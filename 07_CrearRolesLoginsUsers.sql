/*
Cuando un cliente reclama la devolución de un producto se genera una nota de crédito por el 
valor del producto o un producto del mismo tipo. 
En el caso de que el cliente solicite la nota de crédito, solo los Supervisores tienen el permiso 
para generarla.  
Tener en cuenta que la nota de crédito debe estar asociada a una Factura con estado pagada. 
Asigne los roles correspondientes para poder cumplir con este requisito. 
Por otra parte, se requiere que los datos de los empleados se encuentren encriptados, dado 
que los mismos contienen información personal. 
La información de las ventas es de vital importancia para el negocio, por ello se requiere que 
se establezcan políticas de respaldo tanto en las ventas diarias generadas como en los 
reportes generados.  
Plantee una política de respaldo adecuada para cumplir con este requisito y justifique la 
misma. No es necesario que incluya el código de creación de los respaldos. 

*/
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

use COM1353G05
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