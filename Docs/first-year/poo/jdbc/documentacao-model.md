
# 03. JDBC — Model

## 1. Blocos da demanda e objetivo

- **Representação dos dados:** criar classes Java que representem entidades do sistema, como produtos. **Matéria:** POO. O requisito pede “fazer o CRUD dos dados administrativos de pelo menos três tabelas do BD”.
- **Organização do código:** manter as classes de dados no pacote `model`, separado de `dao` e `servlet`. **Matéria:** POO. O documento exige “separando as responsabilidades pelo menos nos pacotes: `servlet`, `dao` e `model`”.
- **Integração com o banco:** permitir que o DAO use objetos do model para transportar dados entre Java e PostgreSQL. **Matérias:** POO e Banco de Dados. O requisito determina “Acessar um Banco de Dados relacional Postgres usando JDBC”.

## 2. Por que usar Model?

O `model` representa os dados do sistema por meio de classes e objetos. Ele organiza os atributos e métodos de cada entidade, facilitando o uso dos dados pelo DAO e pelo restante da aplicação.

Sem o `model`, os dados podem ficar espalhados em variáveis e estruturas repetidas, dificultando a manutenção. No Mottainai, ele organiza informações usadas no controle de produtos e estoque.

## 3. Exemplo de código

```java
package org.mot.mottainaijdbc.model;

// Representa um produto cadastrado no sistema.
public class Product {

    // Armazena os dados principais do produto.
    private int id;
    private String name;
    private int quantity;

    // Define os dados iniciais do produto.
    public Product(int id, String name, int quantity) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
    }

    // Permite consultar e alterar o identificador.
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    // Permite consultar e alterar o nome.
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    // Permite consultar e alterar a quantidade.
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
```

## 4. Conexão com a matéria

- **Classe e objeto:** `Product` define o modelo; cada objeto representa um produto.
- **Encapsulamento:** os atributos são `private` e acessados por métodos públicos.
- **Construtor:** define os dados iniciais do objeto.
- **Separação de responsabilidades:** o `model` representa os dados, o `DAO` acessa o banco e o `Servlet` recebe as requisições web.
