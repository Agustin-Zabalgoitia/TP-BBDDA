USE Com2900G06

CREATE NONCLUSTERED INDEX ix_paciente_num_documento
ON Paciente.Paciente (num_documento);
GO

CREATE NONCLUSTERED INDEX ix_diasxsede_idespecialidad
ON  HospitalGral.Dias_x_Sede  (id_sede);
GO

CREATE NONCLUSTERED INDEX ix_reservaturno_idhistoriaclinica
ON  Turno.Reserva_de_Turno_Medico (id_historia_clinica);
GO