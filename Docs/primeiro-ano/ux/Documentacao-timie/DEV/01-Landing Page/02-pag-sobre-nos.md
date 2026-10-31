# Página: Sobre Nós

**Arquivo:** `sobre-nos.html` / `about-us.css`

## Funcionalidades Implementadas
- **Hero Carrossel:** Utilização de inputs do tipo `radio` (HTML puro) para criar um carrossel interativo. O CSS controla a transição e a parada automática após o clique.
- **Seção Nossa Equipe:** Dois carrosséis horizontais (1º e 2º ano) com *scroll snap* nativo do CSS.

## Destaques Técnicos (CSS)
- Uso de `@keyframes` para a animação automática do carrossel (`hero-auto`).
- Layout responsivo com `@media (max-width: 1024px)` para adaptação do menu e grid (para formato mobile e tablet)
- Uso de `zoom` e `max-width` no container `.bloco-ano` para padronizar o tamanho dos cartões da equipe.
- Uso de variáveis no :root