-- sql serve exprss edition 

CREATE TRIGGER trgAfterInsert ON [dbo].[Game_Review]
FOR INSERT
AS

declare @gameid int;
declare @gamename varchar(100);
declare @gamescore decimal(10,2);
declare @altaction varchar(100);

select @gameid = i.Game_ID from inserted i;
select @gamename = i.Game_Name from inserted i;
select @gamescore = i.Game_Score from inserted i;

set @altaction = 'New game reviewed';

insert into Game_Review_Alt (Game_ID, Game_Name, Game_Score, Alt_Action, Alt_Timestamp) values (@gameid, @gamename, @gamescore, @altaction, getdate());
 PRINT 'After insert trigger fired';
 go
 
 insert into Game_Review values ('Dragon of origins',7.8); 