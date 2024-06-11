-- Usuarios y Login.

/* • Paciente
• Medico ->
• Personal Administrativo -> Administra determinados aspectos del hospital.
• Personal Técnico clínico -> Tenemos a los medicos, estos tienen que tener la capacidad con todo lo relacionado a los estudios.
• Administrador General */
USE Com2900G06
go
create login adminhospital -- Creo el login admin.
with password = 'adminbddhospital',
default_database = Com2900G06; -- base de datos en la que entrara directamente el login.
--check_policy = off, check_expiration = off; -- politica de expiracion de la contrasenia.

create user admin_hospital for login adminhospital -- Creo el usuario del admin.

create role adminBDDHospital -- Creo el rol especifico del admin para otorgarle "x" cantidad de permisos.

grant select, insert, update, delete on database::Com2900G06 to adminBDDHospital -- Le otorgo los permisos a ese rol en vez de a un usuario.

alter role adminBDDHospital add member admin_hospital -- Agrego el admin al rol.

grant execute on schema::Paciente to admin_hospital;
grant execute on schema::HospitalGral to admin_hospital;
grant execute on schema::Turno to admin_hospital;

-- drop user admin_hospital

-- drop role adminBDDHospital

-- drop login adminhospital

-- alter role adminBDDHospital drop member admin_hospital; En caso de querer sacar del rol al user.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Ahora que sabemos como manejar los permisos/roles, los login, y los usuarios, tenemos que ver a que puede acceder cada uno.

/* Personal Administrativo, va a poder acceder a los dias x sede y a las reservas de turno. -> Dias x sede esta en el esquema HospitalGral y Reservas de Turno en Turno.
 Pero solo pueden tener acceso a esas 2 tablas, por lo tanto, puedo obviar las demas, y en vez de darle permisos para todos los objetos del esquema, se los doy unicamente para
 esos 2 */

go
create login personal_admin
with password = 'padminhospital',
default_database = Com2900G06;

create user personal_admin for login personal_admin;

create role p_admin_rol;

grant select, insert, update, delete on schema::HospitalGral to p_admin_rol;
grant select, insert, update, delete on schema::Turno to p_admin_rol;

alter role p_admin_rol add member personal_admin;

deny update, insert, select, delete on Turno.Estado_Turno to personal_admin; 
deny update, insert, select, delete on Turno.Tipo_Turno to personal_admin; 

deny select, update, insert, delete on HospitalGral.Prestador to personal_admin;
deny select, update, insert, delete on HospitalGral.Sede_de_Atencion to personal_admin;
deny select, update, insert, delete on HospitalGral.Especialidad to personal_admin;
deny select, update, insert, delete on HospitalGral.Autorizacion_Estudios to personal_admin;
deny select, update, insert, delete on HospitalGral.Medico to personal_admin;

grant execute on HospitalGral.DiasxSede_AltaRango to personal_admin;
grant execute on HospitalGral.DiasxSede_Baja to personal_admin;
grant execute on Turno.Reserva_de_Turno_Medico_Alta to personal_admin;
grant execute on Turno.Reserva_de_Turno_Medico_Baja to personal_admin;
grant execute on Turno.Reserva_de_Turno_Medico_Modificacion to personal_admin;

-- drop user personal_admin

-- drop role p_admin_rol

--drop login personal_admin

-- alter role p_admin_rol drop member personal_admin; En caso de querer sacar del rol al user.

------------------------------------------------------------------------------------------------------------------------------------------------

/* Personal tecnico, va a poder acceder a los estudios de los pacientes para realizar cambios sobre los mismos, por lo tanto otorgaremos permisos a un unico objeto */

go
create login personal_tecnico
with password = 'ptecnico',
default_database = Com2900G06;

create user p_tecnico for login personal_tecnico;

create role p_tecnico_rol;

grant select, insert, update, delete on schema::Paciente to p_tecnico_rol;

alter role p_tecnico_rol add member p_tecnico;

deny select, update, insert, delete on Paciente.Paciente to p_tecnico;
deny select, update, insert, delete on Paciente.Usuario to p_tecnico;
deny select, update, insert, delete on Paciente.Cobertura to p_tecnico;
deny select, update, insert, delete on Paciente.Domicilio to p_tecnico;

grant execute on HospitalGral.validacion_campo_long to p_tecnico;
grant execute on Paciente.Estudio_Baja to p_tecnico;
grant execute on Paciente.Estudio_Modificacion to p_tecnico;
grant execute on Paciente.Estudio_Alta to p_tecnico;

-- drop user p_tecnico

-- drop role p_tecnico_rol

-- drop login personal_tecnico

-- alter role p_tecnico_rol drop member p_tecnico; En caso de querer sacar del rol al user.

------------------------------------------------------------------------------------------------------------------------------------------------

/* Medico, el medico puede tener acceso a sus propios datos y a los dias que se encuentra en una determinada sede, asi como tambien la hora de inicio de su turno */

go
create login medico_login
with password = 'medicologin',
default_database = Com2900G06;

create user medico_user for login medico_login;

create role medico_rol;

grant select on schema::HospitalGral to medico_rol; -- Le damos acceso de lectura a todos los objetos del esquema HospitalGral.

-- Tecnicamente solo necesita acceso a Medico y a Dias_x_Sede, pero queria probar denegarle el acceso a los demas objetos del esquema para ver como funcionaba el deny.

alter role medico_rol add member medico_user;

grant select on Turno.Reserva_de_Turno_Medico to medico_user;
deny select on HospitalGral.Prestador to medico_user;
deny select on HospitalGral.Sede_de_Atencion to medico_user;
deny select on HospitalGral.Especialidad to medico_user;
deny select on HospitalGral.Autorizacion_Estudios to medico_user;

-- drop user medico_user

-- drop role medico_rol

-- drop login medico_login

-- alter role medico_rol drop member medico_user; En caso de querer sacar del rol al user.

/* El user medico_user tendra acceso denegado a todos los demas objetos, y de HospitalGral, solo a los que no le denegamos el acceso. */

------------------------------------------------------------------------------------------------------------------------------------------------

/* Paciente, el paciente puede acceder y dar de alta reservas por turno, puede leer sus estudios, su domicilio, sus propios datos, su usuario y su cobertura. */

go
create login paciente_login
with password = 'pacientelogin',
default_database = Com2900G06;

create user paciente_user for login paciente_login;

create role paciente_rol;

grant select, update on schema::Paciente to paciente_user;
grant select, insert, update on schema::Turno to paciente_user;

alter role paciente_rol add member paciente_user;

grant select, update on Paciente.Usuario to paciente_user;

deny update on Paciente.Paciente to paciente_user;
deny update on Paciente.Estudio to paciente_user;
deny update on Paciente.Cobertura to paciente_user;
deny update on Paciente.Domicilio to paciente_user;
deny update, insert on Turno.Estado_Turno to paciente_user; 
deny update, insert on Turno.Tipo_Turno to paciente_user; 

grant execute on Paciente.Usuario_Modificacion to paciente_user;
grant execute on Turno.Reserva_de_Turno_Medico_Alta to paciente_user;
grant execute on Turno.Reserva_de_Turno_Medico_Baja to paciente_user;

-- drop user paciente_user

-- drop role paciente_rol

-- drop login paciente_login

-- alter role paciente_rol drop member paciente_user; Por si queremos sacar el rol al usuario.

-- alter login sa disable; -- Desabilitamos el sa en la bdd ya que con el login del administrador general se puede manejar toda la bdd (tomamos medidas de mayor seguridad).