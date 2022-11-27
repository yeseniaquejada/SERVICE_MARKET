/*CREACION DE LA BASE DE DATOS DEL PROYECTO*/
CREATE DATABASE SERVICE_MARKET
USE SERVICE_MARKET

-----------------------------------------------------------------------------------------------------------------------
/*CREACION DE LA TABLA ROLES*/
CREATE TABLE ROLES(
ID_ROL INT IDENTITY(1,1) PRIMARY KEY,
NOMBRE_ROL VARCHAR(40) NOT NULL)

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA ROLES*/
CREATE PROCEDURE CREAR_ROLES(
@NOMBRE_ROL VARCHAR(40))
AS
BEGIN
	INSERT INTO ROLES(NOMBRE_ROL) VALUES (@NOMBRE_ROL)
END

EXEC CREAR_ROLES 'Administrador'
EXEC CREAR_ROLES 'Pestador_servicios'
EXEC CREAR_ROLES 'Cliente'

/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA ROLES */
CREATE PROCEDURE LEER_ROLES
AS
BEGIN
	SELECT * FROM ROLES 
END

EXEC LEER_ROLES

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA ROLES */
CREATE PROCEDURE ACTUALIZAR_ROLES(
@ID_ROL INT,
@NOMBRE_ROL VARCHAR(40))
AS
BEGIN
	UPDATE ROLES SET NOMBRE_ROL = @NOMBRE_ROL WHERE ID_ROL = @ID_ROL
END

EXEC ACTUALIZAR_ROLES 2,'Prestador de servicios'

/*PROCEDIMIENTO ALMACENADO PARA BORRAR REGISTROS DE LA TABLA ROLES */
CREATE PROCEDURE BORRAR_ROLES(
@ID_ROL INT)
AS
BEGIN
	DELETE FROM ROLES WHERE ID_ROL = @ID_ROL
END

EXEC BORRAR_ROLES 3

/*CREACION DE DISPARADOR QUE PERMITA INSERTAR UNA ROL SIEMPRE Y CUANDO EL NOMBRE SEA UNICO*/
CREATE TRIGGER TR_ROLES_INSERTAR
ON ROLES
FOR INSERT
AS
	IF (SELECT COUNT (*) FROM INSERTED, ROLES WHERE INSERTED.NOMBRE_ROL = ROLES.NOMBRE_ROL) > 1
	BEGIN
	ROLLBACK TRANSACTION
	PRINT 'EL TIPO DE ROL SE ENCUENTRA REGISTRADO'
END
	ELSE
	PRINT 'EL TIPO DE ROL FUE INGRESADO EN LA BASE DE DATOS'
GO

EXEC CREAR_ROLES 'Administrador'

/*VISTA TABLA ROLES*/
CREATE VIEW ROLES_V
AS
SELECT ID_ROL,NOMBRE_ROL FROM ROLES 

/*CRUD VISTA*/
SELECT * FROM ROLES_V
INSERT INTO ROLES_V(NOMBRE_ROL) VALUES ('NUEVO ROL')
UPDATE ROLES_V SET NOMBRE_ROL = 'Nuevo rol' WHERE ID_ROL = 4
DELETE FROM ROLES_V WHERE ID_ROL = 4

/*REINICIAR CONTADOR DEL ID*/
DBCC CHECKIDENT (ROLES, RESEED, 0)
-----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LA TABLA CIUDAD*/
CREATE TABLE CIUDAD(
ID_CIUDAD INT PRIMARY KEY IDENTITY(1,1),
NOMBRE_CIUDAD VARCHAR(50) NOT NULL)

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA CIUDAD*/
CREATE PROCEDURE CREAR_CIUDAD(
@NOMBRE_CIUDAD VARCHAR(50))
AS
BEGIN
	INSERT INTO CIUDAD(NOMBRE_CIUDAD) VALUES (@NOMBRE_CIUDAD)
END

EXEC CREAR_CIUDAD 'Medellin'
EXEC CREAR_CIUDAD 'Caldas'
EXEC CREAR_CIUDAD 'Barbosa'
EXEC CREAR_CIUDAD 'Sabaneta'
EXEC CREAR_CIUDAD 'La estrella'
EXEC CREAR_CIUDAD 'Itagui'
EXEC CREAR_CIUDAD 'Envigado'
EXEC CREAR_CIUDAD 'Bello'
EXEC CREAR_CIUDAD 'Girardota'
EXEC CREAR_CIUDAD 'Copacabana'

/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA CIUDAD */
CREATE PROCEDURE LEER_CIUDAD
AS
BEGIN
	SELECT * FROM CIUDAD 
END

EXEC LEER_CIUDAD

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA CIUDAD */
CREATE PROCEDURE ACTUALIZAR_CIUDAD(
@ID_CIUDAD INT,
@NOMBRE_CIUDAD VARCHAR(50))
AS
BEGIN
	UPDATE CIUDAD SET NOMBRE_CIUDAD = @NOMBRE_CIUDAD WHERE ID_CIUDAD = @ID_CIUDAD
END

EXEC ACTUALIZAR_CIUDAD 10,'Copacabana'

/*PROCEDIMIENTO ALMACENADO PARA BORRAR REGISTROS DE LA TABLA CIUDAD */
CREATE PROCEDURE BORRAR_CIUDAD(
@ID_CIUDAD INT)
AS
BEGIN
	DELETE FROM CIUDAD WHERE ID_CIUDAD = @ID_CIUDAD
END

EXEC BORRAR_CIUDAD 10

/*CREACION DE DISPARADOR QUE PERMITA INSERTAR UNA CIUDAD SIEMPRE Y CUANDO EL NOMBRE SEA UNICO*/
CREATE TRIGGER TR_CIUDAD_INSERTAR
ON CIUDAD
FOR INSERT
AS
	IF (SELECT COUNT (*) FROM INSERTED, CIUDAD WHERE INSERTED.NOMBRE_CIUDAD = CIUDAD.NOMBRE_CIUDAD) > 1
	BEGIN
	ROLLBACK TRANSACTION
	PRINT 'LA CIUDAD SE ENCUENTRA REGISTRADA'
END
	ELSE
	PRINT 'LA CIUDAD FUE INGRESADA EN LA BASE DE DATOS'
GO

EXEC CREAR_CIUDAD 'Medellin'

/*VISTA TABLA CIUDAD*/
CREATE VIEW CIUDAD_V
AS
SELECT ID_CIUDAD,NOMBRE_CIUDAD FROM CIUDAD 

/*CRUD VISTA*/
SELECT * FROM CIUDAD_V
INSERT INTO CIUDAD_V(NOMBRE_CIUDAD) VALUES ('GUATAPE')
UPDATE CIUDAD_V SET NOMBRE_CIUDAD = 'Guatape' WHERE ID_CIUDAD = 11
DELETE FROM CIUDAD_V WHERE ID_CIUDAD = 11

/*REINICIAR CONTADOR DEL ID*/
DBCC CHECKIDENT (CIUDAD, RESEED, 0)
-----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LA TABLA USUARIOS*/
CREATE TABLE USUARIOS(
N_IDENTIFICACION VARCHAR(15) PRIMARY KEY,
TIPO_DOC VARCHAR(40) NOT NULL,
FECHA_NACIMIENTO DATE NOT NULL,
FECHA_EXPEDICION DATE NOT NULL,
NOMBRE_USU VARCHAR(60) NOT NULL,
APELLIDOS_USU VARCHAR(70) NOT NULL,
CELULAR_USU VARCHAR(20) NOT NULL,
CORREO_ELECTRONICO VARCHAR(100) NOT NULL,
CONTRASENA VARCHAR(500) NOT NULL,
GENERO VARCHAR(80) NOT NULL,
ID_CIUDAD_FK INT REFERENCES CIUDAD(ID_CIUDAD),
DIRECCION VARCHAR(200) NOT NULL
)

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA USUARIOS*/
CREATE PROCEDURE REGISTRAR_USUARIO(
@TIPO_DOC VARCHAR(40),
@N_IDENTIFICACION VARCHAR(15),
@FECHA_NACIMIENTO DATE,
@FECHA_EXPEDICION DATE,
@NOMBRE_USU VARCHAR(60),
@APELLIDOS_USU VARCHAR(70),
@CELULAR_USU VARCHAR(20),
@GENERO VARCHAR(80),
@ID_CIUDAD_FK INT,
@DIRECCION VARCHAR(200),
@CORREO_ELECTRONICO VARCHAR(100),
@CONTRASENA VARCHAR(500),
@REGISTRADO BIT OUTPUT,
@MENSAJE VARCHAR(100) OUTPUT)
AS 
BEGIN
	IF(NOT EXISTS(SELECT * FROM USUARIOS WHERE CORREO_ELECTRONICO = @CORREO_ELECTRONICO))
	BEGIN 
		INSERT INTO USUARIOS(N_IDENTIFICACION,TIPO_DOC,FECHA_NACIMIENTO,FECHA_EXPEDICION,NOMBRE_USU,APELLIDOS_USU,CELULAR_USU,CORREO_ELECTRONICO,CONTRASENA,GENERO,ID_CIUDAD_FK,DIRECCION)
		VALUES (@N_IDENTIFICACION,@TIPO_DOC,@FECHA_NACIMIENTO,@FECHA_EXPEDICION,@NOMBRE_USU,@APELLIDOS_USU,@CELULAR_USU,@CORREO_ELECTRONICO,@CONTRASENA,@GENERO,@ID_CIUDAD_FK,@DIRECCION)
		SET @REGISTRADO = 1
		SET @MENSAJE = 'Usuario registrado'
	END
	ELSE
	BEGIN
		SET @REGISTRADO = 0
		SET @MENSAJE = 'Correo ya existe'
	END
END

/*DECLARAR VARIABLES DE SALIDA*/
DECLARE @REGISTRADO BIT, @MENSAJE VARCHAR(100)
/*REGISTRO DE ADMINISTRADORES*/
EXEC REGISTRAR_USUARIO 'Cedula de ciudadania','1001228354','2003-06-28','2022-01-01','Valentina','Zapata Florez','573196998087','Femenino',1,'Calle 45 #90-10','valentina@gmail.com','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',@REGISTRADO OUTPUT,@MENSAJE OUTPUT
EXEC REGISTRAR_USUARIO 'Cedula de ciudadania','1013376602','2004-01-13','2022-01-14','Yesenia','Quejada Rojas','573135293264','Femenino',8,'Calle 22 carrera 61 AA 51','yeyerojas1308@gmail.com','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',@REGISTRADO OUTPUT,@MENSAJE OUTPUT


/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA USUARIOS */
CREATE PROCEDURE LEER_USUARIOS
AS
BEGIN
	SELECT * FROM USUARIOS
END 

EXEC LEER_USUARIOS

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA USUARIOS */
CREATE PROCEDURE ACTUALIZAR_USUARIOS(
@TIPO_DOC VARCHAR(40),
@N_IDENTIFICACION VARCHAR(15),
@FECHA_NACIMIENTO DATE,
@FECHA_EXPEDICION DATE,
@NOMBRE_USU VARCHAR(60),
@APELLIDOS_USU VARCHAR(70),
@CELULAR_USU VARCHAR(20),
@GENERO VARCHAR(80),
@ID_CIUDAD_FK INT,
@DIRECCION VARCHAR(200),
@CORREO_ELECTRONICO VARCHAR(100),
@CONTRASENA VARCHAR(500))
AS
BEGIN
	UPDATE USUARIOS SET 
	TIPO_DOC = @TIPO_DOC, FECHA_NACIMIENTO = @FECHA_NACIMIENTO, FECHA_EXPEDICION = @FECHA_EXPEDICION, NOMBRE_USU = @NOMBRE_USU, APELLIDOS_USU = @APELLIDOS_USU, CELULAR_USU = @CELULAR_USU, GENERO = @GENERO, ID_CIUDAD_FK = @ID_CIUDAD_FK, DIRECCION = @DIRECCION, CORREO_ELECTRONICO = @CORREO_ELECTRONICO, CONTRASENA = @CONTRASENA
	WHERE N_IDENTIFICACION = @N_IDENTIFICACION
END

EXEC ACTUALIZAR_USUARIOS 'Cedula de ciudadania','1013376602','2004-01-13','2022-01-14','Yesenia','Quejada Rojas','573135293264','Femenino',8,'Calle 22 carrera 61 AA 51','yeyerojas1308@gmail.com','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'

/*PROCEDIMIENTO ALMACENADO PARA BORRAR REGISTROS DE LA TABLA USUARIOS */
CREATE PROCEDURE BORRAR_USUARIOS(
@N_IDENTIFICACION VARCHAR(15))
AS
BEGIN
	DELETE FROM USUARIOS WHERE N_IDENTIFICACION = @N_IDENTIFICACION
END

EXEC BORRAR_USUARIOS '31793795'

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

EXEC VALIDAR_USUARIO 'yeyerojas1308@gmail.com','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'

/*CREACION DE DISPARADOR QUE BLOQUEE ACTUALIZAR EL NUMERO DE DOCUMENTO DE UN USUARIO*/
CREATE TRIGGER TR_USUARIOS_ACTUALIZAR
ON USUARIOS
FOR UPDATE
AS
IF UPDATE(N_IDENTIFICACION)
BEGIN
PRINT 'NO SE PUEDE ACTUALIZAR EL NUMERO DE IDENTIFICACION DE UN USUARIO'
ROLLBACK TRANSACTION
END

/*VISTA TABLA USUARIOS*/
CREATE VIEW USUARIOS_V
AS
SELECT N_IDENTIFICACION,TIPO_DOC,FECHA_NACIMIENTO,FECHA_EXPEDICION,NOMBRE_USU,APELLIDOS_USU,CELULAR_USU,CORREO_ELECTRONICO, CONTRASENA, GENERO, ID_CIUDAD_FK, DIRECCION 
FROM USUARIOS 

/*CRUD VISTA*/
SELECT * FROM USUARIOS_V

INSERT INTO USUARIOS_V (N_IDENTIFICACION,TIPO_DOC,FECHA_NACIMIENTO,FECHA_EXPEDICION,NOMBRE_USU,APELLIDOS_USU,CELULAR_USU,CORREO_ELECTRONICO, CONTRASENA, GENERO, ID_CIUDAD_FK, DIRECCION) 
VALUES ('11111','CC','2022-01-01','2022-01-01','PRUEBA','PRUEBA2','1111','PRUEBA@GMAIL.COM','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','FEMENINO',1,'CALLE 1')

UPDATE USUARIOS_V SET TIPO_DOC = 'CC',FECHA_NACIMIENTO ='2022-01-01',FECHA_EXPEDICION = '2022-01-01',NOMBRE_USU = 'PRUEBA',APELLIDOS_USU = 'PRUEBA2', CELULAR_USU = '1111', CORREO_ELECTRONICO = 'PRUEBA@GMAIL.COM', CONTRASENA = 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',GENERO = 'FEMENINO',ID_CIUDAD_FK = 1, DIRECCION = 'CALLE 1' 
WHERE N_IDENTIFICACION = '22222'

DELETE FROM USUARIOS_V WHERE N_IDENTIFICACION = '11111'


-----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LA TABLA INTERMEDIA ASIGNACION_ROL*/
CREATE TABLE ASIGNACION_ROL(
ID_ROL_FK INT REFERENCES ROLES(ID_ROL) DEFAULT 3,
IDENTIFICACION_U_FK VARCHAR(15) REFERENCES USUARIOS(N_IDENTIFICACION)
)

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA ASIGNACION_ROL*/
CREATE PROCEDURE CREAR_ASIGNACION_ROL(
@IDENTIFICACION_U_FK VARCHAR(15))
AS
BEGIN
	INSERT INTO ASIGNACION_ROL(IDENTIFICACION_U_FK) VALUES (@IDENTIFICACION_U_FK)
END

EXEC CREAR_ASIGNACION_ROL '1001228354'
EXEC CREAR_ASIGNACION_ROL '1013376602'


/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA ASIGNACION_ROL */
CREATE PROCEDURE LEER_ASIGNACION_ROL
AS
BEGIN
	SELECT * FROM ASIGNACION_ROL
END

EXEC LEER_ASIGNACION_ROL

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA ASIGNACION_ROL*/
CREATE PROCEDURE ACTUALIZAR_ASIGNACION_ROL(
@ID_ROL_FK INT,
@IDENTIFICACION_U_FK VARCHAR(15))
AS
BEGIN
	UPDATE ASIGNACION_ROL SET ID_ROL_FK = @ID_ROL_FK WHERE IDENTIFICACION_U_FK = @IDENTIFICACION_U_FK
END

EXEC ACTUALIZAR_ASIGNACION_ROL 1, '1013376602'

/*CREACION DE DISPARADOR QUE IMPIDA ASIGNARLE UN ROL DUPLICADO AL NUMERO DE DOCUMENTO DE UN USUARIO*/
CREATE TRIGGER TX_ASIGNACION_ROL_B
ON ASIGNACION_ROL
FOR INSERT
AS
IF (SELECT COUNT (*) FROM INSERTED, ASIGNACION_ROL
WHERE INSERTED.IDENTIFICACION_U_FK = ASIGNACION_ROL.IDENTIFICACION_U_FK) >1
BEGIN
ROLLBACK TRANSACTION
PRINT 'EL NUMERO DE DOCUMENTO YA SE ENCUENTRA REGISTRADO'
END
ELSE
PRINT 'LA ASIGNACION DE ROL DEL DOCUMENTO FUE INGRESADA A LA BASE DE DATOS'
GO

/*VISTA TABLA ROLES*/
CREATE VIEW ASIGNACION_ROL_V
AS
SELECT ID_ROL_FK, IDENTIFICACION_U_FK FROM ASIGNACION_ROL

/*CRUD VISTA*/
SELECT * FROM ASIGNACION_ROL_V
INSERT INTO ASIGNACION_ROL_V(IDENTIFICACION_U_FK,ID_ROL_FK) VALUES ('1001228354',2)
UPDATE ASIGNACION_ROL_V SET ID_ROL_FK = 1 WHERE IDENTIFICACION_U_FK = '1001228354'
DELETE FROM ASIGNACION_ROL_V WHERE IDENTIFICACION_U_FK = '1001228354'

-----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LA TABLA CATEGORIAS*/
CREATE TABLE CATEGORIAS(
ID_CATEGORIA INT IDENTITY(1,1) PRIMARY KEY,
NOMBRE_CAT VARCHAR(MAX) NOT NULL,
DESCRIPCION_CAT VARCHAR(MAX) NOT NULL)

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA CATEGORIAS*/
CREATE PROCEDURE CREAR_CATEGORIAS(
@NOMBRE_CAT VARCHAR(MAX),
@DESCRIPCION_CAT VARCHAR(MAX))
AS
BEGIN
	INSERT INTO CATEGORIAS(NOMBRE_CAT,DESCRIPCION_CAT) VALUES (@NOMBRE_CAT,@DESCRIPCION_CAT)
END

EXEC CREAR_CATEGORIAS 'Mantenimiento', 'Orientada a solucionar y prevenir las posibles aver�as que pueda haber en equipos, m�quinas e instalaciones para conservar y garantizar su �ptimo funcionamiento.'
EXEC CREAR_CATEGORIAS 'Trabajos dom�sticos', 'Toda la ayuda dom�stica que necesitas en casa con expertas en orden, limpieza y desinfecci�n.'
EXEC CREAR_CATEGORIAS 'Remodelaci�n y aba�iler�a', 'Orientada en la construcci�n, renovaci�n y reparaci�n de estructuras, paredes, muros, partes de edificios, casas y m�s.'
EXEC CREAR_CATEGORIAS 'Salud y belleza', 'Orientada a la prestaci�n de servicios desde los diferentes campos de la salud y la belleza como lo son cortes, peinados, maquillajes, manicure, pedicura, masajes, etc.'

/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA CATEGORIAS */
CREATE PROCEDURE LEER_CATEGORIAS
AS
BEGIN
	SELECT * FROM CATEGORIAS 
END

EXEC LEER_CATEGORIAS

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA CATEGORIAS */
CREATE PROCEDURE ACTUALIZAR_CATEGORIAS(
@ID_CATEGORIA INT,
@NOMBRE_CAT VARCHAR(MAX),
@DESCRIPCION_CAT VARCHAR(MAX))
AS
BEGIN
	UPDATE CATEGORIAS SET NOMBRE_CAT = @NOMBRE_CAT, DESCRIPCION_CAT = @DESCRIPCION_CAT WHERE ID_CATEGORIA = @ID_CATEGORIA
END

EXEC ACTUALIZAR_CATEGORIAS 2, 'Tabajos dom�sticos', 'Toda la ayuda dom�stica que necesitas en casa con expertas en orden, limpieza y desinfecci�n.'

/*PROCEDIMIENTO ALMACENADO PARA BORRAR REGISTROS DE LA TABLA CATEGORIAS */
CREATE PROCEDURE BORRAR_CATEGORIAS(
@ID_CATEGORIA INT)
AS
BEGIN
	DELETE FROM CATEGORIAS WHERE ID_CATEGORIA = @ID_CATEGORIA
END

EXEC BORRAR_CATEGORIAS 2

/*CREACION DE DISPARADOR QUE PERMITA INSERTAR UNA CATEGORIA SIEMPRE Y CUANDO EL NOMBRE SEA UNICO*/
CREATE TRIGGER TR_CATEGORIAS_INSERTAR
ON CATEGORIAS
FOR INSERT
AS
IF (SELECT COUNT (*) FROM INSERTED, CATEGORIAS
WHERE INSERTED.NOMBRE_CAT = CATEGORIAS.NOMBRE_CAT) > 1
BEGIN
ROLLBACK TRANSACTION
PRINT 'LA CATEGORIA SE ENCUENTRA REGISTRADA'
END
ELSE
PRINT 'LA CATEGORIA FUE INGRESADA EN LA BASE DE DATOS'
GO

EXEC CREAR_CATEGORIAS 'Mantenimiento', 'Orientada a solucionar y prevenir las posibles aver�as que pueda haber en equipos, m�quinas e instalaciones para conservar y garantizar su �ptimo funcionamiento.'

/*VISTA TABLA CATEGORIAS*/
CREATE VIEW CATEGORIAS_V
AS
SELECT ID_CATEGORIA, NOMBRE_CAT, DESCRIPCION_CAT FROM CATEGORIAS

/*CRUD VISTA*/
SELECT * FROM CATEGORIAS_V
INSERT INTO CATEGORIAS_V(NOMBRE_CAT,DESCRIPCION_CAT) VALUES ('Mascotas','Todo el cuidado que necesitas para tus mascotas lo encuentras aqu�.')
UPDATE CATEGORIAS_V SET NOMBRE_CAT = 'Veterinaria' WHERE ID_CATEGORIA = 5
DELETE FROM CATEGORIAS_V WHERE ID_CATEGORIA = 5

/*REINICIAR CONTADOR DEL ID*/
DBCC CHECKIDENT (CATEGORIAS, RESEED, 0)
-----------------------------------------------------------------------------------------------------------------------
 
/*CREACION DE LA TABLA SERVICIOS*/
CREATE TABLE SERVICIOS(
ID_SERVICIO INT IDENTITY(1,1) PRIMARY KEY,
NOMBRE_SER VARCHAR(70) NOT NULL,
PRECIO_SER DECIMAL NOT NULL,
DESCRIPCION_BREVE VARCHAR(500) NOT NULL,
TERMINOS_SER VARCHAR(MAX) NOT NULL,
ID_CATEGORIA_FK INT REFERENCES CATEGORIAS(ID_CATEGORIA)
)

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA SERVICIOS*/
CREATE PROCEDURE CREAR_SERVICIOS(
@NOMBRE_SER VARCHAR(70),
@PRECIO_SER DECIMAL,
@DESCRIPCION_BREVE VARCHAR(500),
@TERMINOS_SER VARCHAR(MAX),
@ID_CATEGORIA_FK INT
)
AS 
BEGIN
	INSERT INTO SERVICIOS(NOMBRE_SER,PRECIO_SER,DESCRIPCION_BREVE,TERMINOS_SER,ID_CATEGORIA_FK) 
	VALUES (@NOMBRE_SER,@PRECIO_SER,@DESCRIPCION_BREVE,@TERMINOS_SER,@ID_CATEGORIA_FK)
END

EXEC CREAR_SERVICIOS 'Depilaci�n de cejas con cera',24000,'Cuidado de tus cejas y la forma natural que ya tienen, para depilarlas se usa cera tipo miel caliente en la zona.',
'Previamente indicar si sufre alg�n tipo de alergia a picaduras de abejas y/o intolerancia a la miel, ya que el producto de depilaci�n contiene estos derivados.',4

/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA SERVICIOS */
CREATE PROCEDURE LEER_SERVICIOS
AS
BEGIN
	SELECT * FROM SERVICIOS 
END

EXEC LEER_SERVICIOS

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA SERVICIOS */
CREATE PROCEDURE ACTUALIZAR_SERVICIOS(
@ID_SERVICIO INT,
@NOMBRE_SER VARCHAR(70),
@PRECIO_SER DECIMAL,
@DESCRIPCION_BREVE VARCHAR(500),
@TERMINOS_SER VARCHAR(MAX),
@ID_CATEGORIA_FK INT
)
AS
BEGIN
	UPDATE SERVICIOS SET NOMBRE_SER = @NOMBRE_SER, PRECIO_SER = @PRECIO_SER, DESCRIPCION_BREVE = @DESCRIPCION_BREVE, TERMINOS_SER = @TERMINOS_SER, ID_CATEGORIA_FK = @ID_CATEGORIA_FK 
	WHERE ID_SERVICIO = @ID_SERVICIO
END

/*PROCEDIMIENTO ALMACENADO PARA BORRAR REGISTROS DE LA TABLA SERVICIOS */
CREATE PROCEDURE BORRAR_SERVICIOS(
@ID_SERVICIO INT)
AS
BEGIN
	DELETE FROM SERVICIOS WHERE ID_SERVICIO = @ID_SERVICIO
END

EXEC BORRAR_SERVICIOS 4

/*PROCEDIMIENTO ALMACENADO PARA CONSULTAR SERVICIOS INNER JOIN CON TABLA CATEGORIAS*/
CREATE PROCEDURE CONSULTAR_SERVICIOS
AS 
BEGIN
	SELECT ID_SERVICIO, NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE, NOMBRE_CAT 
	FROM SERVICIOS INNER JOIN CATEGORIAS 
	ON SERVICIOS.ID_CATEGORIA_FK = CATEGORIAS.ID_CATEGORIA
END

EXEC CONSULTAR_SERVICIOS

/*PROCEDIMIENTO ALMACENADO PARA CATEGORIZAR LOS SERVICIOS */
CREATE PROCEDURE SERVICIOS_CATEGORIAS
(@ID_CATEGORIA INT)
AS
BEGIN
	SELECT ID_SERVICIO, NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE, NOMBRE_CAT 
	FROM SERVICIOS INNER JOIN CATEGORIAS 
	ON SERVICIOS.ID_CATEGORIA_FK = CATEGORIAS.ID_CATEGORIA WHERE ID_CATEGORIA = @ID_CATEGORIA
END

EXEC SERVICIOS_CATEGORIAS 4

/*PROCEDIMIENTO ALMACENADO PARA BUSCAR SERVICIOS POR NOMBRE*/
CREATE PROCEDURE BUSQUEDAD_SERVICIOS(
@NOMBRE_SER VARCHAR(70))
AS
BEGIN
	SELECT ID_SERVICIO, NOMBRE_SER, PRECIO_SER,DESCRIPCION_BREVE, NOMBRE_CAT 
	FROM SERVICIOS INNER JOIN CATEGORIAS 
	ON SERVICIOS.ID_CATEGORIA_FK = CATEGORIAS.ID_CATEGORIA
	WHERE NOMBRE_SER LIKE '%'+@NOMBRE_SER+'%'
END

EXEC BUSQUEDAD_SERVICIOS 'Limpieza'

/*VISTA TABLA SERVICIOS*/
CREATE VIEW SERVICIOS_V
AS
SELECT ID_SERVICIO,NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE,TERMINOS_SER, ID_CATEGORIA_FK 
FROM SERVICIOS

/*CRUD VISTA*/
SELECT * FROM SERVICIOS_V
INSERT INTO SERVICIOS_V(NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE,TERMINOS_SER, ID_CATEGORIA_FK) VALUES ('Limpieza de casas',90000,'Solo se realiza aseo en areas comunes', 'No se plancha, ni cocina, no se cuidan adultos mayores.',2)
UPDATE SERVICIOS_V SET PRECIO_SER =  120000 WHERE ID_SERVICIO = 2
DELETE FROM SERVICIOS_V WHERE ID_SERVICIO = 2

/*REINICIAR CONTADOR DEL ID*/
DBCC CHECKIDENT (SERVICIOS, RESEED, 0)

-----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LA TABLA DETALLE_SERVICIOS(PUBLICACION)*/
CREATE TABLE DETALLE_SERVICIOS(
ID_SERVICIO_FK INT REFERENCES SERVICIOS(ID_SERVICIO),
IDENTIFICACION_U_FK VARCHAR(15) REFERENCES USUARIOS(N_IDENTIFICACION),
FECHA_INICIO DATE NOT NULL DEFAULT GETDATE(),
ESTADO_DS VARCHAR(20) DEFAULT 'Activo')

/*PROCEDIMIENTO ALMACENADO PARA CREAR REGISTROS DE LA TABLA DETALLE_SERVICIOS*/
CREATE PROCEDURE CREAR_DETALLE_SERVICIOS(
@ID_SERVICIO_FK INT,
@IDENTIFICACION_U_FK VARCHAR(15))
AS
BEGIN
	INSERT INTO DETALLE_SERVICIOS(ID_SERVICIO_FK,IDENTIFICACION_U_FK) 
	VALUES (@ID_SERVICIO_FK,@IDENTIFICACION_U_FK)
END

EXEC CREAR_DETALLE_SERVICIOS 1, 1013376602

/*PROCEDIMIENTO ALMACENADO PARA LEER REGISTROS DE LA TABLA DETALLE_SERVICIOS */
CREATE PROCEDURE LEER_DETALLE_SERVICIOS
AS
BEGIN
	SELECT * FROM DETALLE_SERVICIOS
END

EXEC LEER_DETALLE_SERVICIOS

/*PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR REGISTROS DE LA TABLA DETALLE_SERVICIOS */
CREATE PROCEDURE ACTUALIZAR_DETALLE_SERVICIOS(
@ID_SERVICIO_FK INT,
@FECHA_INICIO DATE,
@ESTADO_DS VARCHAR(20))
AS
BEGIN
	UPDATE DETALLE_SERVICIOS SET FECHA_INICIO = @FECHA_INICIO, ESTADO_DS = @ESTADO_DS 
	WHERE ID_SERVICIO_FK = @ID_SERVICIO_FK
END

EXEC ACTUALIZAR_DETALLE_SERVICIOS 1,'2022-11-20', 'Activo'
EXEC ACTUALIZAR_DETALLE_SERVICIOS 2,'2022-11-20', 'Desactivo'

/*CREACION DE DISPARADOR QUE LIMITE QUE UNA PUBLICACION SEA REALIZADA POR MAS DE UN USUARIO*/
CREATE TRIGGER TX_DETALLE_SERVICIOS_B
ON DETALLE_SERVICIOS
FOR INSERT
AS
IF (SELECT COUNT (*) FROM INSERTED, DETALLE_SERVICIOS
WHERE INSERTED.ID_SERVICIO_FK = DETALLE_SERVICIOS.ID_SERVICIO_FK) >1
BEGIN
ROLLBACK TRANSACTION
PRINT 'LA PUBLICACION YA FUE REALIZADA POR UN USUARIO'
END
ELSE
PRINT 'LA PUBLICACION FUE INGRESADA A LA BASE DE DATOS'
GO

/*VISTA TABLA SERVICIOS*/
CREATE VIEW SERVICIOS_V
AS
SELECT ID_SERVICIO,NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE,TERMINOS_SER, ID_CATEGORIA_FK 
FROM SERVICIOS

/*CRUD VISTA*/
SELECT * FROM SERVICIOS_V
INSERT INTO SERVICIOS_V(NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE,TERMINOS_SER, ID_CATEGORIA_FK) VALUES ('Limpieza de casas',90000,'Solo se realiza aseo en areas comunes', 'No se plancha, ni cocina, no se cuidan adultos mayores.',2)
UPDATE SERVICIOS_V SET PRECIO_SER =  120000 WHERE ID_SERVICIO = 2
DELETE FROM SERVICIOS_V WHERE ID_SERVICIO = 2

/*REINICIAR CONTADOR DEL ID*/
DBCC CHECKIDENT (SERVICIOS, RESEED, 0)

----------------------------------------------------------------------------------------------------------------------

/*VISTA MAS INFORMACION SOBRE LA PUBLICACION DEL SERVICIO
TABLAS: DETALLE_SERVICIOS // SERVICIOS // CATEGORIAS // USUARIOS // CIUDAD*/
CREATE VIEW PUBLICACION_SERVICIOS 
AS
SELECT FECHA_INICIO, ESTADO_DS, ID_SERVICIO, NOMBRE_SER, PRECIO_SER, DESCRIPCION_BREVE, 
TERMINOS_SER, NOMBRE_CAT, NOMBRE_USU, APELLIDOS_USU, CELULAR_USU, CORREO_ELECTRONICO, NOMBRE_CIUDAD
FROM
DETALLE_SERVICIOS INNER JOIN SERVICIOS 
ON DETALLE_SERVICIOS.ID_SERVICIO_FK = SERVICIOS.ID_SERVICIO 
INNER JOIN CATEGORIAS 
ON SERVICIOS.ID_CATEGORIA_FK = CATEGORIAS.ID_CATEGORIA
INNER JOIN USUARIOS
ON DETALLE_SERVICIOS.IDENTIFICACION_U_FK = USUARIOS.N_IDENTIFICACION
INNER JOIN CIUDAD
ON USUARIOS.ID_CIUDAD_FK = CIUDAD.ID_CIUDAD WHERE ESTADO_DS = 'Activo'

/*PROCEDIMIENTO ALMACENADO PARA CONSULTAR VISTA PUBLICACION SERVICIOS*/
CREATE PROCEDURE CONSULTAR_PUBLICACION(
@ID_SERVICIO INT)
AS
BEGIN
	SELECT * FROM PUBLICACION_SERVICIOS WHERE ID_SERVICIO = @ID_SERVICIO
END

EXEC CONSULTAR_PUBLICACION 1 /*ACTIVO*/
EXEC CONSULTAR_PUBLICACION 2 /*DESACTIVO*/

----------------------------------------------------------------------------------------------------------------------

/*CREACION DE LA TABLA HISTORIAL DE SERVICIOS ELIMINADOS*/
CREATE TABLE [HISTORIAL_SERVICIOS](
	[ID_SERVICIO] [int] NOT NULL,
	[NOMBRE_SER] [varchar](70) NOT NULL,
	[PRECIO_SER] [decimal](18, 0) NOT NULL,
	[DESCRIPCION_BREVE] [varchar](500) NOT NULL,
	[TERMINOS_SER] [varchar](max) NOT NULL,
	[ID_CATEGORIA_FK] [int] NULL)

/*CREACION DE DISPARADOR PARA QUE AGREGUE SERVICIOS ELIMINADOS AL HISTORIAL*/
CREATE TRIGGER TR_HISTORIAL_SERVICIOS
ON SERVICIOS FOR DELETE 
AS 
BEGIN 
	INSERT INTO [HISTORIAL_SERVICIOS]
	SELECT * FROM deleted
END 
GO

/*PROCEDIMIENTO ALMACENADO PARA LEER LOS REGISTROS DE LA TABLA HISTORIAL_SERVICIOS*/
CREATE PROCEDURE LEER_HISTORIAL_SERVICIOS 
AS
BEGIN
	SELECT * FROM HISTORIAL_SERVICIOS
END

EXEC LEER_HISTORIAL_SERVICIOS 

----------------------------------------------------------------------------------------------------------------------

/*FUNCION PARA CONTAR SERVICIOS DISPONIBLES*/
CREATE FUNCTION SERVICIOS_DISPONIBLES() 
RETURNS INT
AS
BEGIN
DECLARE @DISPONIBLES INT
SELECT  @DISPONIBLES = COUNT (*) FROM SERVICIOS 
RETURN @DISPONIBLES 
END

PRINT 'SERVICIOS DISPONIBLES'
PRINT DBO.SERVICIOS_DISPONIBLES()

