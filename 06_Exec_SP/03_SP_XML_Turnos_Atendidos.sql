go
create or alter procedure HospitalGral.generar_xml_turnos @Obra_Social nvarchar(50), @Fecha_ini DATE, @Fecha_fin DATE
AS
BEGIN
	BEGIN TRY
		if not exists(select 1 from HospitalGral.Prestador where Nombre_Prestador = @Obra_Social)
			throw 50000, 'La obra social no existe.', 1;

			/*  Adicionalmente se requiere que el sistema sea capaz de generar un archivo XML detallando
		    los turnos atendidos para informar a la Obra Social. El mismo debe constar de los datos del
			paciente (Apellido, nombre, DNI), nombre y matrícula del profesional que lo atendió, fecha,
			hora, especialidad. Los parámetros de entrada son el nombre de la obra social y un intervalo
			de fechas. */

			SELECT 
			p.Apellido AS Apellido_Paciente,
			p.Nombre AS Nombre_Paciente,
			p.num_documento as DNI,
			m.Nro_Matricula as Matricula,
			t.Fecha as Fecha,
			t.Hora as Hora,
			e.Nombre_Especialidad as Especialidad
		FROM 
			Turno.Reserva_de_Turno_Medico t
		JOIN 
			Paciente.Paciente p ON t.id_historia_clinica = p.id_historia_clinica
		JOIN 
			HospitalGral.Medico m ON t.id_medico = m.id_medico
		JOIN 
			HospitalGral.Especialidad e ON t.id_especialidad = e.id_especialidad
		JOIN 
			Paciente.Cobertura c ON p.id_cobertura = c.id_cobertura
		JOIN 
			HospitalGral.Prestador pr ON c.id_prestador = pr.id_prestador
		
		where pr.Nombre_Prestador = @Obra_Social and (t.Fecha between @Fecha_ini and @Fecha_fin) and t.id_estado_turno = 0
		--FOR XML AUTO, ELEMENTS, ROOT('Turnos');
		FOR XML PATH ('Turnos'), TYPE

	END TRY

	BEGIN CATCH
		print error_message();
	END CATCH
END
GO
-- OSDE -> Obra social.

exec HospitalGral.generar_xml_turnos 'OSDE', '1993-01-01', '2050-01-01'

