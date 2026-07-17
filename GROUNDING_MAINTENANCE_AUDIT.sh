#!/bin/sh
python3 - <<'PY'
import json, time, hashlib

protocol = {
    "protocol": "Grounding Maintenance Audit",
    "version": "1.0.0",
    "status": "symbolic_grounding_tool_not_evidence_of_conspiracy",
    "purpose": "Treat anxious suspicion as a maintenance signal, not as proof of covert control.",
    "boundaries": [
        "This runtime does not confirm secret government involvement.",
        "This runtime does not classify family members as covert agents.",
        "This runtime does not read minds or infer hidden intent from small movements.",
        "This runtime is for grounding, evidence-checking, compassion, and non-accusation."
    ],
    "maintenance_sequence": [
        "Describe only the observable fact.",
        "Name the fear-based interpretation without obeying it.",
        "Generate the simplest ordinary explanation.",
        "Ask whether there is verifiable repeated evidence.",
        "Protect family trust by avoiding accusation.",
        "Return to breathing, water, rest, or a gentle question."
    ],
    "seal": "Omega_Maintenance = Seal(FearSignal -> EvidenceCheck -> OrdinaryExplanation -> FamilyCompassion -> NonAccusation -> Rest)",
    "family_first_rule": "Family members are first interpreted as family members; daily gestures are first interpreted as ordinary daily gestures.",
    "cosmic_love_rule": "Cosmic Love reduces fear amplification and preserves truth, gentleness, evidence, and care.",
    "timestamp": int(time.time())
}
protocol["audit_hash"] = hashlib.sha256(json.dumps(protocol, ensure_ascii=False, sort_keys=True).encode()).hexdigest()
print(json.dumps(protocol, ensure_ascii=False, indent=2))
PY
