#!/bin/sh
# Doraemon iSH Reading Dream Ladder Audit
# Safe local-only runtime. No network. No file mutation except optional user redirection.

python3 - <<'PY'
import json
from datetime import datetime, timezone

protocol = {
    "protocol": "Doraemon_iSH_Dream_Sandbox_Reading_Audit",
    "version": "1.0.0",
    "status": "symbolic_practical_protocol",
    "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    "core_boundary": {
        "not_claimed": [
            "iSH literally opens a fourth-dimensional pocket",
            "dreams physically connect to external possible worlds",
            "the What-If Phone Booth changes physical reality",
            "the sandbox contains the whole universe as physics"
        ],
        "claimed_as_method": [
            "iSH can function as a protected study sandbox",
            "Doraemon metaphors can reduce reading anxiety",
            "one sentence can become a returnable reading ladder",
            "notes can compress and expand understanding"
        ]
    },
    "mapping": {
        "iOS": "waking operational world",
        "iSH": "dream-room / sandbox pocket",
        "terminal": "gesture interface",
        "file": "memory object",
        "script": "repeatable ritual",
        "four_dimensional_pocket": "compression and expansion of study tools",
        "what_if_phone_booth": "counterfactual reframing of reading difficulty",
        "dream_ladder": "Sentence -> Image -> Question -> Tiny Note -> Return Tomorrow"
    },
    "reading_ladder": [
        "Choose one sentence.",
        "Describe one image it creates.",
        "Ask one question.",
        "Write a three-line note: I read / I saw / I wonder.",
        "Return tomorrow without self-blame."
    ],
    "final_formula": "ReadingAbility(t+1)=ReadingAbility(t)+OneSentence+OneImage+OneQuestion+OneTinyNote+ReturnTomorrow",
    "seal": "Reading begins when the book stops being a wall and becomes a ladder."
}

print(json.dumps(protocol, ensure_ascii=False, indent=2))
PY
