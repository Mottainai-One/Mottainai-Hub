from pathlib import Path
import importlib.util,json,hashlib,sys
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'prototipo-figma/auditoria/rodada21'
def old():
    spec=importlib.util.spec_from_file_location('r17',ROOT/'prototipo-figma/tools/rodada17.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g);g.OUT=OUT;return g
def baseline():old().baseline()
def apply():
    for p in old().TARGETS:
        s=p.read_text(encoding='utf-8')
        assert 'Rodada 21' not in s,'Já aplicado'
        if p.suffix=='.css':
            s+='''
/* Rodada 21 — o card que retorna cruza por trás das fotos da fila. */
.team-track { isolation:isolate; transition:none; }
.team-track .cartoes { position:relative; z-index:2; transition:transform 800ms cubic-bezier(.4,0,.2,1); }
.team-track .cartoes[data-returning] { z-index:0; }
.team-track .cartoes[data-returning] :is(strong,.span-cartoes) { visibility:hidden; }
.team-track[data-reset] .cartoes { transition:none; }
@media(prefers-reduced-motion:reduce) { .team-track .cartoes { transition:none; } }
'''
        else:
            s=s.replace('    const paint=()=>{track.style.transform=`translate3d(${-index*metrics().step}px,0,0)`;track.dataset.index=String(logical());};','''    // Rodada 21: cada card ocupa um slot; o retorno percorre o fundo da fila.
    const visualCards=[...track.querySelectorAll('.cartoes')];
    const paint=(direction=0)=>{
      const current=logical(), previous=(current-direction+count)%count, {step}=metrics();
      track.style.transform=`translate3d(${-count*step}px,0,0)`;
      track.dataset.index=String(current);
      visualCards.forEach((card,i)=>{
        const identity=i%count, slot=(identity-current+count)%count, before=(identity-previous+count)%count;
        const returning=(direction===1 && before===0)||(direction===-1 && before===count-1);
        card.toggleAttribute('data-returning',returning);
        card.style.transform=`translate3d(${(slot-identity)*step}px,0,0)`;
      });
    };''')
            s=s.replace('clearTimeout(fallback);moving=false;','clearTimeout(fallback);moving=false;\n      visualCards.forEach(card=>card.removeAttribute(\'data-returning\'));',1)
            s=s.replace('index+=direction;moving=true;paint();','index+=direction;moving=true;paint(direction);')
            s=s.replace("if(event.target===track && event.propertyName==='transform')finish();","if(event.target.classList.contains('cartoes') && event.propertyName==='transform')finish();")
        p.write_text(s,encoding='utf-8')
    old().render()
def audit():
    before=json.loads((OUT/'antes.json').read_text(encoding='utf-8'))
    changed=[f for f,h in before.items() if hashlib.sha256((ROOT/f).read_bytes()).hexdigest()!=h]
    assert set(changed)=={p.relative_to(ROOT).as_posix() for p in old().TARGETS},changed
    for p in old().TARGETS:
        if p.suffix=='.js':assert p.read_text(encoding='utf-8').split('// Rodada 17')[0]==(OUT/'antes'/p.relative_to(ROOT)).read_text(encoding='utf-8').split('// Rodada 17')[0]
    (OUT/'invariantes.json').write_text(json.dumps(dict(passed=True,changed=changed,backendUnchanged=True,jspHtmlAndMainCarouselUnchanged=True),indent=2),encoding='utf-8');print('Somente os quatro CSS/JS da equipe foram alterados.')
def proof():
    s=(ROOT/'prototipo-figma/tools/rodada17-gravar.cjs').read_text(encoding='utf-8').replace('auditoria/rodada17','auditoria/rodada21')
    (ROOT/'prototipo-figma/tools/rodada21-gravar.cjs').write_text(s,encoding='utf-8')
if __name__=='__main__':globals()[sys.argv[1]]()
