use ITI

drop database SD

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-- Ch-2

--define a local variable
declare @x int


--assign value
select @x =100
select @x


--Assign value from SQL Query
declare @y int
set @y=(select avg(st_age) from student)
select  @y


-- Selct return Null value
declare @f int=10
select @f=St_age from Student
where St_Id=-1
select @f                                        --keep the latest value 



--select return an array  of values 
declare @z int=5 
select @z = st_age from student 
where St_Address='cairo'                         -- [20,21,22,25,24,21]
select @z                                        -- last value (21)


-- declare a table variable 


--Retriving Data from a Table Variable
declare @t table (x_id int, y_name varchar(20))
    insert into @t
	select st_id, st_fname from student 
select * from @t

--select used to Assign or show Variable
declare @a int, @name varchar(20)
select @a= st_age, @name = st_fname from student 
select @a, @name                                 --without where return last var & assign it to var 


--Update and Retrive Data Using Local Variable  
declare @q varchar(20)
update student
     set st_fname = 'lool',@q= st_lname 
	 where st_id = 8
	 select @q


--Varialbe Dynamic queries

declare @ss int =3
select * from Student
where St_Id=@ss

--can use top statement with variable 
declare @ta int = 5
select top(@ta) * from Student


select * from student 
--could be ??
declare @col varchar(20) = '*', @tab varchar(20) = 'student'
select @col from @tab
--error 3lshan el @tab da variable mn no3 string, must be variable mn no3 table.

                     --Execute--
declare @col_1 varchar(20)='*', @tab_1 varchar(20)='Student',@cond varchar(50)='St_Age>20'
execute ('select '+@col_1+' from '+@tab_1 +' where '+ @cond ) 
-- the two statment are equal
select * from student where St_Age>20

-------------------------------------------------
--global variable

select @@SERVERNAME -- اسم الجهاز او السيرفر
select @@VERSION 

update student 
set st_age-=1
select @@ROWCOUNT
select @@ROWCOUNT --

select * from stud 
go
select @@ERROR

select @@IDENTITY --return identity for last row waas inserted

---------------------------------------------------------

                   --- Control of flow statement ---


--if
--begin
--end


declare @x int 
update student set st_age+=1
select @x = @@ROWCOUNT

if @x >0
	begin
		select 'multi rows affected'
		select 'Welcome to ITI'
	end
else 
	begin
		select 'no rows affected'
		select'No Welcome'
	end


-- if exists || if not exists

if exists (select * from sys.tables where name ='student')
	select 'table exists' as news
	--return True or False 
else	
 	create table student
	(id int,
	name nvarchar(20) )	

	--mmkn nhandelbeha errors zy keda 
	--lw fe relation wna ba7awel ams7 el parent


-- Error	
-- delete from Department where Dept_Id = 20

if not exists (select Dept_Id from student where dept_id = 20)
		begin
		delete from Department where dept_id =20
		end
else
        select 'related not deleted'


-- Try & Catch 

begin try 
	delete from Department where dept_id =20
end try
begin catch 
	select'error'
	select ERROR_LINE(), ERROR_NUMBER(), ERROR_MESSAGE()
end catch

---------------------------------------
-- Loops ---

-- while (only)

declare @x int=10
while @x <=20
begin
	set @x+=1
	if @x=14
		continue
	if @x=16
	break
	select @x
end    

-- result [11-12-13-15]
--continue btrg3ny ll loop tany 
--break bt5rgny bara el loop 


-- Case | iif | Choose ---


--The [CASE] command is used is to create different output based on conditions.

SELECT Ins_Name
CASE
    WHEN Salary > 3000 THEN 'High Salary'
    WHEN Salary < 3000 THEN 'Low Salary'
    ELSE 'The quantity is under 30'
END
FROM Instructor;

/* SELECT CustomerName, City, Country
FROM Customers
ORDER BY
(CASE
    WHEN City IS NULL THEN Country
    ELSE City
END);
*/



--IIF(condition, value_if_true, value_if_false)

select IIF(count(dept_id)<20, 'true =less', 'false =more')
from Department


--Choose

--https://www.sqlservertutorial.net/sql-server-system-functions/sql-server-choose-function/
select CHOOSE(1,'a','8','s','F')

select choose(Ins_Id,'one','two','three','four'),Ins_Name
from Instructor
where Ins_Id<5

------------------------------------------------

-- User defined functions:

-- 1) scalar function (returns scalar value)
-- 2) inline table function (returns table and no logic statemnet, Just SELECT STATEMENTS)
-- 3) multi statement table valued function (returns table, select + logic statements "if, looping, declaring").


	--SCALAR FUNCTION 

--Fn prototype --> 1)fn_name   2)Parameters   3)return_value      4)body

create function get_name(@id int)
returns varchar(20) 
begin
	declare @name varchar(20)
	select @name= St_Fname from Student where St_Id = @id
	return @name
end 
--Calling
select dbo.get_name(2)
alter schema HR transfer get_name
select HR.get_name(2)

--Note! we can Alter Function
---------------------------------------------
	
        -- INLINE FUNCTION --

create function GetInstructor (@did int)
returns table
as
	return
	(
		select Ins_Name, Salary *12 as Yearsalary 
		from instructor
		where dept_id = @did
	)

--Calling:
select * from GetInstructor(10)
--------------------------------------------------------
	  
	   -- MULTI STATEMENT FUNCTION --

create function GetStudent (@format varchar(20))
returns @t table 
	(
		id int,
		studentName varchar(20)
	)
as
	begin
	
		if @format = 'first'
		--insert based on select
			insert into @t 
			select St_Id,St_Fname from Student
		else if @format = 'last'
			insert into @t
			select St_Id,St_Lname from Student
		else if @format = 'full'
			insert into @t
			select St_Id,St_Fname+' '+St_Lname from Student
		return
	end
	
--Calling:
	select * from Getstudent('FULL')

-- Dynamic_fn
/*
create finction fetdate(@col varchar(10),@tvarchar(10))
returns ....
begin
     execute (' '+' '+' ')
end 

-- مدام مستخدم  execute in runtime  ممكن يكون فيها  insert/delete/update  و ده غير مسموح في function 


                   --  Function (UDF)	--                   -- Stored Procedure (SP) --
--------------------------------------------------------------------------------------------
 
Caliing   	|   Can be used in SELECT,                 |   Invoked separately by the 
method          WHERE, HAVING clauses, etc.	           |   EXECUTE or EXEC statement.
                                                       |
Data                                                   |  
Modification|  Not Allowed (DML is forbidden).	       |   Allowed (Can perform INSERT, UPDATE, DELETE).
                                                       |       
EXECUTE	    |  Forbidden for use inside the function.  |   Allowed for executing dynamic SQL or other procedures.
                                                       |   
Return                                                 |
Value       |  Must return a value (scalar or table).  | Optional, can return values via OUTPUT parameters.



                      -- Sys_Databaes --                           

Master -->  (The "Master Map" for the entire SQL Server instance.)
Key Purpose:
Stores all the system-level information, 
like server configuration settings, login accounts,
and where all the other databases (both user and system) are located.
[If this database is corrupt, SQL Server cannot start.]

Model --> 	(The "Blueprint" or "Template" for new databases.)
Key Purpose:
Any new user database you create is essentially a copy of the model database. 
It sets the default size, recovery model,
and any objects you want in every new database

msdb -->	(The "Agent's Logbook" for scheduled tasks.)
Key Purpose:
Used by the SQL Server Agent for scheduling jobs (automated tasks),
alerts, and operators. It also stores the history of backups and restores.


tempdb -->  (The "Scratchpad" or "Whiteboard" for temporary work.)
Key Purpose:
This is a workspace for temporary objects created by
users (like temporary tables, marked with a #) 
or for internal work the database engine needs to do 
(like sorting data or storing intermediate query results). 
It is recreated from scratch every time SQL Server restarts.
*/


-- Types of tables:

-- Physical Table 
create table Exam
(E_id int,
E_date date,
Num_of_Q int
)
insert into Exam
values(1,'5/29/2025',50)

drop table Exam

-- Varible Table (@memory only)
declare @exam table
(E_id int,
E_date date,
Num_of_Q int
)

insert into @exam
select * from dbo.Exam
select * from @exam

-- Local Table (session based table) اول ما اقفل  السيشن الجدول هيختفي 
create table #Exam
(E_id int,
E_date date,
Num_of_Q int
)
insert into #Exam
values(1,'12/29/2024',50)

select * from #Exam


--Global Table (shared table)
create table ##Exam
(E_id int,
E_date date,
Num_of_Q int
)
insert into ##Exam
values(1,'12/29/2023',50)
------------------------------------
                     -- Batch --
					 
/*set of querries hytnfzo sawa, w kol wa7d fehom msh hy2sr 3la l tany 3ady 
w lw fe wa7d fehom error 3ady hykml el ba2y*/
create table parent (id int primary key)
create table child (fid int foreign key references parent(id))

--as a batch, u can run these 3 rows at once 
insert into parent (id) values (1)
insert into parent (id) values (2)
insert into parent (id) values (3)

--as a batch, u can run these 3 rows at once 
-- each line of code is executed alone 
insert into child (fid) values (1)     -- 1 row affected 
insert into child (fid) values (4)     --foreign key constraint error 
insert into child (fid) values (3)     -- 1 row affected 

--variable is declared in batch 
declare @x int=4
go 
select @x  --error
---------------------------------------------------
--SCRIPT
--as a batch but commonly with DDL 
--ykon fe 2 querries msh hynf3 ysht3'lo m3 b3d w bfsl benhom b  go 
create table temp (id int)
go
drop table temp
go
create rule r10
go
sp_bindrule r10

----------------------------------------------
                              -- Tranasction --

-- set of querrirs works as one unit of work, ya yusht3'lo kollohom sawa ya wla wa7d fehom ysht3'l
begin transaction
	insert into child (fid) values (1)
	insert into child (fid) values (4)
	insert into child (fid) values (3)
commit 
-- keda k2nha batch 1 row aff, error, 1 row aff

begin transaction
	insert into child (fid) values (1)
	insert into child (fid) values (2)
	insert into child (fid) values (3)
rollback 
-- keda wla k2ny ktbt 7aga kolhom hytms7o sa7 aw 3'lt 7ata lw kolhom sa7
SELECT * FROM child

truncate table child

--u should take care to use commit or roll back 
--try catch klogic is the best fit for this situation 

begin try 
	begin transaction
		insert into child (fid) values (1)
		insert into child (fid) values (5)
		insert into child (fid) values (3)
	commit
end try

begin catch
	rollback
end catch

-- Transaction properties (ACID)


-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-- Ch.3

-- Creating and using Views
create view vstud
as 
select * from Student

-- caling 
select * from vstud

--Alias Syntax
create view vcairo(sid,sname,sadd)
as
select St_Id,St_Fname,St_Address from Student
where St_Address='cairo'

select sid,sname from vcairo

select St_id from vcairo --xx

--Assign view into DB schema  
 alter schema HR transfer vcairo
 /* Note   
 Student --> dbo schema 
 vcairo(view from student )  --> HR schema */
 select * from HR.vcairo
 alter schema dbo transfer HR.vcairo
--Drop view 
drop view vcairo 


--Combine Views Results Using Union 

create view valex(sid,sname,sadd)
as
select St_Id,St_Fname,St_Address from Student
where St_Address='alex'

select * from vcairo
union all
select *  from valex

--Creating View from Anthor View

create view vca 
as
select * from vcairo
union all
select *  from valex
  
select * from vca

--Complex Queries
create view vjoin(sid, sname, did,dname)
as
select st_id, st_fname, d. dept_id, dept_name
from Student S inner join Department d
on d.Dept_Id=s.Dept_Id

select * from vjoin 

-- Joining a View and a Table

create view vgrade 
as
select sname,dname,grade
from vjoin v join Stud_Course sc
on v.sid=sc.St_Id

select * from vgrade

-- Built in Stored Procedure
-- Display the View's Definition

sp_helptext'vgrade'

acreate view vgrade 
as
select sname,dname,grade
from vjoin v join Stud_Course sc
on v.sid=sc.St_Id

-- Encrypt view's Definition
alter view vjoin(sid, sname, did,dname)
with encryption
as
select st_id, st_fname, d. dept_id, dept_name
from Student S inner join Department d
on d.Dept_Id=s.Dept_Id

sp_helptext 'vjoin' --The text for object 'vjoin' is encrypted.

-- DML with View 

--insert Operation on a View
--Single Table 

insert into valex
values(40,'ahmed','alex')
-- the remain columns allow null (PK is not included)

/* [With Check Operation]
Prevents excuting an insert or update to a view 1v that Creates
a row that does not comply as with the view definition*/

Alter view valex (sid, sname, sadd)
as
  select st_id, st_fname, st_address
  from student
  where st_address='alex'
with check option

insert into valex
values(41, 'ahmed', 'mansoura') --xxx


--View (Multi tables)

create view vjoin(sid, sname, did,dname)
as
select st_id, st_fname, d. dept_id, dept_name
from Student S inner join Department d
on d.Dept_Id=s.Dept_Id

/* 
Delete isn't Allowed xxxxxx 
if the view involves multiple tables in its definition 
,direct Delete Operations aren't allowed on the View  

Insert & Update
Allowed if the operatoin affects on one table only */

-- Indexed View
create view vinst
with schemabinding 
as 
	select Ins_Id,Ins_Name,Salary 
	from dbo.Instructor
	where Dept_Id=10
	
select sum(salary)
from vinst

-- it's not allowed to change a datatype of view which has an [indexed view] 

--partitioning

--[Patition function] specify in it (col_data_type, range)
create partition function myPFn(int)
as range left
for values (10,20)
--exists in Storage->Partition Functions

--execute this first before trying to drop
drop partition scheme pschema 

--Partition scheme
create partition scheme pscheme
as partition myPFn
to (first,second,third)
--exists in Storage->Partition Schemes

create table t
(fullName nvarchar(30),
age int)
on pscheme(age)

insert into t values 
('Adham', 9),('Momo',18),('Dari',13)
,('Logy', 45),('Adham',9),('ali', 21)
,('Darin', 33),('Logy',45)

-- Display row's Partition within Partitioned Table 
   select * ,$partition.myPFn(age) from t
/*
  The Power of XML
- extensible markup language
- database text_based
- define new tags
- Application independent
- Platform independent
- Migration data
- ETL tools

# data query table ----> XML
for XML [raw auto auto path path explicit]

# XML ---->tables
open xml



@ XML
- The FOR XML clause is central to XML data retrieval in SQL Server 2005.
- This clause instructs the SQL Server query engine to return the data as an XML stream 
rather than as a rowset

The FOR XML clause has 4 modes to control XML Formate:

1)[RAW] Transforms each row in the result set into an XML element                    */

select * from Student
for xml raw

select * from Student
for xml raw('Student')

select * from Student
for xml raw('Student'),ELEMENTS,ROOT

select * from Student
for xml raw('Student'),ELEMENTS,ROOT('ITIdata')

--How to show null values in xml ? (xsinil)
select * from Student
for xml raw('Student'),ELEMENTS xsinil,ROOT('STUDENTS')

--RAW mode queries can include aggregated columns and GROUP BY clauses.
select * from Student
order by St_Address
for xml raw('Student'),ELEMENTS,ROOT('STUDENTS_DATA')

select St_Address,COUNT(st_id) from Student
group by St_Address
for xml raw('Student'),ELEMENTS,ROOT('STUDENTS')

--u can only present data as elemets or attributes
--using For XML Path is the solution for representing mixed "elemets and attributes"
--for each separate row

--JOIN problem
select t.Top_Id,Top_Name,Crs_Id,Crs_Name 
from Topic t,Course c
where t.Top_Id=c.Top_Id
order by t.top_id
for xml raw ('topic'),ELEMENTS

/* 
-should be nested topic includes courses
-using For XML Auto is the solution for this problem

2)AUTO
Returns query results in a simple,(nested XML tree). 
Each table in the FROM clause 
for which at least one column is listed in the SELECT clause is represented as an XML element.
The columns listed in the SELECT clause are mapped to the appropriate element attributes.   */

select Topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
from Topic ,Course 
where topic.Top_Id=Course.Top_Id
for xml auto,elements

select * 
from Student as st
for xml auto

select * 
from Student 
for xml auto,elements

select * 
from Student 
for xml auto,elements,root('ALLstudents')

--Benifets of For XML Auto
--1)Each row returned by the query is represented by an XML element with the same name
--2)the child elements are collated correctly with their parent
--3)Each column in the result set is represented by an attribute, unless the ELEMENTS option is specified
	select Topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
	from Topic ,Course 
	where topic.Top_Id=Course.Top_Id
	for xml auto,elements,root('Courses_Inside_Topics')

--4)PATH
--Provides a simpler way to mix elements and attributes, and to 
--introduce additional nesting for representing complex properties.
--Easier than Explicit mode

select st_id "@SID",
	   St_Fname "StudentName/FirstName",
	   St_Lname "StudentName/LastName",
	   St_Address "Address"	
from Student
for xml path('student')

select st_id "@StudentID",
	   St_Fname "StudentName/@FirstName",
	   St_Lname "StudentName/LastName",
	   St_Address "Address"	
from Student
for xml path('Student'),root('Students')
-------------------------------------------------------------------------------------
--XML Shredding
--The process of transforming XML data to a rowset is known as “shredding” the XML data.

--Processing XML data as a rowset involves the following five steps:
--1)create proc processtree
declare @docs xml =
				'<Students>
				 <Student StudentID="1">
					<StudentName>
						<First>AHMED</First>
						<Second>ALI</Second>
					</StudentName>
					<Address>CAIRO</Address>
				</Student>
				<Student StudentID="2">
					<StudentName>
						<First>OMAR</First>
						<Second>SAAD</Second>
					</StudentName>
					<Address>ALEX</Address>
				</Student>
				</Students>'

--2)declare document handle
declare @handler int

--3)create memory tree
Exec sp_xml_preparedocument @handler output, @docs

--4)process document 'read tree from memory'
--OPENXML Creates Result set from XML Document

SELECT * 
FROM OPENXML (@handler, '//Student')  --levels  XPATH Code
WITH (StudentID int '@StudentID',
	  Address varchar(10) 'Address', 
	  StudentFirst varchar(10) 'StudentName/First',
	  StudentSECOND varchar(10) 'StudentName/Second'
	  )
--5)remove memory tree
Exec sp_xml_removedocument @handler

-----
insert into student (st_id, st_address, st_fname, st_Iname)
SELECT * 
FROM OPENXML (@handler, '//Student') 
WITH (StudentID int '@SID',
Address varchar(10) 'Address',
StudentFirst varchar(10) 'StudentName/First',
StudentSECOND varchar(10) 'Student Name/Second' )


-----------------------------------------------------------------------------------

--XQuery
--Query language to indentify nodes in XML
--Query, Value, Exist, Modify and Nodes methods in XQuery
 CREATE TABLE customerData  
 (
        customerDocs xml NOT NULL,
 ) 

INSERT INTO customerData(customerDocs)
       VALUES(N'<?xml version="1.0"?>
       <customers>
              <customer FirstName="Bob" LastName="Hayes" Zipcode="91126" status="current">
                     <order ID="12221" Date="July 1, 2006">Laptop</order>
              </customer>
              <customer FirstName="Judy" LastName="Amelia" Zipcode="23235" status="current">
                     <order ID="12221" Date="April 6, 2006">Workstation</order>
              </customer>
              <customer FirstName="Howard" LastName="Golf" Zipcode="20009" status="past due">
                     <order ID="3331122" Date="December 8, 2005">Laptop</order>
              </customer>
              <customer FirstName="Mary" LastName="Smith" Zipcode="12345" status="current">
                     <order ID="555555" Date="February 22, 2007">Server</order>
              </customer>
       </customers>')


Select customerDocs.query('/customers/customer')
from customerData 

Select customerDocs.query('(/customers/customer)[1]')
from customerData 

Select customerDocs.query('/customers/customer/order')
from customerData 

Select customerDocs.query('(/customers/customer/order)[1]')
from customerData
----------------------------------------------------------------------------------
--  								*Typed*

CREATE XML SCHEMA COLLECTION BookIndex
AS
N'<xs:schema attributeFormDefault="unqualified"
    elementFormDefault="qualified"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="index">
        <xs:complexType>
            <xs:sequence>
                <xs:element maxOccurs="unbounded" name="keyword">
                    <xs:complexType>
                        <xs:simpleContent>
                            <xs:extension base="xs:string">
                                <xs:attribute name="page" type="xs:int" use="required" />
                            </xs:extension>
                        </xs:simpleContent>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>'

create table Books
(	ISBN char(13) primary key not null,
	Title nvarchar(200) not null,
	BookIndex1 xml(dbo.BookIndex)  )

Insert into dbo.Books
(ISBN,Title,BookIndex1)
VALUES
('1-59059-589-4','Vxxxxxxxxxxxxxx',
Cast('
<index>
    <keyword page="15">AppDomain</keyword>
    <keyword page="319">DataTable</keyword>
    <keyword page="328">DataSet</keyword>
    <keyword page="149">Encrypt</keyword>
    <keyword page="167">File IO</keyword>
    <keyword page="27">GAC</keyword>
    <keyword>Generics</keyword>
</index>' as XML) )
select * from dbo.Books

declare @xml xml(dbo.BookIndex)
set @xml ='<index>
    <keyword page="1">Chapter1</keyword>
    <keyword page="50">Chapter2</keyword>
    <keyword page="100">Chapter3</keyword>
    <keyword page="200">Chapter4</keyword>
    <keyword page="220">Chapter5</keyword>
    <keyword page="379">Chapter6</keyword>
    <keyword page="1919">Chapter7</keyword>
</index>' 
insert into dbo.Books
(ISBN,Title,BookIndex)
VALUES ('1-11111-111-1','SQL Server 2008',@xml)


-- FLWOR with LET operator
--Query language to indentify nodes in XML
--Statments
-------------
--1)for 
--Used to iterate through a group of nodes at the same level in an XML document.
--is like (select from) in sql

--2)where 
--Used to apply filtering criteria to the node iteration. XQuery includes
--functions such as count that can be used with the where statement.
--like where clause in sql

--3)return 
--Used to specify the XML returned from within an iteration.
--is like select in sql

--4)let is used for issignment

--5)order used for order by

-- FLWOR simple example

SELECT customerDocs.query('
       for $order in /customers/customer/order
        where $order/@ID >=555555
       return $order/text()')
FROM customerData


SELECT customerDocs.query('
       <CustomerOrders> {
       for $i in //customer
       let $name := concat($i/@FirstName, " ", $i/@LastName)
       order by $i/@LastName
       return
              <Customer Name="{$name}">
              {
              $i/order
              }
              </Customer>
       }
       </CustomerOrders>')
FROM customerData

drop table books

--HOW TO SHOW SCHEMA CONTENT
select XML_SCHEMA_NAMESPACE('dbo','BookIndex')

drop xml schema collection dbo.BookIndex

select name
from sys.XML_SCHEMA_COLLECTIONS
order by create_date

--CREATE PRIMARY XML INDEX idx_XML_Primary_Books_BookIndex
--ON dbo.Books(BookIndex)--need a clustered index in the table
--------------------------------------------------------------------
--Hierarchical Data (SQL Server)
--hierarchyID Datatype
 
--Example1  [Organization Hierarchy]
--TopManager (CEO)
--------Branch Managers
------------Department Managers
------------------Supervisors
-------------------------Employees

--Example2  [Geographical hierarchical data] 
--Planet   (Earth)
-------continent (Africa,Europe,Asia...)
----------------country (Egypt,Moraco,Southafrica.....)
------------------------------city (cairo ,alex , Mansoura .........
create table Geography_data  
(Nodes hierarchyid not null,  
GName nvarchar(30),  
GType nvarchar(9))

-- root level data
insert into Geography_data 
values(hierarchyid::GetRoot(),'Earth','Planet')

insert Geography_data  
values
-- root level data
('/', 'Earth', 'Planet')
-- first level data
,('/1/','Asia','Continent')
,('/2/','Africa','Continent')
,('/3/','Europe','Continent')

  -- second level data 
,('/1/1/','China','Country')
,('/1/2/','Japan','Country')
,('/1/3/','South Korea','Country')
,('/2/1/','South Africa','Country')
,('/2/2/','Egypt','Country')
,('/3/1/','France','Country')
 

-- third level data
,('/1/1/1/','Beijing','City')
,('/1/2/1/','Tokyo','City')
,('/1/3/1/','Seoul','City')
,('/2/1/1/','Pretoria','City')
,('/2/2/1/','Cairo','City')
,('/2/2/2/','Alex','City')
,('/2/2/3/','Mansoura','City')
,('/3/1/1/','Paris','City')
 
-- display without sort order returns rows in input order
select * from Geography_data

select 
 Nodes.ToString() AS [Node Text]
,Nodes.GetLevel() [Node Level]
,GName
,Gtype  
from Geography_data

--read tree from left to right
select 
 Nodes.ToString() AS [NodeText]
,Nodes.GetLevel() [NodeLevel]
,GName
,Gtype  
from Geography_data
order by [NodeText]

--display all cities
select Gname,Gtype
from (
	select 
	Nodes.ToString() AS [NodeText]
	,Nodes.GetLevel() [NodeLevel]
	,GName
	,Gtype  
	from Geography_data ) newtable
where Nodelevel=3
 
 --delete root
 delete top(1) from Geography_data

 --add root with method
----------------------------------------------------------------------------------
--CTE --Common type expression
--CTEs make code more readable.
--readability makes queries easier to debug.
--CTEs can reference the results multiple times throughout the query. 
--By storing the results of the subquery, you can reuse them throughout a larger query.
--CTEs can help you perform multi-level aggregations. 
--make a recursive query

--self relationship
select S.st_fname as studentname , L.st_fname as Leadername
from student S , student L
where L.st_id = S.st_super

with StudMemory
as
	(select * from student)
select S.st_fname as studentname , L.st_fname as Leadername
from StudMemory S , StudMemory L
where L.st_id = S.st_super

select *
from Instructor
where salary > (Select avg(Salary) from Instructor)

with InstMemory
as
	(select * from Instructor)
select *
from InstMemory
where salary > (Select avg(Salary) from InstMemory)

--agregate over aggregate   
select st_Fname,sum(grade) 
from Stud_Course sc inner join Student S
On s.St_Id = SC.St_Id
group by st_fname 


with CTE1(SName,total)
as
	(select st_Fname,sum(grade) 
	from Stud_Course sc inner join Student S
	On s.St_Id = SC.St_Id
	group by st_fname)
select Max(total) from CTE1   --max sum(grade)

--recursive
Declare @RowNo int =1;
with ROWCTE as  
   (  SELECT @RowNo as ROWNO    
	  UNION ALL  
      SELECT ROWNO+1  
	  FROM   ROWCTE  
	  WHERE  RowNo < 10  )

execute sp_changedbowner sa
alter database iti set trustworthy on
go
sp_configure 'show advenced options',1;
go
reconfigure
go
sp_configure 'clr_enable',1
go
reconfigure
go
sp_configure 'show_advenced_options',0;
go
reconfigure

--offset and fetch is called server side pageing 
--Fetch and Offset or Page Data 
--like data paging in data grid
--in SQL 2008
SELECT *FROM (
SELECT *,ROW_NUMBER() OVER(ORDER BY st_age) AS age
FROM student) AS TempTable
WHERE age > 5 and age <11

SELECT *
FROM student
ORDER BY st_age
OFFSET 5 ROWS
FETCH NEXT 6 ROWS ONLY;

SELECT *
FROM student
ORDER BY st_age
OFFSET 5 ROWS
/*
   ----- Sequence -----

  Create Sequence Object:              */

Create SEQUENCE MySequence 
START WITH 1 
INCREMENT BY 1
MinValue 1
MaxValue 5
CYCLE; --default

alter SEQUENCE MySequence 
ReSTART WITH 1 --changed from start to restart 
INCREMENT BY 1
CYCLE; --default  

drop SEQUENCE MySequence 

-- Create Temp Table
create TABLE person1 
( ID int,
 FullName nvarchar(100) NOT NULL );

create TABLE person2 
( ID int,
 FullName nvarchar(100) NOT NULL );

-- Insert Some Data 

INSERT into person1
VALUES (NEXT VALUE FOR MySequence, 'nada')

INSERT into person2
VALUES (NEXT VALUE FOR MySequence, 'nada')

select * from person1
select * from person2

select name,minimum_value,maximum_value,current_value,is_cycling
from sys.sequences
where name='Mysequence'

update person2
set id=NEXT VALUE FOR MySequence
where id=2

--advantages of sequence than identity
--1)not need to use insert statment to be increased because it is used with update
--2)cycle
--3)shared between tables
--4)there is no (insent_identity on and off) not needed

--note if u have sequence object (s1) and u want it to be default value of a column (id)
ALTER TABLE tb1
ADD DEFAULT NEXT VALUE for s1 FOR id

----------------------------------------------------------------------------------
--Table Valued Parameter  (new feature 2008)
--is used with function and Stored procedure to pass a table as a single parameter to Fun or SP
--i can use it to pass data from SP to anther
--it is a user defined types
--can be indexed
--it is readonly so it can't be treated output parameter in SP
--variables that is created from Type TVP is saved in Tempdb
--no alter statment to TVP u shoud drop it and recreat

CREATE TYPE TVP AS TABLE
(id int,
name varchar(50) )
--i will find it in types folder

--i can declare a variable of type TVP
DECLARE @x AS TVP

INSERT INTO @x 
VALUES(1,'A'),(1,'B'),(1,'C')

SELECT * FROM @x 


CREATE FUNCTION f1 (@tvp1 AS TVP readonly)
RETURNs int
AS
begin
DECLARE @c INT
SELECT @c=COUNT(*) FROM @tvp1
RETURN @c
end

DECLARE @x AS TVP

INSERT INTO @x 
select st_id,st_fname from student

SELECT dbo.f1(@x)

CREATE PROC p1 (@tvp1 AS TVP  readonly)
AS
SELECT * FROM @tvp1 

DECLARE @x AS TVP
INSERT INTO @x VALUES(1,'A'),(1,'B'),(1,'C')
EXEC p1 @x
EXEC p1 --run without errors
-----------------------------------------------------------------------------------
/* 

- High Availability(DB)

[failover clustering]  real servers | network | automatic failover
[peer to peer replication] replicate data (diff db engine)
[always on]  replicate more than one db
[DB mirroring]  instances 1-1 replication automatic failover
[ship transaction log]  instances 1-M replicate manual failover                       
*/

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

-- Ch-4                                                                                              

The Three Common Types of "Stored Procedures"  in SQL Server are:

1. Built-in System Stored Procedures (sp_...)

2. User-Defined Stored Procedures (UDSP)

3. Triggers (Specialized, event-driven procedures)                                                             

1) Built-in: anything that starts with (sp_):
sp_bindrule, sp_unbindrule, sp_helpconstraint, sp_rename, sp_addtype, sp_helptext, sp_who

2)User Defined (SPs created by the user)                                                                          */ 

--CREATE Stored Procedure:
	CREATE PROC getst
	AS  SELECT *
		FROM student 

--Calling:

	getst
	-- or 
	execute getst  --> [execute] optional but sometimes be obligatory  

--SP with parameter:

	create proc getstbyaddress @add varchar(20)
	as	
	  ( select st_id, St_Fname, St_Address
		from Student
		where St_Address = @add )

getstbyaddress 'alex'

--Alter Schema:

	alter schema hr transfer getstbyadd
	hr getstbyadd 'cairo'

	alter schema dbo transfer hr.getstbyadd

-- Drop Schema :

	drop proc getstbyadd

                 ------------- DML with SP -------------

--Delete data using SP :
	create proc deltopic @x int
	as 
	   delete from topic where top_id=@x

deltopic 1   --> FK Constrain error 

-- Check for Related Records :

	alter proc deltopic @x int
	as 
	   if not exists (select Crs_id from course where Top_id=@x)
			delete from topic where top_id=@x
	   else
			select 'Error_001'
-- exclusive for SP You can write full code within SP, unlike View & Function.   

	deltopic 1

--Insert data using SP :

	create proc instst @id int, @name varchar(20)
	as
		insert into Student(St_Id,St_Fname)
		values (@id,@name) --dynamic insert

	instst 10,'ali' --> Error due to PK constraint

/*
  The error here contains [metadata], and this is not correct security-wise
  Here,the biggest advantage of the [SP] is that I can write code to handle the error 
*/

	alter proc instst @id int, @name varchar(20)
	as
		begin try
		insert into Student(St_Id,St_Fname)
		values (@id,@name) --dynamic insert
		end try
		begin catch
			select 'error'
		end catch
----------------------------------------
--Create SP with parameters:

	create proc sumdata @x int, @y int 
		as 
		select @x+@y

--Passing parameter by position: 
	sumdata 3,9			

--Passing parameter by Name:
	sumdata @y=9, @x=3  

--Using default value for SP:
	alter proc sumdata @x int = 100, @y int =200
		as
		select @x+@y

	sumdata 3,9    --12
	sumdata 3	   --203
	sumdata		   --300
	sumdata @y=3   --103


-- Receive (capture) the result of the SP into a table and work with it :

	create proc getstbyage @age1 int, @age2 int
	as
		select St_Id, St_Fname
		from Student
		where St_Age between @age1 and @age2

	getstbyage 23,28   --> table result

--insert based on execute :

--1
	create table tab4 (id int primary key, firstname varchar(20))
--2
	insert into  tab4 (id, firstname)
	execute getstbyage 23,28
--Calling
	select* from tab4

-- If I want to return it in a variable of type TABLE:
	declare @t table (x int , y varchar(20))
	insert into @t
	execute getstbyage 23,28

	select COUNT(*) from @t
---------------------------------
-- What if the result returned from the SP execution is only one value?
-- It can be written like a scalar function:

	create proc getdata @id int 
	as
		declare @age int 
			select @age =St_Age
			from Student
			where St_Id = @id
		return @age	

-- Create a variable to capture the SP execution return (status) value
	declare @x int
	execute @x=getdata 3 
	select @x

-- The SP RETURN value must be one value and must be an INT only, unlike the Function
-- We use it to return a value that expresses a specific behavior (status) of the SP

/* 
   The difference between the RETURN value of a Function :
   (it returns a number(value) from the function)
   The RETURN value of an SP (it expresses the behavior/status of the SP)
*/

-- Output Parameters in SP:

-- If I want to return something from the SP, I will use an OUTPUT parameter, like Call by Reference
	alter proc getdata @id int, @age int output, @name varchar(20) output
	as
		select @age =St_Age, @name =St_Fname
		from Student
		where St_Id = @id

	declare @x int,@y varchar(20)
	execute getdata 3, @x output, @y output
	select @x,@y
/* 
And I can use these @x, @y (variables) as input parameters for another SP that
for example, performs an INSERT  
*/
	execute instst @x, @y

---------------------------------------
                                                                                           /*
SP Parameters: There are four types of Stored Procedure parameters:
(1) Return (Status Code), (2) Input, (3) Output, (4) Input-Output.

The [Input-Output (I/O)] parameter concept:
This allows us to send an initial value with the parameter (like an INPUT) 
that can be used inside the SP *before* the SP's logic changes the value (like an OUTPUT).
In the example below:                                                                     */

	CREATE PROC getdata2 @age INT OUTPUT, @name VARCHAR(20) OUTPUT
	  AS
		SELECT @age = St_Age, @name = St_Fname
		FROM Student
		WHERE St_Id = @age -- Uses the initial value of @age passed into the SP

	DECLARE @x INT = 3, @y VARCHAR(20)
	EXECUTE getdata2 @x OUTPUT, @y OUTPUT
	SELECT @x, @y                                                                              /*

since the `WHERE` clause executes before the `SELECT` assignment,
the initial value of `@age` (sent from the caller) is used in the `WHERE` clause. 
The `SELECT` statement then overrides and returns the final value (OUTPUT).
This demonstrates the I/O nature: initial value as INPUT, final value as OUTPUT.
                                                                                          
======================================================================                       
 Dynamic Query in SP:

- We can create dynamic queries within an SP, but this poses a **severe security risk** 
 (SQL Injection) because we are passing object names (columns and tables) as variables.
- The object names are visible, and malicious users could exploit this.                                */

	CREATE  PROC getalldata @col VARCHAR(20), @tab VARCHAR(20)
	AS
		EXECUTE ('SELECT ' + @col + ' FROM ' + @tab) 
--> SELECT @Col FROM @tab xxxxxx so, we should use Exec

-- Calling:
	EXEC getalldata '*', 'Student'
/*
================================================
Advantages of Stored Procedures (SPs) :

	1) Logic Encapsulation:Contains all Data Manipulation Language (DML) and other logic.

	2) Security(Access Control):Improves security as users execute the SP but do not need direct permission on (or even know the names of) the underlying tables/objects.
	** Neither the object metadata nor the operation logic is exposed to the user.

	3) Performance(Network Wise):Better performance because only the SP name and parameters are sent over the network (fewer characters).

	4) Performance (Server Wise):Better performance because the execution plan is cached and reused, 
	avoiding repetitive initial processing steps like **parsing**, **optimizing**, and building the **query tree**.

	5) Flexibility(Parameters):Allows flexible data exchange using both input and **output parameters**.
	6) Error Handling:Provides the ability to implement database-level error handling using **TRY...CATCH** blocks.
	7) Business Logic Layer:Enables handling complex business rules at the database level, decoupled from the application code.
================================================================================================
Advantage of Functions:

	Functions can be easily used **inline** as part of a main query (SELECT, WHERE, etc.).
================================================================================================     

                                  ------= TRIGGERS =------

- A trigger is a special type of Stored Procedure.
- It cannot be called explicitly (like an SP) nor can it accept parameters.
- It is an implicit code block that listens for and executes when specific actions occur on the server.
- Triggers can be defined at the (table level) or the (database/server level).

- Triggers at the table level execute with (INSERT, UPDATE, and DELETE) operations.
- TRUNCATE does'nt fire a trigger because it is a DDL command and sometimes bypasses the transaction log.

There are 2 main types of table triggers (in SQL Server): --> **AFTER/FOR** and **INSTEAD OF**.                       */

	INSERT INTO Student (St_Id, St_Fname)
	VALUES (78,'Ali')

	alter TRIGGER t1
	ON Student
	AFTER INSERT -- Executes after the INSERT action is complete
	AS
		SELECT 'Insert Is Done !' as '1001101'

-- Note!   EXEC t1 --> Cannot call triggers explicitly

	CREATE TRIGGER t2
	ON Student
	FOR UPDATE      --> 'FOR' is an alias for 'AFTER'
	AS	
		SELECT GETDATE(),'Update Is Done'

	UPDATE Student
	SET St_Age += 1	
	/*

(INSTEAD OF) Trigger (Permission Simulation :
We can use an INSTEAD OF trigger to prevent a specific action from happening on a table.                                 */

	CREATE TRIGGER t3
	ON Student	
	INSTEAD OF DELETE -- Executes INSTEAD OF the DELETE command
	AS	
		SELECT 'Deletion not allowed for user: ' + SUSER_NAME()

	DELETE FROM Student WHERE St_Id = 1  --> Deletion not allowed for user: 3ADEL\Admin	

--Creating a Read-Only Table using (INSTEAD OF):

	CREATE TRIGGER t4	
	ON Department
	INSTEAD OF DELETE, UPDATE, INSERT
	AS
		SELECT 'Table is Read Only'

	- DELETE FROM Department WHERE Dept_Id = 10           
	- UPDATE Department SET Dept_Name = 'Ali'
	- INSERT INTO Department (Dept_Id, Dept_Name)VALUES (1000,'lol')

-------------------------------
-- Managing Triggers:

-- 1.DROP: ==> To permanently delete the trigger.
	DROP TRIGGER t1

-- 2.DISABLE/ENABLE: ==> To temporarily stop the trigger's function while keeping its definition.

	ALTER TABLE Student DISABLE TRIGGER t2
	ALTER TABLE Student ENABLE TRIGGER t2
/*
-------------------------------
 TRIGGER Notes:
1. If the query syntax is incorrect , execution will fail, and the trigger will not be reached.
2. If the query is correct but affects zero rows (e.g.,UPDATE ... WHERE 1=0), 
   the TRIGGER will still be fired in most SQL engines like (SQL Server).
3. The trigger automatically inherits the **schema** of the table it is created on.                               */

	ALTER TRIGGER itistud.t5
	ON itistud.Course	
	INSTEAD OF DELETE	
	AS	
		SELECT 'No Deletion Allowed'

/*
------------------------------------------------                                                                                   

 The UPDATE() Function within Triggers :

-'UPDATE()' is a special function (not a keyword) used inside a trigger.
- We can use it to check if a specific column was modified.
- We can use this function to run the trigger only when a specific column is updated.                                                  */

	CREATE TRIGGER t6	
	ON Student
	AFTER UPDATE
	AS	
		IF UPDATE(St_Age) -- Check if the St_Age column was part of the UPDATE statement
			SELECT 'Age column was updated'
		ELSE
			SELECT GETDATE() as 'Date of Execution'

	UPDATE Student	
	SET St_Age += 1	--> Triggered (St_Age column is updated) & 'Age column was updated' AS OUTPUT 

	UPDATE Student	
	SET St_Fname = 'Muhammad'
	WHERE St_Id = 10 --> Not triggered (St_Age is not in the SET clause)
/*
---------------------------------------------
 Key Advantage of Triggers::

- The main benefit of triggers is **auditing** and **tracing** for database activity and recording who tried to do anything in a query.
- Each time a trigger is fired,two virtual tables are created and placed in tempdb (and are deleted when the trigger completes):
	1.(inserted) table: Holds the new data (rows being inserted or the *new* values in an UPDATE).
	2.(deleted) table: Holds the old data (rows being deleted or the *old* values in an UPDATE).
 Both tables share the same metadata (schema) as the table the trigger is on.
*/
	CREATE TRIGGER stud_tri	
	ON Student
	AFTER UPDATE
	AS	
		-- The SELECTs below show the content of the virtual tables:
		SELECT * FROM inserted -- New data after the update
		SELECT * FROM deleted  -- Old data before the update
---
	UPDATE Student	
		SET St_Fname = 'Mahmoud'
		WHERE St_Id = 6

-- Alternative Way to Get Deleted Value from Update 

	DECLARE @x VARCHAR(20)
	UPDATE Student	
	SET St_Fname = 'Lolo', @x = St_Fname -- Assigns the *original* St_Fname before the update
	WHERE St_Id = 4
	SELECT @x -- @x now holds the *old* value of St_Fname for St_Id 4
------------------------------------

-- Scenario: Preventing Deletion of Courses on a Specific Day (e.g., Friday)

-- **Method 1: AFTER DELETE with ROLLBACK (Less Efficient/Common)**
-- This method allows the delete to happen, then uses an AFTER trigger to check the condition, and if violated, rolls back the transaction (re-inserting data).
	
	CREATE TRIGGER test1
	ON instructor	
	AFTER DELETE	
	AS
		IF FORMAT(GETDATE(),'dddd') = 'Friday' 
		BEGIN
			SELECT 'Deletion prevented on Friday. Rolling back.'
			-- ROLLBACK -- (If ROLLBACK is used, the INSERT is not needed)
			INSERT INTO instructor	
			SELECT * FROM deleted -- Re-inserts the deleted rows
		END

delete from Instructor where Ins_Id=15
	
-- Method 2: INSTEAD OF DELETE (Recommended for Prevention)
-- This method intercepts(تعترض) the delete command and only executes the actual deletion if the condition is *not* met.

	CREATE TRIGGER course_delete
	ON Course
	INSTEAD OF DELETE
	AS
		IF FORMAT(GETDATE(),'ddd') != 'Fri' --> Check if today is NOT Friday
		BEGIN
			-- If not Friday, proceed with the deletion using the rows from the deleted table
			DELETE FROM Course WHERE Crs_Id IN (SELECT Crs_Id FROM deleted)
		END	
		ELSE	
			SELECT 'Cannot delete course '+(select Crs_Name from deleted )+' on Fridays'

delete from Course where Crs_Id=900
/*
----------------------------
Logging History using (INSTEAD OF) :
 
The 'inserted' and 'deleted' tables are automatically dropped when the trigger query completes,To save 
their content for (history/auditing) , we must copy the data into a permanent table.

Scenario: Prevent updating the primary key (Top_Id) on the Topic table and log the attempt in a history table.                        */

CREATE TABLE history
	(
	_user VARCHAR(20),
	_date DATE,
	_oldid INT,
	_newid INT	)

CREATE TRIGGER topic_update
ON Topic
INSTEAD OF UPDATE
	AS
	IF UPDATE(Top_Id) -- Check if the Top_Id column was part of the update attempt

	BEGIN
	-- Use variables to retrieve the single value from each virtual table
		DECLARE @old INT, @new INT
		SELECT @old = Top_Id FROM deleted -- Old ID value
		SELECT @new = Top_Id FROM inserted -- New ID value (attempted value)
	    
		-- Log the unauthorized attempt to the permanent history table
		INSERT INTO history (_user, _date, _oldid, _newid)
		VALUES (SUSER_NAME(), GETDATE(), @old, @new)
	    
		-- IMPORTANT: Since this is an INSTEAD OF, no UPDATE will happen on the Topic table
	END

UPDATE  TOPIC SET TOP_ID=55 WHERE TOP_ID =5

SELECT * FROM history 
-- will only work if the history table has data.
------------------------------------------------------

                -------------  Database-Level Triggers  -------------
--DDL triggers

create trigger t2
on  database
for alter_table   -- when i do alter on any table 
as
select 'table structure is modified'
-- test:
alter table student alter column st_fname varchar(20)
-- drop trigger :
drop trigger t2 on database


create trigger t3
on database
for ddl_database_level_events
as
	begin
		declare @x xml=eventdata()
		select @x
	end

alter table student alter column st_fname varchar(20)
/*                                           
                                           -- OUTPUT --

	<EVENT_INSTANCE>
	  <EventType>ALTER_TABLE</EventType>
	  <PostTime>2025-10-31T15:47:26.810</PostTime>
	  <SPID>52</SPID>
	  <ServerName>3adel\SQLEXPRESS</ServerName>
	  <LoginName>3ADEL\Admin</LoginName>
	  <UserName>dbo</UserName>
	  <DatabaseName>ITI</DatabaseName>
	  <SchemaName>dbo</SchemaName>
	  <ObjectName>Student</ObjectName>
	  <ObjectType>TABLE</ObjectType>
	  <AlterTableActionList>
		<Alter>
		  <Columns>
			<Name>st_fname</Name>
		  </Columns>
		</Alter>
	  </AlterTableActionList>
	  <TSQLCommand>
		<SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
		<CommandText>alter table student alter column st_fname varchar(20)</CommandText>
	  </TSQLCommand>
	</EVENT_INSTANCE>

 If U want to save some info in a table :                                                            */

-- 1)Create Table to save these :
create table audit
(
event_name varchar(50),
query_text varchar(50),
username varchar(50),
edate datetime )

-- 2)Create Trigger to insert date from XML file into (audit) table 
alter trigger t3
on database
for ddl_database_level_events --> for any DDL queries that were executed at the database (ITI) level 
as
declare @x xml=eventdata()
insert into audit
values(
	@x.value('(/EVENT_INSTANCE/EventType) [1]', 'nvarchar(40)'),
	@x.value('(/EVENT_INSTANCE/TSQLCommand) [1]', 'nvarchar(40)'),
	@x.value('(/EVENT_INSTANCE/LoginName) [1]', 'nvarchar(40)'),
	getdate()  )

-- test:
alter table student alter column st_fname varchar(20)
Create table test(id int)
drop table test 
select * from audit

                -------------  Server-Level Triggers  -------------

create trigger server_trigger
on all server 
for ddl_login_events
as 
select EVENTDATA()

-- Test :
create login ITInew with password= '#123456789@'

/*                                           
                                           -- OUTPUT --
	<EVENT_INSTANCE>
	  <EventType>CREATE_LOGIN</EventType>
	  <PostTime>2025-10-31T16:33:05.917</PostTime>
	  <SPID>52</SPID>
	  <ServerName>3adel\SQLEXPRESS</ServerName>
	  <LoginName>3ADEL\Admin</LoginName>
	  <ObjectName>ITInew</ObjectName>
	  <ObjectType>LOGIN</ObjectType>
	  <DefaultLanguage>us_english</DefaultLanguage>
	  <DefaultDatabase>master</DefaultDatabase>
	  <LoginType>SQL Login</LoginType>
	  <SID>eZVT/ahGB0SZRli/npNMIQ==</SID>
	  <TSQLCommand>
		<SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
		<CommandText>create login ITInew with password= '******'
	</CommandText>
	  </TSQLCommand>
	</EVENT_INSTANCE>
*/
/*
---------------------------------------------
 Runtime Trigger: ==> The OUTPUT Clause

- The **OUTPUT** clause is a DML feature, acting as a "runtime trigger" or exclusive mechanism to return data only for the executing DML statement.
- It works similarly to a trigger, as it can access the **inserted** and **deleted** virtual tables.
- The OUTPUT keyword is temporary and local to the current DML command.                                                           */

-- Usage 1: Returning data to the client
ALTER TABLE Student DISABLE TRIGGER  t3, t6, t1 -- Disabling existing triggers for clean test

DELETE FROM Student
OUTPUT GETDATE(), deleted.St_Id --> Returns the execution date and the ID of the deleted row to the user
WHERE St_Id = 77

-- Usage 2: Inserting data directly into (Auditing) table 
-- This is a very efficient way to perform auditing without a full trigger.

DELETE FROM Student
OUTPUT GETDATE(), deleted.St_Id INTO history (_date, _oldid) 
-- Insert the output directly into the history table columns
WHERE St_Id = 79

SELECT * FROM history 


----------------------------------------------------------------------
-- SECTION 1: Basic Cursor for Read-Only Operation
----------------------------------------------------------------------
                                                                                                                                 /*
  Cursor Introduction:
  A cursor is not a database object; it is a mechanism in memory (a pointer).
  Therefore, we DECLARE a cursor, we do not CREATE it.

	    1. Declare the Cursor: Define the cursor and specify the SELECT statement
     	   that will fill the result set to be looped over.
                                                                                                                                  */
DECLARE c1 CURSOR
FOR
	SELECT St_Id, St_Fname
	FROM Student
	WHERE St_Address ='cairo'
FOR READ ONLY; -- or FOR UPDATE
                                                                                                                                   /*
* If 'FOR READ ONLY': We only display the rows and cannot modify the underlying data.
* If 'FOR UPDATE': We can make changes (updates/deletes) to the data rows.
* The default option is usually FOR READ ONLY or implementation-defined.              

--	   2. Declare Variables: Define local variables to temporarily hold the column values
		  of the fetched row. Typically, the number of variables matches the number of columns selected.                            */

DECLARE @id INT, @name VARCHAR(20);

--	   3. Open the Cursor: Allocates the necessary memory and positions the pointer
--	      to the row *before* the first row of the result set.
OPEN c1;
                                                                                                                                 /*
	   4. Fetch the First Row: Retrieve the data from the first row of the result set
	      and assign the values into the declared local variables (@id, @name).
                                                                                      
	   This operation is necessary to start the loop. It initializes the variables
	   and sets the value of the global status variable @@FETCH_STATUS.
                                                                                                                                  */
FETCH c1 INTO @id, @name;                 --> counter=0
                                                                                                                                  /*
	   5. Loop Control: Check if the FETCH operation was successful.
	 
	    @@FETCH_STATUS is a global variable that indicates the status of the last FETCH attempt:
	    = 0  ----> Success. A row was retrieved successfully.
	    = 1  ----> Failure. The row could not be retrieved (e.g., locked or an error occurred).
	    = 2  ----> No more rows available in the cursor's result set.
                                                                                                                                  */
WHILE @@FETCH_STATUS = 0
BEGIN
--      6. Display the current row's values
	SELECT @id, @name;
                                                                                                                                  /*
	    7. Counter Simulation (Moving to the Next Row): Fetch the next row inside the loop. 
	       This moves the cursor pointer to the next row. [counter ++] 
		   As long as the status remains 0,the loop continues. 
		   A status of 1 or 2 will terminate the loop.                                                                              */
	FETCH NEXT FROM c1 INTO @id, @name;    

END
                                                                                                                                   /*
		8. Close the Cursor: Releases the current result set and saves the pointer's current position.
		   This allows the cursor to be reopened later at the current position if needed.
		                                                                                                                           */
CLOSE c1;
                                                                                                                                   /*
		9. Deallocate the Cursor: Releases the memory resources occupied by the cursor.
		   If we want to use the same cursor name again, the process must restart from step 1 (DECLARE).
		   NOTE: All these steps must be run together as they function as a single logical block (variable, not DB object).
		   The cursor's main purpose is to process the result set as 'scattered data' (one row at a time).
	                                                                                                                           */
Deallocate c1;


----------------------------------------------------------------------
-- SECTION 2: Cursor Example for Concatenating Strings
----------------------------------------------------------------------

-- Goal: Display the result set as a single cell, concatenating all names
--       separated by a comma. We will loop through the names and append them to one variable.
SELECT St_Fname
FROM Student
WHERE St_Fname IS NOT NULL;

DECLARE c1 CURSOR
FOR
	SELECT St_Fname
	FROM Student
	WHERE St_Fname IS NOT NULL
FOR READ ONLY;

DECLARE @name VARCHAR(20), @allnames VARCHAR (300) = '';

OPEN c1;
FETCH NEXT FROM c1 INTO @name;

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Concatenate the current name to the accumulator variable
	SET @allnames = CONCAT(@allnames, ',', @name);
	FETCH NEXT FROM c1 INTO @name;
END

-- Display the final concatenated string
SELECT @allnames AS AllStudentNames;

--> The Result: ,Ahmed,Amr,Mona,Ahmed,Muhammad,Mahmoud,Ali,lool,Saly,Muhammad,Marwa,Said,hassan,Reem,ahmed,Ali

CLOSE c1;
DEALLOCATE c1;

----------------------------------------------------------------------
-- SECTION 3: Cursor for UPDATE Operation (WITH UPDATE)
----------------------------------------------------------------------

-- Goal: Update the salary of instructors based on a condition:
--       If salary >= 3000, increase by 20%. If salary < 3000, increase by 10%.

DECLARE c1 CURSOR
FOR
	SELECT Salary
	FROM Instructor
FOR UPDATE; -- Must use FOR UPDATE to allow modifications

DECLARE @sal INT;

OPEN c1;
FETCH NEXT FROM c1 INTO @sal;

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @sal >= 3000
		-- Update the specific row currently pointed to by the cursor
		UPDATE Instructor
			SET Salary = @sal * 1.2
		WHERE CURRENT OF c1;
	ELSE
		-- Update the specific row currently pointed to by the cursor
		UPDATE Instructor
			SET Salary = @sal * 1.1
		WHERE CURRENT OF c1;

	FETCH NEXT FROM c1 INTO @sal;
END

CLOSE c1;
DEALLOCATE c1;

----------------------------------------------------------------------
-- SECTION 4: Cursor for Counting Based on Condition
----------------------------------------------------------------------

-- Goal: Count the occurrences of the name 'amr' and check if 'ahmed' exists
--       (though the current script only displays the count).

DECLARE c1 CURSOR
FOR
	SELECT St_Fname
	FROM Student
FOR READ ONLY;

DECLARE @name VARCHAR(20), @counter INT = 0, @flag INT = 0;

OPEN c1;
FETCH NEXT FROM c1 INTO @name;

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @name = 'ahmed'
		SET @flag = 1; -- Sets flag if 'ahmed' is found
	
	IF @name = 'amr'
		SET @counter += 1; -- Increments counter if 'amr' is found
		
	FETCH NEXT FROM c1 INTO @name;
END

SELECT @counter AS CountOfAmr; -- Display the final count of 'amr'

CLOSE c1;
DEALLOCATE c1;
------------------------------------------------------------------------------------------------------------------------------------
--SQLCLR
-----------Function
-----------New data type    [class struct]

sp_configure 'clr_enable',1
go
reconfigure


select dbo.sum2Int(3,5)

select dbo.sum2Int(st_id,st_age)
from student

create table shapes
(
_id int,
_desc varchar(20),
_coords Circle
)

--10,20,30
select _desc
from shapes
where _Coords.x>=10

select _desc
from shapes

--SQL CLR stands for
--structured query Language + Common Langauage runtim [VS runtime engine]
--benefits of SQLCLR
--Scale Cabability of query language
--choose any .net language [C# f# Vb.net.....]
--.net language has alot of features
--[classes, DataS tructure, Regualar expressions, dealing with external files]
--better performance [VS runtime engine is faster]
--debugging features
--create new objects like [new data types & new aggregate functions]
--which type of objects can CLR create
--User defined Function
--Stored Procedures
--Trigger
--user defined type CLR Only
--Aggregate function CLR Only
--data type Problem
--u will find builtin assembly [deployed before]
-----named [Microsoft.SqlServer. Types] -->programmability ---> assemblies
------varchar(10) nchar (10) --- ---SQLstring ----> String
--tinyint smallint *SQLint16 ---> int16
---binary varbinary SQLbinary -> byte
--SQL server will responsible for:
--assembly loading
--Memory management
--security
--execution
--CLR will responsible for:
--validation
--type safty
--external files access
--SQLCLR disabled by default
--Enable
sp_configure 'clr_enable', 1
go
reconfigure
go
sp_configure 'show advanced options', 1
go
reconfigure
go
sp_configure 'clr strict security',0
go
reconfigure
go


--SMO
--SQL Management Objects [.net Library]
--used to built customized SQL Managment Application
--more control using custom application [backup&restore ....]
--Manage everything in SQLServer
--Optimized instantiation of objects [Don't need to load entire sever before using object]
--more performance [load when u need]

--AMO 
--Analysis Managment objects [BI features]

--RMO 
--Replication Management Objects

--after creating Desktop app from VS2022
--add references for SMO
--C:\Program Files\Microsoft SQL Server\140\SDK\Assemblies
--Microsoft.SqlServer.Smo.dll
--Microsoft.SqlServer.SmoExtended.dll
--Microsoft.SqlServer.SqlEnum.dll
--Microsoft.SqlServer.Management.Sdk.Sfc.dll
--Microsoft.SqlServer.connectioninfo.dll

--then using
--Microsoft.SqlServer.Management.Common;
--Microsoft.SqlServer.Management.SMO;
--Microsoft.SqlServer.Management.SMO.SQLEnum;


SMO_Mahara.sql

Displaying SMO_Mahara.sql.