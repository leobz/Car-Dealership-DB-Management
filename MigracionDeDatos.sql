USE [GD2C2020]

CREATE SCHEMA UNIX;

-- CREACION DE TABLAS--

CREATE TABLE UNIX.Cliente (
ID_CLIENTE INT identity(1,1) PRIMARY KEY NOT NULL,
CLIENTE_APELLIDO nvarchar(255) NULL,
CLIENTE_NOMBRE nvarchar(255) NULL,
CLIENTE_DIRECCION nvarchar(255) NULL,
CLIENTE_DNI decimal(18,0) NULL,
CLIENTE_FECHA_NAC datetime2(3) NULL,
CLIENTE_MAIL nvarchar(255) NULL);


CREATE TABLE UNIX.Compra(
ID_COMPRA INT identity(1,1) PRIMARY KEY NOT NULL,
COMPRA_NRO decimal(18,0) NULL,
ID_CLIENTE INT NOT NULL,
ID_SUCURSAL INT NOT NULL,
ID_AUTOMOVIL INT NOT NULL,
COMPRA_FECHA datetime2(3) NULL,
COMPRA_PRECIO decimal(18,2) NULL,
COMPRA_TIPO char(2) NULL
);


CREATE TABLE UNIX.CompraPorAutoparte(
ID_COMPRAXAUTOP INT identity(1,1) PRIMARY KEY NOT NULL,
ID_COMPRA INT NOT NULL,
ID_AUTO_PARTE INT NOT NULL,
COMPRA_CANT decimal(18,0) NULL);


CREATE TABLE UNIX.Autoparte(
ID_AUTO_PARTE INT identity(1,1) PRIMARY KEY NOT NULL,
AUTO_PARTE_CODIGO decimal(18,0) NULL,
AUTO_PARTE_DESCRIPCION nvarchar(255) NULL,
ID_SUCURSAL INT NOT NULL,
ID_FABRICANTE INT NOT NULL,
ID_MODELO INT NOT NULL,
CATEGORIA_RUBRO varchar(255) NULL,
AUTO_PARTE_PRECIO decimal(18,2) NULL);


CREATE TABLE UNIX.Automovil(
ID_AUTOMOVIL INT identity(1,1) PRIMARY KEY NOT NULL,
ID_MODELO INT NOT NULL,
ID_SUCURSAL INT NOT NULL,
AUTO_NRO_CHASIS nvarchar(50) NULL,
AUTO_NRO_MOTOR nvarchar(50) NULL,
AUTO_PATENTE nvarchar(50) NULL,
AUTO_CANT_KMS decimal(18,0) NULL,
AUTO_FECHA_ALTA datetime2(3) NULL);


CREATE TABLE UNIX.Fabricante(
ID_FABRICANTE INT identity(1,1) PRIMARY KEY NOT NULL,
FABRICANTE_NOMBRE nvarchar(255) NULL);


CREATE TABLE UNIX.Sucursal(
ID_SUCURSAL INT identity(1,1) PRIMARY KEY NOT NULL,
SUCURSAL_DIRECCION nvarchar(255) NULL,
SUCURSAL_MAIL nvarchar(255) NULL,
SUCURSAL_TELEFONO decimal(18,0) NULL,
SUCURSAL_CIUDAD nvarchar(255) NULL);


CREATE TABLE UNIX.Modelo(
ID_MODELO INT identity(1,1) PRIMARY KEY NOT NULL,
MODELO_CODIGO decimal(18,0) NULL,
ID_FABRICANTE INT NOT NULL,
ID_TIPO_AUTO INT NOT NULL,
ID_TIPO_TRANSMISION INT NOT NULL,
ID_TIPO_CAJA INT NOT NULL,
ID_TIPO_MOTOR INT NOT NULL,
MODELO_NOMBRE nvarchar(255) NULL,
MODELO_POTENCIA decimal(18,0) NULL);


CREATE TABLE UNIX.TipoAuto(
ID_TIPO_AUTO INT identity(1,1) PRIMARY KEY NOT NULL,
TIPO_AUTO_CODIGO decimal(18,0) NULL,
TIPO_AUTO_DESC nvarchar(255) NULL);


CREATE TABLE UNIX.TipoTransmision(
ID_TIPO_TRANSMISION INT identity(1,1) PRIMARY KEY NOT NULL,
TIPO_TRANSMISION_CODIGO decimal(18,0) NULL,
TIPO_TRANSMISION_DESC nvarchar(255) NULL);


CREATE TABLE UNIX.TipoCaja(
ID_TIPO_CAJA INT identity(1,1) PRIMARY KEY NOT NULL,
TIPO_CAJA_CODIGO decimal(18,0) NULL,
TIPO_CAJA_DESC nvarchar(255) NULL);


CREATE TABLE UNIX.TipoMotor(
ID_TIPO_MOTOR INT identity(1,1) PRIMARY KEY NOT NULL,
TIPO_MOTOR_CODIGO decimal(18,0) NULL,
TIPO_MOTOR_DESC nvarchar(255) NULL);


CREATE TABLE UNIX.Factura(
ID_FACTURA INT identity(1,1) PRIMARY KEY NOT NULL,
FACTURA_NRO decimal(18,0) NULL,
FACTURA_FECHA datetime2(3) NULL,
PRECIO_FACTURADO decimal(18,2) NULL,
ID_SUCURSAL INT NOT NULL,
TIPO_PRODUCTO nvarchar(255) NULL,
ID_CLIENTE INT NOT NULL,
ID_COMPRA INT NOT NULL,
ID_AUTOMOVIL INT NOT NULL);


CREATE TABLE UNIX.Item(
ID_ITEM INT identity(1,1) PRIMARY KEY NOT NULL,
ID_FACTURA decimal(18,0) NULL,
ID_AUTO_PARTE decimal(18,0) NULL,
CANT_FACTURADA decimal(18,0) NULL,
ITEM_PRECIO decimal(18,2) NULL);


-- DECLARACION DE FOREIGN KEYS --

-- Tabla Compra

ALTER TABLE UNIX.Compra
ADD CONSTRAINT FK_CompraCliente 
FOREIGN KEY (ID_CLIENTE) REFERENCES UNIX.Cliente(ID_CLIENTE);

ALTER TABLE UNIX.Compra
ADD CONSTRAINT FK_CompraSucursal
FOREIGN KEY (ID_SUCURSAL) REFERENCES UNIX.Sucursal(ID_SUCURSAL);

ALTER TABLE UNIX.Compra
ADD CONSTRAINT FK_CompraAutomovil 
FOREIGN KEY (ID_AUTOMOVIL) REFERENCES UNIX.Automovil(ID_AUTOMOVIL);

--Tabla CompraPorAutoparte

ALTER TABLE UNIX.CompraPorAutoparte
ADD CONSTRAINT FK_CompraXAutopCompra
FOREIGN KEY (ID_COMPRA) REFERENCES UNIX.Compra(ID_COMPRA);

ALTER TABLE UNIX.CompraPorAutoparte
ADD CONSTRAINT FK_CompraXAutopAutop
FOREIGN KEY (ID_AUTO_PARTE) REFERENCES UNIX.Autoparte(ID_AUTO_PARTE);

-- Tabla Autoparte

ALTER TABLE UNIX.Autoparte
ADD CONSTRAINT FK_Autop_Sucursal
FOREIGN KEY (ID_SUCURSAL) REFERENCES UNIX.Sucursal(ID_SUCURSAL);

ALTER TABLE UNIX.Autoparte
ADD CONSTRAINT FK_Autop_Modelo
FOREIGN KEY (ID_MODELO) REFERENCES UNIX.Modelo(ID_MODELO);

ALTER TABLE UNIX.Autoparte
ADD CONSTRAINT FK_Autop_Fabricante
FOREIGN KEY (ID_FABRICANTE) REFERENCES UNIX.Fabricante(ID_FABRICANTE);

--Tabla Automovil

ALTER TABLE UNIX.Automovil
ADD CONSTRAINT FK_Automovil_Modelo
FOREIGN KEY (ID_MODELO) REFERENCES UNIX.Modelo(ID_MODELO);

ALTER TABLE UNIX.Automovil
ADD CONSTRAINT FK_Automovil_Sucursal
FOREIGN KEY (ID_SUCURSAL) REFERENCES UNIX.Sucursal(ID_SUCURSAL);

--Tabla Modelo

ALTER TABLE UNIX.Modelo
ADD CONSTRAINT FK_Modelo_Fabricante
FOREIGN KEY (ID_FABRICANTE) REFERENCES UNIX.Fabricante(ID_FABRICANTE);

ALTER TABLE UNIX.Modelo
ADD CONSTRAINT FK_Modelo_TipoCaja
FOREIGN KEY (ID_TIPO_CAJA) REFERENCES UNIX.TipoCaja(ID_TIPO_CAJA);

ALTER TABLE UNIX.Modelo
ADD CONSTRAINT FK_Modelo_TipoMotor
FOREIGN KEY (ID_TIPO_MOTOR) REFERENCES UNIX.TipoMotor(ID_TIPO_MOTOR);

ALTER TABLE UNIX.Modelo
ADD CONSTRAINT FK_Modelo_TipoTransmision
FOREIGN KEY (ID_TIPO_TRANSMISION) REFERENCES UNIX.TipoTransmision(ID_TIPO_TRANSMISION);

ALTER TABLE UNIX.Modelo
ADD CONSTRAINT FK_Modelo_TipoAuto
FOREIGN KEY (ID_TIPO_AUTO) REFERENCES UNIX.TipoAuto(ID_TIPO_AUTO);

--Tabla Item

ALTER TABLE UNIX.Item
ADD CONSTRAINT FK_Item_Factura
FOREIGN KEY (ID_FACTURA) REFERENCES UNIX.Factura(ID_FACTURA);

ALTER TABLE UNIX.Item
ADD CONSTRAINT FK_Item_Autop
FOREIGN KEY (ID_AUTO_PARTE) REFERENCES UNIX.Autoparte(ID_AUTO_PARTE);

--Tabla Factura

ALTER TABLE UNIX.Factura
ADD CONSTRAINT FK_Factura_Cliente
FOREIGN KEY (ID_CLIENTE) REFERENCES UNIX.Cliente(ID_CLIENTE);

ALTER TABLE UNIX.Factura
ADD CONSTRAINT FK_Factura_Compra
FOREIGN KEY (ID_COMPRA) REFERENCES UNIX.Compra(ID_COMPRA);

ALTER TABLE UNIX.Factura
ADD CONSTRAINT FK_Factura_Automovil
FOREIGN KEY (ID_AUTOMOVIL) REFERENCES UNIX.Automovil(ID_AUTOMOVIL);

ALTER TABLE UNIX.Factura
ADD CONSTRAINT FK_Factura_Sucursal
FOREIGN KEY (ID_SUCURSAL) REFERENCES UNIX.Sucursal(ID_SUCURSAL);


--------------------------------------------------------------------------
----------CREACION DE STORED PROCEDURES PARA MIGRACI�N-------------------


INSERT INTO UNIX.TipoMotor
SELECT DISTINCT TIPO_MOTOR_CODIGO
FROM gd_esquema.Maestra;

INSERT INTO UNIX.TipoCaja
SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
FROM gd_esquema.Maestra;

INSERT INTO UNIX.TipoAuto
SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
FROM gd_esquema.Maestra;

INSERT INTO UNIX.TipoTransmision
SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
FROM gd_esquema.Maestra;



IF(OBJECT_ID('UNIX.Migrador_Fabricante') IS NOT NULL)
	DROP PROCEDURE UNIX.Migrador_Fabricante

GO
CREATE PROCEDURE UNIX.Migrador_Fabricante
AS
BEGIN
INSERT INTO UNIX.Fabricante
SELECT DISTINCT FABRICANTE_NOMBRE
FROM gd_esquema.Maestra;
END
GO

BEGIN

EXEC UNIX.Migrador_Fabricante

END
GO
