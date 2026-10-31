O arquivo está disponível abaixo. Como o download não abriu, deixo também o conteúdo para você copiar e salvar como `tema.md`.

Baixar tema.md · Cópia em texto

# 02. JDBC — DAO

## 1. Blocos da demanda e objetivo

- CRUD administrativo: cadastrar, consultar, atualizar e excluir dados. Matérias: POO e Banco de Dados. O requisito pede: “fazer o CRUD dos dados administrativos de pelo menos três tabelas do BD”.
- Separação de responsabilidades: organizar o código em `servlet`, `dao` e `model`. Matéria: POO. O requisito pede “separando as responsabilidades pelo menos nos pacotes: `servlet`, `dao` e `model`”.
- Acesso ao PostgreSQL: permitir que Java execute comandos SQL no banco. Matérias: POO e Banco de Dados. O requisito determina: “Acessar um Banco de Dados relacional Postgres usando JDBC”.
- Filtros e consultas: encontrar registros por diferentes campos e relacionar dados. Matérias: POO e Banco de Dados. O requisito extra pede “diversificar os métodos para alterar e excluir dados [...] por diferentes campos”.

## 2. Por que usar DAO com JDBC?

O DAO reúne os métodos que acessam o banco; o JDBC permite executar SQL pelo Java. Juntos, organizam o CRUD do Mottainai e separam o acesso aos dados das telas.

Sem DAO, comandos SQL podem ficar espalhados pelo sistema, aumentando a repetição e dificultando correções. Sem fechar os recursos JDBC, conexões podem ficar ocupadas. Use `PreparedStatement` para passar valores com segurança e `try-with-resources` para fechar os recursos automaticamente.

## 3. Exemplo de código

Exemplo para a tabela `product`, com as colunas `id`, `name` e `price`. A classe `Product` deve ter os getters e setters usados no código, e `DataBaseConnection` deve fornecer `connection()`.

```
package org.mot.mottainaijdbc.dao;

import org.mot.mottainaijdbc.connection.DataBaseConnection;
import org.mot.mottainaijdbc.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// Centraliza as operações SQL relacionadas a produtos.
public class ProductDAO {

    // Cadastra um produto.
    public int insert(Product product) throws SQLException {
        String sql = "INSERT INTO product (name, price) VALUES (?, ?)";
        try (Connection connection = DataBaseConnection.getInstance().connection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, product.getName());
            statement.setBigDecimal(2, product.getPrice());
            return statement.executeUpdate();
        }
    }

    // Retorna todos os produtos cadastrados.
    public List<Product> findAll() throws SQLException {
        String sql = "SELECT id, name, price FROM product ORDER BY id";
        List<Product> products = new ArrayList<>();

        try (Connection connection = DataBaseConnection.getInstance().connection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Product product = new Product();
                product.setId(resultSet.getInt("id"));
                product.setName(resultSet.getString("name"));
                product.setPrice(resultSet.getBigDecimal("price"));
                products.add(product);
            }
        }
        return products;
    }

    // Atualiza nome e preço usando o identificador do produto.
    public int updateById(Product product) throws SQLException {
        String sql = "UPDATE product SET name = ?, price = ? WHERE id = ?";

        try (Connection connection = DataBaseConnection.getInstance().connection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, product.getName());
            statement.setBigDecimal(2, product.getPrice());
            statement.setInt(3, product.getId());
            return statement.executeUpdate();
        }
    }

    // Exclui o produto indicado pelo identificador.
    public int deleteById(int id) throws SQLException {
        String sql = "DELETE FROM product WHERE id = ?";

        try (Connection connection = DataBaseConnection.getInstance().connection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            return statement.executeUpdate();
        }
    }
}
```

## 4. Conexão com a matéria

- Classes e objetos: `Product` representa os dados do produto; `ProductDAO` executa operações no banco.
- Encapsulamento: o SQL fica concentrado no DAO, sem ser espalhado pelos Servlets.
- Métodos e parâmetros: cada método executa uma operação específica e recebe os dados necessários.
- Abstração e reutilização: outras classes chamam os métodos do DAO sem repetir o código JDBC.