# Compilado de Testes: Painel CRUD

**Metodologia:** Teste moderado, 7 tarefas guiadas. Heurísticas de Nielsen e escala de severidade (0-4).

## Participantes
- **Lucas**, **Tainá**, **Paula**, **Luiz**

## Resultados Quantitativos
| Tarefa | Nota Média | Principais Observações |
|---|---|---|
| Navegação (Sidebar) | 2.75 | Destaque visual funciona bem. |
| Criar Registro | 3.0 | Botão "+ Cadastrar" é fácil de achar. |
| Visualizar Detalhes | 2.75 | Ícone de olho é claro, mas usuários tentam clicar na linha. |
| Editar | 2.25 | Dúvida unânime sobre por que o CPF não pode ser editado. |
| Excluir | 3.0 | Usuários sentem receio (ação destrutiva) e não leem o modal. |

## Principais Achados (Fricções)
1. **CPF Bloqueado:** Todos os 4 usuários notaram, mas ninguém entendeu o motivo (falta explicação).
2. **Máscara de CPF:** Bug identificado nos testes (Tainá e Luiz).
3. **Modal de Exclusão:** O texto é ignorado. Sugestão de redesign com ênfase no nome do item e botão de "Desfazer".
4. **Feedback de Salvamento:** Falta de confirmação clara após cadastrar ou editar (Tainá, Paula, Luiz).
5. **Filtro de Situação:** Filtro é pouco visível (Lucas e Paula).