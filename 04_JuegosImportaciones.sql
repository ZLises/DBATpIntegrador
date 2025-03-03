
/*

rutas usadas para importar:
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\catalogo.csv'
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Electronic accessories.csv'
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Productos_importados(Listado de Productos).csv'
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Informacion_complementaria(Clasificacion productos).csv'
*/

use AgainDB
go

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
---limpia el codigo antes de crear
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
--------------------------

exec administracion.ImportarCatalogo 
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\catalogo.csv'

exec administracion.ImportarAccesoriosElectronicos
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Electronic accessories.csv'

exec administracion.ImportarProductoImportado
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Productos\Productos_importados(Listado de Productos).csv'

exec administracion.ImportarLineaProducto
'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Informacion_complementaria(Clasificacion productos).csv'

select*from venta.CatalogoGeneral