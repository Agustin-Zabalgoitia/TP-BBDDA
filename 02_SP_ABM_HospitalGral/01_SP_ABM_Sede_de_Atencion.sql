/*
--Empieza la creación de las tablas en el esquema Sede
CREATE TABLE HospitalGral.Sede_de_Atencion (
	id_sede INT IDENTITY(0,1),
	Nombre_de_la_Sede NVARCHAR(50) NOT NULL,
	Direccion_Sede NVARCHAR(50) NOT NULL,
	Localidad NVARCHAR(50),
	Provincia NVARCHAR(50),
	CONSTRAINT PK_Sede_de_Atencion_id_sede PRIMARY KEY (id_sede)
)
*/

USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Sede_de_Atencion_Alta_

	@nombre NVARCHAR(50),
	@dir NVARCHAR(50),
	@localidad NVARCHAR(50),
	@provincia NVARCHAR(50)
AS
BEGIN
	BEGIN TRY
		if(Len(@nombre)>50 OR Len(@nombre)=0)
		throw 50000, 'El nombre es vacío o excede el máximo de caracteres',1;
		if(Len(@dir)>50 OR Len(@dir)=0)
		throw 50001, 'La direccion es vacía o excede el máximo de caracteres',1;
		if(Len(@localidad)>50 OR Len(@localidad)=0)
		throw 50002, 'La localidad es vacía o excede el máximo de caracteres',1;
		if(Len(@provincia)>50 OR Len(@provincia)=0)
		throw 50003, 'La provincia es vacía o excede el máximo de caracteres',1;
		if exists(SELECT 1 FROM HospitalGral.Sede_de_Atencion as sa WHERE @dir = sa.Direccion_Sede AND @localidad = sa.Localidad AND @provincia = sa.Provincia)
		throw 50004, 'Esta Sede ya está dada de alta en esta Direccion, Localidad y Provincia',1;

		INSERT INTO HospitalGral.Sede_de_Atencion(Nombre_de_la_Sede, Direccion_Sede, Localidad, Provincia) VALUES (@nombre, @dir, @localidad, @provincia);
	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE HospitalGral.Sede_de_Atencion_Baja
	@id_sede INT
AS
BEGIN
	
	BEGIN TRY
		if not exists( SELECT 1 FROM HospitalGral.Sede_de_Atencion as sa WHERE @id_sede = sa.id_sede)
		throw 50000, 'No existe el [id_sede] especificado',1;

		DELETE FROM HospitalGral.Sede_de_Atencion WHERE @id_sede = id_sede;

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

CREATE OR ALTER PROCEDURE HospitalGral.Sede_de_Atencion_Modificacion
	@id_sede INT,
	@campo NVARCHAR(50),
	@valor NVARCHAR(50)
AS
    DECLARE @sql NVARCHAR(500);
	DECLARE @tabla varchar(20);
	DECLARE @response nvarchar(35);
BEGIN
	BEGIN TRY
		if not exists(SELECT 1 FROM HospitalGral.Sede_de_Atencion WHERE @id_sede = id_sede)
		throw 50000,'El [id_sede] ingresado no existe',1;

		SET @tabla = 'Sede_de_Atencion';
		SET @response = HospitalGral.validacion_campo_long(@tabla, @campo, @valor);

		--valido si el campo es valido y si la longitud es la adecuada
		if(@response is not null)
		throw 50000, @response, 1

		--Si no es un numero necesita comillas
		if(@campo not in ('id_sede'))
		set @valor = '''' + @valor + '''';

		--Armo la query correspondiente
	    SET @sql =	'UPDATE HospitalGral.Sede_de_Atencion SET ' + 
				@campo + ' = ' + convert(nvarchar(50), @valor) + 
				' where id_sede = ' + convert(varchar(50), @id_sede);

    -- Ejecutar el SQL dinamico (print es para testeo)
	--print @sql
	execute sp_executesql @sql;

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH
END