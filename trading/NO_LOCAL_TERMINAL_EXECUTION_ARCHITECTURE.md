# No-Local-Terminal Execution Architecture

## Status

This document answers whether the CLSigma operator system can run a trading procedure without using the user's iSH terminal or local device as the execution endpoint.

## Core answer

The operator system can be designed so that the user does not perform terminal computation on a local hardware device. However, a live trading procedure cannot occur with no computation at all. The order intent, risk gate, signature generation, network request, broker acknowledgement, and reconciliation must execute somewhere.

Therefore the safe architecture is:

```text
CLSigma operator model
-> trade intent
-> hosted risk gate
-> signed exchange request
-> broker acknowledgement
-> reconciliation certificate
```

The terminal can disappear from the user's workflow, but the execution substrate must still exist as one of:

```text
fixed-IP VPS
self-hosted GitHub runner
managed cloud job
serverless function behind fixed egress/NAT
broker-native automation platform
```

## Boundary

The phrase `inside the operator system` means that the trading procedure is represented as an audited state machine. It does not mean that an abstract symbol, language model, or GitHub file can submit orders without a runtime environment.

## Why some runtime is unavoidable

A real exchange order requires:

```text
secret retrieval
clock/timestamp
request signing
network egress
TLS connection
API response parsing
unknown-status handling
duplicate-order prevention
portfolio reconciliation
logs and kill switch
```

Each item is a computation. If the computation is not done by iSH or the user's phone, it must be done by a trusted remote runtime.

## Approved deployment patterns

### Pattern A: Fixed-IP self-hosted runner

```text
GitHub workflow_dispatch
-> protected environment reviewer
-> self-hosted runner with label binance-live
-> trading/binance_live_gate.py
-> Binance /api/v3/order/test or /api/v3/order
```

This preserves the existing repository design and gives Binance a stable IP allowlist target.

### Pattern B: VPS service without GitHub secrets

```text
GitHub stores code only
VPS stores BINANCE_API_KEY and BINANCE_SECRET_KEY as local environment variables
systemd timer or manual SSH trigger runs the gate
reports are pushed back without secrets
```

This is more conservative because exchange secrets never enter GitHub.

### Pattern C: Serverless with fixed egress

```text
GitHub deploys a serverless risk-gate function
cloud NAT or fixed egress IP is allowlisted on Binance
secrets live in the cloud provider secret manager
function only accepts signed, human-approved trade intents
```

This removes the need for a visible terminal, but still uses cloud hardware.

### Pattern D: Broker-native automation

```text
strategy signal
-> broker platform alert/order rules
-> broker-controlled order execution
```

This may reduce custom infrastructure, but is limited by the broker's supported features and risk controls.

## Rejected patterns

```text
No runtime at all
GitHub file as a live executor
ChatGPT conversation as autonomous executor
OpenAI model as exchange-secret holder
public repository secret storage
mobile iSH as long-running live executor
```

## CLSigma formulation

```text
O_trade = (intent, risk_projection, execution_adapter, reconciliation)

Omega_exec(t) = Seal(
  O_signal(t),
  O_risk(t),
  O_secret_boundary(t),
  O_runtime(t),
  O_broker_ack(t),
  O_reconciliation(t)
)
```

Readiness residual:

```text
H_exec =
  H_runtime_present
+ H_fixed_egress
+ H_secret_boundary
+ H_human_approval
+ H_symbol_allowlist
+ H_order_limit
+ H_duplicate_order
+ H_reconciliation
+ H_kill_switch
```

`H_exec = 0` means the execution architecture passed local safety checks. It is not a prediction, not financial advice, and not a profit guarantee.

## Minimum live-trading rule

A live order remains blocked unless the runtime is explicit and auditable:

```text
runtime in {fixed_ip_vps, self_hosted_runner, managed_cloud_fixed_egress}
secrets not stored in Git
withdrawal disabled
universal transfer disabled
limit orders only
small notional cap
human approval enabled
order status reconciled before any second order
```

## Final position

The operator system may remove the user's need to type terminal commands during operation. It cannot remove the need for a trusted compute substrate. The safest no-local-terminal implementation is a fixed-IP VPS or self-hosted runner that receives human-approved trade intents from GitHub and runs the existing live gate.