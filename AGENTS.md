# AGENTS.md

## Cursor Cloud specific instructions

### Overview

This is a **documentation + shell scripts** repository ("Bradys-files") for setting up Chrome Remote Desktop on macOS to access ChatGPT and Claude web interfaces. There is no application code, no package manager, no build system, no CI/CD, and no automated test suite.

### Repository contents

- `scripts/setup-mac-host.sh` — One-time macOS host configuration (power management, auto-launch)
- `scripts/launch-ai-desktop.sh` — Opens ChatGPT and Claude in a browser
- `docs/` — SOP, test plan, security checklist, ChatGPT vs Claude parity notes
- `README-REMOTE-DESKTOP.md` — Quick-start guide

### Linting

- **Shell scripts:** `shellcheck scripts/*.sh` (info-level suggestions are expected; no warnings/errors at `--severity=warning`)
- **Markdown:** `markdownlint README-REMOTE-DESKTOP.md docs/*.md` (pre-existing stylistic warnings for line-length and table formatting are expected)

### Running scripts

Both scripts are designed for **macOS only**. On Linux (Cloud Agent VMs), they will exit early with informative errors about missing macOS prerequisites (Chrome, Safari, etc.). This is expected behavior — use `bash -n` for syntax validation and `shellcheck` for lint.

### No dependencies

There are no `package.json`, `requirements.txt`, or other dependency files. The update script installs `shellcheck` (via apt) for shell linting — no other dependencies are needed.
