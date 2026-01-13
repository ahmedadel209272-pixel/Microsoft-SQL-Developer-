/*
CREATE DATABASE ITIDB
ON 
(
name='ITIdata',--mdf file 
filename='E:\.Eng_Ahmed\Data Engineer\Database\DATABASES.ITIdata.mdf'
)
LOG ON
(
name='ITIlog',--log file 
filename='E:\.Eng_Ahmed\Data Engineer\Database\DATABASES.ITIdata.ldf'
)

backup database	ITI
to disk ='E:\.Eng_Ahmed\Data Engineer\Database\ITIbackup.bak'

drop database ITIDB

restore database Company_SS
from disk ='E:\.Eng_Ahmed\Data Engineer\Database\DATABASES\Company_SD.bak'

	
RESTORE DATABASE Company_SD 
FROM DISK = 'E:\.Eng_Ahmed\Data Engineer\Database\DATABASES\Company_SD.bak'
WITH 
    MOVE 'Company_SD' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Company_SD.mdf',
    MOVE 'Company_SD_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Company_SD_log.ldf',
    REPLACE;


CREATE DATABASE w3schools ON 
(NAME = w3schools ,filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\w3schools.mdf'),
(NAME = w3schools_log ,filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\w3schools.ldf')
FOR attach ;

RESTORE DATABASE Company_SD 
FROM DISK = 'E:\.Eng_Ahmed\Data Engineer\Database\DATABASES\Company_SD.bak'
WITH 
REPLACE;

CREATE DATABASE Company_SD 
ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Company_SD.mdf' ),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Company_SD_log.ldf' )
FOR ATTACH;
GO

CREATE DATABASE Parks_and_Recreation 
ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Parks_and_Recreation.mdf'),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Parks_and_Recreation_log.ldf' )
FOR ATTACH;
GO

CREATE DATABASE lab_2 
ON 
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\lab_2.mdf'),
( FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\lab_2_log.ldf' )
FOR ATTACH;
GO
*/


use ITI

select St_Fname ,Department.Dept_Name
from student full outer join Department
on Student.Dept_Id=Department.Dept_Id

select * from student 
select * from Department


select x.St_Fname,y.St_Fname
from Student x left outer join Student y
on x.St_super=y.St_Id

select s.St_Fname,c.Crs_Name,sc.Grade
from Student s inner join  Stud_Course sc on s.St_Id=sc.St_Id inner join  Course c
on c.Crs_Id=sc.Crs_Id


-- Data  Types 
CREATE TABLE MYEMP
(ID INT IDENTITY,
SSN INT PRIMARY KEY,
FNAME VARCHAR(10)
)

SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'MYEMP';

DROP TABLE MYEMP

USE ITI 

DELETE FROM MYEMP

SET IDENTITY_INSERT MYEMP OFF 
INSERT INTO MYEMP(SSN,FNAME) VALUES(55,'SALMA'),(87,'ADEL')
SELECT * FROM MYEMP ORDER BY ID

SELECT @@IDENTITY
SELECT SCOPE_IDENTITY()
SELECT IDENT_CURRENT('MYEMP')
SELECT IDENT_INCR('MYEMP')
SELECT IDENT_SEED('MYEMP')

DBCC CHECKIDENT('MYEMP',RESEED,5)


/*
DROP TABLE STUDENT ==> DDL   DATA & META DATA 
DELETE TABLE STUDENT ==> DML   DATA ONLY WITH WHERE CLAUSE      SLOWER   ROLLBACK   IN LOG FILE  CHILD&PARENT
TRUNCATE TABLE STUDENT ==> DDL(EFFECT STRUCTURE OF THE DATA )   ALL DATA (FASTER THAN DELETE)   FASTER    CAN'T ROLLBACK   SOMETIMES IN LOG    CHILD ONLY    RESET IDENT
*/



-- MODIFICATION FOR PARENT 

DELETE FROM Department
WHERE Dept_Id IN (200,300)

SELECT  * FROM Student


-- NULL 
SELECT ISNULL(St_Fname,'HAS NO NAME') 
FROM Student

RESTORE FILELISTONLY 
from disk ='E:\.Eng_Ahmed\Data Engineer\Database\DBs\Company_DB.bak';

RESTORE DATABASE Company
FROM DISK = 'E:\.Eng_Ahmed\Data Engineer\Database\DBs\Company_DB.bak'
WITH MOVE 'Company_SD' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Company.mdf',
MOVE 'Company_SD_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Company_log',
REPLACE;

SELECT SERVERPROPERTY('InstanceDefaultDataPath') AS DefaultDataPath,
       SERVERPROPERTY('InstanceDefaultLogPath') AS DefaultLogPath;

alter database Company set single_user 

drop database Company


--ASS_2
USE Company_SD

SELECT D.Dnum,D.Dname,d.MGRSSN,E.Fname
FROM Departments D INNER JOIN Employee E
ON D.MGRSSN=E.SSN

SELECT D.Dname,P.Pname
FROM Departments D INNER JOIN Project P
ON D.Dnum=P.Dnum


SELECT D.*,E.Fname
FROM Dependent D INNER JOIN Employee E
ON D.ESSN=E.SSN



--HAVING WITHOUT GROUP BY:

SELECT SUM(salary),AVG(salary)
from instructor
having count(ins_id)<100  -- deal witha whle table as a one group count(ins_id) for all group < 100 


USE ITI 

SELECT HOST_NAME()
SELECT SUSER_NAME()

SELECT *
FROM Student

-- DATE_FN :

select year(GETDATE())
select month(GETDATE())
select day(GETDATE())

-- DATEPART() & DATE NAME()
select DATEPART(MONTH,GETDATE())
select DATENAME(MONTH,GETDATE())

-- DATEDIFF()
SELECT Dept_Name,DATEDIFF(YEAR,Manager_hiredate,GETDATE())
FROM Department

-- DATEFROMPARTS()
SELECT DATEFROMPARTS(2024,12,31)

-- ISDATE() 
SELECT ISDATE('1/1/2000')

-- DATEADD()
SELECT DATEADD(MONTH,5,GETDATE())

--CONVERT&CAST
SELECT CONVERT(varchar(10),'2000/2/25')
SELECT CAST(GETDATE() AS VARCHAR(20))

SELECT CONVERT(varchar(10),GETDATE(),101)
SELECT CONVERT(varchar(10),GETDATE(),102)
SELECT CONVERT(varchar(10),GETDATE(),103)
SELECT CONVERT(varchar(10),GETDATE(),104)

-- FORMAT()
SELECT FORMAT(GETDATE(),'yyyy MMM dd')
SELECT FORMAT(GETDATE(),'dddd MMM yy')
SELECT FORMAT(GETDATE(),'dddd')
SELECT FORMAT(GETDATE(),'hh:mm:ss MMM dd')

-- eomonth() ==> end of month 
select eomonth(getdate())

--NULL_Handeling

SELECT ISNULL(St_Fname,'HAS NO NAME')
FROM Student
 
SELECT COALESCE(St_Lname,st_address,'no data ')
FROM Student

select nullif('ahmed','ahmedd')


-- String_fns

select concat('student name is : ',St_Fname,' ',St_Age)
from Student

select concat_ws('-','student name is',St_Fname,St_Age)
from Student

select concat('my love ',quotename('Ahmed','{'),' reem')
from Student

SELECT UPPER(St_Fname),LOWER(St_Lname),SUBSTRING(St_Address,1,3)
FROM Student

select left('Ahmed',2)
select right('Ahmed',2)

select CHARINDEX('h','roro habib alby') 
select patINDEX('%y','roro habib alby')


 select REPLACE('ahmed loves #','#','reem')

  select stuff('ahmed loves #',12,13,' reem')

select trim('   RORO   ')
select Ltrim('   RORO   ')
select Rtrim('   RORO   ')

SELECT REVERSE(REVERSE('RORO'))

--ARRAY ==> STR

SELECT STRING_AGG(St_Fname,',')
FROM Student

SELECT * FROM STRING_SPLIT('Ahmed,Amr,Mona,Ahmed,Khalid,Heba,Ali,Mohamed,Saly,Fady,Marwa,Noha,Said,hassan',',')
FROM Student

create table mydata
(
eid int Primary key,
ename varchar(20),
skills varchar(40)
)



select Ins_Name,,
case
when Salary>3000 then 'HIGH'
when Salary>3000 then 'LOW'
else 'NO DATA '
end
from Instructor


select Ins_Name,
case gender 
when 'f' then 'Female'
when 'm' then 'Male'
end
from Instructor


select * from Instructor

SELECT I.Ins_Name,iif(I.Salary>3000,'HIGH','LOW')
FROM Instructor as I 


update Instructor
set Salary=
case
when Salary>=3000 then Salary*1.15
when Salary<3000 then Salary*1.25
end

ALTER TABLE Instructor
ADD gender VARCHAR(1)  ;

select floor(123.223)

--  # Security #

---A) authentication (Login name + Password

---1) windows authentication
---wind admin ====> SQL admin

---2) SQLServer authentication
--->create new logins --->new password


---B) authorization (permissions)

--(sqlserver schema) 
--object
--SchemaName.ObjectName
--dbo schema --> default schema

-->login ITIdev
-->user @ (DB_ITI) as ITIdev
-->(schema) HR.instructor_student
--> grant: select insert
--> deny : update delete

USE  ITI 

CREATE SCHEMA [HR] 

ALTER  SCHEMA  [HR] TRANSFER mydata  
alter schema dbo transfer HR.Student



use ITI

SELECT top(2) *
FROM Student 
where St_Address='cairo'

select top(2) *
from Instructor
order by Salary desc

select top(3) with ties *
from Student s
order by s.St_Age desc

select newid()  --ID unique @ server 


select top(2)*, NEWID() as new_id
from Student
order by new_id 


------------------------------------------------------------------------------------------------

-- NEWID () Function
-- Automatically generate a unique identifier

create table Myusers
(
Userid uniqueidentifier Primary key default newid (),
Username varchar(20),
Password varchar(20) )

insert into Myusers (username, password) values('ahmed', '43eww3')

select * from Myusers

-- Perform a union between tables from different databases

select from Project -- no (diff database )

select * from Company_SD.dbo. Project -- yes

select Dept_Name from department
union all
select dname from Company_SD.dbo.Departments

-- SELECT INTO Statement (DDL) --

-- Copy a table [create table from existing one]

select * into table2
from student

-- Copy a tablee to another schema 

select * into HR.table2
from student   --> Not equal [alter schema  HR transfer student] 


-- Copy a tablee to another database

select * into Company_SD.dbo.table2
from student

-- Copy a tablee to another sql server

select * into [IP server].Company_SD.dbo.table2
from student

-- Copy specific columns and rows to a new table.
 
select st_id, st_fname into tab5
from student
where St_Address='alex'

-- create a new empty table using insert into using  the schema of another (meta data only)

select * into tab5
from student
where 1=2  -- false condition 

------------
--simple insert

insert into tab5
values (22, 'ahmed')

--insert constructor

insert into tab5
values(2, 'ahmed'), (444, 'eman'), (777, 'khalid')

--insert based on select

insert into tab5
select st_id, st_fname from Student where st_age>26


-- bulk insert 


select suser_name()
select @@SERVERNAME

-- limit rows affeccted by  DELETE/UPDATE 

update top (5) student
set St_Address='alex'

delete top (10) from student

delete top (25) percent from student

----
use ITI

SELECT *
from( SELECT *,ROW_NUMBER()OVER(ORDER BY St_age desc) as RN 
,dense_rank()OVER(ORDER BY St_age desc) as DR
,NTILE(3)OVER(ORDER BY St_age desc) as G 
FROM Student ) as new_tabe
where G=1 AND DR<=3


--partition with row_number()

select * from (
SELECT *,ROW_NUMBER()OVER(PARTITION BY Dept_id  ORDER BY St_age desc) as RN 
from Student) as new
where RN=1

--partition with Dense_rank()

SELECT *,Dense_rank()OVER(PARTITION BY Dept_id  ORDER BY St_age desc) as DR 
from Student


--partition with Ntile()

SELECT *
from (select*,NTILE(2)OVER(PARTITION BY Dept_id  ORDER BY St_age desc) as G 
from Student) as new 
where G=1 and Dept_Id=10


SELECT *
from( SELECT *,ROW_NUMBER()OVER(PARTITION BY Dept_id  ORDER BY St_age desc) as RN 
,dense_rank()OVER(ORDER BY St_age desc) as DR
,NTILE(3)OVER(ORDER BY St_age desc) as G 
FROM Student ) as new_tabe
where G=1 AND DR<=3

-- Window fns
-- lead | lag | first-value | last-value | percent_rank

select s.st_id as sid, st_fname as sname, grade, crs_name as Cname into grades
from Student s, Stud_Course sc, Course c
where s.St_Id=sc.St_Id and c.crs_Id=sc.Crs_Id

select * from grades
order by Cname

SELECT sname, grade,
lAG(sname) OVER(partition by Cname ORDER BY grade) as prev,
LEAD(sname) OVER(partition by Cname ORDER BY grade) as next
FROM grades

SELECT sname, grade,
FIRST_VALUE(Grade) OVER(partition by Cname ORDER BY grade) as FISRT,
LAST_VALUE(Grade) OVER(partition by Cname ORDER BY grade rows between unbounded preceding and unbounded following) as _LAST
FROM grades


SELECT sname, grade,
_perecent=cast(percent_rank() OVER(partition by Cname ORDER BY grade)  as decimal(8,2))
FROM grades

----------------------------------------------
create table lastt
(
Lid int,
Lname varchar(10),
Lvalue int
)

create table Dailyt
(
did int,
dname varchar(10),
dvalue int
)

merge into lastt as T
using Dailyt S
on T.Lid=S.did

when matched then 
update 
set T.Lvalue=S.dvalue

when not matched then 
insert
Values(S.did,S.dname,S.dvalue)
output $action ;
----------------------------------------
-- ROLLUP | CUBE | GROUPING SETS
use iti 
create table sales (
Pid int ,
salesman varchar(10),
quantity int )

insert into sales
values (2,'ahmed',30),(5,'ali',20),(4,'khalid',10),(3,'reem',5),(6,'adel',15),(6,'hoda',12),(7,'hager',17)

select * from sales 
order by Pid

select salesman,sum(quantity) 
from sales 
group by salesman
union 
select 'total',sum(quantity)
from sales
-- eqaul to
select isnull(salesman,'totalll'),sum(quantity) 
from sales 
group by rollup(salesman)

---------------

select pid,salesman,sum(quantity) 
from sales 
group by rollup(Pid,salesman)

select pid,salesman,sum(quantity) 
from sales 
group by cube(Pid,salesman)

-- !! if there are more one column rollup aplly agg fn on the first column only but cume aplply on all clomns 

-- Grouping sets 


select pid,salesman,sum(quantity) 
from sales 
group by grouping sets(Pid,salesman)

-- مجموع المبيعات لكل موظف و مجموع المبيعات لكل منتج فقطططططط

-- PIVOT and UNPIVOT OLAP
-- min u need 3 columns [3_dim --> X,Y,Z(agg)]

-- في النهاية هي طريقه عرض مختلفه لنفس الجدول

--pivot 

select * from (select cast(pid as varchar(5)) as prod , salesman,quantity from sales) as new
pivot(sum(Quantity) for salesman in ([ahmed],[ali],[khalid],[reem],[adel]) )as pvt1
union all
select *
from (select 'total'as prod ,salesman,quantity from sales ) as new
pivot(sum(Quantity) for salesman in ([ahmed],[ali],[khalid],[reem],[adel]) ) as pvt 

-- unpivot

select * into new
from sales 
pivot (sum(quantity) for salesman in ([ahmed],[ali],[khalid],[reem],[adel]) ) as pvt

select * from new
unpivot (quantity for salesman in ([ahmed],[ali],[khalid],[reem],[adel])) as unpvt
