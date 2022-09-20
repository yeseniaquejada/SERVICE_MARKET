CREATE DATABASE SERVICE_MARKET
USE SERVICE_MARKET

/*CREACION DE LA TABLA ROLES*/
CREATE TABLE ROLES(
ID_ROL INT IDENTITY(1,1) PRIMARY KEY,
NOMBRE VARCHAR(40) NOT NULL)

/*CREACION DE LA TABLA USUARIOS*/
CREATE TABLE USUARIOS(
ID_USUARIO INT PRIMARY KEY IDENTITY(1,1),
IDENTIFICACION_U VARCHAR(15) NOT NULL,
TIPO_DOC VARCHAR(40) NOT NULL,
NOMBRE VARCHAR(60) NOT NULL,
APELLIDOS VARCHAR(70) NOT NULL,
CELULAR VARCHAR(12) NOT NULL,
CORREO_ELECTRONICO VARCHAR(100) NOT NULL,
CONTRASENA VARCHAR(500) NOT NULL,
FECHA_NACIMIENTO DATE NOT NULL,
ID_ROL_FK INT REFERENCES ROLES(ID_ROL))

/*PROCEDIMIENTO ALMACENADO PARA REGISTRAR USUARIOS*/
CREATE PROCEDURE REGISTRAR_USUARIO(
@IDENTIFICACION_U VARCHAR(15),
@TIPO_DOC VARCHAR(40),
@NOMBRE VARCHAR(60),
@APELLIDOS VARCHAR(70),
@CELULAR VARCHAR(12),
@CORREO_ELECTRONICO VARCHAR(100),
@CONTRASENA VARCHAR(500),
@FECHA_NACIMIENTO DATE,
@ID_ROL_FK INT,
@REGISTRADO BIT OUTPUT,
@MENSAJE VARCHAR(100) OUTPUT)
AS 
BEGIN
	IF(NOT EXISTS(SELECT * FROM USUARIOS WHERE CORREO_ELECTRONICO = @CORREO_ELECTRONICO))
	BEGIN 
		INSERT INTO USUARIOS(IDENTIFICACION_U,TIPO_DOC,NOMBRE,APELLIDOS,CELULAR,CORREO_ELECTRONICO,CONTRASENA,FECHA_NACIMIENTO,ID_ROL_FK)
		VALUES (@IDENTIFICACION_U,@TIPO_DOC,@NOMBRE,@APELLIDOS,@CELULAR,@CORREO_ELECTRONICO,@CONTRASENA,@FECHA_NACIMIENTO,@ID_ROL_FK)
		SET @REGISTRADO = 1
		SET @MENSAJE = 'Usuario registrado'
	END
	ELSE
	BEGIN
		SET @REGISTRADO = 0
		SET @MENSAJE = 'Correo ya existe'
	END
END

/*PROCEDIMIENTO ALMACENADO PARA VALIDAR USUARIOS*/
CREATE PROCEDURE VALIDAR_USUARIO(
@CORREO_ELECTRONICO VARCHAR(100),
@CONTRASENA VARCHAR(500))
AS
BEGIN
	IF(EXISTS(SELECT * FROM USUARIOS WHERE CORREO_ELECTRONICO = @CORREO_ELECTRONICO AND CONTRASENA = @CONTRASENA))
		SELECT * FROM USUARIOS WHERE CORREO_ELECTRONICO = @CORREO_ELECTRONICO AND CONTRASENA = @CONTRASENA
	ELSE
		SELECT '0'
END

/*EJEMPLO DEL PROCEDIMIENTO ALMACENADO VALIDAR_USUARIO*/
EXEC VALIDAR_USUARIO 'yeyerojas1308@gmail.com','82a79f11b4acb52a642ef7e339dfce4aa92ff65ed2e7ab702d798dbe10eca0b8'

/*INSERT TABLA ROLES*/
INSERT INTO ROLES(NOMBRE) VALUES ('ADMINISTRADOR'),('PROVEEDOR')
INSERT INTO ROLES(NOMBRE) VALUES ('CLIENTE')
SELECT * FROM ROLES 

/*DECLARAR VARIABLES DE SALIDA*/
DECLARE @REGISTRADO BIT, @MENSAJE VARCHAR(100)

/*REGISTRO DE ADMINISTRADORES*/
EXEC REGISTRAR_USUARIO'1013376602','CEDULA DE CIUDADANIA','YESENIA','QUEJADA ROJAS','3135293264','YEYEROJAS1308@GMAIL.COM','123','2004-01-13',1,@REGISTRADO OUTPUT,@MENSAJE OUTPUT

/*CREACION DE LA TABLA CATEGORIAS*/
CREATE TABLE CATEGORIAS(
ID_CATEGORIA INT IDENTITY(1,1) PRIMARY KEY,
NOMBRE VARCHAR(50) NOT NULL,
DESCRIPCION VARCHAR(40) NOT NULL)

/*CREACION DE LA TABLA SERVICIOS*/
CREATE TABLE SERVICIOS(
ID_SERVICIO INT IDENTITY(1,1) PRIMARY KEY,
IMAGEN VARBINARY(MAX) NOT NULL,
NOMBRE VARCHAR(70) NOT NULL,
PRECIO DECIMAL NOT NULL,
TERMINOS VARCHAR(MAX) NOT NULL,
ID_CATEGORIA_FK INT REFERENCES CATEGORIAS(ID_CATEGORIA))

/*CREACION DE LA TABLA DETALLE_SERVICIOS(PUBLICACION)*/
CREATE TABLE DETALLE_SERVICIOS(
ID_SERVICIO_FK INT REFERENCES SERVICIOS(ID_SERVICIO),
ID_USUARIO_FK INT REFERENCES USUARIOS(ID_USUARIO),
FECHA_INICIO DATE NOT NULL,
FECHA_FIN DATE NOT NULL)

/*CREACION DE LA TABLA FACTURAS*/
CREATE TABLE FACTURAS(
N_FACTURA INT IDENTITY(1,1) PRIMARY KEY,
FECHA DATE NOT NULL,
HORA TIME NOT NULL,
TOTAL DECIMAL NOT NULL,
ID_USUARIO_FK INT REFERENCES USUARIOS(ID_USUARIO)
)

/*CREACION DE LA TABLA DETALLE_FACTURAS*/
CREATE TABLE DETALLE_FACTURAS(
ID_SERVICIO_FK INT REFERENCES SERVICIOS(ID_SERVICIO),
N_FACTURA_FK INT REFERENCES FACTURAS(N_FACTURA),
CANTIDAD INT NOT NULL,
PRECIO DECIMAL NOT NULL,
SUBTOTAL DECIMAL NOT NULL,
COMISION DECIMAL NOT NULL,
CALIFICACION INT NOT NULL,
COMENTARIOS VARCHAR(MAX)
)

/*REINICIAR CONTADOR DEL ID*/
DBCC CHECKIDENT (USUARIOS, RESEED, 0)

SELECT * FROM USUARIOS

