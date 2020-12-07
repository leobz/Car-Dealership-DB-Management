--------------------------------------------------------------------------
----------------     Limpieza de Esquema UNIX            -----------------

USE [GD2C2020]
GO

IF(OBJECT_ID('BI_EliminarFKs') IS NOT NULL)
	DROP PROCEDURE BI_EliminarFKs
GO

IF(OBJECT_ID('BI_EliminarEsquemaUnix') IS NOT NULL)
	DROP PROCEDURE BI_EliminarEsquemaUnix
GO

CREATE PROCEDURE BI_EliminarFKs
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

CREATE PROCEDURE BI_EliminarEsquemaUnix
AS
DROP TABLE UNIX.BI_HechoModelo
DROP TABLE UNIX.BI_TipoCaja
DROP TABLE UNIX.BI_TipoMotor
DROP TABLE UNIX.BI_Modelo
DROP TABLE UNIX.BI_Potencia
DROP TABLE UNIX.BI_Fabricante
DROP TABLE UNIX.BI_TipoAuto
DROP TABLE UNIX.BI_TipoTransmision
GO
-- Ejecucion de Procedures

EXEC BI_EliminarFKs;
EXEC BI_EliminarEsquemaUnix;

