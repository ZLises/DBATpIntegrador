use COM1353G05
go
/*
select*from venta.Transacciones

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
go
*/

/*
Mensual: ingresando un mes y año determinado mostrar el total facturado por días de 
la semana, incluyendo sábado y domingo.
*/
create or alter procedure administracion.InformeMesual(@anio int, @mes int)
as
begin
        if(@anio > 1980 and @anio < 2026 and @mes > 1 and @mes < 13)
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
										
      exec sp_executesql @query
	  end
	  else
	  begin
	     print 'Datos erroneos'
	  end
end
go

exec administracion.InformeMesual 2025,3
go
exec administracion.InformeMesual 2019,2
go
---------------------------------------------------------
/*
with cte(Mes,Turno,monto) as(
				select 1,Turno, (precioUnitario*cantidad) as mont from venta.Transacciones t
				join rrhh.Empleado e
				on t.idEmpleado = e.idEmpleado
				where MONTH(t.fecha) = 1
			) 
select*from cte
pivot(sum(monto) for Turno in ([TM],[TT],[JC])) h
*/

/*
Trimestral: mostrar el total facturado por turnos de trabajo por mes. 
*/

create or alter procedure administracion.InformeTrimestral(@mes int)
as
begin
      if(@mes > 0 and @mes < 13)
	  begin

		declare @informe nvarchar(max) = 
		'with cte(Mes,Turno,monto) as(
						select '+cast(@mes as varchar(2))+',Turno, (precioUnitario*cantidad) as mont from venta.Transacciones t
						join rrhh.Empleado e
						on t.idEmpleado = e.idEmpleado
						where MONTH(t.fecha) ='+ cast(@mes as varchar(2))+'
					) 
		select*from cte
		pivot(sum(monto) for Turno in ([TM],[TT],[JC])) h
		FOR XML AUTO,ELEMENTS'

		exec sp_executesql @informe

	  end
	  else
	  begin 
	    print 'Mes erroneo'
	  end
end
go

exec administracion.InformeTrimestral 3
go
------------------
--agrupo por producto y cantidad 
/*
select producto, sum(cantidad) as cantidadVendida from venta.Transacciones
where fecha < '2019-03-30' and fecha > '2019-03-28'
group by producto
order by cantidadVendida desc
*/

/*
Por rango de fechas: ingresando un rango de fechas a demanda, debe poder mostrar 
la cantidad de productos vendidos en ese rango, ordenado de mayor a menor. 
*/

create or alter procedure administracion.InformePorRangoFechas(@fechaMax varchar(30),@fechaMin varchar(30))
as
begin

	select producto, sum(cantidad) as cantidadVendida from venta.Transacciones
	where fecha < cast(@fechaMax as date) and fecha > cast(@fechaMin as date)
	group by producto
	order by cantidadVendida desc
	FOR XML AUTO,ELEMENTS,ROOT('producto')
end
go

exec administracion.InformePorRangoFechas '2019-03-30','2019-03-28'
go
---------------
/*
select idFactura as IDFactura,tipoFactura as TipoFactura,ciudad as Ciudad
       ,tipoCliente as TipoCliente ,genero as Genero,
       cg.categoriaProducto as LineaDeProducto,producto as Producto
	    ,precioUnitario as Precio,cantidad as Cantidad, fecha as Fecha, hora as Hora,
	   medioPago as MedioDePago,t.idEmpleado as IDEmpleado, s.nombreCiudad as Sucursal
	   from venta.Transacciones t
	   join venta.CatalogoGeneral cg
	   on cg.nombreProducto = t.producto
	   join rrhh.Empleado e
	   on t.idEmpleado = e.idEmpleado
	   join rrhh.Sucursal s
	   on s.idSucursal = e.idSucursal

go
*/
----vista para los reportes futuros que se encuentra en el tp
create view administracion.ReporteVentas
as
select idFactura as IDFactura,tipoFactura as TipoFactura,ciudad as Ciudad
       ,tipoCliente as TipoCliente ,genero as Genero,
       cg.categoriaProducto as LineaDeProducto,producto as Producto
	    ,precioUnitario as Precio,cantidad as Cantidad, fecha as Fecha, hora as Hora,
	   medioPago as MedioDePago,t.idEmpleado as IDEmpleado, s.nombreCiudad as Sucursal
	   from venta.Transacciones t
	   join venta.CatalogoGeneral cg
	   on cg.nombreProducto = t.producto
	   join rrhh.Empleado e
	   on t.idEmpleado = e.idEmpleado
	   join rrhh.Sucursal s
	   on s.idSucursal = e.idSucursal
go

select*from administracion.ReporteVentas
---------------------------
/*
select * from(
    select Producto, sum(cantidad) as Cantidad, datepart(week,fecha)as semana,
	row_number()over(partition by datepart(week,fecha) order by sum(cantidad) desc) as orden
	from administracion.ReporteVentas
	where month(fecha) = 3
	group by Producto,datepart(week,fecha)
	) as j
where orden < 6

go
*/

/*
Mostrar los 5 productos menos vendidos en el mes por semana. 
*/
create or alter procedure administracion.ProductosMasVendidosEnUnMesPorSemana(@mes int)
as
begin
   if(@mes < 13 and @mes > 0)
   begin
   declare @query nvarchar(max) = 'select * from(
									select Producto, sum(cantidad) as Cantidad, datepart(week,fecha)as semana,
									row_number()over(partition by datepart(week,fecha) order by sum(cantidad) desc) as orden
									from administracion.ReporteVentas
									where month(fecha) = '+ cast(@mes as nvarchar(2))  +'
									group by Producto,datepart(week,fecha)
									) as j
								where orden < 6
								FOR XML AUTO,ELEMENTS'

	exec sp_executesql @query
	end
	else
	begin
	  print 'Dato de mes incorrecto'
	end
end
go
exec administracion.ProductosMasVendidosEnUnMesPorSemana 3
go
----------------------------
 /*
 select*from(
	 select  Producto, sum(cantidad) as CantidadVendidas,
	 dense_rank()over(order by sum(cantidad) asc) as Rango
	 from administracion.ReporteVentas
	 where month(Fecha) = 2
	 group by Producto)g
	 where Rango < 6
 */
/* Mostrar los 5 productos menos vendidos en el mes. */
create or alter procedure administracion.ReporteTop5ProductosMenosVendidosMes(@mes int)
as
begin  
   if(@mes < 13 and @mes > 0)
   begin
    declare @query nvarchar(max) =
    'select*from(
		 select  Producto, sum(cantidad) as CantidadVendidas,
		 dense_rank()over(order by sum(cantidad) asc) as Rango
		 from administracion.ReporteVentas
		 where month(Fecha) =' + cast(@mes as varchar(2)) + '
		 group by Producto)g
	 where Rango < 6
	 FOR XML AUTO,ELEMENTS
	 '
  
    exec sp_executesql @query
	end
	else 
	begin
	   print 'Dato de mes erroneo'
	end
end
go

exec administracion.ReporteTop5ProductosMenosVendidosMes 2
go
/*
select Sucursal,sum(Cantidad*Precio) as total from administracion.ReporteVentas
where Sucursal = 'Ramos Mejia' and MONTH(Fecha) = 3
group by Sucursal
*/

/*
Mostrar total acumulado de ventas (o sea también mostrar el detalle) para una fecha 
y sucursal particulares 
*/

create procedure administracion.ReporteSucursalMesTotal(@sucursal varchar(30),@mes int)
as
begin
   if(@mes < 13 and @mes > 0)
   begin
       if exists(
	      select Sucursal from administracion.ReporteVentas
		  where Sucursal = @sucursal
	   )begin
		select Sucursal,sum(Cantidad*Precio) as total from administracion.ReporteVentas
		where Sucursal = @sucursal and MONTH(Fecha) = @mes
		group by Sucursal
		FOR XML AUTO,ELEMENTS
		end
		else
		begin
		   print 'No existe esa sucursal en el reporte de ventas'
		end
   end
   else
   begin
      print 'Error de mes'
   end
end
go

exec administracion.ReporteSucursalMesTotal 'Merlo', 1
go
--
/*
select*from(
	select IDEmpleado,sum(Cantidad*Precio)as monto,
	DENSE_RANK() over(partition by Sucursal order by sum(Cantidad*Precio) desc)as Posicion
	from administracion.ReporteVentas
	where month(fecha) = 2 and year(fecha) = 2019
	group by IDEmpleado,Sucursal
)as a
where Posicion = 1
*/


/*
Mensual: ingresando un mes y año determinado mostrar el vendedor de mayor monto 
facturado por sucursal.
*/
create or alter procedure administracion.InformeVendedorMayorMontoMesAnio(@anio int,@mes int)
as
begin
    if(@anio > 1980 and @anio < 2026 and @mes > 1 and @mes < 13)
	begin
	     declare @query nvarchar(max) = '
				select*from(
					select IDEmpleado,sum(Cantidad*Precio)as monto,
					DENSE_RANK() over(partition by Sucursal order by sum(Cantidad*Precio) desc)as Posicion
					from administracion.ReporteVentas
					where month(fecha) = '+  cast(@mes as nvarchar(2))+' and year(fecha) = '+  cast(@anio as nvarchar(4))+'
					group by IDEmpleado,Sucursal
				)as a
				where Posicion = 1
				FOR XML AUTO,ELEMENTS'

	      exec sp_executesql @query
	end
	else
	begin
	   print 'Error de mes o anio'
	end

end
go

exec administracion.InformeVendedorMayorMontoMesAnio 2019,3