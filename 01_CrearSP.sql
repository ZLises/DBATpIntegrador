use COM1353G05
go
--primero se modifica la tabla empleado para poder seguir con los procedimientos
ALTER TABLE rrhh.Empleado
  add  Turno char(2) check(Turno like 'TM' or Turno like 'TT' or Turno like 'JC' )
go
--procedure que inserta ciudades
create procedure rrhh.InsertarCiudad(@nombreCiudad varchar(30))
as
begin
if exists(
		select nombreCiudad from rrhh.Ciudad
		where nombreCiudad = @nombreCiudad
		 )
 begin
  print 'La ciudad ingresada ya existe'
 end
else
 begin 
  insert into rrhh.Ciudad(nombreCiudad) values (@nombreCiudad)
 end
end
go
--procedimiento para modificar ciudades almacenadas
create procedure rrhh.ModificarCiudad(@nombreCiudad varchar(30), @nuevoNombreCiudad varchar(30))
as
begin
   if exists(
     select nombreCiudad from rrhh.Ciudad
	 where nombreCiudad = @nombreCiudad
   )
   begin
     UPDATE rrhh.Ciudad
	 set nombreCiudad = @nuevoNombreCiudad
	 where nombreCiudad = @nombreCiudad
   end
   else
   begin
     print 'El nombre a modificar no existe'
   end
end
go
--procedimiento para eliminar ciudades almacenadas
create procedure rrhh.EliminarCiudad(@nombreCiudadEliminar varchar(30))
as
begin
   if exists(
      select nombreCiudad from rrhh.Ciudad
	  where nombreCiudad = @nombreCiudadEliminar
   )
    begin
	   Delete rrhh.Ciudad
	   where nombreCiudad = @nombreCiudadEliminar
    end
   else
    begin
	  print 'No existe esa ciudad para eliminar'
    end
end
go
--procedimiento para ingresar sucursales a partir de ciudades almacenadas
create procedure rrhh.IngresarSucursal(@nombreCiudad varchar(30))
as
begin
   if exists(
     select nombreCiudad from rrhh.Ciudad
	 where nombreCiudad = @nombreCiudad
   )
   begin
		   if exists(
			 select nombreCiudad from rrhh.Sucursal
			 where nombreCiudad = @nombreCiudad
		   )
		   begin
			 print 'Ya existe'
		   end
		   else
		   begin
			 insert into rrhh.Sucursal([nombreCiudad]) values (@nombreCiudad)
		   end    
   end
   else
   begin
     print 'No existe esa ciudad en la tabla Ciudad'
   end
end
go
--procedimiento para eliminar sucursales
create procedure rrhh.EliminarSucursal(@ciudadSucursalEliminar varchar(30))
as
begin
  if exists(
    select nombreCiudad from rrhh.Sucursal
	where nombreCiudad = @ciudadSucursalEliminar
  )
  begin
    Delete rrhh.Sucursal
	where nombreCiudad = @ciudadSucursalEliminar
  end
  else
  begin
    print 'No existe la sucursal a eliminar'
  end
end
go
--procedimiento para insertar empleados
create or alter procedure rrhh.InsertarEmpleado(@idEmpleado int,@calle varchar(20),@numeroCalle int,
                                       @fechaDeAlta datetime, @nombre varchar(20),@apellido varchar(20),
									   @idSucursal int, @cuil char(11),@turno char(2))
as
begin
     if exists(
	   select idEmpleado from rrhh.Empleado
	   where idEmpleado = @idEmpleado
	 )begin
	   print 'Ya existe ese empleado'
	  end
	  else
	  begin
	      if((@turno like 'TM' or @turno like 'TT' or @turno like 'JC' ))
		  begin
				  if exists(
					 select cuil from rrhh.Empleado
					 where cuil = @cuil
				   )begin
					 print 'Ya existe ese cuil dentro de la tabla empleados'
					end
					else
					begin
					   insert into rrhh.Empleado(idEmpleado,calle,numeroCalle,fechaDeAlta,
												 nombre,apellido,idSucursal,cuil,Turno)
												 values(@idEmpleado,@calle,@numeroCalle,@fechaDeAlta,
												 @nombre,@apellido,@idSucursal,@cuil,@turno)
					end
		  end
		  else
		  begin
		     print 'Ese turno no existe'
		  end
      end
end
go
--procedimiento para eliminar empleados
create procedure rrhh.EliminarEmpleado(@idEmpleado int)
as
begin
  IF exists(
    select idEmpleado from rrhh.Empleado
	where idEmpleado = @idEmpleado
  )
   begin
     Delete rrhh.Empleado
	 where idEmpleado = @idEmpleado
   end
  else 
   begin
     print 'Empleado a eliminar no existe'
   end
end
go
--procedure para insertar los distintos tipos de cliente
create procedure rrhh.InsertarTipoCliente(@tipo varchar(30))
as
begin
   if exists(
     select tipoCliente from rrhh.TipoCliente
	 where tipoCliente = @tipo
   )begin
     print 'Ya existe ese tipo de cliente'
   end
   else
   begin
      Insert into rrhh.TipoCliente(tipoCliente)
	  values (@tipo)
   end
end
go
--procedure para insertar nuevos clientes
create procedure venta.InsertarCliente
(   @idCliente int ,
	@calle varchar(20),
	@numeroCalle int,
	@cuil char(11),
	@nombre varchar(20),
	@apellido varchar(20),
	@tipoCliente varchar(30),
	@genero varchar(20))
as 
begin
   IF EXISTS(
       select idCliente from venta.Cliente
	   where idCliente = @idCliente
   )
   begin
       print 'Ya existe el cliente con ese id'
   end
   else
   begin
       IF exists(
	      select cuil from venta.Cliente
		  where cuil = @cuil
	   )
	   begin
	     print 'Ya existe ese cuil en la tabla cliente'
	   end
	   else
	   begin
	       INSERT INTO venta.Cliente(idCliente,calle,numeroCalle,cuil,nombre,apellido,tipoCliente,genero)
	       values(@idCliente,@calle,@numeroCalle,@cuil,@nombre,@apellido,@tipoCliente,@genero)
	   end
   end
end
GO
--procedure para eliminar cliente
create procedure venta.EliminarCliente(@idCliente int)
as
begin
   if exists(
     select idCliente from venta.Cliente
	 where idCliente = @idCliente
   )
   begin
     Delete venta.Cliente
	 where idCliente = @idCliente
   end
   else
   begin
    print 'Codigo de cliente no existe'
   end
end
go
--procedure para insertar telefonos a los empleados
create procedure rrhh.InsertarTelefonoEmpleado(@idEmpleado int, @telefono int)
as
begin
   if exists(
     select idEmpleado from rrhh.Empleado
	 where idEmpleado = @idEmpleado
   )
   begin
     insert into rrhh.TelefonoEmpleado(idEmpleado,telefono)
	 values (@idEmpleado,@telefono)
   end
   else
   begin
    print 'Codigo de empleado no existe'
   end
end
go
--procedure para insertar telefonos a los cliente
create procedure venta.InsertarTelefonoCliente(@idCliente int, @telefono int)
as
begin
   if exists(
     select idCliente from venta.Cliente
	 where idCliente = @idCliente
   )
   begin
     insert into venta.TelefonoCliente(idCliente,telefono)
	 values (@idCliente,@telefono)
   end
   else
   begin
    print 'Codigo de cliente no existe'
   end
end
go
--procedure para insertar distintos medios de pago
create procedure administracion.InsertarMedioPago(@medioPago varchar(30))
as
begin 
  if exists(
    select tipoPago from administracion.MedioPago
	where tipoPago = @medioPago
  )begin
    print 'ya existe ese medio de pago'
	end
  else
  begin
    insert into administracion.MedioPago([tipoPago])
	values (@medioPago)
	end
end
go
--procedure para insertar tipos de factura
create procedure administracion.InsertarTipoFactura(@tipo char(1))
as
begin
   if exists(
     select tipoFactura from administracion.TipoFactura
	 where tipoFactura = @tipo
    )
	begin
	  print 'ya existe ese tipo de factura'
	end
	else 
	begin
	 insert into administracion.TipoFactura(tipoFactura)
	 values (@tipo)
	end
end
go

---procedure para ingresar empleados random, solo debe ser usado para pruebas
create or alter procedure rrhh.InsertarEmpleadosRandom(@cantidad int, @idEmpleado int,@cuil bigint,@idSucursal int)
as
begin
   declare @calle varchar(30)
   declare @numeroCalle int
   declare @fecha datetime  
   declare @nombre varchar(20)
   declare @apellido varchar(20)
   declare @auxcuil char(11)
   declare @turno char(2)

   while @cantidad > 0
   begin
	   ----------------------------------------
		 set @calle = case cast(rand()*(5+1)-1 as int)   
									when 1 then 'Chopin'
									when 2 then 'Paz'
									when 3 then 'Rivadavia'
									else 'Alvarado'
									end

		set @numeroCalle = cast(rand()*(100-20)+20 as int) 

		set @fecha = getdate()

		set @nombre = case cast(rand()*(5-1)+1 as int)   
									when 1 then 'Julian'
									when 2 then 'Enzo'
									when 3 then 'Cuti'
									else 'Alexis'
									end
		set @apellido = case cast(rand()*(5-1)+1 as int)   
									when 1 then 'Alvarez'
									when 2 then 'Fernandez'
									when 3 then 'Romero'
									else 'Mac Allister'
									end
	 
		 set @turno = case cast(rand()*(3-1)+1 as int)
					  when 1 then 'TT'
					  when 2 then 'TM'
					  else 'JC'
					  end

		 set @auxcuil = cast(@cuil as char(11))

		 exec rrhh.InsertarEmpleado @idEmpleado,@calle,@numeroCalle,@fecha,@nombre,@apellido,@idSucursal,@auxcuil,@turno;
	 
		 set @cuil = @cuil - 100
		 set @idEmpleado = @idEmpleado + 1
		 set @cantidad = @cantidad - 1
		 ----
   end
end
go
--procedimiento para generar nota de credito de parte de un supervisor del area de ventas
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