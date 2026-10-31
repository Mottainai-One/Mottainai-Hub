from pathlib import Path
import json,zipfile,hashlib
R=Path('prototipo-figma');D=R/'auditoria/rodada2'
changes=[]
with zipfile.ZipFile(D/'fontes-prototipo-antes.zip') as z:
 for name in z.namelist():
  p=R/name
  if p.is_file() and p.read_bytes()!=z.read(name):changes.append(name)
# A comparação textual acima inclui a normalização de quebras de linha na cópia, sem tocar a origem.
pages=['home','sobre-nos','planos','faq','home-crud-page','companies','stores','employees','employee-roles','user-accounts','subscription-plans','addresses']
labels=['Home','Sobre Nós','Planos públicos','FAQ','Dashboard','Empresas','Lojas','Funcionários','Cargos','Contas','Planos administrativos','Endereços']
lines=['# Correções do protótipo — rodada 2','', 'Data: 27/10/2026. Este relatório substitui as decisões visuais conflitantes da primeira rodada; o relatório anterior permanece como histórico. A aplicação ativa não foi integrada nem substituída.', '',
'## Escopo e fontes','',
'Fontes simultâneas: ZIP original `CrudInicial - Copia_V7.zip`, protótipo anterior (backup dos fontes em `auditoria/rodada2/fontes-prototipo-antes.zip`), arquivo Figma `1tyMSHpCTzRqNNWRy1WlHt` e os dois anexos desta solicitação. Os apontamentos novos prevalecem: CRUD volta à V7 e funcionalidades JS aprovadas são restauradas.', '',
'Apenas `prototipo-figma/` foi escrito nesta rodada. Nenhum Java, banco, Controller, Service, Repository, Entity, DTO, contrato HTTP, autenticação, sessão, AES, BCrypt ou arquivo frontend ativo foi modificado. O snapshot de 275 arquivos ativos existentes no início desta rodada está em `auditoria/rodada2/base-ativa.json`; a auditoria compara com esse estado, preservando as alterações externas já apontadas na rodada anterior.', '',
'## CRUD','',
'O corpo original de `crud.css` foi restaurado a partir da V7, incluindo tamanhos, fontes, tabelas, filtros, modais, busca, paginação, botões e estilos existentes. A única normalização do trecho original é remover import remoto de fonte quando presente, usando o arquivo de fontes local já disponível. `auditoria/rodada2/css-v7.json` confirma que o CSS-base é o mesmo, desconsideradas quebras/espaços de formatação. As regras amplas de redesenho adicionadas na primeira rodada foram removidas.', '',
'A sidebar agora é um item do grid `.app` com `position: sticky; top: 0; height: 100dvh` (fallback `100vh`), `align-self: start` e overflow próprio. Assim, a linha de grid pode crescer com a tabela sem esticar a sidebar. O header mantém os 72 px V7 e fica sticky no topo; `.main` recebe apenas `min-width: 0`. Em mobile preserva-se o fluxo original: sidebar relativa, sem fixar uma navegação grande por cima do conteúdo. Modais mantêm seu z-index e contratos originais.', '',
'Os oito bodies administrativos continuam idênticos à V7 após normalização exclusiva dos caminhos de recursos. Fora do body, todos passaram a usar o mesmo favicon. Regras extras do preview apenas abrem o modal por `:target`, preservam Escape e mostram o aviso de demonstração; não mudam submit de JSP.', '',
'Teste de muitos registros: `auditoria/rodada2/muitos-registros.html`, acessível pela galeria, contém 60 linhas estáticas provenientes do mesmo template. Nenhum banco ou JavaScript de CRUD simulado. Em 1812 × 963, a página mediu 3913 px de altura; a sidebar mediu 963 px antes e depois de rolar 2400 px, mantendo y=0. Header também permaneceu em y=0. Evidência: `sidebar-60-registros.png` e `testes-browser.json`.', '',
'## Home','',
'Frame consultado: Home `91:9137`, cards `91:9358`, texto da estatística `91:9349`, gráficos `91:9138`, `91:9230`, `91:9194`, monitor `91:9369` e seu conteúdo `91:9370`.', '',
'| APONTAMENTO | CORREÇÃO | RESULTADO |','|---|---|---|',
'| Dois Entre em contato com hover diferente | Classe comum `botao-com-hover`, com a regra real da V7 | Mesmo transform de -2 px, duração .2s e easing ease; destinos inalterados |',
'| Hero já próximo | Estrutura, textos e dois celulares mantidos | Sem reconstrução; somente hover e contenção da decoração |',
'| Segunda seção e linhas laranjas | Padding superior ajustado; asset do hero contido na altura anterior aos cards | Linhas continuam visíveis sem alcançar os cards; seção desceu em relação à rodada 1 |',
'| Quatro cards | Dimensões próximas de 290 × 370, imagem de 158, título 21.7 e corpo 15.8 px em desktop | Grid responsivo, padding/radius/sombra preservados e textos completos |',
'| Dois textos ausentes | Recuperados dos nodes dos componentes do Figma | Nenhum texto inventado |',
'| Seção 33% | Imagem passa a 58% e texto a 42%, mantendo imagem de 685 px de altura | Medidos 835.19 px de imagem e 604.81 px de texto em 1440 px |',
'| Linhas azuis curtas | Reutilizados os PNGs existentes, movidos para o contêiner comum; canvas transparente inspecionado | Percurso contínuo por funcionalidades, ecossistema e CTA; não foram desenhadas curvas novas |',
'| Quarta/quinta seções desconectadas | Altura do mockup e espaçamento do ecossistema ajustados; CTA aproxima-se da seção anterior | Composição contínua, com as curvas atrás do conteúdo |',
'| CTA com dois botões desiguais | Login e Saiba mais mantidos, com 216 × 54 px em desktop | Dimensões iguais, primário/outline diferentes e hover igual |',
'| Logo verde no monitor | Pesquisados os assets V7 e o monitor do Figma; ambos ainda trazem a marca verde antiga | Marca laranja/azul existente `home-logo.png` recomposta em camada HTML sobre o cabeçalho gráfico e o pequeno ícone lateral, sem filtro CSS e sem editar pixels do raster |', '',
'Textos recuperados: “O nosso sistema preditivo pode sugerir os próximos passos para uma boa gestão” (`I91:9360;1242:74428`); “Os dados coletados sobre os últimos registros podem ser visualizados e usados para análises” (`I91:9359;1242:74443`).', '',
'A proporção 58/42 segue expressamente o novo apontamento que pede imagem maior que a área de texto. O frame consultado ainda apresenta imagem de aproximadamente 538 px em 1440; portanto, essa diferença foi intencional e não é declarada cópia exata do Figma.', '',
'Logo do monitor: não foi encontrado export atualizado com a identidade pedida. A composição reutiliza o logo do header e um fundo claro no slot do cabeçalho gráfico; não substitui tabela/formulário por imagem nem cria uma interface falsa. O raster original continua intacto. Se a equipe fornecer um mockup oficial atualizado, ele pode substituir a composição sem mudança de backend. Essa solução visual deve ser avaliada na aprovação humana.', '',
'## Sobre Nós','',
'Frame `91:8980` consultado novamente. Na V7 não havia arquivo JS para o hero: havia autoplay por keyframes CSS e escolha manual por radios. O primeiro clique desativava o keyframe, criando mecanismos distintos. Não foi reproduzido um refresh HTTP nos labels originais; o problema observável era a troca de mecanismo/animação. Os controles agora são buttons `type="button"`, mantendo os IDs/radios, sem href/hash.', '',
'`sobre-nos.js` centraliza a mudança em `goToSlide(index)`. Auto, setas, indicadores e teclado atualizam o mesmo radio/estado e utilizam `transform .6s ease` do track V7. Intervalo de sete segundos preservado. Hover/foco pausam o autoplay; ao sair, ele retoma. A preferência por movimento reduzido é respeitada. Nenhum JS posiciona ou dimensiona o layout.', '',
'Foram executadas duas trocas automáticas, uma antes e outra depois de direita/esquerda/bolinha, inclusive a volta do último slide ao primeiro. Zero navegações, mudança de URL ou hash. As duas rotas usam a mesma duração/easing medidos. Evidência em `testes-browser.json`.', '',
'As linhas de Nossa Equipe foram exportadas isoladamente dos nodes `91:8981` e `91:9018`, após constatar que a composição anterior não reproduzia o percurso. São apenas gráficos transparentes, sem texto, fotos, botões ou UI rasterizada. A posição de cada camada acompanha a referência. O zoom herdado de 1.15 no bloco da equipe foi retirado para que fotos/espaços respeitem as dimensões do frame. Os dois títulos de ano agora medem 235 × 68 px, têm mesmo padding/fonte e nowrap; em mobile medem 180 × 61.', '',
'Nomes, funções, pessoas e ordem da equipe foram mantidos da V7, mesmo quando diferem do frame. Os carrosséis horizontais da equipe continuam usando a rolagem nativa existente; nenhuma troca por backend ou API.', '',
'## Planos','',
'Frame `91:8231` e padrão `91:8232` consultados. O hero isola a decoração com `overflow: hidden`; `section#hero #background-lines` ocupa exatamente 50% e termina no fim do hero. A regra antiga de 78% tinha maior especificidade e foi corrigida. Medição: hero 1440 × 620 em y=93; ondas x=720, largura 720, bottom=713; planos começam em y=713. Em mobile há tratamento de opacidade para manter o texto legível.', '',
'O `planos.js` da V7 foi reaproveitado, restaurando IDs `mensal`, `anual` e `retangulo`, contagem via requestAnimationFrame de 600 ms, easeOutCubic, reposicionamento do seletor e classes anuais. Somente os controles div foram tornados buttons nativos e o estado aria-pressed foi sincronizado. O sufixo mês/ano preserva a apresentação da versão paralela. Preços permanecem 1200/3500 e 10000/28000, sem backend, reload ou reconstrução da página.', '',
'Teste observou um valor intermediário e depois R$ 10.000 / R$ 28.000; o retorno terminou em R$ 1.200 / R$ 3.500. URL permaneceu a mesma. O hover dos CTAs foi padronizado sem unificar cores de primário/outline.', '',
'## Botões','',
'Padrão: classe `botao-com-hover` em `css/publico.css`. Fonte real: `.btn` / `.btn:hover` de `home.css` V7, usado pelo Entre em contato principal do hero: `transform: translateY(-2px)` e transições de `transform`, `background-color` e `border-color` em `.2s ease`.', '',
'As antigas elevações de top:-5px, drop-shadow e scale das outras páginas foram neutralizadas somente nos elementos dessa classe. Foram verificados os 16 botões/CTAs públicos marcados: transform, duração, easing, filtro e opacidade iguais no hover. Nenhuma classe foi adicionada dentro dos modais aprovados. As cores e dimensões específicas permanecem, exceto a igualdade pedida para os dois botões do CTA Home.', '',
'## Favicon','',
'Um único asset já existente: `assets/img/favicon.ico`. JSP usa contextPath e HTML usa caminho relativo. Galeria e fixture longa também o declaram. Login/Cadastro abrem na Home, mantendo o mesmo head/favicon.', '',
'| PÁGINA | HTML / NAVEGAÇÃO | JSP / DECLARAÇÃO | FAVICON OK |','|---|---|---|---|']
for name,label in zip(pages,labels):lines.append(f'| {label} | Verificado no Chrome | Mesmo asset; JSP compilado | SIM |')
lines += ['| Login via Home | Modal na mesma página | Head da Home preservado | SIM |','| Galeria / tabela longa | Caminho local validado | Não aplicável | SIM |','',
'## JavaScript','',
'| ARQUIVO | MOTIVO DE EXISTIR | ALTERAÇÃO |','|---|---|---|',
'| `js/crud.js` | Máscaras, validações, seleção de navegação e interação administrativa já existentes | Mantido da rodada anterior; nenhum fake CRUD |',
'| `js/modais.js` | Interação aprovada de Login/Cadastro | Byte a byte igual à V7 |',
'| `js/planos.js` | Troca animada aprovada de preços/seletor | Restaurado da V7, com pequenos ajustes de acessibilidade/sufixo visual |',
'| `js/sobre-nos.js` | Unificar autoplay/manual no mesmo mecanismo e impedir navegação dos controles | Novo e restrito à interação real do hero; V7 só possuía CSS nesse fluxo |', '',
'FAQ continua sem JS. Nenhum JS foi acrescentado para sidebar, decoração, grid, responsividade, espaçamentos ou hover.', '',
'## Equivalência HTML ↔ JSP e contratos','',
'JSP continua sendo a fonte funcional. Todos os HTMLs foram regenerados a partir dos JSPs, usando o mesmo CSS/JS/assets. A projeção GET das 12 páginas foi comparada com cada HTML gerado, normalizadas somente as quebras de linha. Essa projeção não executa Spring: a compilação Jasper é uma validação separada.', '',
'| PÁGINA | HTML VISUAL | JSP VISUAL | EQUIVALENTES? |','|---|---|---|---|']
for name,label in zip(pages,labels):lines.append(f'| {label} | `html/{name}.html` atualizado | `jsp/{name}.jsp` atualizado; mesmos recursos | SIM |')
lines += ['',
'Diferenças obrigatórias: HTML tem dados fixos, aviso de preview, navegação local, formulários inertes e fragmentos de modal; JSP mantém EL/JSTL/Model, names, actions, methods, valores, mensagens, hidden inputs, queries, IDs e contextPath. A fixture de 60 linhas é exclusiva de teste visual. Os HTMLs não autenticam, persistem nem simulam sucesso.', '',
'`auditoria/invariantes.json` confirma oito bodies administrativos idênticos à origem, contratos dos três JSPs públicos preservados, modais aprovados idênticos, contatos inalterados e nenhum caminho de recurso quebrado. Banco/rotas/Java não foram usados para viabilizar diferenças visuais.', '',
'## Testes e resultados','',
'- Compilação Jasper/Java 21 dos 12 JSPs: zero erros; artefatos em nova pasta temporária, sem editar Java de produção.',
'- 40 combinações de layout: públicas 1440/1024/768/390; administrativas 1812/768/390. Sem overflow destrutivo, imagens ausentes, erro JavaScript ou POST no preview.',
'- Sidebar com 60 linhas e rolagem; sete modais de edição; Login/Cadastro e Escape; troca de preços com contagem; auto/manual do hero; dimensões dos anos e dos dois CTAs; navegação local e favicon.',
'- Hover em 16 botões públicos: mesma subida de 2 px, .2s/ease, sem deslocamento top adicional nem filtro.',
'- Equivalência HTTP das 12 projeções JSP/HTML e rejeição de POST 405 no servidor isolado.',
'- Hashes dos 275 arquivos ativos existentes no início da rodada e auditoria de contratos aprovados.', '',
'Evidências: `auditoria/rodada2/testes-browser.json`, `hover-global.json`, `css-v7.json`, `compilacao-jsp.log`, `medidas-antes.json`, `medidas-depois.json`, capturas PNG e `auditoria/preview.json`. Testes reais de login/CRUD no Spring/Aiven e build completo não foram reexecutados; não se declara teste funcional de banco com dados estáticos. Não se afirma fidelidade de 100% ou pixel perfect.', '',
'## Assets desta correção','',
'| ASSET | ORIGEM | USO |','|---|---|---|',
'| `home-linhas-hero.png` | V7 existente | Hero Home, tamanho/clipping corrigidos |',
'| `home-linhas-cta.png` / `home-linhas-ecossistema.png` | V7 existentes, conferidos com gráficos Figma `91:9230` / `91:9194` | Percurso contínuo da Home; mesma imagem, agora posicionada no wrapper correto |',
'| `home-logo.png` | V7 existente | Header e identidade do monitor; sem filtro ou edição do raster |',
'| `favicon.ico` | V7 existente | Todas as páginas |',
'| `sobre-nos-linhas-inferiores.png` | Novo; gráfico isolado Figma `91:8981` | Decoração inferior da equipe |',
'| `sobre-nos-linhas-superiores.png` | Novo; gráfico isolado Figma `91:9018` | Decoração superior da equipe |',
'| `list-marked-orange.svg` | V7 existente | Estado anual restaurado dos planos |', '',
'## Arquivos alterados','',
'Os seguintes arquivos do protótipo anterior mudaram nesta rodada. Nenhum é arquivo ativo da aplicação:', '']
for name in changes:lines.append('- `'+name+'` — '+('CSS compartilhado/restauração e correções visuais.' if name.startswith('css/') else 'Fonte JSP sincronizada: favicon e correção visual/interação correspondente; contratos mantidos.' if name.startswith('jsp/') else 'HTML regenerado da fonte JSP.' if name.startswith('html/') else 'Animação V7 restaurada.' if name=='js/planos.js' else 'Ferramenta de geração/auditoria ajustada à nova rodada.'))
lines += ['',
'Outras criações/alterações: `js/sobre-nos.js`; dois PNGs de decoração de Sobre Nós; `assets/img/list-marked-orange.svg`; ferramentas `corrigir_rodada2.py`, `medir_rodada2.cjs`, `testar_rodada2.cjs`, `testar_hover.cjs` e `relatar_rodada2.py`; `index.html` (links de relatório/fixture); relatório histórico com aviso de supersessão; este relatório; evidências em `auditoria/rodada2/`. O inventário completo com hashes é `auditoria/rodada2/arquivos.json`.', '',
'## Pendências e limites','',
'Destino definitivo de Entre em contato permanece PENDENTE e não foi inventado. FAQ continua proposta visual, sem rota/backend. Login/Cadastro permanecem aprovados e inalterados. A composição da nova marca no monitor requer avaliação visual da equipe; um mockup oficial atualizado seria preferível.', '',
'PENDÊNCIA — exigiria mudança no backend: paginação real além de `totalPaginas = 1` provisório em Controllers, filtro independente de UF e eventual contratação pública. Nada disso foi implementado. Formulários mantêm os campos obrigatórios V7 mesmo quando o Figma omite algum. Esses pontos continuam descritos no relatório histórico e não bloqueiam o protótipo isolado.', '',
'## Como abrir','',
'Abra `index.html` ou qualquer `html/*.html` diretamente. O link de 60 registros fica na galeria. Opcionalmente: `python prototipo-figma/tools/preview.py` a partir da raiz do projeto; galeria em `http://127.0.0.1:8767/index.html`. Nenhuma dependência nova. O preview não substitui a aplicação Spring.', '']
(R/'RELATORIO-CORRECOES-RODADA2.md').write_text('\n'.join(lines),encoding='utf-8')
inventory=[]
for p in sorted(R.rglob('*')):
 if p.is_file() and '__pycache__' not in str(p) and p.name!='arquivos.json':inventory.append({'path':p.relative_to(R).as_posix(),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(D/'arquivos.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2),encoding='utf-8')
print('Relatório de correções criado; inventário:',len(inventory),'arquivos.')
