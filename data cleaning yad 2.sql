--Data Cleaning After Web Scraping
select *
from housing

-- Drop columns without information
alter table housing
drop column Title, column8

--drop nulls 
delete from housing
where info is null


-- Altering the first column
-- cleaning the data
select info, PATINDEX('%[0-9]%',Info), PATINDEX('%[à-ú]%',Info) from housing
select info,
	   case 
			when PATINDEX('%[0-9]%',Info)>0 then substring(info, PATINDEX('%[à-ú]%',Info), len(info)-PATINDEX('%[0-9]%',Info))
			else substring(info, PATINDEX('%[à-ú]%',Info), len(info)-PATINDEX('%[à-ú]%',Info))
	   end	
from housing

update housing
set Info=  case 
			when PATINDEX('%[0-9]%',Info)>0 then substring(info, PATINDEX('%[à-ú]%',Info), len(info)-PATINDEX('%[0-9]%',Info))
			else substring(info, PATINDEX('%[à-ú]%',Info), len(info)-PATINDEX('%[à-ú]%',Info))
		   end

-- Renaming the column
EXEC sp_rename 'housing.Info', 'FullAddress', 'COLUMN'


-- Altering the second column
--Renaming the column
EXEC sp_rename 'housing.Price', 'Type', 'COLUMN'

--cleaning the data
update housing
set Type= substring(Type,2,len(Type)-1) from housing

--Renaming the third column
EXEC sp_rename 'housing.column4', 'Area', 'COLUMN' 

--Altering the fourth column
--Renaming the column
EXEC sp_rename 'housing.column5', 'City', 'COLUMN' 

--Cleaning the data
update housing
set City= substring(City,1, len(City)-1)


-- Altering the price column
--Cleaning column6
update housing
set column6 =  case
				   when PATINDEX('%[0-9]%',column6)>0  then substring(column6, PATINDEX('%[0-9]%',column6), PATINDEX('%[0-9]%',column6))
				   else substring(column6, PATINDEX('%[à-ú]%',column6), len(column6)-PATINDEX('%[à-ú]%',column6))
			   end

update housing
set column6 = substring(column6, 1, len(column6)-PATINDEX('%ø%',column6)) from housing
where column6 like '%ì%'

--Cleaning column7
update housing
set column7= substring(column7,1,3)

--merging the two columns
ALTER TABLE housing
ADD Price varchar(20)

UPDATE housing 
SET Price = CONCAT(column6,',', column7)

alter table housing
drop column column6, column7

update housing
set Price= substring(Price,1, len(Price)-3)
where Price like '%ì%'