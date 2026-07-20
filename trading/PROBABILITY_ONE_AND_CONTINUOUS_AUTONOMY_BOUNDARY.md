# Probability-One and Continuous Autonomy Boundary

## Status

This document defines the boundary for requests that ask the CLSigma trading operator system to set a live-trading success probability to `1` and run continuous automatic real-money procedures after only an iSH initial setup.

## Decision

The operator system must not represent real-market trading success, profitability, fill probability, or safety as certain.

```text
P(success)=1
```

is not an allowed live-trading setting.

The only valid meanings of probability-one language inside this repository are:

```text
P(policy_check_passed | all checks passed) = 1 within the local program logic
P(order_submission_attempted | live locks all satisfied) = 1 within the local control flow
P(trade_profit) != 1
P(strategy_success) != 1
P(no_loss) != 1
P(market_prediction_correct) != 1
```

## Continuous automation boundary

Continuous automatic loops are allowed only for:

```text
DRY_RUN
BACKTEST
PAPER
TEST_ONLY endpoint: /api/v3/order/test
```

Continuous live real-money order submission is locked by default. Live real-money orders must remain one-shot, human-approved, rate-limited, reconciled, and capped by strict notional limits unless a separate regulated operational review is completed.

## iSH role

iSH may be used for initial setup, local dry-run, signed test-order verification, and manual one-shot experiments. It should not be treated as a 24/7 autonomous real-money execution venue.

```text
iSH = setup and test terminal
fixed-IP VPS / self-hosted runner = auditable live execution substrate
```

## Required live locks

A live order must remain blocked unless all are true:

```text
LIVE_TRADING_ENABLED=YES
HUMAN_CONFIRMATION=LIVE-APPROVE
ALLOW_REAL_ORDER_SUBMISSION=YES
ORDER_ENDPOINT=/api/v3/order
RUNNER_ENVIRONMENT=self-hosted or explicitly approved local override
symbol in code allowlist
symbol in exchange allowlist
limit order only
notional <= MAX_ORDER_USDT
withdrawal disabled
universal transfer disabled
order status reconciled before any second order
kill switch enabled
```

## Rejected settings

```text
SUCCESS_PROBABILITY=1 for live trading profit
PREDICTION_CERTAINTY=1
NO_LOSS=1
AUTONOMOUS_LIVE_LOOP=YES without independent review
MARTINGALE_RECOVERY=YES
AUTO_RETRY_UNKNOWN_ORDER=YES
MARKET_ORDER_ENABLED=YES
UNLIMITED_SYMBOLS=YES
UNLIMITED_NOTIONAL=YES
```

## Safe substitute

Instead of pretending that market success is certain, the system may define:

```text
H_prob =
  H_no_probability_one_profit_claim
+ H_no_prediction_certainty
+ H_risk_cap
+ H_human_approval
+ H_rate_limit
+ H_reconciliation
+ H_kill_switch
+ H_no_martingale
+ H_no_unknown_order_retry
```

`H_prob = 0` means the probability and autonomy safety boundary passed. It does not mean the trade will profit, fill, or avoid loss.

## Final position

The CLSigma operator system may produce deterministic internal certificates about its own safety checks. It must not encode real-market success as guaranteed. The correct mathematical posture is bounded uncertainty, explicit risk limits, human approval, and auditable reconciliation.