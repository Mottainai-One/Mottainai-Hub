const fs=require('node:fs'),path=require('node:path'),{pathToFileURL}=require('node:url'),{chromium}=require(process.env.PLAYWRIGHT_MODULE);
const root=path.resolve(__dirname,'..'),out=path.join(root,'auditoria/rodada21');
(async()=>{const b=await chromium.launch({channel:'chrome',headless:true});try{
 for(const year of [0,1]){
  const context=await b.newContext({viewport:{width:1440,height:900}});await context.route('https://fonts.googleapis.com/**',r=>r.abort());
  const p=await context.newPage();await p.goto(pathToFileURL(path.join(root,'html/sobre-nos.html')).href);await p.evaluate(()=>document.fonts.ready);
  const group=p.locator('.carrossel-wrap').nth(year);await group.scrollIntoViewIfNeeded();await p.waitForTimeout(300);
  await group.screenshot({path:path.join(out,`equipe-${year+1}-inicio.png`)});
  const frames=[],cdp=await context.newCDPSession(p);
  cdp.on('Page.screencastFrame',e=>{frames.push({data:e.data,time:e.metadata.timestamp});cdp.send('Page.screencastFrameAck',{sessionId:e.sessionId}).catch(()=>{});});
  await cdp.send('Page.startScreencast',{format:'jpeg',quality:80,maxWidth:1440,maxHeight:900,everyNthFrame:1});
  await p.waitForTimeout(250);
  const next=group.locator('.team-arrow-next'),prev=group.locator('.team-arrow-prev');
  for(const direction of [-1,-1,1,1,1,1]){await (direction<0?prev:next).click();await p.waitForTimeout(950);}
  await group.screenshot({path:path.join(out,`equipe-${year+1}-final.png`)});
  for(let i=0;i<2&&await prev.isVisible();i++){await prev.click();await p.waitForTimeout(1100);}
  await p.waitForTimeout(250);await cdp.send('Page.stopScreencast');
  // Codificação nativa do navegador, sem instalar ferramentas ou dependências.
  const encoder=await context.newPage();
  const video=await encoder.evaluate(async frames=>{
   const canvas=document.createElement('canvas');canvas.width=1440;canvas.height=900;document.body.append(canvas);
   const ctx=canvas.getContext('2d'),stream=canvas.captureStream(0),track=stream.getVideoTracks()[0];
   const recorder=new MediaRecorder(stream,{mimeType:'video/webm;codecs=vp9'}),chunks=[];
   recorder.ondataavailable=e=>{if(e.data.size)chunks.push(e.data)};const stopped=new Promise(resolve=>recorder.onstop=resolve);recorder.start();
   for(let i=0;i<frames.length;i++){
    const img=new Image();img.src='data:image/jpeg;base64,'+frames[i].data;await img.decode();ctx.drawImage(img,0,0,1440,900);track.requestFrame();
    const delay=i+1<frames.length?Math.max(1,(frames[i+1].time-frames[i].time)*1000):120;
    await new Promise(r=>setTimeout(r,delay));
   }
   recorder.stop();await stopped;track.stop();const blob=new Blob(chunks,{type:'video/webm'});
   return await new Promise(resolve=>{const reader=new FileReader();reader.onload=()=>resolve(reader.result.split(',')[1]);reader.readAsDataURL(blob)});
  },frames);
  fs.writeFileSync(path.join(out,`equipe-${year+1}-movimento.webm`),Buffer.from(video,'base64'));
  fs.writeFileSync(path.join(out,`equipe-${year+1}-gravacao.json`),JSON.stringify({frames:frames.length,duration:frames.at(-1).time-frames[0].time,method:'Chrome screencast + canvas MediaRecorder'},null,2));
  await context.close();
 }
 console.log('Gravados os dois anos com transform, avanço e retorno reais.');
}finally{await b.close()}})().catch(e=>{console.error(e);process.exitCode=1});
