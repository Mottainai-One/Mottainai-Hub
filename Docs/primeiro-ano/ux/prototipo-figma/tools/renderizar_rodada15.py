from pathlib import Path
import re,importlib.util
root=Path(__file__).resolve().parents[2];out=root/'prototipo-figma/auditoria/rodada15'
spec=importlib.util.spec_from_file_location('gerar',root/'prototipo-figma/tools/gerar_html.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
g.main()
g.ROOT=out/'ativo'
for p in (root/'src/main/webapp/WEB-INF/jsp').glob('*.jsp'):
    target=g.ROOT/'jsp'/p.name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(p.read_bytes())
for p in (g.ROOT/'jsp').glob('*.jsp'):
    s=g.generate(p.name)
    s=re.sub(r'(src|href)="/assets/',lambda m:m[1]+'="../../../src/main/resources/static/assets/',s)
    s=s.replace('</head>','<link rel="stylesheet" href="../../css/fontes.css"></head>')
    # Navegação entre fixtures; o JSP mantém suas rotas Spring.
    s=re.sub(r'href="([a-z-]+)\.html',r'href="ativo-\1.html',s)
    (out/('ativo-'+p.stem+'.html')).write_text(s,encoding='utf-8')
print('Renderizações atualizadas')
