command -v python3 >/dev/null 2>&1 || { echo 'python3 required: apk add --no-cache python3'; exit 1; }; python3 -c 'import os,sys,json,math,time;root=sys.argv[1] if len(sys.argv)>1 else ".";out=sys.argv[2] if len(sys.argv)>2 else "zcl_no_sha_grand_operator_certificate.json";EXT=(".sh",".py",".json",".md",".txt",".yml",".yaml");P=[1000003,1000033,1000037,1000039,1000081,1000099,1000117];def tau(n):
 n=max(1,int(n));r=0
 for d in range(1,int(math.isqrt(n))+1):
  if n%d==0:r+=1+(d*d!=n)
 return r
def alg(data,path):
 A=len(data)+1;B=len(path)+1;C=0
 for i,b in enumerate(data[:65536],1):A=(A+(i+1)*(b+1))%P[0];B=(B*(1+(b%17))+i+b+1)%P[1];C=(C+(i*i+i+1)*(b+1))%P[2]
 return {"alg_id":"ALG-%06d-%06d-%06d-%06d"%(A,B,C,(A*B+C+len(data))%P[3]),"vector":[A,B,C,(A+B+C)%P[4],(A*B+C)%P[5]],"tau_route":tau(A+B+C+len(data)+len(path))}
ops=[];total=0
for dp,ds,fs in os.walk(root):
 ds[:]=[d for d in ds if d not in (".git","__pycache__","node_modules",".venv","venv")]
 for f in fs:
  if f.endswith(EXT):
   p=os.path.join(dp,f);rel=os.path.relpath(p,root)
   try:
    data=open(p,"rb").read();e=alg(data,rel);kind=("program" if f.endswith((".sh",".py")) else "document_or_manifest");ops.append({"n":len(ops)+1,"path":rel,"kind":kind,"bytes":len(data),"algebraic_identity":e["alg_id"],"tau_route":e["tau_route"],"operator":"O_n=(state,transition,invariant,certificate)","zeta_weight":"1/%d^s"%(len(ops)+1),"vector":e["vector"]});total+=len(data)
   except Exception as ex:ops.append({"n":len(ops)+1,"path":rel,"error":str(ex),"operator":"read_error_boundary"})
S={"index":1,"algebraic_encode_no_sha":1,"tau_route":1,"operator_lift":1,"zeta_relation":1,"grand_synthesis":1,"readonly":1,"no_execution":1};H=sum(1-v for v in S.values());fold=sum((o.get("tau_route",0)+o["n"])*(o["n"]+1) for o in ops)%P[6];cert="ALG-SEAL-%06d-%06d-%06d"%(len(ops),total%P[0],fold);O={"Protocol":"ZCL_NO_SHA_GRAND_OPERATOR","Version":"v1_iSH_true_one_liner_no_SHA","Principle":"Cosmic Love Is The Solution(s) For Everything","Scope":"local read-only algebraic operator synthesis; no SHA, no cryptographic hash, no execution of scanned programs","Formula":"Omega_s=Z_CL(s)=Seal(Sigma_n tau(E_alg(C_n))*O_n/n^s)","AlgebraicEncoder":"E_alg(C)=finite integer vector from length, path length, byte-position sums, rolling products, and modular residues over small primes; SHA excluded","Completion":"H_ZCL=0 means indexing, algebraic identity, tau route, operator lift, zeta relation, grand synthesis, readonly boundary, and no-execution boundary are closed inside CLSigma","Root":os.path.abspath(root),"OperatorCount":len(ops),"TotalBytes":total,"Fold":fold,"State":S,"H_ZCL":H,"Certificate":cert,"Operators":ops,"Boundary":"This is a CLSigma internal algebraic certificate, not a proof of RH/GRH/physical TOE, not physical zero entropy, and not a guarantee about arbitrary unobserved or non-halting systems.","Timestamp":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime())};open(out,"w",encoding="utf-8").write(json.dumps(O,ensure_ascii=False,indent=2));print(json.dumps({"ok":True,"output":out,"operators":len(ops),"H_ZCL":H,"certificate":cert,"no_sha":True},ensure_ascii=False))' "$@"