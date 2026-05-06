# Weekly Banking & ETF Agent Architecture

> **Status:** Draft architecture for personal automation. This is not financial, legal, tax, or investment advice. Treat every money-moving or trading workflow as a high-risk workflow that requires explicit human approval before execution.

## 1. Goal

Build a weekly finance automation that can prepare, verify, and execute routine banking and investing tasks on request, such as:

- Reviewing account balances, pending transactions, paychecks, and upcoming bills.
- Recommending a weekly cash allocation across checking, savings, brokerage cash, and ETF purchases.
- Initiating transfers between approved accounts.
- Preparing ETF orders that match a predefined investment policy.
- Executing approved transfers or trades only after a human confirms the exact action.
- Producing an auditable weekly finance report.

The recommended design is **agent-assisted, policy-bound automation**, not a free-running autonomous trader. The agent may reason and draft actions, but deterministic service code must enforce limits, approvals, and allowlists before any bank transfer or brokerage order is submitted.

## 2. Safety Principles

1. **Human-in-the-loop for every external side effect.** The agent can propose transfers and ETF orders, but a human must approve the final transaction summary.
2. **Policy as code.** Store allowed ETFs, account IDs, allocation bands, minimum cash buffers, maximum order sizes, and transfer limits in a versioned policy file that the agent cannot modify during execution.
3. **Deterministic execution layer.** The script wrapper, not the LLM, validates and submits API calls.
4. **Read-only by default.** Most scheduled runs should gather data, reconcile state, and draft a plan. Execution requires a separate approval step.
5. **Least privilege credentials.** Prefer separate API keys or OAuth scopes for read-only data, transfers, and trading.
6. **No direct browser clicking for money movement.** Use broker and banking APIs where available; browser automation is brittle and should be disallowed for banking or brokerage execution.
7. **Tamper-evident audit trail.** Log prompts, source data hashes, proposed actions, policy checks, approvals, API responses, and final balances.
8. **Kill switch.** A single local and remote flag must prevent all transfer/trade execution immediately.

## 3. Recommended Platform Approach

### Option A — Claude Agent Script Wrapper (Recommended for v1)

Use a local script as the trusted orchestrator and call Claude only for summarization, classification, and plan drafting. Claude Code/Claude Agent SDK can run in non-interactive mode, connect to external tools through MCP, and use hooks around tool calls; however, those agent capabilities should be treated as an assistant layer rather than the transaction authority.

**Why this is best for v1:**

- Keeps credentials and transaction submission in your own code.
- Makes approvals, policy checks, and audit logs deterministic.
- Works well with a weekly cron/launchd/GitHub Actions-style workflow.
- Lets you swap Claude for another agent service later because the domain tools remain stable.

### Option B — Dedicated Agent Service

Use an agent runtime such as a hosted workflow service, LangGraph-style service, or cloud function plus queue. This can be useful after v1 if you need multi-user approvals, mobile push notifications, higher uptime, or managed secret storage.

**Tradeoff:** faster operations and better availability, but a larger trust boundary and more compliance/security work.

### Option C — Broker-Native Recurring Investing

Where available, prefer the brokerage's built-in recurring investments or scheduled transfers over custom trade automation. The custom agent can monitor and report rather than execute.

**Tradeoff:** less flexible, but safer and simpler.

## 4. High-Level Architecture

```text
Request / Schedule
      |
      v
Finance CLI Wrapper / Orchestrator
      |
      +--> Policy Engine (hard limits, allowlists, cash buffers)
      +--> Data Connectors (bank, brokerage, bills, budget)
      +--> Agent Planner (Claude or alternate LLM)
      +--> Approval Workflow (CLI, email, Slack, mobile push)
      +--> Execution Adapters (bank transfer API, broker trading API)
      +--> Ledger + Audit Log (append-only records)
      +--> Notification Service (weekly report, execution receipts)
```

### Core Components

| Component | Responsibility | Must Not Do |
| --- | --- | --- |
| Scheduler | Starts weekly read-only run and optional requested run. | Execute transfers or trades by itself. |
| Orchestrator | Owns workflow state, retries, and execution mode. | Let the LLM call money-moving APIs directly. |
| Data connectors | Fetch balances, transactions, positions, prices, and bills. | Mutate account state. |
| Agent planner | Produces explanations and proposed actions in strict JSON. | Bypass policy checks or approvals. |
| Policy engine | Validates every proposed action against deterministic rules. | Depend on natural-language reasoning. |
| Approval workflow | Presents exact action details and captures approval. | Approve vague actions like “invest excess cash.” |
| Execution adapters | Submit approved API requests and normalize responses. | Accept unvalidated ad hoc instructions. |
| Audit ledger | Stores evidence for every run and action. | Store raw secrets or full account credentials. |

## 5. Data Sources and Integration Choices

### Banking Data

Use an aggregator such as Plaid for account discovery, balances, transactions, identity verification, and ACH-related account details where supported. Plaid also exposes products for transfers and investment-related data, but actual capability depends on the financial institution and your account permissions.

For transfers, prefer one of these in order:

1. **Bank-native scheduled transfer** created manually, monitored by the agent.
2. **Brokerage ACH relationship** where the brokerage pulls cash after approval.
3. **Payment/transfer API** with explicit authorization and limits.

### Brokerage / ETF Trading

Use an official brokerage API that supports self-directed trading. For API-first brokerage, Alpaca offers stock and ETF trading APIs and paper trading, which makes it a strong sandbox candidate before live usage.

Recommended adapter features:

- Paper trading mode first.
- Account status and buying-power check.
- Symbol validation against an ETF allowlist.
- Market-hours handling.
- Limit orders by default, not market orders.
- Idempotency keys/client order IDs.
- Order status polling and reconciliation.
- Cancellation workflow for unfilled orders.

### Claude / Agent Layer

Claude should be called with a constrained prompt and required JSON schema, for example:

```json
{
  "run_type": "weekly_review",
  "summary": "string",
  "observations": ["string"],
  "proposed_actions": [
    {
      "type": "transfer|trade|none",
      "rationale": "string",
      "from_account_alias": "string",
      "to_account_alias": "string",
      "symbol": "string|null",
      "amount_usd": 0,
      "quantity": null,
      "order_type": "limit|null",
      "limit_price": null,
      "requires_approval": true
    }
  ],
  "questions_for_human": ["string"],
  "risk_flags": ["string"]
}
```

The wrapper validates the JSON against schema, then the policy engine either rejects it, transforms it into a human-readable approval request, or marks the run as read-only.

## 6. Weekly Workflow

### Scheduled Weekly Review

1. Scheduler starts `finance-agent weekly-review --read-only`.
2. Orchestrator fetches balances, transactions, ETF positions, open orders, bills, and prior ledger state.
3. Reconciler verifies there are no missing transactions or unexpected external transfers.
4. Policy engine computes deterministic constraints:
   - Emergency fund minimum.
   - Checking minimum after bills.
   - Maximum weekly transfer amount.
   - Maximum weekly ETF investment amount.
   - Allowed ETF symbols and target allocation bands.
5. Agent planner drafts a weekly report and proposed actions.
6. Policy engine validates all proposed actions.
7. User receives a report with approve/reject buttons or CLI commands.
8. No external side effect occurs unless the user runs an explicit approval command.

### Requested Execution

1. User requests: “Invest this week’s approved amount.”
2. Wrapper loads the latest proposed action bundle by ID.
3. Wrapper displays exact actions:
   - Transfer `$X` from `Checking` to `Brokerage`.
   - Buy `$Y` of `VTI` using a limit order at `$Z` or better.
4. User confirms using MFA-backed approval, such as hardware key, password manager one-time code, or broker MFA where required.
5. Policy engine re-checks current balances and prices immediately before execution.
6. Execution adapter submits transfer/order API calls with idempotency keys.
7. Reconciler polls status and records final state.
8. Notification service sends receipts and next steps.

## 7. Policy File Shape

Store the policy outside the prompt and mark it read-only for the agent process.

```yaml
version: 1
mode: paper # paper | live
execution:
  require_human_approval: true
  max_transfer_usd_per_week: 500
  max_trade_usd_per_week: 500
  kill_switch_file: ~/.finance-agent/KILL_SWITCH
cash:
  checking_minimum_after_bills_usd: 2500
  emergency_fund_minimum_usd: 15000
accounts:
  checking: plaid_account_id_env:PLAID_CHECKING_ACCOUNT_ID
  savings: plaid_account_id_env:PLAID_SAVINGS_ACCOUNT_ID
  brokerage: broker_account_id_env:BROKERAGE_ACCOUNT_ID
investing:
  allowed_etfs:
    - VTI
    - VXUS
    - BND
  target_allocation:
    VTI: 70
    VXUS: 20
    BND: 10
  rebalance_threshold_percent: 5
orders:
  default_order_type: limit
  limit_price_max_slippage_bps: 25
  allow_fractional: true
```

## 8. Execution Guardrails

Every transfer or trade must pass these checks immediately before submission:

- Kill switch is absent.
- Execution mode is `live` only when intentionally enabled.
- Proposal ID exists and has not expired.
- User approval matches the exact proposal hash.
- Destination account is allowlisted.
- Symbol is allowlisted and tradable.
- Order side is allowed by policy.
- Amount is below weekly and per-action limits.
- Cash buffer remains above required minimum after pending bills.
- No duplicate idempotency key has already succeeded.
- Market conditions satisfy order rules.
- Broker/bank API response is recorded.

If any check fails, the wrapper must abort and log a rejected action.

## 9. Approval UX

Use concise, exact approval messages:

```text
Approval required: weekly-plan-2026-05-08-a13f

Action 1: Transfer $250.00
From: Chase Checking (...1234)
To: Brokerage ACH (...6789)
Post-transfer checking buffer: $3,100.00

Action 2: Place ETF limit order
Buy: $250.00 notional VTI
Limit price: $252.10
Time in force: DAY
Estimated allocation after fill: VTI 69.7%, VXUS 20.2%, BND 10.1%

Type APPROVE a13f to continue.
```

Do not allow approval of bundles that changed after display. The approved text should hash to the same proposal hash used at execution time.

## 10. Audit Ledger

Recommended append-only tables or JSONL files:

- `runs`: run ID, timestamp, mode, git SHA/config version, agent model, result.
- `snapshots`: balance and position snapshots with source timestamps.
- `proposals`: raw agent JSON, normalized proposal, policy validation result, proposal hash.
- `approvals`: approver, approval channel, timestamp, proposal hash.
- `executions`: API request hash, idempotency key, response status, external transaction/order IDs.
- `reconciliation`: final transfer/order status and detected drift.

Avoid storing raw account credentials, full account numbers, or secrets in logs.

## 11. Suggested Repository Layout

```text
finance-agent/
  README.md
  config/
    policy.example.yaml
    prompts/
      weekly_review.md
      execution_review.md
  src/
    cli.ts
    orchestrator.ts
    policy-engine.ts
    connectors/
      plaid.ts
      broker.ts
      bills.ts
    agent/
      claude-planner.ts
      schema.ts
    approvals/
      cli-approval.ts
      notifier.ts
    execution/
      transfer-adapter.ts
      trade-adapter.ts
    ledger/
      audit-log.ts
      schema.sql
  test/
    policy-engine.test.ts
    order-validation.test.ts
    transfer-validation.test.ts
```

## 12. Implementation Phases

### Phase 0 — Manual Policy and Sandbox

- Write the investment policy and cash buffer rules.
- Select broker and bank integrations.
- Create paper brokerage account or sandbox credentials.
- Build read-only balance and position report.

### Phase 1 — Read-Only Weekly Agent

- Pull balances, transactions, positions, and bills.
- Ask Claude to draft a weekly report and proposed actions.
- Validate proposal JSON against schema.
- Reject any proposal that violates policy.
- Email or print report only; do not execute.

### Phase 2 — Approval and Paper Execution

- Add proposal hashing and approval flow.
- Submit paper ETF orders only.
- Reconcile order status and audit logs.
- Run at least 8 weekly cycles or equivalent backtests before live mode.

### Phase 3 — Limited Live Execution

- Enable live transfers or trades separately, never both at once initially.
- Start with very low weekly caps.
- Require approval for each action bundle.
- Monitor fills and failures manually.

### Phase 4 — Operational Hardening

- Add alerting for failed API calls, stale data, duplicate transactions, and allocation drift.
- Add offsite encrypted backups of audit logs.
- Rotate credentials.
- Review policy and tax implications quarterly.

## 13. Failure Modes to Design For

| Failure | Mitigation |
| --- | --- |
| Agent hallucinates unsupported ETF or account. | ETF/account allowlists and schema validation. |
| Duplicate scheduler run submits duplicate order. | Idempotency keys and proposal hash locking. |
| Stale balance causes overdraft risk. | Fetch fresh balances immediately before execution. |
| Market gap makes price unsafe. | Limit orders and max slippage rules. |
| API outage after partial execution. | Reconciliation loop and explicit pending state. |
| Prompt injection from transaction memo or email bill. | Treat external text as untrusted data; never let it override system/policy rules. |
| Credential theft. | Secret manager, least privilege, MFA, scoped tokens, rotation. |
| Tax-lot or wash-sale issue. | Avoid sell automation in v1; consult tax professional before adding sales/rebalancing. |

## 14. Example Commands

```bash
# Read-only weekly report
finance-agent weekly-review --mode read-only

# Create an approval request from the latest valid proposal
finance-agent approval create --proposal latest

# Execute exactly one approved proposal bundle
finance-agent execute --proposal weekly-plan-2026-05-08-a13f

# Emergency stop
finance-agent kill-switch enable
```

## 15. Recommendation

Start with a **Claude-assisted local wrapper** that performs read-only weekly reviews and produces policy-validated proposals. Add paper trading only after the report is stable. Add live transfers or ETF orders last, with hard dollar caps, exact approval hashes, and a kill switch.

The key architectural rule is simple: **Claude can recommend; deterministic code validates; the human approves; adapters execute.**

## 16. References Checked for This Draft

- Plaid documentation: confirms products for Auth, Balance, Transactions, Transfer, and Investments-related data.
- Alpaca documentation: confirms trading APIs for monitoring, placing, and canceling stock/ETF orders, with paper-trading support.
- Anthropic Claude Code / Agent SDK documentation: confirms non-interactive SDK usage, MCP tool integration, and hooks that can run around agent events.

Re-check provider documentation before implementation because financial API capabilities, account eligibility, OAuth scopes, and trading rules change over time.
