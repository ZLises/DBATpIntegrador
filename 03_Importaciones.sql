/*
Se requiere que importe toda la información antes mencionada a la base de datos: 
• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los 
archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de 
novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.  
• Considere este comportamiento al generar el código. Debe admitir la importación de 
novedades periódicamente sin eliminar los datos ya cargados y sin generar 
duplicados. 
• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que 
realicen tareas por fuera de un SP. 
• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba 
realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la 
estructura requerida. Estas adaptaciones deberán hacerla en la DB y no en los 
archivos provistos. 
• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal 
cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones 
en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible 
interpretarlo como JSON o CSV, pero los hemos verificado cuidadosamente). 
En esta entrega está incluida la generación de los informes en XML mencionados en la 
introducción del TP. 
*/


use ADBPRUEBA
go

--sp para importar catalogo a catalogoGeneral
create procedure administracion.ImportarCatalogo(@ruta nvarchar(max))
as
begin 
    declare @bulkInsertar nvarchar(max)
	set @bulkInsertar =    'bulk insert #catalogoTemporal
							from ''' + @ruta + '''
							with(
							   fieldterminator = '''+','+''',
							   rowterminator = '''+'\n'+''',
							   codepage = ''' + 'ACP' + ''',
							   firstrow = 2)'
	declare @duplicados nvarchar(max)
	set @duplicados = 'with repetidos(nombre,categoria,precio,duplicado)
						as(
						   select nombre,categoria,precio , ROW_NUMBER() over(partition by nombre,categoria order by precio desc) as repe
						   from #catalogoTemporal
						)
						delete from repetidos
						where duplicado > 1'

	create table #catalogoTemporal(
	 id varchar(255),
	 categoria varchar(255),
     nombre varchar(255),
	 precio varchar(255),
     precioReferencia varchar(255),
	 unidad  varchar(255),
     fecha varchar(255)
	)

	exec sp_executesql @bulkInsertar
	exec sp_executesql @duplicados

	insert into venta.CatalogoGeneral(nombreProducto,categoriaProducto,precio)
	select nombre, categoria,cast(precio as decimal(12,2)) from #catalogoTemporal
	
	drop table #catalogoTemporal
end
go
--sp para importar accesorios electronicos a catalogoGeneral

create procedure administracion.ImportarAccesoriosElectronicos(@ruta nvarchar(max))
as
begin
      declare @duplicados nvarchar(max)
	  set @duplicados = ' with repetidos(producto,precioUnitario,duplicado) as
						  (
							 select producto,precioUnitarioDolares, ROW_NUMBER()over(partition by producto order by precioUnitarioDolares) as repe
							 from #tablaTemporal
						  ) 
						  delete from repetidos
						  where duplicado>1'

      declare @bulkInsertar nvarchar(max)
	  set @bulkInsertar =    'bulk insert #tablaTemporal
							from ''' + @ruta + '''
							with(
							   fieldterminator = '''+';'+''',
							   rowterminator = '''+'\n'+''',
							   codepage = ''' + 'ACP' + ''',
							   firstrow = 2)'

	  CREATE TABLE #tablaTemporal(
			 producto varchar(255),
			 precioUnitarioDolares varchar(255)
	  )
	  exec sp_executesql @bulkInsertar
	 
	  update #tablaTemporal
	  set precioUnitarioDolares = REPLACE(precioUnitarioDolares,',','.')
	  where precioUnitarioDolares like '%,%'

	  exec sp_executesql @duplicados

	  insert into venta.CatalogoGeneral(nombreProducto,categoriaProducto,precio)
	  select producto, 'Accesorios_Electronicos',cast(precioUnitarioDolares as decimal(12,2))*1050 from #tablaTemporal

	  drop table #tablaTemporal
end
go

/*
exec administracion.ImportarAccesoriosElectronicos
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Electronic accessories.csv'
*/
------Sp para importar productos importados
create procedure administracion.ImportarProductoImportado(@ruta nvarchar(max))
as
begin  
       declare @duplicados nvarchar(max)
	   set @duplicados = '
						with repetidos(nombreProducto,categoria,precioUnidad, duplicado)
						as
						(
						 select nombreProducto,categoria, precioUnidad, ROW_NUMBER() over(partition by nombreProducto, categoria order by precioUnidad desc) as repe
						 from #tablaTemp
						)
						delete from repetidos
						where duplicado > 1'
  
       declare @bulkInsertar nvarchar(max)
	   set @bulkInsertar =    'bulk insert #tablaTemp
							from ''' + @ruta + '''
							with(
							   fieldterminator = '''+';'+''',
							   rowterminator = '''+'\n'+''',
							   codepage = ''' + 'ACP' + ''',
							   firstrow = 2)'

		create table #tablaTemp(
		  idProducto varchar(75),
		  nombreProducto varchar(75),
		  proveedor varchar(75),
		  categoria varchar(75),
		  cantidadPorUnidad varchar(75),
		  precioUnidad varchar(75)
		)
		exec sp_executesql @bulkInsertar

		update #tablaTemp
		set precioUnidad = REPLACE(precioUnidad,'$','')
		where precioUnidad like '%$%'

		update #tablaTemp
		set precioUnidad = REPLACE(precioUnidad,',','.')
		where precioUnidad like '%,%'

		exec sp_executesql @duplicados
		
	    insert into venta.CatalogoGeneral(nombreProducto,categoriaProducto,precio)
	    select nombreProducto, categoria, cast(precioUnidad as decimal(12,2)) from #tablaTemp

		drop table #tablaTemp
end
go
/*
exec administracion.ImportarProductoImportado 'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Productos_importados(Listado de Productos).csv'
*/
----
create procedure administracion.ImportarLineaProducto(@ruta nvarchar(max))
as
begin
       declare @duplicados nvarchar(max)
	   set @duplicados = '	    with cte (producto,categoria,precio,duplicado)as
								(
								 select producto,lineaDeProducto,null, ROW_NUMBER()over(partition by producto,lineaDeProducto order by producto) as repe
								 from #temporalTabla
								)
								delete from cte 
								where duplicado > 1'

       declare @bulkInsertar nvarchar(max)
	   set @bulkInsertar =    'bulk insert #temporalTabla
							from ''' + @ruta + '''
							with(
							   fieldterminator = '''+';'+''',
							   rowterminator = '''+'\n'+''',
							   codepage = ''' + 'ACP' + ''',
							   firstrow = 2)'
  
	   create table #temporalTabla(
			 lineaDeProducto varchar(255),
			 producto varchar(255)
	   )

	   exec sp_executesql @bulkInsertar
	   exec sp_executesql @duplicados
		
	   insert into venta.CatalogoGeneral(nombreProducto,categoriaProducto,precio)
	   select producto, lineaDeProducto,null from #temporalTabla	   

	   drop table #temporalTabla
end
go
/*
exec administracion.ImportarLineaProducto
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Informacion_complementaria(Clasificacion productos).csv'
*/
---pasos necesarios para importar en la tabla transacciones las ventas anteriores
/*
create table #tablaTemporal(
     idFactura char(11) check(idFactura like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9]'),
	 tipoFactura char(1),
	 ciudad varchar(50),
	 tipoCliente varchar(30),
	 genero varchar(20),
	 producto varchar(100),
	 precioUnitario decimal(6,2),
	 cantidad int,
	 fecha varchar(30),
	 hora time,
	 medioPago varchar(30),
	 idEmpleado int,
	 identificadorDePago char(23)
)
go

bulk insert #tablaTemporal
from 'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Ventas_registradas.csv'
with(
		 fieldterminator = ';',
		 rowterminator = '\n',
		 codepage = 'ACP',
		 firstrow= 2
)
go
*/

create function administracion.ModificarFecha(@fecha varchar(50))
returns date
as
begin
     declare @fecharetorno date
     set @fecharetorno =  convert(date,@fecha,101)

	 return @fecharetorno
end
go
/*
insert into venta.Transacciones(idFactura, tipoFactura , ciudad , tipoCliente , genero , producto , precioUnitario , cantidad , fecha, hora , medioPago , idEmpleado , identificadorDePago)
select idFactura, tipoFactura , ciudad , tipoCliente , genero , producto , precioUnitario , cantidad ,
      administracion.ModificarFecha(fecha),hora, medioPago ,idEmpleado ,identificadorDePago
	  from #tablaTemporal
go
*/

create or alter procedure venta.InsertarVenta(@ruta nvarchar(max))
as
begin
     declare @repetidos nvarchar(max)
	 set @repetidos = 'with repetidos(idFactura,duplicados) as 
						(
						  select idFactura, ROW_NUMBER() over (partition by idFactura order by precioUnitario desc) as repe
						  from #tablaTemporal
						)
						delete from repetidos
						where duplicados > 1'


     declare @bulkInsertar nvarchar(max)
	 set @bulkInsertar =    'bulk insert #tablaTemporal
							from ''' + @ruta + '''
							with(
							   fieldterminator = '''+';'+''',
							   rowterminator = '''+'\n'+''',
							   codepage = ''' + 'ACP' + ''',
							   firstrow = 2)'

     create table #tablaTemporal(
		 idFactura char(11) check(idFactura like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9]'),
		 tipoFactura char(1),
		 ciudad varchar(50),
		 tipoCliente varchar(30),
		 genero varchar(20),
		 producto varchar(100),
		 precioUnitario decimal(6,2),
		 cantidad int,
		 fecha varchar(30),
		 hora time,
		 medioPago varchar(30),
		 idEmpleado int,
		 identificadorDePago char(23)
     )

	 exec sp_executesql @bulkInsertar
	 exec sp_executesql @repetidos

     insert into venta.Transacciones(idFactura, tipoFactura , ciudad , tipoCliente , genero , producto , precioUnitario , cantidad , fecha, hora , medioPago , idEmpleado , identificadorDePago)
     select idFactura, tipoFactura , ciudad , tipoCliente , genero , producto , precioUnitario , cantidad ,
     administracion.ModificarFecha(fecha),hora, medioPago ,idEmpleado ,identificadorDePago
	 from #tablaTemporal

	 drop table #tablaTemporal
end
go

/*
exec venta.InsertarVenta 
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Ventas_registradas.csv'

select*from venta.Transacciones
*/