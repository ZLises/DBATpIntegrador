USE FIGHT
GO
create procedure usar.InsertarCiudad(@nombreCiudad varchar(30))
as
begin
if exists(
		select nombreCiudad from obj.Ciudad
		where nombreCiudad = @nombreCiudad
		 )
 begin
  print 'La ciudad ingresada ya existe'
 end
else
 begin 
  insert into obj.Ciudad(nombreCiudad) values (@nombreCiudad)
 end
end
go


create procedure usar.ModificarCiudad(@nombreCiudad varchar(30), @nuevoNombreCiudad varchar(30))
as
begin
   if exists(
     select nombreCiudad from obj.Ciudad
	 where nombreCiudad = @nombreCiudad
   )
   begin
     UPDATE obj.Ciudad
	 set nombreCiudad = @nuevoNombreCiudad
	 where nombreCiudad = @nombreCiudad
   end
   else
   begin
     print 'El nombre a modificar no existe'
   end
end
go

create procedure usar.EliminarCiudad(@nombreCiudadEliminar varchar(30))
as
begin
   if exists(
      select nombreCiudad from obj.Ciudad
	  where nombreCiudad = @nombreCiudadEliminar
   )
    begin
	   Delete obj.Ciudad
	   where nombreCiudad = @nombreCiudadEliminar
    end
   else
    begin
	  print 'No existe esa ciudad para eliminar'
    end
end
go

select*from obj.Ciudad
go
create procedure usar.IngresarSucursal(@nombreCiudad varchar(30))
as
begin
   if exists(
     select nombreCiudad from obj.Ciudad
	 where nombreCiudad = @nombreCiudad
   )
   begin
		   if exists(
			 select nombreCiudad from obj.Sucursal
			 where nombreCiudad = @nombreCiudad
		   )
		   begin
			 print 'Ya existe'
		   end
		   else
		   begin
			 insert into obj.Sucursal([nombreCiudad]) values (@nombreCiudad)
		   end    
   end
   else
   begin
     print 'No existe esa ciudad en la tabla Ciudad'
   end
end
go

create procedure usar.EliminarSucursal(@ciudadSucursalEliminar varchar(30))
as
begin
  if exists(
    select nombreCiudad from obj.Sucursal
	where nombreCiudad = @ciudadSucursalEliminar
  )
  begin
    Delete obj.Sucursal
	where nombreCiudad = @ciudadSucursalEliminar
  end
  else
  begin
    print 'No existe la sucursal a eliminar'
  end
end
go

create procedure usar.InsertarEmpleado
(@idEmpleado int,@calle varchar(20),@numeroCalle int,@piso TINYINT,@fechaDeAlta datetime,
 @nombre varchar(20), @apellido varchar(20), @idSucursal int, @cuil char(11))
as
begin
   if exists(
      select idEmpleado from obj.Empleado
	  where idEmpleado = @idEmpleado
   )begin
           print 'Empleado a insertar ya existe'
    end
	else
	begin
		   INSERT INTO obj.Empleado(idEmpleado,calle,numeroCalle,piso,fechaDeAlta,nombre,apellido,idSucursal,cuil)
		   VALUES(@idEmpleado,@calle,@numeroCalle ,@piso ,@fechaDeAlta ,
		   @nombre,@apellido, @idSucursal,@cuil)
   end
end
go

create procedure usar.EliminarEmpleado(@idEmpleado int)
as
begin
  IF exists(
    select idEmpleado from obj.Empleado
	where idEmpleado = @idEmpleado
  )
   begin
     Delete obj.Empleado
	 where idEmpleado = @idEmpleado
   end
  else 
   begin
     print 'Empleado a eliminar no existe'
   end
end
go
--
create procedure usar.InsertarTipoCliente(@tipo varchar(30))
as
begin
   if exists(
     select tipoCliente from obj.TipoCliente
	 where tipoCliente = @tipo
   )begin
     print 'Ya existe ese tipo de cliente'
   end
   else
   begin
      Insert into obj.TipoCliente(tipoCliente)
	  values (@tipo)
   end
end
go

create procedure usar.InsertarCliente
(   @idCliente int ,
	@calle varchar(20),
	@numeroCalle int,
	@piso TINYINT ,
	@cuil char(11),
	@nombre varchar(20),
	@apellido varchar(20),
	@tipoCliente varchar(30),
	@genero varchar(20))
as 
begin
   IF EXISTS(
       select idCliente from obj.Cliente
	   where idCliente = @idCliente
   )
   begin
       print 'Ya existe el cliente con ese id'
   end
   else
   begin
	   INSERT INTO obj.Cliente(idCliente,calle,numeroCalle,piso,cuil,nombre,apellido,tipoCliente,genero)
	   values(@idCliente,@calle,@numeroCalle,@piso,@cuil,@nombre,@apellido,@tipoCliente,@genero)
   end
end
GO

create procedure usar.EliminarCliente(@idCliente int)
as
begin
   if exists(
     select idCliente from obj.Cliente
	 where idCliente = @idCliente
   )
   begin
     Delete obj.Cliente
	 where idCliente = @idCliente
   end
   else
   begin
    print 'Codigo de cliente no existe'
   end
end
go
---telefonos
create procedure usar.InsertarTelefonoEmpleado(@idEmpleado int, @telefono int)
as
begin
   if exists(
     select idEmpleado from obj.Empleado
	 where idEmpleado = @idEmpleado
   )
   begin
     insert into obj.TelefonoEmpleado(idEmpleado,telefono)
	 values (@idEmpleado,@telefono)
   end
   else
   begin
    print 'Codigo de empleado no existe'
   end
end
go

create procedure usar.InsertarTelefonoCliente(@idCliente int, @telefono int)
as
begin
   if exists(
     select idCliente from obj.Cliente
	 where idCliente = @idCliente
   )
   begin
     insert into obj.TelefonoCliente(idCliente,telefono)
	 values (@idCliente,@telefono)
   end
   else
   begin
    print 'Codigo de cliente no existe'
   end
end
go
--facturacion

create procedure usar.InsertarMedioPago(@medioPago varchar(30))
as
begin 
  if exists(
    select tipoPago from obj.MedioPago
	where tipoPago = @medioPago
  )begin
    print 'ya existe ese medio de pago'
	end
  else
  begin
    insert into obj.MedioPago([tipoPago])
	values (@medioPago)
	end
end
go

create procedure usar.InsertarTipoFactura(@tipo char(1))
as
begin
   if exists(
     select tipoFactura from obj.TipoFactura
	 where tipoFactura = @tipo
    )
	begin
	  print 'ya existe ese tipo de factura'
	end
	else 
	begin
	 insert into obj.TipoFactura(tipoFactura)
	 values (@tipo)
	end
end
go
--
create procedure venta.InsertarVenta
(    @idFactura char(11),
	 @tipoFactura char(1),
	 @ciudad varchar(50),
	 @fecha date,
	 @hora time,
	 @tipoCliente varchar(30),
	 @genero varchar(20),
	 @producto varchar(100),
	 @precioUnitario decimal(6,2),
	 @cantidad int,
	 @medioPago varchar(30),
	 @idEmpleado int,
	 @identificadorDePago char(23))
as
begin
    if exists(
	   select idFactura from venta.Transacciones
	   where idFactura = @idFactura
	)begin
	    print 'No se puede realizar la transaccion porque id de factura ya existe'
	 end
	 else
	 begin
			 SET TRANSACTION ISOLATION LEVEL READ COMMITTED
			 BEGIN TRANSACTION
			 insert into venta.Transacciones(idFactura,tipoFactura,ciudad,fecha,hora,tipoCliente,genero,producto,precioUnitario,
						cantidad,medioPago,idEmpleado,identificadorDePago)
						values(@idFactura,@tipoFactura,@ciudad,@fecha,@hora,@tipoCliente,@genero,@producto,@precioUnitario,
						@cantidad,@medioPago,@idEmpleado,@identificadorDePago)
			 COMMIT TRANSACTION
	 end
end