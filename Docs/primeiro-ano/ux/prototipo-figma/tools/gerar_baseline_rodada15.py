from pathlib import Path
import re,importlib.util
root=Path(__file__).resolve().parents[2];out=root/'prototipo-figma/auditoria/rodada15'
spec=importlib.util.spec_from_file_location('g',root/'prototipo-figma/tools/gerar_html.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
g.ROOT=out/'antes/prototipo-figma'
for name in ['companies','home','sobre-nos']:
    s=g.generate(name+'.jsp')
    for kind in ['css','js']:
        s=s.replace('../'+kind+'/',(g.ROOT/kind).as_uri()+'/')
    s=s.replace('../assets/',(root/'prototipo-figma/assets').as_uri()+'/')
    s=s.replace('</head>','<link rel="stylesheet" href="'+(root/'prototipo-figma/css/fontes.css').as_uri()+'"></head>')
    (out/('antes-'+name+'.html')).write_text(s,encoding='utf-8')
