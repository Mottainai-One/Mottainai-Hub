from pathlib import Path
from collections import Counter
import hashlib,json,re,sys,shutil,importlib.util
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'prototipo-figma/auditoria/rodada16'
def files():
    return [p for base in ['src','prototipo-figma/jsp','prototipo-figma/html','prototipo-figma/css','prototipo-figma/js','prototipo-figma/assets','prototipo-figma/tools'] for p in (ROOT/base).rglob('*') if p.is_file() and '__pycache__' not in str(p)]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def baseline():
    OUT.mkdir(parents=True,exist_ok=True)
    if (OUT/'antes.json').exists():raise SystemExit('Baseline já existe')
    (OUT/'antes.json').write_text(json.dumps({p.relative_to(ROOT).as_posix():sha(p) for p in files()},indent=2),encoding='utf-8')
    for p in files():
        if p.suffix in ['.jsp','.css','.js']:
            dest=OUT/'antes'/p.relative_to(ROOT);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest)
    (OUT/'video.html').write_text('<!doctype html><html><body style="margin:0"><video src="file:///C:/Users/20260215-ieg/Videos/Grava%C3%A7%C3%B5es%20de%20Tela/Grava%C3%A7%C3%A3o%20de%20Tela%202026-10-28%20074045.mp4"></video><canvas></canvas></body></html>',encoding='utf-8')
def generator():
    spec=importlib.util.spec_from_file_location('g',ROOT/'prototipo-figma/tools/gerar_html.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g);return g
def sheets():
    from PIL import Image,ImageDraw
    frames=sorted((OUT/'video-frames').glob('*.png'))
    assert len(frames)==112,len(frames)
    # Todas as amostras de 0,1s são incluídas nas folhas; nenhuma parte do vídeo é omitida.
    for batch,start in enumerate(range(0,len(frames),24)):
        canvas=Image.new('RGB',(1600,6*215),'white');draw=ImageDraw.Draw(canvas)
        for i,p in enumerate(frames[start:start+24]):
            x=(i%4)*400;y=(i//4)*215
            image=Image.open(p);image.thumbnail((400,187));canvas.paste(image,(x,y+25));draw.text((x+8,y+6),f'{int(p.stem)/10:.1f}s',fill='black')
        canvas.save(OUT/f'video-sequencia-{batch+1}.png')
def render():
    g=generator()
    for name in ['home','sobre-nos','planos','faq']:
        (ROOT/'prototipo-figma/html'/(name+'.html')).write_text(g.generate(name+'.jsp'),encoding='utf-8')
    g.ROOT=OUT/'ativo'
    for name in ['home','sobre-nos','planos']:
        p=ROOT/'src/main/webapp/WEB-INF/jsp'/(name+'.jsp');dest=g.ROOT/'jsp'/p.name;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest)
        s=g.generate(p.name).replace('="/assets/','="../../../src/main/resources/static/assets/')
        s=s.replace('</head>','<link rel="stylesheet" href="../../css/fontes.css"></head>')
        s=re.sub(r'href="([a-z-]+)\.html',r'href="ativo-\1.html',s)
        (OUT/('ativo-'+name+'.html')).write_text(s,encoding='utf-8')
def apply():
    for parallel in [False,True]:
        jsp=ROOT/('prototipo-figma/jsp' if parallel else 'src/main/webapp/WEB-INF/jsp')
        css=ROOT/('prototipo-figma/css' if parallel else 'src/main/resources/static/assets/css')
        js=ROOT/('prototipo-figma/js' if parallel else 'src/main/resources/static/assets/js')
        if 'team-track' in (jsp/'sobre-nos.jsp').read_text(encoding='utf-8'):raise SystemExit('Alterações já aplicadas')
        for name in ['home','sobre-nos','planos','faq']:
            p=jsp/(name+'.jsp')
            if not p.exists():continue
            s=p.read_text(encoding='utf-8');h=re.search(r'<header\b[\s\S]*?</header>',s)
            head=h[0].replace('/img/wordmark-mottainai.svg','/img/mottainai-logo-completo.svg')
            # O botão do header torna-se o mesmo link externo de contato já usado no site.
            head=re.sub(r'<a\b([^>]*?)href="[^"]*"([^>]*?)>Entre em contato</a>',lambda m:'<a'+m[1]+'href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com"'+m[2]+' target="_blank" rel="noopener noreferrer">Entre em contato</a>',head)
            s=s[:h.start()]+head+s[h.end():]
            s=s.replace('/img/wordmark-mottainai.svg','/img/mottainai-wordmark-rodape.svg')
            if name=='sobre-nos':
                year=iter([1,2])
                pattern=r'<div class="carrossel">([\s\S]*?)(\n\s*</div>\s*\n\s*<button type="button" class="team-arrow team-arrow-next")'
                def wrap(m):
                    return '<div class="carrossel team-viewport" tabindex="0" role="group" aria-label="Equipe do '+str(next(year))+'º ano">\n                    <div class="team-track">'+m[1]+'\n                    </div>'+m[2]
                s,count=re.subn(pattern,wrap,s);assert count==2,count
            p.write_text(s,encoding='utf-8')
        p=css/'footer.css';p.write_text(p.read_text(encoding='utf-8')+'\n/* Rodada 16 — cor exata da Landing/Figma 101:25159, comum a todas as páginas públicas. */\nbody > footer { background-color:#f5f7fa; }\n',encoding='utf-8')
        if parallel:
            p=css/'home.css';p.write_text(p.read_text(encoding='utf-8')+'\n/* Rodada 16 — os cards usam o mesmo recuo horizontal do hero. */\nmain #sistema { padding-inline:var(--home-alinhamento); }\n',encoding='utf-8')
        p=css/'sobre-nos.css';p.write_text(p.read_text(encoding='utf-8')+'''
/* Rodada 16 — viewport recorta as bordas; somente o track se desloca. */
.carrossel.team-viewport { display:block; overflow:hidden; scroll-snap-type:none; scroll-behavior:auto; touch-action:pan-y; }
.team-track { position:relative; display:flex; gap:inherit; width:100%; min-width:0; transform:translate3d(0,0,0); transition:transform 800ms cubic-bezier(.4,0,.2,1); }
.team-track .cartoes { scroll-snap-align:none; }
.team-track img { user-select:none; -webkit-user-drag:none; }
.team-viewport:focus-visible { outline:2px solid #dd7b2d; outline-offset:4px; }
@media(prefers-reduced-motion:reduce) { .team-track { transition:none; } }
''',encoding='utf-8')
        p=js/'sobre-nos.js';s=p.read_text(encoding='utf-8');start=s.index('// Cada clique desloca uma posição')
        s=s[:start]+'''// Cada ano tem viewport, track e índice próprios. Somente o track é transformado.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const viewport=wrap.querySelector('.team-viewport'), track=wrap.querySelector('.team-track');
    const prev=wrap.querySelector('.team-arrow-prev'), next=wrap.querySelector('.team-arrow-next');
    if (!viewport || !track || !prev || !next) return;
    const cards=[...track.querySelectorAll('.cartoes')];
    let index=0, pointerStart=null;
    const metrics=()=>({step:cards.length>1 ? cards[1].offsetLeft-cards[0].offsetLeft : track.clientWidth,max:Math.max(0,track.scrollWidth-track.clientWidth)});
    const apply=()=>{
      const {step,max}=metrics();
      index=Math.min(index,step ? Math.ceil(max/step) : 0);
      const offset=Math.min(index*step,max);
      track.style.transform=`translate3d(${-offset}px,0,0)`;
      track.dataset.index=String(index);
      prev.hidden=offset<=1;
      next.hidden=max<=1 || offset>=max-1;
    };
    const move=direction=>{const {step,max}=metrics();index=Math.max(0,Math.min(index+direction,step ? Math.ceil(max/step) : 0));apply();};
    prev.addEventListener('click',()=>move(-1));next.addEventListener('click',()=>move(1));
    viewport.addEventListener('keydown',event=>{
      if (!['ArrowLeft','ArrowRight','Home','End'].includes(event.key)) return;
      event.preventDefault();
      if(event.key==='Home'){index=0;apply();}
      else if(event.key==='End'){const {step,max}=metrics();index=step ? Math.ceil(max/step) : 0;apply();}
      else move(event.key==='ArrowRight'?1:-1);
    });
    viewport.addEventListener('pointerdown',event=>{pointerStart=event.clientX;viewport.setPointerCapture(event.pointerId);});
    viewport.addEventListener('pointerup',event=>{if(pointerStart!==null && Math.abs(event.clientX-pointerStart)>44)move(event.clientX<pointerStart?1:-1);pointerStart=null;});
    viewport.addEventListener('pointercancel',()=>{pointerStart=null;});
    window.addEventListener('resize',apply);
    track.querySelectorAll('img').forEach(img=>img.addEventListener('load',apply));
    apply();
  });
})();
'''
        p.write_text(s,encoding='utf-8')
    render()
def audit():
    before=json.loads((OUT/'antes.json').read_text(encoding='utf-8'))
    changed=[f for f,h in before.items() if not (ROOT/f).exists() or sha(ROOT/f)!=h]
    allowed={f'{base}/{name}.jsp' for base in ['src/main/webapp/WEB-INF/jsp','prototipo-figma/jsp'] for name in ['home','sobre-nos','planos','faq']}
    allowed|={f'{base}/{name}.css' for base in ['src/main/resources/static/assets/css','prototipo-figma/css'] for name in ['home','sobre-nos','footer']}
    allowed|={f'{base}/sobre-nos.js' for base in ['src/main/resources/static/assets/js','prototipo-figma/js']}
    allowed|={f'prototipo-figma/html/{name}.html' for name in ['home','sobre-nos','planos','faq']}
    allowed.add('prototipo-figma/tools/rodada16.py')
    assert set(changed)<=allowed,set(changed)-allowed
    contracts=[]
    for f in changed:
        if not f.endswith('.jsp'):continue
        a=(OUT/'antes'/f).read_text(encoding='utf-8');b=(ROOT/f).read_text(encoding='utf-8')
        for key in ['action','method','name','id']:
            assert not Counter(re.findall(r'\b'+key+r'="([^"]*)"',a))-Counter(re.findall(r'\b'+key+r'="([^"]*)"',b)),(f,key)
        # O contato do header é externo por solicitação; esse href deixa de usar contextPath.
        el=lambda s:[v for v in re.findall(r'\$\{[^}]*\}',s) if v!='${pageContext.request.contextPath}']
        assert el(a)==el(b),f
        assert re.findall(r'<(?:c:|fmt:|input\b|select\b|textarea\b)[^>]*>',a)==re.findall(r'<(?:c:|fmt:|input\b|select\b|textarea\b)[^>]*>',b),f
        footer=lambda s:re.search(r'<footer\b[\s\S]*?</footer>',s)[0]
        assert re.findall(r'href="([^"]*)"',footer(a))==re.findall(r'href="([^"]*)"',footer(b)),f
        contracts.append(f)
    for base in ['src/main/resources/static/assets/js','prototipo-figma/js']:
        f=base+'/sobre-nos.js'
        old=(OUT/'antes'/f).read_text(encoding='utf-8').split('// Cada clique')[0]
        new=(ROOT/f).read_text(encoding='utf-8').split('// Cada ano')[0]
        assert old==new,'Carrossel principal alterado'
    for name in ['home','sobre-nos','planos','faq']:assert generator().generate(name+'.jsp')==(ROOT/'prototipo-figma/html'/(name+'.html')).read_text(encoding='utf-8')
    result=dict(passed=True,changed=changed,created=[p.relative_to(ROOT).as_posix() for p in files() if p.relative_to(ROOT).as_posix() not in before],contracts=contracts,backendUnchanged=True)
    (OUT/'invariantes.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8');print(json.dumps({'passed':True,'changed':len(changed),'jsp':len(contracts)}))
if __name__=='__main__':globals()[sys.argv[1]]()
