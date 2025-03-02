USE COM1353G05
GO
--se espera que inserte la ciudad
exec usar.InsertarCiudad 'San Justo'
--se espera que no inserte la ciudad
exec usar.InsertarCiudad 'San Justo'


--se espera que modifique la ciuadad
exec usar.ModificarCiudad 'San Justo', 'Merlo'
--se espera que no pueda modificar la ciudad
exec usar.ModificarCiudad 'San Justo', 'Merlo'


--se espera que elimine la ciudad
exec usar.EliminarCiudad 'Merlo'
--se espera que no encuentre la ciudad
exec usar.EliminarCiudad 'Merlo'


--se espera que no te deje ingresar la sucursal en merlo
exec usar.IngresarSucursal 'Merlo'


--se espera que luego de ingresar una nueva ciudad se pueda ingresar una sucursal
exec usar.InsertarCiudad 'Ramos Mejia'
exec usar.IngresarSucursal 'Ramos Mejia'


--se espera que elimine la sucursal
exec usar.EliminarSucursal 'Ramos Mejia'


--se espera que ingrese empleado en la sucursal de Ramos Mejia
exec usar.IngresarSucursal 'Ramos Mejia'
exec usar.InsertarEmpleado 1132,'Alvarado',123,1,'2024-01-01','Juan','Martinez',2,'20456789874'


--se espera error al insertar empleado existente
exec usar.InsertarEmpleado 1132,'Alvarado',123,1,'2024-01-01','Juan','Martinez',2,'20456789874'


--se espera error al eliminar empleado que no existe
exec usar.EliminarEmpleado 9
--se espera que elimine el empleado
exec usar.EliminarEmpleado 1132


--se espera que inserte el tipo de cliente
exec usar.InsertarTipoCliente 'Normal'
--se espera que ingrese el cliente
exec usar.InsertarCliente 101,'Rojo',456,0,23456541234,'Luis','Ronaldinho','Normal','Hombre'
--se espera que no ingrese el cliente
exec usar.InsertarCliente 101,'Rojo',456,0,23456541234,'Luis','Ronaldinho','Normal','Hombre'


--se espera que no elimine el cliente
exec usar.EliminarCliente 213
--se espera que elimine el cliente
exec usar.EliminarCliente 101


--se espera que ingrese el cliente
exec usar.InsertarCliente 221,'CalleFalsa',123,4,'20456541234','David','Villa','Normal','Hombre'
exec usar.InsertarTelefonoCliente 221,1198876532


--se espera que ingrese medio de pago
exec usar.InsertarMedioPago 'Efectivo'
--se espera que ingrese tipo de factura
exec usar.InsertarTipoFactura 'A'


--se espera que ingrese la venta
exec usar.InsertarEmpleado 532,'Marcos Paz',123,1,'2023-01-01','Nazario','Ronaldo',2,'20411789874'
exec venta.InsertarVenta '123232','A','Barcelona','2024-01-01','13:00',
                         'Normal','Hombre','Mandarinas',0.5,10000,'Efectivo',532,'--'