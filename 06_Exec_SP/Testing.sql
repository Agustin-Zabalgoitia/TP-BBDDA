USE Com2900G06
GO 

--- Testing ABM Cobertura
/*
CREATE TABLE Paciente.Cobertura (
	id_cobertura INT IDENTITY(0,1),
	id_prestador INT NOT NULL,
	imagen_credencial NVARCHAR(90),-- (Guardaria la URL) imagen credencial ¿? ni idea de como tendríamos que guardar las imágenes
	Nro_de_Socio INT NOT NULL,
	Fecha_de_Registro DATE NOT NULL,
	CONSTRAINT PK_Cobertura_id_cobertura PRIMARY KEY (id_cobertura),
	CONSTRAINT FK_Cobertura_id_prestador FOREIGN KEY (id_prestador) REFERENCES HospitalGral.Prestador(id_prestador)
)
GO
*/

SELECT * FROM HospitalGral.Prestador

------------------------------------------------------------COBERTURA------------------------------------------------------------------------------

--Cambios en Tabla: imagen-> varchar(255) al menos

--ALTA:
--Cambios en SP: ampliar cant de caracteres para imagen, evitar que los nros de socios se ingresen en negativo, validacion de largo de cadena LISTO

-- Ingrese id en negativo, probe distintos formatos de fecha

DECLARE @id_prestador INT;
DECLARE @imagen NVARCHAR(2048);
DECLARE @nro_socio INT;
DECLARE @fecha_reg DATE;

SET @id_prestador = 1; 
SET @imagen = 'https://preview.redd.it/z27alqcxlosc1.jpeg?width=640&crop=smart&auto=webp&s=b01f716c8b72e19eb68c5c974a630e073aefae08';
SET @nro_socio = -10;
SET @fecha_reg = GETDATE();

EXEC PacientE.Cobertura_Alta @id_prestador, @imagen,@nro_socio,@fecha_reg

--BAJA
--Anda joya
EXEC Paciente.Cobertura_Baja 0
EXEC Paciente.Cobertura_Baja '2'


--MODIFICACION 
---Modificar SP: que no deje modificar Nros de Socio con valores negativos
---Bien ya la Foreign se encarga

DECLARE @fecha_reg DATE;

SET @fecha_reg = GETDATE();

EXEC Paciente.Cobertura_Modificar Fecha_de_Registro, @fecha_reg, 1
SELECT * FROM Paciente.Cobertura


----------------------------------------------------------- ESTUDIO -------------------------------------------------------------
/*
CREATE TABLE Paciente.Estudio (
	id_estudio INT IDENTITY(0,1),
	id_historia_clinica INT NOT NULL,
	fecha DATE NOT NULL,
	Nombre_Estudio NVARCHAR(50) NOT NULL,
	Autorizado BIT NOT NULL,
	--Tengo dudas sobre lo que se supone que contienen estos dos campos
	--¿Tienen un texto nada más, o hacen referencia a datos no estructurados?
	--De momento los voy a dejar con un varchar pero hay que ver que contienen
	Documento_Resultado NVARCHAR(90),
	Imagen_Resultado NVARCHAR(90),
	CONSTRAINT PK_Estudio_id_estudio PRIMARY KEY (id_estudio),
	CONSTRAINT FK_Estudio_Paciente FOREIGN KEY (id_historia_clinica) REFERENCES Paciente.Paciente(id_historia_clinica)
)

*/

--Cambios Tabla: Alargar URL, DATETIME , Ponerles NOT NULL A Doc

--ALTA 

--Cambios SP: Verificar que no sea cadena vacia ni mas largo LISTO 

SELECT * FROM Paciente.Paciente

DECLARE @fecha_reg DATE;
SET @fecha_reg = GETDATE();


EXEC Paciente.Estudio_Alta 88, @fecha_reg, 'ECOGRAFDDSF', 3453252, 'https://preview.redd.it/z27alqcxlosc1.jpeg?width=640&crop=smart&auto=webp&s=b01f716c8b72e19eb68c5c974a630e073aefae08','https://preview.redd.it/z27alqcxlosc1.jpeg?width=640&crop=smart&auto=webp&s=b01f716c8b72e19eb68c5c974a630e073aefae08'

SELECT * FROM Paciente.Estudio

-- BAJA

EXEC Paciente.Estudio_Baja 5

-- MODIFICACION

EXEC Paciente.Estudio_Modificacion Nombre_Estudio,'ECOGRAFIA TRANSVAGINAL',3

----------------------------------------------------------------- DOMICILIO -------------------------------------------------------------------------------------
/*
CREATE TABLE Paciente.Domicilio (
	id_domicilio INT IDENTITY (0,1),
	Calle_Nro NVARCHAR(50), --Decision de diseño juntar los campos Calle y Nro
	Piso INT,
	Departamento CHAR(1),
	Codigo_Postal INT,
	Pais NVARCHAR(50) NOT NULL,
	Provincia NVARCHAR(50) NOT NULL,
	Localidad NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Domicilio_id_domicilio PRIMARY KEY (id_domicilio)
)
*/

--Modificacion TABLA: CHECK a piso, departamento, codigo postal
--Modificaciones SP: agregar validaciones de cadenas vacias LISTO

EXEC Paciente.Domicilio_Alta 'Dávilaa 2560',-5,-2,-10,'','',''
SELECT * FROM Paciente.Domicilio WHERE Calle_Nro = 'Dávilaa 2560'

EXEC Paciente.Domicilio_Baja -2

	DECLARE @id_dom int;
    DECLARE @Calle_Nro varchar(51);
	DECLARE @Piso int;
	DECLARE @Departamento char(1);
	DECLARE @Codigo_Postal int;
	DECLARE @Pais varchar(51);
	DECLARE @Provincia varchar(51);
	DECLARE @Localidad varchar(51);

	SET @id_dom = 0;
	SET @Calle_Nro = '';
	SET @Piso = -2;
	SET @Departamento = 'DADA';
	SET @Codigo_Postal=-1;
	SET @Pais = '';
	SET @Provincia ='';
	SET @Localidad ='';



EXEC Paciente.Domicilio_Modificacion @id_dom,@Calle_Nro, @Piso, @Departamento, @Codigo_Postal, @Pais, @Provincia, @Localidad 
SELECT * FROM Paciente.Domicilio 
--No me verifica que el id no exista LISTO
--- mismos temitas de validacion de cadenas vacias y longitud LISTO en y negativos se resuelven con los CHECKS

------------------------------------------------PACIENTE-------------------------------------------

/*
CREATE TABLE Paciente.Paciente (
	id_historia_clinica INT IDENTITY(0,1),
	tipo_documento NVARCHAR(50),
	num_documento NVARCHAR(9),
	id_cobertura INT ,
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	Apellido_Materno NVARCHAR(50),
	Fecha_De_Nacimiento DATE NOT NULL,
	Sexo_Biologico VARCHAR(10) NOT NULL,
	Genero VARCHAR(10) NOT NULL,
	Nacionalidad NVARCHAR(50) NOT NULL,
	Foto_perfil VARCHAR(255), -- modifiqueeeeee (Tambien la agrego como URL) ¿Añadir foto de perfil? esto no se guarda en sql ni a palos
	Mail NVARCHAR(50) NOT NULL,
	Telefono_Fijo NVARCHAR(15),
	Telefono_de_Contacto_Alternativo NVARCHAR(15),
	Telefono_Laboral NVARCHAR(15),
	Fecha_de_Registro DATE,
	Fecha_de_Actualizacion DATE,
	Usuario_Actualización INT,
	id_domicilio INT,
	Estado_activo BIT,
	CONSTRAINT PK_Paciente_id_historia_clinica PRIMARY KEY (id_historia_clinica), 
	CONSTRAINT FK_Paciente_id_cobertura FOREIGN KEY (id_cobertura) REFERENCES Paciente.Cobertura(id_cobertura)
)
GO

*/

SELECT * FROM Paciente.Paciente

EXEC.Paciente.Paciente_Baja 0

EXEC Paciente.Paciente_Modificacion 0, 'num_documento', '-25111000'