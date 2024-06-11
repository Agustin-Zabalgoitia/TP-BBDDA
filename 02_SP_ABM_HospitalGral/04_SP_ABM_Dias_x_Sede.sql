-- Quiero un Store Procedure que yo le pueda mandar el id_medico, el id_sede, dia de la semana,  Hora de Inicio y Hora de Fin y que inserte en la tabla DiasxSede
-- Turnos cada 15 minutos en ese intervalo 
-- Este tmb hago baja logica

USE Com2900G06
GO

CREATE OR ALTER PROCEDURE HospitalGral.DiasxSede_AltaRango
	@id_medico int,
	@id_sede int,
	@dia_semana varchar(9),
	@hora_inicio TIME,
	@hora_fin TIME
AS
BEGIN

	BEGIN TRY
		if(len(@dia_semana)=0 OR len(@dia_semana)>9)
			THROW 50000, 'El dia ingresado es vacío o excede la longitud máxima de caracteres', 1;
		if(@dia_semana NOT IN ('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'))
			THROW 50001, 'El dia de la semana ingresado no es valido', 1;
		if exists ( SELECT 1 FROM HospitalGral.Dias_x_Sede as ds WHERE @id_medico = ds.id_medico AND @dia_semana = ds.Dia AND @id_sede <> ds.id_sede)
			THROW 50002, 'Este medico trabaja en otra sede ese dia de la semana',1;
		if exists ( SELECT 1 FROM HospitalGral.Dias_x_Sede as ds WHERE @id_medico = ds.id_medico AND @dia_semana = ds.Dia AND @id_sede = ds.id_sede AND ds.Hora_Inicio >= @hora_inicio AND ds.Hora_Inicio<= @hora_fin )
			THROW 50003, 'Verifique el rango horario especificado, el medico indicado ya tiene turnos asignados entre esas horas en esta sede',1;
	-- Bucle para insertar registros cada 15 minutos
			WHILE @hora_inicio < @hora_fin
			BEGIN
				-- Insertar el registro
				INSERT INTO HospitalGral.Dias_x_Sede (id_medico, id_sede, Dia, Hora_Inicio)
				VALUES (@id_medico, @id_sede, @dia_semana, @hora_inicio);

				-- Incrementar la hora en 15 minutos
				SET @hora_inicio = DATEADD(MINUTE, 15, @hora_inicio);
			END
	END TRY
	BEGIN CATCH
		PRINT error_message();
	END CATCH
END
GO


--Agregar verificaciones y rango horario
CREATE OR ALTER PROCEDURE HospitalGral.DiasxSede_Baja
	@id_medico INT,
	@id_sede INT,
	@dia_semana NVARCHAR(9)
AS
BEGIN
	DELETE FROM HospitalGral.Dias_x_Sede
	WHERE id_medico = @id_medico
	  AND id_sede = @id_sede
	  AND Dia = @dia_semana;
END
GO

