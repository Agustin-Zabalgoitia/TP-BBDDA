use [Com2900G06]
go

--Alta Paciente.Usuario
create or alter procedure Paciente.Usuario_Alta
@id_historia_clinica int,
@contrasenia varchar(17)
as
declare @id_usuario int;
begin
	begin try
		if(not exists(select 1 from Paciente.Paciente where id_historia_clinica = @id_historia_clinica))
			throw 50000, 'El c�digo de paciente es inexistente', 1

		if(exists (select 1 from Paciente.Usuario where id_historia_clinica = @id_historia_clinica))
			throw 60000, 'El registro que quiere insertar ya se encuentra en la base de datos.', 1;
		
		if(len(@contrasenia) > 16 or len(@contrasenia) = 0)
			throw 50000, 'Contrase�a no valida, ingrese otra.', 1

		select @id_usuario = num_documento from Paciente.Paciente where id_historia_clinica = @id_historia_clinica;

		insert into Paciente.Usuario
		values (@id_usuario,
				@id_historia_clinica, 
				convert(binary(16), @contrasenia), 
				GETDATE());
	end try
	begin catch
		print error_message();
	end catch
end
go

--Baja Paciente.Usuario
create or alter procedure Paciente.Usuario_Baja
@id_usuario int
as
begin
	begin try
		if(not exists(select 1 from Paciente.Usuario where id_usuario = @id_usuario))
			throw 50000, 'El c�digo de usuario es inexistente', 1
		delete from Paciente.Usuario where id_usuario = @id_usuario
	end try
	begin catch
		print error_message();
	end catch
end
go

--Modificacion Paciente.Usuario
create or alter procedure Paciente.Usuario_Modificacion
    @id_usuario int,
    @Contrasenia nvarchar(17)
as
begin
	begin try
		if(not exists(select 1 from Paciente.Usuario where id_usuario = @id_usuario))
			throw 50000, 'El c�digo de usuario es inexistente', 1
		if(len(@contrasenia) > 16 or len(@contrasenia) = 0)
			throw 50000, 'Contrase�a no valida, ingrese otra.', 1

		update Paciente.Usuario set Contrasenia = convert(binary(16), @Contrasenia) where id_usuario = @id_usuario
	end try
	begin catch
		print error_message();
	end catch
end
go