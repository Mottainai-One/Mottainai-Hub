# Componentes e Modais

Para manter a fluidez e evitar recarregamento da página, as operações de CRUD utilizam modais (`.modal-overlay`).

## Modais Padronizados por Entidade
Cada entidade possui 4 modais principais (exemplo: Funcionário):
1. **Modal de Cadastrar (`modal-funcionario-criar`):** Formulário vazio. Campos obrigatórios possuem `<span class="obrigatorio">*</span>`.
2. **Modal de Editar (`modal-funcionario-editar`):** Formulário pré-preenchido. O campo CPF fica `disabled` (bloqueado).
3. **Modal de Visualizar (`modal-funcionario-ver`):** Modo leitura. Utiliza `.detalhes-grid` para exibir os dados e o histórico (data de criação, atualização e exclusão).
4. **Modal de Excluir (`modal-funcionario-excluir`):** Tela de confirmação (`.modal-pequeno`) com botão destrutivo (`.btn-perigo`).

## Atributos de Integração com JS
- Botões de ação usam `data-abrir-modal="id-do-modal"` e `data-id="id-do-registro"` para que o JavaScript saiba qual modal abrir e qual dado carregar.
- O formulário usa `novalidate` para que a validação seja controlada via JS no futuro.

## Acessibilidade e Semântica
- Uso de `aria-label` nos botões de fechar (`&times;`).
- Uso de `novalidate` no form para controlar a validação via JS (futuro).
- Botões de ação na tabela (olho, lápis, lixeira) com atributos `data-abrir-modal` e `data-id` para o JS identificar qual registro está sendo manipulado.