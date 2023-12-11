
--Offset fetch next in SQL Server 2012
/**One of the common tasks for a SQL developer is to come up with a stored procedure that can return a page of results from the result set**/

--SQL Script to create tblProducts table

Create table tblProducts
(
    Id int primary key identity,
    Name nvarchar(25),
    [Description] nvarchar(50),
    Price int
)
Go

--SQL Script to populate tblProducts table with 100 rows

Declare @Start int
Set @Start = 1

Declare @Name varchar(25)
Declare @Description varchar(50)

While(@Start <= 100)
Begin
    Set @Name = 'Product - ' + LTRIM(@Start)
    Set @Description = 'Product Description - ' + LTRIM(@Start)
    Insert into tblProducts values (@Name, @Description, @Start * 10)
    Set @Start = @Start + 1
End

/* OFFSET FETCH Clause, Returns a page of results from the result set,ORDER BY clause is required 
SELECT * FROM Table_Name
ORDER BY Column_List
OFFSET Rows_To_Skip ROWS
FETCH NEXT Rows_To_Fetch ROWS ONLY

The following SQL query 1. Sorts the table data by Id column 2. Skips the first 10 rows and
3. Fetches the next 10 rows*/

SELECT * FROM tblProducts
ORDER BY Id
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY

--From the front-end application, we would typically send the PAGE NUMBER and the PAGE SIZE to get a page of rows. The following stored procedure accepts PAGE NUMBER and the PAGE SIZE as parameters and returns the correct set of rows.

CREATE PROCEDURE spGetRowsByPageNumberAndSize
@PageNumber INT,
@PageSize INT
AS
BEGIN
    SELECT * FROM tblProducts
    ORDER BY Id
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY
END

--With PageNumber = 3 and PageSize = 10, the stored procedure returns the correct set of rows

EXECUTE spGetRowsByPageNumberAndSize 3, 10
EXEC spGetRowsByPageNumberAndSize 3, 10
spGetRowsByPageNumberAndSize 3, 10

ALTER PROCEDURE spGetRowsByPageNumberAndSize
@PageNumber INT,
@PageSize INT
AS
BEGIN
    SELECT * FROM tblProducts
    ORDER BY Id
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY
END

EXECUTE spGetRowsByPageNumberAndSize 10, 10

--Drop spGetRowsByPageNumberAndSize

--sql server object dependencies The following SQL Script creates 2 tables, 2 stored procedures and a view

drop table if exists Departments;
Create table Departments
(
    Id int primary key identity,
    FName nvarchar(50)
)
Go

drop table if exists EmployeesSP;
Create table EmployeesSP
(
    Id int primary key identity,
    FName nvarchar(50),
    Gender nvarchar(10),
    DeptId int foreign key references Departments(Id)
)
Go

Create procedure sp5_GetEmployees
as
Begin
    Select * from EmployeesSP
End
Go

Create procedure sp5_GetEmployeesandDepartments
as
Begin
    Select EmployeesSP.FName as EmployeeNameSP,
                   Departments.FName as DepartmentName
    from EmployeesSP
    join Departments
    on EmployeesSP.DeptId = Departments.Id
End
Go

Create view VwDepartments
as
Select * from Departments
Go
/*To find the dependencies on the Employees table, right click on it and select View Dependencies from the context menu
Identifying object dependencies is important especially when you intend to modify or delete an object upon which other objects depend. Otherwise you may risk breaking the functionality.

For example, there are 2 stored procedures (sp_GetEmployees and sp_GetEmployeesandDepartments) that depend on the Employees table. If we are not aware of these dependencies and if we delete the Employees table, both stored procedures will fail with the following error.

Msg 208, Level 16, State 1, Procedure sp_GetEmployees, Line 4
Invalid object name 'Employees'.*/


--sys dm sql referencing entities in SQL Server
--Dynamic SQL is a SQL built from strings at runtime.

drop table if exists T7Employees;
Create table T7Employees
(
     ID int primary key identity,
     FirstName nvarchar(50),
     LastName nvarchar(50),
     Gender nvarchar(50),
     Salary int
)
Go

Insert into T7Employees values ('Mark', 'Hastings', 'Male', 60000)
Insert into T7Employees values ('Steve', 'Pound', 'Male', 45000)
Insert into T7Employees values ('Ben', 'Hoskins', 'Male', 70000)
Insert into T7Employees values ('Philip', 'Hastings', 'Male', 45000)
Insert into T7Employees values ('Mary', 'Lambeth', 'Female', 30000)
Insert into T7Employees values ('Valarie', 'Vikings', 'Female', 35000)
Insert into T7Employees values ('John', 'Stanmore', 'Male', 80000)
Go

Create Procedure spSearchEmployees
@FirstName nvarchar(100),
@LastName nvarchar(100),
@Gender nvarchar(50),
@Salary int

As
Begin

     Select * from T7Employees where
     (FirstName = @FirstName OR @FirstName IS NULL) AND
     (LastName  = @LastName  OR @LastName  IS NULL) AND
     (Gender      = @Gender    OR @Gender    IS NULL) AND
     (Salary      = @Salary    OR @Salary    IS NULL)
End
Go

/* The stored procedure in this case is not very complicated as we have only 4 search filters. What if there are 20 or more such filters. This stored procedure can get complex. To make things worse what if we want to specify conditions like AND, OR etc between these search filters. The stored procedure can get extremely large, complicated and difficult to maintain. One way to reduce the complexity is by using dynamic SQL as show below. Depending on for which search filters the user has provided the values on the "Search Page", we build the WHERE clause dynamically at runtime, which can reduce complexity. */

/*dynamic sql is bad both in-terms of security and performance. This is true if the dynamic sql is not properly implemented. From a security standpoint, it may open doors for SQL injection attack and from a performance standpoint, the cached query plans may not be reused. If properly implemented, we will not have these problems with dynamic sql. In our upcoming videos, we will discuss good and bad dynamic sql implementations.*/

/*For now let's implement a simple example that makes use of dynamic sql. In the example below we are assuming the user has supplied values only for FirstName and LastName search fields. To execute the dynamicl sql we are using system stored procedure sp_executesql. */

/*sp_executesql takes two pre-defined parameters and any number of user-defined parameters.

@statement - The is the first parameter which is mandatory, and contains the SQL statements to execute

@params - This is the second parameter and is optional. This is used to declare parameters specified in @statement

The rest of the parameters are the parameters that you declared in @params, and you pass them as you pass parameters to a stored procedure */

Declare @sql nvarchar(1000)
Declare @params nvarchar(1000)

Set @sql = 'Select * from T7Employees where FirstName=@FirstName and LastName=@LastName'

Set @params = '@FirstName nvarchar(100), @LastName nvarchar(100)'

Execute sp_executesql @sql, @params, @FirstName='Ben',@LastName='Hoskins'

--Dynamic SQL in Stored Procedure
--This stored procedure does not have any dynamic sql in it. It is all static sql and is immune to sql injection.

Create Procedure spSearchEmployees3
@FirstName nvarchar(100) = NULL,
@LastName nvarchar(100) = NULL,
@Gender nvarchar(50) = NULL,
@Salary int = NULL
As
Begin

 Select * from T7Employees where
 (FirstName = @FirstName OR @FirstName IS NULL) AND
 (LastName  = @LastName  OR @LastName  IS NULL) AND
 (Gender    = @Gender    OR @Gender    IS NULL) AND
 (Salary    = @Salary    OR @Salary    IS NULL)
End
Go

--Whether you are creating your dynamic sql queries in a client application like ASP.NET web application or in a stored procedure, you should never ever concatenate user input values. Instead you should be using parameters.

--Notice in the following example, we are creating dynamic sql queries by concatenating parameter values, instead of using parameterized queries. This stored procedure is prone to SQL injection. Let's prove this by creating a "Search Page" that calls this procedure.
DROP PROCEDURE spSearchEmployeesBadDynamicSQL
Create Procedure spSearchEmployeesBadDynamicSQL
@FirstName nvarchar(100) = NULL,
@LastName nvarchar(100) = NULL,
@Gender nvarchar(50) = NULL,
@Salary int = NULL
As
Begin

 Declare @sql nvarchar(max)

 Set @sql = 'Select * from T7Employees where 1 = 1'
  
 if(@FirstName is not null)
  Set @sql = @sql + ' and FirstName=''' + @FirstName + ''''
 if(@LastName is not null)
  Set @sql = @sql + ' and LastName=''' + @LastName + ''''
 if(@Gender is not null)
  Set @sql = @sql + ' and Gender=''' + @Gender + ''''
 if(@Salary is not null)
  Set @sql = @sql + ' and Salary=''' + @Salary + ''''

 Execute sp_executesql @sql
End
Go

--In the following stored procedure we have implemented dynamic sql by using parameters, so this is not prone to sql injecttion. This is an example for good dynamic sql implementation.

Create Procedure spSearchEmployeesGoodDynamicSQL
@FirstName nvarchar(100) = NULL,
@LastName nvarchar(100) = NULL,
@Gender nvarchar(50) = NULL,
@Salary int = NULL
As
Begin

     Declare @sql nvarchar(max)
     Declare @sqlParams nvarchar(max)

     Set @sql = 'Select * from Employees where 1 = 1'
         
     if(@FirstName is not null)
          Set @sql = @sql + ' and FirstName=@FN'
     if(@LastName is not null)
          Set @sql = @sql + ' and LastName=@LN'
     if(@Gender is not null)
          Set @sql = @sql + ' and Gender=@Gen'
     if(@Salary is not null)
          Set @sql = @sql + ' and Salary=@Sal'

     Execute sp_executesql @sql,
     N'@FN nvarchar(50), @LN nvarchar(50), @Gen nvarchar(50), @sal int',
     @FN=@FirstName, @LN=@LastName, @Gen=@Gender, @Sal=@Salary
End
Go

--https://www.geeksforgeeks.org/dynamic-sql/

--Dynamic SQL is a programming technique that could be used to write SQL queries during runtime. Dynamic SQL could be used to create general and flexible SQL queries.

--Syntax for dynamic SQL is to make it string as below :

'SELECT statement';
--To run a dynamic SQL statement, run the stored procedure sp_executesql as shown below :
--EXEC sp_executesql N'SELECT statement';

--Declare two variables, @var1 for holding the name of the table and @var 2 for holding the dynamic SQL :
DECLARE 
@var1 NVARCHAR(MAX), 
@var2 NVARCHAR(MAX);

--Set the value of the @var1 variable to table_name :
SET @var1 = N'table_name';

--Create the dynamic SQL by adding the SELECT statement to the table name parameter :
SET @var2= N'SELECT * FROM ' + @var1;

--Run the sp_executesql stored procedure by using the @var2 parameter :
EXEC sp_executesql @var2;

DECLARE 
@tab NVARCHAR(128), 
@st NVARCHAR(MAX);
SET @tab = N'geektable';
SET @st = N'SELECT * 
FROM ' + @tab;
EXEC sp_executesql @st;

--https://www.youtube.com/watch?v=Kn2TratOqz4*/

drop table if exists EmpAccnt;
Create table EmpAccnt
(
     EmpID int ,
     EmpName nvarchar(50),
     Dept nvarchar(50),
     JoinYear date,
     Salary int
)
Go
drop table if exists EmpHr;
Create table EmpHr
(
     EmpID int ,
     EmpName nvarchar(50),
     Dept nvarchar(50),
     JoinYear date,
     Salary int
)

drop table if exists EmpSales;
Create table EmpSales
(
     EmpID int ,
     EmpName nvarchar(50),
     Dept nvarchar(50),
     JoinYear date,
     Salary int
)
--By default, when you insert a new row into a table with an identity column, SQL Server generates a new, unique value for the identity column automatically. However, if you need to insert a specific value into the identity column, you must use the IDENTITY_INSERT option.

SET IDENTITY_INSERT EmpAccnt ON
INSERT INTO EmpAccnt  (EmpID ,EmpName ,Dept ,JoinYear,Salary )
values
(1, 'A', 'Accnt','2001-01-11', 60000),(2, 'P', 'Accnt','2001-01-11', 45000),(3, 'H', 'Accnt','2001-01-11', 70000),(4, 'H', 'Accnt','2001-01-11', 45000);
SET IDENTITY_INSERT EmpAccnt OFF




--IDENTITY_INSERT
--SET IDENTITY_INSERT EmpAccnt OFF

Insert into EmpHr values (5, 'L', 'Hr','2001-01-11', 30000)
Insert into EmpHr values (6, 'V', 'Hr','2001-01-11', 35000)
Insert into EmpHr values (7,'S', 'Hr', '2001-01-11',80000)
Insert into EmpHr values (8, 'S', 'Hr','2001-01-11', 80000)

Insert into Empsales values (9, 'L', 'sales','2001-01-11', 30000)
Insert into Empsales values (10, 'V', 'sales','2001-01-11', 35000)
Insert into Empsales values (11, 'S', 'sales','2001-01-11', 80000)
Insert into Empsales values (12, 'S', 'sales','2001-01-11', 80000)

Declare @table varchar (100)
Declare @collist varchar (100)
Declare @Query varchar (4000)

set @table ='empAcct'
set @collis ='EmpID, EmpName,Dept,JoinYear,Salary';
set @table =CONCAT ('select',@collist,from @table),
print @Query
Exec @Query



     
     


