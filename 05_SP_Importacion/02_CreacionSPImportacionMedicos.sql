USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Medico_importar_CSV
	@path NVARCHAR(150)
AS
BEGIN
	DECLARE @id_domicilio INT;

	--Creo una tabla temporal para hacer el Bulk insert
	CREATE TABLE #TempMedicosNuevos(
		DrApellido NVARCHAR(50),
		Nombre NVARCHAR(30),
		Especialidad NVARCHAR(50),
		Num_Colegiado INT,
		CONSTRAINT PK_tempMed PRIMARY KEY (Especialidad, Num_Colegiado)
	)

	CREATE TABLE #TempEspecialidad(
		Especialidad NVARCHAR(50) 
	)

	--BULK INSERT
	DECLARE @bulk_insert NVARCHAR(MAX);
    SET @bulk_insert = N'
    BULK INSERT #TempMedicosNuevos
    FROM ''' + @path + '''
    WITH 
    (
        FIELDTERMINATOR = '';'', 
        ROWTERMINATOR = ''\n'', 
        CODEPAGE = ''65001'', --- para UTF-8
        FIRSTROW = 2 -- para evitar el encabezado
    );';

	EXEC sp_executesql @bulk_insert;

	INSERT INTO #TempEspecialidad (Especialidad)
	SELECT
		Especialidad
	FROM #TempMedicosNuevos;

	WITH CTE_Dup_Especialidad AS(
		SELECT Especialidad,
		ROW_NUMBER() OVER(PARTITION BY Especialidad ORDER BY Especialidad) AS Rep
		FROM #TempEspecialidad
	)
	INSERT INTO HospitalGral.Especialidad(Nombre_Especialidad)
		SELECT Especialidad
		FROM CTE_Dup_Especialidad 
		WHERE Rep < 2 
		AND NOT EXISTS(
		SELECT 1 
		FROM HospitalGral.Especialidad AS tab
		WHERE Especialidad = tab.Nombre_Especialidad COLLATE Modern_Spanish_CI_AI
	);
	
	INSERT INTO HospitalGral.Medico(id_especialidad, Nombre, Apellido, Nro_Matricula)
	SELECT 
		(SELECT id_especialidad FROM HospitalGral.Especialidad AS e WHERE e.Nombre_Especialidad = temp.Especialidad COLLATE Modern_Spanish_CI_AI),
		Nombre,
		DrApellido,
		Num_Colegiado
	FROM #TempMedicosNuevos AS temp
	WHERE NOT EXISTS(
		SELECT 1 
		FROM HospitalGral.Medico AS tab
		WHERE temp.Num_Colegiado = tab.Nro_Matricula 
		AND (SELECT id_especialidad FROM HospitalGral.Especialidad AS e WHERE e.Nombre_Especialidad = temp.Especialidad COLLATE Modern_Spanish_CI_AI) = tab.Nro_Matricula
	)

	DROP TABLE #TempMedicosNuevos;
	DROP TABLE #TempEspecialidad;
END	
GO
