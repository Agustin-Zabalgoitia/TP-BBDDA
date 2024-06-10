/*
CREATE TABLE HospitalGral.Autorizacion_Estudios(
	id_Autorizacion CHAR(24) ,
	Area VARCHAR(30) ,
	Estudio VARCHAR(70) ,
	id_PrestadorPlan INT ,
	PorcentCobertura INT ,
	Costo DECIMAL(8,2) ,
	Autorizacion_req BIT ,

	CONSTRAINT PK_Autorizacion_Estudios PRIMARY KEY (id_Autorizacion),
	CONSTRAINT FK_AutorizacionEstudio_PrestadorPLan FOREIGN KEY (id_PrestadorPlan) REFERENCES HospitalGral.Prestador(id_prestador)
)
*/

USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Autorizacion_Estudios_Alta

	@id_autorizacion  CHAR(24),
	@area NVARCHAR(50),
	@estudio NVARCHAR(50),
	@id_prestadorplan INT,
	@Porc_cobertura INT,
	@costo DECIMAL(8,2),
	@autorizacion BIT

AS
BEGIN
	BEGIN TRY
		if(Len(@id_autorizacion)>24 OR Len(@id_autorizacion)=0)
		throw 50001, 'El campo de [id_autorizacion] es vacío o excede el máximo de caracteres (24)',1;
		if  exists(SELECT 1 FROM HospitalGral.Autorizacion_Estudios  as ae WHERE @id_autorizacion = ae.id_Autorizacion)
		throw 50000, 'El id_autorizacion ya está registrado en la base de datos',1;
		if(Len(@area)>50 OR Len(@area)=0)
		throw 50001, 'El campo de [area] es vacío o excede el máximo de caracteres (50)',1;
		if(Len(@estudio)>50 OR Len(@estudio)=0)
		throw 50002, 'El campod de [estudio] es vacío o excede el máximo de caracteres (50)',1;
		if not exists(SELECT 1 FROM HospitalGral.Prestador as p WHERE @id_prestadorplan = p.id_prestador)
		throw 50003, 'El [id_prestadorPlan] no coincide con ninguno de los prestadores registados',1;
		IF( @autorizacion NOT IN ('0', '1'))
		throw 50004, 'El valor no corresponde a un booleano',1;

		INSERT INTO HospitalGral.Autorizacion_Estudios(id_Autorizacion,Area,Estudio,id_PrestadorPlan,PorcentCobertura,Costo,Autorizacion_req) 
		VALUES (@id_autorizacion,@area,@estudio,@id_prestadorplan,@Porc_cobertura,@costo, @autorizacion);

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

CREATE OR ALTER PROCEDURE HospitalGral.Autorizacion_Estudios_Baja
	@id_autorizacion  CHAR(24)
AS
BEGIN
	
	BEGIN TRY
		if not exists( SELECT 1 FROM HospitalGral.Autorizacion_Estudios as ae WHERE @id_autorizacion = ae.id_Autorizacion)
		throw 50000, 'No existe el [id_autorizacion] especificado',1;

		DELETE FROM HospitalGral.Autorizacion_Estudios WHERE @id_autorizacion = id_Autorizacion;

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

CREATE OR ALTER PROCEDURE HospitalGral.Autorizacion_Estudios_Modificacion
	@id_autorizacion  CHAR(24),
	@campo VARCHAR(50),
	@valor VARCHAR(50)
AS
	DECLARE @sql NVARCHAR(500);
	DECLARE @tabla varchar(20);
	DECLARE @response nvarchar(35);
BEGIN
	BEGIN TRY
		if not exists( SELECT 1 FROM HospitalGral.Autorizacion_Estudios as ae WHERE @id_autorizacion = ae.id_Autorizacion)
		throw 50000, 'No existe el [id_autorizacion] especificado',1;

		set @tabla = 'Autorizacion_Estudios';
		set @response = HospitalGral.validacion_campo_long(@tabla, @campo, @valor);
	
		--Valido si el campo es valido y si la longitud es la adecuada
		if(@response is not null)
			throw 50000, @response, 1

		--Valido que existan las ID's correspondientes
		if(@campo COLLATE Modern_Spanish_CI_AI = 'id_PrestadorPlan' and not exists (select 1 from HospitalGral.Prestador where id_prestador = convert(int, @valor)))
			throw 50000, 'El [id_PrestadorPlan] no tiene una cobertura valida.', 1
		
		--Si no es un numero necesita comillas
		if(@campo not in ('id_Autorizacion', 'id_PrestadorPlan'))
			set @valor = '''' + @valor + '''';

		--Armo la query correspondiente
		SET @sql =	'UPDATE HospitalGral.Autorizacion_Estudios SET ' + 
					@campo + ' = ' + convert(nvarchar(70), @valor) + 
					' where id_historia_clinica = ' + convert(varchar(50), @id_autorizacion);

		-- Ejecutar el SQL din�mico (print es para testeo)
		--print @sql
		execute sp_executesql @sql;
	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
