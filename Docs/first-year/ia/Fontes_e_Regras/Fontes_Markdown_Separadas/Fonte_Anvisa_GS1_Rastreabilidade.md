**Pesquisa Integrada — Rotulagem, Identificação, Validade e Rastreabilidade de Produtos**

**Pergunta de pesquisa**

**Como informações de validade, identificação e lote presentes na rotulagem e em códigos padronizados podem contribuir para a rastreabilidade e o controle de estoque de produtos perecíveis no varejo?**

**Fontes analisadas**

**Fonte 7 — Anvisa: Rotulagem de alimentos**

- **Instituição:** Agência Nacional de Vigilância Sanitária (Anvisa).

- **Tipo:** fonte oficial/institucional e regulatória.

- **Tema:** rotulagem de alimentos e informações obrigatórias.

- **Abrangência:** produtos alimentícios comercializados no Brasil.

A fonte apresenta informações que devem constar na rotulagem dos alimentos, incluindo a **data de validade**, permitindo que o consumidor e os agentes da cadeia tenham acesso a informações relevantes sobre o produto.

**Fonte 8 — GS1 Brasil: GS1 DataMatrix**

- **Instituição:** GS1 Brasil.

- **Tipo:** conteúdo técnico-institucional sobre identificação e rastreabilidade.

- **Tema:** código 2D, GTIN, lote, validade, rastreabilidade e gestão de estoque.

- **Abrangência:** aplicação dos padrões GS1 em diferentes setores, incluindo alimentos e logística.

A GS1 Brasil explica que o **GS1 DataMatrix** é um código bidimensional capaz de armazenar diferentes informações estruturadas, como:

- GTIN;

- lote;

- data de validade;

- número de série, quando aplicável.

O código utiliza **Identificadores de Aplicação (AIs)** para indicar o significado de cada informação, permitindo que sistemas compatíveis interpretem os dados de maneira padronizada.

**Evidências combinadas**

As duas fontes se complementam porque tratam de diferentes etapas da informação sobre o produto.

A **Anvisa** estabelece a importância das informações presentes na rotulagem dos alimentos, incluindo a data de validade.

A **GS1 Brasil**, por sua vez, apresenta uma forma padronizada de estruturar informações do produto em códigos 2D, possibilitando que dados como GTIN, lote e validade sejam capturados por sistemas compatíveis.

Assim, existe uma diferença importante entre:

**informação que deve estar disponível na identificação/rotulagem do produto**

e

**informação que está efetivamente codificada em um código que pode ser lido automaticamente.**

A existência da data de validade na rotulagem **não significa necessariamente que ela estará disponível por uma bipagem convencional**.

Da mesma forma, o fato de o GS1 DataMatrix ser capaz de armazenar lote e validade **não significa que todos os produtos estejam utilizando esse padrão ou que todos os códigos contenham essas informações**.

**Relação com a dúvida sobre a bipagem**

A combinação das duas fontes ajuda a responder à pergunta:

**A bipagem já retorna a data de validade?**

A resposta deve ser tratada com cautela:

**Depende do código utilizado no produto e da forma como os dados foram codificados e interpretados pelo sistema de leitura.**

A informação de validade pode estar presente na rotulagem, mas uma leitura automática só poderá recuperar essa informação quando ela estiver disponível no código utilizado e quando o sistema for capaz de interpretá-la.

Portanto:

**Rotulagem com validade ≠ validade necessariamente disponível por bipagem.**

E:

**Código 2D capaz de armazenar validade ≠ todo produto possui validade codificada nesse formato.**

**Relação entre GTIN, SKU, lote e validade**

As fontes também ajudam a diferenciar informações que podem cumprir funções diferentes no sistema.

| **Informação**  | **Possível função no Mottainai**                |
|-----------------|-------------------------------------------------|
| GTIN            | Identificação padronizada do produto            |
| SKU             | Identificação utilizada internamente no estoque |
| Lote            | Diferenciação de grupos de produtos             |
| Validade        | Controle do prazo restante                      |
| Número de série | Identificação individual, quando aplicável      |

Essa distinção é importante porque um mesmo produto identificado por determinado SKU ou GTIN pode possuir **diferentes lotes e diferentes datas de validade**.

Consequentemente, controlar somente o identificador do produto pode não ser suficiente para controlar corretamente o risco de vencimento.

**Relação com o Mottainai**

As fontes fornecem uma base para a ideia de que o Mottainai poderia trabalhar com informações estruturadas de identificação e validade quando elas estiverem disponíveis.

Uma possível estrutura conceitual seria:

GTIN/SKU

↓

Lote

↓

Validade

↓

Quantidade em estoque

↓

Quantidade na gôndola

↓

Fluxo de saída

↓

Identificação de risco

Essa estrutura representa uma **hipótese de utilização no projeto**, e não uma funcionalidade comprovada.

O Mottainai poderia utilizar essas informações para:

- identificar produtos;

- diferenciar lotes;

- acompanhar validade;

- apoiar a rastreabilidade;

- relacionar validade com estoque e fluxo de saída;

- gerar alertas para produtos que exigem atenção.

Entretanto, as fontes não comprovam que todos esses dados estarão disponíveis automaticamente no ambiente real do projeto.

**Relação com rastreabilidade**

A GS1 Brasil aponta que a utilização de dados estruturados em códigos padronizados pode favorecer a interoperabilidade entre sistemas e apoiar processos de rastreabilidade.

No contexto do Mottainai, isso poderia contribuir para acompanhar produtos durante etapas como:

- recebimento;

- armazenamento;

- movimentação;

- exposição;

- venda;

- recolhimento ou descarte.

Porém, essa aplicação depende da infraestrutura disponível, dos códigos utilizados pelos produtos e da integração entre os sistemas envolvidos.

A fonte da GS1 **não comprova que o Mottainai terá integração automática com um ERP específico ou que uma única leitura será registrada simultaneamente em dois sistemas**.

**Relação com a dúvida sobre dois sistemas**

As fontes permitem afirmar que padrões de identificação podem favorecer a interoperabilidade.

Entretanto, elas **não permitem concluir** que uma única bipagem será automaticamente registrada em dois sistemas.

Para isso, seriam necessários mecanismos de integração, como:

- comunicação entre sistemas;

- configuração dos leitores;

- APIs;

- middleware;

- regras de sincronização;

- tratamento de erros;

- definição da fonte principal dos dados.

Essa parte continua sendo uma **questão técnica do projeto que exige fontes específicas sobre integração de sistemas e ERP**.

**Redução de erros**

A utilização de códigos padronizados pode reduzir a necessidade de digitação manual quando os dados necessários estiverem corretamente codificados e o sistema for compatível com sua leitura.

Entretanto, isso não significa que a utilização do código elimine erros.

A confiabilidade da informação dependerá de fatores como:

- correta codificação dos dados;

- legibilidade do código;

- compatibilidade do leitor;

- interpretação correta dos campos;

- integração adequada;

- procedimento operacional utilizado.

**Metodologia das fontes**

As duas fontes possuem naturezas diferentes.

**Anvisa**

É uma fonte oficial e regulatória, adequada para compreender informações relacionadas à rotulagem de alimentos e às informações que devem estar presentes nos produtos.

**GS1 Brasil**

É uma fonte técnico-institucional voltada aos padrões de identificação e comunicação de produtos. É adequada para compreender o funcionamento e as possibilidades do GS1 DataMatrix.

Nenhuma das duas fontes representa um estudo de campo específico sobre o Mottainai ou uma validação independente da solução em supermercados.

**Fonte, evidência e interpretação**

| **Categoria**     | **Conteúdo**                                                                                                                                                                                       |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Fonte**         | A Anvisa apresenta informações relacionadas à rotulagem de alimentos, incluindo a data de validade. A GS1 Brasil explica que o GS1 DataMatrix pode estruturar GTIN, lote, validade e outros dados. |
| **Evidência**     | A validade pode fazer parte das informações do produto e padrões 2D podem estruturar dados adicionais para leitura automatizada.                                                                   |
| **Interpretação** | O Mottainai poderia utilizar essas informações, quando disponíveis, para relacionar identificação, lote e validade ao controle de estoque e à identificação de riscos.                             |

**O que as fontes permitem compreender**

As fontes permitem compreender que:

- a validade é uma informação relevante na identificação dos alimentos;

- produtos podem possuir informações estruturadas de identificação e rastreabilidade;

- códigos 2D podem armazenar informações adicionais além de uma simples identificação;

- GTIN, lote e validade podem ser associados em uma estrutura padronizada;

- a leitura automatizada pode reduzir a necessidade de digitação quando houver compatibilidade;

- padrões de identificação podem favorecer a interoperabilidade entre sistemas;

- essas informações podem ser úteis para controle de estoque e rastreabilidade.

**O que as fontes não permitem concluir**

Não é possível concluir apenas com essas fontes que:

- todos os produtos terão validade disponível por bipagem;

- todos os produtos utilizarão GS1 DataMatrix;

- o código disponível nos produtos do projeto conterá lote e validade;

- o leitor atualmente utilizado pelo varejista será compatível;

- o SAP aceitará automaticamente essas informações;

- uma única bipagem alimentará dois sistemas;

- o uso do DataMatrix reduzirá determinado percentual de desperdício;

- o Mottainai já possui essa integração implementada;

- a solução já foi validada em supermercados.

**Limitações**

As principais limitações da análise são:

- a fonte da Anvisa possui caráter oficial e regulatório, mas não comprova o funcionamento de uma solução de bipagem;

- a GS1 Brasil explica as capacidades e aplicações do padrão, mas não comprova sua utilização universal nos produtos analisados pelo projeto;

- nenhuma das fontes valida o funcionamento do Mottainai em ambiente real;

- as fontes não explicam a integração específica com SAP;

- não há comprovação de que todos os fornecedores disponibilizarão lote e validade em códigos compatíveis;

- não é possível concluir, somente a partir dessas fontes, que a leitura automática reduzirá desperdícios;

- a presença de uma informação na embalagem não garante sua disponibilidade automática em um sistema.

**Confiabilidade**

**Anvisa — Alta para informações regulatórias e de rotulagem**

A fonte é adequada para fundamentar informações institucionais e regulatórias relacionadas à rotulagem de alimentos.

**GS1 Brasil — Alta para o funcionamento do padrão GS1**

A GS1 é a organização responsável pelos padrões globais de identificação e comunicação de produtos, sendo a GS1 Brasil a entidade nacional relacionada a esses padrões.

A fonte é adequada para explicar o funcionamento e as possibilidades do GS1 DataMatrix.

**Limitação da confiabilidade**

A alta confiabilidade dessas fontes é **específica para os assuntos que elas efetivamente abordam**.

Isso não significa que elas sejam suficientes para comprovar:

- integração com SAP;

- funcionamento do Mottainai;

- adoção universal do DataMatrix;

- redução de desperdício;

- resultados financeiros;

- desempenho de um algoritmo;

- funcionamento de uma operação específica de supermercado.

**Conclusão integrada**

As fontes da **Anvisa e da GS1 Brasil se complementam** ao abordar, respectivamente, a informação presente na rotulagem e a possibilidade de estruturar essas informações em códigos padronizados.

Para o Mottainai, isso sustenta a possibilidade de utilizar informações como **identificação, lote e validade** no controle de produtos perecíveis, quando esses dados estiverem disponíveis e puderem ser capturados pela infraestrutura adotada.

A principal conclusão, porém, deve ser mantida com cautela:

**A existência da validade na rotulagem ou a capacidade de um código 2D armazenar essa informação não significa que qualquer bipagem fornecerá automaticamente a validade ao sistema.**

Essa disponibilidade depende do código utilizado, da forma como os dados foram codificados, dos equipamentos de leitura e da integração com os sistemas utilizados pelo varejista.

Portanto, as fontes fundamentam a **possibilidade técnica**, mas não comprovam a implementação ou a validação dessa solução no Mottainai.
