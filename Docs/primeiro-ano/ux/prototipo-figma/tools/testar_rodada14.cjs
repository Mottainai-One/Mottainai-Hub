const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const {chromium}=require(process.env.PLAYWRIGHT_MODULE),root=path.resolve(__dirname,'..'),outDir=path.join(root,'auditoria/rodada14');
const out={passed:false,layouts:[],plans:[],hero:[],team:[],footers:[],errors:[]};
const uri=(name,active)=>pathToFileURL(active?path.join(outDir,'ativo-'+name+'.html'):path.join(root,'html',name+'.html')).href;
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{const p=await b.newPage();p.on('pageerror',e=>out.errors.push(String(e)));await p.route('https://fonts.googleapis.com/**',r=>r.abort());
 const load=async(name,active,width)=>{await p.setViewportSize({width,height:1000});await p.goto(uri(name,active));await p.evaluate(()=>document.fonts.ready)};
 for(const active of [false,true])for(const width of [1440,1024,768,390]){
  let footers=[];
  for(const name of ['home','planos','sobre-nos']){
   await load(name,active,width);
   const issues=await p.evaluate(()=>({overflow:document.documentElement.scrollWidth>innerWidth+2,broken:[...document.images].filter(i=>!i.complete||!i.naturalWidth).map(i=>i.src),badge:!!document.querySelector('#preview-note,.preview-notice')}));
   assert(!issues.overflow,`${active} ${width} ${name} overflow`);assert.equal(issues.broken.length,0,JSON.stringify(issues.broken));assert(!issues.badge);
   if([1440,390].includes(width))await p.screenshot({path:path.join(outDir,`${active?'ativo':'paralelo'}-${name}-${width}.png`),fullPage:true});
   out.layouts.push({active,width,name,...issues});
   footers.push(await p.locator('footer').evaluate(e=>{const f=e.getBoundingClientRect();return [...e.querySelectorAll('.footer-topo,.footer-logo img,.footer-logo p,h5,li,.footer-base p')].map(x=>{const r=x.getBoundingClientRect(),s=getComputedStyle(x);return{text:x.textContent.trim(),x:r.x-f.x,y:r.y-f.y,w:r.width,h:r.height,font:s.fontSize,color:s.color,background:getComputedStyle(e).backgroundColor}})}));
   if(name==='planos'){
    assert.equal(await p.locator('.card-plano').count(),3);assert.equal(await p.locator('.btn-plano[href*="mail.google.com"]').count(),3);
    for(const a of await p.locator('a[href*="mail.google.com"]').all()){const u=new URL(await a.getAttribute('href'));assert.equal(u.searchParams.get('to'),'mottainai.contato@gmail.com');}
    const cta=p.locator('#duvidas .btn-contato');assert.equal(await cta.evaluate(e=>getComputedStyle(e).backgroundColor),'rgb(16, 42, 67)');assert.equal(await cta.evaluate(e=>getComputedStyle(e,'::after').content),'none');
    await p.locator('#anual').click();await p.waitForTimeout(200);const partial=await p.locator('#principal .preco strong').innerText();await p.waitForTimeout(500);assert((await p.locator('#principal .preco strong').innerText()).includes('28.000'));assert.equal(await p.locator('#anual').getAttribute('aria-pressed'),'true');
    await p.locator('#mensal').click();await p.waitForTimeout(700);assert((await p.locator('#principal .preco strong').innerText()).includes('3.500'));
    if(width<=1024){assert.equal(await p.locator('.card-plano:visible').count(),1);await p.locator('#seta-proximo').click();assert.equal(await p.locator('.card-plano.visivel .nome').innerText(),'Enterprise');await p.locator('#seta-anterior').click();assert.equal(await p.locator('.card-plano.visivel .nome').innerText(),'Professional');}
    else assert.equal(await p.locator('.card-plano:visible').count(),3);
    out.plans.push({active,width,priceAnimationIntermediate:partial,carousel:width<=1024});
   }
  }
  for(let j=1;j<footers.length;j++)for(let i=0;i<footers[0].length;i++){
   const a=footers[0][i],z=footers[j][i];assert(z,`footer faltando ${i}`);for(const k of ['x','y','w','h'])assert(Math.abs(a[k]-z[k])<1,`footer ${active} ${width} ${j} ${i} ${k} ${a[k]} / ${z[k]}`);assert.equal(a.font,z.font);assert.equal(a.color,z.color);assert.equal(a.background,z.background);
  }out.footers.push({active,width,equivalent:true});
 }
 for(const active of [false,true]){
  await load('sobre-nos',active,1440);let initial=p.url();const box=await p.locator('.hero-carrossel > .next').boundingBox();
  for(let i=0;i<4;i++){await p.locator('.hero-carrossel > .next').click();await p.mouse.move(0,0);await p.waitForTimeout(700);assert.equal(await p.locator('.hero-carrossel').getAttribute('data-slide'),String((i+1)%4));assert.equal(p.url(),initial);const r=await p.locator('.hero-carrossel > .next').boundingBox();assert(Math.abs(r.x-box.x)<1&&Math.abs(r.y-box.y)<1);}
  const dots=await p.locator('.car-dots button').evaluateAll(es=>es.map(e=>({fill:getComputedStyle(e).backgroundColor,border:getComputedStyle(e).borderTopColor})));assert(dots.every(d=>d.fill===d.border));
  await p.evaluate(()=>document.activeElement.blur());await p.locator('footer').scrollIntoViewIfNeeded();await p.mouse.move(0,990);await p.waitForTimeout(7500);assert.equal(await p.locator('.hero-carrossel').getAttribute('data-slide'),'1');out.hero.push({active,manual:true,automatic:true,fixedArrows:true,noReload:true});
  await load('sobre-nos',active,390);const groups=p.locator('.carrossel-wrap');assert.equal(await groups.count(),2);
  for(let i=0;i<2;i++){
   const g=groups.nth(i),track=g.locator('.carrossel'),prev=g.locator('.team-arrow-prev'),next=g.locator('.team-arrow-next');await g.scrollIntoViewIfNeeded();assert(await prev.isHidden());assert(await next.isVisible());const other=await groups.nth(1-i).locator('.carrossel').evaluate(e=>e.scrollLeft);
   const r=await next.boundingBox(),t=await track.boundingBox();assert(r.x>=t.x+t.width-1,'seta sobre foto');await next.click();await p.waitForTimeout(800);assert(await prev.isVisible());assert.equal(await groups.nth(1-i).locator('.carrossel').evaluate(e=>e.scrollLeft),other);
   await track.evaluate(e=>e.scrollTo({left:e.scrollWidth,behavior:'instant'}));await p.waitForTimeout(150);assert(await next.isHidden());assert(await prev.isVisible());const l=await prev.boundingBox();assert(l.x+l.width<=t.x+1);await track.evaluate(e=>e.scrollTo({left:0,behavior:'instant'}));await p.waitForTimeout(150);assert(await prev.isHidden());out.team.push({active,year:i+1,start:true,middle:true,end:true,independent:true,noPhotoOverlap:true});
  }
 }
 assert.equal(out.errors.length,0);out.passed=true;
}finally{await b.close();fs.writeFileSync(path.join(outDir,'visual.json'),JSON.stringify(out,null,2))}console.log(JSON.stringify({passed:out.passed,layouts:out.layouts.length,plans:out.plans.length,footers:out.footers.length,hero:out.hero.length,team:out.team.length}));})().catch(e=>{console.error(e);process.exitCode=1});
