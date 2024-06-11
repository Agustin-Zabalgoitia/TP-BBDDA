--MEDICOS ESPECIALIDAD
--SELECT m.id_medico, m.nombre, m.Apellido, m.nro_matricula, e.nombre_especialidad FROM HospitalGral.Medico m JOIN HospitalGral.Especialidad e ON m.id_especialidad = e.id_especialidad

--DIAS C X SEDE
--Capaz hago una vista con esto
SELECT 
	e.id_especialidad,
	e.Nombre_Especialidad,
	m.id_medico,
	m.Apellido,
	s.id_sede,
	s.Nombre_de_la_Sede,
    d.Dia,
    d.Hora_Inicio
     
FROM 
    HospitalGral.Dias_x_Sede d
JOIN 
    HospitalGral.Medico m ON d.id_medico = m.id_medico
JOIN 
    HospitalGral.Sede_de_Atencion s ON d.id_sede = s.id_sede
JOIN 
    HospitalGral.Especialidad e ON m.id_especialidad = e.id_especialidad;


--RESERVA DE TURNO

SELECT 
    t.id_turno,
    t.Fecha,
    t.Hora,
	p.id_historia_clinica,
    p.Nombre AS Nombre_Paciente,
    p.Apellido AS Apellido_Paciente,
    est.Nombre_Estado,
    tt.Nombre_del_Tipo_de_Turno,
    m.Apellido AS Medico,
    s.Nombre_de_la_Sede,
    e.Nombre_Especialidad,
	pr.id_prestador,
    pr.Nombre_Prestador,
    pr.Plan_Prestador
FROM 
    Turno.Reserva_de_Turno_Medico t
JOIN 
    Paciente.Paciente p ON t.id_historia_clinica = p.id_historia_clinica
JOIN 
    Turno.Estado_Turno est ON t.id_estado_turno = est.id_estado
JOIN 
    Turno.Tipo_Turno tt ON t.id_tipo_turno = tt.id_tipo_turno
JOIN 
    HospitalGral.Medico m ON t.id_medico = m.id_medico
JOIN 
    HospitalGral.Sede_de_Atencion s ON t.id_sede = s.id_sede
JOIN 
    HospitalGral.Especialidad e ON t.id_especialidad = e.id_especialidad
JOIN 
    Paciente.Cobertura c ON p.id_cobertura = c.id_cobertura
JOIN 
    HospitalGral.Prestador pr ON c.id_prestador = pr.id_prestador;


SELECT * FROM Turno.Reserva_de_Turno_Medico

*/

SELECT * FROM Paciente.Paciente
SELECT * FROM HospitalGral.Prestador --20
SELECT * FROM Paciente.Cobertura