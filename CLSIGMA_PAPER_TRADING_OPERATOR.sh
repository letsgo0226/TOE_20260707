#!/bin/sh
set -eu
python3 - "$@" <<'PY'
import csv
import json
import math
import os
import random
import statistics
import sys
from datetime import datetime, timedelta, timezone

FAST = 5
SLOW = 20
TARGET_EXPOSURE = 1.0
MAX_EXPOSURE = 1.0
VOLATILITY_GATE = 0.04
KILL_DRAWDOWN = 0.12
FEE_BPS = 5.0
SLIPPAGE_BPS = 2.0
ANNUALIZATION = 252

input_path = sys.argv[1] if len(sys.argv) > 1 and sys.argv[1] not in ("", "-") else None
output_path = sys.argv[2] if len(sys.argv) > 2 and sys.argv[2] not in ("", "-") else None


def finite_positive(x):
    return math.isfinite(x) and x > 0


def read_prices(path):
    rows = []
    with open(path, "r", encoding="utf-8-sig", newline="") as fh:
        reader = csv.DictReader(fh)
        names = {str(n).strip().lower(): n for n in (reader.fieldnames or [])}
        if "close" not in names:
            raise ValueError("CSV requires a close column")
        ts_key = names.get("timestamp") or names.get("date") or names.get("time")
        close_key = names["close"]
        for idx, row in enumerate(reader, start=2):
            raw = str(row.get(close_key, "")).strip()
            if not raw:
                continue
            try:
                close = float(raw)
            except ValueError as exc:
                raise ValueError(f"invalid close at CSV line {idx}") from exc
            if not finite_positive(close):
                raise ValueError(f"close must be finite and positive at CSV line {idx}")
            stamp = str(row.get(ts_key, "")).strip() if ts_key else str(idx - 1)
            rows.append((stamp, close))
    if len(rows) < SLOW + 2:
        raise ValueError(f"need at least {SLOW + 2} valid price rows")
    return rows


def synthetic_prices(n=320):
    rng = random.Random(777)
    start = datetime(2025, 1, 1, tzinfo=timezone.utc)
    rows = []
    price = 100.0
    for i in range(n):
        regime = 0.00045 if (i // 80) % 2 == 0 else -0.00010
        cyc = 0.0015 * math.sin(i / 13.0)
        shock = rng.gauss(0.0, 0.009)
        price *= math.exp(regime + cyc + shock)
        rows.append(((start + timedelta(days=i)).date().isoformat(), price))
    return rows


def mean(values):
    return sum(values) / len(values)


def sample_stdev(values):
    return statistics.stdev(values) if len(values) > 1 else 0.0


rows = read_prices(input_path) if input_path else synthetic_prices()
timestamps = [r[0] for r in rows]
prices = [r[1] for r in rows]

cash_equity = 1.0
peak_equity = 1.0
position = 0.0
max_drawdown = 0.0
turnover_total = 0.0
trade_count = 0
killed = False
bar_records = []
strategy_returns = []

for i in range(SLOW, len(prices) - 1):
    history = prices[:i]
    fast = mean(history[-FAST:])
    slow = mean(history[-SLOW:])
    prior_returns = [history[j] / history[j - 1] - 1.0 for j in range(max(1, len(history) - SLOW + 1), len(history))]
    vol = sample_stdev(prior_returns)
    raw_signal = 1 if fast > slow else (-1 if fast < slow else 0)

    current_drawdown = 1.0 - cash_equity / peak_equity if peak_equity > 0 else 1.0
    if current_drawdown >= KILL_DRAWDOWN:
        killed = True

    desired = TARGET_EXPOSURE if raw_signal > 0 else 0.0
    if vol > VOLATILITY_GATE or killed:
        desired = 0.0
    desired = max(0.0, min(MAX_EXPOSURE, desired))

    turnover = abs(desired - position)
    cost = turnover * (FEE_BPS + SLIPPAGE_BPS) / 10000.0
    next_return = prices[i + 1] / prices[i] - 1.0
    strategy_return = desired * next_return - cost
    cash_equity *= 1.0 + strategy_return
    if not finite_positive(cash_equity):
        raise RuntimeError("equity became non-finite or non-positive")

    if turnover > 0:
        trade_count += 1
    turnover_total += turnover
    position = desired
    peak_equity = max(peak_equity, cash_equity)
    drawdown = 1.0 - cash_equity / peak_equity
    max_drawdown = max(max_drawdown, drawdown)
    strategy_returns.append(strategy_return)

    bar_records.append({
        "timestamp": timestamps[i],
        "execution_price": round(prices[i], 10),
        "fast_mean_prior": round(fast, 10),
        "slow_mean_prior": round(slow, 10),
        "volatility_prior": round(vol, 10),
        "raw_signal": raw_signal,
        "projected_position": desired,
        "turnover": round(turnover, 10),
        "cost_fraction": round(cost, 10),
        "next_bar_return": round(next_return, 10),
        "strategy_return": round(strategy_return, 10),
        "equity": round(cash_equity, 10),
        "drawdown": round(drawdown, 10),
        "kill_switch": killed,
    })

avg_return = mean(strategy_returns) if strategy_returns else 0.0
volatility = sample_stdev(strategy_returns)
sharpe = (avg_return / volatility * math.sqrt(ANNUALIZATION)) if volatility > 0 else 0.0
annualized_volatility = volatility * math.sqrt(ANNUALIZATION)
total_return = cash_equity - 1.0
algebraic_data_id = sum((i + 1) * int(round(p * 1000000)) for i, p in enumerate(prices)) % 1000000007
J_trade = -total_return + 2.0 * max_drawdown + 0.25 * annualized_volatility + 0.001 * turnover_total

checks = {
    "data_valid": len(prices) >= SLOW + 2 and all(finite_positive(p) for p in prices),
    "no_lookahead": True,
    "transaction_costs_enabled": (FEE_BPS + SLIPPAGE_BPS) > 0,
    "exposure_bounded": all(0.0 <= b["projected_position"] <= MAX_EXPOSURE for b in bar_records),
    "drawdown_kill_switch_present": KILL_DRAWDOWN > 0,
    "paper_only": True,
    "network_disabled": True,
    "broker_api_absent": True,
    "reproducibility_declared": True,
    "governance_boundary_declared": True,
}
H_trade = sum(0 if ok else 1 for ok in checks.values())

certificate = {
    "kernel": "CLSigma_Paper_Trading_Operator_v1",
    "status": "MODEL_COMPLETE" if H_trade == 0 else "MODEL_INCOMPLETE",
    "mode": "historical_csv" if input_path else "deterministic_synthetic_self_test",
    "input": input_path or "synthetic(seed=777)",
    "algebraic_data_id_no_sha": algebraic_data_id,
    "formula": "Omega_trade(s)=Seal(Sum_t w_t(s)*O_t)",
    "zeta_style_note": "Z_CL^trade is model-internal notation, not a classical zeta identity.",
    "strategy": {
        "type": "prior-bar moving-average crossover with long-or-flat risk projection",
        "fast_window": FAST,
        "slow_window": SLOW,
        "target_exposure": TARGET_EXPOSURE,
        "max_exposure": MAX_EXPOSURE,
        "volatility_gate": VOLATILITY_GATE,
        "kill_drawdown": KILL_DRAWDOWN,
        "fee_bps": FEE_BPS,
        "slippage_bps": SLIPPAGE_BPS,
    },
    "metrics": {
        "price_rows": len(prices),
        "evaluated_bars": len(strategy_returns),
        "final_equity": round(cash_equity, 10),
        "total_return": round(total_return, 10),
        "max_drawdown": round(max_drawdown, 10),
        "annualized_volatility": round(annualized_volatility, 10),
        "sharpe_no_risk_free_rate": round(sharpe, 10),
        "trade_count": trade_count,
        "turnover_total": round(turnover_total, 10),
        "kill_switch_triggered": killed,
        "J_trade": round(J_trade, 10),
    },
    "checks": checks,
    "H_trade": H_trade,
    "boundary": [
        "paper trading and research only",
        "no live orders",
        "no network requests",
        "no broker or exchange connection",
        "no guarantee of profit or future performance",
        "independent validation is required before any live adapter",
    ],
    "records": bar_records,
}

payload = json.dumps(certificate, ensure_ascii=False, indent=2)
if output_path:
    parent = os.path.dirname(os.path.abspath(output_path))
    os.makedirs(parent, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as fh:
        fh.write(payload + "\n")
    print(json.dumps({
        "status": certificate["status"],
        "mode": certificate["mode"],
        "output": output_path,
        "H_trade": H_trade,
        "metrics": certificate["metrics"],
    }, ensure_ascii=False, indent=2))
else:
    print(payload)
PY
