#!/bin/sh
set -eu

python3 - <<'PY'
import json

status = {
    "protocol": "DORAEMON_FRAME_SEARCH_PENDING_AUDIT",
    "formal_match": "pending",
    "empirical_match": "not_yet_found",
    "claim_strength": "restrained",
    "candidate_set": [
        "SpiralCity_1997_Trailer",
        "GalaxySuperExpress_Alternative",
        "Other_Doraemon_Trailer_Or_Preview"
    ],
    "verification_required": [
        "identify exact video or source",
        "locate all four screenshots in the source",
        "record approximate timestamps",
        "confirm coherent visual sequence",
        "compare against alternative candidates"
    ],
    "non_claims": [
        "not yet a confirmed frame match",
        "not yet a final movie identification",
        "not a forced certainty claim"
    ],
    "seal": "A good search records uncertainty, preserves clues, and waits for evidence."
}

print(json.dumps(status, ensure_ascii=False, indent=2))
PY
