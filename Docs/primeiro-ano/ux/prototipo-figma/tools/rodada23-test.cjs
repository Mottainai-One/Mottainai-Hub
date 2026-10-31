const {chromium}=require(process.env.PLAYWRIGHT_MODULE),fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{pathToFileURL}=require('node:url');
const root=path.resolve(__dirname,'..'),out=path.join(root,'auditoria/rodada23');
const result={passed:false,cases:[],errors:[]};
(async()=>{
 const browser=await chromium.launch({channel:'chrome',headless:true});
 try {
  const page=await browser.newPage({reducedMotion:'reduce'});
  page.on('pageerror',e=>result.errors.push(String(e)));
  for(const active of [false,true])for(const width of [1440,1024,768,390]){
   await page.setViewportSize({width,height:1000});
   await page.goto(active?'http://127.0.0.1:18768/mottainai/faq':pathToFileURL(path.join(root,'html/faq.html')).href);
   await page.evaluate(()=>document.fonts.ready);
   assert.equal(await page.locator('.faq-lista details').count(),5);
   assert.equal(await page.locator('.faq-avaliacao:not([aria-hidden])').count(),3);
   const layout=await page.evaluate(()=>{
    const box=s=>{const b=document.querySelector(s).getBoundingClientRect();return {x:b.x,y:b.y,w:b.width,h:b.height}};
    return {body:document.documentElement.scrollWidth,viewport:innerWidth,hero:box('.faq-hero'),list:box('.faq-lista'),row:box('summary'),reviews:box('.faq-avaliacoes'),card:box('.faq-avaliacao'),footer:box('footer'),height:document.documentElement.scrollHeight};
   });
   assert(layout.body<=width+1,JSON.stringify(layout));
   if(width===1440){assert(Math.abs(layout.list.w-1165)<1);assert(Math.abs(layout.list.y-609)<1);assert(Math.abs(layout.row.h-90)<1);}
   for(let i=0;i<5;i++){
    const detail=page.locator('details').nth(i),summary=detail.locator('summary');
    await summary.click();assert.equal(await detail.getAttribute('open'),'');
    const fits=await detail.evaluate(e=>{const p=e.querySelector('p'),b=e.getBoundingClientRect(),r=p.getBoundingClientRect();return r.bottom<=b.bottom&&r.right<=b.right&&p.scrollWidth<=p.clientWidth+1});assert(fits);
    await summary.click();assert.equal(await detail.getAttribute('open'),null);
   }
   await page.evaluate(()=>scrollTo(0,0));
   await page.screenshot({path:path.join(out,`${active?'spring':'html'}-${width}.png`),fullPage:true});
   const links=await page.locator('header a, footer a').evaluateAll(es=>es.map(e=>({href:e.getAttribute('href'),text:e.textContent.trim()})));
   for(const link of links){
    if(link.href.startsWith('https:')){assert(/^https:\/\/(mail.google.com\/mail\/|www.instagram.com\/mottainai.estoques\/|wa.me\/5511993332592)/.test(link.href),link.href);continue;}
    const [pathname,hash]=link.href.split('#');
    const name=active?pathname.split('/').pop():pathname.replace('.html','');
    const source=fs.readFileSync(path.resolve(root,active?'../src/main/webapp/WEB-INF/jsp':'jsp',`${name}.jsp`),'utf8');
    if(hash)assert(new RegExp(`id=["']${hash}["']`).test(source),link.href);
    if(active){const response=await page.request.get('http://127.0.0.1:18768'+pathname);assert.equal(response.status(),200,pathname);}
   }
   const images=await page.locator('img').evaluateAll(es=>es.every(e=>e.complete&&e.naturalWidth>0));assert(images);
   assert(!/PROTÓTIPO|conteúdo de demonstração|sem autenticação|sem persistência/i.test(await page.locator('body').innerText()));
   result.cases.push({active,width,layout,accordion:5,links:links.length,images:true});
  }
  await page.emulateMedia({reducedMotion:'no-preference'});
  for(const width of [1440,390]){
   await page.setViewportSize({width,height:1000});await page.goto('http://127.0.0.1:18768/mottainai/faq');
   await page.locator('.faq-carrossel').scrollIntoViewIfNeeded();await page.mouse.move(1,1);
   const start=await page.locator('.faq-carrossel').evaluate(e=>e.scrollLeft);
   await page.waitForTimeout(5900);
   const end=await page.locator('.faq-carrossel').evaluate(e=>e.scrollLeft);assert(end>start+100,`automático ${width}: ${start} -> ${end}`);
   await page.locator('.faq-carrossel').hover();const pause=await page.locator('.faq-carrossel').evaluate(e=>e.scrollLeft);await page.waitForTimeout(5200);assert.equal(await page.locator('.faq-carrossel').evaluate(e=>e.scrollLeft),pause);
   result.cases.push({width,automatic:true,pause:true});
  }
  assert.equal(result.errors.length,0);result.passed=true;
 }finally{await browser.close();fs.writeFileSync(path.join(out,'visual.json'),JSON.stringify(result,null,2));}
 console.log(JSON.stringify({passed:result.passed,cases:result.cases.length,errors:result.errors.length}));
})().catch(e=>{console.error(e);process.exitCode=1});
