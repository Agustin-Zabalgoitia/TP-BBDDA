use [Com2900_G06]
go

--Alta Paciente.Paciente
create or alter procedure Paciente.Paciente_Alta
@tipo_documento nvarchar(51),
@num_documento nvarchar(9),
@id_cobertura int,
@Nombre nvarchar(51),
@Apellido nvarchar(51),
@Apellido_Materno nvarchar(51),
@Fecha_De_Nacimiento date,
@Sexo_Biologico varchar(11),
@Genero varchar(11),
@Nacionalidad nvarchar(51),
@Foto_perfil nvarchar(91),
@Mail nvarchar(51),
@Telefono_Fijo nvarchar(16),
@Telefono_de_Contacto_Alternativo nvarchar(16),
@Telefono_Laboral nvarchar(16),
@Fecha_de_Registro date,
@Fecha_de_Actualizacion date,
@Usuario_Actualizaci�n int,
@id_domicilio int
as
declare @campo_error nvarchar(1000);
declare @mensaje_error nvarchar(1000);
begin
	begin try
		--Registro duplicado
		if(exists (select 1 from Paciente.Paciente where 
					tipo_documento = @tipo_documento and
					num_documento = @num_documento and
					id_cobertura = @id_cobertura and
					Nombre = @Nombre and
					Apellido = @Apellido and
					Apellido_Materno = @Apellido_Materno and
					Fecha_De_Nacimiento = @Fecha_De_Nacimiento and
					Sexo_Biologico = @Sexo_Biologico and
					Genero = @Genero and
					Nacionalidad = @Nacionalidad and
					Foto_perfil = @Foto_perfil and
					Mail = @Mail and
					Telefono_Fijo = @Telefono_Fijo and
					Telefono_de_Contacto_Alternativo = @Telefono_de_Contacto_Alternativo and
					Telefono_Laboral = @Telefono_Laboral and
					Fecha_de_Registro = @Fecha_de_Registro and
					Fecha_de_Actualizacion = @Fecha_de_Actualizacion and
					Usuario_Actualizaci�n = @Usuario_Actualizaci�n and
					id_domicilio = @id_domicilio
					))
			throw 60000, 'El registro que quiere insertar ya se encuentra en la base de datos.', 1;

		set @campo_error = '';

		--Validaci�n de codigos
		if(not exists (select 1 from Paciente.Cobertura where id_cobertura = @id_cobertura))
			throw 50000, 'El paciente no tiene una cobertura valida.', 1
		if(not exists (select 1 from Paciente.Domicilio where id_domicilio = @id_domicilio))
			throw 50000, 'El paciente no tiene un domicilio valido.', 1
	
		--Validaci�n de formatos
		if(len(@tipo_documento)>50 or len(@tipo_documento)=0)
			set @campo_error += ('[Tipo documento]'+ char(10));
		if(len(@num_documento)>8 or len(@num_documento)=0)
			set @campo_error += ('[num. documento]'+ char(10));
		if(len(@Nombre)>50 or len(@Nombre)=0)
			set @campo_error += ('[Nombre]'+ char(10));
		if(len(@Apellido)>50 or len(@Apellido)=0)
			set @campo_error += ('[Apellido]'+ char(10));
		if(len(@Apellido_Materno)>50 or len(@Apellido_Materno)=0)
			set @campo_error += ('[Apellido Materno]'+ char(10));
		if(len(@Sexo_Biologico)>11 or len(@Sexo_Biologico)=0)
			set @campo_error += ('[Sexo Biologico]'+ char(10));
		if(len(@Genero)>11 or len(@Genero)=0)
			set @campo_error += ('[Genero]'+ char(10));
		if(len(@Nacionalidad)>50 or len(@Nacionalidad)=0)
			set @campo_error += ('[Nacionalidad]'+ char(10));
		if(len(@Foto_perfil)>90 or len(@Foto_perfil)=0)
			set @campo_error += ('[Foto perfil]'+ char(10));
		if(len(@Mail)>50 or len(@Mail)=0)
			set @campo_error += ('[Mail]'+ char(10));
		if(len(@Telefono_Fijo)>15 or len(@Telefono_Fijo)=0)
			set @campo_error += ('[Telefono Fijo]'+ char(10));
		if(len(@Telefono_de_Contacto_Alternativo)>15 or len(@Telefono_de_Contacto_Alternativo)=0)
			set @campo_error += ('[Telefono de Contacto Alternativo]'+ char(10));
		if(len(@Telefono_Laboral)>15 or len(@Telefono_Laboral)=0)
			set @campo_error += ('[Telefono Laboral]'+ char(10));

		set @mensaje_error = 'Los siguientes campos no tienen la longitud adecuada:' + char(10) + @campo_error;

		if(len(@campo_error)>0)
			throw 50000, @mensaje_error, 1;

		INSERT INTO Paciente.Paciente
		VALUES(	@tipo_documento,@num_documento,@id_cobertura,@Nombre,@Apellido,@Apellido_Materno,
				@Fecha_De_Nacimiento,@Sexo_Biologico,@Genero,@Nacionalidad,@Foto_perfil,@Mail,
				@Telefono_Fijo,@Telefono_de_Contacto_Alternativo,@Telefono_Laboral,@Fecha_de_Registro,
				@Fecha_de_Actualizacion,@Usuario_Actualizaci�n,@id_domicilio);
	end try
	begin catch
		print error_message();
	end catch
end
go

--Baja Paciente.Paciente
create or alter procedure Paciente.Paciente_Baja 
@id_historia_clinica int
as
begin
	begin try
		--Valido la existencia del paciente
		if(not exists(select 1 from Paciente.Paciente where id_historia_clinica = @id_historia_clinica))
			throw 50000, 'El c�digo ingresado no existe', 1;
		delete from Paciente.Paciente where id_historia_clinica = @id_historia_clinica
	end try
	begin catch
		print error_message();
	end catch
end
go

--Modificacion Paciente.Paciente
CREATE OR ALTER PROCEDURE Paciente.Paciente_Modificacion
    @id_historia_clinica int,
    @campo NVARCHAR(50),
    @valor NVARCHAR(55)
AS

    DECLARE @sql NVARCHAR(500);
	DECLARE @tabla varchar(20);
	DECLARE @response nvarchar(35);
BEGIN
	begin try
	
	--Valido la existencia del paciente
	if(not exists(select 1 from Paciente.Paciente where id_historia_clinica = @id_historia_clinica))
		throw 50000, 'El codigo ingresado no existe', 1;

	set @tabla = 'Paciente';
	set @response = HospitalGral.validacion_campo_long(@tabla, @campo, @valor);
	
	--Valido si el campo es valido y si la longitud es la adecuada
	if(@response is not null)
		throw 50000, @response, 1

	--Valido que existan las ID's correspondientes
    if(@campo COLLATE Latin1_General_CI_AS = 'id_cobertura' and not exists (select 1 from Paciente.Cobertura where id_cobertura = convert(int, @valor)))
        throw 50000, 'El paciente no tiene una cobertura valida.', 1
    if(@campo  COLLATE Latin1_General_CI_AS = 'id_domicilio' and not exists (select 1 from Paciente.Domicilio where id_domicilio = convert(int, @valor)))
        throw 50000, 'El paciente no tiene un domicilio valido.', 1

    --Si no es un numero necesita comillas
	if(@campo not in ('id_cobertura', 'id_domicilio'))
		set @valor = '''' + @valor + '''';

	--Armo la query correspondiente
    SET @sql =	'UPDATE Paciente.Paciente SET ' + 
				@campo + ' = ' + convert(nvarchar(55), @valor) + 
				' where id_historia_clinica = ' + convert(varchar(50), @id_historia_clinica);

    -- Ejecutar el SQL din�mico (print es para testeo)
	--print @sql
	execute sp_executesql @sql;

	end try
	begin catch
		print error_message();
	end catch
END
GO