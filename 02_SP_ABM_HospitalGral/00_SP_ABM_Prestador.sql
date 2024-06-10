-- Alta

GO
CREATE OR ALTER PROCEDURE HospitalGral.Prestador_Alta @Nombre_Prestador nvarchar(50), @Plan_Prestador nvarchar(50)
AS

BEGIN
	BEGIN TRY
		if exists(select 1 from HospitalGral.Prestador where Nombre_Prestador = @Nombre_Prestador and Plan_Prestador = @Plan_Prestador)
			throw 50000, 'Ya existe un registro con ese Nombre de Prestador y con ese Plan de Prestador.', 1;

		INSERT INTO HospitalGral.Prestador values (@Nombre_Prestador, @Plan_Prestador);
	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH

END

-- Baja

GO
CREATE OR ALTER PROCEDURE HospitalGral.Prestador_Baja @id_prestador int
AS
	
	declare @msj nvarchar(100);

BEGIN
	BEGIN TRY
		if not exists(select 1 from HospitalGral.Prestador where id_prestador = @id_prestador)
			throw 50000, 'El id de prestador no existe.', 1;

		select @msj = 'El id de prestador eliminado es ' + convert(varchar(30), @id_prestador) + ' cuyo Nombre es: ' + (select Nombre_Prestador from HospitalGral.Prestador where id_prestador = @id_prestador) + '.';
		
		DELETE FROM HospitalGral.Prestador
		WHERE id_prestador = @id_prestador;

		print @msj

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH
END

-- Modificacion

GO
CREATE OR ALTER PROCEDURE HospitalGral.Prestador_Modificacion @campo_a_modif varchar(20), @valor varchar(50), @id_prestador int
AS

	declare @response nvarchar(35);
	declare @tabla varchar(20);
	declare @sql nvarchar(100);

BEGIN
	BEGIN TRY
		if not exists(select 1 from HospitalGral.Prestador where id_prestador = @id_prestador)
			throw 50000, 'El id de prestador no existe por lo tanto no hay registro para modificar.', 1;

		select @tabla = 'Prestador';
		
		select @response = HospitalGral.validacion_campo_long(@tabla, @campo_a_modif, @valor);

		if(@response is not null)
			throw 50001, @response, 1;

		set @valor = '''' + @valor + ''''; -- Solo puedo modificar cadenas en prestador, no hace falta verificar por numeros.

		select @sql = 'UPDATE HospitalGral.Prestador SET ' + @campo_a_modif + ' = ' + @valor + ' WHERE id_prestador = ' + convert(varchar(30), @id_prestador);

		--print @sql;

		exec sp_executesql @sql;

	END TRY
		
	BEGIN CATCH
		print error_message();
	END CATCH

END