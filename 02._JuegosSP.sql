use AgainDB
go

--se espera que inserte la ciudad
exec rrhh.InsertarCiudad 'San Justo'
--se espera que no inserte la ciudad
exec rrhh.InsertarCiudad 'San Justo'


--se espera que modifique la ciuadad
exec rrhh.ModificarCiudad 'San Justo', 'Merlo'
--se espera que no pueda modificar la ciudad
exec rrhh.ModificarCiudad 'San Justo', 'Merlo'


--se espera que elimine la ciudad
exec rrhh.EliminarCiudad 'Merlo'
--se espera que no encuentre la ciudad
exec rrhh.EliminarCiudad 'Merlo'


--se espera que no te deje ingresar la sucursal en merlo
exec rrhh.IngresarSucursal 'Merlo'


--se espera que luego de ingresar una nueva ciudad se pueda ingresar una sucursal
exec rrhh.InsertarCiudad 'Ramos Mejia'
exec rrhh.IngresarSucursal 'Ramos Mejia'


--se espera que elimine la sucursal
exec rrhh.EliminarSucursal 'Ramos Mejia'

select*from rrhh.Sucursal
--se espera que ingrese empleado en la sucursal de Ramos Mejia
exec rrhh.IngresarSucursal 'Ramos Mejia'
exec rrhh.InsertarEmpleado  6789,'Florida',3452,'2024-01-01','Mario','Balotelli',1,'20456789874'
							
select*from rrhh.Empleado

--se espera error al insertar empleado existente
exec rrhh.InsertarEmpleado  6789,'Florida',3452,'2024-01-01','Mario','Balotelli',1,'20456789874'
--se insertan empleados random
exec rrhh.InsertarEmpleadosRandom 8,257020,20428387024,1


--se espera error al eliminar empleado que no existe
exec rrhh.EliminarEmpleado 9
--se espera que elimine el empleado
exec rrhh.EliminarEmpleado 6789


--se espera que inserte el tipo de cliente
exec rrhh.InsertarTipoCliente 'Normal'
exec rrhh.InsertarTipoCliente 'Member'
--se espera que ingrese el cliente
exec venta.InsertarCliente 101,'Rojo',456,23456541234,'Luis','Ronaldinho','Normal','Hombre'
--se espera que no ingrese el cliente
exec venta.InsertarCliente 101,'Rojo',456,23456541234,'Luis','Ronaldinho','Normal','Hombre'

--se espera que no elimine el cliente
exec venta.EliminarCliente 213
--se espera que elimine el cliente
exec venta.EliminarCliente 101


--se espera que ingrese el cliente
exec venta.InsertarCliente 221,'CalleFalsa',123,'20456541234','David','Villa','Normal','Hombre'
exec venta.InsertarTelefonoCliente 221,1198876532


--se espera que ingrese medio de pago
exec administracion.InsertarMedioPago 'Ewallet'
exec administracion.InsertarMedioPago 'Cash'
exec administracion.InsertarMedioPago 'Credit card'
--se espera que ingrese tipo de factura
exec administracion.InsertarTipoFactura 'A'
exec administracion.InsertarTipoFactura 'B'
exec administracion.InsertarTipoFactura 'C'

