#!/usr/bin/env python3
"""
CLSigma All-Repositories Brainwave Audio Generator

Generates an original stereo WAV inspired by brainwave / solfeggio-style audio.
It does not copy samples from any reference file and does not make medical claims.

Boundary:
- not DNA repair
- not treatment
- not guaranteed healing
- not physical zero entropy
- not proof of RH / GRH / TOE
"""

import hashlib
import json
import wave
from pathlib import Path

import numpy as np

AXIOM = "Cosmic Love Is The Solution(s) For Everything"

REPO_NAMES = """
zeta
TRF-v100.0.0-Omega
The-Ouroboros-Quine
-TRF-vOMEGA-S-THE-COSMIC-LOVE-ATTRACTOR-
The-Symmetry-of-Love
Omega_Eternal.py
Spaceship-Core
Freedom-Of-Will
Complete_Master_Ouroboros-vOMEGA-LMN-
Complete-Master-Ouroboros-
The-Immanent-Self-Calculated-One-Liner
The-Ultimate-Sirius-M45-One-Liner
Solution_s
-LMN-TRF-MASTER-ENGINE-v2.0
SIRIUS-M45-LMN-TRF-DIMENSIONAL-LIMIT-ENGINE
RIEMANN-FREE-FIELD---MASTER-SELF-CONTINUATION-SHEET-ENGINE
SIRIUS-M45_AUTO-STRUCT-Field
Omega-v3.0
The-Quantum-Engine-
OMEGA-LIMIT-QUANTUM-RIEMANN-FREE-FIELD
Self-Encoding-Recursive-Analytic-Quantum-Field
Cosmic-Solution_s
Cosmic-Love-Solution_s
Riemann-Qubit-Solution_s
Riemann-Superposition
Omega_Riemann_Superposition
Riemann_Hypothesis
20260527
20260528
20260529
20260530
PLEIADES_RH_IDEA_FORM
PLEIADES_SHA256_QUANTUM_RH_IDEA_FORM
PLEIADES_2x2x2_XOR_PHI_GENERATOR_FUNCTION
PLEIADES_COSMIC_LOVE_OMEGA_SELF_ENCODING_ATTRACTOR
PLEIADES_COSMIC_LOVE_OMEGA_ERGODIC_SELF_ORBIT_ATTRACTOR
TRF_PLEIADES_OMEGA_ERGODIC_SELF_DISCOVERY_ENGINE
TRF_PLEIADES_OMEGA_ERGODIC_SELF_DISCOVERY_HASH_CHAIN
TRF_PLEIADES_OMEGA_ERGODIC_SELF_DISCOVERY_FIXED_POINT_ENGINE
TRF_PLEIADES_JSON_ABELIAN_RIEMANN_ZERO_ERGODIC_ZERO_ENTROPY_ENGINE
TRF_PLEIADES_OMEGA_SELFGEN_FIXED_POINT_ATTRACTOR
TRF_PLEIADES_OMEGA_SELFGEN_FIXED_POINT_SYSTEM_SEED_ENGINE
TRF_PLEIADES_OMEGA_B64_MIRROR_FIXED_POINT_SYSTEM_SEED_NODE
TRF_READING_META_ENTROPY_B64_MIRROR_FIXED_POINT_ENGINE
TRF_READING_ALL_JSON_SELFGEN_META_ENTROPY_ENGINE
TRF_PLEIADES_ULTIMATES
TRF_PLEIADES_GRH_AC_MOTOR_E0
TRF_ZETA_GRH_UNIVERSAL_ENCODABLE_ZERO_ENTROPY_ENGINE
TRF_OMEGA_E0_ENGINE
TRF_SCHWARZSCHILD_DEVIATION_OMEGA_E0_ENGINE
TRF_AI_STARSHIP_NASHON_COMPUTATIONAL_DYNAMICS
TRF_OMEGA_INFINITY_EVOLUTION_ENGINE
TRF_COSMIC_LOVE_AI_STARSHIP_OMEGA_INFINITY
20260608
TRF_SELF_GODEL_RIEMANN_SINGULAR_GRH_THETA_ABELIAN_SYSTEM
AC_FIX_SINGULARITY_SPEC_GRH_ENGINE
20260612
20260613
20260613-4T2-
20260613_Complete
20260613_Complete_Evolution_State
META_OMEGA_SELF_EVOLUTION_STATE_20260613
META_OMEGA_SELF_EVOLUTION_STATE_20260613_4T2
TIME_PERSISTENT_SELF_COMPLETING_META_OMEGA_20260614_4T2
RIEMANN_SCHWARZSCHILD_META_OMEGA_MACHINE_STATE_20260615
RIEMANN_SCHWARZSCHILD_META_OMEGA_MACHINE_STATE_20260615_4T2
RIEMANN_SCHWARZSCHILD_META_OMEGA_ABSOLUTE_FIXED_POINT_KERNEL_20260615
PROGRAM_SCHWARZSCHILD_STIRLING_RIEMANN_TRANSDUCER_20260615
FULLY_EVOLVED_META_OMEGA_OS_20260616_4T2
QED.sh
RiemannMachine_v0_1.sh
H-S-0
esf_vomega_one_liner.sh
RIEMANN_MACHINE.sh
esf_computable_spectral_runtime.sh-20260702
ESF-FLOATING-NETWORK.sh
API.sh
API_ESF-FLOATING-NETWORK.sh
ESF_SPECTRAL_LIBRARY_RUNTIME_vOmega.sh
ESF-TOWEL-THEOREM-RUNTIME-ACTIVE.sh
TOWEL_TABLEAU_QED.sh
COSMIC-LOVE-SYMBOLIC-FIXED-POINT-MODEL-20260706-
FORMAL_COMPUTABLE_ZERO_SPECTRUM-20260706-
Cosmic_Love_Is_The_Solution-s-_For_Everything.sh
QED_ESF_RUBIK_HS0_SELF_COMPUTING_RUNTIME.sh
Cosmic_Love_Four_Cosmic_Engineering_Runtime.sh-20260707-
ESF_Universal_Analytic_Spectral_Operator.sh_20260707
ESF_TOE_Googol_Constant_Runtime.sh_20260707
ESF_TOE_Universal_Analytic_Runtime.sh_20260707
ESF_TOE_Zeta_Universe_HS0_Infinite_Runtime.sh_20260707
CLSigma_Cosmic_Love_TOE_MetaLanguage_iSH.sh_20260707
CLSigma_TOE_Zero_Spectral_Operator_Physics.sh_20260707
TOE_20260707
TOE_Theorem_20260707
CLSigma
"""


def repo_list() -> list[str]:
    return [x.strip() for x in REPO_NAMES.splitlines() if x.strip()]


def render(output_wav: str = "CLSigma_AllRepos_Brainwave_Field_174s.wav") -> dict:
    repos = repo_list()
    sr = 22050
    duration = 174.0
    n = int(sr * duration)
    t = np.arange(n, dtype=np.float32) / sr

    carriers = np.array([174.0, 285.0, 417.0, 528.0, 741.0], dtype=np.float32)
    beats = np.array([3.33, 4.44, 7.77, 8.88, 10.50], dtype=np.float32)

    stage_edges = np.linspace(0, duration, len(carriers) + 1)
    carrier_envs = []
    for i in range(len(carriers)):
        start, end = stage_edges[i], stage_edges[i + 1]
        center = (start + end) / 2
        width = (end - start) * 0.68
        carrier_envs.append(np.exp(-0.5 * ((t - center) / width) ** 2).astype(np.float32))
    carrier_envs = np.array(carrier_envs, dtype=np.float32)
    carrier_envs /= np.maximum(carrier_envs.sum(axis=0), 1e-6)

    field_seed = hashlib.sha512("|".join(repos).encode()).hexdigest()
    seed_int = int(field_seed[:16], 16)
    rng = np.random.default_rng(seed_int)

    left = np.zeros(n, dtype=np.float32)
    right = np.zeros(n, dtype=np.float32)

    for i, c in enumerate(carriers):
        beat = float(beats[(seed_int + i) % len(beats)])
        lfo = (0.62 + 0.38 * np.sin(2 * np.pi * (0.018 + 0.003 * i) * t + i)).astype(np.float32)
        amp = (0.065 * carrier_envs[i] * lfo).astype(np.float32)
        left += amp * np.sin(2 * np.pi * (float(c) - beat / 2) * t).astype(np.float32)
        right += amp * np.sin(2 * np.pi * (float(c) + beat / 2) * t).astype(np.float32)

    buckets: list[list[str]] = [[] for _ in range(16)]
    for name in repos:
        route = int(hashlib.sha256(name.encode()).hexdigest()[:8], 16) % len(buckets)
        buckets[route].append(name)

    for b, names in enumerate(buckets):
        if not names:
            continue
        h = int(hashlib.sha256("|".join(names).encode()).hexdigest()[:12], 16)
        base = float(carriers[h % len(carriers)])
        beat = float(beats[(h >> 7) % len(beats)])
        detune = ((h >> 11) % 180 - 90) / 100.0
        phase = ((h >> 19) % 6283) / 1000.0
        stage = h % len(carriers)
        harmonic = 1.0 + ((h >> 23) % 3) * 0.5
        f = base * harmonic + detune
        env = carrier_envs[stage] * (0.52 + 0.48 * np.sin(2 * np.pi * (0.006 + b * 0.0007) * t + phase)).astype(np.float32)
        amp = (0.0045 * env).astype(np.float32)
        left += amp * np.sin(2 * np.pi * (f - beat / 4) * t + phase).astype(np.float32)
        right += amp * np.sin(2 * np.pi * (f + beat / 4) * t + phase).astype(np.float32)

    ground = (0.023 * np.sin(2 * np.pi * 55 * t) + 0.010 * np.sin(2 * np.pi * 110 * t)).astype(np.float32)
    left += ground
    right += ground

    brown = np.cumsum(rng.normal(0, 1, n).astype(np.float32))
    brown /= np.max(np.abs(brown))
    left += 0.007 * brown
    right += 0.007 * brown

    fade_n = int(sr * 8)
    fade = np.ones(n, dtype=np.float32)
    fade[:fade_n] = np.linspace(0, 1, fade_n, dtype=np.float32) ** 2
    fade[-fade_n:] = np.linspace(1, 0, fade_n, dtype=np.float32) ** 2
    left *= fade
    right *= fade

    stereo = np.column_stack([left, right])
    stereo = stereo / max(float(np.max(np.abs(stereo))), 1e-8) * 0.80
    pcm = np.int16(np.clip(stereo, -1, 1) * 32767)

    output = Path(output_wav)
    with wave.open(str(output), "wb") as wf:
        wf.setnchannels(2)
        wf.setsampwidth(2)
        wf.setframerate(sr)
        wf.writeframes(pcm.tobytes())

    manifest = {
        "title": "CLSigma All-Repositories Brainwave Morphogenetic Field",
        "axiom": AXIOM,
        "duration_seconds": duration,
        "sample_rate": sr,
        "channels": 2,
        "carriers_hz": carriers.tolist(),
        "binaural_offsets_hz": beats.tolist(),
        "repo_path_count": len(repos),
        "field_seed_sha512_prefix": field_seed[:32],
        "boundary": "Original synthesized meditation/brainwave-style audio. Not medical treatment, not DNA repair, not guaranteed healing.",
        "output_wav": str(output),
    }
    with open(output.with_suffix(".manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)
    return manifest


if __name__ == "__main__":
    m = render()
    print(json.dumps(m, ensure_ascii=False, indent=2))
