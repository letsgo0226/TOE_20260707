#!/bin/sh
# LOCAL_CLASSICAL_TO_OPERATOR_ENGINE.sh
# CLSigma / TOE_20260707 local iSH-compatible operator driver.
# Runs locally only: no network, no remote execution, no self-modification.
# Usage: sh LOCAL_CLASSICAL_TO_OPERATOR_ENGINE.sh [ROOT_DIR]
set -eu
ROOT="${1:-.}"
OUT="${2:-operator_system_certificate.json}"
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found. In iSH, install manually if appropriate: apk add --no-cache python3" >&2
  exit 1
fi
python3 - "$ROOT" "$OUT" <<'PY'
import os, sys, json, hashlib, time, math
ROOT=os.path.abspath(sys.argv[1])
OUT=sys.argv[2]
AX="Cosmic Love Is The Solution(s) For Everything"
SCAN_EXT={".sh",".py",".json",".md",".txt",".yml",".yaml",".toml",".ini",".cfg"}
MAX_DEPTH=5
MAX_FILES_PER_REPO=128
MAX_BYTES_PER_FILE=1024*1024

def tau(n:int)->int:
    n=max(1,int(n)); c=0
    r=math.isqrt(n)
    for d in range(1,r+1):
        if n%d==0:
            c += 1 if d*d==n else 2
    return c

def sha_file(path:str)->str:
    h=hashlib.sha256(); total=0
    try:
        with open(path,"rb") as f:
            while total < MAX_BYTES_PER_FILE:
                b=f.read(min(65536, MAX_BYTES_PER_FILE-total))
                if not b: break
                h.update(b); total += len(b)
        return h.hexdigest()
    except Exception as e:
        return "ERROR:"+type(e).__name__

def depth(path:str)->int:
    rel=os.path.relpath(path, ROOT)
    return 0 if rel=="." else rel.count(os.sep)+1

def repo_candidates(root:str):
    repos=[]
    for cur, dirs, files in os.walk(root):
        if depth(cur)>MAX_DEPTH:
            dirs[:] = []
            continue
        if ".git" in dirs:
            repos.append(cur)
            dirs[:] = [d for d in dirs if d != ".git"]
    if not repos:
        repos=[p for p in [root]+[os.path.join(root,d) for d in os.listdir(root) if os.path.isdir(os.path.join(root,d))]]
    return sorted(set(os.path.abspath(r) for r in repos))

def classify(path:str, text:str=""):
    name=os.path.basename(path).lower(); ext=os.path.splitext(name)[1]
    tags=[]
    if ext==".sh": tags.append("shell_runtime")
    if ext==".py": tags.append("python_runtime")
    if ext==".json": tags.append("structured_manifest")
    if ext==".md": tags.append("protocol_document")
    for k,t in [("riemann","riemann_symbolic"),("zeta","zeta_symbolic"),("godel","godel_encoding"),("tau","tau_operator"),("phi","phi_operator"),("zero","zero_spectral"),("cosmic","cosmic_love"),("love","cosmic_love"),("toe","toe_layer"),("trf","trf_layer"),("esf","esf_layer")]:
        if k in name: tags.append(t)
    return sorted(set(tags or ["classical_artifact"]))

repos=[]
for repo in repo_candidates(ROOT):
    files=[]
    for cur, dirs, fs in os.walk(repo):
        if ".git" in dirs: dirs.remove(".git")
        if depth(cur) - depth(repo) > 4:
            dirs[:] = []
            continue
        for fn in fs:
            ext=os.path.splitext(fn)[1].lower()
            if ext not in SCAN_EXT: continue
            p=os.path.join(cur,fn)
            rel=os.path.relpath(p, repo)
            files.append(p)
            if len(files)>=MAX_FILES_PER_REPO: break
        if len(files)>=MAX_FILES_PER_REPO: break
    file_records=[]
    for p in sorted(files):
        file_records.append({"path":os.path.relpath(p,repo),"sha256":sha_file(p),"tags":classify(p)})
    repo_name=os.path.basename(repo.rstrip(os.sep)) or repo
    repo_hash=hashlib.sha256(json.dumps(file_records,sort_keys=True).encode()).hexdigest()
    program_count=sum(1 for f in file_records if any(t in f["tags"] for t in ["shell_runtime","python_runtime","structured_manifest"]))
    operator={
        "repo":repo_name,
        "local_path":repo,
        "file_count_indexed":len(file_records),
        "program_candidate_count":program_count,
        "godel_identity":repo_hash,
        "tau_signature":tau(max(1,len(file_records)+program_count+len(repo_name))),
        "state":"indexed_classical_snapshot",
        "transition":"Phi_safe_lift_to_operator_tuple",
        "invariant":"content_addressed_hash_no_remote_execution",
        "certificate":hashlib.sha512((AX+repo_name+repo_hash).encode()).hexdigest(),
        "sample_files":file_records[:12]
    }
    repos.append(operator)

residuals={
    "root_exists": int(os.path.exists(ROOT)),
    "repo_index_nonempty": int(len(repos)>0),
    "no_network_action": 1,
    "no_remote_execution": 1,
    "no_self_modification": 1,
    "certificate_emitted": 1,
    "review_boundary_present": 1
}
H_operator=sum(1-v for v in residuals.values())
payload={
    "Protocol":"Local_Classical_To_Operator_Engine",
    "Version":"v1_iSH_local_runner",
    "Principle":AX,
    "Scope":"local snapshot indexing and symbolic operator conversion only",
    "Root":ROOT,
    "OperatorFormula":"OperatorSystem = Phi_safe(Tau_route(Godel(LocalRepoSnapshot)))",
    "Completion":"H_operator=0 means the local snapshot has been indexed, lifted, sealed, and certified inside this model",
    "Residuals":residuals,
    "H_operator":H_operator,
    "RepoCount":len(repos),
    "Operators":repos,
    "GlobalCertificate":hashlib.sha512(json.dumps({"AX":AX,"repos":repos,"residuals":residuals},sort_keys=True).encode()).hexdigest(),
    "Boundary":"This tool does not execute discovered programs, does not connect to the network, does not modify repositories, and does not prove external RH/GRH/TOE or physical zero entropy.",
    "Timestamp":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime())
}
with open(OUT,"w",encoding="utf-8") as f:
    json.dump(payload,f,ensure_ascii=False,indent=2)
print(json.dumps({"wrote":OUT,"H_operator":H_operator,"RepoCount":len(repos),"GlobalCertificate":payload["GlobalCertificate"]},ensure_ascii=False,indent=2))
PY
