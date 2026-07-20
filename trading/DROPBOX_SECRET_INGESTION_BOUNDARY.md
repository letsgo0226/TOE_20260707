# Dropbox Secret Ingestion Boundary

## Status

This document defines the boundary for requests that ask the CLSigma trading operator system to read exchange API keys or private keys from Dropbox files such as `API金鑰及私鑰.txt`.

## Decision

The operator system must not read, copy, display, summarize, transform, or use live exchange credentials from Dropbox, GitHub files, chat messages, screenshots, public links, or any document-oriented storage.

A Dropbox file may be located by name for the limited purpose of warning, deletion, quarantine, or access-review, but its secret contents must not be fetched into the assistant, committed into GitHub, passed to OpenAI tools, printed into logs, or used to sign exchange requests.

## Reason

Live trading requires a secret boundary. Exchange API keys and private keys are bearer credentials. If they are placed in a synced document, searchable cloud file, Git commit, chat, workflow log, or shared folder, they must be treated as exposed and rotated before live use.

## Approved credential sources

```text
fixed-IP VPS environment variables
cloud secret manager with fixed egress
GitHub Environment secrets scoped to a protected environment and self-hosted runner
broker-native secret vault
```

## Rejected credential sources

```text
Dropbox text file
Google Drive file
GitHub repository file
chat message
screenshot
workflow log
mobile clipboard
public or private shared link
OpenAI model memory or prompt
```

## Allowed Dropbox actions

```text
search for the filename without fetching content
delete or move the file after explicit user confirmation
inspect sharing metadata
list revisions for cleanup planning
advise key rotation
```

## Disallowed Dropbox actions

```text
fetch the secret file content
create a temporary download link for the secret file
copy the key into GitHub secrets through the assistant
use the secret to sign Binance requests
run automatic real-money trading from the assistant conversation
```

## Safe live-trading architecture

```text
CLSigma signal
-> human-approved trade intent
-> protected GitHub workflow or VPS trigger
-> fixed-IP self-hosted runner
-> environment secret retrieval inside runtime only
-> Binance signed request
-> broker acknowledgement
-> reconciliation certificate
```

## H_secret_live

```text
H_secret_live =
  H_no_secret_file
+ H_key_rotated
+ H_fixed_egress
+ H_secret_manager
+ H_protected_environment
+ H_human_approval
+ H_order_limit
+ H_reconciliation
```

`H_secret_live = 0` means the credential boundary is satisfied. It is not a profit guarantee, not financial advice, and not permission to bypass human approval.
