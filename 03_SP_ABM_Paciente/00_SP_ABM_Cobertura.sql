-- Alta

GO
CREATE OR ALTER PROCEDURE Paciente.Cobertura_Alta @id_prestador int, @imagen_credencial nvarchar(90), @Nro_de_Socio int, @Fecha_de_Registro date
AS

BEGIN
	BEGIN TRY
		if not exists(select 1 from HospitalGral.Prestador where id_prestador = @id_prestador)
			throw 50000, 'El id de prestador no existe, no puede darse de alta la cobertura.', 1;

		if(@Fecha_de_Registro < convert(DATE, GETDATE()))
			throw 50002, 'La fecha de registro de la cobertura no puede ser mas antigua que la del dia de hoy.', 1;

		if exists(select 1 from Paciente.Cobertura where id_prestador = @id_prestador and Nro_de_Socio = @Nro_de_Socio)
			throw 50003, 'El numero de socio ya se encuentra registrado para dicho prestador.', 1;

		INSERT INTO Paciente.Cobertura values (@id_prestador, @imagen_credencial, @Nro_de_Socio, @Fecha_de_Registro);

	END TRY
		
	BEGIN CATCH
		print error_message();
	END CATCH

END

-- Baja

GO
CREATE OR ALTER PROCEDURE Paciente.Cobertura_Baja @id_cobertura int
AS
	declare @msj nvarchar(100);

BEGIN
	BEGIN TRY
		if not exists(select 1 from Paciente.Cobertura where id_cobertura = @id_cobertura)
			throw 50000, 'El id de cobertura ingresado no existe.', 1;
				
		select @msj = 'Se elimino la cobertura con el Nro_Socio: ' + convert(varchar(20), (select Nro_de_Socio from Paciente.Cobertura where id_cobertura = @id_cobertura)) + ' cuyo id es: ' + convert(varchar(20), @id_cobertura) + '.';

		DELETE FROM Paciente.Cobertura 
		WHERE id_cobertura = @id_cobertura;

		print @msj;

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH

END

-- Modificacion

GO
CREATE OR ALTER PROCEDURE Paciente.Cobertura_Modificar @campo_a_modif varchar(20), @valor varchar(90), @id_cobertura int
AS
	
	declare @tabla varchar(20);
	declare @response nvarchar(35);
	declare @sql nvarchar(100);

BEGIN
	BEGIN TRY
		if not exists(select 1 from Paciente.Cobertura where id_cobertura = @id_cobertura)
			throw 50000, 'El id de cobertura ingresado no existe.', 1;
		
		select @tabla = 'Cobertura';

		if not exists(select 1 from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tabla and COLUMN_NAME = @campo_a_modif collate Latin1_General_CI_AS)
			throw 50001, 'El campo a modificar no existe', 1;

		select @response = HospitalGral.validacion_campo_long(@tabla, @campo_a_modif, @response);

		if(@response is not null)
			throw 500002, @response, 1;

		set @valor = '''' + @valor + ''''; -- Solo podemos modificar cadenas, asi que no vamos a tener valores numericos.

		select @sql = 'UPDATE Paciente.Cobertura SET ' + @campo_a_modif + ' = ' + @valor + ' WHERE id_cobertura = ' + convert(varchar(30), @id_cobertura);

		--print @sql;

		exec sp_executesql @sql;

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH

END