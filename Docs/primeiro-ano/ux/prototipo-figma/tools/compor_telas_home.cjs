// Composição determinística das telas exportadas: sem gerar ou redesenhar interfaces.
const fs=require('node:fs'),path=require('node:path');
const {chromium}=require(process.env.PLAYWRIGHT_MODULE);
const root=path.resolve(__dirname,'..'),dir=path.join(root,'auditoria/rodada11');
const uri=f=>'data:image/png;base64,'+fs.readFileSync(path.join(dir,f)).toString('base64');
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{
 const p=await b.newPage();
 for(const [side,screen,mirror] of [['left','mobile-profile-screen.png',true],['right','mobile-lo-screen.png',false]]){
  const result=await p.evaluate(async({base,screen,mirror})=>{
   const load=src=>new Promise((resolve,reject)=>{const i=new Image();i.onload=()=>resolve(i);i.onerror=reject;i.src=src});
   const [img,ui]=await Promise.all([load(base),load(screen)]),w=img.width,h=img.height;
   const c=document.createElement('canvas');c.width=w;c.height=h;const ctx=c.getContext('2d',{willReadFrequently:true});ctx.drawImage(img,0,0);
   const data=ctx.getImageData(0,0,w,h),pixels=data.data,mask=new Uint8Array(w*h),queue=new Int32Array(w*h);let head=0,tail=0;
   const light=i=>{let j=i*4;return pixels[j]>175&&pixels[j+1]>170&&pixels[j+2]>160&&Math.max(pixels[j],pixels[j+1],pixels[j+2])-Math.min(pixels[j],pixels[j+1],pixels[j+2])<85};
   const seed=1200*w+450;queue[tail++]=seed;mask[seed]=1;
   while(head<tail){let i=queue[head++],x=i%w;for(const n of [x?i-1:-1,x<w-1?i+1:-1,i-w,i+w])if(n>=0&&n<w*h&&!mask[n]&&light(n)){mask[n]=1;queue[tail++]=n}}
   if(tail<500000)throw new Error('Máscara interna não encontrada: '+tail);
   // Preenche somente buracos internos (letras/ícones da tela antiga); notch e carcaça ficam fora.
   const outside=new Uint8Array(w*h);head=0;tail=0;queue[tail++]=0;outside[0]=1;
   while(head<tail){let i=queue[head++],x=i%w;for(const n of [x?i-1:-1,x<w-1?i+1:-1,i-w,i+w])if(n>=0&&n<w*h&&!mask[n]&&!outside[n]){outside[n]=1;queue[tail++]=n}}
   // Homografia inversa do plano da tela fotografada. A perspectiva é do aparelho original.
   const quad=[[624,40],[1260,143],[665,1556],[28,1425]];
   const src=[[0,0],[1,0],[1,1],[0,1]],A=[],v=[];
   for(let i=0;i<4;i++){const [x,y]=quad[i],[u,z]=src[i];A.push([x,y,1,0,0,0,-u*x,-u*y]);v.push(u);A.push([0,0,0,x,y,1,-z*x,-z*y]);v.push(z)}
   for(let k=0;k<8;k++){let m=k;for(let j=k+1;j<8;j++)if(Math.abs(A[j][k])>Math.abs(A[m][k]))m=j;[A[k],A[m]]=[A[m],A[k]];[v[k],v[m]]=[v[m],v[k]];let d=A[k][k];for(let j=k;j<8;j++)A[k][j]/=d;v[k]/=d;for(let i=0;i<8;i++)if(i!==k){let f=A[i][k];for(let j=k;j<8;j++)A[i][j]-=f*A[k][j];v[i]-=f*v[k]}}
   const sc=document.createElement('canvas');sc.width=ui.width;sc.height=ui.height;const sx=sc.getContext('2d');sx.fillStyle='#f6f7fa';sx.fillRect(0,0,sc.width,sc.height);sx.drawImage(ui,0,0);const s=sx.getImageData(0,0,sc.width,sc.height).data;
   let replaced=0;for(let y=0;y<h;y++)for(let x=0;x<w;x++){const i=y*w+x;if(outside[i])continue;const d=v[6]*x+v[7]*y+1;let u=(v[0]*x+v[1]*y+v[2])/d,z=(v[3]*x+v[4]*y+v[5])/d;if(mirror)u=1-u;
    const px=Math.max(0,Math.min(ui.width-1,u*(ui.width-1))),py=Math.max(0,Math.min(ui.height-1,z*(ui.height-1))),ix=Math.floor(px),iy=Math.floor(py),fx=px-ix,fy=py-iy;
    for(let k=0;k<3;k++){const at=(a,b)=>s[(Math.min(ui.height-1,b)*ui.width+Math.min(ui.width-1,a))*4+k];pixels[i*4+k]=(1-fy)*((1-fx)*at(ix,iy)+fx*at(ix+1,iy))+fy*((1-fx)*at(ix,iy+1)+fx*at(ix+1,iy+1));}replaced++;
   }ctx.putImageData(data,0,0);return{png:c.toDataURL().split(',')[1],replaced,width:w,height:h,quad,mirror};
  },{base:uri(side+'-raw-0.png'),screen:uri(screen),mirror});
  fs.writeFileSync(path.join(dir,side+'-source-updated.png'),Buffer.from(result.png,'base64'));delete result.png;fs.writeFileSync(path.join(dir,side+'-mapping.json'),JSON.stringify(result,null,2));
 }
 const monitor=await p.evaluate(async({base,screen})=>{const load=src=>new Promise(r=>{const i=new Image();i.onload=()=>r(i);i.src=src});const [a,s]=await Promise.all([load(base),load(screen)]);const c=document.createElement('canvas');c.width=a.width;c.height=a.height;const x=c.getContext('2d');x.drawImage(a,0,0);const slot={x:45,y:40,w:1980,h:1078};x.fillStyle='#102a40';x.fillRect(slot.x,slot.y,slot.w,slot.h);const scale=Math.min(slot.w/s.width,slot.h/s.height),w=s.width*scale,h=s.height*scale;x.drawImage(s,slot.x+(slot.w-w)/2,slot.y+(slot.h-h)/2,w,h);return c.toDataURL().split(',')[1]},{base:uri('monitor-raw-0.png'),screen:uri('desktop-predictive-alerts-screen.png')});
 fs.writeFileSync(path.join(dir,'monitor-source-updated.png'),Buffer.from(monitor,'base64'));
}finally{await b.close()}})().catch(e=>{console.error(e);process.exitCode=1});
