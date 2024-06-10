USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Sede_de_Atencion_importar_CSV
	@path NVARCHAR(150)
AS
BEGIN
	--Creo una tabla temporal para hacer el Bulk insert
	CREATE TABLE #TempSedesNuevas(
		Sede NVARCHAR(30),
		Direccion NVARCHAR(50),
		Localidad NVARCHAR(50),
		Provincia NVARCHAR(30),
		CONSTRAINT PK_tempSede PRIMARY KEY (Sede, Direccion)
	)

	--BULK INSERT
	DECLARE @bulk_insert NVARCHAR(MAX);
    SET @bulk_insert = N'
    BULK INSERT #TempSedesNuevas
    FROM ''' + @path + '''
    WITH 
    (
        FIELDTERMINATOR = '';'', 
        ROWTERMINATOR = ''\n'', 
        CODEPAGE = ''65001'', --- para UTF-8
        FIRSTROW = 2 -- para evitar el encabezado
    );';

	EXEC sp_executesql @bulk_insert;

	INSERT INTO HospitalGral.Sede_de_Atencion(Nombre_de_la_Sede, Direccion_Sede, Localidad, Provincia)
	SELECT 
		Sede,
		Direccion,
		Localidad,
		Provincia
	FROM #TempSedesNuevas AS temp
	WHERE NOT EXISTS(
		SELECT 1 
		FROM HospitalGral.Sede_de_Atencion AS tab
		WHERE temp.sede = tab.Nombre_de_la_Sede
		AND temp.Direccion = tab.Direccion_Sede
	)

	DROP TABLE #TempSedesNuevas;
END	
GO

