USE [GD2C2020]
GO
BEGIN TRANSACTION

------------------------- CREACION DE TABLAS  -------------------------------
CREATE TABLE UNIX.BI_HechoModelo
(
    MODELO_CODIGO DECIMAL(18,0) NOT NULL,
    TIPO_CAJA_CODIGO decimal(18,0) NOT NULL,
    TIPO_MOTOR_CODIGO decimal(18,0),
    TIPO_TRANSMISION_CODIGO decimal(18,0) NOT NULL,
    TIPO_AUTO_CODIGO decimal(18,0) NOT NULL,
    FABRICANTE_CODIGO INT NOT NULL,
    POTENCIA_CODIGO INT NOT NULL,
    PROMEDIO_TIEMPO_STOCK INT,
    PRIMARY KEY(
      MODELO_CODIGO, TIPO_CAJA_CODIGO, TIPO_MOTOR_CODIGO, TIPO_TRANSMISION_CODIGO, TIPO_AUTO_CODIGO, FABRICANTE_CODIGO, POTENCIA_CODIGO
      )
);

CREATE TABLE UNIX.BI_Modelo
(
    MODELO_CODIGO DECIMAL(18,0) PRIMARY KEY,
    MODELO_NOMBRE nvarchar(255)
);

CREATE TABLE UNIX.BI_TipoCaja
(
    TIPO_CAJA_CODIGO decimal(18,0) PRIMARY KEY,
    TIPO_CAJA_DESC nvarchar(255)
);

CREATE TABLE UNIX.BI_TipoMotor
(
    TIPO_MOTOR_CODIGO decimal(18,0) PRIMARY KEY
);

CREATE TABLE UNIX.BI_Potencia(
  POTENCIA_CODIGO INT NOT NULL,
  POTENCIA NVARCHAR(255) NOT NULL,
  PRIMARY KEY(POTENCIA_CODIGO)
  )

CREATE TABLE UNIX.BI_Fabricante(
  FABRICANTE_CODIGO INT NOT NULL,
  FABRICANTE_NOMBRE NVARCHAR(255) NOT NULL,
  PRIMARY KEY(FABRICANTE_CODIGO)
  )

CREATE TABLE UNIX.BI_TipoAuto(
  TIPO_AUTO_CODIGO DECIMAL(18,0) NOT NULL,
  TIPO_AUTO_DESC NVARCHAR(255) NOT NULL,
  PRIMARY KEY(TIPO_AUTO_CODIGO)
  )

CREATE TABLE UNIX.BI_TipoTransmision(
  TIPO_TRANSMISION_CODIGO DECIMAL(18,0) NOT NULL,
  TIPO_TRANSMISION_DESC NVARCHAR(255) NOT NULL,
  PRIMARY KEY (TIPO_TRANSMISION_CODIGO)
)



--------------------------- ALTER TABLE (FOREING KEYS)  -----------------------------
ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_Modelo
FOREIGN KEY (MODELO_CODIGO) REFERENCES UNIX.BI_Modelo(MODELO_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_Fabricante
FOREIGN KEY (FABRICANTE_CODIGO) REFERENCES UNIX.BI_Fabricante(FABRICANTE_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoCaja
FOREIGN KEY (TIPO_CAJA_CODIGO) REFERENCES UNIX.BI_TipoCaja(TIPO_CAJA_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoMotor
FOREIGN KEY (TIPO_MOTOR_CODIGO) REFERENCES UNIX.BI_TipoMotor(TIPO_MOTOR_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoTransmision
FOREIGN KEY (TIPO_TRANSMISION_CODIGO) REFERENCES UNIX.BI_TipoTransmision(TIPO_TRANSMISION_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_TipoAuto
FOREIGN KEY (TIPO_AUTO_CODIGO) REFERENCES UNIX.BI_TipoAuto(TIPO_AUTO_CODIGO);

ALTER TABLE UNIX.BI_HechoModelo
ADD CONSTRAINT FK_HechoModelo_Potencia
FOREIGN KEY (POTENCIA_CODIGO) REFERENCES UNIX.BI_Potencia(POTENCIA_CODIGO);



COMMIT



