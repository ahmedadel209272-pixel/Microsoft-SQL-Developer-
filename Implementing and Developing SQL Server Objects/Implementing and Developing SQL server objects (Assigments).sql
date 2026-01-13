-- Implementing and Developing SQL server objects

-- [ ASS _ CH-1 ]

-- Part 1:

use SD

--a
-- define a new data type
sp_addtype loc , 'nchar(2)'

--create a new rule 
create rule r1  as @x in ('NY','DS','KW');

--create a new default 
create default d1 as 'NY'

--bind rule & default
sp_bindrule r1,loc
go
sp_bindefault d1,loc

--create a new table & inser data
create table Department
( DeptNo int primary key,
DeptName varchar(15),
Location loc
)
insert into Department
values('d1','Research','NY'),('d2','Accounting','DS'),('d3','Markiting','KW')

create table Employee
(EmpNo int primary key,
[Emp Fname] varchar(15) not null,
[Emp Lname] varchar(15) not null,
[DeptNo] varchar(4),
Salary int unique,
constraint c2 foreign key(DeptNo) references Department(DeptNo) 
)

create rule r2 as @x<6000;
sp_bindrule r2 ,'Employee.Salary';

insert into Employee values
(25348,'Mathew','Smith','d3',2500)
,(10102,'Ann','Jones','d3',3000)
,(18316,'John','Barrimore','d1',2400)
,(29346,'James','James','d2',2800)

create table Project (
ProjectNo varchar(4) primary key,
ProjectName varchar(15) not null,
Budget int )

insert into Project values 
 ('p1','Apollo',120000)
,('p2','Gemini',95000)
,('p3','Mercury',185600)
 
insert into Works_on
values 
 (10102,'p1','Analyst','2006.10.1')
,(10102,'p3','Manager','2012.1.1')
,(25348,'p2','Clerk','2007.2.15')
,(18316,'p2',NULL,'2007.6.1')
,(29346,'p2',NULL,'2006.12.15')

insert into Works_on
values 
 (11111,'p1','Analyst','2006.10.1') -- XXXX : foreign key constraint 

alter table Employee
add TelephoneNumber varchar(50)

alter table Employee
drop column TelephoneNumber;

create schema Company ;
go
alter schema Company transfer Department

create schema [HumanResource] ;
go
alter schema [HumanResource] transfer Employee 

--3 Write query to display the constraints for the Employee table.
EXEC sp_helpconstraint 'Human Resourse.Employee';

--4
create synonym Emp for [HumanResource].[Emlpoyee]  

drop synonym Emp

Select * from Employee --NO
Select * from [HumanResource].Employee;--YES
Select * from Emp;
Select * from [Human Resourse].Emp --NO

--5
select * from Company.project

update Company.project set Budget*=1.1
where ProjectNo = (select p.ProjectNo
from Works_on w join Company.Project p
on w.ProjectNo = p.ProjectNo join HumanResource.Employee e
on e.EmpNo=w.EmpNo
where e.EmpNo=10102 and w.job='manager')

--6
update Company.Department 
set DeptName='Sales'
where DeptName=(select DeptName from Company.Department d join HumanResource.Employee e
on d.DeptNo=e.DeptNo
where e.[Emp Fname]='james')


--7
update works_on set Enter_Date ='12.12.2017'
where projectNo='p1' and EmpNo=(select EmpNo from HumanResource.Employee e join Company.Department d 
on e.DeptNo =d.DeptNo
where d.DeptName='Sales')


--8
delete from Works_on
where EmpNo in (select EmpNo from HumanResource.Employee e join Company.Department d on e.DeptNo=d.DeptNo
where d.Location='KW')


--9
select*from Student
insert into Student(St_id)
values(55)

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- [ ASS _ CH-2 ]

--1
alter function get_month(@x date)
returns varchar(10)
begin 
    return datename(month,@x)
end
go
select dbo.get_month('2002-2-4')
------------------------------------------------
--2
create function get_range(@x int,@y int )
returns @t table (val int)
as
begin
  declare @current int= @x +1;
  while @current<@y
    begin
      insert into @t(val) values(@current)
	  select @current+=1
    end
	return
end

select * from get_range(5,10)
------------------------------------------------
--3
create function st_info(@no int)
returns table
as
  return
  (
  select CONCAT(s.St_Fname,' ',s.St_Lname) as [Full Name],d.Dept_Name 
  from Student s join Department d 
  on s.Dept_Id=d.Dept_Id 
  where s.St_Id=@no
  )

select * from  st_info(5)
------------------------------------------------
--4
alter function info(@id int)
returns varchar(35)
begin 
declare @info varchar(35);
select @info= 
case 
  when St_Fname is null and St_Lname is null then 'First name & last name are null'
  when St_Fname is null then 'first name is null'
  when St_Lname is null then 'last name is null'
  else 'First name & last name are not null'
end 
from Student where St_Id=@id
return @info
end

select dbo.info(10)
select dbo.info(12)
select dbo.info(13)
select dbo.info(1)

select * from Student
------------------------------------------------
--5
create function mag_info (@no int)
returns table 
as 
  return
  (
  select d.Dept_Name,i.Ins_Name,d.Manager_hiredate 
  from Department d join Instructor i 
  on d.Dept_Manager = i.Ins_Id
  where i.Ins_Id=@no
  )

select * from mag_info(5)
------------------------------------------------
--6
create function ahmed(@aa varchar(20))
returns @t table(val varchar(20))
as
  begin
  insert into @t
  select
     case
	 when @aa ='first name' then St_Fname
	 when @aa ='last name' then St_Lname
	 when @aa ='full name' then concat(St_Fname,' ',St_Lname)
	 end
   from student
   return
  end

select * from ahmed('full name')
------------------------------------------------
--7
select s.St_Id as Student_No, substring(St_Fname,1, (len(St_Fname)-1) )
from student s
------------------------------------------------
--8
delete from Stud_Course 
   where St_Id in  ( select s.St_Id
                     from Student s join Department d
                     on s.Dept_Id=d.Dept_Id
                     where d.Dept_Name='SD')

------------------------------------------------
------------------------------------------------
-- Bonus:
-- 1. Give an example for Hierarch id Data type 
--> XML data type

-- 2.

Use Company_SD

declare @var int;
set @var=1
while @var<=3000
    begin
        insert into Employee(SSN,Fname,Lname,Dno)
        values(@var,'Jane',' Smith',10)
        set @var+=1
    end

select * from Employee

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------


-- [ ASS _ CH-3 ]

--1	
create view tab_1 as(
					select concat(St_Fname,' ',St_Lname) as [Full Name] ,c.Crs_id
					from Student s join stud_course sc 
					on s.St_id=sc.St_id join course c 
					on sc.Crs_id=c.Crs_id
					where sc.Grade>50
					)
select * from tab_1
------------------------------------------------
--2
create view v3 
with encryption as (select i.Ins_Name as [Manager Name],C.Crs_Name as [Topic Taught]
					from Department d join instructor i 
					on d.dept_manager = i.ins_id
					join ins_course ic on ic.ins_id=d.dept_manager 
					join course c on ic.Crs_id=c.crs_id )
------------------------------------------------
--3
alter view v4 as  (select i.Ins_Name as [Instructor Name],d.Dept_Name
					from Department d join instructor i 
					on d.dept_manager = i.ins_id
					WHERE D.Dept_Name IN ('SD', 'Java') )
select * from v4
------------------------------------------------
--4
create view v1 as(select * from student 
				  where St_address ='Alex'
				  or St_address ='cairo')
with check option 
------------------------------------------------
--5
create view v5 as 
				 (select distinct p.pname,count(w.ESSn)
				  from Project p join Works_for w
				  on p.Pnumber=w.Pno
				  group by pname )
------------------------------------------------
--6
-- Cannot create more than one clustered index on table 'Departments'

-- 1)Drop the existing clustered index 'PK_Departments'
    alter Departments
    drop constraint PK_Departments;

-- 2)create clustered index you want 
    create clustered index dept_manager_startdate
    on Departments(MGRstartDate)

/* Notes!
                        --- Clustered Index ---

What it is --> Determines the physical order of data in the table
The table data is stored in the leaf nodes of the index
Only one clustered index per table (since data can only be physically sorted one way)

Characteristics:

Fast for range queries (BETWEEN, >, <)
Automatically created when you define a PRIMARY KEY (unless specified otherwise)
Doesn't require extra storage for the data itself
Slower for INSERT/UPDATE/DELETE operations (data needs to be physically rearranged)

                     --- Non-Clustered Index ---

What it is --> Separate structure from the actual table data

Contains the indexed columns and a pointer to the actual data
Multiple non-clustered indexes can be created per table (up to 999 in SQL Server)
The leaf nodes contain pointers to the data rows

Characteristics:

Faster for INSERT/UPDATE/DELETE compared to clustered indexes
Requires extra storage space
Good for frequently queried columns that aren't the primary key 
Slower for data retrieval than clustered indexes (requires additional lookup)
*/

------------------------------------------------
--7
create unique nonclustered index age_index
on student(St_Age)

-- because a duplicate key was found for the object name 'dbo.Student'

------------------------------------------------
--8
use SD

-- Create tables
CREATE  TABLE Last_Transactions (User_ID int , Transaction_Amount decimal(10,2))
CREATE  TABLE Dialy_Transactions (User_ID int , Transaction_Amount decimal(10,2))

--Insert data 
insert into Last_Transactions values (1,4000),(4,2000),(2,10000)
insert into Dialy_Transactions values (1,1000),(2,2000),(3,1000)

--Query 
MERGE INTO Last_Transactions T
USING Dialy_Transactions S
ON T.User_ID=S.User_ID
WHEN    MATCHED  THEN
				 UPDATE 
				 SET T.Transaction_Amount=S.Transaction_Amount
WHEN NOT MATCHED THEN 
				 INSERT VALUES (S.User_ID,S.Transaction_Amount);
-- WHEN NOT MATCHED THEN BY SOURCE 

SELECT * FROM Dialy_Transactions
SELECT * FROM Last_Transactions
------------------------------------------------
-- Part2: 
use SD

-- 1.
create view v_clerk
as 
	(select w.EmpNo,w.ProjectNo,w.enter_Date
	from Works_on w
	where w.job='Clerk')

select * from v_clerk 
------------------------------------------------
-- 2.
create view v_without_budget
as
	(select *
	from Project p
	where p.Budget is null)

select * from v_without_budget
------------------------------------------------
-- 3.
create view v_count 
as 
	(select p.ProjectName,COUNT(w.job) as [No of jobs]
	from Project p join Works_on w
		on p.ProjectNo=w.ProjectNo
	group by p.ProjectName
	)

select * from v_count
------------------------------------------------
-- 4.
create view v_project_p2
as
	(select v.EmpNo
	from v_clerk v
	where v.ProjectNo='p2')

select * from v_project_p2
------------------------------------------------
-- 5.
alter view v_without_budget
as
	(select *
	from Project p
	where p.Budget is null and p.ProjectNo in ('p1','p2') )
------------------------------------------------
-- 6.

drop view v_clerk
drop view v_count
------------------------------------------------
-- 7.
alter view emp_lname_d2
as
	(select Emp.EmpNo,Emp.EmpLname
	from Emp 
	where Emp.DeptNo='d2' )

------------------------------------------------
-- 8.
select distinct EmpLname
from emp_lname_d2
where CHARINDEX('j',EmpLname)>0

------------------------------------------------
-- 9.
create view v_dept
as
	(select CD.DeptNo,DeptName 
	from CD)
------------------------------------------------
-- 10.
insert into v_dept values('d4','Development’')
------------------------------------------------
-- 11.
create view v_2006_check
as
	(select EmpNo,ProjectNo
	from Works_on
	where year(enter_Date)=2006
	)
with check option

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------


-- [ ASS _ CH-4 ]



--01)

create proc [Num_stud_dept]
as 
begin
	select Dept_Name,count(St_Id) as No_of_stud 
	from Student s right join Department d
	on s.Dept_id=d.Dept_id
	group by Dept_Name
end

--02)
CREATE proc [dbo].[CheckEmployeesInProject]
as  
	declare @Pno int
	declare @count int 

	select @Pno=Pnumber from project where Pname='AL Solimaniah'
	select @count =count(ESSn) from works_for where Pno=@Pno group by Pno

	if @count>=3 
		begin
			PRINT 'The number of employees in the project p1 is 3 or more'
		end
	else
		begin
			PRINT 'The following employees work for the project p1:'
			SELECT Fname, Lname
			FROM Employee E
			JOIN Works_for W 
			ON E.Ssn = W.Essn
			WHERE W.Pno = @Pno
		end

--03)
CREATE PROCEDURE ReplaceEmployeeInProject @OldEmp INT,@NewEmp INT,@ProjNo INT
AS
	update works_for
	set ESSn=@NewEmp
	where ESSn=@OldEmp and Pno = @ProjNo

--04)
ALTER TABLE Project
ADD Budget MONEY

UPDATE Project
SET Budget = 100000

CREATE TABLE [audit] (
    ProjectNo INT,
    UserName NVARCHAR(50),
    ModifiedDate DATETIME,
    Budget_Old MONEY,
    Budget_New MONEY )


create trigger [budget_update]
on [Project]
after update  
as
	if update(budget)
	begin
		insert into audit(Pname, UserName, ModifiedDate, Budget_Old, Budget_New)
		select  i.Pname,
				suser_name(),
				getdate(),
				d.budget,
				i.budget 
		from inserted i join deleted d 
		ON i.Pnumber = d.Pnumber
	end

--05)
create trigger [dbo].[no_insert]
on Department
instead of insert 
as
	Begin
		print 'can’t insert a new record in that table'
	End

--06)
CREATE trigger [dbo].[no_insert_@march]
on [dbo].[Employee]
after insert
as 
begin
	if month(getdate())=3
		begin
			print'Insertion in March is not allowed'
			rollback
		end
end

--07)
CREATE trigger trg_StudentInsertAudit
on Student
after insert 
as
	begin
		declare @key_value int
		declare @user varchar(max)=suser_name() 

		select @key_value=St_id from inserted

		insert into student_Audit
		values(@user,
			   getdate(),
			   @user+' Insert New Row with Key='+cast(@Key_Value AS VARCHAR(10))+'in table [Student]' )
	end

--08)
CREATE trigger [dbo].[no_delete] 
on [dbo].[Student] 
instead of delete
as
begin
	declare @user varchar(50) =suser_name()
	declare @key int 
	select @key=St_id from deleted

	insert into student_Audit
	values	(@user,
			getdate(),
			'try to delete Row with Key= '+cast( @key as varchar(10) )  
			)
end

--09) Use XML Raw
use AdventureWorks2012

--A) Elements
select * 
from HumanResources.Employee 
for xml RAW('Emplpyee'),elements ,root('Employees')

--B) Attributes
select * 
from HumanResources.Employee 
for xml RAW


--10)
USE ITI

--A) Use XML Auto
select d.Dept_Name,i.Ins_Name
from Department d join Instructor i
on d.Dept_Id=i.Dept_Id
for xml Auto,root('Departments')

--B) Use XML Path
select  d.Dept_Name "Department/@Name",
		i.Ins_Name "Department/Instructor"  
from Department d join Instructor i
on d.Dept_Id=i.Dept_Id
for xml Path ('')

SELECT 
    D.Dept_Name AS [@Name],
    (
        SELECT 
            I.Ins_Name AS [Instructor]
        FROM Instructor I
        WHERE I.Dept_Id = D.Dept_Id
        FOR XML PATH(''), TYPE
    )
FROM Department D
FOR XML PATH('Department'), ROOT('Departments');


--11)
declare @doc xml ='<customers>
					  <customer FirstName="Bob" Zipcode="91126">
							 <order ID="12221">Laptop</order>
					  </customer>
					  <customer FirstName="Judy" Zipcode="23235">
							 <order ID="12221">Workstation</order>
					  </customer>
					  <customer FirstName="Howard" Zipcode="20009">
							 <order ID="3331122">Laptop</order>
					  </customer>
					  <customer FirstName="Mary" Zipcode="12345">
							 <order ID="555555">Server</order>
					  </customer>
			       </customers>'

declare @hdoc int 

execute sp_xml_preparedocument @hdoc output, @doc

insert into customer
select  FirstName,
		Zipcode,
		OrderID,
		OrderName
from openxml(@hdoc,'//order',2)
with (  FirstName  VARCHAR(50) '../@FirstName',
		Zipcode    INT         '../@Zipcode',
		OrderID    INT         '@ID',
		OrderName  VARCHAR(50) '.' ) ;

Exec sp_xml_removedocument @hdoc

select * from customer

-- Part-2 [cursor] :

12-

--1. declare the cursor
	Declare c1 CURSOR 
--2. specify the SELECT statement
	for 
		select EmpNo,salary  
		from Employee
--2. define if you want to read only or update 
	for update  
--3. declare the variables 
	declare @id int,@sal decimal(10,2)
--4. open the cursor
	open c1
--5. Fetch the First Row --> counter=0
	fetch from c1 into @id,@sal
--6. Loop Control: Check if the FETCH operation was successful.
	while @@FETCH_STATUS=0
--7. write thelogic 
	begin
		if @sal<3000
			update Employee set salary=@sal*1.1
			where EmpNo = @id
		else
			update Employee set salary=@sal*1.2
			where EmpNo = @id
--8.Fetch the next row inside the loop. [counter ++]
			fetch next from c1 into @id,@sal
	end
--9. close the cursor 
	close c1
--10. Deallocate the Cursor: Releases the memory resources occupied by the cursor.
	deallocate c1 

13-

DECLARE c2 CURSOR 
FOR
SELECT Dname,Fname
FROM Employee JOIN departments
ON SSN=MGRSSN   
FOR READ ONLY
DECLARE @DEP VARCHAR(8),@FN VARCHAR(10)
OPEN C2
FETCH FROM C2 INTO @DEP,@FN
WHILE @@FETCH_STATUS=0
	BEGIN
		SELECT @DEP AS Dep,@FN AS First_name
		FETCH NEXT FROM C2 INTO @DEP,@FN 
	END
CLOSE C2 
DEALLOCATE C2

14-

USE ITI
DECLARE C11 CURSOR
FOR
SELECT St_Fname FROM student 
FOR READ ONLY 
DECLARE @NAME VARCHAR(10),@ALL VARCHAR(300)
OPEN C11
FETCH NEXT FROM C11 INTO @NAME 
WHILE @@FETCH_STATUS=0 
	BEGIN
		IF @NAME IS NOT NULL
			SET @ALL =CONCAT( @ALL,@NAME,', ') ;
			FETCH NEXT FROM C11 INTO @NAME;
	END
CLOSE C11;
DEALLOCATE C11;
--DISPLAY SET OF NAMES
SELECT @ALL AS AllStudentNames;

--The Result
--Ahmed, Amr, Mona, Ahmed, Muhammad, Mahmoud, Ali, lool, Saly, Muhammad, Marwa, Said, hassan, Reem, ahmed, Ali, 

15-
BACKUP DATABASE SD
TO DISK = 'D:\backups\SD_full.bak'
WITH INIT;

BACKUP DATABASE SD
TO DISK = 'D:\backups\SD_diff.bak'
WITH DIFFERENTIAL;

16-


                                                                                                             /*
Part-2:
What is the difference between the following objects in SQL Server:

1) batch, script and transaction 

Batch: A group of [Highlighted] SQL statements sent together to execute at once
Script: A text file containing one or more SQL statements
Transaction: A set of SQL statements executed as a single ACID unit [Commit & Rollback]
---------------------------------------
2) trigger and stored procedure

Trigger:A special type of stored procedure that automatically executes when a specific event occurs on a table.
SP: A stored procedure is a set of SQL statements stored in the database that performs a specific task,
can return zero or more values, can manipulate data, and can be executed independently.
---------------------------------------
3) stored procedure and functions

SP: is a set of SQL statements stored in the database that performs a specific task
, can manipulate data
, can return zero or more values
and can be executed independently."

Function: is a SQL object stored in the database that performs a specific calculation or operation
,always returns a single value or table
, is read-only
, and is used inside queries."
---------------------------------------
4) drop, truncate and delete statement

DROP: permanently deletes a database object, such as a table or view, from the database.[metadata+data]

TRUNCATE: quickly removes all rows from a table, resets identity columns, and uses minimal logging, but the table structure remains.
[data only]

DELETE:removes specific rows from a table based on a condition and logs each deletion, allowing rollback."
---------------------------------------
5) select and select into statement

SELECT: retrieves data from one or more existing tables without creating a new table.

SELECT *** INTO ***: creates a new table and copies the selected data into it in a single operation.
---------------------------------------
6) local and global variables

local variable: 
is declared inside a batch, procedure, or function, is accessible only within that scope, and its name starts with a single @ symbol

Global Variable:
is available throughout the entire SQL Server session or system, and its name starts with two @@ symbols
---------------------------------------
7)convert and cast statements

CAST: converts a value from one data type to another using standard SQL syntax.
ex:
CAST(Salary AS VARCHAR(10))

CONVERT: "CONVERT converts a value from one data type to another and allows formatting, 
especially for date and time value

ex:
CONVERT(VARCHAR(10), HireDate, 101)--> Convert the HireDate column (DATETIME) to MM/DD/YYYY format
---------------------------------------
8) DDL,DML,DCL,DQL and TCL

DDL (Data Definition Language): define or modify database objects such as tables, views, or schemas.
Example: CREATE, ALTER, DROP

DML (Data Manipulation Language): are used to manipulate data stored in tables.
Examples: INSERT, UPDATE, DELETE

DCL (Data Control Language): are used to control access and permissions in the database."
Examples: GRANT, REVOKE

DQL (Data Query Language): are used to query and retrieve data from the database.
Example: SELECT

TCL (Transaction Control Language): are used to manage transactions in the database, ensuring data integrity.
Examples: COMMIT, ROLLBACK, SAVEPOINT


---------------------------------------
9) For xml raw and for xml auto

FOR XML RAW: returns each row as a separate <row> element with column values as attribute
ex: <row EmployeeID="1" EmployeeName="Ahmed" />

FOR XML AUTO: returns each row as an XML element named after the table, 
and nested elements for related tables.
ex:  <Employees EmployeeID="1" EmployeeName="Ahmed" />

---------------------------------------
10) Table valued and multi statemcent function

Inline TVF: Single SELECT, simpler, faster.

Multi-Statement: Can have multiple statements, use table variable to accumulate results, slightly slower.

---------------------------------------
11) Varchar(50) and varchar(max)

VARCHAR(50): a variable-length string data type that can store up to 50 characters.

VARCHAR(MAX): a variable-length string data type that can store up to (2^31)-1 characters (~2GB).

---------------------------------------
12) Datetime, datetime2(7) and datetimeoffset(7)

DATETIME: stores date and time values ranging from 1753-9999 
with accuracy of 3.33 milliseconds 
ex:
SET @dt = '2025-12-04 14:30:00';

DATETIME2(7):stores date and time values ranging from 0001-9999
allows specifying precision for fractional seconds (up to 7 digits)
ex: 
SET @dt2 = '2025-12-04 14:30:00.1234567';

DATETIMEOFFSET(7): stores date and time with fractional seconds (up to 7 digits) and includes the time zone offset from UTC.
الفرق بالساعات والدقائق بين توقيتك المحلي وتوقيت جرينتش (UTC).

---------------------------------------
13) Default instance and named instance

Default Instance: the main SQL Server instance on a machine and is accessed using only the server name.

Named Instance: Named has a specific name and allows multiple SQL instances on the same machine
---------------------------------------
14) SQL and windows Authentication

---------------------------------------
15) Clustered and non-clustered index

Clustered Index: Defines the physical order of data in the table.

Non-Clustered Index: A separate structure that stores index keys and pointers to the actual data.

✅ Key Difference:
Only one clustered index per table, but multiple non-clustered indexes are allowed.

---------------------------------------
16) Group by rollup and group by cube

---------------------------------------
Sequence object and identity 

---------------------------------------
Inline function and view

---------------------------------------
Table variable and temporary table



---------------------------------------
20) Row_number() and dense_Rank() function

ROW_NUMBER():
"Assigns a unique sequential number to each row, even if values are equal."
ترقيم فريد لكل صف حتى لو القيم مكررة

DENSE_RANK():
"Assigns the same rank to equal values without gaps in ranking."
نفس الترتيب للقيم المكررة

Example: Values: 100, 100, 200

ROW_NUMBER → 1, 2, 3
DENSE_RANK → 1, 1, 2
---------------------------------------
21) View & CTE 

View: A virtual table created from a stored SELECT query and saved inside the database for repeated use.

Stored permanently in the database.
Can be reused many times.
Does not store data, only the query.
Can have indexes (Indexed View).
Cannot be recursivea


CTE (Common Table Expression):A temporary named result set defined within a query and used only during its execution.

Exists only during the query execution.
Not stored in the database.
Can be recursive.
Improves query readability.
Cannot have indexes.

                                                                                                             */