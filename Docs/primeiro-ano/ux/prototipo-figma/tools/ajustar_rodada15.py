from pathlib import Path
import re,shutil
root=Path(__file__).resolve().parents[2]
ctx='${pageContext.request.contextPath}'
def read(p):return p.read_text(encoding='utf-8')
def write(p,s):p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf-8')
if 'Rodada 15' in read(root/'prototipo-figma/css/crud-layout.css'):raise SystemExit('Rodada já aplicada')
for base in [root/'src/main/resources/static/assets',root/'prototipo-figma/assets']:
    shutil.copyfile(Path('C:/Users/20260215-ieg/Downloads/Group 147.svg'),base/'img/wordmark-mottainai.svg')
shutil.copyfile(root/'prototipo-figma/assets/icons/perfil-usuario-figma.svg',root/'src/main/resources/static/assets/icons/perfil-usuario-figma.svg')

# Links apontam para seções reais; Termos aponta para Planos por decisão do usuário.
links={'Diferencial':'/home#diferencial','Funcionalidades':'/home#funcionalidades','Sistema':'/home#sistema','Nossa equipe':'/sobre-nos#nossa-equipe','Nosso propósito':'/sobre-nos#proposta','No que acreditamos':'/sobre-nos#nosso-ideal','Condições':'/planos#escolha-plano','Termos de Uso':'/planos','Contato':'/planos#duvidas'}
for parallel in [False,True]:
    jsp=root/('prototipo-figma/jsp' if parallel else 'src/main/webapp/WEB-INF/jsp')
    css=root/('prototipo-figma/css' if parallel else 'src/main/resources/static/assets/css')
    js=root/('prototipo-figma/js' if parallel else 'src/main/resources/static/assets/js')
    assets=ctx+('/prototipo-figma/assets' if parallel else '/assets')
    web=ctx+('/prototipo-figma' if parallel else '/assets')
    for name in ['home','sobre-nos','planos','faq']:
        p=jsp/(name+'.jsp')
        if not p.exists():continue
        s=read(p)
        # Apenas as imagens de marca do header e footer.
        h=re.search(r'<header\b[\s\S]*?</header>',s)
        if h:
            new=re.sub(r'(<img\b[^>]*\bsrc=")[^"]+("[^>]*>)',lambda m:m[1]+assets+'/img/wordmark-mottainai.svg'+m[2],h[0],count=1)
            s=s[:h.start()]+new+s[h.end():]
        f=re.search(r'<footer\b[\s\S]*?</footer>',s)
        if f:
            footer=f[0]
            footer=re.sub(r'<img\b[^>]*>',f'<img class="footer-wordmark" src="{assets}/img/wordmark-mottainai.svg" alt="Mottainai" />',footer,count=1)
            for text,url in links.items():footer=footer.replace('<li>'+text+'</li>',f'<li><a href="{ctx}{url}">{text}</a></li>')
            footer=footer.replace('<li>Instagram: @mottainai_app</li>','<li><a href="https://www.instagram.com/mottainai.estoques/" target="_blank" rel="noopener noreferrer">Instagram: @mottainai.estoques</a></li>')
            footer=footer.replace('<li>Tel Empresarial: (+55) 11 91234-5678</li>','<li><a href="https://wa.me/5511993332592" target="_blank" rel="noopener noreferrer">Tel Empresarial: (+55) 11 99333-2592</a></li>')
            footer=footer.replace('<li>Email: mottainai@gmail.com.br</li>','<li><a href="https://mail.google.com/mail/?view=cm&amp;fs=1&amp;to=mottainai.contato@gmail.com" target="_blank" rel="noopener noreferrer">Email: mottainai.contato@gmail.com</a></li>')
            s=s[:f.start()]+footer+s[f.end():]
        if name=='home':s=s.replace('<section class="estatistica">','<section id="diferencial" class="estatistica">')
        # FAQ compartilha exatamente o mesmo footer e CSS da Home desta versão.
        if name=='faq':
            homefooter=re.search(r'<footer\b[\s\S]*?</footer>',read(jsp/'home.jsp'))[0]
            s=re.sub(r'<footer\b[\s\S]*?</footer>',lambda m:homefooter,s)
        if f and '/css/footer.css' not in s:s=s.replace('</head>',f'<link rel="stylesheet" href="{web}/css/footer.css">\n</head>')
        write(p,s)

    # Perfil comum usa a sessão real, sem consulta nem alteração do backend.
    profile=f'''<div class="perfil-administrativo">
            <button type="button" class="header-usuario perfil-trigger" aria-expanded="false" aria-controls="perfil-popup">
                <span class="header-nome">Administrador</span>
                <span class="header-avatar"><img src="{assets}/icons/user.svg" alt="" /></span>
            </button>
            <div class="perfil-popup" id="perfil-popup" hidden aria-labelledby="perfil-titulo">
                <strong class="perfil-titulo" id="perfil-titulo">Minha conta</strong>
                <p class="perfil-subtitulo">Informações do perfil</p>
                <div class="perfil-avatar"><img src="{assets}/icons/perfil-usuario-figma.svg" alt="" /></div>
                <p class="perfil-email"><c:out value="${{sessionScope.administrationEmail}}" /></p>
                <span class="perfil-cargo">Administrador do sistema</span>
                <form action="{ctx}/logout" method="post"><button type="submit" class="perfil-sair"><img src="{assets}/icons/logout.svg" alt="" />Sair da conta</button></form>
            </div>
        </div>'''
    for p in jsp.glob('*.jsp'):
        s=read(p)
        if 'data-pagina=' not in s:continue
        h=re.search(r'<header class="header">[\s\S]*?</header>',s)
        if not h:continue
        head=h[0]
        if 'perfil-administrativo' in head:
            start=head.index('<div class="perfil-administrativo">')
        else:start=head.index('<div class="header-usuario">')
        head=head[:start]+profile+'\n    </header>'
        s=s[:h.start()]+head+s[h.end():]
        if '/js/crud-ux.js' not in s:s=s.replace('</body>',f'<script src="{web}/js/crud-ux.js"></script>\n</body>')
        if p.stem=='home-crud-page':
            paths=iter(['/empresas','/lojas','/funcionarios','/contas'])
            s=re.sub(r'<div class="card-resumo">([\s\S]*?)</div>',lambda m:f'<a class="card-resumo" href="{ctx}{next(paths)}">'+m[1]+'</a>',s)
        write(p,s)

    # Contratos de busca intactos; espaço vazio ocupa os mesmos 16px de linha + 8px de margem.
    p=js/'crud-ux.js';s=read(p)
    s=s.replace("const status = document.createElement('p');", "const status = document.createElement('div');")
    s=s.replace("status.className = 'busca-status'; status.setAttribute('role', 'status'); status.setAttribute('aria-live', 'polite');", "status.className = 'busca-status'; status.setAttribute('aria-hidden', 'true');")
    s=re.sub(r'    status.textContent = term \?[\s\S]*?;\n', '',s)
    # Nos JSPs ativos antigos não existia filtro local: apenas o popup é acrescentado.
    # O fluxo GET original permanece livre em todos os casos.
    write(p,s)

    p=css/'crud-layout.css';write(p,read(p)+'''
/* Rodada 15 — alinhamento comum, espaço de busca e perfil Figma 171:7734. */
body[data-pagina] .modal-subtitulo { padding-inline:22px; }
body[data-pagina] .busca-status { height:16px; min-height:16px; margin:0 0 8px; padding:0; }
body[data-pagina] a.card-resumo { display:flex; flex-direction:column; text-decoration:none; color:inherit; cursor:pointer; }
body[data-pagina] a.card-resumo:focus-visible { outline:3px solid #dd7b2d; outline-offset:3px; }
body[data-pagina] a.card-resumo:hover { box-shadow:0 3px 12px #102a431a; }
body[data-pagina] .perfil-administrativo { position:relative; margin-left:auto; }
body[data-pagina] .perfil-trigger { color:inherit; cursor:pointer; border:0; background:transparent; font:inherit; }
body[data-pagina] .perfil-trigger:focus-visible { outline:2px solid #ed842c; outline-offset:3px; }
body[data-pagina] .perfil-popup { position:absolute; top:calc(100% + 10px); right:0; width:264px; max-width:calc(100vw - 36px); min-height:330px; height:auto; max-height:none; overflow:visible; padding:19px; box-sizing:border-box; background:#fff; border:1px solid #e8eef2; border-radius:18px; box-shadow:0 10px 26px #0a213821; color:#162f43; text-align:left; z-index:40; font-family:Inter,Arial,sans-serif; }
body[data-pagina] .perfil-popup[hidden] { display:none; }
body[data-pagina] .perfil-popup::before { content:""; position:absolute; top:0; left:19px; right:19px; height:4px; border-radius:2px; background:#ed842c; }
body[data-pagina] .perfil-popup .perfil-titulo { display:block; margin:0; font-size:16px; font-weight:600; line-height:20px; }
body[data-pagina] .perfil-popup .perfil-subtitulo { margin:5px 0 0; font-size:10px; line-height:20px; color:#83939d; }
body[data-pagina] .perfil-popup .perfil-avatar { display:grid; place-items:center; width:84px; height:84px; margin:18px auto 16px; border:1px solid #d7e3e9; border-radius:50%; background:#eaf1f4; }
body[data-pagina] .perfil-popup .perfil-avatar img { display:block; width:48px; height:48px; }
body[data-pagina] .perfil-popup .perfil-email { margin:0; min-height:20px; font-size:11px; font-weight:500; line-height:20px; color:#23394a; text-align:center; overflow-wrap:anywhere; }
body[data-pagina] .perfil-popup .perfil-cargo { display:block; width:160px; max-width:100%; margin:3px auto 0; border-radius:12px; background:#f2f6f8; color:#657986; text-align:center; font-size:9px; font-weight:500; line-height:24px; }
body[data-pagina] .perfil-popup form { margin:16px 0 0; padding:18px 0 0; border-top:1px solid #eaeff2; }
body[data-pagina] .perfil-popup .perfil-sair { display:flex; align-items:center; justify-content:center; gap:11px; width:100%; min-height:46px; padding:10px; box-sizing:border-box; border:1px solid #fbe2df; border-radius:11px; background:#fff2f0; color:#b64141; font:600 12px/20px Inter,Arial,sans-serif; cursor:pointer; }
body[data-pagina] .perfil-popup .perfil-sair img { width:20px; height:20px; filter:brightness(0) saturate(100%) invert(32%) sepia(60%) saturate(900%) hue-rotate(323deg); }
body[data-pagina] .perfil-popup .perfil-sair:hover { background:#ffe6e2; color:#b64141; }
@media(max-width:650px) { body[data-pagina] .modal-subtitulo { padding-inline:16px; } }
''')

    p=css/'planos.css';write(p,read(p)+'''
/* Rodada 15 — escala ampla original do hero e halo centrado no próprio card. */
section#hero { overflow:hidden; }
section#hero #background-lines { inset:auto; top:-170px; right:0; width:762px; height:846px; overflow:visible; }
section#hero #background-lines img { width:100%; height:auto; object-fit:initial; }
section#escolha-plano .card-plano#principal .blur { left:50%; top:50%; transform:translate(-50%,-50%); width:240%; height:240%; pointer-events:none; }
section#escolha-plano .card-plano#principal .blur img { display:block; width:100%; height:100%; object-fit:fill; }
@media(max-width:1100px) { section#hero #background-lines { right:-180px; } }
@media(max-width:767px) { section#hero #background-lines { right:-350px; } }
''')
    p=css/'home.css';s=read(p).replace('translateY(-96px)','translateY(-120px)')
    # Não muda a geometria dos aparelhos: sombra independente no pseudo-elemento.
    s+='''
/* Rodada 15 — sombra elíptica concentrada, sem transformar os aparelhos. */
.hero-imagem::after { content:""; position:absolute; pointer-events:none; z-index:0; width:68%; height:38px; left:50%; bottom:-5px; transform:translateX(-50%); border-radius:50%; background:radial-gradient(ellipse at center,rgba(16,42,67,.23) 0%,rgba(16,42,67,.12) 38%,rgba(16,42,67,0) 72%); filter:blur(6px); }
'''
    if not parallel:s+='''
/* O hero ativo usa uma coluna de imagens sem altura própria: ancora somente a sombra. */
.hero-imagem::after { width:400px; max-width:none; left:auto; right:-45px; bottom:-203px; transform:none; }
'''
    write(p,s)
    p=css/'sobre-nos.css';write(p,read(p)+'''
/* Rodada 15 — hero discreto; equipe mantém círculos escuros fora das fotos. */
.hero-carrossel > .car-btn { background:transparent; color:#fff; box-shadow:none; width:48px; height:48px; font-size:0; display:grid; place-items:center; }
.hero-carrossel > .car-btn::before { content:""; display:block; width:12px; height:12px; border-top:3px solid currentColor; border-right:3px solid currentColor; transform:rotate(45deg); }
.hero-carrossel > .car-btn.prev::before { transform:rotate(-135deg); }
.hero-carrossel > .car-btn:hover { background:#ffffff12; color:#fff; }
.carrossel[data-moving] { scroll-snap-type:none; scroll-behavior:auto; }
@media(prefers-reduced-motion:reduce) { .carrossel { scroll-behavior:auto; } }
''')

# Footer compartilhado é carregado também na Home/FAQ; mantém estilos da Home e ajusta só a marca/links.
footer_extra='''
/* Rodada 15 — mesmo wordmark real e navegação em todas as páginas públicas. */
body > footer .footer-logo img.footer-wordmark { display:block; width:188px; height:45px; position:relative; inset:auto; top:0; margin:0 0 13px; object-fit:contain; }
body > footer a { color:inherit; text-decoration:none; }
body > footer a:hover { text-decoration:underline; text-underline-offset:3px; }
body > footer a:focus-visible { outline:2px solid #dd7b2d; outline-offset:3px; }
html { scroll-padding-top:20px; }
'''
for p in [root/'prototipo-figma/css/footer.css',root/'src/main/resources/static/assets/css/footer.css']:write(p,read(p)+footer_extra)
print('JSP/CSS/assets/JS compartilhado atualizados')
