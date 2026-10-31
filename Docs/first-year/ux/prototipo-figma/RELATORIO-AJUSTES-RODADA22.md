# Monitor — proporção natural do dashboard

O conteúdo interno estava sendo comprimido verticalmente para exibir toda a captura. Foi mantida a proporção original, preenchendo a abertura do monitor com um recorte da parte inferior.

No Figma, apenas o preenchimento da tela `114:7745` foi alterado: `imageTransform` passou de identidade para `[[1,0,0],[0,0.6680812835693359,0]]`. A captura original tem 2880×2354px; a abertura continua com 597×326. Essa relação mantém a mesma escala nos eixos horizontal e vertical. O recorte fica ancorado no topo para preservar o cabeçalho e a primeira tabela.

## Arquivos da aplicação alterados

- `src/main/resources/static/assets/img/home-monitor-predictive-alerts.png`
- `prototipo-figma/assets/img/home-monitor-predictive-alerts.png`

Ambos receberam a mesma exportação nativa em 1872×1488px. Os JSPs e HTMLs continuam usando esse asset compartilhado; não foi necessário alterar markup, CSS, JS ou backend.

## Validação

- Comparação de pixels: diferenças restritas ao retângulo interno `(59,65,1821,1014)`. Moldura e base permanecem idênticas.
- Oito verificações no navegador: versões ativa/paralela em 1440/1024/768/390px. A posição e o tamanho externos do monitor são idênticos antes/depois.
- Prévia renderizada: `auditoria/rodada22/monitor-na-home.png`. Evidências: `figma-ajuste.json`, `invariantes.json` e `visual.json` nessa mesma pasta.

Não foram repetidos os testes Java nesta rodada: houve somente atualização de imagem, sem alteração de código executável, JSP ou contrato HTTP. A ferramenta de verificação fica em `build/manual/rodada22-layout.cjs`.
