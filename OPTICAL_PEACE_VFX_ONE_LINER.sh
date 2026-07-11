python3 - <<'PY'
import math,json,wave,struct,os
W,H,N=960,540,90
out='optical_peace_vfx_frames'
os.makedirs(out,exist_ok=True)
def pix(x,y,t):
    cx,cy=600,210; sx,sy=405,218; tx=170+620*t; ty=410-260*t
    dx,dy=tx-sx,ty-sy; L=max((dx*dx+dy*dy)**0.5,1); d=abs((x-sx)*dy-(y-sy)*dx)/L; p=((x-sx)*dx+(y-sy)*dy)/(L*L)
    bg=42+28*y/H
    visor=abs(y-cy)<18 and abs(x-cx)<120
    head=((x-cx)/150)**2+((y-cy+25)/130)**2<1 and y<330
    beam=d<5 and 0<=p<=1
    bloom=((x-tx)**2+(y-ty)**2)**0.5
    v=bg
    if head:v=max(v,105)
    if visor:v=max(v,18)
    if beam:v=245
    if bloom<95:v=min(255,max(v,int(255*(1-bloom/115))))
    if x%80<2 or y%80<2:v=max(v,70)
    return max(0,min(255,int(v)))
for k in range(N):
    t=k/(N-1)
    fn=f'{out}/frame_{k:03d}.ppm'
    with open(fn,'wb') as f:
        f.write(f'P6\n{W} {H}\n255\n'.encode())
        for y in range(H):
            row=bytearray()
            for x in range(W):
                v=pix(x,y,t); row+=bytes([v,v,v])
            f.write(row)
meta={'Protocol':'OpticalPeaceVFX','Purpose':'nonviolent black-and-white symbolic projection effect','Formula':'1/f=1/u+1/v; A=I+B/2-1; Omega_peace=Z_CL^peace(s)','Boundary':'visual effect only; no weapon, no targeting, no blinding, no military guidance','Frames':N,'OutputDirectory':out}
open('optical_peace_vfx_manifest.json','w').write(json.dumps(meta,indent=2))
print(json.dumps(meta,indent=2))
PY