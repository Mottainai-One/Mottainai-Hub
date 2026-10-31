# Página: Planos

**Arquivo:** `planos.html` / `style.css` / `planos.js`

## Funcionalidades Implementadas
- **Toggle Mensal/Anual:** Um seletor que altera os preços dos cards dinamicamente. 
- **Carrossel de Planos (Mobile/Tablet):** Exibição de um card por vez com setas de navegação.
- **Efeito de Hover (Desktop):** O card `#principal` (Professional) cresce por padrão. Quando outro card recebe hover, o principal encolhe e o novo card cresce.
- **Glow de Fundo:** Efeito visual (imagem com blur) que se move para o centro do card ativo.

## Destaques Técnicos (JavaScript)
- O arquivo `planos.js` manipula o DOM para alterar o texto de preço (`R$ 1.200` para `R$ 10.000`) usando animação de contagem (`easeOutCubic`).
- O toggle muda a classe `.anual` na `section#escolha-plano`, alterando as cores via CSS.