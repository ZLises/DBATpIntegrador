USE FIGHT
GO
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
from '\BDATrabajoPractico\ArchivosImportar\Productos\catalogo.csv'
with(
   fieldterminator = ',',
   rowterminator = '\n',
   firstrow = 2
)
go
--modificaciones de la tabla
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
select*from #catalogoTemporal
where precio like '%i%'

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

insert into importar.Catalogo(id,categoria,nombre,precio,precioReferencia,unidad,fecha)
select cast(id as int),categoria,nombre, convert(decimal(8,2),precio), convert(decimal(8,2),precioReferencia),cast(unidad as char(6)), convert(datetime,fecha,120)
	   from #catalogoTemporal 
go
--importe antes de eliminar la tabla temporal
drop table #catalogoTemporal
go

create procedure importar.ImportarCatalogo
as
begin
	 create table #catalogoTemporal(
	 id varchar(255),
	 categoria varchar(255),
	 nombre varchar(255),
	 precio varchar(255),
	 precioReferencia varchar(255),
	 unidad  varchar(255),
	 fecha varchar(255)
	 )

   BULK Insert #catalogoTemporal
   from '\BDATrabajoPractico\ArchivosImportar\Productos\catalogo.csv'
   with(
   fieldterminator = ',',
   rowterminator = '\n',
   firstrow = 2
   )

   insert into importar.Catalogo(id,categoria,nombre,precio,precioReferencia,unidad,fecha)
   select cast(id as int),categoria,nombre, convert(decimal(8,2),precio), convert(decimal(8,2),precioReferencia),cast(unidad as char(6)), convert(datetime,fecha,120)
   from #catalogoTemporal 

   drop table #catalogoTemporal
end
go
----
create procedure importar.ImportarAccesoriosElectronicos
as
begin
			CREATE TABLE #tablaTemporal(
			   producto varchar(255),
			   precioUnitarioDolares varchar(255)
			)

			bulk insert #tablaTemporal
			from  '\BDATrabajoPractico\ArchivosImportar\Productos\Electronic accessories.csv'
			with(
				  fieldterminator = ';',
				  rowterminator = '\n',
				  codepage = 'ACP',
				  firstrow = 2
			)

			update #tablaTemporal
			set precioUnitarioDolares = REPLACE(precioUnitarioDolares,',','.')
			where precioUnitarioDolares like '%,%'

			insert into obj.AccesorioElectronico(producto,precioUnitarioDolares)
			select producto, cast(precioUnitarioDolares as decimal(8,2)) as PrecioUDolares from #tablaTemporal

			drop table #tablaTemporal
end
go
--
create procedure importar.ImportarLineaProducto
as
begin
			create table #temporalTabla(
			  lineaDeProducto varchar(255),
			  producto varchar(255)
			)

			bulk insert #temporalTabla
			from '\BDATrabajoPractico\ArchivosImportar\Informacion_complementaria(Clasificacion productos).csv'
			with(
			 fieldterminator = ';',
			 rowterminator = '\n',
			 codepage = 'ACP',
			 firstrow= 2
			)

			insert into obj.LineaProducto(lineaDeProducto,producto)
			select lineaDeProducto,producto from #temporalTabla

			drop table #temporalTabla
end
go
---------
create procedure importar.ImportarProductoImportado
as
begin
		create table #tablaTemp(
		  idProducto varchar(75),
		  nombreProducto varchar(75),
		  proveedor varchar(75),
		  categoria varchar(75),
		  cantidadPorUnidad varchar(75),
		  precioUnidad varchar(75)
		)

		bulk insert #tablaTemp
		from 'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Productos_importados(Listado de Productos).csv'
		with(
				 fieldterminator = ';',
				 rowterminator = '\n',
				 codepage = 'ACP',
				 firstrow= 2
		)

		update #tablaTemp
		set precioUnidad = REPLACE(precioUnidad,'$','')
		where precioUnidad like '%$%'

		update #tablaTemp
		set precioUnidad = REPLACE(precioUnidad,',','.')
		where precioUnidad like '%,%'

		insert into obj.ProductoImportado(idProducto,nombreProducto,proveedor,categoria,cantidadPorUnidad,precioUnidad)
		select cast(idProducto as int),nombreProducto,proveedor,categoria,cantidadPorUnidad,cast(precioUnidad as decimal(6,2)) 
		from #tablaTemp

		drop table #tablaTemp
end
go
-------- para poder importar en la tabla venta, se necesitan registros adicionales