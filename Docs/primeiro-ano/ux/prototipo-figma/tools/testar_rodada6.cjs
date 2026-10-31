const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const {chromium}=require(process.env.PLAYWRIGHT_MODULE),root=path.resolve(__dirname,'..'),dir=path.join(root,'auditoria/rodada6');
const admins=['home-crud-page','companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses','administrations'];
const out={layouts:[],profile:[],search:[],home:[],errors:[],passed:false},url=n=>pathToFileURL(path.join(root,'html',n+'.html')).href;
(async()=>{const browser=await chromium.launch({channel:'chrome',headless:true});try{
 const page=await browser.newPage();page.on('pageerror',error=>out.errors.push(String(error)));
 for(const name of ['home',...admins]) for(const width of name==='home'?[1440,1024,768,390]:[1812,768,390]){
  await page.setViewportSize({width,height:1000});await page.goto(url(name));await page.evaluate(()=>document.fonts.ready);
  const layout=await page.evaluate(()=>({overflow:document.documentElement.scrollWidth>innerWidth+2,images:[...document.images].filter(i=>!i.complete||!i.naturalWidth).map(i=>i.src)}));
  assert(!layout.overflow,name+' overflow '+width);assert.equal(layout.images.length,0,name+' imagens');out.layouts.push({name,width,...layout});
  if(['home','companies','administrations'].includes(name)&&[1440,1812,390].includes(width))await page.screenshot({path:path.join(dir,name+'-'+width+'.png'),fullPage:true});
 }
 await page.setViewportSize({width:1440,height:1000});
 for(const name of admins){
  await page.goto(url(name));const colors=await page.evaluate(()=>['.header','.sidebar','.sidebar-logo'].map(sel=>getComputedStyle(document.querySelector(sel)).backgroundColor));assert(colors.every(color=>color===colors[0]),name+' cores header/sidebar');const before=page.url();const trigger=page.locator('.perfil-trigger'),popup=page.locator('#perfil-popup');
  await trigger.click();await assert.doesNotReject(()=>popup.waitFor({state:'visible'}));assert.equal(await trigger.getAttribute('aria-expanded'),'true');
  assert((await popup.innerText()).includes('ID: 7'));assert((await popup.innerText()).includes('admin.preview@example.test'));assert.equal(page.url(),before);if(name==='companies')await page.screenshot({path:path.join(dir,'perfil-aberto.png')});
  await trigger.click();assert(await popup.isHidden());await trigger.click();await page.locator('h1').click();assert(await popup.isHidden());
  await trigger.click();await page.keyboard.press('Escape');assert(await popup.isHidden());out.profile.push({name,click:true,outside:true,escape:true,sessionPreview:true,noNavigation:true});
  const input=page.locator('.toolbar input[name="busca"]');if(!await input.count())continue;
  const rows=page.locator('.tabela tbody tr:visible'),total=await rows.count();
  await input.fill('zzzinexistente');assert.equal(await rows.count(),0,name+' filtra');await input.fill('');assert.equal(await rows.count(),total);
  if(name==='companies'){await input.fill('Mer');assert((await rows.count())>0);await input.fill('Aurora');assert((await rows.count())>0&&(await rows.count())<total);await input.fill('');}
  await input.fill('');out.search.push({name,total,filtered:true,restored:true});
 }
 await page.goto(url('administrations'));await page.getByRole('link',{name:'+ Cadastrar administrador',exact:true}).click();
 assert(await page.locator('#modal-administration-criar').isVisible());assert.equal(await page.locator('#modal-administration-criar form').getAttribute('method'),'dialog');
 await page.goto(url('administrations'));await page.locator('.col-acoes a[title="Editar"]').first().click();
 assert(await page.locator('#modal-administration-editar').isVisible());assert.equal(await page.locator('#modal-administration-editar input[name="email"]').inputValue(),'admin.preview@example.test');
 assert.equal(await page.locator('#modal-administration-editar input[name="password"]').inputValue(),'');
 await page.screenshot({path:path.join(dir,'administration-editar.png')});
 out.administration={createModal:true,editModal:true,noPasswordValue:true,noDeletion:true};
 // Restaura somente no documento de teste os contratos GET/POST que o HTML estático neutraliza.
 await page.goto(url('companies'));await page.evaluate(()=>{let f=document.querySelector('.toolbar');f.method='get';f.action='http://127.0.0.1:8976/empresas'});
 let requests=[];await page.route('http://127.0.0.1:8976/**',async route=>{requests.push({method:route.request().method(),url:route.request().url()});await route.fulfill({status:200,body:'Requisição capturada pelo teste.'});});
 await page.locator('input[name="busca"]').fill('Mercado');await Promise.all([page.waitForURL('http://127.0.0.1:8976/**'),page.locator('input[name="busca"]').press('Enter')]);
 assert.equal(requests.at(-1).method,'GET');assert(new URL(requests.at(-1).url).searchParams.get('busca')==='Mercado');
 await page.goto(url('companies'));await page.evaluate(()=>{let f=document.querySelector('.toolbar');f.method='get';f.action='http://127.0.0.1:8976/empresas'});
 await page.locator('input[name="busca"]').fill('Mer');await Promise.all([page.waitForURL('http://127.0.0.1:8976/**'),page.getByRole('button',{name:'Pesquisar',exact:true}).click()]);assert.equal(requests.at(-1).method,'GET');
 await page.goto(url('companies'));await page.evaluate(()=>{let f=document.querySelector('#perfil-popup form');f.method='post';f.action='http://127.0.0.1:8976/logout'});
 await page.locator('.perfil-trigger').click();await Promise.all([page.waitForURL('http://127.0.0.1:8976/logout'),page.locator('#perfil-popup button').click()]);assert.equal(requests.at(-1).method,'POST');out.http=requests;
 // Página longa real do preview: as linhas foram geradas estaticamente, sem CRUD em JS.
 await page.goto(pathToFileURL(path.join(root,'auditoria/rodada2/muitos-registros.html')).href);
 const sidebar=page.locator('.sidebar');const before=await sidebar.boundingBox();await page.evaluate(()=>scrollTo(0,document.body.scrollHeight));await page.waitForTimeout(100);const after=await sidebar.boundingBox();
 assert(Math.abs(before.y-after.y)<1);assert(Math.abs(before.height-after.height)<1);assert.equal(after.y,0);out.sidebar={before,after,rows:await page.locator('.tabela tbody tr').count()};await page.screenshot({path:path.join(dir,'sidebar-scroll.png')});
 for(const width of [1440,1024,768,390]){
  await page.setViewportSize({width,height:1000});await page.goto(url('home'));await page.evaluate(()=>document.fonts.ready);
  const state=await page.evaluate(()=>{const box=s=>document.querySelector(s).getBoundingClientRect();return{gap:box('body > footer').y-box('.cta-final-imagem').bottom,orange:getComputedStyle(document.querySelector('.cta-final .destaque-salmao')).color,contacts:[...document.querySelectorAll('a')].filter(a=>a.textContent.trim()==='Entre em contato').map(a=>a.href),faq:[...document.querySelectorAll('a')].filter(a=>a.textContent.trim()==='Saiba mais').map(a=>a.getAttribute('href')),photos:document.querySelectorAll('.modal aside img:not(.modal-wordmark)').length,wordmark:document.querySelector('.modal-wordmark').getAttribute('src'),footer:document.querySelector('footer img').getAttribute('src')}});
  assert.equal(state.orange,'rgb(221, 123, 45)');assert(state.contacts.length>=2);assert(state.contacts.every(href=>new URL(href).searchParams.get('to')==='mottainai.contato@gmail.com'));assert(state.faq.every(href=>href==='faq.html'));assert.equal(state.faq.length,2);assert.equal(state.photos,0);assert(state.wordmark.includes('mottainai-wordmark-azul.svg'));assert(state.gap>=30);const oldStyle=await page.addStyleTag({content:fs.readFileSync(path.join(dir,'css-home-antes.css'),'utf8')});const oldGap=await page.evaluate(()=>document.querySelector('body > footer').getBoundingClientRect().y-document.querySelector('.cta-final-imagem').getBoundingClientRect().bottom);await oldStyle.evaluate(el=>el.remove());assert(Math.abs(oldGap-state.gap-(width<768?12:20))<1);out.home.push({width,...state,beforeGap:oldGap,reduction:oldGap-state.gap});
  if(width===1440){await page.locator('label[for="login"]').first().click();await page.waitForTimeout(350);await page.screenshot({path:path.join(dir,'login-sem-foto.png')});await page.locator('label[for="cadastro"]').first().click();await page.waitForTimeout(350);await page.screenshot({path:path.join(dir,'cadastro-sem-foto.png')});}
 }
 assert.equal(out.errors.length,0);out.passed=true;
}finally{await browser.close();fs.writeFileSync(path.join(dir,'visual.json'),JSON.stringify(out,null,2));}console.log(JSON.stringify({passed:out.passed,layouts:out.layouts.length,profiles:out.profile.length,search:out.search.length,home:out.home.length}));})().catch(error=>{console.error(error);process.exitCode=1});
