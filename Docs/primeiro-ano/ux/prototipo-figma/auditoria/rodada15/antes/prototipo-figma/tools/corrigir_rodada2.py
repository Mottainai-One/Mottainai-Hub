from pathlib import Path
import re,zipfile
R=Path('prototipo-figma');A=Path('.')
if (R/'auditoria/rodada2/correcoes-aplicadas.txt').exists():
 raise SystemExit('Correções já aplicadas. Esta ferramenta registra a primeira aplicação; não sobrescreve a revisão final.')
with zipfile.ZipFile(Path('../CrudInicial - Copia_V7.zip')) as z:
 def original(suffix):
  name=next(n for n in z.namelist() if n.endswith('/'+suffix) or n==suffix)
  return z.read(name).decode('utf-8-sig')
 crud=original('src/main/resources/static/assets/css/crud.css')
 crud=re.sub(r'(?m)^\s*@import[^\n]*\n','',crud)
 (R/'css/crud.css').write_text(crud+'''
/* Rodada 2: visual V7 restaurado; somente independência de altura da navegação. */
body[data-pagina] .sidebar { position:sticky; top:0; height:100vh; height:100dvh; min-height:0; align-self:start; overflow-y:auto; }
body[data-pagina] .header { position:sticky; top:0; height:var(--header-altura); z-index:20; }
body[data-pagina] .main { min-width:0; }
/* Preview isolado: fragmento abre o mesmo modal, sem substituir o submit JSP. */
body[data-pagina] .modal-overlay:target { display:flex; }
body[data-preview="static"]:has(.modal-overlay:target) { overflow:hidden; }
body[data-preview="static"] .preview-notice { position:fixed; right:12px; bottom:8px; z-index:900; padding:5px 10px; max-width:85vw; background:#fff3e4; border:1px solid #ebc49e; border-radius:5px; font-size:11px; color:#71300a; }
body[data-preview="static"]:has(.modal-overlay:target) .preview-notice { display:none; }
@media(max-width:650px) { body[data-pagina] .sidebar { position:relative; height:auto; max-height:100dvh; } body[data-pagina] .header { position:relative; } }
''',encoding='utf-8')
 planosjs=original('src/main/resources/static/assets/js/planos.js')
 # O mecanismo de animação original permanece; botões nativos recebem estado acessível.
 planosjs=planosjs.replace('  posicionarRetangulo();','  posicionarRetangulo();\n  opcaoMensal.setAttribute("aria-pressed", String(modo === "mensal"));\n  opcaoAnual.setAttribute("aria-pressed", String(modo === "anual"));\n  secao.querySelectorAll(".preco > span").forEach(el => el.textContent = modo === "anual" ? "/ano" : "/mês");')
 planosjs+='\nopcaoMensal.setAttribute("aria-pressed", "true");\nopcaoAnual.setAttribute("aria-pressed", "false");\n'
 (R/'js/planos.js').write_text(planosjs,encoding='utf-8')
# Uniformiza o favicon escolhido; não altera o body administrativo.
icon='<link rel="shortcut icon" href="${pageContext.request.contextPath}/prototipo-figma/assets/img/favicon.ico" type="image/x-icon">'
for p in (R/'jsp').glob('*.jsp'):
 s=p.read_text(encoding='utf-8');s=re.sub(r'\s*<link\b[^>]*\brel="(?:shortcut )?icon"[^>]*>','',s)
 s=s.replace('</head>',icon+'\n</head>');p.write_text(s,encoding='utf-8')
# Home: fonte JSP primeiro; HTML será gerado a partir dela.
p=R/'jsp/home.jsp';s=p.read_text(encoding='utf-8')
s=s.replace('<p><!-- Texto real pendente --></p>','<p>O nosso sistema preditivo pode sugerir os próximos passos para uma boa gestão</p>',1)
s=s.replace('<p><!-- Texto real pendente --></p>','<p>Os dados coletados sobre os últimos registros podem ser visualizados e usados para análises</p>',1)
# Marca aprovada em camada de imagem sobre o slot gráfico do mockup; raster permanece intacto.
needle='alt="Painel administrativo Mottainai" />'
s=s.replace(needle,needle+'\n                    <span class="marca-monitor" aria-hidden="true"><img src="${pageContext.request.contextPath}/prototipo-figma/assets/img/home-logo.png" alt=""></span>')
# Hover público não alcança o trecho aprovado dos modais.
marker='    <!-- ===== MODAL DE LOG-IN ===== -->';before,modal=s.split(marker,1)
before=re.sub(r'class="(btn(?: btn-[^"]+)?|btn-contato)"',lambda m:'class="'+m.group(1)+' botao-com-hover"',before)
p.write_text(before+marker+modal,encoding='utf-8')
# Sobre Nós: controles nativos, mesmos destinos de slides/IDs/radios.
p=R/'jsp/sobre-nos.jsp';s=p.read_text(encoding='utf-8')
s=re.sub(r'<label for="hero-(\d)"(.*?)>(.*?)</label>',lambda m:'<button type="button" data-slide="'+str(int(m.group(1))-1)+'"'+m.group(2)+'>'+m.group(3)+'</button>',s)
s=s.replace('class="contato-button btn"','class="contato-button btn botao-com-hover"')
s=s.replace('</body>','<script src="${pageContext.request.contextPath}/prototipo-figma/js/sobre-nos.js" defer></script>\n</body>')
p.write_text(s,encoding='utf-8')
# Planos: restaura os IDs e o mecanismo da V7 em buttons acessíveis.
p=R/'jsp/planos.jsp';s=p.read_text(encoding='utf-8')
s=re.sub(r'<fieldset id="toggle-plano">[\s\S]*?</fieldset>','''<div id="toggle-plano" role="group" aria-label="Periodicidade de cobrança dos planos">
          <div id="retangulo"><button type="button" class="opcao" id="mensal">Mensal</button></div>
          <button type="button" class="opcao" id="anual">Anual</button>
        </div>''',s)
s=re.sub(r'<strong class="valor-mensal">(.*?)</strong><strong class="valor-anual">.*?</strong>',r'<strong>\1</strong>',s)
s=s.replace('<span class="periodo-mensal">/mês</span><span class="periodo-anual">/ano</span>','<span>/mês</span>')
s=re.sub(r'class="(btn-contato|btn-saiba-mais|btn-plano)"',r'class="\1 botao-com-hover"',s)
s=s.replace('</body>','<script src="${pageContext.request.contextPath}/prototipo-figma/js/planos.js" defer></script>\n</body>')
p.write_text(s,encoding='utf-8')
p=R/'jsp/faq.jsp';s=p.read_text(encoding='utf-8');s=s.replace('class="btn-contato"','class="btn-contato botao-com-hover"');p.write_text(s,encoding='utf-8')
# Recursos gráficos V7 reutilizados, sem edição de pixels.
for name in ['list-marked-orange.svg']:
 (R/'assets/img'/name).write_bytes((A/'src/main/resources/static/assets/img'/name).read_bytes())
p=R/'index.html';s=p.read_text(encoding='utf-8');s=s.replace('<title>', '<link rel="shortcut icon" href="assets/img/favicon.ico" type="image/x-icon"><title>',1);p.write_text(s,encoding='utf-8')
print('Restauração V7 e ajustes cirúrgicos nos JSPs concluídos. Nenhum arquivo ativo escrito.')
