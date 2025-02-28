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
Trabajo Práctico Integrador 
Pág. 11 de 12 
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

USE COM1353G05
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
		from '\BDATrabajoPractico\ArchivosImportar\Productos\Productos_importados(Listado de Productos).csv'
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

create table #tablaTemporal(
     idFactura char(11) check(idFactura like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9]') unique,
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
from 'C:\Users\ulaza\Documents\SQL Server Management Studio\BDATrabajoPractico\BDATrabajoPractico\ArchivosImportar\Ventas_registradas.csv'--ruta procedurencio valera
with(
		 fieldterminator = ';',
		 rowterminator = '\n',
		 codepage = 'ACP',
		 firstrow= 2
)
go
insert into obj.MedioPago(tipoPago)
select medioPago from #tablaTemporal
group by medioPago
go

insert into obj.TipoFactura
select tipoFactura from #tablaTemporal
group by tipoFactura
having tipoFactura != 'A'
go

insert into obj.TipoCliente
select tipoCliente from #tablaTemporal
group by tipoCliente
having tipoCliente != 'Normal'
go

create function importar.ModificarFecha(@fecha varchar(50))
returns date
as
begin
     declare @fecharetorno date
     set @fecharetorno =  convert(date,@fecha,101)

	 return @fecharetorno
end
go
--
create procedure importar.InsertarEmpleadosRandom(@cantidad int, @idEmpleado int,@cuil bigint)
as
begin
   declare @calle varchar(30)
   declare @numeroCalle int
   declare @piso tinyint
   declare @fecha datetime  
   declare @nombre varchar(20)
   declare @apellido varchar(20)
   declare @auxcuil char(11)

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

	set @piso = cast(rand()*(5+1)-1 as tinyint)

	set @fecha = getdate()

	set @nombre = case cast(rand()*(5+1)-1 as int)   
								when 1 then 'Julian'
								when 2 then 'Enzo'
								when 3 then 'Cuti'
								else 'Alexis'
								end
	set @apellido = case cast(rand()*(5+1)-1 as int)   
								when 1 then 'Alvarez'
								when 2 then 'Fernandez'
								when 3 then 'Romero'
								else 'Mac Allister'
								end
	 set @auxcuil = cast(@cuil as char(11))
------------------------------------------------
     exec usar.InsertarEmpleado @idEmpleado,@calle,@numeroCalle,@piso,@fecha,@nombre,@apellido,2,@auxcuil
	 
	 set @cuil = @cuil - 100
     set @idEmpleado = @idEmpleado + 1
     set @cantidad = @cantidad - 1
   end
end
go

exec importar.InsertarEmpleadosRandom 7, 257020, 20137874563
go

---insertar los datos directamente a la tabla 
insert into venta.Transacciones(idFactura, tipoFactura , ciudad , tipoCliente , genero , producto , precioUnitario , cantidad , fecha, hora , medioPago , idEmpleado , identificadorDePago)
select idFactura, tipoFactura , ciudad , tipoCliente , genero , producto , precioUnitario , cantidad ,
      importar.ModificarFecha(fecha),hora, medioPago ,idEmpleado ,identificadorDePago
	  from #tablaTemporal
go

drop table #tablaTemporal
go