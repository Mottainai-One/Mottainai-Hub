const {chromium}=require(process.env.PLAYWRIGHT_MODULE),path=require('node:path'),fs=require('node:fs'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const root=path.resolve(__dirname,'..'),out=path.join(root,'auditoria/rodada20'),pages=['companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses','administrations'],result={passed:false,modals:[],views:[],deletions:[],errors:[]};
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{const p=await b.newPage();p.on('pageerror',e=>result.errors.push(String(e)));await p.route('https://fonts.googleapis.com/**',r=>r.abort());
for(const active of [false,true])for(const width of [1440,768,390])for(const name of pages){
 await p.setViewportSize({width,height:1000});const url=pathToFileURL(active?path.join(out,'ativo-'+name+'.html'):path.join(root,'html',name+'.html')).href;await p.goto(url);await p.evaluate(()=>document.fonts.ready);
 const list=p.locator('.modal-overlay');for(let i=0;i<await list.count();i++){
  const m=list.nth(i),id=await m.getAttribute('id');if(!await m.locator('.modal-fechar').count())continue;
  await p.locator('.modal-overlay').evaluateAll(es=>es.forEach(e=>e.classList.remove('aberto')));await p.evaluate(id=>location.hash=id,id);if(active)await m.evaluate(e=>e.classList.add('aberto'));await p.waitForTimeout(230);
  if(!await m.isVisible())continue;
  const modal=m.locator('.modal').first(),close=m.locator('.modal-fechar').first(),a=await modal.boundingBox(),x=await close.boundingBox(),top=x.y-a.y,right=a.x+a.width-x.x-x.width;
  assert(Math.abs(top-right)<1,JSON.stringify({active,width,name,id,top,right,a,x}));assert.equal(await close.getAttribute('aria-label'),'Fechar');
  result.modals.push({active,width,name,id,top,right});
  if(id.endsWith('-ver')){
   const title=m.locator('.modal-cabecalho h2,.modal-cabecalho h3').first(),data=m.locator('.detalhe-label').first();const t=await title.boundingBox();const d=await (await data.count()?data:modal.locator(':scope > p').first()).boundingBox();assert(Math.abs(t.x-d.x)<1,JSON.stringify({active,width,name,t,d}));const sub=m.locator('.modal-subtitulo');if(await sub.count()){const z=await sub.boundingBox();assert(Math.abs(z.x-d.x)<1);assert.equal(await sub.evaluate(e=>getComputedStyle(e).paddingLeft),'0px');}
   result.views.push({active,width,name,left:t.x,aligned:true});
  }
  if(id.endsWith('-excluir')){assert.equal(await close.getAttribute('href'),await m.locator('.modal-rodape a').getAttribute('href'));result.deletions.push({active,width,name,closeCancels:true});}
  if(name==='companies'&&width===1440&&(id.endsWith('-ver')||id.endsWith('-excluir')))await modal.screenshot({path:path.join(out,`${active?'ativo':'paralelo'}-${id}.png`)});
 }
}
assert.equal(result.errors.length,0);result.passed=true;
}finally{await b.close();fs.writeFileSync(path.join(out,'visual.json'),JSON.stringify(result,null,2));}console.log(JSON.stringify({passed:result.passed,modals:result.modals.length,views:result.views.length,deletions:result.deletions.length,errors:result.errors.length}));})().catch(e=>{console.error(e);process.exitCode=1});
