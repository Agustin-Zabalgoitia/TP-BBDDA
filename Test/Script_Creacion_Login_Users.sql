-- Usuarios y Login.

/* • Paciente
• Medico ->
• Personal Administrativo -> Administra determinados aspectos del hospital.
• Personal Técnico clínico -> Tenemos a los medicos, estos tienen que tener la capacidad con todo lo relacionado a los estudios.
• Administrador General */
use Com2900G06
GO

create login adminhospital -- Creo el login admin.
with password = 'adminbddhospital',
default_database = Com2900G06; -- base de datos en la que entrara directamente el login.
--check_policy = off, check_expiration = off; -- politica de expiracion de la contrasenia.

create user admin_hospital for login adminhospital -- Creo el usuario del admin.

create role adminBDDHospital -- Creo el rol especifico del admin para otorgarle "x" cantidad de permisos.

grant select, insert, update, delete on database::Com2900G06 to adminBDDHospital -- Le otorgo los permisos a ese rol en vez de a un usuario.

alter role adminBDDHospital add member admin_hospital -- Agrego el admin al rol.

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

deny update, insert, select, delete on Turno.Estado_Turno to paciente_user; 
deny update, insert, select, delete on Turno.Tipo_Turno to paciente_user; 

deny select, update, insert, delete on HospitalGral.Prestador to medico_rol;
deny select, update, insert, delete on HospitalGral.Sede_de_Atencion to medico_rol;
deny select, update, insert, delete on HospitalGral.Especialidad to medico_rol;
deny select, update, insert, delete on HospitalGral.Autorizacion_Estudios to medico_rol;
deny select, update, insert, delete on HospitalGral.Medico to medico_rol;

alter role p_admin_rol add member personal_admin;

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

deny select, update, insert, delete on Paciente.Paciente to paciente_user;
deny select, update, insert, delete on Paciente.Usuario to paciente_user;
deny select, update, insert, delete on Paciente.Cobertura to paciente_user;
deny select, update, insert, delete on Paciente.Domicilio to paciente_user;

alter role p_tecnico_rol add member p_tecnico;

-- alter role p_tecnico_rol add member p_tecnico; En caso de querer sacar del rol al user.

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

deny select on HospitalGral.Prestador to medico_rol;
deny select on HospitalGral.Sede_de_Atencion to medico_rol;
deny select on HospitalGral.Especialidad to medico_rol;
deny select on HospitalGral.Autorizacion_Estudios to medico_rol;

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

deny update on Paciente.Paciente to paciente_user;
deny update on Paciente.Estudio to paciente_user;
deny update on Paciente.Cobertura to paciente_user;
deny update on Paciente.Domicilio to paciente_user;
deny update, insert on Turno.Estado_Turno to paciente_user; 
deny update, insert on Turno.Tipo_Turno to paciente_user; 

alter role paciente_rol add member paciente_user;

-- alter login sa disable; -- Desabilitamos el sa en la bdd ya que con el login del administrador general se puede manejar toda la bdd (tomamos medidas de mayor seguridad).