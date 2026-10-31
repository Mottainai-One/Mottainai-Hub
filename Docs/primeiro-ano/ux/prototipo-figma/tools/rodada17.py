from pathlib import Path
import sys,json,hashlib,importlib.util
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'prototipo-figma/auditoria/rodada17'
TARGETS=[ROOT/base/name for base in ['src/main/resources/static/assets','prototipo-figma'] for name in ['css/sobre-nos.css','js/sobre-nos.js']]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def baseline():
    OUT.mkdir(parents=True,exist_ok=True)
    if (OUT/'antes.json').exists():raise SystemExit('Baseline já existe')
    files=[p for base in ['src','prototipo-figma/jsp','prototipo-figma/html','prototipo-figma/css','prototipo-figma/js','prototipo-figma/assets'] for p in (ROOT/base).rglob('*') if p.is_file()]
    (OUT/'antes.json').write_text(json.dumps({p.relative_to(ROOT).as_posix():sha(p) for p in files},indent=2),encoding='utf-8')
    for p in TARGETS:
        target=OUT/'antes'/p.relative_to(ROOT);target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(p.read_bytes())
def apply():
    for p in TARGETS:
        s=p.read_text(encoding='utf-8')
        if 'Rodada 17' in s:raise SystemExit('Alterações já aplicadas')
        if p.suffix=='.css':
            s+='''
/* Rodada 17 — vizinhos nas bordas e controles na mesma região da referência. */
.carrossel-wrap { --team-gap:18px; --team-peek:calc(var(--team-gap) + 10px); }
.carrossel.team-viewport { width:calc(100% + 2 * var(--team-peek)); margin-inline:calc(-1 * var(--team-peek)); padding-inline:var(--team-peek); box-sizing:border-box; mask-image:linear-gradient(to right,transparent,#000 4%,#000 96%,transparent); -webkit-mask-image:linear-gradient(to right,transparent,#000 4%,#000 96%,transparent); }
.team-track { transition:transform 800ms cubic-bezier(.4,0,.2,1); }
.team-track[data-reset] { transition:none; }
.team-arrow { top:calc(var(--team-arrow-top,215px) - var(--team-control-size,96px) / 2); width:var(--team-control-size,96px); height:var(--team-control-size,96px); z-index:3; }
.team-arrow-prev { left:calc(var(--team-arrow-left,160px) - var(--team-control-size,96px) / 2); right:auto; }
.team-arrow-next { left:calc(var(--team-arrow-right,1000px) - var(--team-control-size,96px) / 2); right:auto; }
.team-arrow:focus-visible { outline:3px solid #dd7b2d; outline-offset:4px; border-radius:50%; }
@media(max-width:767px) { .carrossel-wrap { --team-peek:12px; } }
@media(prefers-reduced-motion:reduce) { .team-track { transition:none; } }
'''
        else:
            s=s[:s.index('// Cada ano tem viewport')]+'''// Rodada 17 — faixa circular: cópias visuais nas bordas, originais preservados no centro.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const viewport=wrap.querySelector('.team-viewport'), track=wrap.querySelector('.team-track');
    const prev=wrap.querySelector('.team-arrow-prev'), next=wrap.querySelector('.team-arrow-next');
    if (!viewport || !track || !prev || !next) return;
    const cards=[...track.querySelectorAll('.cartoes')], count=cards.length;
    if (!count) return;
    const reduced=matchMedia('(prefers-reduced-motion:reduce)');
    const copy=card=>{const clone=card.cloneNode(true);clone.dataset.teamClone='true';clone.setAttribute('aria-hidden','true');clone.setAttribute('inert','');clone.removeAttribute('id');clone.querySelectorAll('[id]').forEach(e=>e.removeAttribute('id'));return clone;};
    track.prepend(...cards.map(copy));track.append(...cards.map(copy));
    let index=count, moving=false, pending=0, pointerStart=null, fallback;
    const metrics=()=>({step:count>1 ? cards[1].offsetLeft-cards[0].offsetLeft : cards[0].offsetWidth,gap:parseFloat(getComputedStyle(track).columnGap)||0});
    const logical=()=>((index-count)%count+count)%count;
    const paint=()=>{track.style.transform=`translate3d(${-index*metrics().step}px,0,0)`;track.dataset.index=String(logical());};
    const reset=()=>{
      track.setAttribute('data-reset','');paint();
      void track.offsetWidth;
      requestAnimationFrame(()=>requestAnimationFrame(()=>track.removeAttribute('data-reset')));
    };
    const controls=()=>{
      const {step,gap}=metrics();wrap.style.setProperty('--team-gap',gap+'px');
      const w=wrap.getBoundingClientRect(),v=viewport.getBoundingClientRect(),zoom=w.width/wrap.offsetWidth || 1;
      const style=getComputedStyle(viewport),photo=cards[0].querySelector('img');
      const left=(v.left-w.left)/zoom+parseFloat(style.paddingLeft)+cards[0].offsetWidth*.42;
      const right=(v.right-w.left)/zoom-parseFloat(style.paddingRight)-cards[0].offsetWidth*.42;
      const top=(v.top-w.top)/zoom+parseFloat(style.paddingTop)+(photo?.offsetHeight||266)*.59;
      wrap.style.setProperty('--team-control-size',(Math.min(96,Math.max(44,innerWidth/15))/zoom)+'px');
      wrap.style.setProperty('--team-arrow-left',left+'px');wrap.style.setProperty('--team-arrow-right',right+'px');wrap.style.setProperty('--team-arrow-top',top+'px');
      const fits=count*step-gap<=track.clientWidth+1;prev.hidden=fits;next.hidden=fits;
    };
    const finish=()=>{
      if (!moving) return;
      clearTimeout(fallback);moving=false;
      if(index<count || index>=2*count){index=count+logical();reset();}
      if(pending){const direction=pending;pending=0;requestAnimationFrame(()=>requestAnimationFrame(()=>move(direction)));}
    };
    const move=direction=>{
      if(moving){pending=direction;return;}
      track.removeAttribute('data-reset');index+=direction;moving=true;paint();
      if(reduced.matches)finish();else fallback=setTimeout(finish,900);
    };
    const layout=()=>{clearTimeout(fallback);moving=false;pending=0;index=count+logical();controls();reset();};
    track.addEventListener('transitionend',event=>{if(event.target===track && event.propertyName==='transform')finish();});
    prev.addEventListener('click',()=>move(-1));next.addEventListener('click',()=>move(1));
    viewport.addEventListener('keydown',event=>{
      if(!['ArrowLeft','ArrowRight','Home','End'].includes(event.key))return;
      event.preventDefault();
      if(event.key==='Home'||event.key==='End'){index=count+(event.key==='End'?count-1:0);pending=0;moving=false;clearTimeout(fallback);paint();}
      else move(event.key==='ArrowRight'?1:-1);
    });
    viewport.addEventListener('pointerdown',event=>{pointerStart=event.clientX;viewport.setPointerCapture(event.pointerId);});
    viewport.addEventListener('pointerup',event=>{if(pointerStart!==null && Math.abs(event.clientX-pointerStart)>44)move(event.clientX<pointerStart?1:-1);pointerStart=null;});
    viewport.addEventListener('pointercancel',()=>{pointerStart=null;});
    window.addEventListener('resize',layout);reduced.addEventListener('change',layout);
    cards.forEach(card=>card.querySelectorAll('img').forEach(img=>img.addEventListener('load',controls)));
    layout();
  });
})();
'''
        p.write_text(s,encoding='utf-8')
    render()
def render():
    spec=importlib.util.spec_from_file_location('r16',ROOT/'prototipo-figma/tools/rodada16.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g);g.OUT=OUT;g.render()
def proof():
    s=(ROOT/'prototipo-figma/tools/rodada16-gravar.cjs').read_text(encoding='utf-8').replace('auditoria/rodada16','auditoria/rodada17')
    s=s.replace('for(let i=0;i<2&&await next.isVisible();i++){await next.click();await p.waitForTimeout(1100);}', 'for(const direction of [-1,-1,1,1,1,1]){await (direction<0?prev:next).click();await p.waitForTimeout(950);}')
    (ROOT/'prototipo-figma/tools/rodada17-gravar.cjs').write_text(s,encoding='utf-8')
def audit():
    before=json.loads((OUT/'antes.json').read_text(encoding='utf-8'))
    changed=[f for f,h in before.items() if not (ROOT/f).exists() or sha(ROOT/f)!=h]
    assert set(changed)=={p.relative_to(ROOT).as_posix() for p in TARGETS},changed
    for p in [p for base in ['src/main/webapp/WEB-INF/jsp','prototipo-figma/jsp'] for p in (ROOT/base).glob('*.jsp')]:assert sha(p)==before[p.relative_to(ROOT).as_posix()]
    for p in TARGETS:
        if p.suffix=='.js':assert p.read_text(encoding='utf-8').split('// Rodada 17')[0]==(OUT/'antes'/p.relative_to(ROOT)).read_text(encoding='utf-8').split('// Cada ano')[0]
    (OUT/'invariantes.json').write_text(json.dumps(dict(passed=True,changed=changed,jspAndHtmlUnchanged=True,backendUnchanged=True,heroUnchanged=True),indent=2),encoding='utf-8');print('Somente quatro CSS/JS alterados; JSP/HTML/backend intactos.')
if __name__=='__main__':globals()[sys.argv[1]]()
