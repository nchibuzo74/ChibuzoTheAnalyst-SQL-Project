----Create a database
create database Omnibiz;
go
use Omnibiz;

---Identify the datatypes of the imported table
EXEC sp_help [Dummy Sales Data];

---Change the datatypes of the columns
alter table [Dummy Sales Data] alter column MasterOrderID bigint;    --- from float(decimal) to bigint(integar)
alter table [Dummy Sales Data] alter column HubNumberID bigint;		 --- from float(decimal) to bigint(integar)
alter table [Dummy Sales Data] alter column customerid bigint;		 --- from float(decimal) to bigint(integar)
alter table [Dummy Sales Data] alter column TotalPrice money;		 --- from float(decimal) to bigint(integar)
alter table [Dummy Sales Data] alter column PromoDiscount bigint;		 --- from float(decimal) to bigint(integar)

----Remove other unnecessary columns from the dataset
alter table [Dummy Sales Data] drop column F22;
alter table [Dummy Sales Data] drop column F23;
alter table [Dummy Sales Data] drop column F24;
alter table [Dummy Sales Data] drop column F25;
alter table [Dummy Sales Data] drop column F26;
alter table [Dummy Sales Data] drop column F27;
alter table [Dummy Sales Data] drop column F28;
alter table [Dummy Sales Data] drop column F29;

----Replace customerid as 0 with 1000000 because the ID's are in 7 digit places
update [Dummy Sales Data]
set customerid = 1000000
where customerid = 0;

---Replace NULL with 0 in Total Price and Total Discount column
update [Dummy Sales Data]
set TotalPrice = 0
where TotalPrice = NULL;

update [Dummy Sales Data]
set TotalDiscount = 0
where TotalDiscount = NULL;


---View the dataset
select * from [dbo].[Dummy Sales Data];

----
select A.customerid, min(datepart(MONTH,A.OrderPlacedDate)) as [First Customers]
from [Dummy Sales Data] as A
where customerid is not null
group by A.customerid
order by A.customerid asc;


---Retention Analysis
select month([This Month].OrderPlacedDate) as [Month No.],
	   format(count(distinct([Last Month].customerid)),'###,###') as [Last Month # Customer]
from [Dummy Sales Data] as [This Month]
left join [Dummy Sales Data] as [Last Month]
on [This Month].customerid = [Last Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [This Month].customerid is not null
group by month([This Month].OrderPlacedDate);

---- Cohort Analysis
select [Last Month].customerid, 
	   [Last Month].MasterOrderID, 
	   [Last Month].OrderPlacedDate,
	   format(coalesce(sum([Last Month].TotalPrice),0),'###,###') as [Previous Month Revenue],
	   [This Month].customerid, 
	   [This Month].MasterOrderID, 
	   [This Month].OrderPlacedDate,
	   format(coalesce(sum([This Month].TotalPrice),0),'###,###') as [Next Month Revenue]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [Last Month].customerid is not null
group by [Last Month].customerid, 
	     [Last Month].MasterOrderID, 
		 [Last Month].OrderPlacedDate, 
		 [This Month].customerid, 
		 [This Month].MasterOrderID, 
		 [This Month].OrderPlacedDate
order by [Last Month].customerid asc, [This Month].customerid asc;

---- Pivoted Analysis on OrderStatus
select * from
(select *
from [Dummy Sales Data] as [Source Table]
where OrderPlacedDate is not null) as y
pivot(
count(customerid) for OrderStatus in ([Cancelled],[Delivered])
)as [Pivot Table];