use [Com2900G06]
go

--Alta Turno.Tipo_Turno
create or alter procedure Turno.Tipo_Turno_Alta 
@Nombre_Del_Tipo_de_Turno nvarchar(51)
as 
begin 
	begin try
		if(len(@Nombre_Del_Tipo_de_Turno)=0)
			throw 50000, 'El nombre no debe estar vacio, Inserte un nombre valido.', 1;
		if(len(@Nombre_Del_Tipo_de_Turno)>50)
			throw 50001, 'El nombre excede la longitud maxima de 50 caracteres. Inserte otro nombre.', 1;
		if(exists (select 1 from Turno.Tipo_Turno where Nombre_del_Tipo_de_Turno = @Nombre_Del_Tipo_de_Turno))
			throw 60000, 'El registro que quiere insertar ya se encuentra en la base de datos.', 1;
		insert into Tipo_Turno values (@Nombre_Del_Tipo_de_Turno);
	end try
	begin catch
		print error_message();
	end catch
end
go

--Baja Turno.Tipo_Turno
create or alter procedure Turno.Tipo_Turno_Baja 
@id_tipo_turno int
as 
begin 
	begin try
		if(not exists (select 1 from Turno.Tipo_Turno where id_tipo_turno = @id_tipo_turno))
			throw 50002, 'No existe un tipo de turno asociado con ese c�digo', 1;
		delete from Turno.Tipo_Turno where id_tipo_turno = @id_tipo_turno;
	end try
	begin catch
		print error_message();
	end catch
end
go

--Modificacion Turno.Tipo_Turno
create or alter procedure Turno.Tipo_Turno_Modificacion
@id_tipo_turno int,
@Nombre_Del_Tipo_de_Turno nvarchar(51)
as 
begin 
	begin try
		if(not exists (select 1 from Turno.Tipo_Turno where id_tipo_turno = @id_tipo_turno))
			throw 50002, 'No existe un tipo de turno asociado con ese c�digo', 1;
		if(len(@Nombre_Del_Tipo_de_Turno)=0)
			throw 50000, 'El nombre no debe estar vacio, Inserte un nombre valido.', 1;
		if(len(@Nombre_Del_Tipo_de_Turno)<=50)
			update Tipo_Turno 
			set Nombre_del_Tipo_de_Turno = @Nombre_Del_Tipo_de_Turno 
			where id_tipo_turno = @id_tipo_turno;
		else
			throw 50001, 'El nombre excede la longitud maxima de 50 caracteres. Inserte otro nombre.', 1;
	end try
	begin catch
		print error_message();
	end catch
end
go