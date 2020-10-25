--------------------------------------------------------------------------
----------------     Limpieza de Esquema UNIX            -----------------


-- Definicion de Procedures
CREATE PROCEDURE EliminarFKs
AS
    DECLARE @SQL as varchar(2000)
    DECLARE @Schema as varchar(200)
    DECLARE @Table as varchar(200)
    DECLARE @Constraint as varchar(200)

    DECLARE FKCursor CURSOR READ_ONLY FOR
    SELECT Table_Schema,Table_Name, Constraint_Name
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
    DEALLOCATE FKCursor;

;

CREATE PROCEDURE EliminarEsquemaUnix
AS
	DROP TABLE UNIX.Automovil
	DROP TABLE UNIX.Autoparte
	DROP TABLE UNIX.Cliente
	DROP TABLE UNIX.Compra
	DROP TABLE UNIX.CompraPorAutoparte
	DROP TABLE UNIX.CompraAutomovil
	DROP TABLE UNIX.ItemAutomovil
	DROP TABLE UNIX.ItemAutoparte
	DROP TABLE UNIX.Fabricante
	DROP TABLE UNIX.Factura
	DROP TABLE UNIX.Modelo
	DROP TABLE UNIX.Sucursal
	DROP TABLE UNIX.TipoAuto
	DROP TABLE UNIX.TipoCaja
	DROP TABLE UNIX.TipoMotor
	DROP TABLE UNIX.TipoTransmision
	DROP SCHEMA UNIX;

-- Ejecucion de Procedures

EXEC EliminarFKs;
EXEC EliminarEsquemaUnix;



ALTER TABLE UNIX.Autoparte
DROP CONSTRAINT FK_Autop_Modelo

DROP TABLE UNIX.Autoparte
DROP TABLE UNIX.Compra