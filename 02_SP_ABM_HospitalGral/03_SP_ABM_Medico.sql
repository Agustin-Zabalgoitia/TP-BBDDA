/*
CREATE TABLE HospitalGral.Medico (
	id_medico INT IDENTITY(0,1),
	id_especialidad INT,
	Nombre NVARCHAR(50) NOT NULL,
	Apellido NVARCHAR(50) NOT NULL,
	Nro_Matricula INT NOT NULL,
	CONSTRAINT PK_Medico_id_medico PRIMARY KEY (id_medico),
	CONSTRAINT FK_Medico_id_especialidad FOREIGN KEY (id_especialidad) REFERENCES HospitalGral.Especialidad(id_especialidad)
)
*/
USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.Medico_Alta

	@id_especialidad INT,
	@nombre NVARCHAR(50),
	@apellido NVARCHAR(50),
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

		INSERT INTO HospitalGral.Medico(id_especialidad,Nombre,Apellido,Nro_Matricula) VALUES (@id_especialidad,@nombre,@apellido,@Nro_Matricula);

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO 

CREATE OR ALTER PROCEDURE HospitalGral.Medico_Baja
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

CREATE OR ALTER PROCEDURE HospitalGral.Medico_Modificacion
	@id_medico INT,
	@campo VARCHAR(50),
	@valor VARCHAR(50)
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

		if(@campo not in ('id_medico', 'id_especialidad'))
		set @valor = '''' + @valor + '''';

		--Armo la query correspondiente
		SET @sql =	'UPDATE HospitalGral.MedicoSET ' + 
				@campo + ' = ' + convert(nvarchar(50), @valor) + 
				' where id_medico = ' + convert(varchar(50), @id_medico);

		execute sp_executesql @sql;

	END TRY
	BEGIN CATCH
		print error_message();
	END CATCH

END