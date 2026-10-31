# Páginas de Entidades (CRUD)

Cada entidade do banco de dados possui uma interface própria no painel. A estrutura HTML é padronizada.

## Entidades Mapeadas
1. **Empresas (`Empresas.html`):** Razão Social, CNPJ (com máscara), E-mail, Telefone, Latitude e Longitude.
2. **Lojas (`Lojas.html`):** Vínculo com Empresa (select), CNPJ, E-mail, Telefone e Endereço (select).
3. **Funcionários (`Funcionario.html`):** Nome, CPF (com máscara), Telefone, E-mail, Loja, Cargo e Data de Admissão.
4. **Cargos (`Cargos.html`):** Nome do cargo, Descrição e Nível de Permissão.
5. **Contas de Usuários (`ContasUsuarios.html`):** E-mail de acesso, Funcionário (select) e Senha.
6. **Planos de Assinatura (`PlanosAssinatura.html`):** Nome, Descrição, Preço, Limite de Lojas e Limite de Usuários.
7. **Endereços (`Enderecos.html`):** CEP, Logradouro, Número, Bairro, Cidade e Estado.

## Estrutura Padrão de uma Página
- **Sidebar:** Navegação com a página atual destacada via atributo `data-pagina` no `<body>`.
- **Header:** Título da página e dados do usuário logado.
- **Toolbar:** Campo de busca (`<input>`), filtro (`<select>`) e botão de cadastro.
- **Tabela:** Listagem de dados com ícones de ação (olho, lápis, lixeira).
- **Paginação:** Controles de navegação.