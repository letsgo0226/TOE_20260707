#!/usr/bin/env python3
"""CLSigma Binance live gate.

Safety model:
- Secrets are read only from environment variables.
- Default mode is DRY_RUN.
- Default Binance endpoint is /api/v3/order/test, not the real order endpoint.
- Real order submission requires all of:
  LIVE_TRADING_ENABLED=YES
  HUMAN_CONFIRMATION=LIVE-APPROVE
  ALLOW_REAL_ORDER_SUBMISSION=YES
  ORDER_ENDPOINT=/api/v3/order
  RUNNER_ENVIRONMENT=self-hosted, unless CLSIGMA_ALLOW_LOCAL_LIVE=YES

This is a technical safety gate, not investment advice and not a profit guarantee.
"""

from __future__ import annotations

import hashlib
import hmac
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from decimal import Decimal, InvalidOperation
from typing import Any

BINANCE_BASE_URL = os.environ.get("BINANCE_BASE_URL", "https://api.binance.com")


def env(name: str, default: str = "") -> str:
    return os.environ.get(name, default).strip()


def decimal_env(name: str, default: str) -> Decimal:
    value = env(name, default)
    try:
        return Decimal(value)
    except InvalidOperation as exc:
        raise SystemExit(f"Invalid decimal for {name}: {value!r}") from exc


def bool_yes(name: str) -> bool:
    return env(name).upper() == "YES"


def sign_payload(secret: str, query: str) -> str:
    return hmac.new(secret.encode("utf-8"), query.encode("utf-8"), hashlib.sha256).hexdigest()


def build_certificate(status: str, checks: dict[str, int], extra: dict[str, Any] | None = None) -> dict[str, Any]:
    h_live = sum(1 for passed in checks.values() if not passed)
    certificate: dict[str, Any] = {
        "protocol": "CLSIGMA_BINANCE_LIVE_GATE",
        "version": "v1_locked_template",
        "status": status,
        "H_live": h_live,
        "checks": checks,
        "meaning": "H_live=0 means local safety checks passed; it does not mean profit, suitability, or market correctness.",
        "boundary": "No secrets are printed. Default endpoint is test-only. Real orders require explicit multi-lock confirmation.",
    }
    if extra:
        certificate.update(extra)
    return certificate


def validate_inputs() -> tuple[dict[str, str], dict[str, int], Decimal]:
    symbol = env("SYMBOL", "BTCUSDT").upper()
    side = env("SIDE", "BUY").upper()
    quantity = decimal_env("QUANTITY", "0")
    price = decimal_env("PRICE", "0")
    max_order_usdt = decimal_env("MAX_ORDER_USDT", "10")
    allowed_symbols = {x.strip().upper() for x in env("ALLOWED_SYMBOLS", "BTCUSDT,ETHUSDT").split(",") if x.strip()}
    endpoint = env("ORDER_ENDPOINT", "/api/v3/order/test")
    live_enabled = bool_yes("LIVE_TRADING_ENABLED")
    human_confirmation = env("HUMAN_CONFIRMATION") == "LIVE-APPROVE"
    real_submission = bool_yes("ALLOW_REAL_ORDER_SUBMISSION")
    runner_ok = env("RUNNER_ENVIRONMENT") == "self-hosted" or bool_yes("CLSIGMA_ALLOW_LOCAL_LIVE")
    key_present = bool(env("BINANCE_API_KEY"))
    secret_present = bool(env("BINANCE_SECRET_KEY"))
    order_value = quantity * price

    checks = {
        "H_symbol_allowlist": int(symbol in allowed_symbols),
        "H_side_valid": int(side in {"BUY", "SELL"}),
        "H_limit_order_only": 1,
        "H_quantity_positive": int(quantity > 0),
        "H_price_positive": int(price > 0),
        "H_order_value_limit": int(order_value > 0 and order_value <= max_order_usdt),
        "H_no_market_order": 1,
        "H_endpoint_test_by_default": int(endpoint in {"/api/v3/order/test", "/api/v3/order"}),
        "H_secret_present_for_live": int((not live_enabled) or (key_present and secret_present)),
        "H_human_confirmation_for_live": int((not live_enabled) or human_confirmation),
        "H_self_hosted_or_local_override": int((not live_enabled) or runner_ok),
        "H_real_order_double_lock": int((endpoint != "/api/v3/order") or (live_enabled and real_submission and human_confirmation)),
    }

    params = {
        "symbol": symbol,
        "side": side,
        "type": "LIMIT",
        "timeInForce": "GTC",
        "quantity": str(quantity),
        "price": str(price),
        "recvWindow": env("RECV_WINDOW", "5000"),
        "timestamp": str(int(time.time() * 1000)),
        "newClientOrderId": env("CLIENT_ORDER_ID", f"CLSIGMA_{int(time.time())}"),
        "endpoint": endpoint,
    }
    return params, checks, order_value


def submit_signed_request(params: dict[str, str]) -> dict[str, Any]:
    api_key = env("BINANCE_API_KEY")
    secret = env("BINANCE_SECRET_KEY")
    endpoint = params.pop("endpoint")
    query = urllib.parse.urlencode(params)
    signature = sign_payload(secret, query)
    url = f"{BINANCE_BASE_URL}{endpoint}?{query}&signature={signature}"
    request = urllib.request.Request(url, method="POST", headers={"X-MBX-APIKEY": api_key})
    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            body = response.read().decode("utf-8")
            return {"http_status": response.status, "body": json.loads(body) if body else {}}
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        return {"http_status": exc.code, "error": body[:1000]}


def main() -> int:
    params, checks, order_value = validate_inputs()
    h_live = sum(1 for passed in checks.values() if not passed)
    endpoint = params["endpoint"]
    live_enabled = bool_yes("LIVE_TRADING_ENABLED")

    safe_public = {
        "symbol": params["symbol"],
        "side": params["side"],
        "type": params["type"],
        "quantity": params["quantity"],
        "price": params["price"],
        "order_value_quote": str(order_value),
        "endpoint": endpoint,
        "mode": "LIVE" if live_enabled else "DRY_RUN",
    }

    if h_live != 0:
        print(json.dumps(build_certificate("BLOCKED", checks, {"intent": safe_public}), ensure_ascii=False, indent=2))
        return 2

    if not live_enabled:
        print(json.dumps(build_certificate("DRY_RUN_ONLY", checks, {"intent": safe_public}), ensure_ascii=False, indent=2))
        return 0

    response = submit_signed_request(dict(params))
    print(json.dumps(build_certificate("SUBMITTED_TO_BINANCE_ENDPOINT", checks, {"intent": safe_public, "broker_response": response}), ensure_ascii=False, indent=2))
    return 0 if 200 <= int(response.get("http_status", 0)) < 300 else 3


if __name__ == "__main__":
    raise SystemExit(main())
