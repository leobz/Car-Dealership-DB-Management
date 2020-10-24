USE [GD2C2020]

-- CREACION DE ESQUEMA
CREATE SCHEMA UNIX;

-- CREACION DE TABLAS--

BEGIN TRANSACTION

CREATE TABLE UNIX.Cliente (
CLIENTE_CODIGO INT identity(1,1) PRIMARY KEY,
CLIENTE_APELLIDO nvarchar(255),
CLIENTE_NOMBRE nvarchar(255),
CLIENTE_DIRECCION nvarchar(255),
CLIENTE_DNI decimal(18,0),
CLIENTE_FECHA_NAC datetime2(3),
CLIENTE_MAIL nvarchar(255)
);


CREATE TABLE UNIX.Compra(
COMPRA_NRO decimal(18,0) PRIMARY KEY,
CLIENTE_CODIGO INT NOT NULL,
SUCURSAL_CODIGO INT NOT NULL,
COMPRA_FECHA datetime2(3),
TIPO_COMPRA char(2),
PRECIO_TOTAL decimal(18,2)
);


CREATE TABLE UNIX.CompraPorAutoparte(
COMPRA_NRO DECIMAL(18,0) ,
AUTO_PARTE_CODIGO DECIMAL(18,0),
COMPRA_CANT decimal(18,0),
COMPRA_PRECIO DECIMAL(18,2),
PRIMARY KEY (COMPRA_NRO, AUTO_PARTE_CODIGO)
);


CREATE TABLE UNIX.CompraAutomovil(
COMPRA_NRO DECIMAL(18,0),
AUTOMOVIL_CODIGO INT,
COMPRA_PRECIO DECIMAL(18,2)
PRIMARY KEY(COMPRA_NRO,AUTOMOVIL_CODIGO)
);

CREATE TABLE UNIX.Autoparte(
AUTO_PARTE_CODIGO DECIMAL(18,0) PRIMARY KEY NOT NULL,
AUTO_PARTE_DESCRIPCION nvarchar(255),
FABRICANTE_CODIGO INT NOT NULL,
MODELO_CODIGO DECIMAL(18,0) NOT NULL,
CATEGORIA_RUBRO varchar(255),
AUTO_PARTE_PRECIO decimal(18,2));


CREATE TABLE UNIX.Automovil(
AUTOMOVIL_CODIGO INT identity(1,1) PRIMARY KEY,
MODELO_CODIGO DECIMAL(18,0) NOT NULL,
AUTO_CANT_KMS decimal(18,0) NULL,
AUTO_NRO_CHASIS nvarchar(50) NULL,
AUTO_FECHA_ALTA datetime2(3) NULL,
AUTO_NRO_MOTOR nvarchar(50) NULL,
AUTO_PATENTE nvarchar(50) NULL,
SUCURSAL_CODIGO INT NOT NULL
);


CREATE TABLE UNIX.Fabricante(
FABRICANTE_CODIGO INT identity(1,1) PRIMARY KEY,
FABRICANTE_NOMBRE nvarchar(255)
);


CREATE TABLE UNIX.Sucursal(
SUCURSAL_CODIGO INT identity(1,1) PRIMARY KEY,
SUCURSAL_DIRECCION nvarchar(255),
SUCURSAL_MAIL nvarchar(255),
SUCURSAL_TELEFONO decimal(18,0),
SUCURSAL_CIUDAD nvarchar(255)
);


CREATE TABLE UNIX.Modelo(
MODELO_CODIGO DECIMAL(18,0) PRIMARY KEY,
MODELO_NOMBRE nvarchar(255),
MODELO_POTENCIA nvarchar(255),
TIPO_AUTO_CODIGO decimal(18,0) NOT NULL,
TIPO_MOTOR_CODIGO decimal(18,0) NOT NULL,
TIPO_CAJA_CODIGO decimal(18,0) NOT NULL,
TIPO_TRANSMISION_CODIGO decimal(18,0) NOT NULL,
FABRICANTE_CODIGO INT NOT NULL
);


CREATE TABLE UNIX.TipoAuto(
TIPO_AUTO_CODIGO decimal(18,0) PRIMARY KEY,
TIPO_AUTO_DESC nvarchar(255)
);


CREATE TABLE UNIX.TipoTransmision(
TIPO_TRANSMISION_CODIGO decimal(18,0) PRIMARY KEY,
TIPO_TRANSMISION_DESC nvarchar(255) NULL
);


CREATE TABLE UNIX.TipoCaja(
TIPO_CAJA_CODIGO decimal(18,0) PRIMARY KEY,
TIPO_CAJA_DESC nvarchar(255)
);


CREATE TABLE UNIX.TipoMotor(
TIPO_MOTOR_CODIGO decimal(18,0) PRIMARY KEY
);


CREATE TABLE UNIX.Factura(
FACTURA_NRO DECIMAL(18,0) PRIMARY KEY,
FACTURA_FECHA datetime2(3),
PRECIO_TOTAL DECIMAL(18,2),
SUCURSAL_CODIGO INT NOT NULL,
TIPO_PRODUCTO nvarchar(255),
CLIENTE_CODIGO INT NOT NULL,
COMPRA_NRO DECIMAL(18,0) NOT NULL
);


CREATE TABLE UNIX.ItemAutoparte(
FACTURA_NRO DECIMAL(18,0) ,
AUTO_PARTE_CODIGO DECIMAL(18,0),
CANT_FACTURADA decimal(18,0) NULL,
PRECIO_FACTURADO DECIMAL(18,2),
PRIMARY KEY (FACTURA_NRO, AUTO_PARTE_CODIGO)
);


CREATE TABLE UNIX.ItemAutomovil(
FACTURA_NRO DECIMAL(18,0),
AUTOMOVIL_CODIGO INT,
PRECIO_FACTURADO DECIMAL(18,2),
PRIMARY KEY(FACTURA_NRO, AUTOMOVIL_CODIGO)
);

COMMIT
