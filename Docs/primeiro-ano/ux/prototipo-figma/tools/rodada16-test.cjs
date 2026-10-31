const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url'),{chromium}=require(process.env.PLAYWRIGHT_MODULE);
const root=path.resolve(__dirname,'..'),outDir=path.join(root,'auditoria/rodada16'),out={passed:false,layouts:[],alignment:[],team:[],contacts:[],errors:[]};
const uri=(name,active)=>pathToFileURL(active?path.join(outDir,'ativo-'+name+'.html'):path.join(root,'html',name+'.html')).href;
(async()=>{const browser=await chromium.launch({channel:'chrome',headless:true});try{const p=await browser.newPage();p.on('pageerror',e=>out.errors.push(String(e)));await p.route('https://fonts.googleapis.com/**',r=>r.abort());
 const load=async(name,active,width)=>{await p.setViewportSize({width,height:1000});await p.goto(uri(name,active));await p.evaluate(()=>document.fonts.ready)};
 for(const active of [false,true])for(const width of [1440,1024,768,390])for(const name of ['home','sobre-nos','planos',...(!active?['faq']:[])]){
  await load(name,active,width);
  const state=await p.evaluate(()=>({overflow:document.documentElement.scrollWidth>innerWidth+2,broken:[...document.images].filter(i=>!i.complete||!i.naturalWidth).map(i=>i.src),footer:getComputedStyle(document.querySelector('footer')).backgroundColor,headerLogo:document.querySelector('body > header img').getAttribute('src'),footerLogo:document.querySelector('footer img').getAttribute('src'),links:[...document.querySelectorAll('footer li a')].map(a=>a.getAttribute('href'))}));
  assert(!state.overflow,`${active}/${name}/${width}: overflow`);assert.equal(state.broken.length,0,JSON.stringify(state.broken));assert.equal(state.footer,'rgb(245, 247, 250)');assert(state.headerLogo.endsWith('mottainai-logo-completo.svg'));assert(state.footerLogo.endsWith('mottainai-wordmark-rodape.svg'));assert.equal(state.links.length,12);
  const contact=p.locator('body > header a[href*="mail.google.com"]');assert.equal(await contact.count(),1,`${active}/${name}: contato`);assert.equal(await contact.getAttribute('target'),'_blank');assert.equal(await contact.getAttribute('rel'),'noopener noreferrer');const u=new URL(await contact.getAttribute('href'));assert.equal(u.searchParams.get('to'),'mottainai.contato@gmail.com');
  if(name==='home'&&width>=1024){const text=await p.locator('.hero-texto').boundingBox(),hero=await p.locator('main > .hero').boundingBox(),first=await p.locator('.cards-sistema .card').first().boundingBox(),last=await p.locator('.cards-sistema .card').last().boundingBox(),pad=await p.locator('main > .hero').evaluate(e=>parseFloat(getComputedStyle(e).paddingRight));assert(Math.abs(first.x-text.x)<1,JSON.stringify({active,width,text,first}));assert(Math.abs(last.x+last.width-hero.x-hero.width+pad)<1,JSON.stringify({active,width,hero,last,pad}));out.alignment.push({active,width,left:first.x,right:last.x+last.width});}
  out.layouts.push({active,width,name,...state});if([1440,390].includes(width))await p.screenshot({path:path.join(outDir,`${active?'ativo':'paralelo'}-${name}-${width}.png`),fullPage:true});
 }
 for(const active of [false,true])for(const width of [1440,1024,768,390]){
  await load('sobre-nos',active,width);const groups=p.locator('.carrossel-wrap');assert.equal(await groups.count(),2);
  for(let i=0;i<2;i++){
   const g=groups.nth(i),viewport=g.locator('.team-viewport'),track=g.locator('.team-track'),prev=g.locator('.team-arrow-prev'),next=g.locator('.team-arrow-next');await g.scrollIntoViewIfNeeded();assert(await prev.isHidden());
   assert.equal(await viewport.evaluate(e=>getComputedStyle(e).overflowX),'hidden');const total=await track.locator('.cartoes').count();const other=await groups.nth(1-i).locator('.team-track').evaluate(e=>e.style.transform);const max=await track.evaluate(e=>e.scrollWidth-e.clientWidth);
   if(max>1){assert(await next.isVisible());const arrow=await next.boundingBox(),v=await viewport.boundingBox();assert(arrow.x>=v.x+v.width-1,'seta não pode cobrir fotos');const initial=await track.locator('.cartoes').evaluateAll(es=>es.map(e=>e.getBoundingClientRect().x));
    await next.click();await p.waitForTimeout(260);const middle=await track.locator('.cartoes').evaluateAll(es=>es.map(e=>e.getBoundingClientRect().x));const clipping=await viewport.evaluate(v=>{const r=v.getBoundingClientRect();return [...v.querySelectorAll('.cartoes')].some(e=>{const c=e.getBoundingClientRect();return c.left<r.right&&c.right>r.left&&((c.left<r.left&&c.right>r.left)||(c.left<r.right&&c.right>r.right))})});
    if(width===1440)await g.screenshot({path:path.join(outDir,`${active?'ativo':'paralelo'}-equipe-${i+1}-durante.png`)});
    await p.waitForTimeout(700);const final=await track.locator('.cartoes').evaluateAll(es=>es.map(e=>e.getBoundingClientRect().x));assert(middle[0]<initial[0]&&middle[0]>final[0],JSON.stringify({active,width,i,initial,middle,final}));assert(clipping,'sem card parcial durante movimento');
    for(let j=1;j<total;j++)assert(Math.abs((middle[j]-initial[j])-(middle[0]-initial[0]))<1,'conjunto não se move como track único');
    assert.equal(await track.locator('.cartoes').count(),total);assert.equal(await groups.nth(1-i).locator('.team-track').evaluate(e=>e.style.transform),other);const a=await next.boundingBox();if(a)assert(Math.abs(a.x-arrow.x)<1&&Math.abs(a.y-arrow.y)<1,'seta não está fixa');
    await prev.click();await p.waitForTimeout(900);assert(await prev.isHidden());
    for(let n=0;n<12&&await next.isVisible();n++){await next.click();await p.waitForTimeout(900);}assert(await next.isHidden());assert(await prev.isVisible());
    await viewport.focus();await p.keyboard.press('Home');await p.waitForTimeout(900);assert(await prev.isHidden());await p.keyboard.press('End');await p.waitForTimeout(900);assert(await next.isHidden());
   }else assert(await next.isHidden());
   out.team.push({active,width,year:i+1,transform:true,continuous:true,partialDuringMotion:true,fixedArrows:true,independent:true,limits:true});
  }
 }
 // Cliques reais do contato; destino interceptado somente no teste, sem operar conta externa.
 await p.context().route('https://mail.google.com/**',r=>r.fulfill({contentType:'text/plain',body:'Destino validado'}));
 for(const active of [false,true])for(const name of ['home','sobre-nos','planos',...(!active?['faq']:[])]){await load(name,active,1440);const [popup]=await Promise.all([p.waitForEvent('popup'),p.locator('body > header a[href*="mail.google.com"]').click()]);await popup.waitForLoadState();assert.equal(new URL(popup.url()).searchParams.get('to'),'mottainai.contato@gmail.com');await popup.close();out.contacts.push({active,name,composeURL:true,externalAccountNotOperated:true});}
 assert.equal(out.errors.length,0);out.passed=true;
}finally{await browser.close();fs.writeFileSync(path.join(outDir,'visual.json'),JSON.stringify(out,null,2));}console.log(JSON.stringify(Object.fromEntries(Object.entries(out).map(([k,v])=>[k,Array.isArray(v)?v.length:v]))));})().catch(e=>{console.error(e);process.exitCode=1});
