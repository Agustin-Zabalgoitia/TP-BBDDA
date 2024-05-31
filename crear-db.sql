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
--USE agustin
--DROP DATABASE Com2900G06

CREATE DATABASE Com2900G06
GO

USE Com2900G06
GO

--Esquema para agrupar todos los datos relacionados con el paciente, incluyendo:
--Estudio, usuario, paciente, cobertura, domicilio, y prestador
CREATE SCHEMA Paciente
GO

--Esquema para agrupar todos los datos relacionados con los turnos, incluyendo:
--Reserva, estado, tipo, dias x sede, sede de atención, médico, y especialidad
CREATE SCHEMA Turno
GO

--Nota en general: ¿los id deberían ser Identity o INT?, de momento los dejo en INT



CREATE TABLE Paciente.Domicilio (
	id_domicilio INT,
	Calle NVARCHAR(50) NOT NULL,
	Numero INT NOT NULL,
	Piso INT,
	Departamento CHAR(1),
	Codigo_Postal INT NOT NULL,
	Pais NVARCHAR(50) NOT NULL,
	Provincia NVARCHAR(50) NOT NULL,
	Localidad NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Domicilio_id_domicilio PRIMARY KEY (id_domicilio)
)
GO

CREATE TABLE Paciente.Prestador (
	id_prestador INT,
	Nombre_Prestador NVARCHAR(50) NOT NULL,
	Plan_Prestador NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Prestador_id_prestador PRIMARY KEY (id_prestador)
)
GO

CREATE TABLE Paciente.Cobertura (
	id_cobertura INT,
	id_prestador INT NOT NULL,
	--imagen credencial ¿? ni idea de como tendríamos que guardar las imágenes
	Nro_de_Socio INT NOT NULL,
	Fecha_de_Registro DATE NOT NULL,
	CONSTRAINT PK_Cobertura_id_cobertura PRIMARY KEY (id_cobertura),
	CONSTRAINT FK_Cobertura_id_prestador FOREIGN KEY (id_prestador) REFERENCES Paciente.Prestador(id_prestador)
)
GO

CREATE TABLE Paciente.Paciente (
	id_historia_clinica INT,
	tipo_documento NVARCHAR(50),
	num_documento INT,
	id_cobertura INT NOT NULL,
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	Apellido_Materno NVARCHAR(50),
	Fecha_De_Nacimiento DATE NOT NULL,
	Sexo_Biologico VARCHAR(10) NOT NULL,
	Genero VARCHAR(10) NOT NULL,
	Nacionalidad NVARCHAR(50) NOT NULL,
	--¿Añadir foto de perfil? esto no se guarda en sql ni a palos
	Mail NVARCHAR(50) NOT NULL,
	Telefono_Fijo INT,
	Telefono_de_Contacto_Alternativo INT,
	Telefono_Laboral INT,
	Fecha_de_Registro DATE NOT NULL,
	Fecha_de_Actualizacion DATE,
	--Usuario_Actualización ni idea qué es esto
	CONSTRAINT PK_Paciente_id_historia_clinica PRIMARY KEY (id_historia_clinica, tipo_documento, num_documento),
	CONSTRAINT FK_Paciente_id_cobertura FOREIGN KEY (id_cobertura) REFERENCES Paciente.Cobertura(id_cobertura)
)
GO

CREATE TABLE Paciente.Estudio (
	id_estudio INT,
	id_historia_clinica INT NOT NULL,
	tipo_documento NVARCHAR(50) NOT NULL,
	num_documento INT NOT NULL,
	fecha DATE NOT NULL,
	Nombre_Estudio NVARCHAR(50) NOT NULL,
	Autorizado BIT NOT NULL,
	--Tengo dudas sobre lo que se supone que contienen estos dos campos
	--¿Tienen un texto nada más, o hacen referencia a datos no estructurados?
	--De momento los voy a dejar con un varchar pero hay que ver que contienen
	Documento_Resultado NVARCHAR(50),
	Imagen_Resultado NVARCHAR(50),
	CONSTRAINT PK_Estudio_id_estudio PRIMARY KEY (id_estudio),
	CONSTRAINT FK_Estudio_Paciente FOREIGN KEY (id_historia_clinica, tipo_documento, num_documento) REFERENCES Paciente.Paciente(id_historia_clinica, tipo_documento, num_documento)
)
GO

CREATE TABLE Paciente.Usuario (
	id_usuario INT,
	id_historia_clinica INT NOT NULL,
	tipo_documento NVARCHAR(50) NOT NULL,
	num_documento INT NOT NULL,
	--Las contraseñas se guardan en un hash, el tamaño del mismo depende del algoritmo usado
	--acá estoy creando un campo para guardar un hash de 16 bytes (MD2, MD4, o MD5)
	Contrasenia BINARY(16) NOT NULL,
	Fecha_de_Creacion DATE NOT NULL,
	CONSTRAINT PK_Usuario_id_usuario PRIMARY KEY (id_usuario),
	CONSTRAINT FK_Usuario_Paciente FOREIGN KEY (id_historia_clinica, tipo_documento, num_documento) REFERENCES Paciente.Paciente(id_historia_clinica, tipo_documento, num_documento)
)
GO

