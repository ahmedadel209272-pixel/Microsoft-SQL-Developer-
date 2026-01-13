-- [ ASS _ CH-1 ]

-- Part-2
--1
SELECT * FROM EMPLOYEE 
--2
SELECT FNAME,LNAME,SALARY,DNO
FROM EMPLOYEE
--3
SELECT PNAME,PLOCATION,DNUM
FROM PROJECT
--4
SELECT FNAME+' '+LNAME AS FULL_NAME,(SALARY*12*0.1)AS [ANNUAL COMM]
FROM EMPLOYEE
--5
SELECT SSN,FNAME
FROM EMPLOYEE
WHERE SALARY>1000
--6
SELECT SSN,FNAME
FROM EMPLOYEE
WHERE (SALARY*12)>10000
--7
SELECT FNAME,SALARY
FROM EMPLOYEE
WHERE SEX='F'
--8
SELECT DNUM,DNAME
FROM DEPARTMENT
WHERE MGRSSN=968574
--9
SELECT PNAME,PNUMBER,PLOCATION
FROM PROJECT
WHERE DNUM=10

-----------------------------------------------------------------------------------
-- [ ASS _ CH-2 ]

--1
SELECT d.Dnum,d.Dname,e.SSN AS Manager_ID,e.Fname + ' ' + e.Lname AS Manager_Name
FROM Departments d
JOIN Employee e 
ON d.MGRSSN = e.SSN;

--2
SELECT d.Dname,p.Pname
FROM Departments d JOIN Project p 
ON d.Dnum = p.Dnum;
--3
SELECT concat(e.Fname,' ',e.Lname) AS Employee_Name, d.*
FROM Dependent d JOIN Employee e
    ON d.ESSN = e.SSN;
--4
SELECT Pnumber,Pname,City
FROM Project
WHERE City IN ('Cairo', 'Alex');
--5
SELECT *
FROM Project
WHERE Pname LIKE 'A%';
--6
SELECT *
FROM Employee
WHERE (Dno = 30) AND (Salary BETWEEN 1000 AND 2000);
--7
SELECT concat(e.Fname,' ',e.Lname) AS Full_Name
FROM Employee e JOIN Works_for w
    ON e.SSN = w.ESSn
JOIN Project p
    ON w.Pno = p.Pnumber
WHERE (e.Dno=10) AND (w.Hours >= 10) AND (p.Pname = 'AL Rabwah');
--8
SELECT concat(X.Fname,' ',X.Lname) AS Full_Name
FROM Employee X JOIN Employee Y
ON X.Superssn = Y.SSN
WHERE (Y.Fname='Kamel') AND (Y.Lname='Mohamed');
--9
SELECT concat(e.Fname,' ',e.Lname) AS Full_Name,p.Pname
FROM Employee e JOIN Works_for w
ON e.SSN = w.ESSn JOIN Project p
ON w.Pno = p.Pnumber
ORDER BY p.Pname;
--10
SELECT p.Pnumber,d.Dname,e.Lname AS Manager_LastName,e.Address,e.Bdate
FROM Project p JOIN Departments d
ON p.Dnum = d.Dnum
JOIN Employee e
ON d.MGRSSN = e.SSN
WHERE p.City = 'Cairo';
--11
SELECT DISTINCT e.*
FROM Employee e
JOIN Departments d
    ON e.SSN = d.MGRSSN;
--12
SELECT e.*,d.*
FROM Employee e LEFT JOIN Dependent d
ON e.SSN = d.ESSN;

--13
INSERT INTO Employee
VALUES ('Ahmed', 'Adel', 102672, '04/22/2002','Alexandria', 'M', 3000,112233, 30);

--14
INSERT INTO Employee (Fname, Lname, SSN, Dno)
VALUES ('amr', 'hashem', 102660, 30);

--15
UPDATE Employee
SET Salary = Salary * 1.2
WHERE SSN = 102672;

-----------------------------------------------------------------------------------
-- [ ASS _ CH-3 ]

/*
1.Display (Using Union Function)
	a.The name and the gender of the dependence that's gender is Female and depending on Female Employee.
	b.And the male dependence that depends on Male Employee.  */

select d.Dependent_name,d.Sex
from Dependent d join Employee e
on (d.ESSN=e.SSN) and (e.Sex='F') and (d.Sex='F')
union all
select d.Dependent_name,d.Sex
from Dependent d join Employee e
on (d.ESSN=e.SSN) and (e.Sex='M') and (d.Sex='M')

--2.For each project, list the project name and the total hours per week (for all employees) spent on that project.

select Pname,sum(Hours) as [total hrs for all employees]
from Project P join Works_for W on P.Pnumber=W.Pno
group by Pname
order by [total hrs for all employees] desc

--3.Display the data of the department which has the smallest employee ID over all employees' ID.
select distinct d.*
from Employee e join Departments d
on e.Dno=d.Dnum
WHERE d.MGRSSN=(SELECT MIN(MGRSSN)FROM Departments)

--4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select min(Salary) Min_SALARY,max(Salary) Max_SALARY,avg(Salary) AVG_SALARY , Dname 
from Employee e join Departments d
	on e.Dno=d.Dnum
group by Dname

--5.List the last name of all managers who have no dependents.
select Lname as [mgr don't have dependents] 
from Employee e join Departments d
on SSN=MGRSSN
where SSN not in (select distinct ESSN from Dependent)
-- OR using joins only
select Fname+' '+Lname as [mgr don't have dependents]
from Employee e join Departments d
on SSN=MGRSSN left join Dependent dd
on e.SSN=dd.ESSN
where dd.ESSN is null

                                                                                         /*
6.For each department:
	if its average salary is less than the average salary of all employees
	display its number, name and number of its employees.  
                                                                                         */
select  Dnum,
		Dname,
		count(SSN) AS NO_of_Employees,
		avg(salary) as AVG_SALARY
from Departments D join Employee E
	on D.Dnum=E.Dno
group by Dname,Dnum
having avg(E.Salary)<(select avg (Salary) from Employee)

                                                                                         /*
7.Retrieve a list of employees and the projects they are working on ordered by department 
	and within each department:
	ordered alphabetically by last name, first name.
	                                                                                         */
SELECT  (Fname+' '+Lname) as Full_Name,
		Pname,
		D.Dname
from Employee E join Works_for 
	on SSN=ESSN 
join Project 
	on Pnumber=Pno 
join Departments D 
	on E.Dno=D.Dnum
order by D.Dname,Fname,Lname

--8.Try to get the max 2 salaries using subquery

select aa.Salary
FROM (
    select MAX(Salary) AS Salary from Employee
    union all 
    select MAX(Salary)
    from Employee
    WHERE Salary < (select MAX(Salary) from Employee)
) AS aa
ORDER BY aa.Salary desc;

--9.Get the full name of employees that is similar to any dependent name
	select concat(Fname,' ',Lname) as Emp_FullName
	from Employee
	intersect 
	select Dependent_name
	from Dependent 

--10.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%

select ESSN,Pname,Salary
from Works_for join Project p
on Pno=p.Pnumber join Employee on Employee.SSN=ESSn
where Pname='Al Rabwah'

update Employee
set  Salary=Salary*1.3
from Works_for join Project p 
	on Pno=p.Pnumber 
join Employee 
	on Employee.SSN=ESSn
where Pname='Al Rabwah'

--11.Display the employee number and name,if at least one of them have dependents (use exists keyword)
-- self study

--Exists : returns TRUE if the subquery returns one or more rows, and FALSE if it returns zero rows.

SELECT SSN,Fname
from Employee e
where Exists (select d.ESSN
              from Dependent d
			  where e.SSN=d.ESSN)

--[Part.2-DML]

--1
INSERT INTO Departments
VALUES('DEPT IT',100,112233,'1-11-2006')

-- 2:

	--a
		update Departments
		set MGRSSN=968574
		where Dnum=100

	--b
		update Departments
		set MGRSSN=102672 ,MGRStart_Date=GETDATE()
		where Dnum=20

	--c
		update Employee
		set Superssn=102672
		where SSN=102660 

--3
update Employee
set Superssn=102672
where Superssn=223344

select Dependent_name 
from Employee E join Dependent D 
on E.SSN=D.ESSN
where  ESSN=223344

delete from [Dependent]
where ESSN=223344

delete from Works_for
where ESSn=223344

delete from Employee
where SSN=223344

-----------------------------------------------------------------------------------
-- [ ASS _ CH-5 ]

-- Part 1: ITI_DB Solutions

--1
select count(St_Age) from Student
--2
select distinct Ins_Name from Instructor
--3
select  St_Id as [Student ID],
isnull(concat(St_Fname,' ',St_Lname),St_Fname)as [Student Full Name],
isnull(convert(varchar(5),dept_id),'no department') as [Department name]
from Student 
--4
select I.Ins_Name,D.Dept_Name 
from Instructor I left outer join Department D
on I.Dept_Id=D.Dept_Id 
--5
select concat(St_Fname,' ',St_Lname) as [Student Full Name],C.Crs_Name
from Student S join Stud_Course SC on S.St_Id=SC.St_Id join Course C
on SC.Crs_Id=C.Crs_Id
where SC.Grade is not null
--6
select count(Crs_Id),t.Top_Name
from Course c join Topic t on c.Top_Id=t.Top_Id  group by t.Top_Name
--7
select MAX(Salary) as max_salary,MIN(Salary) as min_salary
from Instructor
--8
select Ins_Name,Salary
from Instructor
where Salary<(select avg(salary) from Instructor)
--9
select Ins_Name,d.Dept_Name
from Instructor i join Department d
on i.Dept_Id=d.Dept_Id
where Salary=(select min(Salary)from Instructor)
--10
select top(2) salary
from instructor 
order by Salary desc
--11
select Ins_Name,coalesce(convert(varchar(15),Salary),'instructor bonus')
from  Instructor
--12
select avg(salary)from Instructor
--13
select Y.St_Fname,X.*
from Student X join Student Y
on Y.St_super=X.St_Id
--14
select Ins_Name,Salary,Dept_Id
from(select*, DENSE_RANK()over(partition by I.Dept_id order by I.Salary desc) as DN
from Instructor I) as new
where DN<=2 and Salary is not null
--15
select *
from (select *, ROW_NUMBER()over(partition by dept_id order  by NEWID() ) as RN
from Student) as new 
WHERE RN=1
---------------------------------------------------------------------------------

-- Part 2: AdventureWorks_DB Solutions

--1
SELECT SalesOrderID,ShipDate
FROM SALES.SalesOrderHeader
WHERE OrderDate BETWEEN  '2002-07-28'  AND '2014-07-28'
--2
SELECT ProductID,Name,StandardCost
FROM Production.Product
WHERE StandardCost<110.00
--3
SELECT ProductID,Name
FROM Production.Product
WHERE Weight IS NULL
--4
SELECT ProductID,Name,Color
FROM Production.Product
WHERE Color IN ('Black','Red','Silver')
--5
SELECT ProductID,Name
FROM Production.Product
WHERE Name like 'B%'
--6
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

SELECT ProductDescriptionID,Description
FROM Production.ProductDescription
WHERE Description LIKE '%[_]%'

--7
SELECT OrderDate,SUM(TotalDue) AS Total_Due 
FROM SALES.SalesOrderHeader
WHERE OrderDate BETWEEN '2001-07-01' AND '2014-07-31'
GROUP BY  OrderDate
ORDER BY OrderDate

--8
 SELECT DISTINCT HIREDATE FROM HumanResources.Employee

--9
select AVG(distinct ListPrice) 
from Production.Product

--10
select CONCAT('The ',Name,' is only! ',convert(varchar(15),ListPrice)) as [Price of Products]
from Production.Product
where ListPrice between 100 and 120
order by ListPrice

--11
insert into dbo.store_Archive
select rowguid ,Name, SalesPersonID, Demographics from Sales.Store

--12
select format(GETDATE(),'yyyy dddd MMMM')
union
select format(GETDATE(),'yyyy MMM ddd')
union
select format(GETDATE(),'yyyy MM dd')


-- Implementing and Developing SQL server objects

-- [ ASS _ CH-1 ]

-- Part 1:

use SD_NEW

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

