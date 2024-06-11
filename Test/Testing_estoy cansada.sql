-----------------------------------------------------------------	RESERVA DE TURNOS -------------------------------------------------------------------
DECLARE @id_sede INT = 3;
DECLARE @id_medico INT = 5;
DECLARE @dia DATE = '2024-06-12';
DECLARE @hora TIME = '12:15:00';
DECLARE @Dia_Semana NVARCHAR(10);
DECLARE @Dia_Semana_esp NVARCHAR(10);
--EXEC Turno.Reserva_de_Turno_Medico_Alta 1,1,1,3,2,@dia,@hora
EXEC Turno.Reserva_de_Turno_Medico_Alta 1,1,5,3,2,@dia,@hora

SET @Dia_Semana = DATENAME(WEEKDAY, @dia);

print @dia_semana;

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

SELECT * FROM HospitalGral.Dias_x_Sede WHERE id_medico = @id_medico AND id_sede = @id_sede AND Dia = @Dia_Semana_esp AND Hora_Inicio = @Hora
SELECT * FROM Turno.Reserva_de_Turno_Medico