--------------------------------------------------------------------------
----------------     Limpieza de Esquema UNIX            -----------------

USE [GD2C2020]
GO

/* Drop all views */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 v.name FROM sys.views as v WHERE OBJECT_SCHEMA_NAME(v.object_id) = 'UNIX')

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP VIEW [UNIX].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped View: ' + @name
    SELECT @name = (SELECT TOP 1 v.name FROM sys.views as v WHERE OBJECT_SCHEMA_NAME(v.object_id) = 'UNIX' AND v.name > @name ORDER BY v.name)
END
GO

/* Drop function */
IF(OBJECT_ID('CalcularRangoEdad') IS NOT NULL)
	DROP FUNCTION CalcularRangoEdad
GO

/* Drop all Foreing Keys */
IF(OBJECT_ID('EliminarFKs') IS NOT NULL)
	DROP PROCEDURE EliminarFKs
GO

CREATE PROCEDURE EliminarFKs
AS
DECLARE @SQL as varchar(2000)
DECLARE @Schema as varchar(200)
DECLARE @Table as varchar(200)
DECLARE @Constraint as varchar(200)
DECLARE FKCursor CURSOR READ_ONLY FOR
  SELECT Table_Schema, Table_Name, Constraint_Name
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
OPEN FKCursor
FETCH NEXT FROM FKCursor INTO @Schema,@Table,@Constraint
WHILE (@@fetch_status <> -1)
        BEGIN
    IF (@@fetch_status <> -2)
        BEGIN
        EXEC ('ALTER TABLE ' + @Schema + '.[' + @Table+ '] DROP CONSTRAINT [' + @Constraint + ']')
    END
    FETCH NEXT FROM FKCursor INTO @Schema,@Table,@Constraint
END
CLOSE FKCursor
DEALLOCATE FKCursor
GO

/* Drop all tables */
IF(OBJECT_ID('EliminarTablas') IS NOT NULL)
	DROP PROCEDURE EliminarTablas
GO

CREATE PROCEDURE EliminarTablas
AS
DECLARE @Table as varchar(200)
DECLARE TableCursor CURSOR READ_ONLY FOR
SELECT t.name 
FROM sys.tables t
WHERE schema_name(t.schema_id) = 'UNIX';
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @Table
WHILE (@@fetch_status <> -1)
        BEGIN
    IF (@@fetch_status <> -2)
        BEGIN
        EXEC ('DROP TABLE [UNIX]. ' + @Table)
    END
    FETCH NEXT FROM TableCursor INTO @Table
END
CLOSE TableCursor
DEALLOCATE TableCursor
GO

EXEC EliminarFKs;
EXEC EliminarTablas

DROP SCHEMA IF EXISTS UNIX; 