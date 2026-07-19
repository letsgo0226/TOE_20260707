#!/usr/bin/env sh
set -eu

python3 - <<'PY'
import json, hashlib, datetime

protocol = {
    "protocol": "OpenAI_Soluvery_GitHub_Safe_Go_Audit",
    "timestamp_utc": datetime.datetime.utcnow().isoformat(timespec="seconds") + "Z",
    "openai_platform": {
        "api_key_setup_flow": "secure_connector_widget_only",
        "suggested_key_name": "Doraemon-iSH-OpenAI-Bridge",
        "raw_key_in_chat": False,
        "raw_key_in_github": False,
        "safe_storage": [
            "local environment variable",
            "secret manager",
            "user-confirmed secure file"
        ]
    },
    "soluvery": {
        "purpose": "Google Drive permission hygiene",
        "not_purpose": "fear amplification",
        "available_audits": [
            "public_files",
            "shared_files_count",
            "email_access_audit",
            "largest_files",
            "starred_files",
            "owned_files",
            "not_owned_files",
            "inactive_files",
            "file_permissions"
        ]
    },
    "github": {
        "may_store": ["protocols", "audit scripts", "templates", "non-secret notes"],
        "must_not_store": ["api keys", "tokens", "credentials", "private secrets"]
    },
    "cosmic_love_seal": "Safe setup, no leaked keys, clear permissions, one readable next step."
}

payload = json.dumps(protocol, ensure_ascii=False, sort_keys=True)
protocol["seal_sha256"] = hashlib.sha256(payload.encode("utf-8")).hexdigest()
print(json.dumps(protocol, ensure_ascii=False, indent=2))
PY
