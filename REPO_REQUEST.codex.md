Hand-off file for Codex (PAT edition)

Save as: REPO_REQUEST.codex.md

# GOAL
Create a cloud-hosted orchestration hub that runs a Supervisor agent to plan → code → test → commit → open PR to a target repo, using a **fine-grained GitHub PAT** (no GitHub App). Expose `/github/webhook` for repo-level webhooks. Deploy on {{CLOUD}}.

# INPUTS
GITHUB_OWNER={{GITHUB_OWNER}}
ORCH_REPO={{ORCH_REPO}}
TARGET_REPO={{TARGET_REPO}}
DEFAULT_BASE_BRANCH=main
CLOUD={{CLOUD}}
DOMAIN={{DOMAIN}}

# SECRETS (to be set in cloud env, NOT committed)
OPENAI_API_KEY={{OPENAI_API_KEY}}
GITHUB_TOKEN={{GITHUB_TOKEN}}
GITHUB_WEBHOOK_SECRET={{GITHUB_WEBHOOK_SECRET}}
ANTHROPIC_API_KEY={{ANTHROPIC_API_KEY}}
GEMINI_API_KEY={{GEMINI_API_KEY}}

# REPO: create {{GITHUB_OWNER}}/{{ORCH_REPO}} (private), initialize empty.

# PROJECT STRUCTURE
app/
  __init__.py
  main.py
  agents.py
  github_webhook.py
  tools_git.py
  tools_exec.py
  tools_llm.py
.github/workflows/ci.yml
Dockerfile
requirements.txt
README.md
.env.example

requirements.txt
fastapi
uvicorn[standard]
httpx
pydantic
openai
pyjwt

Dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app app
EXPOSE 8000
CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","8000"]

app/__init__.py
__all__ = []

app/main.py
from fastapi import FastAPI
from .github_webhook import router as gh_router
from .agents import init_supervisor

app = FastAPI(title="Orchestration Hub (PAT)", version="0.1.0")
app.include_router(gh_router)

@app.on_event("startup")
async def startup():
    init_supervisor()

app/agents.py
import os
from typing import Dict
from openai import OpenAI

_client = None

def init_supervisor():
    global _client
    if _client is None:
        _client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

def run_demo_task(goal: str) -> str:
    """
    Simple end-to-end: write files -> run tests -> commit to TARGET_REPO -> open PR (PAT auth).
    """
    from .tools_exec import write_file, run_in_sandbox
    from .tools_git import create_branch_and_commit, open_pr

    files = {
        "cli/app.py": 'print("Hello from Orchestrator")\n',
        "tests/test_app.py": 'def test_ok():\n    assert 2*2==4\n',
        "Makefile": "test:\n\tpytest -q\n",
        "requirements.txt": "pytest\n",
    }
    # author files and test locally (inside container)
    for p, c in files.items():
        write_file(p, c)
    run_in_sandbox("pip install -r requirements.txt")
    run_in_sandbox("pytest -q")

    owner_repo = os.getenv("DEFAULT_TARGET_REPO", "{{GITHUB_OWNER}}/{{TARGET_REPO}}")
    owner, repo = owner_repo.split("/")
    branch = "feat/orchestrator-bootstrap"
    create_branch_and_commit(owner, repo, branch, files, "Bootstrap orchestrator demo")
    pr = open_pr(owner, repo, head=branch, base=os.getenv("DEFAULT_BASE_BRANCH", "main"),
                 title="[orchestrator] bootstrap", body=goal)
    return pr

app/github_webhook.py
import hmac, hashlib, os, json
from fastapi import APIRouter, Request, HTTPException

router = APIRouter()

def verify_sig(body: bytes, sig: str):
    secret = os.environ["GITHUB_WEBHOOK_SECRET"].encode()
    digest = "sha256=" + hmac.new(secret, body, hashlib.sha256).hexdigest()
    if not hmac.compare_digest(digest, sig or ""):
        raise HTTPException(status_code=401, detail="Invalid webhook signature")

@router.post("/github/webhook")
async def webhook(request: Request):
    body = await request.body()
    verify_sig(body, request.headers.get("X-Hub-Signature-256", ""))
    event = request.headers.get("X-GitHub-Event", "")
    payload = json.loads(body.decode())
    # For now, just acknowledge. You can expand to iterate on PR updates, etc.
    return {"ok": True, "event": event}

app/tools_git.py (PAT-only auth)
import os, json, tempfile, subprocess, shlex, httpx

def _token():
    t = os.getenv("GITHUB_TOKEN")
    if not t:
        raise RuntimeError("GITHUB_TOKEN not set")
    return t

def _headers():
    return {"Authorization": f"Bearer {_token()}",
            "Accept": "application/vnd.github+json"}

def create_branch_and_commit(owner: str, repo: str, new_branch: str, files: dict, message: str) -> str:
    with tempfile.TemporaryDirectory() as tmp:
        repo_url = f"https://x-access-token:{_token()}@github.com/{owner}/{repo}.git"
        subprocess.check_call(["git", "clone", "--depth", "1", f"https://github.com/{owner}/{repo}.git", tmp])
        # set auth
        subprocess.check_call(["git", "-C", tmp, "remote", "set-url", "origin", repo_url])
        # base from remote default (assume main)
        subprocess.check_call(["git", "-C", tmp, "checkout", "-b", new_branch])
        for path, content in files.items():
            full = os.path.join(tmp, path)
            os.makedirs(os.path.dirname(full) or ".", exist_ok=True)
            with open(full, "w", encoding="utf-8") as f:
                f.write(content)
        subprocess.check_call(["git", "-C", tmp, "add", "."])
        subprocess.check_call(["git", "-C", tmp, "commit", "-m", message])
        subprocess.check_call(["git", "-C", tmp, "push", "-u", "origin", new_branch])
    return f"PUSHED {owner}/{repo}:{new_branch}"

def open_pr(owner: str, repo: str, head: str, base: str, title: str, body: str = "") -> str:
    url = f"https://api.github.com/repos/{owner}/{repo}/pulls"
    r = httpx.post(url, headers=_headers(),
                   json={"title": title, "head": head, "base": base, "body": body},
                   timeout=60)
    r.raise_for_status()
    data = r.json()
    return json.dumps({"number": data["number"], "html_url": data["html_url"]})

app/tools_exec.py
import json, subprocess, shlex, os

def run_in_sandbox(cmd: str, workdir: str = ".") -> str:
    p = subprocess.run(shlex.split(cmd), cwd=workdir,
                       capture_output=True, text=True, timeout=240)
    return json.dumps({"code": p.returncode,
                       "stdout": p.stdout[-8000:], "stderr": p.stderr[-8000:]})

def write_file(path: str, content: str) -> str:
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    return f"WROTE {path}"

app/tools_llm.py (optional other LLMs)
import httpx, os

def call_claude(system: str, prompt: str) -> str:
    key = os.getenv("ANTHROPIC_API_KEY")
    if not key: return ""
    r = httpx.post(
        "https://api.anthropic.com/v1/messages",
        headers={"x-api-key": key, "anthropic-version": "2023-06-01"},
        json={"model":"claude-3-7-sonnet-2025-xx","max_tokens":3000,"system":system,
              "messages":[{"role":"user","content":prompt}]},
        timeout=120
    ); r.raise_for_status()
    return r.json()["content"][0]["text"]

def call_gemini(system: str, prompt: str) -> str:
    key = os.getenv("GEMINI_API_KEY")
    if not key: return ""
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key={key}"
    r = httpx.post(url, json={"contents":[{"parts":[{"text":f"{system}\n\n{prompt}"}]}]}, timeout=120)
    r.raise_for_status()
    return r.json()["candidates"][0]["content"]["parts"][0]["text"]

.github/workflows/ci.yml
name: CI
on:
  pull_request:
    branches: [ main ]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install -r requirements.txt || true
      - run: echo "No project tests here; this repo hosts the orchestrator service."

.env.example
OPENAI_API_KEY=
GITHUB_TOKEN=
GITHUB_WEBHOOK_SECRET=
DEFAULT_TARGET_REPO={{GITHUB_OWNER}}/{{TARGET_REPO}}
DEFAULT_BASE_BRANCH=main
ANTHROPIC_API_KEY=
GEMINI_API_KEY=

README.md (deploy + configure)
# Orchestration Hub (PAT Edition)

## 1) Configure secrets (in your cloud's env vars)
- OPENAI_API_KEY
- GITHUB_TOKEN (fine-grained PAT with Contents:RW & Pull requests:RW on TARGET_REPO)
- GITHUB_WEBHOOK_SECRET (random string)
- DEFAULT_TARGET_REPO={{GITHUB_OWNER}}/{{TARGET_REPO}}
- DEFAULT_BASE_BRANCH=main
- (optional) ANTHROPIC_API_KEY, GEMINI_API_KEY

## 2) Deploy ({{CLOUD}})
Build & run the Docker image. On Render/Railway/Fly, create a new web service pointing at this repo. Service listens on port 8000.

## 3) Webhook (repo-level)
In the **TARGET_REPO**: Settings → Webhooks → Add webhook
- Payload URL: https://<your-service-domain>/github/webhook
- Content type: application/json
- Secret: (must match GITHUB_WEBHOOK_SECRET)
- Events: Pull requests, Push, Check run (optional)
- Active: ✓

## 4) Smoke test
POST to /github/webhook locally without signature to see 401 (expected).
POST with valid HMAC to get {"ok": true}.

## 5) Try an end-to-end run (manual)
Create a tiny client or REPL in the container:
```python
from app.agents import init_supervisor, run_demo_task
init_supervisor()
print(run_demo_task("Bootstrap PR to TARGET_REPO"))


Expect a new branch + PR on {{GITHUB_OWNER}}/{{TARGET_REPO}}.


---

## What changes because we’re **not** using a GitHub App
- Auth is via **`GITHUB_TOKEN` (PAT)** only—no JWT or installation tokens.
- Webhooks are configured **per repo** (TARGET_REPO → Settings → Webhooks), not at an App level.
- Keep PAT scope tight: **allow-list the target repo(s)** when you generated it, and only **Contents:RW** + **Pull requests:RW**.

---

If you share the placeholder values now (owner, repo names, cloud, and whether you want optional
