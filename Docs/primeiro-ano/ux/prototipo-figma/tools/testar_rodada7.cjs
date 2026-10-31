const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const {chromium}=require(process.env.PLAYWRIGHT_MODULE),root=path.resolve(__dirname,'..'),dir=path.join(root,'auditoria/rodada7');
const before=JSON.parse(fs.readFileSync(path.join(dir,'layout-antes.json'))),out={home:[],profiles:[],errors:[],passed:false};
const admins=['home-crud-page','companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses','administrations'];
const url=name=>pathToFileURL(path.join(root,'html',name+'.html')).href;
const near=(a,b,label)=>assert(Math.abs(a-b)<.6,`${label}: ${a} vs ${b}`);
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{
 const p=await b.newPage();p.on('pageerror',e=>out.errors.push(String(e)));
 for(const width of [1440,1024,768,390]){
  await p.setViewportSize({width,height:1000});await p.goto(url('home'));await p.evaluate(()=>document.fonts.ready);
  const x=await p.evaluate(()=>{const box=s=>{const r=document.querySelector(s).getBoundingClientRect();return{x:r.x,y:r.y,w:r.width,h:r.height}};return{width:innerWidth,overflow:document.documentElement.scrollWidth>innerWidth+1,images:[...document.images].filter(i=>!i.complete||!i.naturalWidth).length,hero:box('.hero-texto'),cta:box('.cta-final-texto'),monitor:box('.cta-final-imagem'),footer:box('body > footer'),logo:box('.footer-wordmark'),columns:[...document.querySelectorAll('.footer-coluna')].map(e=>({x:e.getBoundingClientRect().x,y:e.getBoundingClientRect().y})),heroLefts:['.hero-texto h1','.hero-texto p','.hero-botoes'].map(s=>box(s).x),ctaLefts:['.cta-final-texto h2','.cta-final-texto p','.cta-botoes'].map(s=>box(s).x),asset:document.querySelector('.footer-wordmark').getAttribute('src'),filter:getComputedStyle(document.querySelector('.footer-wordmark')).filter}});
  assert(!x.overflow);assert.equal(x.images,0);near(x.hero.x,x.cta.x,'Mesma linha');
  for(const left of [...x.heroLefts,...x.ctaLefts])near(left,x.hero.x,'Título/parágrafo/botões');
  const old=before.find(v=>v.width===width);
  for(const prop of ['x','y','w','h']){near(x.hero[prop],old.hero[prop],'Hero preservado '+prop);near(x.monitor[prop],old.monitor[prop],'Computador preservado '+prop);near(x.footer[prop],old.footer[prop],'Footer preservado '+prop);}
  for(let i=0;i<x.columns.length;i++){near(x.columns[i].x,old.columns[i].x,'Coluna x');near(x.columns[i].y,old.columns[i].y,'Coluna y');}
  near(x.logo.w,188,'Logo largura');near(x.logo.h,45,'Logo altura');assert.equal(x.filter,'none');assert(x.asset.endsWith('home-wordmark-footer-figma.png'));
  if(width===1440){near(x.logo.x-x.footer.x,61,'Figma logo x');near(x.logo.y-x.footer.y,63,'Figma logo y');}
  out.home.push(x);await p.locator('body > footer').screenshot({path:path.join(dir,'footer-'+width+'.png')});await p.locator('.cta-final').screenshot({path:path.join(dir,'alinhamento-final-'+width+'.png')});
 }
 for(const name of admins)for(const [width,height] of [[1812,963],[1024,768],[390,844]]){
  await p.setViewportSize({width,height});await p.goto(url(name));await p.locator('.perfil-trigger').click();
  const state=await p.locator('.perfil-popup').evaluate(e=>{let r=e.getBoundingClientRect(),img=e.querySelector('.perfil-foto'),photo=img.getBoundingClientRect(),name=e.querySelector('.perfil-nome').getBoundingClientRect(),s=getComputedStyle(e);return{width:innerWidth,height:innerHeight,x:r.x,y:r.y,w:r.width,h:r.height,client:e.clientHeight,scroll:e.scrollHeight,clientWidth:e.clientWidth,scrollWidth:e.scrollWidth,overflow:s.overflow,photo:{x:photo.x,y:photo.y,w:photo.width,h:photo.height,radius:getComputedStyle(img).borderRadius,loaded:img.complete&&img.naturalWidth>0},name:{y:name.y,h:name.height,text:e.querySelector('.perfil-nome').textContent},text:e.innerText,fileInputs:e.querySelectorAll('input[type="file"]').length}});
  assert.equal(state.client,state.scroll,name+' rolagem vertical');assert.equal(state.clientWidth,state.scrollWidth,name+' rolagem horizontal');assert.equal(state.overflow,'visible');assert(state.h<320);assert(state.y+state.h<height);assert(state.x>=0&&state.x+state.w<=width);
  near(state.photo.x+state.photo.w/2,state.x+state.w/2,'Foto centralizada');assert.equal(state.photo.w,64);assert.equal(state.photo.radius,'50%');assert(state.photo.loaded);assert(state.name.y>=state.photo.y+state.photo.h);assert.equal(state.name.text,'Administrador');assert(state.text.includes('ID: 7'));assert(state.text.includes('Email: admin.preview@example.test'));assert.equal(state.fileInputs,0);
  const current=p.url();await p.locator('.perfil-trigger').click();assert(await p.locator('.perfil-popup').isHidden());await p.locator('.perfil-trigger').click();await p.locator('h1').click();assert(await p.locator('.perfil-popup').isHidden());assert.equal(current,p.url());await p.locator('.perfil-trigger').click();await p.keyboard.press('Escape');assert(await p.locator('.perfil-popup').isHidden());
  // Limite real de email (100 caracteres), apenas no documento do teste.
  await p.locator('.perfil-trigger').click();await p.locator('.perfil-email').evaluate(e=>e.textContent='Email: '+'a'.repeat(87)+'@example.test');
  const long=await p.locator('.perfil-popup').evaluate(e=>({height:e.getBoundingClientRect().height,scroll:e.scrollHeight,client:e.clientHeight,scrollWidth:e.scrollWidth,clientWidth:e.clientWidth}));assert.equal(long.scroll,long.client);assert.equal(long.scrollWidth,long.clientWidth);assert(long.height<320);
  out.profiles.push({name,...state,longEmail:long});
  if(name==='companies'&&width===1812){await p.goto(url(name));await p.locator('.perfil-trigger').click();await p.screenshot({path:path.join(dir,'perfil-desktop.png')});}
 }
 // Contrato de logout preservado no JSP; restauração somente no DOM de teste do HTML neutro.
 await p.setViewportSize({width:1440,height:1000});await p.goto(url('companies'));await p.evaluate(()=>{let f=document.querySelector('#perfil-popup form');f.action='http://127.0.0.1:8977/logout';f.method='post'});
 let method;await p.route('http://127.0.0.1:8977/logout',async route=>{method=route.request().method();await route.fulfill({status:200,body:'POST verificado pelo teste.'})});await p.locator('.perfil-trigger').click();await Promise.all([p.waitForURL('http://127.0.0.1:8977/logout'),p.locator('#perfil-popup button').click()]);assert.equal(method,'POST');out.logout={method};
 await p.goto(pathToFileURL(path.join(dir,'muitos-registros.html')).href);await p.locator('.perfil-trigger').click();const initial=await p.locator('.perfil-popup').boundingBox();await p.evaluate(()=>scrollTo(0,document.body.scrollHeight));const final=await p.locator('.perfil-popup').boundingBox();near(initial.height,final.height,'Card independente da tabela');out.longTable={rows:await p.locator('.tabela tbody tr').count(),before:initial,after:final};
 assert.equal(out.errors.length,0);out.passed=true;
}finally{await b.close();fs.writeFileSync(path.join(dir,'visual.json'),JSON.stringify(out,null,2));}console.log(JSON.stringify({passed:out.passed,home:out.home.length,profiles:out.profiles.length,logout:out.logout?.method}));})().catch(e=>{console.error(e);process.exitCode=1});
