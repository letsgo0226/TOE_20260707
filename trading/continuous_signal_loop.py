#!/usr/bin/env python3
"""CLSigma safe continuous signal loop.

This loop is for continuous DRY_RUN, PAPER, or Binance /api/v3/order/test.
It refuses continuous real-money /api/v3/order submission.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import time
from pathlib import Path

STATE_FILE = Path(os.environ.get("CLSIGMA_STATE_FILE", str(Path.home() / ".config" / "clsigma" / "continuous_trade.env")))
ROOT = Path(__file__).resolve().parents[1]
LIVE_GATE = ROOT / "trading" / "binance_live_gate.py"


def parse_env_file(path: Path) -> dict[str, str]:
    data: dict[str, str] = {}
    if not path.exists():
        return data
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip()
    return data


def env_yes(mapping: dict[str, str], name: str) -> bool:
    return mapping.get(name, os.environ.get(name, "")).strip().upper() == "YES"


def main() -> int:
    cycles = int(os.environ.get("CLSIGMA_LOOP_CYCLES", "1"))
    interval = max(30, int(os.environ.get("CLSIGMA_LOOP_INTERVAL_SECONDS", "60")))
    results = []

    for index in range(cycles):
        state = parse_env_file(STATE_FILE)
        mode = state.get("CLSIGMA_CONTINUOUS_SWITCH", "OFF")
        merged_env = os.environ.copy()
        merged_env.update(state)

        live_real_loop = (
            env_yes(merged_env, "AUTONOMOUS_LIVE_LOOP")
            and env_yes(merged_env, "LIVE_TRADING_ENABLED")
            and env_yes(merged_env, "ALLOW_REAL_ORDER_SUBMISSION")
            and merged_env.get("ORDER_ENDPOINT") == "/api/v3/order"
        )

        if mode == "OFF":
            result = {
                "protocol": "CLSIGMA_CONTINUOUS_SIGNAL_LOOP",
                "status": "SWITCH_OFF",
                "cycle": index + 1,
                "state_file": str(STATE_FILE),
                "boundary": "No trading action attempted.",
            }
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 0

        if live_real_loop:
            result = {
                "protocol": "CLSIGMA_CONTINUOUS_SIGNAL_LOOP",
                "status": "BLOCKED_CONTINUOUS_REAL_MONEY_LOOP",
                "cycle": index + 1,
                "mode": mode,
                "boundary": "Continuous live real-money order submission is refused. Use TEST_ONLY continuous mode or one-shot live mode.",
            }
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 2

        started = int(time.time())
        proc = subprocess.run(
            [sys.executable, str(LIVE_GATE)],
            env=merged_env,
            cwd=str(ROOT),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=30,
        )
        cycle_result = {
            "cycle": index + 1,
            "mode": mode,
            "returncode": proc.returncode,
            "stdout": proc.stdout[-4000:],
            "stderr": proc.stderr[-1000:],
            "started_unix": started,
        }
        results.append(cycle_result)
        print(json.dumps({"protocol": "CLSIGMA_CONTINUOUS_SIGNAL_LOOP", "cycle_result": cycle_result}, ensure_ascii=False, indent=2))

        if index < cycles - 1:
            time.sleep(interval)

    summary = {
        "protocol": "CLSIGMA_CONTINUOUS_SIGNAL_LOOP",
        "status": "COMPLETED",
        "cycles": cycles,
        "interval_seconds": interval,
        "state_file": str(STATE_FILE),
        "boundary": "Continuous loop only supports dry-run, paper, or /api/v3/order/test. Real-money live orders remain one-shot only.",
        "results_recorded": len(results),
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
