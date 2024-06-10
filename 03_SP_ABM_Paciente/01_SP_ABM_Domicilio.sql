use [Com2900G06]
go

--Alta Paciente.Domicilio
create or alter procedure Paciente.Domicilio_Alta
    @Calle_Nro varchar(51),
	@Piso int,
	@Departamento char(1),
	@Codigo_Postal int,
	@Pais varchar(51),
	@Provincia varchar(51),
	@Localidad varchar(51)
as
	declare @campo_error nvarchar(100);
	declare @mensaje_error nvarchar(110);
begin
	begin try
		if(exists (select 1 from Paciente.Domicilio
		where Calle_Nro = @Calle_Nro and
				Piso = @Piso and
				Departamento = @Departamento and
				Codigo_Postal = @Codigo_Postal and
				Pais = @Pais and
				Provincia = @Provincia and
				Localidad = @Localidad))
		throw 60000, 'El registro que quiere insertar ya se encuentra en la base de datos.', 1;

		--Validaciones de campos
		set @campo_error = ''

		if(len(@Calle_Nro)>50)
			set @campo_error += '[Num. Calle] ';
		if(len(@Pais)>50)
			set @campo_error += '[Pais] ';
		if(len(@Provincia)>50)
			set @campo_error += '[Provincia] ';
		if(len(@Localidad)>50)
			set @campo_error += '[Localidad] ';
		set @mensaje_error = 'Los siguientes campos no tienen la longitud adecuada: [ ' + @campo_error + ' ]';

		if(len(@campo_error)>0)
			throw 50000, @mensaje_error, 1;

		--Insercci�n de datos
		insert into Paciente.Domicilio 
		values (@Calle_Nro, @Piso, @Departamento, @Codigo_Postal, @Pais, @Provincia, @Localidad);

	end try
	begin catch
		print error_message();
	end catch
end
go

--Baja Paciente.Domicilio
create or alter procedure Paciente.Domicilio_Baja
    @id_domicilio int
as
begin
	begin try
		if(not exists(select 1 from Paciente.Domicilio where id_domicilio = @id_domicilio))
			throw 50000, 'El c�digo del domicilio es inexistente', 1;
		delete from Paciente.Domicilio where id_domicilio = @id_domicilio
	end try
	begin catch
		print error_message();
	end catch
end
go

--Modificacion Paciente.Domicilio
create or alter procedure Paciente.Domicilio_Modificacion
    @id_domicilio int,
	@Calle_Nro nvarchar(51),
	@Piso int,
	@Departamento char(1),
	@Codigo_Postal int,
	@Pais nvarchar(51),
	@Provincia nvarchar(51),
	@Localidad nvarchar(51)
as
	declare @campo_error nvarchar(100);
	declare @mensaje_error nvarchar(110);
begin
	begin try
		--Validaciones de campos
		set @campo_error = ''

		if(len(@Calle_Nro)>50)
			set @campo_error += '[Num. Calle] ';
		if(len(@Pais)>50)
			set @campo_error += '[Pais] ';
		if(len(@Provincia)>50)
			set @campo_error += '[Provincia] ';
		if(len(@Localidad)>50)
			set @campo_error += '[Localidad] ';
		set @mensaje_error = 'Los siguientes campos no tienen la longitud adecuada: [ ' + @campo_error + ' ]';

		if(len(@campo_error)>0)
			throw 50000, @mensaje_error, 1;

		--Actualizaci�n de datos
		update Paciente.Domicilio 
		set Calle_Nro = @Calle_Nro, Piso = @Piso, Departamento = @Departamento, Codigo_Postal = @Codigo_Postal,
			Pais = @Pais, Provincia = @Provincia, Localidad = @Localidad
		where id_domicilio = @id_domicilio

	end try
	begin catch
		print error_message();
	end catch
end
go