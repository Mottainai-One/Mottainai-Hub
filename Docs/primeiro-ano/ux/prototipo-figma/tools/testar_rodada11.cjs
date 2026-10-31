// Verificação local; este arquivo não é carregado pela aplicação.
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict');
const {pathToFileURL}=require('node:url'),{chromium}=require(process.env.PLAYWRIGHT_MODULE);
const root=path.resolve(__dirname,'..'),dir=path.join(root,'auditoria/rodada11');
const pairs={'home-mobile-profile-camila.png':'home-mobile-perfil.png','home-mobile-lo-conversation.png':'home-mobile-assistente.png','home-monitor-predictive-alerts.png':'home-painel-web.png'};
const out={passed:false,cases:[],errors:[]};
const geometry=()=>Object.fromEntries(['body > header','main > .hero','.hero-texto','#mock-left','#mock-right','#sistema','.estatistica','#funcionalidades','.ecossistema','.cta-final','.cta-final-imagem','#ecossistema-linha','#cta-final-linha','body > footer'].map(s=>{const e=document.querySelector(s),r=e?.getBoundingClientRect();return[s,r?{x:r.x,y:r.y,w:r.width,h:r.height}:null]}));
(async()=>{const browser=await chromium.launch({channel:'chrome',headless:true});try{
 const p=await browser.newPage();p.on('pageerror',e=>out.errors.push(String(e)));await p.route('https://fonts.googleapis.com/**',r=>r.abort());
 for(const active of [false,true])for(const width of [1440,1024,768,390]){
  await p.setViewportSize({width,height:1000});await p.goto(pathToFileURL(active?path.join(dir,'ativo-home.html'):path.join(root,'html/home.html')).href);await p.evaluate(()=>document.fonts.ready);
  const after=await p.evaluate(geometry),assets=await p.locator('#mock-left,#mock-right,.cta-final-imagem > img:not(.mascote-cta)').evaluateAll(es=>es.map(e=>({src:e.src,w:e.naturalWidth,h:e.naturalHeight,loaded:e.complete})));
  assert.equal(assets.length,3);for(const name of Object.keys(pairs))assert(assets.some(a=>a.src.endsWith(name)&&a.loaded&&a.w>1000));
  assert.equal(await p.locator('.marca-monitor,.marca-monitor-icone').count(),0,'Marca antiga não pode cobrir a nova tela');
  assert(await p.evaluate(()=>[...document.images].every(i=>i.complete&&i.naturalWidth>0)));
  const overflow=await p.evaluate(()=>document.documentElement.scrollWidth>innerWidth+2);assert(!overflow);
  if([1440,390].includes(width))await p.screenshot({path:path.join(dir,(active?'ativo':'paralelo')+'-home-'+width+'.png'),fullPage:true});
  await p.evaluate(async pairs=>{for(const e of document.querySelectorAll('#mock-left,#mock-right,.cta-final-imagem > img:not(.mascote-cta)'))for(const [a,b]of Object.entries(pairs))if(e.src.endsWith(a)){e.src=e.src.replace(a,b);await e.decode()}},pairs);
  const before=await p.evaluate(geometry);let maxDelta=0;for(const key in after){if(!after[key])continue;for(const prop of ['x','y','w','h']){const delta=Math.abs(after[key][prop]-before[key][prop]);maxDelta=Math.max(maxDelta,delta);assert(delta<1,`${active} ${width} ${key}.${prop}: ${delta}`)}}
  out.cases.push({active,width,assets,maxDelta,overflow});
 }
 await p.setViewportSize({width:1440,height:1000});await p.goto(pathToFileURL(path.join(root,'html/home.html')).href);await p.locator('.cta-botoes label[for="login"]').click();assert(await p.locator('#login').isChecked());await p.locator('#login-form label[for="cadastro"]').click();assert(await p.locator('#cadastro').isChecked());out.loginInteraction=true;
 assert.equal(out.errors.length,0);out.passed=true;
}finally{await browser.close();fs.writeFileSync(path.join(dir,'visual.json'),JSON.stringify(out,null,2))}console.log(JSON.stringify({passed:out.passed,cases:out.cases.length,login:out.loginInteraction}));})().catch(e=>{console.error(e);process.exitCode=1});
