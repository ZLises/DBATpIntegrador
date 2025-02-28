use master 
go
--creacion de la base de datos
IF EXISTS(
	select name from master.dbo.sysdatabases
	where name = 'FIGHT'
)
 BEGIN
    print 'La base de datos ya existe'
 END
ELSE
 BEGIN
    CREATE DATABASE FIGHT
 END
GO

--usar la base de datos creada
USE FIGHT
GO
 
--creacion del esquema principal
IF EXISTS(
        select name
		from sys.schemas
		where name = 'obj')
 BEGIN
  print 'El esquema obj ya existe'
 END
ELSE
 BEGIN
  exec('CREATE SCHEMA obj')
 END
GO


IF OBJECT_ID(N'obj.Ciudad',N'U') IS NULL
 BEGIN
   CREATE TABLE obj.Ciudad(
     nombreCiudad varchar(30) primary key
   )
 END
ELSE
 BEGIN
  print 'La tabla ciudad ya existe'
 END
GO

IF OBJECT_ID(N'obj.Sucursal',N'U') IS NULL
 BEGIN
   CREATE TABLE obj.Sucursal(
     idSucursal int identity(1,1) primary key,
	 nombreCiudad varchar(30),
	 foreign key (nombreCiudad) references obj.Ciudad(nombreCiudad)
   )
 END
ELSE
 BEGIN
  print 'La tabla sucursal ya existe'
 END
GO

IF OBJECT_ID(N'obj.Empleado',N'U') IS NULL
 BEGIN 
   CREATE TABLE obj.Empleado(
     idEmpleado int primary key,
	 calle varchar(20),
	 numeroCalle int,
	 piso TINYINT default(0),
	 fechaDeAlta datetime not null,
	 nombre varchar(20),
	 apellido varchar(20),
	 idSucursal int,
	 cuil char(11) check(cuil like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique,
	 foreign key (idSucursal) references obj.Sucursal(idSucursal)
   )
 END
ELSE
 BEGIN
   print 'La tabla empleado ya existe'
 END
GO

IF OBJECT_ID(N'obj.TipoCliente',N'U') IS NULL
 BEGIN 
  CREATE TABLE obj.TipoCliente(
    tipoCliente varchar(30) primary key
  )
 END
ELSE
 BEGIN
   print 'Ya existe la tabla TipoCliente'
 END
GO

IF OBJECT_ID(N'principal.Cliente',N'U') IS NULL
 BEGIN 
  CREATE TABLE obj.Cliente(
    idCliente int primary key,
	calle varchar(20),
	numeroCalle int,
	piso TINYINT default(0),
	cuil char(11) check(cuil like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique,
	nombre varchar(20),
	apellido varchar(20),
	tipoCliente varchar(30),
	genero varchar(20),
	foreign key (tipoCliente) references obj.TipoCliente(tipoCliente)
  )
 END
ELSE
 BEGIN
  print 'La tabla Cliente ya existe'
 END
GO	

IF OBJECT_ID(N'obj.TelefonoEmpleado',N'U') IS NULL
 BEGIN
    CREATE TABLE obj.TelefonoEmpleado(
	  idEmpleado int,
	  telefono int,
	  foreign key (idEmpleado) references obj.Empleado(idEmpleado)
	)
 END
ELSE 
 BEGIN
   print 'La tabla telefono empleado ya existe'
 END
GO

IF OBJECT_ID(N'obj.TelefonoCliente',N'U') IS NULL
 BEGIN
    CREATE TABLE obj.TelefonoCliente(
	  idCliente int,
	  telefono int,
	  foreign key (idCliente) references obj.Cliente(idCliente)
	)
 END
ELSE 
 BEGIN
   print 'La tabla telefono cliente ya existe'
 END
GO

IF OBJECT_ID(N'obj.MedioPago',N'U') IS NULL
 BEGIN
  CREATE TABLE obj.MedioPago(
   tipoPago varchar(30) primary key
  )
 END
ELSE 
 BEGIN
  print 'Ya existe la tabla MedioPago'
 END
GO

IF OBJECT_ID(N'obj.TipoFactura',N'U') IS NULL
 BEGIN
  CREATE TABLE obj.TipoFactura(
   tipoFactura char(1) check(tipoFactura like'[A-Z]') primary key
  )
 END
ELSE 
 BEGIN
  print 'Ya existe la tabla TipoFactura'
 END
GO
-- esquema para usar sp
IF EXISTS(
        select name
		from sys.schemas
		where name = 'usar')
 BEGIN
  print 'El esquema usar ya existe'
 END
ELSE
 BEGIN
  exec('CREATE SCHEMA usar')
 END
GO
-- ventas
IF EXISTS(
        select name
		from sys.schemas
		where name = 'venta')
 BEGIN
  print 'El esquema venta ya existe'
 END
ELSE
 BEGIN
  exec('CREATE SCHEMA venta')
 END
GO

IF OBJECT_ID(N'venta.Transacciones',N'U') IS NULL
 BEGIN 
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

	 foreign key (idEmpleado) references obj.Empleado(idEmpleado),
	 foreign key (tipoCliente) references obj.TipoCliente(tipoCliente),
	 foreign key (tipoFactura) references obj.TipoFactura(tipoFactura),
	 foreign key (medioPago) references obj.MedioPago(tipoPago)
   )
 END
ELSE
 BEGIN
   print 'La tabla transacciones ya existe'
 END
GO

--esquema para importar archivos
IF EXISTS(
        select name
		from sys.schemas
		where name = 'importar')
 BEGIN
  print 'El esquema importar ya existe'
 END
ELSE
 BEGIN
  exec('CREATE SCHEMA importar')
 END
GO

IF OBJECT_ID(N'importar.Catalogo',N'U')IS NULL
BEGIN
create table importar.Catalogo(
  id int,
  categoria varchar(180),
  nombre varchar(180),
  precio decimal(8,2),
  precioReferencia decimal(8,2),
  unidad char(6),
  fecha datetime
)
END
ELSE
 BEGIN
   print 'Ya existe la tabla catalogo'
 END
go

----tablas necesarias para la importacion

IF OBJECT_ID(N'obj.AccesorioElectronico',N'U') IS NULL
begin
		CREATE TABLE obj.AccesorioElectronico
		(
		   producto varchar(200),
		   precioUnitarioDolares decimal(8,2)
		)
end
else
begin
     print 'Ya existe la tabla accesorio electronico'
end
go

if OBJECT_ID(N'obj.ProductoImportado',N'U')is null
begin
create table obj.ProductoImportado(
   idProducto int,
   nombreProducto varchar(75),
   proveedor varchar(75),
   categoria varchar(75),
   cantidadPorUnidad varchar(75),
   precioUnidad decimal(6,2)
)
end
else
begin
  print 'La tabla productoImportado ya existe'
end
go



--tablas que no tengo que juntar
IF OBJECT_ID(N'obj.LineaProducto',N'U') IS NULL
begin
create table obj.LineaProducto(
   lineaDeProducto varchar(120),
   producto varchar(120)
)
end
else
begin
  print 'La tabla linea de producto ya existe'
end
go