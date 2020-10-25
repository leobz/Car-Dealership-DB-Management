BEGIN TRANSACTION
USE [GD2C2020]
GO
CREATE SCHEMA UNIX
GO
COMMIT

-- CREACION DE TABLAS --

CREATE TRIGGER tipoCompra
on UNIX.Compra
instead of insert
AS
BEGIN
	declare @compra_num decimal(18,0), @cliente_codigo int, @sucursal_codigo int,
	@compra_fecha datetime2(3), @precio_total decimal(18,2), @auto_parte_codigo decimal(18,0)
	
	declare c_compras cursor for select i.COMPRA_NRO,CLIENTE_CODIGO,
	SUCURSAL_CODIGO, COMPRA_FECHA, PRECIO_TOTAL, T.AUTO_PARTE_CODIGO
	from inserted i JOIN (SELECT DISTINCT COMPRA_NRO, AUTO_PARTE_CODIGO
	FROM  gd_esquema.Maestra M 
	WHERE COMPRA_NRO IS NOT NULL) AS T
	ON (i.COMPRA_NRO=T.COMPRA_NRO)
	
	open c_compras
	fetch from c_compras
	into @compra_num, @cliente_codigo, @sucursal_codigo,
	@compra_fecha, @precio_total, @auto_parte_codigo

	while @@fetch_status=0
	BEGIN
		if @auto_parte_codigo IS NULL
			begin
			INSERT INTO UNIX.Compra(COMPRA_NRO,CLIENTE_CODIGO, SUCURSAL_CODIGO,
			COMPRA_FECHA, TIPO_COMPRA, PRECIO_TOTAL)
			VALUES(@compra_num, @cliente_codigo, @sucursal_codigo,
			@compra_fecha,'automovil', @precio_total)
			end
		else
			begin
			INSERT INTO UNIX.Compra(COMPRA_NRO,CLIENTE_CODIGO, SUCURSAL_CODIGO, 
			COMPRA_FECHA, TIPO_COMPRA, PRECIO_TOTAL)
			VALUES(@compra_num, @cliente_codigo, @sucursal_codigo,
			@compra_fecha,'autoparte', @precio_total)
			end

	fetch from c_compras into @compra_num, @cliente_codigo, @sucursal_codigo,
	@compra_fecha, @precio_total, @auto_parte_codigo
	END
	close c_compras
	deallocate c_compras
END;

DROP Trigger tipoCompra