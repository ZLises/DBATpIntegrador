---------------
use master
go

CREATE LOGIN SupervisorRRHH 
with password = 'superrhh'

CREATE LOGIN EmpleadoRRHH 
with password = 'empleadorrhh'

CREATE LOGIN SupervisorVenta 
with password = 'superrventa'

CREATE LOGIN EmpleadoVenta 
with password = 'empleadoventa'

CREATE LOGIN SupervisorAdministracion 
with password = 'superradministracion'

CREATE LOGIN EmpleadoAdiminstracion 
with password = 'empleadoadministracion'

use AgainDB
go

CREATE USER SupervisorRRHHUser for login SupervisorRRHH
go
CREATE USER SupervisorVentaUser for login SupervisorVenta
go
CREATE USER SupervisorAdministracionUser for login SupervisorAdministracion
go
CREATE USER EmpleadoRRHHUser for login EmpleadoRRHH
go
CREATE USER EmpleadoVentaUser for login EmpleadoVenta
go
CREATE USER EmpleadoAdministracionUser for login EmpleadoAdiminstracion
go
----------------------------

create role SupervisorRRHHRole
go
create role SupervisorVentaRole
go
create role SupervisorAdministracionRole
go
create role EmpleadoRRHHRole
go
create role EmpleadoVentaRole
go
create role EmpleadoAdministracionRole
go
----------------------------

alter server role SupervisorRRHHRole add member SupervisorRRHHUser
go
alter server role SupervisorVentaRole add member SupervisorVentaUser
go
alter server role SupervisorAdministracionRole add member SupervisorAdministracionUser
go
alter server role EmpleadoRRHHRole add member EmpleadoRRHHUser
go
alter server role EmpleadoVentaRole add member EmpleadoVentaUser
go
alter server role EmpleadoAdministracionRole add member EmpleadoAdministracionUser
go
----------------------------
GRANT EXECUTE ON SCHEMA::rrhh to SupervisorRRHHRole
go
GRANT SELECT ON OBJECT::rrhh.Empleado to SupervisorRRHHRole;
go
GRANT SELECT ON OBJECT::rrhh.Sucursal to SupervisorRRHHRole;
go
GRANT SELECT ON OBJECT::rrhh.Ciudad to SupervisorRRHHRole;
go
GRANT SELECT ON OBJECT::rrhh.TelefonoEmpleado to SupervisorRRHHRole;
go
GRANT SELECT ON OBJECT::rrhh.TipoCliente to SupervisorRRHHRole;
go


GRANT EXECUTE ON SCHEMA::venta to SupervisorVentaRole
go
GRANT SELECT ON OBJECT::venta.Cliente to SupervisorVentaRole;
go
GRANT SELECT ON OBJECT::venta.TelefonoCliente to SupervisorVentaRole;
go
GRANT SELECT ON OBJECT::venta.CatalogoGeneral to SupervisorVentaRole;
go
GRANT SELECT ON OBJECT::venta.NotaDeCredito to SupervisorVentaRole;
go

GRANT EXECUTE ON SCHEMA::administracion to SupervisorAdministracionRole
go
GRANT SELECT ON OBJECT::administracion.MedioPago to SupervisorVentaRole;
go
GRANT SELECT ON OBJECT::administracion.TipoFactura to SupervisorVentaRole;
go
----------------------------
GRANT EXECUTE ON SCHEMA::rrhh to EmpleadoRRHHRole
go
DENY EXECUTE ON OBJECT :: rrhh.InsertarEmpleado to EmpleadoRRHHRole
go
DENY EXECUTE ON OBJECT :: rrhh.EliminarSucursal to EmpleadoRRHHRole
go
DENY EXECUTE ON OBJECT :: rrhh.EliminarEmpleado to EmpleadoRRHHRole
go
DENY EXECUTE ON OBJECT :: rrhh.InsertarEmpleadosRandom to EmpleadoRRHHRole
go
----------------------------

GRANT EXECUTE ON SCHEMA::venta to EmpleadoVentaRole
go
DENY EXECUTE ON OBJECT :: venta.GenerarNotaDeCredito to EmpleadoVentaRole
go
----------------------------
GRANT EXECUTE ON SCHEMA::administracion to EmpleadoAdministracionRole
go
DENY EXECUTE ON OBJECT ::administracion.InsertarMedioPago to EmpleadoAdministracionRole
go
DENY EXECUTE ON OBJECT ::administracion.InsertarTipoFactura to EmpleadoAdministracionRole
go
----------------------------