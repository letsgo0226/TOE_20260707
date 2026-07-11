python3 -c 'import os,sys,hashlib,json,math;R=sys.argv[1] if len(sys.argv)>1 else ".";O=sys.argv[2] if len(sys.argv)>2 else "zcl_godel_exact_operator_certificate.json";E={".sh",".py",".json",".md",".txt",".yml",".yaml"};F=[]
for d,_,fs in os.walk(R):
 for f in fs:
  p=os.path.join(d,f);x=os.path.splitext(f)[1].lower()
  if x in E:
   try:b=open(p,"rb").read();r=os.path.relpath(p,R);g=int(hashlib.sha256(r.encode()+b).hexdigest(),16);n=len(F)+1;F.append({"n":n,"path":r,"G":str(g),"Z_num":"G_%d"%n,"Z_den":"%d^s"%n,"O":"O_%d"%n,"h":hashlib.sha256(b).hexdigest()})
   except Exception:pass
S="+".join(["G_%d/%d^s"%(i+1,i+1) for i in range(len(F))]) or "0";C=hashlib.sha512(json.dumps(F,sort_keys=True).encode()).hexdigest();P={"Protocol":"ZCL_GODEL_EXACT_COMPACT_ONE_LINER","Scope":"lossless_compact_local_readonly_operator_lift","Formula":"Z_CL(s)=Seal(Sum_n G(C_n)/n^s)","AlgebraicRelation":"n^s*term_n=G(C_n); O_n=(G(C_n),path,hash); Omega_s=Z_CL(s)","Root":R,"Files":len(F),"Operators":F,"H_TOE":0,"Boundary":"readonly; no execution; no network; no medical/physical/math proof claim","Certificate":C};open(O,"w",encoding="utf-8").write(json.dumps(P,ensure_ascii=False,separators=(",",":")));print(O,C)'