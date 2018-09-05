--create first table
CREATE TABLE Employee_Test
(
Emp_ID INT Identity,
Emp_name Varchar(100),
Emp_Sal Decimal (10,2)
)

INSERT INTO Employee_Test VALUES ('Anees',1000);
INSERT INTO Employee_Test VALUES ('Rick',1200);
INSERT INTO Employee_Test VALUES ('John',1100);
INSERT INTO Employee_Test VALUES ('Stephen',1300);
INSERT INTO Employee_Test VALUES ('Maria',1400);

-- create the audit table

CREATE TABLE Employee_Test_Audit
(
Emp_ID int,
Emp_name varchar(100),
Emp_Sal decimal (10,2),
Audit_Action varchar(100),
Audit_Timestamp datetime
)

-- Insert Trigger

CREATE TRIGGER trgAfterInsert ON [dbo].[Employee_Test] 
FOR INSERT
AS
	declare @empid int;
	declare @empname varchar(100);
	declare @empsal decimal(10,2);
	declare @audit_action varchar(100);

	select @empid=i.Emp_ID from inserted i;	
	select @empname=i.Emp_Name from inserted i;	
	select @empsal=i.Emp_Sal from inserted i;	
	set @audit_action='Inserted Record -- After Insert Trigger.';

	insert into Employee_Test_Audit
           (Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp) 
	values(@empid,@empname,@empsal,@audit_action,getdate());

	PRINT 'AFTER INSERT trigger fired.'
GO

-- insert the data
insert into Employee_Test values('Chris',1500)

-- data is displayed like
-- 6   Chris  1500.00   Inserted Record -- After Insert Trigger.	2008-04-26 12:00:55.700


-- update trigger

CREATE TRIGGER trgAfterUpdate ON [dbo].[Employee_Test] 
FOR UPDATE
AS
	declare @empid int;
	declare @empname varchar(100);
	declare @empsal decimal(10,2);
	declare @audit_action varchar(100);

	select @empid=i.Emp_ID from inserted i;	
	select @empname=i.Emp_Name from inserted i;	
	select @empsal=i.Emp_Sal from inserted i;	
	
	if update(Emp_Name)
		set @audit_action='Updated Record -- After Update Trigger.';
	if update(Emp_Sal)
		set @audit_action='Updated Record -- After Update Trigger.';

	insert into Employee_Test_Audit(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp) 
	values(@empid,@empname,@empsal,@audit_action,getdate());

	PRINT 'AFTER UPDATE Trigger fired.'
GO

-- update the data

update Employee_Test set Emp_Sal=1550 where Emp_ID=6

-- data is displayed like this

-- 6  Chris  1550.00  Updated Record -- After Update Trigger.	  2008-04-26 12:38:11.843

-- after delete trigger

CREATE TRIGGER trgAfterDelete ON [dbo].[Employee_Test] 
AFTER DELETE
AS
	declare @empid int;
	declare @empname varchar(100);
	declare @empsal decimal(10,2);
	declare @audit_action varchar(100);

	select @empid=d.Emp_ID from deleted d;	
	select @empname=d.Emp_Name from deleted d;	
	select @empsal=d.Emp_Sal from deleted d;	
	set @audit_action='Deleted -- After Delete Trigger.';

	insert into Employee_Test_Audit
(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp) 
	values(@empid,@empname,@empsal,@audit_action,getdate());

	PRINT 'AFTER DELETE TRIGGER fired.'
GO


-- data is displayed like this
-- 6  Chris   1550.00  Deleted -- After Delete Trigger.  2008-04-26 12:52:13.867

-- we can use this one ]

ALTER TABLE Employee_Test {ENABLE|DISBALE} TRIGGER ALL

-- or this one

ALTER TABLE Employee_Test DISABLE TRIGGER trgAfterDelete

-- instead of triggers

CREATE TRIGGER trgInsteadOfDelete ON [dbo].[Employee_Test] 
INSTEAD OF DELETE
AS
	declare @emp_id int;
	declare @emp_name varchar(100);
	declare @emp_sal int;
	
	select @emp_id=d.Emp_ID from deleted d;
	select @emp_name=d.Emp_Name from deleted d;
	select @emp_sal=d.Emp_Sal from deleted d;

	BEGIN
		if(@emp_sal>1200)
		begin
			RAISERROR('Cannot delete where salary > 1200',16,1);
			ROLLBACK;
		end
		else
		begin
			delete from Employee_Test where Emp_ID=@emp_id;
			COMMIT;
			insert into Employee_Test_Audit(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,
                                                        Audit_Timestamp)
			values(@emp_id,@emp_name,@emp_sal,
                               'Deleted -- Instead Of Delete Trigger.',getdate());
			PRINT 'Record Deleted -- Instead Of Delete Trigger.'
		end
	END
GO

-- delete command

delete from Employee_Test where Emp_ID=4

-- error message will be displayed like this

-- Server: Msg 50000, Level 16, State 1, Procedure trgInsteadOfDelete, Line 15 Cannot delete where salary > 1200