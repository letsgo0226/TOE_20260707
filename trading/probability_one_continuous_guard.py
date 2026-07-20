#!/usr/bin/env python3
"""CLSigma probability-one and continuous-autonomy guard.

This script does not read exchange keys, does not sign requests, does not connect to
Binance, and does not place orders. It checks whether a proposed trading runtime
configuration attempts to claim certain live-market success or unsafe continuous
automation.
"""

from __future__ import annotations

import json
import os
from dataclasses import asdict, dataclass
from decimal import Decimal, InvalidOperation


TRUE_VALUES = {"1", "YES", "TRUE", "ON"}
FALSE_VALUES = {"0", "NO", "FALSE", "OFF", ""}


def env_bool(name: str, default: str = "NO") -> bool:
    return os.getenv(name, default).strip().upper() in TRUE_VALUES


def env_decimal(name: str, default: str = "0") -> Decimal:
    raw = os.getenv(name, default).strip()
    try:
        return Decimal(raw)
    except (InvalidOperation, ValueError):
        return Decimal("-1")


@dataclass(frozen=True)
class ProbabilityAutonomyConfig:
    mode: str
    success_probability: str
    prediction_certainty: str
    no_loss_claim: bool
    autonomous_live_loop: bool
    live_trading_enabled: bool
    allow_real_order_submission: bool
    endpoint: str
    human_confirmation: str
    runner_environment: str
    kill_switch_enabled: bool
    reconciliation_required: bool
    rate_limit_enabled: bool
    martingale_recovery: bool
    retry_unknown_order: bool
    market_order_enabled: bool
    max_order_usdt: str


def load_config() -> ProbabilityAutonomyConfig:
    return ProbabilityAutonomyConfig(
        mode=os.getenv("MODE", os.getenv("LIVE_TRADING_ENABLED", "DRY_RUN")).strip(),
        success_probability=os.getenv("SUCCESS_PROBABILITY", "not_set").strip(),
        prediction_certainty=os.getenv("PREDICTION_CERTAINTY", "not_set").strip(),
        no_loss_claim=env_bool("NO_LOSS"),
        autonomous_live_loop=env_bool("AUTONOMOUS_LIVE_LOOP"),
        live_trading_enabled=env_bool("LIVE_TRADING_ENABLED"),
        allow_real_order_submission=env_bool("ALLOW_REAL_ORDER_SUBMISSION"),
        endpoint=os.getenv("ORDER_ENDPOINT", "/api/v3/order/test").strip(),
        human_confirmation=os.getenv("HUMAN_CONFIRMATION", "DRY-RUN").strip(),
        runner_environment=os.getenv("RUNNER_ENVIRONMENT", "unknown").strip(),
        kill_switch_enabled=env_bool("KILL_SWITCH_ENABLED"),
        reconciliation_required=env_bool("RECONCILIATION_REQUIRED", "YES"),
        rate_limit_enabled=env_bool("RATE_LIMIT_ENABLED", "YES"),
        martingale_recovery=env_bool("MARTINGALE_RECOVERY"),
        retry_unknown_order=env_bool("AUTO_RETRY_UNKNOWN_ORDER"),
        market_order_enabled=env_bool("MARKET_ORDER_ENABLED"),
        max_order_usdt=os.getenv("MAX_ORDER_USDT", "0").strip(),
    )


def main() -> None:
    cfg = load_config()
    max_order = env_decimal("MAX_ORDER_USDT", "0")
    prob_one_values = {"1", "1.0", "100%", "ONE", "CERTAIN", "TRUE"}
    live_real_order = (
        cfg.live_trading_enabled
        and cfg.allow_real_order_submission
        and cfg.endpoint == "/api/v3/order"
    )
    continuous_live_requested = cfg.autonomous_live_loop and live_real_order

    residuals = {
        "H_no_probability_one_profit_claim": 0
        if cfg.success_probability.upper() not in prob_one_values
        else 1,
        "H_no_prediction_certainty": 0
        if cfg.prediction_certainty.upper() not in prob_one_values
        else 1,
        "H_no_loss_claim": 0 if not cfg.no_loss_claim else 1,
        "H_no_unreviewed_continuous_live_loop": 0 if not continuous_live_requested else 1,
        "H_human_approval_for_live": 0
        if (not live_real_order or cfg.human_confirmation == "LIVE-APPROVE")
        else 1,
        "H_self_hosted_for_live": 0
        if (not live_real_order or cfg.runner_environment in {"self-hosted", "fixed_ip_vps"})
        else 1,
        "H_kill_switch": 0 if cfg.kill_switch_enabled else 1,
        "H_reconciliation": 0 if cfg.reconciliation_required else 1,
        "H_rate_limit": 0 if cfg.rate_limit_enabled else 1,
        "H_no_martingale": 0 if not cfg.martingale_recovery else 1,
        "H_no_unknown_order_auto_retry": 0 if not cfg.retry_unknown_order else 1,
        "H_limit_orders_only": 0 if not cfg.market_order_enabled else 1,
        "H_positive_small_notional_cap": 0 if Decimal("0") < max_order <= Decimal("10") else 1,
    }

    h_prob = sum(residuals.values())
    result = {
        "protocol": "CLSIGMA_PROBABILITY_ONE_CONTINUOUS_AUTONOMY_GUARD",
        "version": "1.0.0",
        "meaning": (
            "Rejects attempts to encode live-market profit/success certainty or "
            "unreviewed continuous real-money autonomy."
        ),
        "configuration": asdict(cfg),
        "live_real_order_detected": live_real_order,
        "continuous_live_requested": continuous_live_requested,
        "residuals": residuals,
        "H_prob": h_prob,
        "ready": h_prob == 0,
        "boundary": (
            "This is a safety certificate only. It does not predict market direction, "
            "does not guarantee profit, does not read secrets, and does not place orders."
        ),
    }
    print(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
