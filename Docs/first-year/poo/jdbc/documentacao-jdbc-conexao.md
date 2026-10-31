# JDBC — Conexão com o PostgreSQL

Parte do requisito da disciplina **Programação Orientada a Objetos (POO)**. Esta documentação apresenta a necessidade da conexão JDBC no Mottainai, um exemplo de implementação com `dotenv` e sua relação com POO.

## 1. Demanda e objetivo

**Disciplina: POO**

**Trecho da demanda:** “Acessar um Banco de Dados relacional Postgres usando JDBC.”

**Objetivo:** permitir que a aplicação Java se conecte ao PostgreSQL para consultar e persistir os dados administrativos do Mottainai.

**Disciplina: Sistemas Operacionais**

**Trecho da demanda:** “Estruturar variáveis do ambiente (`.env`) para o sistema (segurança de código): ENVs para banco de dados e API externas.”

**Objetivo:** manter as configurações de conexão, especialmente a senha, fora do código-fonte.

## 2. Por que usar JDBC?

JDBC é a API que permite à aplicação Java comunicar-se com o banco de dados por meio de um driver. No Mottainai, essa conexão é necessária para que os DAOs executem operações de cadastro, consulta, alteração e exclusão no PostgreSQL.

Sem uma conexão com o banco, a aplicação não consegue acessar os dados persistidos por meio de JDBC; por consequência, as operações que dependem desses dados não funcionarão. A conexão é a base do acesso ao banco, mas não implementa o CRUD sozinha: os comandos SQL são executados pelas classes responsáveis por essas operações.

## 3. Exemplo de conexão JDBC com dotenv

No arquivo `.env`, configure os dados da conexão usando nomes de variáveis em inglês:

```dotenv
# Estrutura da URL JDBC: jdbc:postgresql://<host>:<port>/<database>
DB_URL=jdbc:postgresql://<host>:<port>/<database>

# Nome de usuário do PostgreSQL
DB_USER=<username>

# Senha do usuário do PostgreSQL
DB_PASSWORD=<password>
```

**Estrutura da URL JDBC:**

`jdbc:postgresql://<host>:<port>/<database>`

- `jdbc`: indica que a conexão usa a API JDBC.
- `postgresql`: identifica o banco de dados PostgreSQL.
- `<host>`: endereço do servidor do banco de dados.
- `<port>`: porta em que o PostgreSQL recebe conexões.
- `<database>`: nome do banco de dados que será acessado.

Substitua os valores entre `< >` pelos dados do ambiente utilizado.

Exemplo da classe `DataBaseConnection`:

```java
package org.mot.mottainaijdbc.connection;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Centraliza a configuração e a abertura de conexões com o PostgreSQL. */
public class DataBaseConnection {

    // Carrega as variáveis definidas no arquivo .env.
    private static final Dotenv dotenv = Dotenv.load();

    // Obtém as configurações sem deixar as credenciais escritas diretamente no código.
    private static final String URL = dotenv.get("DB_URL");
    private static final String USER = dotenv.get("DB_USER");
    private static final String PASSWORD = dotenv.get("DB_PASSWORD");

    // Cria uma única instância da classe (padrão Singleton).
    private static final DataBaseConnection INSTANCE = new DataBaseConnection();

    // Impede que outras classes criem instâncias diretamente.
    private DataBaseConnection() {
    }

    // Disponibiliza a instância única da classe.
    public static DataBaseConnection getInstance() {
        return INSTANCE;
    }

    // Abre e retorna uma conexão JDBC usando as configurações do .env.
    // A classe que utilizar a conexão deve fechá-la após terminar as operações.
    public Connection connection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

O projeto precisa ter o driver JDBC do PostgreSQL e a biblioteca `dotenv-java` configurados no `pom.xml`.

> **Observação importante sobre o dotenv:** a biblioteca `dotenv` carrega os valores definidos no arquivo `.env`; ela não criptografa esses valores. Como o arquivo pode conter credenciais, inclua `.env` no `.gitignore` para evitar enviá-lo ao GitHub e expor o acesso ao banco. Não coloque senhas reais no repositório. Se um arquivo com credenciais já tiver sido enviado, removê-lo depois não elimina a exposição: troque as credenciais comprometidas.

No `.gitignore`, inclua:

```gitignore
.env
```

## 4. Relação com POO

A conexão JDBC se relaciona com POO pela **encapsulação** e pela **separação de responsabilidades**. A classe `DataBaseConnection` centraliza a configuração e a abertura da conexão; os DAOs utilizam essa conexão para executar comandos SQL; os modelos (`model`) representam os dados; e os servlets recebem e respondem às requisições web. Essa organização deixa o código mais claro e facilita sua manutenção.
