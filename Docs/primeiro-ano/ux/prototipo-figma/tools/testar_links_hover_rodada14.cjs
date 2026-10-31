const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const{chromium}=require(process.env.PLAYWRIGHT_MODULE),root=path.resolve(__dirname,'..'),dir=path.join(root,'auditoria/rodada14');
(async()=>{const browser=await chromium.launch({channel:'chrome',headless:true});const result=[];try{const p=await browser.newPage();await p.route('https://fonts.googleapis.com/**',r=>r.abort());for(const active of [false,true]){
await p.setViewportSize({width:1440,height:1000});await p.goto(pathToFileURL(active?path.join(dir,'ativo-planos.html'):path.join(root,'html/planos.html')).href);await p.evaluate(()=>document.fonts.ready);
const button=p.locator('#duvidas .btn-contato');await button.scrollIntoViewIfNeeded();await p.mouse.move(0,0);const before=await button.boundingBox();await button.hover();await p.waitForTimeout(350);const after=await button.boundingBox(),style=await button.evaluate(e=>({bg:getComputedStyle(e).backgroundColor,pattern:getComputedStyle(e,'::after').content}));assert(Math.abs(after.y-before.y+2)<.2);assert.equal(style.bg,'rgb(26, 58, 92)');assert.equal(style.pattern,'none');
const urls=[];await p.context().route('https://mail.google.com/**',r=>{urls.push(r.request().url());return r.fulfill({status:200,contentType:"text/plain",body:"Navegação externa interceptada somente pelo teste."})});
for(const mode of ['mensal','anual']){
 await p.locator('#'+mode).click();await p.waitForTimeout(700);
 for(const anchor of await p.locator('.card-plano .btn-plano').all()){
  const popupPromise=p.context().waitForEvent('page',{timeout:5000});await anchor.click();const popup=await popupPromise;await popup.waitForLoadState({timeout:3000}).catch(()=>{});await popup.close();
 }
}
assert.equal(urls.length,6);for(const url of urls)assert.equal(new URL(url).searchParams.get('to'),'mottainai.contato@gmail.com');
result.push({active,hoverDelta:after.y-before.y,hover:style,composeRequests:urls,externalPageContentVerified:false});
}
// Registro visual da seção fornecida no ZIP, sem substituir a página atual.
await p.goto(pathToFileURL(path.resolve(root,'../build/referencia-landing/landing/pages/planos.html')).href);await p.evaluate(href=>{const l=document.createElement('link');l.rel='stylesheet';l.href=href;document.head.append(l)},pathToFileURL(path.join(root,'css/fontes.css')).href);await p.evaluate(()=>document.fonts.ready);await p.locator('#escolha-plano').screenshot({path:path.join(dir,'referencia-zip-planos.png')});
fs.writeFileSync(path.join(dir,'links-hover.json'),JSON.stringify({passed:true,cases:result},null,2));console.log(JSON.stringify({passed:true,cases:result.length}));
}finally{await browser.close()}})().catch(e=>{console.error(e);process.exitCode=1});
