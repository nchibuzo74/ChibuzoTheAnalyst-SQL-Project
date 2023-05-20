---Create database StoreP
create database StoreP;
go
use StoreP;
---Create Employeee table
create table Employeee (
						ID int primary key not null,
						[First Name] varchar(max) not null,
						[Last Name] varchar(max) not null,
						Salary money not null,
						City varchar(max) not null);

----Insert records into Employeee
go
begin
insert into Employeee(ID,[First Name],[Last Name],Salary,City) values(2,'Monu','Rathor',4789,'Agra'),
																	 (4,'Rahul','Saxena',5567,'London');
end;

---Create Store Procedures for Inserting, Updating and Deleting records into Employeee table
create procedure MasterInsertUpdateDelete (
										  @id int,
										  @first_name varchar(max),
										  @last_name varchar(max),
										  @salary money,
										  @city varchar(max),
										  @statement_type varchar(max) = '')
as
	begin
		if @statement_type = 'Insert'				-----Insert section
			begin
				insert into Employeee (ID,[First Name],[Last Name],Salary,City) values(@id,@first_name,@last_name,@salary,@city)
			end

		if @statement_type = 'Update'				----Update section
			begin
				update Employeee
				set [First Name] = @first_name,
					[Last Name] = @last_name,
					Salary = @salary,
					City = @city
				where ID = @id
			end

		if @statement_type = 'Delete'				---Delete section
			begin
				delete from Employeee
				where ID = @id
			end

		if @statement_type = 'Select'				---Retrieve section
			begin
				select * from Employeee
			end
end


---To insert || update || delete records in Employeee table goto "Programmability" - "Stored Procedures"
select * from Employeee;