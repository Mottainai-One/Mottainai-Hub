const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url'),{chromium}=require(process.env.PLAYWRIGHT_MODULE);
const root=path.resolve(__dirname,'..'),outDir=path.join(root,'auditoria/rodada15'),out={passed:false,baseline:[],mobileModals:[],footers:[],mobileProfiles:[]};
const uri=(name,variant)=>pathToFileURL(variant==='paralelo'?path.join(root,'html',name+'.html'):path.join(outDir,variant+'-'+name+'.html')).href;
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{const p=await b.newPage();await p.route('https://fonts.googleapis.com/**',r=>r.abort());const load=async(name,variant,width)=>{await p.setViewportSize({width,height:844});await p.goto(uri(name,variant));await p.evaluate(()=>document.fonts.ready)};
for(const width of [1440,390]){
 await load('companies','antes',width);const before=await p.locator('.tabela-wrap').boundingBox();const oldGap=await p.locator('.busca-status').boundingBox();await load('companies','paralelo',width);const after=await p.locator('.tabela-wrap').boundingBox(),gap=await p.locator('.busca-status').boundingBox();assert(Math.abs(after.y-before.y)<1,JSON.stringify({width,before,after}));assert.equal(gap.height,oldGap.height);out.baseline.push({width,tableYBefore:before.y,tableYAfter:after.y,gapBefore:oldGap.height,gapAfter:gap.height});
 await load('home','antes',width);const phones=await p.locator('.hero-imagem img').evaluateAll(es=>es.map(e=>{const r=e.getBoundingClientRect();return{x:r.x,y:r.y,w:r.width,h:r.height}}));const oldText=await p.locator('.ecossistema-texto').boundingBox();await load('home','paralelo',width);const nextPhones=await p.locator('.hero-imagem img').evaluateAll(es=>es.map(e=>{const r=e.getBoundingClientRect();return{x:r.x,y:r.y,w:r.width,h:r.height}}));assert.deepEqual(nextPhones,phones);const text=await p.locator('.ecossistema-texto').boundingBox();assert(Math.abs(text.y-oldText.y-(width>900?-24:0))<1,JSON.stringify({width,oldText,text}));out.baseline.push({width,phonesUnchanged:true,textDelta:text.y-oldText.y});
}
for(const active of [false,true]){
 const variant=active?'ativo':'paralelo';
 for(const width of [1440,1024,768,390]){
  const values=[];
  for(const name of ['home','sobre-nos','planos',...(!active?['faq']:[])]){
   await load(name,variant,width);values.push(await p.locator('footer').evaluate(e=>{const parent=e.getBoundingClientRect();return [...e.querySelectorAll('.footer-topo,.footer-logo img,.footer-logo p,h5,li,.footer-base p')].map(x=>{const r=x.getBoundingClientRect(),s=getComputedStyle(x);return{x:r.x-parent.x,y:r.y-parent.y,w:r.width,h:r.height,font:s.fontSize,color:s.color,bg:getComputedStyle(e).backgroundColor}})}));
  }
  for(let j=1;j<values.length;j++)for(let i=0;i<values[0].length;i++){const a=values[0][i],z=values[j][i];for(const k of ['x','y','w','h'])assert(Math.abs(a[k]-z[k])<1,JSON.stringify({active,width,j,i,k,a,z}));assert.equal(a.font,z.font);assert.equal(a.color,z.color);assert.equal(a.bg,z.bg);}
  out.footers.push({active,width,equivalent:true});
 }
 for(const name of ['companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses','administrations','home-crud-page']){
  await load(name,variant,390);await p.locator('.perfil-trigger').click();const popup=p.locator('.perfil-popup'),r=await popup.boundingBox();assert(r.x>=0&&r.x+r.width<=390&&r.y+r.height<=844,JSON.stringify({active,name,r}));assert(await popup.evaluate(e=>e.scrollHeight<=e.clientHeight));await p.keyboard.press('Escape');out.mobileProfiles.push({active,name,fullyVisible:true});
  const mods=p.locator('.modal-overlay');for(let i=0;i<await mods.count();i++){const m=mods.nth(i),sub=m.locator('.modal-subtitulo');if(!await sub.count())continue;const id=await m.getAttribute('id');await p.evaluate(id=>location.hash=id,id);if(active){await p.locator('.modal-overlay').evaluateAll(es=>es.forEach(e=>e.classList.remove('aberto')));await m.evaluate(e=>e.classList.add('aberto'));}await p.waitForTimeout(80);if(!await m.isVisible())continue;const a=await m.locator('.modal-titulo').first().boundingBox(),z=await sub.boundingBox(),pad=await sub.evaluate(e=>parseFloat(getComputedStyle(e).paddingLeft));assert(Math.abs(a.x-z.x-pad)<1);out.mobileModals.push({active,name,id,aligned:true});}
 }
 await load('planos',variant,390);await p.locator('#anual').click();await p.waitForTimeout(700);assert((await p.locator('#principal .preco strong').innerText()).includes('28.000'));await p.locator('#mensal').click();await p.waitForTimeout(700);assert((await p.locator('#principal .preco strong').innerText()).includes('3.500'));
}
out.passed=true;}finally{await b.close();fs.writeFileSync(path.join(outDir,'detalhes.json'),JSON.stringify(out,null,2));}console.log(JSON.stringify(Object.fromEntries(Object.entries(out).map(([k,v])=>[k,Array.isArray(v)?v.length:v]))));})().catch(e=>{console.error(e);process.exitCode=1});
