const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const {chromium}=require(process.env.PLAYWRIGHT_MODULE),root=path.resolve(__dirname,'..'),outDir=path.join(root,'auditoria/rodada15');
const out={passed:false,layouts:[],modals:[],profiles:[],dashboard:[],footers:[],team:[],home:[],plans:[],hero:[],errors:[]};
const uri=(name,active)=>pathToFileURL(active?path.join(outDir,'ativo-'+name+'.html'):path.join(root,'html',name+'.html')).href;
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{const p=await b.newPage();p.on('pageerror',e=>out.errors.push(String(e)));await p.route('https://fonts.googleapis.com/**',r=>r.abort());
const load=async(name,active,width=1440)=>{await p.setViewportSize({width,height:1000});await p.goto(uri(name,active));await p.evaluate(()=>document.fonts.ready)};
for(const active of [false,true]){
 for(const width of [1440,1024,768,390]){
  for(const name of ['home','planos','sobre-nos',...(!active?['faq']:[])]){
   await load(name,active,width);
   const state=await p.evaluate(()=>({overflow:document.documentElement.scrollWidth>innerWidth+2,broken:[...document.images].filter(i=>!i.complete||!i.naturalWidth).map(i=>i.src),badge:!!document.querySelector('#preview-note,.preview-notice')}));
   assert(!state.overflow,`${active} ${width} ${name} overflow`);assert.equal(state.broken.length,0,JSON.stringify(state.broken));assert(!state.badge);out.layouts.push({active,width,name,...state});
   const footer=await p.locator('footer').evaluate(e=>({logo:e.querySelector('img').getAttribute('src'),links:[...e.querySelectorAll('li')].map(li=>{const a=li.querySelector('a');return{text:li.textContent.trim(),href:a?.href,target:a?.target,rel:a?.rel}})}));
   assert(footer.logo.endsWith('wordmark-mottainai.svg'));assert.equal(footer.links.length,12);assert(footer.links.every(l=>l.href));
   for(const l of footer.links){if(l.href.startsWith('https:')){assert.equal(l.target,'_blank');assert.equal(l.rel,'noopener noreferrer');}}
   assert(footer.links.some(l=>l.href==='https://www.instagram.com/mottainai.estoques/'));assert(footer.links.some(l=>l.href==='https://wa.me/5511993332592'));assert(footer.links.some(l=>l.href.includes('to=mottainai.contato@gmail.com')));
   const headerSrc=await p.locator('body > header img').first().getAttribute('src');assert(headerSrc.endsWith('wordmark-mottainai.svg'));
   out.footers.push({active,width,name,...footer});
   if(name==='home'){
    const text=await p.locator('.ecossistema-texto').evaluate(e=>getComputedStyle(e).transform);if(width>=901)assert(text.includes('-120'),text);out.home.push({active,width,text});
   }
   if(name==='planos'){
    const r=await p.locator('#principal').boundingBox(),halo=await p.locator('#principal .blur').boundingBox();assert(Math.abs(r.x+r.width/2-halo.x-halo.width/2)<1);assert(Math.abs(r.y+r.height/2-halo.y-halo.height/2)<1);
    const pattern=await p.locator('#background-lines').boundingBox();assert.equal(Math.round(pattern.width),762);out.plans.push({active,width,haloCentered:true,pattern});
   }
   if([1440,390].includes(width))await p.screenshot({path:path.join(outDir,`${active?'ativo':'paralelo'}-${name}-${width}.png`),fullPage:true});
  }
 }
 // Anchors entre páginas têm alvo real; os slides abrem na posição correta.
 await load('home',active);const internal=await p.locator('footer a').evaluateAll(es=>es.map(a=>a.href).filter(h=>h.startsWith('file:')));
 for(const href of internal){await p.goto(href);const hash=new URL(href).hash;if(hash){await p.waitForTimeout(750);assert.equal(await p.locator(hash).count(),1,href);if(['#proposta','#nosso-ideal'].includes(hash))assert.equal(await p.locator('.hero-carrossel').getAttribute('data-slide'),hash==='#proposta'?'1':'2');}}
 for(const name of ['companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses','administrations','home-crud-page']){
  await load(name,active);
  assert.equal(await p.locator('.perfil-trigger').count(),1,name);
  await p.locator('.perfil-trigger').click();const popup=p.locator('.perfil-popup');assert(await popup.isVisible());assert.equal(await popup.locator('.perfil-email').innerText(),'admin.preview@example.test');assert.equal(await popup.locator('.perfil-cargo').innerText(),'Administrador do sistema');
  const dims=await popup.evaluate(e=>({w:e.clientWidth,h:e.clientHeight,scroll:e.scrollHeight>e.clientHeight,overflow:getComputedStyle(e).overflow}));assert(!dims.scroll,name+' popup scroll');assert(dims.w<=288);assert.equal(await popup.locator('.perfil-avatar img').count(),1);
  const source=fs.readFileSync(path.join(active?path.resolve(root,'../src/main/webapp/WEB-INF/jsp'):path.join(root,'jsp'),name+'.jsp'),'utf8');assert(source.includes('<form action="${pageContext.request.contextPath}/logout" method="post">'));assert(source.includes('${sessionScope.administrationEmail}'));
  if(name==='home-crud-page')await popup.screenshot({path:path.join(outDir,`${active?'ativo':'paralelo'}-perfil.png`)});
  await p.keyboard.press('Escape');assert(await popup.isHidden());out.profiles.push({active,name,...dims,sessionBinding:true,logoutPost:true});
  if(name==='home-crud-page'){
   const hrefs=await p.locator('a.card-resumo').evaluateAll(es=>es.map(e=>e.getAttribute('href')));assert.equal(hrefs.length,4);for(let i=0;i<4;i++){const expected=['companies','stores','employees','user-accounts'][i];assert(hrefs[i].includes(expected));}out.dashboard.push({active,hrefs});continue;
  }
  const gap=p.locator('.busca-status');if(await gap.count()){assert.equal(await gap.innerText(),'');assert.equal(await gap.getAttribute('aria-hidden'),'true');assert.equal((await gap.boundingBox()).height,16);}
  const modals=p.locator('.modal-overlay');
  for(let i=0;i<await modals.count();i++){
   const m=modals.nth(i),subtitle=m.locator('.modal-subtitulo');if(!await subtitle.count())continue;
   const id=await m.getAttribute('id');await p.evaluate(id=>location.hash=id,id);if(active){await p.locator('.modal-overlay').evaluateAll(es=>es.forEach(e=>e.classList.remove('aberto')));await m.evaluate(e=>e.classList.add('aberto'));}await p.waitForTimeout(100);if(!await m.isVisible())continue;
   const title=m.locator('.modal-titulo').first();const a=await title.boundingBox(),z=await subtitle.boundingBox();const pad=await subtitle.evaluate(e=>parseFloat(getComputedStyle(e).paddingLeft));assert(Math.abs(a.x-z.x-pad)<1,`${active} ${name} ${id}: ${a.x} vs ${z.x}+${pad}`);out.modals.push({active,name,id,x:a.x,subtitleTextX:z.x+pad});
   if(name==='employees'&&id.includes('editar'))await m.screenshot({path:path.join(outDir,`${active?'ativo':'paralelo'}-modal-employee.png`)});
  }
 }
 await load('sobre-nos',active);const initial=p.url(),button=p.locator('.hero-carrossel > .next'),box=await button.boundingBox(),heroBox=await p.locator('.hero-carrossel').boundingBox();
 for(let i=0;i<4;i++){await button.click();await p.waitForTimeout(700);const n=await button.boundingBox();const currentHero=await p.locator('.hero-carrossel').boundingBox();assert(Math.abs(n.x-currentHero.x-box.x+heroBox.x)<1&&Math.abs(n.y-currentHero.y-box.y+heroBox.y)<1,JSON.stringify({active,i,n,currentHero,box,heroBox}));assert.equal(p.url(),initial);assert.equal(await button.evaluate(e=>getComputedStyle(e).backgroundColor),'rgba(0, 0, 0, 0)');}
 out.hero.push({active,fixed:true,transparent:true,noReload:true});
 for(const width of [1440,390]){
  await load('sobre-nos',active,width);const groups=p.locator('.carrossel-wrap');
  for(let i=0;i<2;i++){
   const group=groups.nth(i),track=group.locator('.carrossel'),prev=group.locator('.team-arrow-prev'),next=group.locator('.team-arrow-next');await group.scrollIntoViewIfNeeded();assert(await prev.isHidden());
   const other=await groups.nth(1-i).locator('.carrossel').evaluate(e=>e.scrollLeft);const max=await track.evaluate(e=>e.scrollWidth-e.clientWidth);
   if(max>2){const start=await track.evaluate(e=>e.scrollLeft),r=await next.boundingBox(),t=await track.boundingBox();assert(r.x>=t.x+t.width-1);await next.click();await p.waitForTimeout(170);const middle=await track.evaluate(e=>e.scrollLeft);await p.waitForTimeout(650);const end=await track.evaluate(e=>e.scrollLeft);assert(middle>start&&middle<end,JSON.stringify({active,width,i,start,middle,end}));assert.equal(await groups.nth(1-i).locator('.carrossel').evaluate(e=>e.scrollLeft),other);assert(await prev.isVisible());await prev.click();await p.waitForTimeout(800);assert(await prev.isHidden());for(let j=0;j<12&&await next.isVisible();j++){await next.click();await p.waitForTimeout(800);}assert(await next.isHidden(),JSON.stringify({active,width,i,left:await track.evaluate(e=>e.scrollLeft),max}));}
   out.team.push({active,width,year:i+1,continuous:true,independent:true,extremities:true});
  }
 }
}
assert.equal(out.errors.length,0);out.passed=true;
}finally{await b.close();fs.writeFileSync(path.join(outDir,'visual.json'),JSON.stringify(out,null,2));}console.log(JSON.stringify(Object.fromEntries(Object.entries(out).map(([k,v])=>[k,Array.isArray(v)?v.length:v]))));})().catch(e=>{console.error(e);process.exitCode=1});
