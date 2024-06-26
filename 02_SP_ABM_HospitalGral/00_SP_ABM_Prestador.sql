USE [Com2900G06]
GO

CREATE OR ALTER   PROCEDURE [HospitalGral].[Prestador_Alta] 
@Nombre_Prestador nvarchar(51), 
@Plan_Prestador nvarchar(51)
AS
declare @errormessage nvarchar(50);
BEGIN
	BEGIN TRY
		if exists(select 1 from HospitalGral.Prestador where Nombre_Prestador = @Nombre_Prestador and Plan_Prestador = @Plan_Prestador)
			throw 50000, 'Ya existe un registro con ese Nombre de Prestador y con ese Plan de Prestador.', 1;

		set @errormessage = hospitalgral.validacion_campo_long('Prestador', 'Nombre_Prestador', @Nombre_Prestador);
		if(@errormessage is not null)
			throw 50001, @errormessage, 1
		
		set @errormessage = hospitalgral.validacion_campo_long('Prestador', 'Plan_Prestador', @Plan_Prestador);
		if(@errormessage is not null)
			throw 50001, @errormessage, 1

		INSERT INTO HospitalGral.Prestador values (@Nombre_Prestador, @Plan_Prestador,0);
	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

CREATE OR ALTER PROCEDURE [HospitalGral].[Prestador_Baja] @id_prestador int
AS
	
	declare @msj nvarchar(100);

BEGIN
	BEGIN TRY
		if not exists(select 1 from HospitalGral.Prestador where id_prestador = @id_prestador)
			throw 50000, 'El id de prestador no existe.', 1;

		select @msj = 'El id de prestador eliminado es ' + convert(varchar(30), @id_prestador) + ' cuyo Nombre es: ' + (select Nombre_Prestador from HospitalGral.Prestador where id_prestador = @id_prestador) + '.';
		
		update HospitalGral.Prestador set logical_drop = 1
		WHERE id_prestador = @id_prestador;
		
		update Turno.Reserva_de_Turno_Medico --Actualizar aquellos turnos
		set id_estado_turno = 2	--Dando el status 2 (Cancelado)
		where id_turno in --Si:
		(	select re.id_turno --Tablas:
			from HospitalGral.Prestador Pr join	--Prestador
			Paciente.Cobertura Co join			--Cobertura
			Paciente.Paciente Pa join			--Paciente
			Turno.Reserva_de_Turno_Medico Re	--Reserva de turno Medico
			on (Pa.id_historia_clinica = Re.id_historia_clinica)	--Pertenece al mismo cliente
			on (Co.id_cobertura = Pa.id_cobertura)					--De la misma cobertura
			on (Pr.id_prestador = Co.id_prestador and				--Perteneciente a x prestador
			Pr.id_prestador = @id_prestador)						--Donde el prestador sea el que voy a eliminar
		);

		print @msj

		set @msj = (select STRING_AGG(re.id_turno, char(10)) --Tablas:
		from HospitalGral.Prestador Pr join	--Prestador
		Paciente.Cobertura Co join			--Cobertura
		Paciente.Paciente Pa join			--Paciente
		Turno.Reserva_de_Turno_Medico Re	--Reserva de turno Medico
		on (Pa.id_historia_clinica = Re.id_historia_clinica)	--Pertenece al mismo cliente
		on (Co.id_cobertura = Pa.id_cobertura)					--De la misma cobertura
		on (Pr.id_prestador = Co.id_prestador and				--Perteneciente a x prestador
		Pr.id_prestador = @id_prestador))

		set @msj = 'Los turnos cancelados son: ' + @msj;
		print @msj;

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH
END
GO

CREATE OR ALTER   PROCEDURE [HospitalGral].[Prestador_Modificacion]
	@campo_a_modif nvarchar(20), 
	@valor nvarchar(52), 
	@id_prestador int
AS
	declare @response nvarchar(35);
	declare @tabla varchar(20);
	declare @sql nvarchar(150);
	declare @aux nvarchar(50);
BEGIN
	BEGIN TRY
		if not exists(select 1 from HospitalGral.Prestador where id_prestador = @id_prestador)
			throw 50000, 'El id de prestador no existe por lo tanto no hay registro para modificar.', 1;

		select @tabla = 'Prestador';

		select @response = HospitalGral.validacion_campo_long(@tabla, @campo_a_modif, @valor);

		if(@response is not null)
			throw 50001, @response, 1;

		if('Nombre_Prestador' = @campo_a_modif)
		begin
			set @aux = (select Plan_Prestador from HospitalGral.Prestador where id_prestador = @id_prestador);
			if(exists(select 1 from HospitalGral.Prestador where id_prestador != @id_prestador and Nombre_Prestador = @valor and Plan_Prestador = @aux))
				set @sql = 'Error. Registro duplicado';
		end
		
		if('Plan_Prestador' = @campo_a_modif)
		begin
			set @aux = (select Nombre_Prestador from HospitalGral.Prestador where id_prestador = @id_prestador);
			if(exists(select 1 from HospitalGral.Prestador where id_prestador != @id_prestador and Plan_Prestador = @valor and Nombre_Prestador = @aux))
				set @sql = 'Error. Registro duplicado';
		end

		if(@sql is not null)
			throw 50002, @sql, 1


		set @valor = '''' + @valor + ''''; -- Solo puedo modificar cadenas en prestador, no hace falta verificar por numeros.

		select @sql = 'UPDATE HospitalGral.Prestador SET ' + @campo_a_modif + ' = ' + @valor + ' WHERE id_prestador = ' + convert(varchar(30), @id_prestador);

		--print @sql;

		exec sp_executesql @sql;

	END TRY
		
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO



