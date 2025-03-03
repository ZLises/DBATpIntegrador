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
create procedure venta.ConfirmarTransaccion(@idCliente int,@medioPago varchar(50),@idEmpleado int)
as
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
		    declare @tipoFactura char(1)
			set @tipoFactura = 
							  case cast(rand()*(3-1)+1 as int)
							  when 1 then 'A'
							  when 2 then 'B'
							  else 'C'
							  end
	      
	 begin

	 end

end
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
go
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


    declare @aux int
	set @aux = cast(rand()*(999-100)+100 as int)
	declare @aux2 int
	set @aux2 = cast(rand()*(99-10)+10 as int)
	declare @aux3  int
	set @aux3 = cast(rand()*(9999-1000)+1000 as int)

	declare @cadena nvarchar(11)

	set @cadena = CAST(@aux as nvarchar(3)) + '-' +CAST(@aux2 as nvarchar(3)) + '-' + CAST(@aux3 as nvarchar(4))
	print @cadena