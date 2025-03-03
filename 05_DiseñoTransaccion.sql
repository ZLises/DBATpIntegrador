use AgainDB
go

select*from venta.Transacciones

create table #InsertarProducto(
   idProducto int,
   cantidad int
)
go

create function venta.validarDatos(@idCliente int,@medioPago varchar(50),@idEmpleado int)
   returns int
  as
  begin
     declare @retorno int
	 set @retorno = 0

     if exists(
	     select idCliente from venta.Cliente
		 where idCliente = @idCliente
	 )begin
	      if exists(
		     select tipoPago from administracion.MedioPago
			 where tipoPago = @medioPago
		  )begin
		        if exists(
				   select idEmpleado from rrhh.Empleado
				   where idEmpleado = @idEmpleado
				)begin
				   set @retorno = 1
				 end
		  end
	  end
       return @retorno
  end
go

create or alter procedure venta.InsertarProducto(@idProducto int, @cantidad int)
as
begin
		if (@cantidad > 0)
		begin
			if not exists(
			   select idProducto from venta.CatalogoGeneral
			   where idProducto = @idProducto
			)begin
			   print 'No existe ese codigo de producto en el catalogo'
			 end
			 else
			 begin
				 insert into #InsertarProducto(idProducto,cantidad)
				 values(@idProducto,@cantidad)
			 end
		end
		else
		begin
		   print 'Error en el ingreso de cantidad'
		end
end
go

create or alter procedure venta.ConfirmarTransaccion(@idCliente int,@medioPago varchar(50),@idEmpleado int)
as
begin 

	  if ((venta.ValidarDatos(@idCliente,@medioPago,@idEmpleado) = 1))
	  begin
	    set transaction isolation level read committed
		begin transaction
				declare @cadena char(11)
				declare @aux int
				declare @aux2 int
				declare @aux3 int

				set @aux = cast(rand()*(999-100)+100 as int)
				set @aux2 = cast(rand()*(99-10)+10 as int)
				set @aux3 = cast(rand()*  (9999-1000)+1000 as int)
				set @cadena = CAST(@aux as char(3))+'-'+CAST(@aux2 as char(2))+'-'+ CAST(@aux3 as char(4))

				if exists(
				   select idFactura from venta.Transacciones
				   where idFactura = @cadena
				)begin
				   print 'No se puede realizar la transaccion debido a que el idFactura ya existe en la tabla transacciones'
				 end
				 else
				  begin
						declare @tipoFactura char(1)
						set @tipoFactura = 
										  case cast(rand()*(3-1)+1 as int)
										  when 1 then 'A'
										  when 2 then 'B'
										  else 'C'
										  end

						declare @tipoCliente varchar(30) = (
						                        select tipoCliente from venta.Cliente
												where idCliente = @idCliente 
						                       )
					    declare @genero varchar(30) = (
						                        select genero from venta.Cliente
												where idCliente = @idCliente 
						                       )
						/*
						declare @precioUnitario decimal(12,2) = (
						                                           select precio from venta.CatalogoGeneral c
																   join #InsertarProducto i 
																   on i.idProducto = c.idProducto
						                                         )
						declare @producto varchar(200) = (
						                                    select nombreProducto from venta.CatalogoGeneral c
															join #InsertarProducto i 
															on i.idProducto = c.idProducto
						                                 )
						*/
                        declare @identificadorDePago char(23) = case @medioPago
						                                        when 'Cash' then '--'
																when 'Ewallet' then '1000004000099475111111'
																else '1160-1146-1138-1185'
																end
						
						insert into venta.Transacciones(idFactura,tipoFactura,ciudad,fecha,hora,tipoCliente,
														genero,medioPago,
														idEmpleado,identificadorDePago,precioUnitario,producto,cantidad
													   )
						select @cadena , @tipoFactura,'Miami',convert(date,getdate(),101), cast(getdate() as time),
							   @tipoCliente,@genero,@medioPago,@idEmpleado,@identificadorDePago,cg.precio,
							   cg.nombreProducto,cantidad from #InsertarProducto i
							   join  venta.CatalogoGeneral cg
							   on i.idProducto = cg.idProducto
		commit transaction

				 end
	  end
	  else
		  begin
			print 'Algunos datos ingresados por parametro no son correctos'
		  end
	 truncate table #InsertarProducto
end
go

create procedure venta.CancelarInsertarProducto
as
begin
    truncate table #InsertarProducto
end
go

--format(campo,'HH:mm')
--pequeño juego de transacciones

select*from venta.CatalogoGeneral
where idProducto = 67
--Insersion de productos correctamente 
exec venta.InsertarProducto 67,2
go
--confirmo la venta
exec venta.ConfirmarTransaccion 221,'Cash',6789
go

--ingreso muchos productos
exec venta.InsertarProducto 41, 12
exec venta.InsertarProducto 42, 11
exec venta.InsertarProducto 43, 11
--confirmo la venta
exec venta.ConfirmarTransaccion 221,'Cash',6789

--ingreso productos
exec venta.InsertarProducto 41, 12
exec venta.InsertarProducto 42, 11
--los cancelo manualmente y se limpia la tabla que tiene los productos
exec venta.CancelarInsertarProducto

select*from #InsertarProducto
select*from venta.CatalogoGeneral
select*from venta.Cliente
select*from rrhh.Empleado
select*from venta.Transacciones