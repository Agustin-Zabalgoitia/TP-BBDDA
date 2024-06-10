USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Autorizacion_estudios_importar_JSON
	@path NVARCHAR(200)
AS
BEGIN
	
	CREATE TABLE #TempAutorizaciones(
	id_Autorizacion CHAR(24) PRIMARY KEY ,
	Area NVARCHAR(30) ,
	Estudio NVARCHAR(70) ,
	Prestador NVARCHAR(50),
	Plan_p NVARCHAR(50),
	PorcentCobertura INT,
	Costo DECIMAL(8,2) ,
	Autorizacion_req BIT ,
	)

	-- IMPORTAR JSON --- USA UTF-16
	DECLARE @importJSON NVARCHAR(MAX);
    SET @importJSON = N'
    INSERT INTO #TempAutorizaciones(id_Autorizacion, Area, Estudio, Prestador, Plan_p, PorcentCobertura, Costo, Autorizacion_req)
    SELECT id_Autorizacion, Area, Estudio, Prestador, Plan_p, PorcentCobertura, Costo, Autorizacion_req
    FROM OPENROWSET(
        BULK ''' + @path + ''',
        CODEPAGE = ''65001'',
        SINGLE_NCLOB
    ) AS j
    CROSS APPLY OPENJSON(BulkColumn)
    WITH(
        id_Autorizacion CHAR(24) ''$._id."$oid"'', 
        Area NVARCHAR(30)  ''$.Area'', 
        Estudio NVARCHAR(70) ''$.Estudio'', 
        Prestador NVARCHAR(50)''$.Prestador'', 
        Plan_p NVARCHAR(50)  ''$.Plan'', 
        PorcentCobertura INT ''$."Porcentaje Cobertura"'', 
        Costo DECIMAL(8,2) ''$.Costo'', 
        Autorizacion_req BIT ''$."Requiere autorizacion"''
    );
    ';

    -- Ejecutar consulta SQL dinámica
    EXEC sp_executesql @importJSON;

	--LOGICA DE INSERT
	INSERT INTO HospitalGral.Autorizacion_Estudios(id_Autorizacion, Area, Estudio, Id_prestadorPlan, PorcentCobertura, Costo, Autorizacion_req)
	SELECT
		id_Autorizacion, 
		Area, 
		Estudio, 
		(SELECT id_prestador FROM HospitalGral.Prestador p WHERE p.Nombre_Prestador = temp.Prestador COLLATE Modern_Spanish_CI_AI AND p.Plan_Prestador = temp.Plan_p COLLATE Modern_Spanish_CI_AI),
		PorcentCobertura, 
		Costo, 
		Autorizacion_req
	FROM #TempAutorizaciones temp
	WHERE NOT EXISTS(
		SELECT 1 
		FROM HospitalGral.Autorizacion_Estudios ae
		WHERE ae.id_Autorizacion = temp.id_Autorizacion COLLATE Modern_Spanish_CI_AI
	)
	AND temp.Estudio IS NOT NULL
	
	DROP TABLE #TempAutorizaciones
END
GO
