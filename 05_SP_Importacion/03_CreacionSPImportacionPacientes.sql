-- CARGAR ARCHIVOS CSV
USE Com2900G06
GO

CREATE OR ALTER PROCEDURE Paciente.Paciente_importar_CSV
	@path NVARCHAR(150)
AS
BEGIN
	--Creo una tabla temporal para hacer el Bulk insert
	CREATE TABLE #TempPacientesNuevos(
		Nombre NVARCHAR(50) ,
		Apellido NVARCHAR(50),
		Fecha_De_Nacimiento NVARCHAR(10),
		tipo_documento NVARCHAR(50),
		num_documento INT,
		Sexo_Biologico VARCHAR(10) NOT NULL,
		Genero VARCHAR(10) NOT NULL,
		Telefono_Fijo NVARCHAR(15),
		Nacionalidad NVARCHAR(50) NOT NULL,
		Mail NVARCHAR(50) NOT NULL,
		Calle_Nro NVARCHAR(50) NOT NULL,
		Localidad NVARCHAR(50) NOT NULL,
		Provincia NVARCHAR(50) NOT NULL

		CONSTRAINT PK_temp0 PRIMARY KEY (tipo_documento, num_documento)
	)

	--BULK INSERT
	DECLARE @bulk_insert NVARCHAR(MAX);
    SET @bulk_insert = N'
    BULK INSERT #TempPacientesNuevos
    FROM ''' + @path + '''
    WITH 
    (
        FIELDTERMINATOR = '';'', 
        ROWTERMINATOR = ''\n'', 
        CODEPAGE = ''65001'', --- para UTF-8
        FIRSTROW = 2 -- para evitar el encabezado
    );';

	EXEC sp_executesql @bulk_insert;
	

	--PROCESO LA TABLA TEMPORAL PARA DEJARLA CON FORMATOS CORRECTO
	-- ->Paso de VARCHAR a DATE las fechas de nacimiento
	UPDATE #TempPacientesNuevos
	SET Fecha_De_Nacimiento = CONVERT(DATE, Fecha_De_Nacimiento, 105) 

	ALTER TABLE #TempPacientesNuevos
	ADD id_domicilio INT NULL; 

	--Logica de Insercion y duplicados
	-- INSERTA DOMICILIOS
	INSERT INTO Paciente.Domicilio(Calle_Nro, Localidad, Provincia, Pais)
	SELECT
		Calle_Nro,
		Localidad,
		Provincia,
		Nacionalidad
	FROM #TempPacientesNuevos AS temp
	WHERE NOT EXISTS(
		SELECT 1
		FROM Paciente.Paciente AS tab
		WHERE temp.tipo_documento = tab.tipo_documento
		AND temp.num_documento = tab.num_documento
	)

	-- INSERTA PACIENTES

	INSERT INTO Paciente.Paciente(tipo_documento,num_documento,Nombre, Apellido, Fecha_De_Nacimiento,Sexo_Biologico,Genero,Nacionalidad, Mail,Telefono_Fijo)
	SELECT
		tipo_documento,
		num_documento,
		Nombre,
		Apellido,
		Fecha_De_Nacimiento, 
		Sexo_Biologico,
		Genero,
		Nacionalidad,
		Mail,
		Telefono_Fijo
	FROM #TempPacientesNuevos AS temp
	WHERE NOT EXISTS(
		SELECT 1
		FROM Paciente.Paciente AS tab
		WHERE temp.tipo_documento = tab.tipo_documento
		AND temp.num_documento = tab.num_documento
	)

	UPDATE Paciente.Paciente
	SET id_domicilio = id_historia_clinica; --recontra peligroso ¿Modifico la estrategia haciendole un Identity a la temporal y sacandosela a las originales? mmm pero cada vez que ejecuta empieza de 0, NO

	DROP TABLE #TempPacientesNuevos;
END	
GO