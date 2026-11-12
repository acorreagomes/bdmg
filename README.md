# Executar/Testar Sistema 
- Criar uma pasta no C:\ com o nome exemplo "BDMG" e colocar os arquivos "BDMG.exe", "Server.exe" e "config.ini" dentro dela.
- Configurar os dados de conexão em "config.ini".
- Executar o executável do serviço "Server.exe". (Obs: Serviço roda na porta: 9091)
- Executar o sistema "BDMG.exe" e testar as funcionalidades.

# Banco BDMG - Tarefas

Script de criação do banco `BDMG`, da tabela `tarefas` e da trigger `trg_Tarefas_DataConclusao`.

## Requisitos

- SQL Server 2014 ou superior (desenvolvido no SQL Server 2014 Express).
- SQL Server Management Studio (SSMS) ou Azure Data Studio.

## Como executar

1. Conecte-se à instância do SQL Server.
2. Abra o arquivo `banco.sql`.
3. Execute o script inteiro (F5).

Ou, pela linha de comando:

```
sqlcmd -S localhost -E -i banco.sql
```

O script é reexecutável: se rodar mais de uma vez, não gera erro nem apaga dados da tabela.

## Estrutura

Tabela `dbo.tarefas`:

| Coluna          | Tipo         | Regra                       |
|-----------------|--------------|-----------------------------|
| id              | INT          | Chave primária, identity    |
| descricao       | VARCHAR(250) | Obrigatória                 |
| status          | CHAR(9)      | Obrigatória, padrão `Pendente` |
| prioridade      | CHAR(5)      | Obrigatória, padrão `Baixa` |
| data_conclusao  | DATETIME     | Opcional, preenchida pela trigger |

## Trigger `trg_Tarefas_DataConclusao`

Dispara após `INSERT` e `UPDATE` na tabela `tarefas`:

- Quando o status é `Concluida` e `data_conclusao` está vazia, preenche com a data/hora atual.
- Quando o status volta para `Pendente`, limpa `data_conclusao`.

Observação: o status `Concluida` é escrito sem acento.

## Conexão com o banco (config.ini)

A conexão do sistema com o banco é configurada no arquivo `config.ini`, que fica **no mesmo diretório do executável**. 
Ajuste-o antes de abrir o sistema.

```ini
[Conexao]
DriverID=MSSQL
Server=NOME_DO_SERVIDOR\NOME_DA_INSTANCIA
Database=BDMG
OSAuthent=Yes
User_Name=
Password=
```

| Chave       | Descrição                                                                 |
|-------------|---------------------------------------------------------------------------|
| Server      | Servidor e instância do SQL Server (ex.: `localhost\SQLEXPRESS`)         |
| Database    | Nome do banco: `BDMG`                                                     |
| OSAuthent   | `Yes` usa a autenticação do Windows; `No` usa login e senha do SQL Server |
| User_Name   | Usuário do SQL Server (somente quando `OSAuthent=No`)                     |
| Password    | Senha do usuário (somente quando `OSAuthent=No`)                          |

Para usar a autenticação do SQL Server, altere para:

```ini
OSAuthent=No
User_Name=seu_usuario
Password=sua_senha
```

Se o sistema não conectar, confira o nome do servidor/instância, se o serviço do SQL Server está em execução e se o banco `BDMG` foi criado pelo `banco.sql`.
