use master 
go
--creacion de la base de datos
IF EXISTS(
	select name from master.dbo.sysdatabases
	where name = 'AgainDB'
)
 BEGIN
    print 'La base de datos ya existe'
 END
ELSE
 BEGIN
    CREATE DATABASE [AgainDB]
 END
GO

--usar la base de datos creada
USE AgainDB
GO

 
--CREACION ESQUEMAS A UTILIZAR
IF EXISTS(
        select name
		from sys.schemas
		where name = 'rrhh')
 BEGIN
  print 'El esquema rrhh ya existe'
 END
ELSE
 BEGIN
  exec('CREATE SCHEMA rrhh')
 END
GO

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

IF EXISTS(
        select name
		from sys.schemas
		where name = 'administracion')
 BEGIN
  print 'El esquema administracion ya existe'
 END
ELSE
 BEGIN
  exec('CREATE SCHEMA administracion')
 END
GO
---------------------------------

IF OBJECT_ID(N'rrhh.Ciudad',N'U') IS NULL
 BEGIN
   CREATE TABLE rrhh.Ciudad(
     nombreCiudad varchar(30) primary key
   )
 END
ELSE
 BEGIN
  print 'La tabla ciudad ya existe'
 END
GO
 
IF OBJECT_ID(N'rrhh.Sucursal',N'U') IS NULL
 BEGIN
   CREATE TABLE rrhh.Sucursal(
     idSucursal int identity(1,1) primary key,
	 nombreCiudad varchar(30),
	 foreign key (nombreCiudad) references rrhh.Ciudad(nombreCiudad)
   )
 END
ELSE
 BEGIN
  print 'La tabla sucursal ya existe'
 END
GO


IF OBJECT_ID(N'rrhh.Empleado',N'U') IS NULL
 BEGIN 
   CREATE TABLE rrhh.Empleado(
     idEmpleado int primary key,
	 calle varchar(20),
	 numeroCalle int,
	 fechaDeAlta datetime not null,
	 nombre varchar(20),
	 apellido varchar(20),
	 idSucursal int,
	 cuil char(11) check(cuil like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique,
	 foreign key (idSucursal) references rrhh.Sucursal(idSucursal)
   )
 END
ELSE
 BEGIN
   print 'La tabla empleado ya existe'
 END
GO


IF OBJECT_ID(N'rrhh.Empleado',N'U') IS NULL
 BEGIN 
   CREATE TABLE rrhh.Empleado(
     idEmpleado int primary key,
	 calle varchar(20),
	 numeroCalle int,
	 piso TINYINT default(0),
	 fechaDeAlta datetime not null,
	 nombre varchar(20),
	 apellido varchar(20),
	 idSucursal int,
	 cuil char(11) check(cuil like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique,
	 foreign key (idSucursal) references rrhh.Sucursal(idSucursal)
   )
 END
ELSE
 BEGIN
   print 'La tabla empleado ya existe'
 END
GO

IF OBJECT_ID(N'rrhh.TipoCliente',N'U') IS NULL
 BEGIN 
  CREATE TABLE rrhh.TipoCliente(
    tipoCliente varchar(30) primary key
  )
 END
ELSE
 BEGIN
   print 'Ya existe la tabla TipoCliente'
 END
GO

IF OBJECT_ID(N'venta.Cliente',N'U') IS NULL
 BEGIN 
  CREATE TABLE venta.Cliente(
    idCliente int primary key,
	calle varchar(20),
	numeroCalle int,
	cuil char(11) check(cuil like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') unique,
	nombre varchar(20),
	apellido varchar(20),
	tipoCliente varchar(30),
	genero varchar(20),
	foreign key (tipoCliente) references rrhh.TipoCliente(tipoCliente)
  )
 END
ELSE
 BEGIN
  print 'La tabla Cliente ya existe'
 END
GO	


IF OBJECT_ID(N'venta.TelefonoCliente',N'U') IS NULL
 BEGIN
    CREATE TABLE venta.TelefonoCliente(
	  idCliente int,
	  telefono int,
	  foreign key (idCliente) references venta.Cliente(idCliente)
	)
 END
ELSE 
 BEGIN
   print 'La tabla telefono cliente ya existe'
 END
GO

IF OBJECT_ID(N'rrhh.TelefonoEmpleado',N'U') IS NULL
 BEGIN
    CREATE TABLE rrhh.TelefonoEmpleado(
	  idEmpleado int,
	  telefono int,
	  foreign key (idEmpleado) references rrhh.Empleado(idEmpleado)
	)
 END
ELSE 
 BEGIN
   print 'La tabla telefono empleado ya existe'
 END
GO

IF OBJECT_ID(N'administracion.MedioPago',N'U') IS NULL
 BEGIN
  CREATE TABLE administracion.MedioPago(
   tipoPago varchar(30) primary key
  )
 END
ELSE 
 BEGIN
  print 'Ya existe la tabla MedioPago'
 END
GO

IF OBJECT_ID(N'administracion.TipoFactura',N'U') IS NULL
 BEGIN
  CREATE TABLE administracion.TipoFactura(
   tipoFactura char(1) check(tipoFactura like'[A-Z]') primary key
  )
 END
ELSE 
 BEGIN
  print 'Ya existe la tabla TipoFactura'
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

	 foreign key (idEmpleado) references rrhh.Empleado(idEmpleado),
	 foreign key (tipoCliente) references rrhh.TipoCliente(tipoCliente),
	 foreign key (tipoFactura) references administracion.TipoFactura(tipoFactura),
	 foreign key (medioPago) references administracion.MedioPago(tipoPago)
   )
 END
ELSE
 BEGIN
   print 'La tabla transacciones ya existe'
 END
GO

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