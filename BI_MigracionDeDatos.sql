BEGIN TRANSACTION

--------------------------- DIMENSIONES  -----------------------------

INSERT INTO UNIX.BI_Modelo(MODELO_CODIGO, MODELO_NOMBRE)
SELECT DISTINCT MODELO_CODIGO, MODELO_NOMBRE
FROM UNIX.Modelo
WHERE MODELO_CODIGO IS NOT NULL;


INSERT INTO UNIX.BI_TipoCaja (TIPO_CAJA_CODIGO, TIPO_CAJA_DESC)
SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
FROM UNIX.TipoCaja
WHERE TIPO_CAJA_CODIGO IS NOT NULL;


INSERT INTO UNIX.BI_TipoMotor (TIPO_MOTOR_CODIGO)
SELECT DISTINCT TIPO_MOTOR_CODIGO
FROM UNIX.TipoMotor
WHERE TIPO_MOTOR_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_Fabricante (FABRICANTE_CODIGO, FABRICANTE_NOMBRE)
SELECT DISTINCT FABRICANTE_CODIGO, FABRICANTE_NOMBRE
FROM UNIX.Fabricante
WHERE FABRICANTE_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_TipoAuto (TIPO_AUTO_CODIGO, TIPO_AUTO_DESC)
SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
FROM UNIX.TipoAuto
WHERE TIPO_AUTO_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_TipoTransmision (TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC)
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
FROM UNIX.TipoTransmision
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL;

INSERT INTO UNIX.BI_Potencia(POTENCIA_CODIGO, POTENCIA)
VALUES(1, '50-150cv'), (2, '151-300cv'), (3, '> 300cv');

INSERT INTO UNIX.BI_Sucursal(SUCURSAL_CODIGO, SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO,SUCURSAL_CIUDAD)
SELECT SUCURSAL_CODIGO, SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO,SUCURSAL_CIUDAD
FROM UNIX.Sucursal

INSERT INTO UNIX.BI_Tiempo(ANIO,MES)
	(SELECT DISTINCT YEAR(COMPRA_FECHA), MONTH(COMPRA_FECHA) FROM UNIX.Compra)
	UNION
	(SELECT DISTINCT YEAR(FACTURA_FECHA), MONTH(FACTURA_FECHA) FROM UNIX.Factura)

INSERT INTO UNIX.BI_Edad (EDAD_CODIGO, EDAD)
VALUES(1, '18 - 30 anios'), (2, '30 - 50 anios'), (3, '> 50 anios');

INSERT INTO UNIX.BI_Autoparte(AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION,AUTO_PARTE_PRECIO)
SELECT AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION,AUTO_PARTE_PRECIO
FROM UNIX.Autoparte


--------------------------- HECHO MODELO -----------------------------

IF(OBJECT_ID('tempdb.dbo.#TablaTemporal') IS NOT NULL)
	DROP TABLE #TablaTemporal
GO

CREATE TABLE #TablaTemporal (MODELO_CODIGO int, tiempoStockPromedio int)

INSERT INTO #TablaTemporal
SELECT MODELO_CODIGO, SUM(DATEDIFF (DAY, COMPRA_FECHA , FACTURA_FECHA ))/ COUNT(*) tiempoStockPromedio
FROM UNIX.Automovil a
JOIN UNIX.CompraAutomovil ca ON (ca.AUTOMOVIL_CODIGO = a.AUTOMOVIL_CODIGO)
JOIN UNIX.Compra c ON (c.COMPRA_NRO  = ca.COMPRA_NRO)
JOIN UNIX.ItemAutomovil ia ON (ia.AUTOMOVIL_CODIGO = a.AUTOMOVIL_CODIGO)
JOIN UNIX.Factura f ON (f.FACTURA_NRO = ia.FACTURA_NRO)
GROUP BY MODELO_CODIGO
ORDER BY MODELO_CODIGO


INSERT INTO UNIX.BI_HechoModelo 
(MODELO_CODIGO, TIPO_CAJA_CODIGO, TIPO_MOTOR_CODIGO, TIPO_TRANSMISION_CODIGO,
 TIPO_AUTO_CODIGO, FABRICANTE_CODIGO, POTENCIA_CODIGO, PROMEDIO_TIEMPO_STOCK)
SELECT m.MODELO_CODIGO, TIPO_CAJA_CODIGO, TIPO_MOTOR_CODIGO, TIPO_TRANSMISION_CODIGO, TIPO_AUTO_CODIGO, FABRICANTE_CODIGO,
  CASE
    WHEN MODELO_POTENCIA BETWEEN 49 AND 150  THEN 1
    WHEN MODELO_POTENCIA BETWEEN 151 AND 300  THEN 2
    ELSE  3
  END AS POTENCIA_CODIGO, tiempoStockPromedio
FROM UNIX.Modelo m
JOIN #TablaTemporal t ON (t.MODELO_CODIGO = m.MODELO_CODIGO);
GO

--------------------------- FUNCION CALCULAR RANGO EDAD -----------------------------


CREATE OR ALTER FUNCTION CalcularRangoEdad(@FechaNacimiento DATETIME2)
RETURNS INT
BEGIN
  DECLARE @Anios INT
  DECLARE @Result INT
  SET @Anios = CAST(DATEDIFF (YEAR, @FechaNacimiento, GETDATE()) AS INT)
  
  IF (@Anios BETWEEN 18 AND 30) 
  BEGIN
    SET @Result = 1
  END

  IF (@Anios BETWEEN 31 AND 50) 
  BEGIN
    SET @Result = 2
  END

  IF (@Anios > 50) 
  BEGIN
    SET @Result = 3
  END

  RETURN @Result
END
GO

--------------------------- HECHO AUTOMOVIL COMPRA -----------------------------

INSERT INTO UNIX.BI_HechoAutomovilCompra (TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_COMPRADA, COMPRA_TOTAL)
SELECT
  TIEMPO_CODIGO, s.SUCURSAL_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO, COUNT(*) CANTIDAD_TOTAL_COMPRADA, SUM(PRECIO_TOTAL) COMPRA_TOTAL
FROM UNIX.Compra c
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(COMPRA_FECHA) AND t.MES = MONTH(COMPRA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = c.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = c.CLIENTE_CODIGO)
WHERE TIPO_COMPRA = 'AM'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO;


--------------------------- HECHO AUTOMOVIL VENTA -----------------------------

INSERT INTO UNIX.BI_HechoAutomovilVenta (TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_VENDIDA, VENTA_TOTAL)
SELECT
  TIEMPO_CODIGO, s.SUCURSAL_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO, COUNT(*) CANTIDAD_TOTAL_VENTA, SUM(PRECIO_TOTAL) VENTA_TOTAL
FROM UNIX.Factura f
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(FACTURA_FECHA) AND t.MES = MONTH(FACTURA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = f.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = f.CLIENTE_CODIGO)
WHERE TIPO_PRODUCTO = 'AM'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO;

--------------------------- HECHO AUTOPARTE COMPRA -----------------------------

INSERT INTO UNIX.BI_HechoAutoparteCompra (TIEMPO_CODIGO, SUCURSAL_CODIGO, AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_COMPRADA, COMPRA_TOTAL)
SELECT
  TIEMPO_CODIGO, s.SUCURSAL_CODIGO,ca.AUTO_PARTE_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO, SUM(COMPRA_CANT) CANTIDAD_TOTAL_COMPRADA, SUM(PRECIO_TOTAL) COMPRA_TOTAL
FROM UNIX.Compra c
JOIN UNIX.CompraPorAutoparte ca ON(c.COMPRA_NRO=ca.COMPRA_NRO)
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(COMPRA_FECHA) AND t.MES = MONTH(COMPRA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = c.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = c.CLIENTE_CODIGO)
WHERE TIPO_COMPRA = 'AP'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO, AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO;

--------------------------- HECHO AUTOPARTE VENTA -----------------------------

INSERT INTO UNIX.BI_HechoAutoparteVenta (TIEMPO_CODIGO, SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO, CANTIDAD_TOTAL_VENDIDA, VENTA_TOTAL)
SELECT
  TIEMPO_CODIGO, s.SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC) CLIENTE_EDAD_CODIGO, SUM(CANT_FACTURADA) CANTIDAD_TOTAL_VENDIDA, SUM(PRECIO_TOTAL) VENTA_TOTAL
FROM UNIX.Factura f
JOIN UNIX.ItemAutoparte ia ON(f.FACTURA_NRO=ia.FACTURA_NRO)
--JOIN UNIX.BI_Autoparte aut ON(ia.AUTO_PARTE_CODIGO=aut.AUTO_PARTE_CODIGO)
JOIN UNIX.BI_Tiempo t ON (t.ANIO =  YEAR(FACTURA_FECHA) AND t.MES = MONTH(FACTURA_FECHA))
JOIN UNIX.BI_Sucursal s ON (s.SUCURSAL_CODIGO = f.SUCURSAL_CODIGO)
JOIN UNIX.Cliente cl ON (cl.CLIENTE_CODIGO = f.CLIENTE_CODIGO)
WHERE TIPO_PRODUCTO = 'AP'
GROUP BY TIEMPO_CODIGO, s.SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, dbo.CalcularRangoEdad(CLIENTE_FECHA_NAC)
ORDER BY TIEMPO_CODIGO, SUCURSAL_CODIGO,AUTO_PARTE_CODIGO, CLIENTE_EDAD_CODIGO;

COMMIT TRANSACTION


---------------------------------------------------------  VISTAS  ------------------------------------------------------

-----------------------------  VISTAS  AUTOMOVIL ------------------------------------------------------

----------  Cantidad de automóviles, vendidos y comprados x sucursal y mes
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Cantidad_Comprados_Vendidos AS
SELECT
  COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
  COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
  COALESCE(ac.CLIENTE_EDAD_CODIGO, av.CLIENTE_EDAD_CODIGO) CLIENTE_EDAD_CODIGO,
  COALESCE(CANTIDAD_TOTAL_COMPRADA, 0) CANTIDAD_TOTAL_COMPRADA,
  COALESCE(CANTIDAD_TOTAL_VENDIDA, 0) CANTIDAD_TOTAL_VENDIDA
FROM UNIX.BI_HechoAutomovilCompra ac
FULL OUTER JOIN UNIX.BI_HechoAutomovilVenta av 
  ON (
    av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
    av.SUCURSAL_CODIGO = ac.TIEMPO_CODIGO AND
    av.CLIENTE_EDAD_CODIGO = ac.CLIENTE_EDAD_CODIGO
    );
GO




----------  Ganancias (precio de venta – precio de compra) x Sucursal x mes
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Ganancias AS
SELECT
  COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
  COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
  COALESCE(ac.CLIENTE_EDAD_CODIGO, av.CLIENTE_EDAD_CODIGO) CLIENTE_EDAD_CODIGO,
  COALESCE(av.VENTA_TOTAL, 0) - COALESCE(ac.COMPRA_TOTAL, 0) GANANCIAS
FROM UNIX.BI_HechoAutomovilCompra ac
FULL OUTER JOIN UNIX.BI_HechoAutomovilVenta av 
  ON (
    av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
    av.SUCURSAL_CODIGO = ac.TIEMPO_CODIGO AND
    av.CLIENTE_EDAD_CODIGO = ac.CLIENTE_EDAD_CODIGO
    );
GO


----------  Promedio de tiempo en stock de cada modelo de automóvil.
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Stock AS
SELECT MODELO_CODIGO, PROMEDIO_TIEMPO_STOCK
FROM UNIX.BI_HechoModelo
GO


----------  Precio promedio de automóviles, vendidos y comprados.
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Automoviles_Precio_Promedio AS
SELECT 
(SELECT SUM(COMPRA_TOTAL) / SUM(CANTIDAD_TOTAL_COMPRADA) FROM UNIX.BI_HechoAutomovilCompra) PRECIO_PROMEDIO_COMPRA,
(SELECT SUM(VENTA_TOTAL) / SUM(CANTIDAD_TOTAL_VENDIDA) FROM UNIX.BI_HechoAutomovilVenta) PRECIO_PROMEDIO_VENTA
GO


-----------------------------  VISTAS  AUTOPARTE ------------------------------------------------------

----------  Precio promedio de autopartes, vendidas y compradas
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Autopartes_Precio_Promedio AS
SELECT 
(SELECT SUM(COMPRA_TOTAL) / SUM(CANTIDAD_TOTAL_COMPRADA) FROM UNIX.BI_HechoAutoparteCompra) PRECIO_PROMEDIO_COMPRA,
(SELECT SUM(VENTA_TOTAL) / SUM(CANTIDAD_TOTAL_VENDIDA) FROM UNIX.BI_HechoAutoparteVenta) PRECIO_PROMEDIO_VENTA
GO

----------  Ganancias (precio de venta – precio de compra) x Sucursal x mes
GO
CREATE OR ALTER VIEW UNIX.BI_Vista_Autopartes_Ganancias AS
SELECT
  COALESCE(ac.TIEMPO_CODIGO, av.TIEMPO_CODIGO) TIEMPO_CODIGO,
  COALESCE(ac.SUCURSAL_CODIGO, av.SUCURSAL_CODIGO) SUCURSAL_CODIGO,
  COALESCE(ac.CLIENTE_EDAD_CODIGO, av.CLIENTE_EDAD_CODIGO) CLIENTE_EDAD_CODIGO,
  SUM(av.VENTAS_TOTALES) - SUM(ac.COMPRAS_TOTALES) GANANCIAS
FROM 
  (SELECT TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO, SUM(COMPRA_TOTAL) COMPRAS_TOTALES
  FROM UNIX.BI_HechoAutoparteCompra
  GROUP BY TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO
  ) ac
FULL OUTER JOIN
  (SELECT TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO, SUM(VENTA_TOTAL) VENTAS_TOTALES
  FROM UNIX.BI_HechoAutoparteVenta
  GROUP BY TIEMPO_CODIGO, SUCURSAL_CODIGO, CLIENTE_EDAD_CODIGO
  ) av 
  ON (
    av.TIEMPO_CODIGO = ac.TIEMPO_CODIGO AND
    av.SUCURSAL_CODIGO = ac.TIEMPO_CODIGO AND
    av.CLIENTE_EDAD_CODIGO = ac.CLIENTE_EDAD_CODIGO
    )
GO

SELECT * FROM UNIX.BI_HechoAutoparteCompra

SELECT * FROM UNIX.BI_HechoAutoparteCompra


SELECT * FROM UNIX.BI_Vista_Automoviles_Cantidad_Comprados_Vendidos
SELECT * FROM UNIX.BI_Vista_Automoviles_Ganancias
SELECT * FROM UNIX.BI_Vista_Automoviles_Stock
SELECT * FROM UNIX.BI_Vista_Automoviles_Precio_Promedio