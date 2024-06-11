use [Com2900G06]
go


-- Alta

CREATE OR ALTER   PROCEDURE [Paciente].[Estudio_Alta] @id_historia_clinica int, @fecha date, @Nombre_Estudio nvarchar(71), @Documento_Resultado nvarchar(256), @Imagen_Resultado nvarchar(256)
AS
	declare @autorizacion int;
	declare @porccobertura int;
	declare @campo_error nvarchar(100);
	declare @mensaje_error nvarchar(110);
	declare @msj nvarchar(70);
BEGIN
	BEGIN TRY 

		--Validacion de datos
		if(len(@Nombre_Estudio)>70 OR len(@Nombre_Estudio)= 0)
			set @campo_error += '[Nombre_Estudio] ';
		if(len(@Documento_Resultado)>255 OR len(@Documento_Resultado)= 0)
			set @campo_error += '[Documento_Resultado] ';
		if(len(@Imagen_Resultado)>255 OR len(@Imagen_Resultado)= 0)
			set @campo_error += '[Imagen_Resultado] ';

		set @mensaje_error = 'Los siguientes campos no tienen la longitud adecuada: [ ' + @campo_error + ' ]';
		if(len(@campo_error)>0)
			throw 50000, @mensaje_error, 1;

		if not exists(select 1 from Paciente.Paciente where id_historia_clinica = @id_historia_clinica)
			throw 50000, 'El paciente no existe, ingrese nuevamente el id de historia clinica', 1;

		if(@fecha < convert(DATE, GETDATE()))
			throw 50001, 'Fecha invalida, la fecha del estudio debe ser posterior al dia de hoy.', 1;
		--Fin Validacion de datos
		
		select @porccobertura = au.PorcentCobertura from Paciente.Paciente pa join --Obtengo todos los estudios permitidos para ese paciente
		Paciente.Cobertura co join
		HospitalGral.Prestador pr join
		HospitalGral.Autorizacion_Estudios au --Dame todas aquellas
		on (pr.id_prestador = au.id_PrestadorPlan) --Autorizaciones de estudio de determinado Prestador
		on (co.id_prestador = pr.id_prestador) --Que tenga determinada cobertura
		on (co.id_cobertura = pa.id_cobertura and --Donde la cobertura de ese prestador
			pa.id_historia_clinica = 19)--Sea la misma que la del paciente que solicita el estudio
		where au.Estudio = @Nombre_Estudio

		if(@Nombre_Estudio in
		(	select au.Estudio from Paciente.Paciente pa join --Obtengo todos los estudios permitidos para ese paciente
			Paciente.Cobertura co join
			HospitalGral.Prestador pr join
			HospitalGral.Autorizacion_Estudios au --Dame todas aquellas
			on (pr.id_prestador = au.id_PrestadorPlan) --Autorizaciones de estudio de determinado Prestador
			on (co.id_prestador = pr.id_prestador) --Que tenga determinada cobertura
			on (co.id_cobertura = pa.id_cobertura and --Donde la cobertura de ese prestador
				pa.id_historia_clinica = @id_historia_clinica)--Sea la misma que la del paciente que solicita el estudio
		)) set @autorizacion = 1; else set @autorizacion = 0;

		
		if(@autorizacion = 1)
		begin
			print 'El estudio solicidado está autorizado por la prestadora';
			set @msj = 'La prestadora cubre el '+convert(nvarchar(5), @porccobertura)+'% del estudio';
			print @msj;
		end
		else
			print 'El estudio solicidado NO está autorizado por la prestadora';
	
		
		

		INSERT INTO Paciente.Estudio values	(@id_historia_clinica, @fecha, @Nombre_Estudio, @autorizacion, @Documento_Resultado, @Imagen_Resultado)

	END TRY
	
	BEGIN CATCH
		print error_message();
	END CATCH

END	


-- Baja

GO
CREATE OR ALTER PROCEDURE Paciente.Estudio_Baja @id_estudio int
AS
	declare @msj nvarchar(50);

BEGIN
	BEGIN TRY

		if not exists(select 1 from Paciente.Estudio where id_estudio = @id_estudio)
			throw 50000, 'El id de estudio no existe y no pertenece a ningun paciente', 1;
		
		select @msj = 'Estudio numero ' + convert(varchar(30),@id_estudio) + ' eliminado del paciente ' + (convert(varchar(30), (select id_historia_clinica from Paciente.Estudio where id_estudio = @id_estudio))) + '.'

		DELETE FROM Paciente.Estudio
		WHERE id_estudio = @id_estudio;

		print @msj

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH
END

-- Modificacion

GO
CREATE OR ALTER PROCEDURE Paciente.Estudio_Modificacion @campo_a_modif varchar(20), @valor varchar(256), @id_estudio int
AS

	declare @response nvarchar(35);
	declare @tabla varchar(20);
	declare @sql nvarchar(500);

BEGIN
	BEGIN TRY

		if not exists(select 1 from Paciente.Estudio where id_estudio = @id_estudio)
			throw 50000, 'El numero de estudio que se quiere actualizar no existe', 1;

		IF(( 'Autorizado' = @campo_a_modif )and (@campo_a_modif NOT IN ('0', '1')))
		throw 50004, 'El valor no corresponde a un booleano',1;
			
		select @tabla = 'Estudio';

		select @response = HospitalGral.validacion_campo_long(@tabla, @campo_a_modif, @valor);

		if(@response is not null)
			throw 50002, @response, 1;

		
	

		if(@campo_a_modif in ('Nombre_Estudio', 'Documento_Resultado', 'Imagen_Resultado'))
			set @valor = '''' + @valor + '''';


		select @sql = 'UPDATE Paciente.Estudio SET ' + @campo_a_modif + ' = ' + @valor + ' WHERE id_estudio = ' + convert(varchar(30), @id_estudio) 

		--print @sql

		exec sp_executesql @sql;

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH
END