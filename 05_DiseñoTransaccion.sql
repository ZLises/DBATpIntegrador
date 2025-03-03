use AgainDB
go

select*from venta.Transacciones

create table #InsertarProducto(
   idProducto int,
   cantidad int
)
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
		   print 'Error en el ingreso de cantiadad'
		end
end
go

select*from venta.CatalogoGeneral

--Insersion de productos correctamente 
exec venta.InsertarProducto 8,1
go
exec venta.InsertarProducto 5,2
go
exec venta.InsertarProducto 6,1
go
exec venta.InsertarProducto 7,1
go

--no te deja insertar en la tabla temporal #InsertarProducto ya que ese id no existe en el catalogo general
exec venta.InsertarProducto 1232320,1
go
--no te deja insertar en la tabla temporal #insertarProducto ya que la cantidad no es valida
exec venta.InsertarProducto 5,-34
go

SELECT*FROM #InsertarProducto

go

create or alter procedure venta.ConfirmarTransaccion(@idCliente int,@medioPago varchar(50),@idEmpleado int)
as
begin 
	  if ((venta.ValidarDatos(@idCliente,@medioPago,@idEmpleado) = 1))
	  begin
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
							   @tipoCliente,@genero,@medioPago,@idEmpleado,@identificadorDePago,@precioUnitario,
							   @producto,cantidad from #InsertarProducto
				 end
	  end
	  else
		  begin
			print 'Algunos datos ingresados por parametro no son correctos'
		  end
	 truncate table #InsertarProducto
end
go

select*from venta.CatalogoGeneral
where idProducto = 67
--Insersion de productos correctamente 
exec venta.InsertarProducto 67,2
go
--221
exec venta.ConfirmarTransaccion 221,'Cash',6789


--Insertar algun parametro incorrecto
exec venta.InsertarProducto 15, 3
exec venta.ConfirmarTransaccion 221,'Ewallet',6789

select*from #InsertarProducto
select*from venta.CatalogoGeneral
select*from venta.Cliente
select*from rrhh.Empleado
select*from venta.Transacciones



















--format(campo,'HH:mm')
--ejecutar un procedure para cancelar las operaciones de insertar producto
select * from venta.Transacciones
select cast(getdate() as time)
---crear un idtransaccion a la tabla, y dejar el idFactura ahi 
--evitar duplicados con un join en insersiones 
/*
declare @tipoFactura char(1)

set @tipoFactura = 
                  case cast(rand()*(3-1)+1 as int)
				  when 1 then 'A'
				  when 2 then 'B'
				  else 'C'
				  end
print @tipoFactura
*/

/* manera de crear un char random de 
    declare @cadena char(11)
    declare @aux int
	declare @aux2 int
	declare @aux3 int

	set @aux = cast(rand()*(999-100)+100 as int)
	set @aux2 = cast(rand()*(99-10)+10 as int)
	set @aux3 = cast(rand()*  (9999-1000)+1000 as int)

	set @cadena = CAST(@aux as char(3))+'-'+CAST(@aux2 as char(2))+'-'+ CAST(@aux3 as char(4))

	print @cadena
*/


/*
   CREATE TABLE venta.Transacciones(
     idFactura char(11),
	 tipoFactura char(1),
	 ciudad varchar(50),
	 fecha date,
	 hora time,
	 tipoCliente varchar(30),
	 genero varchar(20),
	 producto varchar(100),
	 precioUnitario decimal(6,2),
	 cantidad int,
	 medioPago varchar(30),
	 idEmpleado int,
	 identificadorDePago char(23),
*/
/*

    declare @aux int
	set @aux = cast(rand()*(999-100)+100 as int)
	declare @aux2 int
	set @aux2 = cast(rand()*(99-10)+10 as int)
	declare @aux3  int
	set @aux3 = cast(rand()*(9999-1000)+1000 as int)

	declare @cadena char(11)

	set @cadena = CAST(@aux as char(3)) + '-' +CAST(@aux2 as char(2)) + '-' + CAST(@aux3 as char(4))
	print @cadena

	select*from venta.Transacciones

	declare @cadena char(11)
	set @cadena = '750-67-8428'

	if exists(
	   select idFactura from venta.Transacciones
	   where idFactura = @cadena
	)begin
	   print 'No se puede realizar la transaccion debido a que el idFactura ya existe en la tabla transacciones'
	 end
	 */

	

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

  select venta.validarDatos (221,'Credit card',257020)

  select*from rrhh.Empleado
  select*from venta.Cliente
  select*from administracion.MedioPago