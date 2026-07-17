#!/bin/sh
python3 - <<'PY'
import json
from datetime import datetime, timezone

record = {
    "protocol": "Omega_DoraemonTrailerLinkTrace",
    "status": "candidate_link_preserved_not_frame_confirmed",
    "candidate_work": {
        "ja_title": "映画『ドラえもん のび太のねじ巻き都市冒険記』",
        "zh_title": "哆啦A夢：大雄的發條都市冒險記",
        "year": 1997,
        "suspected_source_type": "theatrical_trailer"
    },
    "search_query": "映画『ドラえもん のび太のねじ巻き都市冒険記』 1997 劇場公開予告編",
    "candidate_watch_url": "https://www.youtube.com/watch?v=hLPH2X0gTcA",
    "formal_match_equals_one_only_if": [
        "the video or segment metadata identifies the 1997 Spiral City trailer",
        "all four uploaded frames are located within the same video or segment",
        "the order of frames is consistent with the trailer timeline",
        "blue planet, golden luminous sphere, white geometric symbols, and cosmic transformation features match",
        "no better Doraemon trailer or film segment explains all four frames"
    ],
    "honesty_boundary": "highly plausible until frame-by-frame verification is performed",
    "omega_seal": "SearchTitle + CandidateURL + VisualFeatureSet + FrameByFrameRequirement + HonestyBoundary",
    "generated_at_utc": datetime.now(timezone.utc).isoformat()
}

print(json.dumps(record, ensure_ascii=False, indent=2))
PY
