
use AgainDB
go

create table venta.NotaDeCredito(
   idNotaDeCredito int identity(1,1) primary key,
   idFactura char(11),
   montoTotal decimal(12,2),
   fecha datetime not null
)
go
create procedure venta.GenerarNotaDeCredito(@idFactura char(11))
as
begin
   if exists(
      select idFactura from venta.Transacciones
	  where idFactura = @idFactura
   )begin
       declare @monto decimal(12,2)
       set @monto = (select sum(cantidad*precioUnitario) as montoTotal from venta.Transacciones
                    where idFactura = @idFactura)

	   insert into venta.NotaDeCredito(idFactura,montoTotal,fecha)
	   values (@idFactura,@monto,getdate())
    end
	else
	begin
	  print 'Ese id no se encuentra dentro de las transacciones'
	end
end
go
---prueba de generar una nota de credito
select * from venta.NotaDeCredito
go
exec venta.GenerarNotaDeCredito '415-45-2997'
go
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

CREATE USER SupervisorRRHHUser
CREATE USER SupervisorVentaUser
CREATE USER SupervisorAdministracionUser
CREATE USER EmpleadoRRHHUser
CREATE USER EmpleadoVentaUser
CREATE USER EmpleadoAdministracionUser

create role SupervisorRRHHRole
create role SupervisorVentaRole
create role SupervisorAdministracionRole
create role EmpleadoRRHHRole
create role EmpleadoVentaRole
create role EmpleadoAdministracionRole


alter server role SupervisorRRHHRole add member SupervisorRRHHUser
alter server role SupervisorVentaRole add member SupervisorVentaUser
alter server role SupervisorAdministracionRole add member SupervisorAdministracionUser
alter server role EmpleadoRRHHRole add member EmpleadoRRHHUser
alter server role EmpleadoVentaRole add member EmpleadoVentaUser
alter server role EmpleadoAdministracionRole add member EmpleadoAdministracionUser
----------------------------
GRANT EXECUTE ON SCHEMA::rrhh to SupervisorRRHHRole

GRANT EXECUTE ON SCHEMA::venta to SupervisorVentaRole

GRANT EXECUTE ON SCHEMA::venta to SupervisorAdministracionRole
----------------------------
GRANT EXECUTE ON SCHEMA::rrhh to EmpleadoRRHHRole
DENY EXECUTE ON OBJECT :: rrhh.InsertarEmpleado to EmpleadoRRHHRole
DENY EXECUTE ON OBJECT :: rrhh.EliminarSucursal to EmpleadoRRHHRole
DENY EXECUTE ON OBJECT :: rrhh.EliminarEmpleado to EmpleadoRRHHRole
DENY EXECUTE ON OBJECT :: rrhh.InsertarEmpleadoRandom to EmpleadoRRHHRole


GRANT EXECUTE ON SCHEMA::venta to EmpleadoVentaRole
DENY EXECUTE ON OBJECT :: venta.GenerarNotaDeCredito to EmpleadoVentaRole

GRANT EXECUTE ON SCHEMA::administracion to EmpleadoAdministracionRole
DENY EXECUTE ON OBJECT ::administracion.InsertarMedioPago to EmpleadoAdministracionRole
DENY EXECUTE ON OBJECT ::administracion.InsertarTipoFactura to EmpleadoAdministracionRole
