USE Com2900G06
GO

EXEC HospitalGral.Sede_de_Atencion_importar_CSV 'C:\Users\Florencia\Documents\Facultad\PLAN2023\3641-BasesdeDatosAplicada\Com2900_Grupo06_Entrega03\Dataset\Sedes.csv'
SELECT * FROM HospitalGral.Sede_de_Atencion
GO

EXEC HospitalGral.Prestador_importar_CSV 'C:\Users\Florencia\Documents\Facultad\PLAN2023\3641-BasesdeDatosAplicada\Com2900_Grupo06_Entrega03\Dataset\Prestador.csv'
SELECT * FROM HospitalGral.Prestador
GO

EXEC HospitalGral.Medico_importar_CSV 'C:\Users\Florencia\Documents\Facultad\PLAN2023\3641-BasesdeDatosAplicada\Com2900_Grupo06_Entrega03\Dataset\Medicos.csv'
SELECT * FROM HospitalGral.Medico
GO

EXEC Paciente.Paciente_importar_CSV 'C:\Users\Florencia\Documents\Facultad\PLAN2023\3641-BasesdeDatosAplicada\Com2900_Grupo06_Entrega03\Dataset\Pacientes.csv'
SELECT * FROM Paciente.Paciente
GO

EXEC HospitalGral.Autorizacion_estudios_importar_JSON 'C:\Users\Florencia\Documents\Facultad\PLAN2023\3641-BasesdeDatosAplicada\Com2900_Grupo06_Entrega03\Dataset\Centro_Autorizaciones.Estudios clinicos.json'
SELECT * FROM HospitalGral.Autorizacion_Estudios
GO