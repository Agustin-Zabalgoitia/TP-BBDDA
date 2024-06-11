use [Com2900G06]
go

--Alta HospitalGral.Especialidad
create or alter procedure HospitalGral.Especialidad_Alta
@Nombre_Especialidad NVARCHAR(51)
as
begin
	begin try
		if(len(@Nombre_Especialidad)>50 or len(@Nombre_Especialidad)=0)
			throw 50000, 'El nombre de la especialidad no tiene el la longitud correcta, ingrese nuevamente.', 1
		if(exists (select 1 from HospitalGral.Especialidad where Nombre_Especialidad = @Nombre_Especialidad))
			throw 60000, 'El registro que quiere insertar ya se encuentra en la base de datos.', 1;
		insert into HospitalGral.Especialidad values (@Nombre_Especialidad);
	end try
	begin catch
		print error_message();
	end catch
end
go

--Baja HospitalGral.Especialidad
create or alter procedure HospitalGral.Especialidad_Baja
@id_especialidad int
as
begin
	begin try
		if(not exists (select 1 from HospitalGral.Especialidad where id_especialidad = @id_especialidad))
				throw 50000, 'El codigo de especialidad es inexistente.', 1
		delete from HospitalGral.Especialidad where id_especialidad = @id_especialidad;
	end try
begin catch
	print error_message();
end catch
end
go

--Modificacion HospitalGral.Especialidad
create or alter procedure HospitalGral.Especialidad_Modificacion
@id_especialidad int,
@Nombre_Especialidad nvarchar(51)
as
begin
	begin try
			if not exists(select 1 from HospitalGral.Especialidad where id_especialidad = @id_especialidad)
				throw 50000, 'El codigo de especialidad es inexistente.', 1;

			if exists(select 1 from HospitalGral.Especialidad where Nombre_Especialidad = @Nombre_Especialidad)
				throw 50000, 'Ese registro ya se encuentra en la base de datos.', 1;

			if(len(@Nombre_Especialidad)>50 or len(@Nombre_Especialidad)=0)
				throw 50000, 'El nombre de la especialidad no tiene el la longitud correcta, ingrese nuevamente.', 1


			update HospitalGral.Especialidad 
			set Nombre_Especialidad = @Nombre_Especialidad 
			where id_especialidad = @id_especialidad;
	end try
begin catch
	print error_message();
end catch
end

