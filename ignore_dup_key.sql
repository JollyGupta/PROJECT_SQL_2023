/*A UNIQUE constraint or a UNIQUE index cannot be created on an existing table, if the table contains duplicate values in the key columns. Obviously, to solve this,remove the key columns from the index definition or delete or update the duplicate values.

3. By default, duplicate values are not allowed on key columns, when you have a unique index or constraint. For, example, if I try to insert 10 rows, out of which 5 rows contain duplicates, then all the 10 rows are rejected. However, if I want only the 5 duplicate rows to be rejected and accept the non-duplicate 5 rows, then I can use IGNORE_DUP_KEY option. An example of using IGNORE_DUP_KEY option is shown below.*/

--The IGNORE_DUP_KEY index option can be specified for both clustered and nonclustered unique indexes. Using it on a clustered index can result in much poorer performance than for a nonclustered unique index*/

drop table if exists tblEmployee15;
CREATE TABLE tblEmployee15
(
 [Id] int Primary Key,
 [FirstName] nvarchar(50),
 [LastName] nvarchar(50),
 [Salary] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)

Insert into tblEmployee15 Values(1,'Mike', 'Sandoz',4500,'Male','New York')
Insert into tblEmployee15 Values(2,'John', 'Menco1',2500,'Female','London')
Insert into tblEmployee15 Values(3,'John', 'Menco1',2500,'Female','London1')
Insert into tblEmployee15 Values(4,'John', 'Menco3',4500,'Female','London2')
Insert into tblEmployee15 Values(5,'John', 'Menco4',5500,'Male','London3')

Select * from tblEmployee15

EXECUTE SP_HELPCONSTRAINT tblEmployee15
EXECUTE SP_HELPindex tblEmployee15

CREATE UNIQUE INDEX IX_tblEmployee_City
ON tblEmployee15(City)

WITH IGNORE_DUP_KEY -- not able to use this ????????????????
Select * from tblEmployee15

--Advantages and disadvantages of indexes