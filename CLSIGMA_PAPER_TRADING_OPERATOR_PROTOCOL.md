# CLSigma Paper-Trading Operator Protocol

## Purpose

This protocol adapts the repository's finite operator, timing, provenance, and governance ideas to **research-only algorithmic trading**.

It is designed for:

```text
historical backtesting
paper trading
risk-control experiments
reproducible strategy certificates
```

It is **not** a profit guarantee, investment recommendation, broker, exchange, or live-order system.

## Scope boundary

The reference runtime:

```text
performs no network request
contains no broker API
contains no credentials
places no real order
uses no leverage
uses no short borrowing
changes no external account
```

A later live-trading adapter must remain outside the reference runtime and must undergo independent legal, security, operational, and financial review.

## Market-state operator

For each bar `t`, define:

```text
X_t = (
  price_t,
  return_t,
  fast_mean_t,
  slow_mean_t,
  volatility_t,
  equity_t,
  drawdown_t
)
```

The signal operator is:

```text
S_t = sign(fast_mean_t - slow_mean_t)
```

with `S_t in {-1, 0, +1}`.

To avoid look-ahead bias, the runtime computes the signal using data available strictly before the execution bar.

## Risk projection operator

A raw strategy action must be projected into the feasible risk set:

```text
a_t_raw = S_t

a_t = P_R(a_t_raw)
```

where `P_R` enforces:

```text
absolute exposure <= max_exposure
volatility <= volatility_gate
portfolio drawdown < kill_drawdown
finite prices and returns
transaction costs included
```

The reference runtime uses a long/flat policy even though the symbolic signal may be negative:

```text
S_t <= 0  -> position_t = 0
S_t > 0   -> position_t = target_exposure
```

This avoids borrowing and short-selling assumptions in the educational model.

## Equity transition

Let `p_t` be the execution price and `q_t` the projected position. Define:

```text
r_(t+1) = p_(t+1) / p_t - 1
turnover_t = |q_t - q_(t-1)|
cost_t = turnover_t * (fee_bps + slippage_bps) / 10000

E_(t+1) = E_t * (1 + q_t * r_(t+1) - cost_t)
```

The strategy is invalid if equity becomes non-finite or non-positive.

## Objective

The operator objective is not simply maximum return. It is a constrained research problem:

```text
maximize    expected_return
subject to  max_drawdown <= D_max
            absolute_exposure <= Q_max
            data_valid = true
            no_lookahead = true
            costs_enabled = true
            paper_only = true
            kill_switch = true
```

A model score may be written as:

```text
J_trade
  = -Return
  + lambda_dd * MaxDrawdown
  + lambda_vol * Volatility
  + lambda_turn * Turnover
  + lambda_h * H_trade
```

Lower `J_trade` is preferable only within the same dataset and assumptions.

## CLSigma formulation

Define the bar-level operator:

```text
O_t = (X_t, S_t, P_R, q_t, cost_t, E_t, certificate_t)
```

Then:

```text
Omega_trade(s)
  = Seal(Sum_t w_t(s) * O_t)
```

or, as model-internal notation:

```text
Z_CL^trade(s)
  = Seal(Sum_t O_t / t^s)
```

This notation organizes a finite computation. It is not a classical zeta identity and does not predict prices by itself.

## Completion residual

```text
H_trade
  = H_data
  + H_lookahead
  + H_costs
  + H_exposure
  + H_drawdown
  + H_reproducibility
  + H_paper_only
  + H_governance
```

Inside the runtime, `H_trade = 0` means the declared checks passed for that run. It does not mean the strategy is profitable, safe in every future market, or suitable for live deployment.

## Required validation path

```text
1. deterministic synthetic-data test
2. historical-data backtest
3. out-of-sample test
4. walk-forward analysis
5. stress tests and missing-data tests
6. paper trading
7. independent review
8. only then consider a separately controlled live adapter
```

Backtests must disclose transaction costs, slippage, sample period, asset universe, survivorship assumptions, missing data, and parameter-selection method.

## Included runtime

```text
CLSIGMA_PAPER_TRADING_OPERATOR.sh
```

Input CSV format:

```text
timestamp,close
2026-01-02,100.25
2026-01-03,101.10
```

Execution:

```sh
sh CLSIGMA_PAPER_TRADING_OPERATOR.sh prices.csv certificate.json
```

Without an input file, the runtime uses deterministic synthetic prices for a self-test.
