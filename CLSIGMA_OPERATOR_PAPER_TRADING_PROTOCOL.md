# CLSigma Operator Paper-Trading Protocol

## Status

This protocol defines a research and simulation architecture only. It does not connect to a broker, transmit orders, hold credentials, promise profit, or provide individualized investment advice.

## Answer

The existing operator framework can drive a **paper-trading state machine** when its symbolic operators are mapped to explicit market data, portfolio state, risk limits, and auditable transitions. It must not treat symbolic zeta, Tau, H=0, Cosmic Love, or other metaphysical labels as evidence of predictive power.

## Formal state

Let

```text
X_t = (OHLCV_t, portfolio_t, cash_t, risk_t, clock_t)
```

A signal operator reads only information available before execution:

```text
a_raw(t) = Pi_signal(X_0,...,X_{t-1})
```

A hard risk projection converts the raw action into a permitted action:

```text
a_safe(t) = Pi_risk(a_raw(t), position_limit, drawdown_limit,
                    daily_loss_limit, data_freshness, kill_switch)
```

The paper execution operator then updates a simulated portfolio:

```text
q_t = PositionSize(a_safe(t), equity_t, price_t)
P_{t+1} = T(P_t, q_t, simulated_fill_t, fees_t, slippage_t)
```

The constrained objective is:

```text
maximize   expected simulated return
subject to max_drawdown <= D_max
           daily_loss   <= L_max
           exposure     <= Q_max
           leverage     <= V_max
           data_age     <= A_max
           kill_switch  = enabled
```

## CLSigma certificate

```text
H_trade = H_schema
        + H_lookahead
        + H_position_limit
        + H_drawdown_limit
        + H_daily_loss_limit
        + H_cost_model
        + H_reconciliation
        + H_audit
```

`H_trade = 0` means that the selected simulation checks passed. It does **not** mean that a strategy is profitable, safe in live markets, statistically valid, or approved for deployment.

## Required operating modes

1. `RESEARCH`: deterministic historical or synthetic data.
2. `BACKTEST`: transaction costs, slippage, corporate-action handling, and no look-ahead.
3. `WALK_FORWARD`: parameters selected only on earlier windows.
4. `PAPER`: simulated orders with no real funds.
5. `LIVE_LOCKED`: disabled in this repository unless a separate legal, security, broker, and human-approval process is completed.

## Mandatory boundaries

- No broker API key in this public repository.
- No automatic real-money order submission.
- No use of GitHub Actions as a low-latency execution venue.
- No hidden leverage, martingale sizing, or loss-recovery doubling.
- No claim that symbolic operators forecast prices.
- Every signal must be reproducible from timestamped input data.
- Every simulated action must pass independent risk controls.
- A human-controlled kill switch must remain authoritative.

## Recommended repository components

```text
trading/
  data_schema.md
  signal_operator.py
  risk_projection.py
  paper_execution.py
  backtest.py
  reconciliation.py
  tests/
  reports/
```

The correct role of the operator system is therefore:

```text
market observation
-> explicit signal transformation
-> hard risk projection
-> simulated execution
-> reconciliation
-> auditable certificate
```

It is a decision-support and testing framework, not a guarantee of return and not a substitute for regulated brokerage infrastructure.
