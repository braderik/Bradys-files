# Financial Automation Agent Architecture

> **Status:** Draft architecture for personal automation. This is not financial, legal, tax, or investment advice. Treat every money-moving or trading workflow as high risk and require explicit approval before execution.

## Overview

Build a human-in-the-loop agent that can run weekly banking and investment operations on command. The agent reviews account state, applies rules, proposes actions, waits for approval, then executes only the approved transfers, ETF purchases, and related financial operations.

**Design principles:** Every transaction requires explicit approval. All actions are audit-logged. Credentials never leave the host. LLM output is advisory and must pass deterministic validation before any execution adapter runs.

## System Diagram

```text
┌─────────────────────────────────────────────────────────┐
│                    ORCHESTRATOR                          │
│              (n8n on Hetzner VPS)                        │
│                                                          │
│  ┌──────────┐   ┌──────────────┐   ┌──────────────────┐ │
│  │Scheduler │──▶│ Agent Script │──▶│ Approval Gateway │ │
│  │(cron)    │   │ (Claude API) │   │ (Slack/SMS/Push) │ │
│  └──────────┘   └──────┬───────┘   └────────┬─────────┘ │
│                         │                     │           │
│              ┌──────────▼──────────┐          │           │
│              │   Decision Engine   │◀─────────┘           │
│              │  (rules + AI eval)  │                      │
│              └──────────┬──────────┘                      │
│                         │                                 │
│         ┌───────────────┼───────────────┐                 │
│         ▼               ▼               ▼                 │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐          │
│  │  Banking   │  │ Brokerage  │  │  Audit Log │          │
│  │  Adapter   │  │  Adapter   │  │ (Supabase) │          │
│  └─────┬──────┘  └─────┬──────┘  └────────────┘          │
│        │               │                                 │
│        │  ┌────────────▼────────────┐                    │
│        │  │ Browser Adapter          │                    │
│        │  │ (Playwright + Bitwarden) │                    │
│        │  └────────────┬────────────┘                    │
└────────┼───────────────┼─────────────────────────────────┘
         │               │
         ▼               ▼
   ┌──────────┐     ┌──────────┐
   │Teller.io │     │ E*TRADE  │
   │   API    │     │   API    │
   └──────────┘     └──────────┘
         │               │
         └──────┬────────┘
                ▼
          ┌──────────┐
          │ Bank UI  │
          │Fallbacks │
          └──────────┘
```

## Components

### 1. Orchestrator — n8n on Hetzner VPS

Use the existing n8n deployment on the Hetzner VPS as the workflow host. n8n owns scheduling, branching, retries, approval webhooks, notifications, and high-level run state.

**Why n8n over a raw script:** built-in cron, error handling, retry logic, credential vault, Slack/email nodes, webhook triggers, and a visual run history. It is already deployed and connected through Tailscale.

| Workflow | Trigger | Description |
| --- | --- | --- |
| `weekly-finance-review` | Cron, Sunday 9:00 AM CT | Pull balances, generate a plan, send approval request. |
| `execute-approved-actions` | Approval callback webhook | Execute only the approved transfer/trade bundle. |
| `ad-hoc-invest` | Manual n8n run or Slack command | Propose an on-demand ETF buy, transfer, or cash sweep. |

### 2. Data Ingestion Layer

#### Banking — Teller.io

Use Teller.io as the primary read-only banking data source:

- Checking and savings balance snapshots.
- Recent transaction pulls with deduplication against the previous run.
- Account identity and account IDs for policy matching.

Teller should remain **read-only** in this architecture. Use it for balances and transactions, not for initiating ACH movement. For moving money into brokerage, prefer an ACH pull initiated by the brokerage API.

#### Brokerage — E*TRADE API

Use E*TRADE as the brokerage adapter if keeping the existing brokerage relationship. The adapter should support:

- Account balances: `GET /v1/accounts/{accountIdKey}/balance`.
- Portfolio holdings: `GET /v1/accounts/{accountIdKey}/portfolio`.
- Order preview: `POST /v1/accounts/{accountIdKey}/orders/preview`.
- Order placement: `POST /v1/accounts/{accountIdKey}/orders/place`.

**Auth flow:** OAuth 1.0a with consumer key/secret and access token. Because E*TRADE token lifetime and re-authorization can be operationally painful, isolate auth refresh in a dedicated workflow and fail closed when credentials are stale.

**Alternative:** If E*TRADE auth becomes too brittle, use Alpaca for API-first ETF execution. Alpaca has a modern REST API, paper-trading sandbox, and fractional-share support, but it may require opening or funding a separate brokerage account.

### 3. Agent Script / Decision Engine

The decision engine can run as either:

1. A Claude API call embedded in an n8n Code node.
2. A standalone script on the VPS invoked by n8n.

The standalone script is preferable once execution exists because it is easier to test, version, and run with restricted filesystem permissions.

#### Input Context Per Run

```json
{
  "checking_balance": 8420.00,
  "savings_balance": 15200.00,
  "brokerage_cash": 3100.00,
  "portfolio_holdings": [
    { "symbol": "SGOV", "shares": 150, "value": 15045.00 },
    { "symbol": "VTI", "shares": 42, "value": 11340.00 }
  ],
  "pending_bills": [],
  "rules": {},
  "last_run_actions": []
}
```

#### Rules Engine

Store configurable rules in a version-controlled JSON file on the VPS for v1. Move to a Supabase table later only if a web-editable rules UI becomes useful.

| Rule | Logic | Example |
| --- | --- | --- |
| Sweep excess checking | If checking is above threshold, propose transfer of the delta to savings or brokerage. | Checking > $5,000 → sweep excess to brokerage. |
| Weekly DCA | Allocate fixed dollars to target ETFs by weight. | $200/week: 60% VTI, 30% VXUS, 10% BND. |
| Rebalance check | If any holding drifts beyond threshold, flag a proposal for review. | VTI at 70% vs 60% target → flag rebalance. |
| Emergency floor | Block outbound actions if checking is below a minimum. | Checking < $2,000 → halt all outbound actions. |
| Tax-loss harvest | Flag lots with unrealized losses beyond threshold. | VXUS lot down > $500 → propose human tax review. |

**Claude's role:** Given account state and rules, output a structured action plan. Claude must not execute, authenticate, click, or call bank/broker APIs directly.

```json
{
  "proposed_actions": [
    {
      "type": "transfer",
      "from": "checking_***1234",
      "to": "brokerage_***5678",
      "amount": 3420.00,
      "reason": "Sweep: checking at $8,420, floor is $5,000"
    },
    {
      "type": "buy",
      "symbol": "VTI",
      "amount_usd": 120.00,
      "order_type": "limit",
      "reason": "Weekly DCA: 60% of $200 allocation"
    }
  ],
  "blocked_actions": [],
  "warnings": ["Brokerage cash will be near $0 after DCA; next sweep replenishes Friday"]
}
```

The script validates this JSON against a schema, normalizes account aliases, calculates a proposal hash, then passes the proposal to the approval gateway.

### 4. Approval Gateway

No action executes without explicit human approval.

**Approval flow:**

1. Agent generates a proposal.
2. n8n formats a summary with exact amounts, accounts, symbols, and post-action balances.
3. Summary is sent by Slack DM, with SMS or Pushover as optional fallback.
4. Message includes `Approve All`, `Edit`, and `Reject` actions.
5. Approve calls the `execute-approved-actions` webhook with a single-use token and proposal hash.
6. Edit opens an n8n form or a small internal web page to modify amounts, then creates a new proposal hash.
7. Approval expires after 4 hours. Expired approvals cannot execute.

**Slack message example:**

```text
📊 Weekly Finance Review — Sun May 10

PROPOSED ACTIONS:
1. Transfer $3,420 → Brokerage (sweep excess checking)
2. Buy $120 VTI (weekly DCA)
3. Buy $60 VXUS (weekly DCA)
4. Buy $20 BND (weekly DCA)

Checking after: $5,000 | Brokerage cash after: $0
⚠️ Next sweep replenishes brokerage Friday

[✅ Approve All]  [✏️ Edit]  [❌ Reject]
```

### 5. Execution Layer

Execution adapters translate approved actions into API calls or controlled browser workflows. Every adapter must re-fetch live account state immediately before execution, validate the action against rules, write audit entries, and return a normalized result.

#### Banking Adapter

Use Teller for read-only data. For transfers, prefer brokerage-initiated ACH pulls where supported by E*TRADE or Alpaca. If a future banking API supports transfer initiation, add it behind the same approval and policy gates.

Example normalized transfer request:

```json
{
  "type": "transfer",
  "from_account_id": "acc_xxx",
  "to_account_id": "brokerage_ach_yyy",
  "amount": "3420.00",
  "proposal_hash": "sha256:...",
  "idempotency_key": "run_..._transfer_1"
}
```

#### Brokerage Adapter — E*TRADE

Use a two-step preview-then-place workflow:

```text
POST /v1/accounts/{id}/orders/preview  → validate estimated order details
POST /v1/accounts/{id}/orders/place    → place only if preview matches approved action
```

Execution rules:

- Preview every order immediately before placement.
- Use limit orders by default; market orders require a separate rule override.
- Block symbols not present in the ETF allowlist.
- Block order amount above weekly and per-order caps.
- Include a client order ID or idempotency key when supported.
- Poll status after placement and record the final state.

#### Browser Automation Adapter — Playwright + Bitwarden

Use browser automation only as a fallback for operations without a safe API path, such as specific internal bank transfers, bill-pay portals, or actions that require a bank UI.

**Important constraint:** browser automation must not become an unrestricted autonomous banking robot. For high-risk actions such as wires, require either manual final confirmation in the bank UI or an additional high-value approval challenge before clicking the final confirmation button.

**Auth flow:**

```text
Bitwarden CLI → unlock vault for workflow duration → lookup item → inject credentials → fetch TOTP when needed → lock vault
```

```bash
# Unlock vault for the workflow duration only.
export BW_SESSION=$(bw unlock --passwordenv BW_MASTER --raw)

# Fetch bank credentials.
BANK_CREDS=$(bw get item "PNC Online Banking" --session "$BW_SESSION")
USERNAME=$(echo "$BANK_CREDS" | jq -r '.login.username')
PASSWORD=$(echo "$BANK_CREDS" | jq -r '.login.password')
TOTP=$(bw get totp "PNC Online Banking" --session "$BW_SESSION")
```

**Playwright transfer script outline:**

```python
from playwright.async_api import async_playwright

async def execute_transfer(params: dict):
    """
    params: {
      "bw_item": "PNC Online Banking",
      "from_account_label": "Performance Select Checking",
      "to_account_label": "E*TRADE Brokerage",
      "amount": 3420.00,
      "run_id": "uuid",
      "proposal_hash": "sha256:..."
    }
    """
    creds = get_bitwarden_creds(params["bw_item"])

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        ctx = await browser.new_context(viewport={"width": 1280, "height": 720})
        page = await ctx.new_page()

        await page.goto("https://example-bank.invalid/login")
        await page.fill("#userId", creds["username"])
        await page.fill("#password", creds["password"])
        await page.click("#login-btn")

        if await page.locator(".mfa-challenge").is_visible():
            totp = get_bitwarden_totp(params["bw_item"])
            await page.fill("#otp-input", totp)
            await page.click("#verify-btn")

        await page.click("text=Transfers & Payments")
        await page.select_option("#from-account", label=params["from_account_label"])
        await page.select_option("#to-account", label=params["to_account_label"])
        await page.fill("#amount", str(params["amount"]))

        await page.screenshot(path=f"/opt/finance-agent/audit/{params['run_id']}_pre_confirm.png")

        # Final confirmation is allowed only after approval hash and high-risk checks pass.
        enforce_final_confirmation_gate(params)
        await page.click("#confirm-transfer-btn")

        await page.wait_for_selector(".confirmation-number")
        confirmation = await page.locator(".confirmation-number").text_content()
        await page.screenshot(path=f"/opt/finance-agent/audit/{params['run_id']}_confirmed.png")

        await browser.close()
        return {"status": "executed", "confirmation": confirmation}
```

**Browser automation safeguards:**

- Capture pre-confirmation and post-confirmation screenshots.
- Pull TOTP from Bitwarden at execution time; do not cache it.
- Lock the Bitwarden vault after every workflow run.
- Run headless Chromium in an isolated Docker container on the VPS.
- Version DOM selectors per bank and fail closed when selectors change.
- Enforce maximum single-action amounts before Playwright launches.
- Abort, screenshot, and alert if any selector fails to resolve quickly.
- Disable browser execution when `FINANCE_AGENT_ENABLED=false`.

**MFA handling strategies:**

| MFA Type | Strategy |
| --- | --- |
| TOTP | Pull current TOTP from Bitwarden. |
| SMS code | Relay prompt to Slack/Pushover and wait for manual input. |
| Push notification | User approves on phone; workflow polls for continuation. |
| Security questions | Prefer not to automate; if unavoidable, store in Bitwarden custom fields and require extra approval. |

**Supported bank operations:**

| Operation | Primary Path | Fallback Path |
| --- | --- | --- |
| Check balance | Teller API | None. |
| Recent transactions | Teller API | None. |
| Internal transfer | Bank-native scheduled transfer or bank UI | Playwright. |
| Wire transfer | Manual bank UI | Playwright only with high-value approval gate. |
| Bill pay | Manual bank UI | Playwright only with high-value approval gate. |
| ACH pull into brokerage | Brokerage API | Manual brokerage UI. |
| ETF buy/sell | E*TRADE or Alpaca API | None. |

### 6. Audit Log — Supabase

Use Supabase/Postgres as the audit store. Keep secrets, full credentials, and full account numbers out of this table.

```sql
create table finance_audit (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null,
  timestamp timestamptz default now(),
  action_type text not null,
  status text not null,
  proposal_hash text,
  idempotency_key text,
  payload jsonb not null,
  response jsonb,
  approved_by text,
  notes text
);

create index finance_audit_run_id_idx on finance_audit (run_id);
create index finance_audit_proposal_hash_idx on finance_audit (proposal_hash);
```

Recommended statuses:

- `proposed`
- `policy_rejected`
- `approved`
- `approval_expired`
- `executing`
- `executed`
- `failed`
- `reconciled`

## Security Model

| Layer | Control |
| --- | --- |
| Credentials | Bitwarden CLI vault; unlock per run and lock after completion. |
| Teller mTLS | Client cert and key stored on VPS with `0600` permissions; avoid printing PEM material in logs. |
| Network | VPS reachable over Tailscale; no public finance execution endpoints. |
| Webhooks | Single-use approval tokens, proposal hashes, TTLs, and HMAC verification where possible. |
| Auth tokens | E*TRADE tokens stored encrypted and rotated or refreshed when expired. |
| Browser sessions | Headless Chromium in Docker; no persistent cookies or shared profiles. |
| MFA | TOTP from Bitwarden; SMS/push requires manual relay or manual approval. |
| Execution | Re-fetch balances and positions before every execution. |
| Approval | Four-hour TTL; edits generate a new proposal hash. |
| Audit | Log every API call, proposal, approval, response, and browser screenshot path. |
| Alerting | Failed execution, selector miss, stale data, or policy rejection triggers Slack alert. |
| Kill switch | `FINANCE_AGENT_ENABLED=false` halts all execution workflows. |

## Credentials & Config

### Teller.io

Teller uses client certificates and access tokens. Store certificate material outside the repository, for example:

```text
/opt/finance-agent/creds/teller/certificate.pem
/opt/finance-agent/creds/teller/private_key.pem
```

Do not commit real app IDs, access tokens, certificate contents, private keys, account IDs, or customer identifiers. Use placeholders in documentation and examples:

```bash
curl https://api.teller.io/accounts \
  --cert /opt/finance-agent/creds/teller/certificate.pem \
  --key /opt/finance-agent/creds/teller/private_key.pem \
  -u "$TELLER_ACCESS_TOKEN:"
```

**n8n integration:** use an HTTP Request node configured with TLS client certificate files stored on disk and pass the Teller access token through n8n credentials or an injected secret.

### E*TRADE / Alpaca

Credential setup is pending the final brokerage choice.

- E*TRADE: store OAuth consumer key/secret and access token in n8n credentials or a VPS secret store.
- Alpaca: store API key/secret separately for paper and live trading; make paper mode the default.

### Supabase

Use the existing Supabase integration for audit logging. Store only action payloads, normalized responses, hashes, and screenshot paths. Do not store raw secrets.

## Implementation Phases

### Phase 1 — Read-Only Dashboard (1–2 days)

- n8n workflow: Teller balance pull and brokerage portfolio pull.
- Weekly cron sends Slack summary of balances, holdings, and performance.
- Supabase audit table setup.
- No execution capability.

### Phase 2 — Proposal Engine (2–3 days)

- Claude API integration through an n8n Code node or standalone VPS script.
- Rules config in version-controlled JSON.
- Proposal generation and Slack approval message.
- Approval webhook stub that logs approvals without executing.

### Phase 3 — Brokerage Execution (2–3 days)

- E*TRADE OAuth setup or Alpaca paper trading setup.
- Preview-then-place flow for ETF orders.
- DCA logic, with fractional handling if using Alpaca.
- Order confirmation logging and reconciliation.

### Phase 4 — Banking Transfers / Browser Fallbacks (2–3 days)

- Bitwarden CLI setup on VPS.
- Playwright headless Chromium in Docker.
- Target-bank login and MFA handling script.
- Transfer script with pre/post-confirmation screenshots.
- DOM selector registry and selector-miss alerting.
- Balance re-validation before execution.

### Phase 5 — Advanced Rules (ongoing)

- Rebalance detection and proposals.
- Tax-loss-harvesting flags for human review.
- Dividend reinvestment tracking.
- Monthly performance report by email or Slack.

## Tech Stack Summary

| Component | Tool | Why |
| --- | --- | --- |
| Orchestrator | n8n on Hetzner VPS | Already deployed; visual workflows, cron, credential vault, webhooks. |
| AI Engine | Claude API | Structured output, rule interpretation, natural-language summaries. |
| Banking API | Teller.io | Existing integration for checking/savings balances and transactions. |
| Brokerage API | E*TRADE API or Alpaca | ETF trades and brokerage-initiated ACH pull support. |
| Browser Automation | Playwright with headless Chromium | Fallback for bank operations without a safe API path. |
| Credential Vault | Bitwarden CLI | Runtime credential and TOTP access with vault locking. |
| Approval UX | Slack interactive messages | Buttons, webhooks, and existing operational channel. |
| Audit Store | Supabase | Existing Postgres-backed audit and query layer. |
| Networking | Tailscale | Private mesh access; avoid public execution endpoints. |
| Notifications | Slack plus Pushover fallback | Redundant alerting for approvals and failures. |

## Open Decisions

1. **E*TRADE vs Alpaca:** E*TRADE keeps the current brokerage, but auth may be brittle. Alpaca is easier for automation and paper trading, but may require funding a new account.
2. **Rules storage:** JSON on VPS for v1, then Supabase when a UI is needed.
3. **Approval channel:** Slack alone, or Slack plus SMS/Pushover for high-value actions.
4. **Scheduling granularity:** Weekly sweep and DCA only, or intra-week triggers when balances cross thresholds.
5. **On-command scope:** Slack slash command such as `/invest 500 VTI`, or manual ad-hoc runs in n8n.
6. **Browser fallback limits:** Which operations, if any, can be fully automated after approval versus requiring manual final confirmation.

## References Checked for This Draft

- Teller documentation: confirms accounts, balances, transactions, sandbox mode, and authentication patterns.
- E*TRADE developer documentation: confirms account, portfolio, order preview, order placement, and OAuth documentation areas.
- n8n documentation: confirms Slack credentials and webhook-based workflow patterns.

Re-check provider documentation before implementation because financial API capabilities, account eligibility, OAuth scopes, token lifetimes, and trading rules change over time.
