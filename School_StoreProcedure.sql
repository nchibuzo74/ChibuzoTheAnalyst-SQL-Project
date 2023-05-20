---Create database School
create database School;
go
use school;

---Create Class table
create table Class(Enrollment int identity(1,1) primary key not null,
					[Student Name] varchar(max) not null,
					[Email ID] varchar(max),
					State char(2) not null);

----Insert records into Class table
go
begin
insert into Class([Student Name],[Email ID],State) values ('Rishab P','rishab@gmail.com','WB'),
														  ('Mayank G','mayank@gmail.com','JH'),
														  ('Rajat A','rajat@gmail.com','UP');
end;

---Create table Science
create table Science([Enroll ID] int primary key not null,
					 [Student Name] varchar(max) not null,
					 Marks int not null,
					 foreign key ([Enroll ID]) references class(enrollment) on update cascade on delete cascade);

----Insert records into Science
go
begin
insert into Science([Enroll ID],[Student Name],Marks) values(1,'Rishab P',85),
															(3,'Rajat A', 87);
end;

----Create table Mathematics
create table Mathematics(ID int primary key not null,
						[Student Name] varchar(max) not null,
						Marks int not null,
						foreign key (ID) references class(enrollment) on update cascade on delete cascade);

----Insert records into Mathematics
go
begin
insert into Mathematics(ID,[Student Name],Marks) values(1,'Rishab P',90),
													   (2,'Mayank G',86);
end;

-----Create Store Procedure to insert || update || delete records in Class table
create procedure Class_Values (@enrollment int = null output,
							   @Student_Name varchar(max),
							   @Email_ID varchar(max),
							   @State char(2),
							   @Statement_Type varchar(max) = '')
as
	begin
		if @Statement_Type = 'Insert'														----Insert section
			begin
				insert into Class ([Student Name],[Email ID],State) values(@Student_Name,@Email_ID,@State)
				set @enrollment = scope_identity()
			end

		if @Statement_Type = 'Update'														-----Update section
			begin
				update Class
				set [Student Name] = @Student_Name,
				    [Email ID] = @Email_ID,
					State = @State
				where Enrollment = @enrollment
			end

		if @Statement_Type = 'Delete'
			begin
				delete from Class
				where Enrollment = @Enrollment
			end
end


-----Create Store Procedure to insert || update || delete records in Mathematics table
create procedure Maths_Value (@ID int,
							  @Student_Name varchar(max),
							  @Marks int,
							  @Statement_Type varchar(max) = '')
as
	begin
		if @Statement_Type = 'Insert'																----Insert section
			begin
				insert into Mathematics(ID,[Student Name],Marks) values(@ID,@Student_Name,@Marks)
			end

		if @Statement_Type = 'Update'															------Update section
			begin
				update Mathematics
				set [Student Name] = @Student_Name,
				    Marks = @Marks
				where ID = @ID
			end
	
	if @Statement_Type = 'delete'																-----Delete section
		begin
			delete from Mathematics
			where ID = @ID
		end
end


-----Create Store Procedure to insert || update || delete records in Science table
create procedure Science_values (@Enroll_ID int,
							     @Student_Name varchar(max),
								 @Marks int,
								 @Statement_Type varchar(max) = '')
as
	begin
		if @statement_type = 'Insert'																			---Insert section
			begin
				insert into Science([Enroll ID],[Student Name],Marks) values(@Enroll_ID,@Student_Name,@Marks)
			end

		if @Statement_Type = 'Update'																			---Update section
			begin
				update Science
					set	[Student Name] = @Student_Name,
						Marks = @Marks
				where [Enroll ID] = @Enroll_ID
			end

		if @Statement_Type = 'delete'																			-----Delete section
			begin
				delete from Science
				where [Enroll ID] = @Enroll_ID
			end
end


--Retrieve the infromations from the 3 tables 
select * from Class;
select * from Mathematics;
select  * from Science;

---undo transaction processes on delete using rollback
begin transaction
delete from Class
where [Student Name] = 'Rishab P';
rollback;

----update transaction processes using commit
begin transaction
update Class
set [Student Name] = 'Rishab A'
where [Student Name] = 'Rishab P'
commit;

----Create view as Merge_Record
create view Merge_Record
as
select C.[Student Name],C.[Email ID],C.State, M.Marks as [Maths Score] from Class as C
inner join Mathematics as M
on C.Enrollment = M.ID;

select * from Merge_Record;