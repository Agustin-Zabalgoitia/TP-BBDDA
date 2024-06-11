use [Com2900G06]
go


-- Alta

GO
CREATE OR ALTER PROCEDURE Turno.Reserva_de_Turno_Medico_Alta @id_historia_clinica INT, @id_tipo_turno INT, @id_medico INT, @id_sede INT, @id_especialidad INT, @Fecha DATE, @Hora TIME
AS
	DECLARE @Dia_Semana NVARCHAR(10);
	DECLARE @Dia_Semana_esp NVARCHAR(10);
	DECLARE @id_estado_turno INT
BEGIN
	
	BEGIN TRY
	if not exists(select 1 from HospitalGral.Sede_de_Atencion where id_sede = @id_sede) -- La sede tiene que existir.
		throw 50000, 'Sede inexistente, no se puede dar de alta la reserva de turno medico.', 1;

	if not exists(select 1 from HospitalGral.Medico where id_medico = @id_medico) -- El medico tiene que existir.
		throw 50001, 'Medico inexistente, no se puede dar de alta la reserva del turno medico.', 1;

	if not exists(select 1 from HospitalGral.Especialidad where id_especialidad = @id_especialidad) -- La especialidad tiene que existir.
		throw 50006, 'No existe esa especialidad, no se puede dar de alta la reserva del turno medico.', 1;

	/* Si estoy aca es porque por lo menos la sede y el medico existen, ahora hay que ver que el medico sea de esa especialidad, y que el medico este en esa sede.
	y que ademas exista un medico con esa especialidad */ 

	if not exists(select 1 from HospitalGral.Medico where id_medico = @id_medico and id_especialidad = @id_especialidad) -- Si el medico que puse, no tiene esa especialidad, no puedo dar de alta la reserva.
		throw 50002, 'No existe ese medico con esa especialidad, no se puede dar de alta la reserva del turno medico.', 1;

	if not exists(select 1 from HospitalGral.Dias_x_Sede where id_medico = @id_medico and id_sede = @id_sede) -- Si el medico y la sede no coinciden, ese medico no puede atender ese turno, no puedo darlo de alta.
		throw 50003, 'No existe ese medico en esa sede, no se puede dar de alta la reserva del turno medico.', 1;
	
	/* Si estoy aca es porque el medico atiene en esa sede, y ademas tiene la especialidad que yo quiero, queda ver si la fecha y hora coinciden, y si no tengo otro turno ya previo
	para ese medico, en esa sede, con esa especialidad a esa fecha y hora. */

	/*
	if not exists(select 1 from HospitalGral.Dias_x_Sede where id_medico = @id_medico and id_sede = @id_sede and (Hora_Inicio < @hora)) -- No puedo poner una hora < a la hora en la que el medico comienza a atender.
		throw 50004, 'El medico en esa sede a ese horario aun no comenzo su turno laboral, no se puede dar de alta la reserva del turno medico.', 1;
	*/--- A lo sumo verificar si es el primero o el ultimo 

	SET @Dia_Semana = DATENAME(WEEKDAY, @fecha);


	SET @Dia_Semana_esp =
    CASE @Dia_Semana
        WHEN 'Monday' THEN 'Lunes'
        WHEN 'Tuesday' THEN 'Martes'
        WHEN 'Wednesday' THEN 'Miércoles'
        WHEN 'Thursday' THEN 'Jueves'
        WHEN 'Friday' THEN 'Viernes'
        WHEN 'Saturday' THEN 'Sábado'
        WHEN 'Sunday' THEN 'Domingo'
    END;

	if not exists(SELECT 1 FROM HospitalGral.Dias_x_Sede WHERE id_medico = @id_medico AND id_sede = @id_sede AND Dia = @Dia_Semana_esp AND Hora_Inicio = @Hora)
		throw 50000, 'El horario especificado no es uno de los turnos preestablecidos para asignar', 1;

	/* Si todo lo demas se cumplio, solo queda ver si tengo un turno para esa fecha en esa hora/intervalo de tiempo previo, en cuyo caso no podria dar de alta el turno */
	-- No esta contemplado el intervalo de tiempo todavia.

	if exists(select 1 from Turno.Reserva_de_Turno_Medico where id_medico = @id_medico and id_sede = @id_sede and fecha = @fecha and hora = @hora and (select 1 from Turno.Reserva_de_Turno_Medico where fecha = @fecha and hora = @hora and id_estado_turno = 3) = 1)
		throw 50005, 'En esa fecha y hora el medico en esa sede ya se encuentra ocupado, no se puede dar de alta la reserval del turno medico.', 1;

	SET @id_estado_turno = 3;

	INSERT INTO Turno.Reserva_de_Turno_Medico VALUES (@id_historia_clinica, @id_estado_turno, @id_tipo_turno, @id_medico, @id_sede, @id_especialidad, @Fecha, @Hora);
	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH
END;
GO

-- Baja
CREATE OR ALTER PROCEDURE Turno.Reserva_de_Turno_Medico_Baja @id_turno int
AS
BEGIN
	BEGIN TRY 
	if not exists(select 1 from Turno.Reserva_de_Turno_Medico where id_turno = @id_turno)
		throw 50000, 'El turno a dar de baja no existe, pruebe con otro id de turno.', 1;

	UPDATE Turno.Reserva_de_Turno_Medico
	SET id_estado_turno = 2 -- Hacemos un borrado logico, es decir, seteamos el estado de turno a cancelado, pero no lo borramos de nuestros registros.
	WHERE id_turno = @id_turno;

	END TRY
	
	BEGIN CATCH
		print error_message();
	END CATCH

END
GO

-- Modificacion
CREATE OR ALTER PROCEDURE Turno.Reserva_de_Turno_Medico_Modificacion @campo_a_modif varchar(20), @valor varchar(50), @id_turno int
AS
	
	declare @tabla varchar(20);
	declare @SQL nvarchar(100);

BEGIN
	BEGIN TRY
		if not exists(select 1 from Turno.Reserva_de_Turno_Medico where id_turno = @id_turno)
			throw 50000, 'El numero de turno no existe, no se puede modificar una reserva inexistente.', 1;
		
		select @tabla = 'Reserva_de_Turno_Medico';

		if not exists(select 1 from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tabla and COLUMN_NAME = @campo_a_modif COLLATE Modern_Spanish_CI_AI) 
			throw 50001, 'El campo que se quiere modificar no existe, coloce un campo valido.', 1;

	select @SQL = 'UPDATE Turno.Reserva_de_Turno_Medico SET ' + @campo_a_modif + ' = ' + @valor + ' WHERE id_turno = ' + convert(varchar(50), @id_turno)
		
	--print(@SQL);

	execute sp_executesql @sql

	END TRY
	
	BEGIN CATCH
		print error_message();
	END CATCH
END