# Estilização e Responsividade (Style.css)

O CSS foi estruturado utilizando a metodologia de **Variáveis CSS** (Custom Properties) para manter a consistência visual.

## Design Tokens (`:root`)
- **Cores Primárias:** `--azul-primario: #102a43`, `--laranja-titulo: #dd7b2d`.
- **Cores de Status:** `--verde-ativo-bg` (Ativo), `--laranja-inativo-bg` (Inativo), `--vermelho: #d92d20` (Excluir).
- **Tipografia:** `--fonte: "DM Sans", sans-serif`.

## Layout Principal (CSS Grid)
O esqueleto do sistema utiliza CSS Grid:
```css
.app {
  display: grid;
  grid-template-columns: var(--sidebar-largura) 1fr;
  grid-template-rows: var(--header-altura) 1fr;
  grid-template-areas:
    "sidebar header"
    "sidebar main";
  min-height: 100vh;
}