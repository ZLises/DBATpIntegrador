/*
Luego de decidirse por un motor de base de datos relacional, llegó el momento de generar la 
base de datos. En esta oportunidad utilizarán SQL Server. 
Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle 
las configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos, 
etc.) en un documento como el que le entregaría al DBA. 
Incluya también un DER con el diseño de la base de datos. Deben aparecer correctamente 
las relaciones y las claves, pero el formato queda a su criterio. 
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar 
un archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es 
entregado en una sola ejecución). Incluya comentarios para indicar qué hace cada módulo 
de código.  
Genere store procedures para manejar la inserción, modificado, borrado (si corresponde, 
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla. 
Los nombres de los store procedures NO deben comenzar con “SP”.  
Algunas operaciones implicarán store procedures que involucran varias tablas, uso de 
transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs. 
Asegúrense de que los comentarios que acompañen al código lo expliquen. 
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto 
en la creación de objetos. NO use el esquema “dbo”.  
Todos los SP creados deben estar acompañados de juegos de prueba. Se espera que 
realicen validaciones básicas en los SP (p/e cantidad mayor a cero, CUIT válido, etc.) y que 
en los juegos de prueba demuestren la correcta aplicación de las validaciones. 
Las pruebas deben realizarse en un script separado, donde con comentarios se indique en 
cada caso el resultado esperado 

*/

use master 
go
--creacion de la base de datos
IF EXISTS(
	select name from master.dbo.sysdatabases
	where name = 'COM1353G05'
)
 BEGIN
    print 'La base de datos ya existe'
 END
ELSE
 BEGIN
    CREATE DATABASE COM1353G05
 END
GO

--usar la base de datos creada
USE COM1353G05
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
--creacion de la tabla ciudad para situar a la sucursal en una ciudad
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
 --creacion de la tabla sucursal
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

--creacion de la tabla empleado
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

--creacion de tipos de cliente, para clasificar a los clientes normales, de los clientes Member
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

--generacion de la tabla cliente
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

--generacion de la tabla telefono cliente, para asignarle varios telefonos si es necesario a 1 cliente
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
--generacion de la tabla telefono empleado, para asignarle varios telefonos si es necesario a 1 empleado
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
--generacion de la tabla medioPago que se va a encargar de administrar los tipos de pagos que hay en la empresa
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
--generacion de la tabla factura, para administrar los tipos de facturas que hay disponibles
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
---generacion de la tabla que almacena las transacciones y su informacion
IF OBJECT_ID(N'venta.Transacciones',N'U') IS NULL
 BEGIN 
   CREATE TABLE venta.Transacciones(
     idTransaccion int identity(1,1) primary key,
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
---creacion de la tabla catalogo general, que es la union de los catalogos de todas las sucursales
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
--generacion de la tabla nota de credito, para almacenar informacion por si un cliente solicita reembolso
IF OBJECT_ID(N'venta.NotaDeCredito',N'U') IS NULL
begin
		create table venta.NotaDeCredito(
		   idNotaDeCredito int identity(1,1) primary key,
		   idFactura char(11),
		   montoTotal decimal(12,2),
		   fecha datetime not null
		)
end
else
 begin
 print 'Ya existe la tabla NotaDeCredito'
 end
go