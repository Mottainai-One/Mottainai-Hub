from pathlib import Path
import json, hashlib
R=Path(__file__).resolve().parents[1]
if (R/'auditoria/rodada2/correcoes-aplicadas.txt').exists():
    raise SystemExit('Relatório histórico preservado. Use tools/relatar_rodada2.py para a versão atual.')
frames={'home':'91:9137','sobre-nos':'91:8980','planos':'91:8231','faq':None,'home-crud-page':'92:48372','companies':'92:46391','stores':'92:46644','employees':'92:46906','employee-roles':'92:47158','user-accounts':'92:47384','subscription-plans':'92:47616','addresses':'92:47865'}
labels=['Home','Sobre Nós','Planos públicos','FAQ','Dashboard','Empresas','Lojas','Funcionários','Cargos','Contas','Planos administrativos','Endereços']
notes={
'home':('Header, hero com dois celulares, quatro cards, fotografia/estatística, grid de funcionalidades, ecossistema, CTA e footer.', 'Removida a mascote extra no CTA; imagem de comparação substituída pela fotografia correta do Figma. Modais aprovados preservados.', 'Textos V7 e botão Login aprovados mantidos; Figma usa Cadastre-se nesse CTA. Quebras de linha e altura total variam.'),
'sobre-nos':('Hero de 700 px, fotos em quatro colunas, títulos dos anos, onda decorativa, header/footer e versão mobile.', 'Logos reutilizados da Home. Carrosséis de radios e trilhos de rolagem nativos mantidos.', 'Fotografias e textos da V7 preservados; posições e altura total não são pixel perfect. Em telas menores há rolagem horizontal da equipe.'),
'planos':('Hero com padrão verde, três cards equilibrados e plano Profissional destacado, preços, ilustração de dúvidas e footer.', 'Toggle convertido para fieldset/radios; valores mensal/anual já existentes mantidos. Footer copiado da Home. Links Saiba mais para faq.jsp somente no protótipo.', 'Troca de preços imediata em vez de animação numérica. Contratar plano mantém o comportamento visual V7, sem contratação real. Planos públicos continuam independentes do banco.'),
'faq':('Hero, coluna de perguntas, details/summary, tipografia e footer derivados da Landing/UI Kit.', 'Página nova derivada do scaffold de Planos e footer da Home. Dez perguntas demonstrativas.', 'Não existe frame completo de FAQ identificado. Proposta para avaliação; textos não estabelecem regras oficiais.'),
'home-crud-page':('Sidebar/header, indicadores, títulos, cards e tabela de cadastros recentes.', 'Body V7 idêntico após normalização exclusiva dos caminhos de recursos. Favicon inexistente casa.svg substituído pelo ícone home.svg já disponível.', 'Indicadores e colunas seguem o Model V7; não se inventaram novas métricas do Figma.'),
'companies':('Dimensões do painel, toolbar, tabela, chips, ações, paginação e grid do modal.', 'Body V7 idêntico após normalização dos recursos.', 'Mantidos seletor de plano obrigatório e todas as colunas V7. Botão Pesquisar preserva submit GET explícito.'),
'stores':('Layout compartilhado, tabela, ações e formulário/modal.', 'Body V7 idêntico após normalização dos recursos.', 'Relacionamentos, selects e campos continuam os da V7, mesmo quando o frame apresenta menos campos.'),
'employees':('Layout compartilhado, tabela, chips e modal de duas colunas.', 'Body V7 idêntico após normalização dos recursos.', 'CPF e campos/relacionamentos obrigatórios V7 continuam presentes. Conteúdo extenso pode aumentar o modal, com rolagem.'),
'employee-roles':('Toolbar, tabela, número de funcionários, status, ações e modal.', 'Body V7 idêntico após normalização dos recursos.', 'Filtros, contagens e vínculos seguem o backend atual; nenhum filtro adicional inventado.'),
'user-accounts':('Tabela, situação, ações e formulário conforme componentes administrativos.', 'Body V7 idêntico após normalização dos recursos.', 'Campos de conta/senha e validações existentes preservados; nenhuma senha real nos exemplos estáticos.'),
'subscription-plans':('Tabela, toolbar, valores, chips e formulário de plano.', 'Body V7 idêntico após normalização dos recursos.', 'Mantida representação atual das empresas vinculadas/contagens; não transformado o plano em relacionamento exclusivo de uma empresa.'),
'addresses':('Tabela de endereços, busca, ações e modal com overflow adequado.', 'Body V7 idêntico após normalização dos recursos.', 'Busca textual V7 mantida; nenhum filtro independente de UF foi adicionado. Paginação real permanece conforme Controller V7.')}
lines=['# Protótipo visual paralelo Mottainai — V7','', 'Data: 27/10/2026. Material para comparação e aprovação humana; não ativado no Spring.','',
'## Escopo e integridade','',
'A fonte funcional foi `CrudInicial - Copia_V7.zip`. Antes da cópia, os 276 arquivos do projeto extraído foram comparados com a V7 e registrados em `auditoria/base-v7-sha256.json`. A verificação final compara novamente esses hashes. Foi detectada divergência em `.idea/workspace.xml` durante a rodada; esse metadado local do IDE não foi editado nem revertido por esta tarefa e está registrado separadamente na auditoria. A checagem final detectou também divergência em src/main/java/com/mottainai/crudinicial/BCryptGenerator.java, arquivo não editado por esta tarefa. Ambos foram preservados. Os outros 274 arquivos permanecem idênticos à base; a comparação integral de hashes falha por essa divergência Java externa, sem falha nos contratos JSP. Nenhum Java, JSP/CSS/JS ativo, banco, DataLoad, AES, BCrypt, autenticação, sessão, dependência, versão ou configuração Spring foi alterado. Todas as criações e alterações desta rodada estão dentro de `prototipo-figma/`.', '',
'Os 11 JSPs existentes foram copiados antes da adaptação; FAQ foi derivada das páginas públicas. As oito páginas administrativas mantêm o body da V7 integralmente, exceto caminhos dos recursos paralelos. Actions, methods, names, IDs, hidden inputs, JSTL, EL, mensagens, query params e contextPath são auditados em `auditoria/invariantes.json`. Não foram criadas rotas nem recursos Spring; a pasta não integra o ViewResolver nem o diretório webapp do WAR padrão.', '',
'## Como visualizar','',
'Abra `index.html` ou qualquer arquivo em `html/` diretamente no navegador, sem Spring e sem instalação de dependências. Links, fontes, CSS e imagens são locais. A galeria oferece as 12 páginas, fontes JSP e referências do Figma.', '',
'Preview opcional, usando apenas a biblioteca padrão Python:', '', '```powershell','python prototipo-figma/tools/preview.py','```','',
'Acesse `http://127.0.0.1:8767/index.html`. `/ver-jsp/companies.jsp` e os demais nomes projetam o JSP com o mesmo conteúdo demonstrativo que gera o HTML; `/ver-jsp/home.jsp?login=1` demonstra a abertura do login. Isso não executa Spring/JSTL real: o compilador Jasper foi utilizado separadamente para validar os JSPs. O servidor aceita GET e rejeita POST. Ctrl+C encerra.', '',
'Os formulários HTML usam `method="dialog"` sem action, inclusive login, filtros e CRUD. Assim não enviam nem persistem dados; não existe login falso, localStorage, fetch ou simulação de sucesso. Modais HTML são abertos por fragmentos `:target`; os JSPs mantêm o fluxo real de `acao`/Model. Dados de tabela são exemplos estáticos gerados a partir dos JSPs, identificados pelo aviso visual de preview. Paginação HTML é somente representação visual.', '',
'## Referência Figma','',
'Arquivo `1tyMSHpCTzRqNNWRy1WlHt`; páginas CRUD (`0:1`), UI - kit (`92:50267`) e Landing (`59:1428`). UI Kit consultado: `92:50649`; modal de empresa: `92:46527`. As capturas completas em `referencias/figma/` são somente documentação de comparação e nunca substituem HTML de tabelas, cards ou formulários.', '',
'CSS é a principal ferramenta: DM Sans local, navy `#0b2031`, fundo administrativo `#dedddb`, chips verdes/laranja, Grid/Flex, media queries, radios e details. Os CRUDs usam um único `crud.css`. Modais públicos mantêm `modais.css` aprovado. `publico.css` compartilha header/footer sem redesenhar o login.', '',
'## Diferenças por página','']
for name,label in zip(frames,labels):
    visual,jsp,remaining=notes[name]
    frame=frames[name]
    js='Nenhum.' if name in ['sobre-nos','planos','faq'] else ('modais.js aprovado, sem alteração.' if name=='home' else 'crud.js compartilhado da V7; fechamento Escape adicional restrito ao HTML estático.')
    lines += [f'### {label}', '',f'PÁGINA: `{name}`.  ',f'BASE UTILIZADA: '+('`planos.jsp` + header/footer públicos existentes.' if name=='faq' else f'`src/main/webapp/WEB-INF/jsp/{name}.jsp` e CSS/JS correspondentes da V7.')+'  ',f'FRAME FIGMA: '+(f'`{frame}`.' if frame else 'Proposta derivada; não há tela FAQ completa.')+'  ',f'ALTERAÇÕES VISUAIS: {visual}  ',f'ALTERAÇÕES JSP: {jsp}  ',f'ALTERAÇÕES CSS: '+('`crud.css` compartilhado.' if name in list(frames)[4:] else f'`{name}.css`, `publico.css` e fontes locais.')+'  ',f'ALTERAÇÕES JS: {js}  ', 'CONTRATOS BACKEND PRESERVADOS: '+('Todos os contratos administrativos auditados, sem mudança de body funcional.' if name in list(frames)[4:] else 'Navegação e comportamento de contato V7 preservados; nenhum endpoint novo. Login mantém POST real somente no JSP.')+'  ',f'DIFERENÇAS QUE RESTARAM: {remaining}', '']
lines += ['## Comparação CRUD','', '| CRUD | FIGMA | PROTÓTIPO | BACK PRESERVADO | DIFERENÇAS RESTANTES |','|---|---|---|---|---|']
for name,label in list(zip(frames,labels))[4:]:
    lines += [f'| {label} | {frames[name]} | `jsp/{name}.jsp` / `html/{name}.html` | Sim; auditoria estrutural | {notes[name][2]} |']
lines += ['', '## Versões JSP e HTML','', '| PÁGINA | JSP CRIADO | HTML CRIADO | VISUAL EQUIVALENTE | DIFERENÇAS |','|---|---|---|---|---|']
for name,label in zip(frames,labels):
    lines += [f'| {label} | `jsp/{name}.jsp` | `html/{name}.html` | Mesma estrutura e CSS; projeção do JSP | HTML tem exemplos, aviso e forms inertes; JSP conserva Model/submit real. |']
lines += ['', '| PÁGINA | FIGMA | HTML | JSP | STATUS |','|---|---|---|---|---|']
for name,label in zip(frames,labels):
    lines += [f'| {label} | {frames[name] or "Derivada do UI Kit"} | Renderizado no Chrome | Compilado com Jasper | Protótipo para aprovação; sem integração ativa |']
lines += ['', '## Mudanças não executadas porque exigiriam backend','',
'### Paginação administrativa além da primeira página','',
'PÁGINA: CRUDs, exemplo Endereços e Planos administrativos.  \nFIGMA: múltiplas páginas de registros.  \nBACK ATUAL: `AddressViewController.list` e `SubscriptionPlanViewController.list` recebem pagina, mas fornecem `totalPaginas = 1` (paginação provisória).  \nALTERAÇÃO NECESSÁRIA: implementar paginação efetiva no fluxo Controller/Service/consulta antes de prometer novas páginas reais.  \nRISCO: alterar seleção/ordenação/total e comportamento existente.  \nRECOMENDAÇÃO: preservar a V7 nesta rodada. Alternativa front: apenas estilizar a paginação atual; HTML mostra páginas demonstrativas, sem cortar dados em JavaScript.', '',
'### Filtro dedicado de UF','',
'PÁGINA: Endereços.  \nFIGMA: referência de filtragem por estado.  \nBACK ATUAL: `AddressViewController.list` aceita `busca`, mas não parâmetro separado de UF; busca já inclui o estado no texto.  \nALTERAÇÃO NECESSÁRIA: definir e implementar contrato específico caso seja desejado um filtro independente.  \nRISCO: divergir das regras atuais de busca.  \nRECOMENDAÇÃO: mantida a busca atual; nenhum select falso adicionado.', '',
'### Remoção de campos obrigatórios para igualar modais','',
'PÁGINA: Empresas e demais formulários relacionais.  \nFIGMA: alguns modais mostram menos campos (por exemplo, empresa sem seletor de plano).  \nBACK ATUAL: os forms V7 enviam os relacionamentos e campos exigidos pelos DTOs/Controllers.  \nALTERAÇÃO NECESSÁRIA: somente se aprovada uma regra de valor padrão ou alteração de obrigatoriedade no backend.  \nRISCO: cadastro inválido ou vínculo incorreto.  \nRECOMENDAÇÃO: manter os campos reais, acomodando-os no grid e permitindo rolagem. Nenhum contrato foi removido.', '',
'### Empresa vinculada a plano e contratação pública','',
'PÁGINA: Planos administrativos / Planos públicos.  \nFIGMA: representação de empresa no plano e CTA Contratar.  \nBACK ATUAL: estrutura V7 do plano e seus vínculos/contagens mantida; página pública é visual.  \nALTERAÇÃO NECESSÁRIA: definir semântica de empresa única se realmente desejada e fluxo comercial de contratação.  \nRISCO: mudar relacionamentos e regras comerciais.  \nRECOMENDAÇÃO: manter a representação funcional atual e não ligar CTA a endpoint inventado. Alternativa front: apenas aproximação visual.', '',
'## FAQ','',
'FAQ = proposta visual derivada do design system existente. Não foi encontrada uma tela FAQ completa no Figma. Header, cores, fonte, CTA e footer vêm da Landing/UI Kit; dez perguntas são conteúdo demonstrativo, não regras oficiais. `jsp/faq.jsp` e `html/faq.html` usam details/summary e zero JavaScript. Nenhum Controller, rota `/faq`, Service, Repository, endpoint ou tabela foi criado. O link `faq.jsp` existe apenas no protótipo e a projeção HTML o converte para `faq.html`.', '',
'## Login e Cadastro','',
'Mantidos conforme versão V7 aprovada. O trecho de modais da Home, `modais.css` e `modais.js` são comparados automaticamente com a origem. JSP continua preparado para login Administration, email/senha, mensagem de erro, alternância e abertura por Model de `/login`; nenhuma autenticação foi alterada. HTML reproduz esses modais e neutraliza o submit com HTML nativo. Não há autenticação no preview. O fechamento por Escape e a alternância foram executados no navegador.', '',
'## Contato','',
'Destino definitivo de “Entre em contato” continua pendente. PENDENTE — destino definitivo dos botões Entre em contato. Nenhum mailto, WhatsApp, formulário, endpoint ou destino externo foi inventado. Hrefs dos três JSPs públicos são comparados com a V7 pela auditoria.', '',
'## JavaScript','',
'| PÁGINA | JS NECESSÁRIO | MOTIVO | PODERIA SER CSS/HTML? |','|---|---|---|---|']
for name,label in zip(frames,labels):
    if name=='home': row='`modais.js` aprovado | Escape e interação aprovada de Login/Cadastro | CSS já controla abertura/alternância; preservado o pequeno handler de teclado aprovado.'
    elif name in ['sobre-nos','planos','faq']:row='0 | Radios/CSS, scroll nativo ou details/summary | Sim; implementado sem JS. `planos.js` não é carregado.'
    else:row='`crud.js` compartilhado | Sidebar ativa, máscaras, validações visuais e teclado existentes; Escape do HTML | Abertura do preview usa :target; máscaras e validações atuais foram preservadas.'
    lines += [f'| {label} | {row} |']
lines += ['', 'Não há JS por entidade. O `planos.js` paralelo contém somente comentário explicativo e não é carregado; animação de contagem deixou de ser necessária. O acréscimo no `crud.js` só atua quando `data-preview="static"`, fechando o fragmento de modal ao pressionar Escape. Nenhum comportamento de CRUD/persistência foi acrescentado.', '', '| ARQUIVO | BYTES | LINHAS |','|---|---:|---:|']
for file in sorted((R/'js').glob('*.js')):
    lines += [f'| `{file.name}` | {file.stat().st_size} | {len(file.read_text(encoding="utf-8").splitlines())} |']
lines += ['', '## Assets','', 'Primeiro foram reaproveitados os assets V7. As três imagens novas abaixo são gráficos/fotografia isolados, não screenshots de UI. Fontes DM Sans foram localizadas a partir da fonte já utilizada; nenhuma dependência adicionada. Os demais arquivos na tabela são cópias dos assets da V7.', '', '| ASSET | JÁ EXISTIA? | ORIGEM FIGMA SE NOVO | USO |','|---|---|---|---|']
new={'planos-padrao-hero.png':('91:8232','Padrão decorativo do hero Planos'),'planos-duvidas.png':('91:8561','Ilustração de dúvidas Planos'),'home-card-comparacao.png':('I91:9359;1242:74440, grupo 91:9358','Fotografia do card comparação Home')}
for file in sorted((R/'assets').rglob('*')):
    if not file.is_file():continue
    rel=file.relative_to(R).as_posix()
    if file.name in new: origin,use=new[file.name]; yes='Não'
    elif file.suffix=='.ttf':origin='Google Fonts, mesma família DM Sans existente';use='Fonte offline';yes='Família existente; arquivo localizado'
    else:origin='V7';use='Logo, foto, mockup, ilustração ou ícone reutilizado';yes='Sim'
    lines += [f'| `{rel}` | {yes} | {origin} | {use} |']
lines += ['', '## Validação executada e evidências','',
'- `auditoria/invariantes.json`: 276 hashes ativos verificados: 274 idênticos e duas divergências externas acima; auditoria de hashes não aprovada por BCryptGenerator.java; oito bodies administrativos aprovados; forms/actions/methods/names/hidden/JSTL/EL/IDs; cópias dos modais aprovados; caminhos locais de CSS/imagens; 12 JSPs e 12 HTMLs; formulários HTML neutralizados e destinos de contato preservados.',
'- `auditoria/compilacao-jsp.log`: Jasper/Java 21 compilou todos os 12 JSPs com zero erros. Classes geradas somente em diretório temporário novo; nenhum Java de produção foi editado.',
'- `auditoria/visual.json`: Chrome/Playwright do ambiente, sem dependência nova. Quatro páginas públicas nas larguras 1440, 1024, 768 e 390; oito administrativas em 1812, 768 e 390: 40 combinações. Imagens locais carregadas, ausência de overflow destrutivo e erros JS, e nenhuma requisição POST.',
'- `auditoria/preview.json`: as 12 projeções GET dos JSPs coincidem com os HTMLs gerados (normalizadas quebras de linha); páginas retornam HTTP 200 e POST retorna 405. O teste usa servidor temporário local e não acessa Spring.',
'- Interações: alternância Login/Cadastro e Escape; submit do login HTML sem navegação/autenticação; preços mensais/anuais por clique e setas; FAQ por clique/Enter; radio do hero Sobre Nós; sete modais de edição, fechamento Escape e modal Empresa em 390 px.',
'- Capturas do protótipo em `auditoria/capturas/`; referências Figma em `referencias/figma/`. Comparação antes/depois de Empresas com mesma estrutura/conteúdo e CSS V7 original: sidebar 220 → 312 px, header 72 → 108 px, título 22 → 36 px, linha 59 → 73 px. Essas são medições de layout, não de performance/backend.',
'', 'Os testes de negócio/integração com Aiven e o build completo Spring não foram reexecutados nesta rodada exclusivamente visual. Não se declara CRUD/login reais testados no HTML: o fluxo real está preservado estruturalmente e os JSPs compilam, mas dependerá de homologação no Spring se o protótipo for integrado futuramente. A equivalência HTML/JSP usa a mesma fonte, estrutura e CSS; dados reais maiores podem mudar altura/quebras. Não se afirma pixel perfect ou percentual de fidelidade.', '',
'## Arquivos criados e alterados nesta rodada','',
'Todos são novos em relação à V7: `jsp/` (12 fontes adaptadas), `html/` (12 previews gerados), `css/` (estilos copiados/adaptados, fonte e FAQ), `js/` (dois scripts preservados e arquivo Planos não carregado), `assets/` (recursos compartilhados), `index.html` (galeria), `tools/` (gerador, auditoria, servidor isolado e testes), `referencias/` (evidência Figma) e `auditoria/` (hashes, resultados e capturas). Nenhum arquivo pré-existente da aplicação foi alterado por esta tarefa; as divergências externas do workspace do IDE e BCryptGenerator.java estão registradas acima. A lista exata de arquivos e hashes criados é `auditoria/arquivos-prototipo.json`.', '',
'## Pendências para decisão humana','',
'Aprovar visualmente cada página; validar textos demonstrativos da FAQ; definir destino de contato e eventual contratação; decidir se deseja implementar filtros/paginação pendentes do backend em outra rodada; decidir futuramente a integração dos JSPs e recursos paralelos. Nenhuma dessas decisões foi presumida, e a V7 continua sendo a aplicação ativa.', '']
(R/'RELATORIO-PROTOTIPO-FIGMA.md').write_text('\n'.join(lines),encoding='utf-8')
manifest=[]
for file in sorted(R.rglob('*')):
    if file.is_file() and file.name!='arquivos-prototipo.json' and '__pycache__' not in str(file):
        manifest.append({'path':file.relative_to(R).as_posix(),'bytes':file.stat().st_size,'sha256':hashlib.sha256(file.read_bytes()).hexdigest()})
(R/'auditoria/arquivos-prototipo.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
print('Relatório e inventário gerados:',len(manifest),'arquivos.')



