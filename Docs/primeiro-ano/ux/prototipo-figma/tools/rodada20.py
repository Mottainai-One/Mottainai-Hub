from pathlib import Path
import re,sys,json,hashlib,importlib.util
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'prototipo-figma/auditoria/rodada20'
PAGES=['companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses','administrations']
def generator():
    spec=importlib.util.spec_from_file_location('g',ROOT/'prototipo-figma/tools/gerar_html.py');g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g);return g
def baseline():
    OUT.mkdir(parents=True,exist_ok=True)
    if (OUT/'antes.json').exists():raise SystemExit('Baseline já existe')
    paths=[p for base in ['src','prototipo-figma/jsp','prototipo-figma/html','prototipo-figma/css','prototipo-figma/js','prototipo-figma/assets'] for p in (ROOT/base).rglob('*') if p.is_file()]
    (OUT/'antes.json').write_text(json.dumps({p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},indent=2),encoding='utf-8')
    for p in paths:
        if p.suffix=='.jsp' or p.name=='crud-layout.css':
            target=OUT/'antes'/p.relative_to(ROOT);target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(p.read_bytes())
def apply():
    for base in ['src/main/webapp/WEB-INF/jsp','prototipo-figma/jsp']:
        for name in PAGES:
            p=ROOT/base/(name+'.jsp');s=p.read_text(encoding='utf-8')
            if name!='administrations':
                block=re.search(r'(<div class="modal modal-pequeno">)([\s\S]*?)(</div>\s*</div>\s*<script)',s)
                assert block,name
                cancel=re.search(r'<a href="([^"]+)" class="btn btn-secundario">Cancelar</a>',block[0]);assert cancel,name
                assert 'modal-fechar' not in block[0],'Já aplicado'
                anchor='\n        <a href="'+cancel[1]+'" class="modal-fechar" aria-label="Fechar">&times;</a>'
                s=s[:block.end(1)]+anchor+s[block.end(1):]
            s=re.sub(r'<a\b[^>]*class="modal-fechar"[^>]*>',lambda m:m[0] if 'aria-label=' in m[0] else m[0][:-1]+' aria-label="Fechar">',s)
            p.write_text(s,encoding='utf-8')
    css='''
/* Rodada 20 — detalhes alinhados aos dados e fechamento com recuo uniforme. */
body[data-pagina] .modal-overlay > .modal { position:relative; --modal-fechar-recuo:20px; }
body[data-pagina] .modal-overlay .modal-cabecalho { padding-right:48px; }
body[data-pagina] .modal-overlay[id$="-ver"] .modal-cabecalho { padding-left:0; padding-top:0; }
body[data-pagina] .modal-overlay[id$="-ver"] .modal-subtitulo { padding-inline:0; }
body[data-pagina] .modal-overlay .modal-fechar { position:absolute; top:var(--modal-fechar-recuo); right:var(--modal-fechar-recuo); width:28px; height:28px; padding:0; margin:0; display:grid; place-items:center; line-height:1; text-decoration:none; z-index:1; }
body[data-pagina] .modal-overlay .modal-pequeno .confirmacao-titulo { padding-right:44px; }
@media(max-width:650px) { body[data-pagina] .modal-overlay > .modal { --modal-fechar-recuo:16px; } }
'''
    for base in ['src/main/resources/static/assets/css','prototipo-figma/css']:
        p=ROOT/base/'crud-layout.css';assert 'Rodada 20' not in p.read_text(encoding='utf-8');p.write_text(p.read_text(encoding='utf-8')+css,encoding='utf-8')
    render()
def render():
    g=generator()
    for name in PAGES:
        (ROOT/'prototipo-figma/html'/(name+'.html')).write_text(g.generate(name+'.jsp'),encoding='utf-8')
        for page in [2,3]:(ROOT/'prototipo-figma/html'/(name+'-pagina-'+str(page)+'.html')).write_text(g.generate(name+'.jsp',preview_page=page),encoding='utf-8')
    g.ROOT=OUT/'ativo'
    for name in PAGES:
        p=ROOT/'src/main/webapp/WEB-INF/jsp'/(name+'.jsp');dest=g.ROOT/'jsp'/p.name;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(p.read_bytes())
        s=g.generate(p.name).replace('="/assets/','="../../../src/main/resources/static/assets/').replace('</head>','<link rel="stylesheet" href="../../css/fontes.css"></head>')
        s=re.sub(r'href="([a-z-]+)\.html',r'href="ativo-\1.html',s)
        (OUT/('ativo-'+name+'.html')).write_text(s,encoding='utf-8')
def audit():
    before=json.loads((OUT/'antes.json').read_text(encoding='utf-8'))
    changed=[f for f,h in before.items() if hashlib.sha256((ROOT/f).read_bytes()).hexdigest()!=h]
    for f in changed:
        assert f.endswith('crud-layout.css') or any(f.endswith('/'+n+'.jsp') or re.search('/'+re.escape(n)+r'(?:-pagina-[23])?\.html$',f) for n in PAGES),f
        if not f.endswith('.jsp'):continue
        old=(OUT/'antes'/f).read_text(encoding='utf-8');new=(ROOT/f).read_text(encoding='utf-8')
        # Retira somente os novos X/labels para comprovar que todo o conteúdo anterior é idêntico.
        clean=lambda s:re.sub(r' aria-label="Fechar"','',s)
        new=re.sub(r'\n        <a href="[^"]+" class="modal-fechar" aria-label="Fechar">&times;</a>(?=\n        <h3 class="confirmacao-titulo">)','',new)
        assert clean(old)==clean(new),f
    (OUT/'invariantes.json').write_text(json.dumps(dict(passed=True,changed=changed,backendUnchanged=True,formsAndBindingsUnchanged=True),indent=2),encoding='utf-8');print('Contratos preservados:',len(changed),'arquivos de front atualizados.')
if __name__=='__main__':globals()[sys.argv[1]]()
