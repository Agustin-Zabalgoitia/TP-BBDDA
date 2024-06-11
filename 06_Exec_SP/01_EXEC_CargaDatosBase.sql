USE Com2900G06
GO
------------------------------------------------------HOSPITAL GRAL--------------------------------------------------------
---Prestador (Importado CSV)
--Sede de Atencion (Importado CSV)
--Especialidad (Importado CSV Medicos)
--Medico (Importado CSV)
--Autorizacion_Estudios (Importado JSON)

--- DIAS X SEDE 
DECLARE @hora_ini TIME = '08:00:00';
DECLARE @hora_fin TIME = '12:00:00';
EXEC HospitalGral.DiasxSede_AltaRango 0,0,'Lunes',@hora_ini,@hora_fin

SET @hora_ini = '08:00:00'; SET @hora_fin = '14:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 1,1,'Martes',@hora_ini,@hora_fin

SET @hora_ini = '12:00:00'; SET @hora_fin = '17:30:00'
EXEC HospitalGral.DiasxSede_AltaRango 5,3,'Miércoles', @hora_ini, @hora_fin

SET @hora_ini = '14:00:00'; SET @hora_fin = '17:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 11,2,'Jueves',@hora_ini,@hora_fin --Derma

SET @hora_ini = '14:00:00'; SET @hora_fin = '17:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 14,4,'Jueves',@hora_ini,@hora_fin --Endo

SET @hora_ini = '14:00:00'; SET @hora_fin = '17:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 14,4,'Viernes',@hora_ini,@hora_fin --Endo

SET @hora_ini = '14:00:00'; SET @hora_fin = '17:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 17,5,'Sabado',@hora_ini,@hora_fin --Fono

SET @hora_ini = '12:00:00'; SET @hora_fin = '17:30:00'
EXEC HospitalGral.DiasxSede_AltaRango 20,6,'Sabado',@hora_ini,@hora_fin --Gastro

SET @hora_ini = '08:00:00'; SET @hora_fin = '15:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 24,7,'Lunes',@hora_ini,@hora_fin --Gine

SET @hora_ini = '08:00:00'; SET @hora_fin = '15:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 27,8,'Martes',@hora_ini,@hora_fin --Hepa

SET @hora_ini = '14:00:00'; SET @hora_fin = '17:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 29,9,'Miercoles',@hora_ini,@hora_fin --Kine

SET @hora_ini = '08:00:00'; SET @hora_fin = '15:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 31,10,'Jueves',@hora_ini,@hora_fin --MedFam

SET @hora_ini = '08:00:00'; SET @hora_fin = '15:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 42,11,'Viernes',@hora_ini,@hora_fin --Neuro

SET @hora_ini = '12:00:00'; SET @hora_fin = '17:30:00'
EXEC HospitalGral.DiasxSede_AltaRango 45,12,'Sabado',@hora_ini,@hora_fin --Nutri

SET @hora_ini = '08:00:00'; SET @hora_fin = '15:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 49,12,'Viernes',@hora_ini,@hora_fin --Obstre

SET @hora_ini = '12:00:00'; SET @hora_fin = '17:30:00'
EXEC HospitalGral.DiasxSede_AltaRango 53,13,'Sabado',@hora_ini,@hora_fin --Ofta

SET @hora_ini = '08:00:00'; SET @hora_fin = '15:00:00'
EXEC HospitalGral.DiasxSede_AltaRango 56,12,'Lunes',@hora_ini,@hora_fin --Traumato

SET @hora_ini = '12:00:00'; SET @hora_fin = '17:30:00'
EXEC HospitalGral.DiasxSede_AltaRango 60,14,'Sabado',@hora_ini,@hora_fin --Uro



--------------------------------------------------------PACIENTE-----------------------------------------------------------

--Paciente Cobertura ->COMPLETAR
--SELECT * FROM Paciente.Cobertura

DECLARE @dia_hoy DATE = GETDATE();

EXEC Paciente.Cobertura_Alta 0,0,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1234, @dia_hoy
EXEC Paciente.Cobertura_Alta 1,1,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1235, @dia_hoy
EXEC Paciente.Cobertura_Alta 2,2,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1236, @dia_hoy
EXEC Paciente.Cobertura_Alta 3,3,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1237, @dia_hoy
EXEC Paciente.Cobertura_Alta 4,4,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1238, @dia_hoy
EXEC Paciente.Cobertura_Alta 5,5,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1239, @dia_hoy
EXEC Paciente.Cobertura_Alta 6,6,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1204, @dia_hoy
EXEC Paciente.Cobertura_Alta 7,7,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1214, @dia_hoy
EXEC Paciente.Cobertura_Alta 8,8,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1224, @dia_hoy
EXEC Paciente.Cobertura_Alta 9,9,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1234, @dia_hoy
EXEC Paciente.Cobertura_Alta 10,10,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1244, @dia_hoy
EXEC Paciente.Cobertura_Alta 11,11,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1254, @dia_hoy
EXEC Paciente.Cobertura_Alta 12,12,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1264, @dia_hoy
EXEC Paciente.Cobertura_Alta 13,13,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1274, @dia_hoy
EXEC Paciente.Cobertura_Alta 14,14,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1284, @dia_hoy
EXEC Paciente.Cobertura_Alta 15,15,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1294, @dia_hoy
EXEC Paciente.Cobertura_Alta 16,16,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1034, @dia_hoy
EXEC Paciente.Cobertura_Alta 17,17,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1134, @dia_hoy
EXEC Paciente.Cobertura_Alta 18,18,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1734, @dia_hoy
EXEC Paciente.Cobertura_Alta 19,19,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1834, @dia_hoy
EXEC Paciente.Cobertura_Alta 20,20,'https://preview.redd.it/47wpfhrnsc9c1.jpeg?auto=webp&s=516099b0b14e0fb1802ae41423da9325d149461c', 1934, @dia_hoy


--Update de coberturas
UPDATE Paciente.Paciente
SET id_cobertura = (
    SELECT c.id_cobertura
    FROM Paciente.Cobertura c
    WHERE c.id_historia_clinica = Paciente.Paciente.id_historia_clinica
);

--SELECT * From Paciente.Paciente

--Paciente Domicilio (Importado Paciente CSV)
--Paciente Paciente (Importado CSV)
--Paciente Estudio -> COMPLETAR
--Paciente Usuario -> COMPLETAR  (podria darle de alta el usuario al importar y dar de alta)

EXEC Paciente.Usuario_Alta 0,'abc123'
EXEC Paciente.Usuario_Alta 1,'abc123'
EXEC Paciente.Usuario_Alta 2,'abc123'
EXEC Paciente.Usuario_Alta 3,'abc123'
EXEC Paciente.Usuario_Alta 4,'abc123'
EXEC Paciente.Usuario_Alta 5,'abc123'
EXEC Paciente.Usuario_Alta 6,'abc123'
EXEC Paciente.Usuario_Alta 7,'abc123'
EXEC Paciente.Usuario_Alta 8,'abc123'
EXEC Paciente.Usuario_Alta 9,'abc123'





----------------------------------------------------------TURNO------------------------------------------------------------

--Estado Turno
EXEC Turno.Estado_Turno_Alta 'Atendido'
EXEC Turno.Estado_Turno_Alta 'Ausente'
EXEC Turno.Estado_Turno_Alta 'Cancelado'
EXEC Turno.Estado_Turno_Alta 'Reservado' 

-- Tipo Turno
EXEC Turno.Tipo_Turno_Alta 'Presencial'
EXEC Turno.Tipo_Turno_Alta 'Virtual'

--Reservas de Turno
--SELECT * FROM Turno.Reserva_de_Turno_Medico

DECLARE @fecha_res DATE;
DECLARE @hora TIME;

SET @fecha_res = '2024-06-10'; SET @hora='08:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 0,1,0,0,0,@fecha_res,@hora

SET @fecha_res = '2024-06-11'; SET @hora='08:45:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 1,1,1,1,1,@fecha_res,@hora

SET @fecha_res = '2024-06-12'; SET @hora='16:00:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 2,1,5,3,2,@fecha_res,@hora

SET @fecha_res = '2024-06-13'; SET @hora='14:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 3,1,11,2,3,@fecha_res,@hora

SET @fecha_res = '2024-06-14'; SET @hora='15:00:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 4,1,14,4,4,@fecha_res,@hora

SET @fecha_res = '2024-06-15'; SET @hora='16:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 5,1,17,5,5,@fecha_res,@hora

SET @fecha_res = '2024-06-15'; SET @hora='12:15:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 6,1,20,6,6,@fecha_res,@hora

SET @fecha_res = '2024-06-10'; SET @hora='08:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 7,1,24,7,7,@fecha_res,@hora

SET @fecha_res = '2024-06-11'; SET @hora='08:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 8,1,27,8,8,@fecha_res,@hora

SET @fecha_res = '2024-06-12'; SET @hora='14:00:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 9,1,29,9,9,@fecha_res,@hora

SET @fecha_res = '2024-06-13'; SET @hora='14:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 10,1,31,10,10,@fecha_res,@hora

SET @fecha_res = '2024-06-14'; SET @hora='08:15:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 11,1,42,11,11,@fecha_res,@hora

SET @fecha_res = '2024-06-15'; SET @hora='13:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 12,1,45,12,12,@fecha_res,@hora

SET @fecha_res = '2024-06-14'; SET @hora='08:15:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 13,1,49,12,13,@fecha_res,@hora

SET @fecha_res = '2024-06-12'; SET @hora='15:45:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 14,1,5,3,2,@fecha_res,@hora

SET @fecha_res = '2024-06-15'; SET @hora='12:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 15,1,53,13,14,@fecha_res,@hora

SET @fecha_res = '2024-06-10'; SET @hora='11:15:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 16,1,56,12,15,@fecha_res,@hora

SET @fecha_res = '2024-06-15'; SET @hora='14:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 17,1,60,14,16,@fecha_res,@hora

SET @fecha_res = '2024-06-10'; SET @hora='09:45:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 18,1,0,0,0,@fecha_res,@hora

SET @fecha_res = '2024-06-11'; SET @hora='09:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 19,1,1,1,1,@fecha_res,@hora

SET @fecha_res = '2024-06-10'; SET @hora='09:30:00'
EXEC Turno.Reserva_de_Turno_Medico_Alta 20,1,0,0,0,@fecha_res,@hora

UPDATE Turno.Reserva_de_Turno_Medico
SET id_estado_turno = 0
WHERE Fecha < CAST(GETDATE() AS DATE);