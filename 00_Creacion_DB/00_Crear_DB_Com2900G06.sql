/*
Entrega 3
Luego de decidirse por un motor de base de datos relacional, llegó el momento de generar la base de
datos.
Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle las
configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos, etc.) en un
documento como el que le entregaría al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar un
archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es entregado).
Incluya comentarios para indicar qué hace cada módulo de código.
Genere store procedures para manejar la inserción, modificado, borrado (si corresponde, también
debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con “SP”.
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto en la
creación de objetos. NO use el esquema “dbo”.
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha de
entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.
Entregar todo en un zip cuyo nombre sea Grupo_XX.zip mediante la sección de prácticas de MIEL.
Solo uno de los miembros del grupo debe hacer la entrega
*/

/*
Fecha de entrega: 11/06/2024
Nº de grupo: 6
Nombre de la Materia: Bases de Datos Aplicadas

Alumnos
DNI			Nombre
43262563	Abaca, Iván
43895910	Gonzalez, Luca
43458509	Licarzi, Florencia Berenice
43508768	Zabalgoitia, Agustín
*/

--Creación de la base de datos con el nombre indicado por la consigna
--USE master
--DROP DATABASE Com2900G06

CREATE DATABASE Com2900G06
GO

USE Com2900G06
GO

ALTER DATABASE Com2900G06
COLLATE Modern_Spanish_CI_AI;
GO 

--Esquema para agrupar todos los datos relacionados con el paciente, incluyendo:
--Prestador, autorizacion, dias x sede, sede de atención, médico, y especialidad
CREATE SCHEMA HospitalGral
GO

--Esquema para agrupar todos los datos relacionados con el paciente, incluyendo:
--Estudio, usuario, paciente, cobertura, domicilio
CREATE SCHEMA Paciente
GO

--Esquema para agrupar todos los datos relacionados con los turnos, incluyendo:
--Reserva, estado, tipo, 
CREATE SCHEMA Turno
GO

CREATE TABLE HospitalGral.Prestador (
	id_prestador INT IDENTITY (0,1),
	Nombre_Prestador NVARCHAR(50) NOT NULL,
	Plan_Prestador NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Prestador_id_prestador PRIMARY KEY (id_prestador)
)
GO

--Empieza la creación de las tablas en el esquema Sede
CREATE TABLE HospitalGral.Sede_de_Atencion (
	id_sede INT IDENTITY(0,1),
	Nombre_de_la_Sede NVARCHAR(50) NOT NULL,
	Direccion_Sede NVARCHAR(50) NOT NULL,
	Localidad NVARCHAR(50),
	Provincia NVARCHAR(50),
	CONSTRAINT PK_Sede_de_Atencion_id_sede PRIMARY KEY (id_sede)
)
GO

CREATE TABLE HospitalGral.Especialidad (
	id_especialidad INT IDENTITY(0,1),
	Nombre_Especialidad NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Especialidad_id_especialidad PRIMARY KEY (id_especialidad)
)
GO

CREATE TABLE HospitalGral.Medico (
	id_medico INT IDENTITY(0,1),
	id_especialidad INT,
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	Nro_Matricula INT NOT NULL,
	CONSTRAINT PK_Medico_id_medico PRIMARY KEY (id_medico),
	CONSTRAINT FK_Medico_id_especialidad FOREIGN KEY (id_especialidad) REFERENCES HospitalGral.Especialidad(id_especialidad)
)
GO

--Se maneja como el concepto de disponibilidad de Analisis de sistemas, tenes que particionar el dia en turnos de 15 minutos, y alguno sera asociado a la reserva de turno
CREATE TABLE HospitalGral.Dias_x_Sede (
	id_sede INT NOT NULL,
	id_medico INT NOT NULL,
	Dia NVARCHAR(9) NOT NULL,
	Hora_Inicio TIME NOT NULL, --Hora de inicio de los turnos, los turnos duran 15 minutos
	CONSTRAINT PK_Dias_x_Sede PRIMARY KEY (id_medico, Dia, Hora_Inicio),
	CONSTRAINT FK_Dias_x_Sede_id_sede FOREIGN KEY (id_sede) REFERENCES HospitalGral.Sede_de_Atencion(id_sede),
	CONSTRAINT FK_Dias_x_Sede_id_medico FOREIGN KEY (id_medico) REFERENCES HospitalGral.Medico(id_medico),
)
GO


CREATE TABLE HospitalGral.Autorizacion_Estudios(
	id_Autorizacion CHAR(24) NOT NULL,
	Area VARCHAR(30) NOT NULL,
	Estudio VARCHAR(70) NOT NULL,
	id_PrestadorPlan INT NOT NULL,
	PorcentCobertura INT NOT NULL,
	Costo DECIMAL(8,2) NOT NULL,
	Autorizacion_req BIT NOT NULL,

	CONSTRAINT PK_Autorizacion_Estudios PRIMARY KEY (id_Autorizacion),
	CONSTRAINT FK_AutorizacionEstudio_PrestadorPLan FOREIGN KEY (id_PrestadorPlan) REFERENCES HospitalGral.Prestador(id_prestador)
)
GO

--Empieza la creación de las tablas en el esquema Paciente

CREATE TABLE Paciente.Cobertura (
	id_cobertura INT IDENTITY(0,1),
	id_prestador INT,
	imagen_credencial VARCHAR(255),
	Nro_de_Socio INT CHECK(Nro_de_Socio >= 0) NOT NULL ,
	Fecha_de_Registro DATE NOT NULL,
	CONSTRAINT PK_Cobertura_id_cobertura PRIMARY KEY (id_cobertura),
	CONSTRAINT FK_Cobertura_id_prestador FOREIGN KEY (id_prestador) REFERENCES HospitalGral.Prestador(id_prestador)
)
GO

CREATE TABLE Paciente.Domicilio (
	id_domicilio INT IDENTITY (0,1),
	Calle_Nro NVARCHAR(50), --Decision de diseño juntar los campos Calle y Nro
	Piso INT CHECK (Piso >= 0),
	Departamento CHAR(1),
	Codigo_Postal INT CHECK (Codigo_Postal >= 0),
	Pais NVARCHAR(50) NOT NULL,
	Provincia NVARCHAR(50) NOT NULL,
	Localidad NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Domicilio_id_domicilio PRIMARY KEY (id_domicilio)
)
GO

CREATE TABLE Paciente.Paciente (
	id_historia_clinica INT IDENTITY(0,1),
	tipo_documento NVARCHAR(50),
	num_documento int CHECK (num_documento >=0),
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

CREATE TABLE Paciente.Estudio (
	id_estudio INT IDENTITY(0,1),
	id_historia_clinica INT NOT NULL,
	fecha DATE NOT NULL,
	Nombre_Estudio NVARCHAR(70) NOT NULL,
	Autorizado BIT NOT NULL,
	Documento_Resultado VARCHAR(255) NOT NULL,
	Imagen_Resultado VARCHAR(255),
	CONSTRAINT PK_Estudio_id_estudio PRIMARY KEY (id_estudio),
	CONSTRAINT FK_Estudio_Paciente FOREIGN KEY (id_historia_clinica) REFERENCES Paciente.Paciente(id_historia_clinica)
)
GO

CREATE TABLE Paciente.Usuario (
	id_usuario INT NOT NULL CHECK (id_usuario >= 0),
	id_historia_clinica INT NOT NULL,
	--Las contraseñas se guardan en un hash, el tamaño del mismo depende del algoritmo usado
	--acá estoy creando un campo para guardar un hash de 16 bytes (MD2, MD4, o MD5)
	Contrasenia BINARY(16) NOT NULL,
	Fecha_de_Creacion DATE NOT NULL,
	CONSTRAINT PK_Usuario_id_usuario PRIMARY KEY (id_usuario),
	CONSTRAINT FK_Usuario_Paciente FOREIGN KEY (id_historia_clinica) REFERENCES Paciente.Paciente(id_historia_clinica)
)

--Empieza la creación de las tablas en el esquema Turno

CREATE TABLE Turno.Estado_Turno ( --CARGAR ESPECIF
	id_estado INT IDENTITY(0,1),
	Nombre_Estado NVARCHAR(50),
	CONSTRAINT PK_Estado_Turno_id_estado PRIMARY KEY (id_estado)
)
GO

CREATE TABLE Turno.Tipo_Turno ( -- CARGAR ESPECIF
	id_tipo_turno INT IDENTITY(0,1),
	Nombre_del_Tipo_de_Turno NVARCHAR(50),
	CONSTRAINT PK_Tipo_Turno_id_tipo_turno PRIMARY KEY (id_tipo_turno)
)
GO


CREATE TABLE Turno.Reserva_de_Turno_Medico (
	id_turno INT IDENTITY(0,1),
	id_historia_clinica INT NOT NULL,
	id_estado_turno INT NOT NULL,
	id_tipo_turno INT NOT NULL,
	id_medico int NOT NULL,
	id_sede int NOT NULL,
	id_especialidad int NOT NULL,
	Fecha DATE NOT NULL,
	Hora TIME NOT NULL,
	--�Es necesario guardar la id del m�dico, su especialidad, y la direcci�n de atenci�n?
	--En caso de que sean necesarios se tendr� que a�adir a Dias x Sede
	CONSTRAINT PK_Reserva_de_Turno_Medico_id_turno PRIMARY KEY (id_turno),
	CONSTRAINT FK_Reserva_de_Turno_Medico_Paciente FOREIGN KEY (id_historia_clinica) REFERENCES Paciente.Paciente(id_historia_clinica),
	CONSTRAINT FK_Reserva_de_Turno_Medico_id_medico FOREIGN KEY (id_medico) REFERENCES HospitalGral.Medico(id_medico),
	CONSTRAINT FK_Reserva_de_Turno_Medico_id_sede FOREIGN KEY (id_sede) REFERENCES HospitalGral.Sede_de_Atencion(id_sede)
)
GO

