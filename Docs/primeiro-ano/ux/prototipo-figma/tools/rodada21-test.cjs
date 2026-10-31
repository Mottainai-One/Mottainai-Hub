const {chromium}=require(process.env.PLAYWRIGHT_MODULE),fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const root=path.resolve(__dirname,'..'),out=path.join(root,'auditoria/rodada21'),result={passed:false,cases:[],errors:[]};
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{const p=await b.newPage();await p.route('https://fonts.googleapis.com/**',r=>r.abort());p.on('pageerror',e=>result.errors.push(String(e)));
for(const active of [false,true])for(const width of [1440,1024,768,635,390]){
 await p.setViewportSize({width,height:1000});await p.goto(pathToFileURL(active?path.join(out,'ativo-sobre-nos.html'):path.join(root,'html/sobre-nos.html')).href);await p.evaluate(()=>document.fonts.ready);await p.waitForTimeout(100);
 const groups=p.locator('.carrossel-wrap');for(let year=0;year<2;year++){
  const g=groups.nth(year),t=g.locator('.team-track'),cards=t.locator('.cartoes:not([data-team-clone])'),next=g.locator('.team-arrow-next'),prev=g.locator('.team-arrow-prev');await g.scrollIntoViewIfNeeded();
  const count=await cards.count(),initial=await cards.evaluateAll(es=>es.map(e=>e.getBoundingClientRect().x)),arrow=await next.boundingBox(),other=await groups.nth(1-year).locator('.team-track').getAttribute('data-index');
  await next.click();await p.waitForTimeout(220);
  const state=await cards.evaluateAll(es=>es.map(e=>{const r=e.getBoundingClientRect();return{x:r.x,right:r.right,returning:e.hasAttribute('data-returning'),z:Number(getComputedStyle(e).zIndex),caption:getComputedStyle(e.querySelector('strong')).visibility,img:getComputedStyle(e.querySelector('img')).visibility}}));
  assert(state[0].returning);assert(state[0].x>initial[0],JSON.stringify({active,width,year,initial,state}));assert(state[1].x<initial[1],'fila não avança');assert(state[0].z<state[1].z);assert.equal(state[0].caption,'hidden');assert.equal(state[0].img,'visible');
  assert(state.slice(1).some(c=>c.x<state[0].right&&c.right>state[0].x),'imagens não se cruzam');
  if(width===1440)await g.screenshot({path:path.join(out,`${active?'ativo':'paralelo'}-equipe-${year+1}-durante.png`)});
  await p.waitForTimeout(750);assert.equal(await t.getAttribute('data-index'),'1');assert.equal(await groups.nth(1-year).locator('.team-track').getAttribute('data-index'),other);assert.equal(await t.locator('[data-returning]').count(),0);
  const a=await next.boundingBox();assert(Math.abs(a.x-arrow.x)<1&&Math.abs(a.y-arrow.y)<1);assert.equal(a.width,arrow.width);
  await prev.click();await p.waitForTimeout(950);assert.equal(await t.getAttribute('data-index'),'0');await prev.click();await p.waitForTimeout(950);assert.equal(await t.getAttribute('data-index'),String(count-1));await next.click();await p.waitForTimeout(950);assert.equal(await t.getAttribute('data-index'),'0');assert(await prev.isVisible());assert(await next.isVisible());
  if(width===1440)await g.screenshot({path:path.join(out,`${active?'ativo':'paralelo'}-equipe-${year+1}-repouso.png`)});
  result.cases.push({active,width,year:year+1,rearImageCrossesBehind:true,normalCardsAdvance:true,captionsClean:true,arrowsUnchanged:true,circular:true,independent:true});
 }
}
assert.equal(result.errors.length,0);result.passed=true;
}finally{await b.close();fs.writeFileSync(path.join(out,'visual.json'),JSON.stringify(result,null,2));}console.log(JSON.stringify({passed:result.passed,cases:result.cases.length,errors:result.errors.length}));})().catch(e=>{console.error(e);process.exitCode=1});
