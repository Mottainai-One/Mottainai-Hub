"""Aplicação localizada dos ajustes públicos, sem modificar Java ou contratos dos forms."""
from pathlib import Path
import re
import sys

root=Path(__file__).resolve().parents[2]
proto=root/'prototipo-figma'
if 'class="carrossel-planos"' in (proto/'jsp/planos.jsp').read_text(encoding='utf-8'):
    raise SystemExit('Rodada já aplicada. Use os scripts de teste e auditoria, sem reaplicar a migração.')
gmail='https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com'
ref=(root/'build/referencia-landing/landing/assets/css/style.css').read_text(encoding='utf-8')
cards_css=ref[ref.index('section#escolha-plano {'):ref.index('/* ============ Dúvidas')]
cards_css=cards_css.replace('../icons/','../img/')
responsive=ref[ref.index('  /* Planos: um card por vez'):ref.index('  /* Dúvidas */',ref.index('  /* Planos: um card por vez'))]
plans_extra='''
/* Rodada 14: somente o padrão existente do hero; cor do UI Kit, sem repetição. */
section#hero #background-lines { position:absolute; inset:0 0 0 auto; width:53%; height:100%; opacity:.28; overflow:visible; background:#426b8c; mask:url('../img/planos-padrao-hero.png') top right / contain no-repeat; -webkit-mask:url('../img/planos-padrao-hero.png') top right / contain no-repeat; pointer-events:none; }
#hero #background-lines img { visibility:hidden; }
body.pagina-planos #duvidas #conteudo-duvidas .btn-contato.botao-com-hover { background:#102a43; border-color:#102a43; color:#fff; }
body.pagina-planos #duvidas #conteudo-duvidas .btn-contato.botao-com-hover:hover { background:#1a3a5c; border-color:#1a3a5c; transform:translateY(-2px); }
body.pagina-planos #duvidas #conteudo-duvidas .btn-contato.botao-com-hover::after { content:none; }
section#escolha-plano { padding:40px max(24px,5.35%) 100px; }
section#escolha-plano .container { gap:35px; }
section#escolha-plano .card-plano { display:block; flex:0 1 328px; min-width:0; }
section#escolha-plano .card-plano#principal { flex-basis:391px; }
section#escolha-plano .card-plano .descricao { margin-top:12px; }
section#escolha-plano .card-plano .preco { margin-top:24px; }
section#escolha-plano #toggle-plano { box-sizing:border-box; width:330px; height:60px; margin-inline:auto; }
section#escolha-plano #toggle-plano .opcao { border:0; background:transparent; font-family:inherit; height:48px; }
section#escolha-plano .btn-plano { text-decoration:none; }
section#escolha-plano .card-plano:not(#principal) .btn-plano { left:27px; right:27px; width:auto; }
section#escolha-plano .card-plano#principal .btn-plano { left:27px; right:27px; width:auto; }
@media(max-width:1024px) {
  section#escolha-plano .container { display:flex; min-width:0; gap:0; }
  section#escolha-plano .container .card-plano { flex:none; }
  section#escolha-plano .container .card-plano:not(.visivel) { display:none; }
  section#escolha-plano .card-plano .btn-plano,section#escolha-plano .card-plano#principal .btn-plano { width:100%; margin-top:32px; }
  section#escolha-plano .seta { width:36px; min-width:36px; }
}
@media(max-width:480px) {
  section#escolha-plano { padding-inline:12px; }
  section#escolha-plano .carrossel-planos { gap:8px; }
  section#escolha-plano .card-plano,section#escolha-plano .card-plano#principal { padding:24px 18px; min-height:510px; }
  section#escolha-plano .card-plano .atributos li,section#escolha-plano .card-plano#principal .atributos li { font-size:13px; }
  section#escolha-plano .card-plano .preco strong { font-size:26px; }
}
'''
about_css='''
/* Rodada 14: controles fixos fora do track; mesmos movimentos automático/manual. */
.hero-carrossel > .car-btn { z-index:3; bottom:17px; }
.hero-carrossel[data-enhanced] .hero-track { animation:none; transition:transform .6s ease; }
.hero-carrossel .car-dots button { width:12px; height:12px; padding:0; border:2px solid #426b8c; border-radius:50%; background:#426b8c; cursor:pointer; }
.hero-carrossel .car-dots button[aria-pressed="true"] { background:#dd7b2d; border-color:#dd7b2d; transform:scale(1.2); }
.hero-carrossel .car-btn { border:0; font:inherit; cursor:pointer; }
.carrossel::scroll-button(*) { content:none; display:none; }
.carrossel-wrap { position:relative; display:block; padding-inline:64px !important; }
.team-arrow { position:absolute; top:155px; width:48px; height:48px; border:0; padding:0; background:transparent; cursor:pointer; z-index:2; }
.team-arrow-prev { left:0; }
.team-arrow-next { right:0; }
.team-arrow img { display:block; width:100%; height:auto; }
.team-arrow-prev img { transform:rotate(180deg); }
.team-arrow[hidden] { display:none; }
@media(max-width:767px) { .carrossel-wrap { padding-inline:56px !important; } .team-arrow { top:160px; width:44px; height:44px; } }
'''

def balanced_end(s,start):
    depth=0
    for m in re.finditer(r'</?div\b[^>]*>',s[start:]):
        depth+= -1 if m.group().startswith('</') else 1
        if depth==0:return start+m.start(),start+m.end()
    raise ValueError('div não fechado')

for production in [False,True]:
    jsp=root/'src/main/webapp/WEB-INF/jsp' if production else proto/'jsp'
    css=root/'src/main/resources/static/assets/css' if production else proto/'css'
    js=root/'src/main/resources/static/assets/js' if production else proto/'js'
    prefix='${pageContext.request.contextPath}/assets' if production else '${pageContext.request.contextPath}/prototipo-figma'
    imgprefix=prefix+'/img' if production else prefix+'/assets/img'
    # Usar o footer da Home correspondente, sem alterar a Home.
    home=(jsp/'home.jsp').read_text(encoding='utf-8')
    footer=re.search(r'<footer>[\s\S]*?</footer>',home).group()
    for page in ['planos','sobre-nos']:
        f=jsp/(page+'.jsp');s=f.read_text(encoding='utf-8')
        s=re.sub(r'<footer>[\s\S]*?</footer>',lambda m:footer,s)
        s=s.replace('</head>',f'<link rel="stylesheet" href="{prefix}/css/footer.css">\n</head>')
        if page=='planos':
            s=s.replace('${pageContext.request.contextPath}/home#contato',gmail)
            s=re.sub(r'<div class="btn-plano([^"]*)">Contratar plano</div>',lambda m:f'<a class="btn-plano{m[1]}" href="{gmail}" target="_blank" rel="noopener noreferrer">Contratar plano</a>',s)
            # O wrapper e as setas recuperam a seção do ZIP; os cards atuais são mantidos.
            start=s.index('<div class="container">',s.index('id="escolha-plano"'));end,endtag=balanced_end(s,start)
            s=s[:endtag]+'\n<button type="button" class="seta" id="seta-proximo" aria-label="Próximo plano">&#10095;</button>\n</div>'+s[endtag:]
            s=s[:start]+'<div class="carrossel-planos">\n<button type="button" class="seta" id="seta-anterior" aria-label="Plano anterior">&#10094;</button>\n'+s[start:]
            if '<script' not in s:s=s.replace('</body>',f'<script src="{prefix}/js/planos.js" defer></script>\n</body>')
        else:
            s=re.sub(r'\s*<(?:button|label)\b[^>]*class="car-btn (?:prev|next)"[^>]*>.*?</(?:button|label)>','',s)
            s=re.sub(r'<div class="car-dots">[\s\S]*?</div>',lambda m:'<button type="button" data-direction="-1" class="car-btn prev" aria-label="Anterior">&#10094;</button>\n<button type="button" data-direction="1" class="car-btn next" aria-label="Próximo">&#10095;</button>\n<div class="car-dots">'+''.join(f'<button type="button" data-slide="{i}" aria-label="Slide {i+1}"></button>' for i in range(4))+'</div>',s)
            pos=0
            while True:
                start=s.find('<div class="carrossel-wrap">',pos)
                if start<0:break
                end,endtag=balanced_end(s,start)
                prev=f'<button type="button" class="team-arrow team-arrow-prev" aria-label="Integrantes anteriores" hidden><img src="{imgprefix}/team-arrow-right.svg" alt=""></button>'
                nxt=f'<button type="button" class="team-arrow team-arrow-next" aria-label="Próximos integrantes"><img src="{imgprefix}/team-arrow-right.svg" alt=""></button>'
                s=s[:end]+nxt+s[end:];s=s[:start+len('<div class="carrossel-wrap">')]+prev+s[start+len('<div class="carrossel-wrap">'):];pos=endtag+len(prev)+len(nxt)
            if 'js/sobre-nos.js' not in s:s=s.replace('</body>',f'<script src="{prefix}/js/sobre-nos.js" defer></script>\n</body>')
        f.write_text(s,encoding='utf-8')
    # Regras dos cards do ZIP, limitadas à seção, seguidas das adaptações responsivas.
    local_cards=cards_css.replace('../img/','../assets/img/') if not production else cards_css
    local_extra=plans_extra.replace('../img/','../assets/img/') if not production else plans_extra
    f=css/'planos.css';f.write_text(f.read_text(encoding='utf-8')+'\n/* Seção recuperada de landing.zip/assets/css/style.css. */\n'+local_cards+'\n@media(max-width:1024px) {\n'+responsive+'\n}\n'+local_extra,encoding='utf-8')
    f=css/'sobre-nos.css';f.write_text(f.read_text(encoding='utf-8')+about_css,encoding='utf-8')
    # Reutilização do JS funcional da referência com os acréscimos de acessibilidade já existentes.
    script=(root/'build/referencia-landing/landing/assets/js/planos.js').read_text(encoding='utf-8')
    script=script.replace('  posicionarRetangulo();','  posicionarRetangulo();\n  opcaoMensal.setAttribute("aria-pressed", String(modo === "mensal"));\n  opcaoAnual.setAttribute("aria-pressed", String(modo === "anual"));\n  secao.querySelectorAll(".preco > span").forEach(el => el.textContent = modo === "anual" ? "/ano" : "/mês");')
    script+='\nopcaoMensal.setAttribute("aria-pressed","true");\nopcaoAnual.setAttribute("aria-pressed","false");\n'
    (js/'planos.js').write_text(script,encoding='utf-8')

# O gerador não deve reinserir o aviso nas próximas gerações.
f=proto/'tools/gerar_html.py';s=f.read_text(encoding='utf-8');s=re.sub(r"        note = .*?\n",'',s);s=s.replace("+' method=\"dialog\"'+note+'>'","+' method=\"dialog\"'+'>'")
s=re.sub(r"    if name in \['sobre-nos.jsp','planos.jsp','faq.jsp'\]:\n        text=text.replace\('</body>'.*?\n",'',s)
f.write_text(s,encoding='utf-8')
