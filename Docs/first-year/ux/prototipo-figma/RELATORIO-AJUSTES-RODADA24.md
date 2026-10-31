# Ajustes focados — rodada 24

Base recebida: `prototipo-figma/prototipo-figma/`, mantida na localização em que foi extraída. O ZIP original não foi alterado.

## Correções

- **Sair:** o POST `/logout` continua invalidando a sessão e agora redireciona para `/home`. Não foi trocado por um GET na aplicação. Nos 27 HTMLs de preview, o formulário de “Sair da conta” apenas navega para `home.html`, sem autenticação simulada. O gerador foi ajustado para preservar essa navegação em futuras gerações. Os JSPs de logout já tinham o POST correto e foram preservados.
- **Empresas:** o HTML recebido já filtrava “Aurora” ao digitar. No JSP ativo, `data-profile-only` interrompia o script antes da pesquisa. Removido somente esse atributo em `companies.jsp`, reutilizando o filtro existente. A pesquisa imediata filtra os seis registros carregados na página; Enter/Pesquisar mantém o GET real para consultar a listagem completa no backend. Nenhum endpoint ou parâmetro foi alterado.
- **Planos:** os dois contatos do conteúdo (hero e seção de dúvidas) receberam `target="_blank"` e `rel="noopener noreferrer"`, no JSP ativo e no JSP/HTML da cópia recebida. Destinos preservados.
- **Logotipos:** somente a coordenada vertical das barras laranjas foi alterada nos SVGs compartilhados de header e footer, tanto na aplicação quanto na cópia recebida. Letras, pontos laranjas, símbolo, cores, dimensões, viewBox e demais vetores foram preservados. O logo administrativo já tinha a barra encostada e não foi alterado. Todos os HTMLs/JSPs públicos que usam esses assets recebem o ajuste.

## Validação

- Java e JSPs ativos: compilação concluída.
- JSP paralelo de Planos: compilação Jasper sem erros.
- 47 testes JUnit passaram; nenhum falhou. Os testes de logout agora esperam `/home` e continuam conferindo invalidação da sessão. Falhas de login continuam levando para `/login`.
- Chrome: pesquisa instantânea em Empresas no HTML e na projeção do JSP ativo; “aurora” deixa uma linha, termo inexistente deixa zero e limpar restaura as seis, sem navegação.
- Chrome: os dois contatos de Planos, nas duas versões, abriram outra guia e mantiveram a original. O destino externo foi interceptado somente no teste; nenhuma mensagem foi enviada.
- Chrome: “Sair da conta” navega para a Home nas nove páginas administrativas principais. Os 27 HTMLs foram conferidos estruturalmente.
- Auditoria dos SVGs: apenas `y` das barras foi alterado; demais elementos idênticos. Capturas `logo-header.png` e `logo-footer.png` conferidas visualmente.
- Contratos dos JSPs alterados conferidos: actions, methods, names, ids, EL e JSTL preservados.

Não foram alterados CSS, JavaScript de produção, banco, regras de negócio dos CRUDs ou demais layouts. Os testes não acessaram o PostgreSQL remoto. O preview de HTML usa dados estáticos já existentes; não substitui o backend.

## Arquivos alterados (40)

- `prototipo-figma/prototipo-figma/assets/img/mottainai-logo-completo.svg`
- `prototipo-figma/prototipo-figma/assets/img/mottainai-wordmark-rodape.svg`
- `prototipo-figma/prototipo-figma/html/addresses-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/addresses-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/addresses.html`
- `prototipo-figma/prototipo-figma/html/administrations-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/administrations-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/administrations.html`
- `prototipo-figma/prototipo-figma/html/companies-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/companies-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/companies.html`
- `prototipo-figma/prototipo-figma/html/employee-roles-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/employee-roles-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/employee-roles.html`
- `prototipo-figma/prototipo-figma/html/employees-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/employees-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/employees.html`
- `prototipo-figma/prototipo-figma/html/home-crud-page-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/home-crud-page-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/home-crud-page.html`
- `prototipo-figma/prototipo-figma/html/planos.html`
- `prototipo-figma/prototipo-figma/html/stores-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/stores-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/stores.html`
- `prototipo-figma/prototipo-figma/html/subscription-plans-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/subscription-plans-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/subscription-plans.html`
- `prototipo-figma/prototipo-figma/html/user-accounts-pagina-2.html`
- `prototipo-figma/prototipo-figma/html/user-accounts-pagina-3.html`
- `prototipo-figma/prototipo-figma/html/user-accounts.html`
- `prototipo-figma/prototipo-figma/jsp/planos.jsp`
- `prototipo-figma/prototipo-figma/tools/gerar_html.py`
- `src/main/java/com/mottainai/crudinicial/controller/AuthenticationController.java`
- `src/main/resources/static/assets/img/mottainai-logo-completo.svg`
- `src/main/resources/static/assets/img/mottainai-wordmark-rodape.svg`
- `src/main/webapp/WEB-INF/jsp/companies.jsp`
- `src/main/webapp/WEB-INF/jsp/planos.jsp`
- `src/test/java/com/mottainai/crudinicial/controller/AdministrationSessionTest.java`
- `src/test/java/com/mottainai/crudinicial/controller/AuthenticationControllerTest.java`
- `src/test/java/com/mottainai/crudinicial/controller/PublicPageViewControllerTest.java`

Os arquivos de auditoria desta pasta e scripts temporários em `build/rodada24-*` registram a validação. Não entram no runtime da aplicação.
