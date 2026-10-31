from pathlib import Path
import re,importlib.util
root=Path(__file__).resolve().parents[2]
if 'const openAnchor' in (root/'prototipo-figma/js/sobre-nos.js').read_text(encoding='utf-8'):
    raise SystemExit('Alterações já aplicadas; use renderizar_rodada15.py para atualizar somente as fixtures.')
for parallel in [False,True]:
    js=root/('prototipo-figma/js' if parallel else 'src/main/resources/static/assets/js')
    p=js/'sobre-nos.js';s=p.read_text(encoding='utf-8')
    s=s.replace('  goToSlide(0);','''  goToSlide(0);
  const openAnchor = () => {
    const index = [...carousel.querySelectorAll('.slide')].findIndex(slide => '#'+slide.id === location.hash);
    if (index < 0) return;
    goToSlide(index);
    requestAnimationFrame(() => { carousel.scrollLeft=0; carousel.querySelector('.hero-track').scrollLeft=0; });
  };
  window.addEventListener('hashchange', openAnchor);
  openAnchor();''')
    start=s.index('// Cada grupo da equipe')
    s=s[:start]+'''// Cada clique desloca uma posição com movimento contínuo; os grupos são independentes.
(() => {
  document.querySelectorAll('.carrossel-wrap').forEach(wrap => {
    const track = wrap.querySelector('.carrossel');
    const prev = wrap.querySelector('.team-arrow-prev'), next = wrap.querySelector('.team-arrow-next');
    if (!track || !prev || !next) return;
    const reduced = matchMedia('(prefers-reduced-motion: reduce)');
    let frame = 0, destination = 0;
    const update = () => {
      const max = track.scrollWidth-track.clientWidth, style = getComputedStyle(track);
      const edge = Math.max(parseFloat(style.paddingLeft)||0,parseFloat(style.paddingRight)||0)+2;
      prev.hidden = track.scrollLeft <= edge;
      next.hidden = max <= edge || track.scrollLeft >= max-edge;
    };
    const stop = () => { cancelAnimationFrame(frame); frame=0; delete track.dataset.moving; update(); };
    const move = direction => {
      const card=track.querySelector('.cartoes');
      if (!card) return;
      const step=card.getBoundingClientRect().width+(parseFloat(getComputedStyle(track).columnGap)||0);
      const from=track.scrollLeft, max=track.scrollWidth-track.clientWidth;
      destination=Math.min(max,Math.max(0,(frame ? destination : from)+direction*step));
      cancelAnimationFrame(frame);
      if (reduced.matches) { track.scrollLeft=destination; stop(); return; }
      track.dataset.moving='true';
      const started=performance.now(), target=destination;
      const tick=now=>{
        const t=Math.min((now-started)/650,1), eased=t<.5 ? 4*t*t*t : 1-Math.pow(-2*t+2,3)/2;
        track.scrollLeft=from+(target-from)*eased;
        update();
        if (t<1) frame=requestAnimationFrame(tick);
        else { frame=0; delete track.dataset.moving; update(); }
      };
      frame=requestAnimationFrame(tick);
    };
    prev.addEventListener('click',()=>move(-1)); next.addEventListener('click',()=>move(1));
    track.addEventListener('scroll',update,{passive:true});
    track.addEventListener('pointerdown',stop,{passive:true}); track.addEventListener('wheel',stop,{passive:true});
    window.addEventListener('resize',stop);
    track.querySelectorAll('img').forEach(img=>img.addEventListener('load',update));
    update(); requestAnimationFrame(update);
  });
})();
'''
    p.write_text(s,encoding='utf-8')
    p=js/'crud-ux.js';s=p.read_text(encoding='utf-8');s=s.replace("  const search = document.querySelector", "  if (document.currentScript?.hasAttribute('data-profile-only')) return;\n  const search = document.querySelector")
    p.write_text(s,encoding='utf-8')
    if not parallel:
        for p in (root/'src/main/webapp/WEB-INF/jsp').glob('*.jsp'):
            if p.stem=='administrations':continue
            s=p.read_text(encoding='utf-8').replace('<script src="${pageContext.request.contextPath}/assets/js/crud-ux.js">','<script data-profile-only src="${pageContext.request.contextPath}/assets/js/crud-ux.js">')
            p.write_text(s,encoding='utf-8')

spec=importlib.util.spec_from_file_location('gerar',root/'prototipo-figma/tools/gerar_html.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
g.main()
# Renderizações estáticas dos JSPs ativos usam exatamente o mesmo motor de fixtures, fora do WAR.
out=root/'prototipo-figma/auditoria/rodada15'
old=g.ROOT
for p in (root/'src/main/webapp/WEB-INF/jsp').glob('*.jsp'):
    # generate lê ROOT/jsp. Uma raiz isolada guarda apenas as cópias de teste.
    target=out/'ativo/jsp'/p.name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(p.read_bytes())
g.ROOT=out/'ativo'
for p in (g.ROOT/'jsp').glob('*.jsp'):
    s=g.generate(p.name)
    s=re.sub(r'(src|href)="/assets/',lambda m:m[1]+'="../../../../src/main/resources/static/assets/',s)
    # Recursos ativos não têm fontes locais declaradas; somente a fixture usa a fonte local de teste.
    s=s.replace('</head>','<link rel="stylesheet" href="../../css/fontes.css"></head>')
    (out/('ativo-'+p.stem+'.html')).write_text(s,encoding='utf-8')
g.ROOT=old
print('HTMLs e fixtures ativas regenerados')
