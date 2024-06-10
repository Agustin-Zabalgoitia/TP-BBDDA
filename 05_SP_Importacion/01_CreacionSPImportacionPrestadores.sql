USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Prestador_importar_CSV
	@path NVARCHAR(150)
AS
BEGIN

	--Creo una tabla temporal para hacer el Bulk insert
	CREATE TABLE #TempPrestadorNuevos(
		Prestador NVARCHAR(30),
		Plan_Prest NVARCHAR(30),
		CONSTRAINT PK_tempPrest PRIMARY KEY (Prestador, Plan_Prest)
	)

	--BULK INSERT
	DECLARE @bulk_insert NVARCHAR(MAX);
    SET @bulk_insert = N'
    BULK INSERT #TempPrestadorNuevos
    FROM ''' + @path + '''
    WITH 
    (
        FIELDTERMINATOR = '';'', 
        ROWTERMINATOR = '';;\n'', 
        CODEPAGE = ''65001'', --- para UTF-8
        FIRSTROW = 2 -- para evitar el encabezado
    );';

	EXEC sp_executesql @bulk_insert;

	INSERT INTO HospitalGral.Prestador(Nombre_Prestador,Plan_Prestador)
	SELECT 
		Prestador,
		Plan_Prest
	FROM #TempPrestadorNuevos AS temp
	WHERE NOT EXISTS(
		SELECT 1 
		FROM HospitalGral.Prestador AS tab
		WHERE temp.Prestador = tab.Nombre_Prestador COLLATE Modern_Spanish_CI_AI
		AND temp.Plan_Prest = tab.Plan_Prestador COLLATE Modern_Spanish_CI_AI
	)

	DROP TABLE #TempPrestadorNuevos;
END	
GO
