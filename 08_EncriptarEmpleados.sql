use AgainDB
go

select*from rrhh.Empleado

ALTER TABLE rrhh.Empleado
add calleCifrada varbinary(256)
go

ALTER TABLE rrhh.Empleado
add nombreCifrado varbinary(256)
go

ALTER TABLE rrhh.Empleado
add apellidoCifrado varbinary(256)
go


declare @claveCifrado nvarchar(128)
set @claveCifrado = 'Dormi4hs'
update rrhh.Empleado
set apellidoCifrado = EncryptByPassPhrase(@claveCifrado,  
			 apellido,1, CONVERT(varbinary, apellido))  
go

declare @claveCifrado nvarchar(128)
set @claveCifrado = 'Dormi4hs'
update rrhh.Empleado
set nombreCifrado = EncryptByPassPhrase(@claveCifrado,  
			 nombre,1, CONVERT(varbinary, nombre)) 
go

declare @claveCifrado nvarchar(128)
set @claveCifrado = 'Dormi4hs'
update rrhh.Empleado
set calleCifrada = EncryptByPassPhrase(@claveCifrado,  
			 calle,1, CONVERT(varbinary, calle))  
go

update rrhh.Empleado
set calle = ''

update rrhh.Empleado
set nombre = ''

update rrhh.Empleado
set apellido = ''
