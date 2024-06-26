USE [Com2900G06]
GO

CREATE OR ALTER   PROCEDURE [HospitalGral].[Medico_Alta]

	@id_especialidad INT,
	@nombre NVARCHAR(51),
	@apellido NVARCHAR(51),
	@Nro_Matricula INT
AS
BEGIN
	BEGIN TRY
		if not exists(SELECT 1 FROM HospitalGral.Especialidad  as e WHERE @id_especialidad = e.id_especialidad)
		throw 50000, 'La especialidad indicada no existe',1;
		if(Len(@nombre)>50 OR Len(@nombre)=0)
		throw 50001, 'El nombre es vacío o excede el máximo de caracteres',1;
		if(Len(@apellido)>50 OR Len(@apellido)=0)
		throw 50002, 'El apellido es vacío o excede el máximo de caracteres',1;
		if exists(SELECT 1 FROM HospitalGral.Medico as m WHERE @Nro_Matricula = m.Nro_Matricula)
		throw 50003, 'Este Nro_Matricula ya está dado de alta en la base de datos de Medicos',1;
		if(@Nro_Matricula<0)
		throw 50004, 'No admite un numero de matricula negativo',1;

		INSERT INTO HospitalGral.Medico(id_especialidad,Nombre,Apellido,Nro_Matricula) VALUES (@id_especialidad,@nombre,@apellido,@Nro_Matricula);

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

CREATE OR ALTER   PROCEDURE [HospitalGral].[Medico_Baja]
	@id_medico INT
AS
BEGIN
	
	BEGIN TRY
		if not exists( SELECT 1 FROM HospitalGral.Medico as m WHERE @id_medico = m.id_medico)
		throw 50000, 'No existe el [id_medico] especificado',1;

		DELETE FROM HospitalGral.Medico WHERE @id_medico = id_medico;

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

CREATE OR ALTER   PROCEDURE [HospitalGral].[Medico_Modificacion]
	@id_medico INT,
	@campo VARCHAR(50),
	@valor VARCHAR(52)
AS
	DECLARE @sql NVARCHAR(500);
	DECLARE @tabla varchar(20);
	DECLARE @response nvarchar(35);
BEGIN
	
	BEGIN TRY
		if not exists(SELECT 1 FROM HospitalGral.Medico WHERE id_medico = @id_medico)
		throw 50000, 'No existe el [id_medico] especificado',1;
		
		SET @tabla = 'Medico';
		SET @response = HospitalGral.validacion_campo_long(@tabla, @campo, @valor);

		if(@response is not null)
		throw 50000, @response, 1

		if(@campo COLLATE Modern_Spanish_CI_AI = 'id_especialidad' and not exists (SELECT 1 FROM HospitalGral.Medico WHERE id_especialidad =  CONVERT(INT, @valor)))
		throw 50000, 'No se ingreso un [id_especialidad] valido.', 1;

		if(@campo COLLATE Modern_Spanish_CI_AI = 'Nro_Matricula' and exists (SELECT 1 FROM HospitalGral.Medico WHERE Nro_Matricula =  CONVERT(INT, @valor)))
		throw 50000, 'Este numero de matricula ya existe.', 1;

		if(@campo COLLATE Modern_Spanish_CI_AI = 'Nro_Matricula' and exists (SELECT 1 FROM HospitalGral.Medico WHERE CONVERT(INT, @valor) < 0))
		throw 50000, 'Este numero de matricula no es valido.', 1;

		if(@campo not in ('id_medico', 'id_especialidad', 'Nro_Matricula'))
		set @valor = '''' + @valor + '''';

		--Armo la query correspondiente
		SET @sql =	'UPDATE HospitalGral.Medico SET ' + 
				@campo + ' = ' + convert(nvarchar(52), @valor) + 
				' where id_medico = ' + convert(varchar(50), @id_medico);

		execute sp_executesql @sql;

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO


