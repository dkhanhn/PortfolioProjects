

--create a new table named 'tblPoints'

drop table if exists tblPoints
select DisplayName, ObjectName, CustomPropValue as Points 
into tblPoints 
from dbo.CustomProps where CustomPropType = 'Point'


--Extract ShapeName from ShapeFileName
if Object_ID('ShapeName', 'U') is not null
alter table Shapes
add ShapeName as right(shapefilename, len(shapefilename)-charindex('\',shapefilename, 3))


--create a table Results to join Points, Parameters, Shapes, Scripts

drop table if exists Results
select tblPoints.DisplayName, tblPoints.ObjectName, tblPoints.Points, CustomProps.CustomPropValue as Parameter, Shapes.ShapeFileName, Shapes.ShapeName as ShapeName, CustomShapeScript.ScriptText
into Results
from tblPoints
right join CustomProps
on tblPoints.ObjectName  = CustomProps.ObjectName and tblPoints.DisplayName = CustomProps.DisplayName
right join Shapes
on tblPoints.ObjectName  = Shapes.ObjectName and tblPoints.DisplayName = Shapes.DisplayName
left join CustomShapeScript
on tblPoints.ObjectName = CustomShapeScript.ObjectName
where CustomPropType = 'Parameter' and CustomPropValue <> 'pvformat' --select only OP and PV
order by DisplayName, ObjectName;

Select * from Results


