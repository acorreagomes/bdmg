/*
  Banco: BDMG
  Objetos: tabela dbo.tarefas e trigger dbo.trg_Tarefas_DataConclusao
  Compativel com SQL Server 2014 ou superior.
  O script pode ser executado mais de uma vez sem erro.
*/

USE master;
GO

IF DB_ID('BDMG') IS NULL
    CREATE DATABASE BDMG;
GO

USE BDMG;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/* ---------- Tabela ---------- */
IF OBJECT_ID('dbo.tarefas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.tarefas (
        id             INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        descricao      VARCHAR(250)      NOT NULL,
        status         CHAR(9)           NOT NULL
            CONSTRAINT DF_tarefas_status DEFAULT 'Pendente',
        prioridade     CHAR(5)           NOT NULL
            CONSTRAINT DF_tarefas_prioridade DEFAULT 'Baixa',
        data_conclusao DATETIME          NULL
    );
END
GO

/* ---------- Trigger ---------- */
IF OBJECT_ID('dbo.trg_Tarefas_DataConclusao', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_Tarefas_DataConclusao;
GO

CREATE TRIGGER dbo.trg_Tarefas_DataConclusao
ON dbo.tarefas
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Concluida: preenche a data se ainda nao tiver
    UPDATE t
    SET t.data_conclusao = GETDATE()
    FROM dbo.tarefas t
    INNER JOIN inserted i ON i.id = t.id
    WHERE i.status = 'Concluida'
      AND t.data_conclusao IS NULL;

    -- Voltou para Pendente: limpa a data
    UPDATE t
    SET t.data_conclusao = NULL
    FROM dbo.tarefas t
    INNER JOIN inserted i ON i.id = t.id
    WHERE i.status = 'Pendente'
      AND t.data_conclusao IS NOT NULL;
END;
GO
