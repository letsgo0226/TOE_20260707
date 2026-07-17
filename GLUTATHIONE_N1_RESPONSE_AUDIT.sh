#!/usr/bin/env sh
set -eu

python3 - <<'PY'
import json
from datetime import datetime, timezone

protocol = {
    "protocol": "GLUTATHIONE_N1_RESPONSE_AUDIT",
    "status": "bounded_personal_tracking_protocol",
    "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    "personal_observation": {
        "reported_subjective_pattern": "Direct glutathione feels stronger than NAC or GlyNAC-ET",
        "scope": "N=1 personal experience",
        "universal_claim": False
    },
    "mechanistic_boundary": {
        "direct_glutathione": "finished molecule / direct support",
        "NAC_GlyNAC": "precursor or substrate support",
        "interpretation": "Different inputs may help different bottlenecks at different times"
    },
    "safety_rules": [
        "Do not stack many high-dose antioxidants without tracking",
        "Do not replace medical care with supplements",
        "Track dose, formulation, timing, sleep, mood, diet, and side effects",
        "Discuss supplement use with a clinician when medications or chronic conditions are present",
        "Treat subjective response as signal, not universal proof"
    ],
    "formal_state": {
        "N1_signal": True,
        "clinical_certainty": False,
        "requires_tracking": True,
        "medical_advice": False
    },
    "seal": "For this body, direct glutathione may currently feel more effective; for the system, the correct answer remains evidence, tracking, and safety."
}

print(json.dumps(protocol, ensure_ascii=False, indent=2))
PY
