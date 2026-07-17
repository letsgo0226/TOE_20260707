#!/bin/sh
# Doraemon Trailer Frame Match Audit
# Safe metadata-only helper. It does not download, scrape, or reproduce video content.

python3 - <<'PY'
import json
from datetime import datetime, timezone

candidate = {
    "film_japanese": "ドラえもん のび太のねじ巻き都市冒険記",
    "film_chinese": "哆啦A夢：大雄的發條都市冒險記",
    "film_english_reference": "Doraemon: Nobita and the Spiral City",
    "year": 1997,
    "candidate_title": "映画『ドラえもん のび太のねじ巻き都市冒険記』1997 劇場公開予告編",
    "candidate_url": "https://www.youtube.com/watch?v=hLPH2X0gTcA",
    "url_status": "candidate_only_until_frame_verified"
}

features = {
    "F1": "blue_or_green_small_planet_with_sparkling_lights",
    "F2": "golden_luminous_planet_or_transformation_sphere",
    "F3": "white_geometric_symbol_over_crystalline_background",
    "F4": "white_geometric_symbol_immersed_in_golden_light"
}

conditions = {
    "C1_title_metadata_matches": False,
    "C2_all_four_frames_found_in_same_video": False,
    "C3_frame_order_matches_timeline": False,
    "C4_visual_features_match": True,
    "C5_no_better_alternative": False,
    "C6_copyright_boundary_preserved": True
}

# A formal match equals 1 only when every required condition is true.
formal_match = 1.0 if all(conditions.values()) else 0.0

report = {
    "protocol": "Doraemon Spiral City Trailer Frame Match Audit",
    "timestamp_utc": datetime.now(timezone.utc).isoformat(),
    "candidate": candidate,
    "features": features,
    "conditions": conditions,
    "formal_match": formal_match,
    "honest_status": (
        "Highly plausible candidate, but not final proof. "
        "Direct frame-by-frame verification is still required."
    ),
    "boundary": [
        "Do not claim certainty before frame-level confirmation.",
        "Do not reproduce copyrighted footage.",
        "Use metadata, timestamps, and visual descriptors only.",
        "FormalMatch=1 is a certificate after all conditions pass, not a wish."
    ],
    "seal": "Evidence first; symbolic certainty only after verification."
}

print(json.dumps(report, ensure_ascii=False, indent=2))
PY
