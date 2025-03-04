use COM1353G05
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
--ingreso ciudad
exec rrhh.InsertarCiudad 'Ramos Mejia'
--ingreso sucursal
exec rrhh.IngresarSucursal 'Ramos Mejia'

select*from rrhh.Sucursal

--se espera que elimine la sucursal
exec rrhh.EliminarSucursal 'Ramos Mejia'

--ingreso de ciudades e ingreso de sucursales
exec rrhh.InsertarCiudad 'San Justo'
exec rrhh.InsertarCiudad 'Merlo'

exec rrhh.IngresarSucursal 'Ramos Mejia'
exec rrhh.IngresarSucursal 'San Justo'
exec rrhh.IngresarSucursal 'Merlo'

--se espera que ingrese empleado en la sucursal de Ramos Mejia
--ingresa empleado
exec rrhh.InsertarEmpleado  6789,'Florida',3452,'2024-01-01','Mario','Balotelli',2,'20456789874','JC'	
exec rrhh.InsertarEmpleado  4989,'Alzavio',3452,'2024-11-11','Roberto','Carlos',3,'20116789874','TT'

--se espera error al insertar empleado existente
exec rrhh.InsertarEmpleado  6789,'Florida',3452,'2024-01-01','Mario','Balotelli',1,'20456789874','JC'

----------------------------------------------------------------------------
--se insertan empleados random//usado para despues importar las ventas!!!
exec rrhh.InsertarEmpleadosRandom 8,257020,20428387024,4
----------------------------------------------------------------------------

--se espera error al eliminar empleado que no existe
exec rrhh.EliminarEmpleado 9
--se espera que elimine el empleado
exec rrhh.EliminarEmpleado 6789

--se espera que inserte el tipo de cliente//importante para despues insertar ventas!!!
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


--se espera que ingrese medio de pago//importante para despues insertar ventas!!
exec administracion.InsertarMedioPago 'Ewallet'
exec administracion.InsertarMedioPago 'Cash'
exec administracion.InsertarMedioPago 'Credit card'

--se espera que ingrese tipo de factura//importante para despues insertar ventas!!
exec administracion.InsertarTipoFactura 'A'
exec administracion.InsertarTipoFactura 'B'
exec administracion.InsertarTipoFactura 'C'
