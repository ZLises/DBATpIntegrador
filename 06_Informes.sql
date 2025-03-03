use AgainDB
go
--en empleado agregar los turnos TT,TM,JC
/*
Mensual: ingresando un mes y año determinado mostrar el total facturado por días de 
la semana, incluyendo sábado y domingo.
*/

select*from venta.Transacciones

--mes 03 año 2025
------------
with asd(dia,montoTotal)as
(
   select dias,(cast(cantidad as decimal(12,2))*preciounitario) as monto from(
	select *, datename(dw,fecha) as dias from venta.Transacciones
	where year(fecha) = 2025 and month(fecha) = 03
  )as subquery
)
select '2025-03',* from asd
pivot(sum(montoTotal) for dia in([Lunes],[Martes],[Miércoles],[Jueves],
							[Viernes],[Sabado],[Domingo]))as h
--------
--cast(datepart(mm,fecha))
go

create or alter procedure administracion.InformeMesual(@anio int, @mes int)
as
begin

        declare @fechaCadena varchar(30)
		set @fechaCadena = ''''+ cast(@anio as varchar(4)) + '-'+ cast(@mes as varchar(2)) + ''''

		declare @query nvarchar(max) = '
										with asd(dia,montoTotal)as
										(
										   select dias,(cast(cantidad as decimal(12,2))*preciounitario) as monto from(
											select *, datename(dw,fecha) as dias from venta.Transacciones
											where year(fecha) = '+ cast(@anio as varchar(4)) +' and month(fecha) ='+ cast(@mes as varchar(2)) +'
										  )as subquery
										)
										select '+ @fechaCadena + ',* from asd
										pivot(sum(montoTotal) for dia in([Lunes],[Martes],[Miércoles],[Jueves],
																	[Viernes],[Sabado],[Domingo]))as h
																	
										FOR XML AUTO,ELEMENTS'
										--FOR XML AUTO,ELEMENTS,ROOT(''dia'')
      exec sp_executesql @query
end
go

exec administracion.InformeMesual 2025,3
exec administracion.InformeMesual 2019,2
