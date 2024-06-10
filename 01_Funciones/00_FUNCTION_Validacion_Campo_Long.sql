use [Com2900G06]
go

CREATE OR ALTER FUNCTION HospitalGral.validacion_campo_long (
    @tabla NVARCHAR(128),
    @campo NVARCHAR(128),
    @valor NVARCHAR(100)
)
RETURNS nvarchar(35)
AS
BEGIN
	DECLARE @maxlen INT;
    -- Valido la existencia del campo
    IF NOT EXISTS (
        SELECT 1 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = @tabla COLLATE Modern_Spanish_CI_AI
        AND COLUMN_NAME = @campo COLLATE Modern_Spanish_CI_AI
    )
		return 'El campo '+ @campo +' no existe';

    -- Obt�n la longitud m�xima del campo
    SELECT @maxlen = CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tabla COLLATE Modern_Spanish_CI_AI
    AND COLUMN_NAME = @campo COLLATE Modern_Spanish_CI_AI
    AND DATA_TYPE IN ('varchar', 'nchar', 'nvarchar');

    -- Si la longitud m�xima es NULL, significa que el campo no es de tipo cadena
    IF @maxlen IS NULL
        return NULL;

    -- Valida la longitud del valor
    IF LEN(@valor) > @maxlen OR LEN(@valor) = 0
        return 'Error de longitud en el campo';

    RETURN NULL;
END;
GO