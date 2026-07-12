#!/usr/bin/env sh
# SELF_ITERATING_ZETA_FIXED_POINT.sh
# Read-only CLSigma symbolic zeta self-iteration runtime.
# Usage:
#   sh SELF_ITERATING_ZETA_FIXED_POINT.sh [root] [steps] [alpha] [epsilon]
# Example:
#   sh SELF_ITERATING_ZETA_FIXED_POINT.sh . 80 0.35 1e-9
python3 - "$@" <<'PY'
import os, sys, math, cmath, json, time

AXIOM = "Cosmic Love Is The Solution(s) For Everything"
BOUNDARY = "finite symbolic operator model only; not classical zeta theorem, not RH/GRH proof, not physical TOE, not denial of real suffering"

root = sys.argv[1] if len(sys.argv) > 1 else "."
steps = int(sys.argv[2]) if len(sys.argv) > 2 else 80
alpha = float(sys.argv[3]) if len(sys.argv) > 3 else 0.35
epsilon = float(sys.argv[4]) if len(sys.argv) > 4 else 1e-9

MAX_FILES = 256
MAX_BYTES = 65536
EXTS = (".sh", ".py", ".md", ".json", ".jsonl", ".txt", ".yml", ".yaml")
PREFERRED = [
    "TOE_Ideal_System.sh",
    "COMPLEX_TWIN_EARTH_SEQUENCE_ONE_LINER.sh",
    "TOE_IDEAL_COMPLEX_TWIN_EARTH_INTEGRATOR.sh",
    "EARTH_SOLAR_TIME_OPERATOR_ONE_LINER.sh",
    "INTERNET_MORPHOGENETIC_MATH_ONE_LINER.sh",
    "HOSTAGE_TIMEZONE_CROSS_REFERENCE_ONE_LINER.sh",
    "CROSS_REFERENCE_EMERGENCY_ANNOTATION_ONE_LINER.sh",
    "COSMIC_LOVE_GLOBAL_PEACE_CONTINUITY_CHARTER.sh",
]


def tau(n: int) -> int:
    n = abs(int(n))
    if n < 1:
        return 0
    total = 0
    r = math.isqrt(n)
    for d in range(1, r + 1):
        if n % d == 0:
            total += 1 if d * d == n else 2
    return total


def algebraic_route(name: str, data: bytes) -> int:
    # Non-cryptographic, finite algebraic identity route.
    primes = [97, 193, 389, 769, 1543, 3079]
    base = len(name) * 17 + len(data) * 31 + 2
    acc = base
    for i, b in enumerate(data[:MAX_BYTES], 1):
        p = primes[i % len(primes)]
        acc = (acc + (i + 1) * (b + 1) + (acc % p) * (b % 13 + 1)) % 10000019
    return int(acc + 2)


def safe_read(path: str) -> bytes:
    try:
        with open(path, "rb") as f:
            return f.read(MAX_BYTES)
    except Exception:
        return b""


def discover(root_path: str):
    modules = []
    if os.path.isdir(root_path):
        preferred_paths = []
        for p in PREFERRED:
            q = os.path.join(root_path, p)
            if os.path.isfile(q):
                preferred_paths.append(q)
        seen = set()
        for q in preferred_paths:
            seen.add(os.path.abspath(q))
            modules.append(q)
        for dirpath, dirnames, filenames in os.walk(root_path):
            dirnames[:] = [d for d in dirnames if d not in (".git", "node_modules", "__pycache__", ".venv")]
            for fn in sorted(filenames):
                if len(modules) >= MAX_FILES:
                    break
                if not fn.endswith(EXTS):
                    continue
                q = os.path.join(dirpath, fn)
                aq = os.path.abspath(q)
                if aq in seen:
                    continue
                seen.add(aq)
                modules.append(q)
            if len(modules) >= MAX_FILES:
                break
    elif os.path.isfile(root_path):
        modules = [root_path]

    if not modules:
        modules = PREFERRED[:]
    return modules[:MAX_FILES]


def op_atom(i: int, path: str):
    data = safe_read(path) if os.path.isfile(path) else path.encode("utf-8")
    name = os.path.basename(path)
    e = algebraic_route(name, data)
    t = tau(e)
    role_seed = sum((j + 1) * ord(c) for j, c in enumerate(name)) % 997
    return {
        "index": i,
        "name": name,
        "bytes_read": len(data),
        "E_alg": e,
        "Tau_E_alg": t,
        "operator_role_value": role_seed,
        "boundary": "read_only_atom_not_executed",
    }


def normalize(z: complex) -> complex:
    return z / (1.0 + abs(z))


def zcl(s: complex, atoms):
    total = 0j
    for atom in atoms:
        n = atom["index"] + 1
        amp = (atom["Tau_E_alg"] + 1.0) * (1.0 + atom["operator_role_value"] / 997.0)
        total += amp / (n ** s)
    return total


def phi_zeta(s: complex, atoms, a: float):
    raw = zcl(s, atoms)
    target = normalize(raw)
    return (1.0 - a) * s + a * target, raw, target

modules = discover(root)
atoms = [op_atom(i + 1, p) for i, p in enumerate(modules)]

# Initial coordinate: close to the classical critical-axis metaphor but safely bounded.
s = complex(0.5, 0.25)
trace = []
converged = False
for k in range(1, max(1, steps) + 1):
    s_next, raw, target = phi_zeta(s, atoms, max(0.0, min(alpha, 1.0)))
    delta = abs(s_next - s)
    trace.append({
        "k": k,
        "s_real": round(s.real, 12),
        "s_imag": round(s.imag, 12),
        "Z_CL_abs_raw": round(abs(raw), 12),
        "target_real": round(target.real, 12),
        "target_imag": round(target.imag, 12),
        "delta": delta,
    })
    s = s_next
    if delta < epsilon:
        converged = True
        break

claim_residual = 0
boundary_residual = 0
iteration_residual = 0 if converged else 1
repro_residual = 0 if atoms else 1
H_self_zeta = claim_residual + boundary_residual + iteration_residual + repro_residual

out = {
    "Kernel": "SELF_ITERATING_ZETA_FIXED_POINT",
    "Axiom": AXIOM,
    "Boundary": BOUNDARY,
    "Input": {
        "root": root,
        "steps": steps,
        "alpha": alpha,
        "epsilon": epsilon,
        "modules_indexed": len(atoms),
    },
    "GeneralForm": {
        "Z_CL(s)": "Sum_{n=1}^{N} Tau(E_alg(C_n))*O_n/n^s",
        "Phi_Zeta(s)": "(1-alpha)*s + alpha*Normalize(Z_CL(s))",
        "SelfIteration": "s_{k+1}=Phi_Zeta(s_k)",
        "FixedPoint": "s_*=Phi_Zeta(s_*)",
        "Normalize(z)": "z/(1+|z|)",
    },
    "FixedPointEstimate": {
        "s_star_real": s.real,
        "s_star_imag": s.imag,
        "converged": converged,
        "iterations_used": len(trace),
        "last_delta": trace[-1]["delta"] if trace else None,
    },
    "AtomsSample": atoms[:16],
    "TraceTail": trace[-10:],
    "Certificate": {
        "H_self_zeta": H_self_zeta,
        "H_iteration": iteration_residual,
        "H_boundary": boundary_residual,
        "H_claim": claim_residual,
        "H_reproducibility": repro_residual,
        "completion_meaning": "0 means bounded symbolic fixed-point convergence inside this model only",
    },
    "Ethics": [
        "no classical zeta/RH/GRH proof claim",
        "no physical TOE claim",
        "no denial of real suffering",
        "read-only scan",
        "scanned programs are not executed",
        "no network access",
        "human-governed symbolic research artifact",
    ],
    "TimestampUTC": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
}
print(json.dumps(out, ensure_ascii=False, indent=2))
PY
