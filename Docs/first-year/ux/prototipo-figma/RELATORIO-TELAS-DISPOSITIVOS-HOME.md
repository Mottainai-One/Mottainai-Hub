# Home — substituição das telas dos dispositivos

## Figma

Arquivo atualizado: [Mottainai_teste — Home](https://www.figma.com/design/1tyMSHpCTzRqNNWRy1WlHt/Mottainai_teste?node-id=101-24086).

As três telas separadas na Landing foram identificadas pela estrutura e pelas imagens renderizadas, antes das alterações. Seus textos, cores e componentes não foram editados.

| Tela fornecida | Node original | Dimensões | Dispositivo na Home | Node do dispositivo |
|---|---|---|---|---|
| Cliente / Perfil / Claro — Camila | `109:27785` | 412 × 917 | Celular esquerdo | `101:24122` |
| Cliente / Conversa com a Lô / Início da conversa / Claro | `109:27857` | 412 × 917 | Celular direito | `101:25139` |
| Alertas Preditivos — Algoritmo Mottainai — Dono · V2 | `109:28060` | 1440 × 1177 | Monitor da seção final | `101:24258` |

### Encaixe e preservação dos aparelhos

Os celulares existentes são imagens com a interface antiga incorporada. Foi feita composição determinística das exportações fornecidas sobre a região interna da tela, usando o recorte do próprio aparelho e projeção em perspectiva. Não foi gerado nem redesenhado conteúdo de interface. Notch, carcaça e lateral permanecem com os pixels originais; as transformações e dimensões dos nós existentes foram preservadas. O espelhamento da imagem de origem do celular esquerdo foi compensado para o texto continuar legível na composição final.

Foram atualizados os fills dos nós `101:24142` e `101:25158`, dentro das máscaras existentes. Os originais separados continuam no mesmo lugar da Landing.

No monitor, as camadas da interface antiga foram removidas; a moldura/base original `101:25108` foi mantida. A tela nova está no node `114:7745`, abertura de 597 × 326 em `(10,12)`, com escala proporcional `FIT`.

**Diferença de proporção:** a tela desktop fornecida é mais alta que a abertura do monitor. Para mostrar integralmente as duas tabelas sem esticar a interface, foram mantidas faixas laterais com o azul da própria composição. São necessárias para preservar simultaneamente conteúdo, proporção e aparelho. Não há screenshot antigo por baixo da tela nova.

As linhas azuis/laranjas, posições, tamanhos, rotações e sobreposição dos dispositivos não foram alterados.

## Código

Os assets existentes foram examinados e correspondiam às interfaces anteriores. Foram criados três PNGs transparentes, exportados dos dispositivos já atualizados no Figma em escala 3:

| Asset novo | Resolução | Uso |
|---|---|---|
| `home-mobile-profile-camila.png` | 1275 × 1523 | Celular esquerdo |
| `home-mobile-lo-conversation.png` | 1247 × 1488 | Celular direito |
| `home-monitor-predictive-alerts.png` | 1872 × 1488 | Monitor final |

Cada arquivo foi colocado em `src/main/resources/static/assets/img/` e `prototipo-figma/assets/img/`, conforme os dois empacotamentos existentes. As cópias têm hashes idênticos; HTML e JSP paralelos compartilham os mesmos assets. Os arquivos antigos foram preservados e não foram sobrescritos.

### Arquivos existentes alterados

1. `src/main/webapp/WEB-INF/jsp/home.jsp`: troca das três referências de imagens; `width="624"` no monitor para manter sua largura original no Flexbox mesmo com PNG de maior resolução.
2. `prototipo-figma/jsp/home.jsp`: mesmas referências e largura; remoção dos dois spans decorativos `marca-monitor` e `marca-monitor-icone`, que encobriam a interface nova com marcas sobrepostas da versão anterior.
3. `prototipo-figma/html/home.html`: regenerado a partir do JSP paralelo, com as mesmas alterações visuais.

**CSS atualizado: não foi necessário.** Nenhum JS novo foi inserido nas páginas. Actions, methods, names, ids, hidden inputs, parâmetros, contextPath, EL, JSTL e bindings foram preservados.

### Material auxiliar criado

- `tools/compor_telas_home.cjs`: composição local dos PNGs para preservar os aparelhos; não é carregado pela aplicação.
- `tools/testar_rodada11.cjs`: verificação visual e de interação no Chrome.
- `tools/auditar_rodada11.py`: auditoria de escopo, contratos, assets, transformações do Figma e amostras da carcaça.
- Este relatório e evidências em `auditoria/rodada11/`.

## Validação

| Item | Resultado |
|---|---|
| Figma atualizado | **SIM** |
| HTML atualizado | **SIM** |
| JSP real atualizado | **SIM** |
| JSP paralelo atualizado | **SIM** |
| Backend alterado | **NÃO** |
| CSS / JS de produção alterados | **NÃO** |
| Testes Java locais | **47/47 aprovados** |
| Compilação Jasper | JSPs ativos e paralelos sem erros |
| Chrome — Home ativa e paralela × 1440, 1024, 768 e 390 px | **8/8 aprovados** |
| Abertura de Login e alternância para Cadastro no preview | Aprovadas |

As capturas foram comparadas com o Figma. As três imagens carregam localmente, são diferentes entre si, possuem transparência e não geram overflow horizontal da página. Os recortes internos estão incorporados aos exports, portanto acompanham a escala do dispositivo sem escapar da moldura.

A comparação de geometria antes/depois apresentou variações inferiores a 1 px, decorrentes do arredondamento dos PNGs exportados; não houve reposicionamento dos blocos. A auditoria confirmou **3 arquivos existentes alterados e 426 preservados**, incluindo estilos, scripts e backend.

**Limites:** o JSP ativo foi compilado e sua geometria foi conferida por fixture estática, sem iniciar Spring/Aiven. O validador Java local não executa `contextLoads`, dependente desse ambiente. A versão ativa já tinha sobreposição entre hero e celulares em largura estreita; esse layout anterior foi preservado por estar fora da troca das telas. A versão paralela conserva seu próprio layout aprovado. Não se declara equivalência do restante das páginas com o Figma.

## Evidências

- [Comparação Figma / HTML / JSP ativo](auditoria/rodada11/comparacao.html).
- `auditoria/rodada11/figma-final.json`: nodes, fills e geometria final.
- `auditoria/rodada11/figma-before-devices.json`: estrutura dos aparelhos antes da alteração.
- `auditoria/rodada11/visual.json`: oito cenários, medidas e resultados.
- `auditoria/rodada11/invariantes.json`: escopo e hashes.
- `auditoria/rodada11/test-summary.txt`, `validacao.log`, `jsp-prototipo.log`: testes e compilação.

As capturas e exportações das telas isoladas dentro de `auditoria/rodada11/` são evidências. Os únicos novos assets carregados pela Home são os três mockups listados acima.
