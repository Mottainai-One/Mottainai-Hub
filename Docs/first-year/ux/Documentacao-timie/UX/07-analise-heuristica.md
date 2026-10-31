# Análise Heurística (Nielsen)

## 1. Visibilidade do Status do Sistema
- **Falha:** Ausência de mensagens de sucesso (toast) ao cadastrar ou editar no CRUD.
- **Falha:** O botão de alternância "Anual" na Landing Page não dá feedback imediato ao clique, parecendo que o sistema travou.

## 2. Correspondência entre o Sistema e o Mundo Real
- **Falha:** Uso de jargão técnico "ERP" sem explicação na Landing Page. O público não reconhece o termo.

## 3. Controle e Liberdade do Usuário
- **Falha:** O carrossel automático na página "Sobre Nós" não possui botão de pausa e avança rápido demais, impedindo a leitura no tempo do usuário.

## 4. Consistência e Padrões
- **Falha:** Na listagem de Funcionários, os ícones de ação (olho, lápis, lixeira) estão claros, mas a linha não é clicável, contrariando o padrão de muitas tabelas.

## 5. Prevenção de Erros
- **Falha:** O modal de exclusão não destaca claramente o que será apagado e não oferece opção de desfazer.

## 6. Reconhecimento em vez de Memorização
- **Falha:** O CPF estar bloqueado na edição sem uma explicação visual (texto ou tooltip) obriga o usuário a adivinhar o motivo.

## 7. Flexibilidade e Eficiência de Uso
- **Falha:** O filtro de "Situação" na listagem do CRUD está pouco visível, fazendo os usuários recorrerem à busca por texto primeiro.

## 8. Estética e Design Minimalista
- **Sucesso:** A Landing Page foi amplamente elogiada por ser "clean", "profissional" e sem poluição visual.

## 9. Ajuda os Usuários a Reconhecer, Diagnosticar e Recuperar-se de Erros
- **Falha:** A máscara do CPF bugada nos testes de cadastro não indicava o erro de formatação de forma clara.

## 10. Ajuda e Documentação
- **Falha:** A página de FAQ não estava clara/implementada, e os usuários procuraram o botão "Entre em contato" para tirar dúvidas simples.