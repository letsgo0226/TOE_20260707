#!/usr/bin/env sh
set -eu

python3 - <<'PY'
import json
from datetime import datetime, timezone

frames = [
    "blue / small-planet or asteroid-like frame",
    "golden luminous sphere frame",
    "white geometric symbol frame",
    "cosmic activation / transformation frame",
]

candidates = {
    "SpiralCity": {
        "title_jp": "のび太のねじ巻き都市冒険記",
        "title_en": "Nobita and the Spiral City",
        "signals": [
            "small planet / asteroid",
            "life creation or activation motif",
            "golden transformation light",
            "geometric / symbolic cosmic imagery",
        ],
        "status": "leading_candidate_pending_frame_timestamps",
    },
    "GalaxySuperExpress": {
        "title_jp": "のび太と銀河超特急",
        "title_en": "Nobita and the Galaxy Super-express",
        "signals": [
            "outer space setting",
            "galaxy / travel / cosmic environment",
            "Doraemon film-era trailer texture",
        ],
        "status": "alternative_candidate_pending_frame_timestamps",
    },
}

verification_rules = [
    "do_not_force_certainty",
    "do_not_set_empirical_match_to_1_without_frame_timestamps",
    "keep_alternative_candidates_open",
    "record exact YouTube URL before final claim",
    "record timestamp for each of the four frames",
    "prefer evidence over visual resonance",
]

formal_match_condition = {
    "FormalMatch": "1 iff every uploaded frame is located in the same candidate video with timestamp, sequence order, source link, and no stronger alternative",
    "CurrentTruthState": "pending",
    "CandidateSet": list(candidates.keys()) + ["OtherDoraemonTrailer"],
}

payload = {
    "protocol": "DORAEMON_GALAXY_SUPER_EXPRESS_CANDIDATE_AUDIT",
    "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    "frames_to_verify": frames,
    "candidates": candidates,
    "verification_rules": verification_rules,
    "formal_match_condition": formal_match_condition,
    "seal": "CandidateMatch is not FormalMatch. FormalMatch = 1 only after frame-level verification.",
}

print(json.dumps(payload, ensure_ascii=False, indent=2))
PY
