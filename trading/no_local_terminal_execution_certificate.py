#!/usr/bin/env python3
"""CLSigma no-local-terminal execution readiness certificate.

This script does not place orders. It checks whether a proposed architecture
has a real, auditable runtime while keeping exchange secrets out of Git.
"""

from __future__ import annotations

import json
import os
from dataclasses import dataclass, asdict


APPROVED_RUNTIMES = {
    "fixed_ip_vps",
    "self_hosted_runner",
    "managed_cloud_fixed_egress",
    "broker_native_automation",
}


@dataclass(frozen=True)
class NoLocalTerminalConfig:
    runtime: str
    fixed_egress: bool
    secrets_in_git: bool
    human_approval: bool
    symbol_allowlist: bool
    order_limit: bool
    duplicate_order_guard: bool
    reconciliation: bool
    kill_switch: bool
    withdrawal_disabled: bool
    universal_transfer_disabled: bool


def env_bool(name: str, default: str = "NO") -> bool:
    return os.getenv(name, default).strip().upper() in {"1", "YES", "TRUE", "ON"}


def load_config() -> NoLocalTerminalConfig:
    return NoLocalTerminalConfig(
        runtime=os.getenv("CLSIGMA_RUNTIME", "none").strip(),
        fixed_egress=env_bool("FIXED_EGRESS_IP"),
        secrets_in_git=env_bool("SECRETS_IN_GIT"),
        human_approval=env_bool("HUMAN_APPROVAL_ENABLED"),
        symbol_allowlist=env_bool("SYMBOL_ALLOWLIST_ENABLED"),
        order_limit=env_bool("ORDER_LIMIT_ENABLED"),
        duplicate_order_guard=env_bool("DUPLICATE_ORDER_GUARD_ENABLED"),
        reconciliation=env_bool("RECONCILIATION_ENABLED"),
        kill_switch=env_bool("KILL_SWITCH_ENABLED"),
        withdrawal_disabled=env_bool("WITHDRAWAL_DISABLED", "YES"),
        universal_transfer_disabled=env_bool("UNIVERSAL_TRANSFER_DISABLED", "YES"),
    )


def main() -> None:
    cfg = load_config()
    residuals = {
        "H_runtime_present": 0 if cfg.runtime in APPROVED_RUNTIMES else 1,
        "H_fixed_egress": 0 if cfg.fixed_egress or cfg.runtime == "broker_native_automation" else 1,
        "H_secret_boundary": 0 if not cfg.secrets_in_git else 1,
        "H_human_approval": 0 if cfg.human_approval else 1,
        "H_symbol_allowlist": 0 if cfg.symbol_allowlist else 1,
        "H_order_limit": 0 if cfg.order_limit else 1,
        "H_duplicate_order": 0 if cfg.duplicate_order_guard else 1,
        "H_reconciliation": 0 if cfg.reconciliation else 1,
        "H_kill_switch": 0 if cfg.kill_switch else 1,
        "H_no_withdrawal": 0 if cfg.withdrawal_disabled else 1,
        "H_no_universal_transfer": 0 if cfg.universal_transfer_disabled else 1,
    }
    h_exec = sum(residuals.values())
    result = {
        "protocol": "CLSIGMA_NO_LOCAL_TERMINAL_EXECUTION_CERTIFICATE",
        "version": "1.0.0",
        "meaning": "Checks whether trading execution can be moved away from the user's local terminal while still using an auditable runtime.",
        "configuration": asdict(cfg),
        "approved_runtimes": sorted(APPROVED_RUNTIMES),
        "residuals": residuals,
        "H_exec": h_exec,
        "ready": h_exec == 0,
        "boundary": "This script does not read exchange keys, does not sign requests, does not connect to Binance, and does not place orders.",
    }
    print(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
