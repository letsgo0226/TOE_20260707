# CLSigma Binance Live Gate Setup

## Status

This setup is a locked live-trading gateway template. It does not contain API keys. It does not use `API.txt`. It defaults to dry-run or Binance's test order endpoint.

## Secret handling

Do not store live API credentials in GitHub files. The prior `API.txt` key must be treated as exposed and revoked or rotated before any live use.

Use one of these patterns:

1. Fixed-IP VPS environment variables, preferred.
2. GitHub Environment secrets only for a self-hosted runner bound to that fixed IP.

Never commit:

```text
BINANCE_API_KEY
BINANCE_SECRET_KEY
API.txt
.env
private keys
signed URLs
session cookies
```

## Required Binance API permissions

Minimum permissions for first live-gate tests:

```text
Read: enabled
Spot trading: enabled only when needed
Withdrawal: disabled
Universal transfer: disabled
Margin/futures/prediction/leverage: disabled
IP allowlist: fixed VPS public IP only
Symbol allowlist: exact symbols only, for example BTCUSDT and ETHUSDT
```

## GitHub Actions architecture

```text
GitHub workflow_dispatch button
-> protected environment: binance-live
-> self-hosted runner labeled binance-live
-> trading/binance_live_gate.py
-> Binance /api/v3/order/test by default
-> optional /api/v3/order only after explicit multi-lock confirmation
```

The workflow is intentionally configured with:

```yaml
runs-on: [self-hosted, binance-live]
environment: binance-live
permissions:
  contents: read
```

## Required GitHub environment

Create an environment named:

```text
binance-live
```

Add required reviewers before secrets are accessible. Add environment secrets only after rotating keys:

```text
BINANCE_API_KEY
BINANCE_SECRET_KEY
```

## Local dry run

```sh
SYMBOL=BTCUSDT \
SIDE=BUY \
QUANTITY=0.001 \
PRICE=10000 \
MAX_ORDER_USDT=10 \
python3 trading/binance_live_gate.py
```

Expected status:

```text
DRY_RUN_ONLY
```

## Test signed endpoint without placing a real order

This uses Binance `/api/v3/order/test`.

```sh
export BINANCE_API_KEY='rotated_key_here'
export BINANCE_SECRET_KEY='rotated_secret_here'

LIVE_TRADING_ENABLED=YES \
HUMAN_CONFIRMATION=LIVE-APPROVE \
ORDER_ENDPOINT=/api/v3/order/test \
ALLOW_REAL_ORDER_SUBMISSION=NO \
CLSIGMA_ALLOW_LOCAL_LIVE=YES \
SYMBOL=BTCUSDT \
SIDE=BUY \
QUANTITY=0.001 \
PRICE=10000 \
MAX_ORDER_USDT=10 \
python3 trading/binance_live_gate.py
```

## Real order submission locks

A real order is blocked unless all of these are true:

```text
LIVE_TRADING_ENABLED=YES
HUMAN_CONFIRMATION=LIVE-APPROVE
ALLOW_REAL_ORDER_SUBMISSION=YES
ORDER_ENDPOINT=/api/v3/order
RUNNER_ENVIRONMENT=self-hosted or CLSIGMA_ALLOW_LOCAL_LIVE=YES
quantity > 0
price > 0
order_value <= MAX_ORDER_USDT
symbol in ALLOWED_SYMBOLS
side in BUY/SELL
limit order only
```

## CLSigma certificate

```text
H_live =
  H_symbol_allowlist
+ H_side_valid
+ H_limit_order_only
+ H_quantity_positive
+ H_price_positive
+ H_order_value_limit
+ H_no_market_order
+ H_endpoint_test_by_default
+ H_secret_present_for_live
+ H_human_confirmation_for_live
+ H_self_hosted_or_local_override
+ H_real_order_double_lock
```

`H_live = 0` means the configured local safety checks passed. It is not a prediction, not financial advice, and not a profit guarantee.

## Operational boundary

The operator system may propose a trade intent, but the live gate, human approval, Binance permissions, IP allowlist, symbol allowlist, and kill-switch rules must be able to reject it.
