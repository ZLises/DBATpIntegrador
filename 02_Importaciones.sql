use AgainDB
go

/*
IF OBJECT_ID(N'venta.CatalogoGeneral', N'U') IS NULL
begin
   CREATE TABLE venta.CatalogoGeneral(
      idProducto int identity(1,1) primary key,
	  nombreProducto varchar(200),
	  categoriaProducto varchar(255),
	  precio decimal(12,2)
   )
end
else
begin
  print 'Ya existe la tabla catalogoGeneral'
end
*/

create table #catalogoTemporal(
  id varchar(255),
  categoria varchar(255),
  nombre varchar(255),
  precio varchar(255),
  precioReferencia varchar(255),
  unidad  varchar(255),
  fecha varchar(255)
)
go

BULK Insert #catalogoTemporal
from 'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\catalogo.csv'
with(
   fieldterminator = ',',
   rowterminator = '\n',
   firstrow = 2
)
go
------------------------------------

update #catalogoTemporal
set nombre = nombre +' '+ precio+' ' + precioReferencia 
where precioReferencia like '%"%'
go

update #catalogoTemporal
set precio = unidad
where precioReferencia like '%"%'
go

update #catalogoTemporal
set precioReferencia = substring(fecha,1,CHARINDEX(',',fecha)) + 'x'
where precioReferencia like '%"%'
go

update #catalogoTemporal
set precioReferencia = REPLACE(precioReferencia,',','')
where precioReferencia like '%x%'
go

update #catalogoTemporal
set fecha = substring(fecha,CHARINDEX(',',fecha)+1, len(fecha))
where precioReferencia like '%x%'
go

update #catalogoTemporal
set unidad = SUBSTRING(fecha,1,CHARINDEX(',',fecha))
where precioReferencia like '%x%'
go

update #catalogoTemporal
set unidad = REPLACE(unidad,',','')
where unidad like '%,%'
go

update #catalogoTemporal
set fecha = substring(fecha,CHARINDEX(',',fecha)+1, len(fecha))
where precioReferencia like '%x%'
go--

update #catalogoTemporal
set fecha = REPLACE(fecha,'"','')
where precioReferencia like '%x%'
go--

update #catalogoTemporal
set precioReferencia = REPLACE(precioReferencia,'x','')
where precioReferencia like '%x%'
go
---------------------

--elimina comillas de los ids
update #catalogoTemporal
set id = REPLACE(id,'"','')
where id like '%"%'
go
------------------
update #catalogoTemporal
set nombre = nombre + ' ' + precio 
where precio like '%"%'
go--

update #catalogoTemporal
set precio = precioReferencia + 'x'
where precio like '%"%'
go--

update #catalogoTemporal
set precioReferencia = unidad 
where precio like '%x%'
go

update #catalogoTemporal
set unidad = SUBSTRING(fecha,1,CHARINDEX(',',fecha)-1)
where precio like '%x%'
go--

update #catalogoTemporal
set fecha = substring(fecha,CHARINDEX(',',fecha)+1, len(fecha))
where precio like '%x%'
go--

update #catalogoTemporal
set precio = REPLACE(precio,'x','')
where precio like '%x%'
go--

update #catalogoTemporal
set fecha = REPLACE(fecha,'"','')
where fecha like '%"%'
go
-----------------------
update #catalogoTemporal
set nombre = nombre + ' ' + precio + ' ' + precioReferencia + ' ' + unidad
where precio like '%i%'
go--

update #catalogoTemporal
set precio = SUBSTRING(fecha,1,CHARINDEX(',',fecha)-1)
where precio like '%i%'
go--

update #catalogoTemporal
set fecha = SUBSTRING(fecha,CHARINDEX(',',fecha)+1,len(fecha))
where unidad like '%"%'
go--

update #catalogoTemporal
set precioReferencia = SUBSTRING(fecha,1,CHARINDEX(',',fecha)-1)
where unidad like '%"%'
go--

update #catalogoTemporal
set unidad = SUBSTRING(fecha,1,charindex(',',fecha)-1) + '"'
where unidad like '%"%'
go--

update #catalogoTemporal
set fecha = SUBSTRING(fecha,CHARINDEX(',',fecha)+1,len(fecha))
where unidad like '%"%'
go--

update #catalogoTemporal
set unidad = SUBSTRING(fecha,1,charindex(',',fecha)-1) + '"'
where unidad like '%"%'
go--

update #catalogoTemporal
set fecha = SUBSTRING(fecha,CHARINDEX(',',fecha)+1,len(fecha))
where unidad like '%"%'
go--

update #catalogoTemporal
set unidad = REPLACE(unidad,'"','')
where unidad like '%"%'
go--
---------------------------------------

update #catalogoTemporal
set nombre = nombre + ' ' + precio + ' ' + precioReferencia + ' ' + unidad + SUBSTRING(fecha,1,charindex(',',fecha)-1)
where unidad like '%albaricoque%'
go--

update #catalogoTemporal
set fecha = SUBSTRING(fecha,charindex(',',fecha)+1,len(fecha))
where unidad like '%albaricoque%'
go

update #catalogoTemporal
set precio = SUBSTRING(fecha,1,charindex(',',fecha)-1)
where unidad like '%albaricoque%'

update #catalogoTemporal
set fecha = SUBSTRING(fecha,charindex(',',fecha)+1,len(fecha))
where unidad like '%albaricoque%'
go

update #catalogoTemporal
set precioReferencia = SUBSTRING(fecha,1,charindex(',',fecha)-1) 
where unidad like '%albaricoque%'

update #catalogoTemporal
set fecha = SUBSTRING(fecha,charindex(',',fecha)+1,len(fecha))
where unidad like '%albaricoque%'
go

update #catalogoTemporal
set unidad = SUBSTRING(fecha,1,charindex(',',fecha)-1) + '"'
where unidad like '%albaricoque%'
go

update #catalogoTemporal
set fecha = SUBSTRING(fecha,charindex(',',fecha)+1,len(fecha))
where unidad like '%"%'
go

update #catalogoTemporal
set unidad = REPLACE(unidad,'"','')
where unidad like '%"%'
go--
------------------------------------
--sacar comillas de los nombres
update #catalogoTemporal
set nombre = REPLACE(nombre,'"','')
where nombre like '%"%'
go
--e
update #catalogoTemporal
set nombre = REPLACE(nombre,'+®','e')
where nombre like '%+®%'
go
--o
update #catalogoTemporal
set nombre = REPLACE(nombre,'+¦','o')
where nombre like '%+¦%'
go
--i
update #catalogoTemporal
set nombre = REPLACE(nombre,'+¡','i')
where nombre like '%+¡%'
go
--u
update #catalogoTemporal
set nombre = REPLACE(nombre,'++','u')
where nombre like '%++%'
go
--a
update #catalogoTemporal
set nombre = REPLACE(nombre,'+í','a')
where nombre like '%+í%'
go
---hasta aca se limpia toda la tabla

--sp para importar catalogo a catalogoGeneral
create procedure administracion.ImportarCatalogo(@ruta nvarchar(max))
as
begin 
    declare @bulkInsertar nvarchar(max)
	set @bulkInsertar =    'bulk insert #temporal
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

create or alter procedure administracion.ImportarAccesoriosElectronicos(@ruta nvarchar(max))
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

exec administracion.ImportarAccesoriosElectronicos
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Electronic accessories.csv'

----
create or alter procedure administracion.ImportarProductoImportado(@ruta nvarchar(max))
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

exec administracion.ImportarProductoImportado 'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Productos_importados(Listado de Productos).csv'

select*from venta.CatalogoGeneral
----