CREATE TABLE CSVTable( 
Name NVARCHAR(MAX), 
Email NVARCHAR(MAX), 
Area NVARCHAR(MAX) 
) 

BULK INSERT CSVTable
FROM 'D:\csv.txt'
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
SELECT * FROM CSVTable
----------------------------------------
use tianchi;
create table dbo.mars_tianchi_user_actions(
user_id varchar(35) not null,
song_id varchar(35) not null,
gmt_create varchar(20) not null,
action_type int not null,
ds varchar(10) not null
)

bulk insert dbo.mars_tianchi_user_actions
from 'E:\github\tianchi\data\mars_tianchi_user_actions.csv'
with(
	fieldterminator = ',',
	rowterminator = '\n'
)
