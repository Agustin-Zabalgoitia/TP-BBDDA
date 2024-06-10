use [Com2900G06]
go

--Alta Turno.Estado_Turno
create or alter procedure Turno.Estado_Turno_Alta 
@Nombre_Estado nvarchar(51)
as 
begin 
	begin try
		if(len(@Nombre_Estado)=0)
			throw 50000, 'El nombre no debe estar vacio, Inserte un nombre valido.', 1;
		if(len(@Nombre_Estado)>50)
			throw 50001, 'El nombre excede la longitud maxima de 50 caracteres. Inserte otro nombre.', 1;
		if(exists (select 1 from Turno.Estado_Turno where Nombre_Estado = @Nombre_Estado))
			throw 60000, 'El registro que quiere insertar ya se encuentra en la base de datos.', 1;
		insert into Estado_Turno values (@Nombre_Estado);
	end try
	begin catch
		print error_message();
	end catch
end
go

--Baja Turno.Estado_Turno
create or alter procedure Turno.Estado_Turno_Baja 
@id_estado int
as 
begin 
	begin try
		if(not exists (select 1 from Turno.Estado_Turno where id_estado = @id_estado))
			throw 50002, 'No existe un estado de turno asociado con ese c�digo', 1;
		delete from Turno.Estado_Turno where id_estado = @id_estado;
	end try
	begin catch
		print error_message();
	end catch
end
go

--Modificacion Turno.Estado_Turno
create or alter procedure Turno.Estado_Turno_Modificacion
@id_estado int,
@Nombre_Estado nvarchar(51)
as 
begin 
	begin try
		if(not exists (select 1 from Turno.Estado_Turno where id_estado = @id_estado))
			throw 50002, 'No existe un estado de turno asociado con ese c�digo', 1;
		if(len(@Nombre_Estado)=0)
			throw 50000, 'El nombre no debe estar vacio, Inserte un nombre valido.', 1;
		if(len(@Nombre_Estado)<=50)
			update Estado_Turno 
			set Nombre_Estado = @Nombre_Estado 
			where id_estado = @id_estado;
		else
			throw 50001, 'El nombre excede la longitud maxima de 50 caracteres. Inserte otro nombre.', 1;
	end try
	begin catch
		print error_message();
	end catch
end
go