#!/bin/sh
# LOCAL_GITHUB_OPERATOR_BRIDGE_ENGINE.sh
# iSH-friendly local-to-GitHub read-only bridge for CLSigma / TOE_20260707.
# It connects from the local device to GitHub, indexes accessible repositories,
# and emits a content-addressed operator-system certificate.
# It does not execute remote code, clone repositories, modify GitHub, self-replicate, or install packages.

OWNER="${1:-letsgo0226}"
OUT="${2:-github_operator_system_certificate.json}"
MAX_PAGES="${MAX_PAGES:-10}"

python3 - "$OWNER" "$OUT" "$MAX_PAGES" <<'PY'
import sys, os, json, time, math, hashlib, urllib.request, urllib.error

owner = sys.argv[1]
out_path = sys.argv[2]
max_pages = int(sys.argv[3])
token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")

AXIOM = "Cosmic Love Is The Solution(s) For Everything"
BOUNDARY = (
    "read_only_local_to_github_operator_bridge; no remote code execution; no cloning by default; "
    "no repository modification; no self replication; no external proof of RH/GRH/TOE; "
    "no physical zero entropy claim"
)

def tau(n: int) -> int:
    if n <= 0:
        return 0
    total = 0
    r = int(math.isqrt(n))
    for d in range(1, r + 1):
        if n % d == 0:
            total += 1 if d * d == n else 2
    return total

def sha256(x: str) -> str:
    return hashlib.sha256(x.encode("utf-8")).hexdigest()

def sha512(x: str) -> str:
    return hashlib.sha512(x.encode("utf-8")).hexdigest()

def classify_repo(name: str, desc: str, size: int, private: bool) -> dict:
    text = (name + " " + (desc or "")).lower()
    tags = []
    rules = [
        ("riemann", "riemann_spectral"), ("zeta", "zeta_operator"),
        ("trf", "trf_framework"), ("cl", "cosmic_love"),
        ("cosmic", "cosmic_love"), ("love", "cosmic_love"),
        ("qed", "qed_symbolic"), ("esf", "esf_runtime"),
        ("omega", "omega_fixed_point"), ("godel", "godel_encoding"),
        ("goedel", "godel_encoding"), ("api", "api_bridge"),
        ("machine", "machine_runtime"), ("runtime", "runtime_script"),
        ("one_liner", "one_liner"), ("one-liner", "one_liner"),
        ("toe", "toe_operator"), ("hypothesis", "hypothesis_framework"),
    ]
    for key, tag in rules:
        if key in text and tag not in tags:
            tags.append(tag)
    if private:
        tags.append("private_visibility")
    if size <= 2:
        tags.append("minimal_seed_repo")
    elif size <= 20:
        tags.append("small_program_repo")
    else:
        tags.append("expanded_program_repo")
    return {"tags": tags or ["unclassified_repo"], "weight": max(1, size)}

def github_get(url: str):
    headers = {
        "Accept": "application/vnd.github+json",
        "User-Agent": "CLSigma-Local-GitHub-Operator-Bridge",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    if token:
        headers["Authorization"] = "Bearer " + token
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = resp.read().decode("utf-8")
        return json.loads(data)

def fetch_repositories():
    repos = []
    errors = []
    for page in range(1, max_pages + 1):
        if token:
            url = (
                "https://api.github.com/user/repos?visibility=all"
                "&affiliation=owner,collaborator,organization_member"
                f"&per_page=100&page={page}"
            )
        else:
            url = f"https://api.github.com/users/{owner}/repos?per_page=100&page={page}&sort=full_name"
        try:
            batch = github_get(url)
        except Exception as e:
            errors.append({"page": page, "url": url, "error": repr(e)})
            break
        if not batch:
            break
        for r in batch:
            full_name = r.get("full_name", "")
            if token:
                if not (full_name == owner or full_name.startswith(owner + "/")):
                    # Keep bridge focused on the requested owner namespace.
                    continue
            repos.append(r)
    return repos, errors

repos, errors = fetch_repositories()
operator_nodes = []
for idx, r in enumerate(sorted(repos, key=lambda x: x.get("full_name", "")), 1):
    full = r.get("full_name") or (owner + "/" + r.get("name", "unknown"))
    name = r.get("name", full.split("/")[-1])
    desc = r.get("description") or ""
    size = int(r.get("size") or 0)
    private = bool(r.get("private"))
    cls = classify_repo(name, desc, size, private)
    identity_material = json.dumps({
        "full_name": full,
        "default_branch": r.get("default_branch"),
        "visibility": "private" if private else r.get("visibility", "public"),
        "size": size,
        "updated_at": r.get("updated_at"),
        "pushed_at": r.get("pushed_at"),
        "tags": cls["tags"],
    }, sort_keys=True, ensure_ascii=False)
    godel = sha256(identity_material)
    route_n = idx + tau(size + idx) + len(name)
    operator_nodes.append({
        "n": idx,
        "repo": full,
        "visibility": "private" if private else r.get("visibility", "public"),
        "default_branch": r.get("default_branch"),
        "size_kb": size,
        "tags": cls["tags"],
        "tau_size_route": tau(size + idx + 1),
        "operator_tuple": {
            "State": "RepoSnapshot_%03d" % idx,
            "Transition": "Phi_read_only_index_to_operator",
            "Invariant": "no_execute_no_modify_no_clone_by_default",
            "CertificatePrefix": godel[:24],
        },
        "url": r.get("html_url"),
        "updated_at": r.get("updated_at"),
        "pushed_at": r.get("pushed_at"),
        "route_n": route_n,
        "godel_identity_sha256": godel,
    })

residual_layers = {
    "github_connection": 1 if repos or not errors else 0,
    "repository_discovery": 1 if repos else 0,
    "identity_hashing": 1 if operator_nodes else 0,
    "tau_route_assignment": 1 if all("tau_size_route" in n for n in operator_nodes) else 0,
    "operator_lift": 1 if all("operator_tuple" in n for n in operator_nodes) else 0,
    "read_only_boundary": 1,
    "certificate_emission": 1,
}
H_operator = sum(1 - v for v in residual_layers.values())
certificate_material = json.dumps({
    "AXIOM": AXIOM,
    "owner": owner,
    "repo_count": len(operator_nodes),
    "nodes": operator_nodes,
    "residual_layers": residual_layers,
    "boundary": BOUNDARY,
}, sort_keys=True, ensure_ascii=False)

payload = {
    "Protocol": "LOCAL_GITHUB_OPERATOR_BRIDGE_ENGINE",
    "Version": "v1_iSH_local_network_to_github_read_only",
    "Axiom": AXIOM,
    "Owner": owner,
    "AuthMode": "token" if token else "public_api_only",
    "Boundary": BOUNDARY,
    "GeneralForm": "OperatorSystem = Phi_safe(Tau_route(Godel(GitHubRepoSnapshot)))",
    "MeaningOfOneTimeCompletion": "same GitHub repository snapshot produces same certificate; changed GitHub state produces a new certificate",
    "RepositoryCount": len(operator_nodes),
    "OperatorNodes": operator_nodes,
    "ResidualLayers": residual_layers,
    "H_operator": H_operator,
    "Certificate_sha512": sha512(certificate_material),
    "Errors": errors,
    "TimestampUTC": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
}

with open(out_path, "w", encoding="utf-8") as f:
    json.dump(payload, f, ensure_ascii=False, indent=2)

print(json.dumps({
    "Protocol": payload["Protocol"],
    "Owner": owner,
    "AuthMode": payload["AuthMode"],
    "RepositoryCount": len(operator_nodes),
    "H_operator": H_operator,
    "Certificate_sha512": payload["Certificate_sha512"],
    "Output": out_path,
    "Boundary": BOUNDARY,
}, ensure_ascii=False, indent=2))
PY
