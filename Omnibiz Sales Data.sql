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
alter table [Dummy Sales Data] add Discount money;					-----Add a new column as Discount
alter table [Dummy Sales Data] add [Row Number] int identity(1,1);  ------Add a new column as serial number for rows
-------Copy all the rows in TotalDiscount column to Discount column
update [Dummy Sales Data]											
set TotalDiscount = discount;

----Remove TotalDiscount Column from the dataset
alter table [Dummy Sales Data] drop column totaldiscount;

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

update [Dummy Sales Data]			-------This is not relevant
set TotalDiscount = 0
where TotalDiscount = NULL;

update [Dummy Sales Data]			-------This is not relevant
set Discount = 0
where Discount is null;

/*begin transaction					-------This is not relevant
update [Dummy Sales Data]
set TotalDiscount = 0
where TotalDiscount = NULL
commit;*/

---View the dataset--------------------------------------------------------------------------------------------------------------
select * from [dbo].[Dummy Sales Data];
----------------------------------------------------------------------------------------------------------------------------------

----Rough work------------------------------------------------------------------------------------------------
select A.customerid, min(datepart(MONTH,A.OrderPlacedDate)) as [First Customers], format(A.OrderPlacedDate,'hh:mm'), datepart(ISO_WEEK,A.OrderPlacedDate)
from [Dummy Sales Data] as A
where customerid is not null
group by A.customerid, format(A.OrderPlacedDate,'hh:mm'), datepart(ISO_WEEK,A.OrderPlacedDate)
order by A.customerid asc, datepart(ISO_WEEK,A.OrderPlacedDate) asc;
-----------------------------------------------------------------------------------------------------------------

---Retention Analysis------------------------------------------------------------------------------------------
select	case 
			when datename(MONTH,[This Month].OrderPlacedDate) = 'January' then 1
			when datename(MONTH,[This Month].OrderPlacedDate) = 'February' then 2
			when datename(MONTH,[This Month].OrderPlacedDate) = 'March' then 3
			when datename(MONTH,[This Month].OrderPlacedDate) = 'April' then 4
			when datename(MONTH,[This Month].OrderPlacedDate) = 'May' then 5
			when datename(MONTH,[This Month].OrderPlacedDate) = 'June' then 6
			when datename(MONTH,[This Month].OrderPlacedDate) = 'July' then 7
			when datename(MONTH,[This Month].OrderPlacedDate) = 'August' then 8
			when datename(MONTH,[This Month].OrderPlacedDate) = 'September' then 9
			when datename(MONTH,[This Month].OrderPlacedDate) = 'October' then 10
			when datename(MONTH,[This Month].OrderPlacedDate) = 'November' then 11
			else 12
			end as [Month Sort],
			datename(MONTH,[This Month].OrderPlacedDate) as [Month Name],
	   year([This Month].OrderPlacedDate) as Year,
	   format(count(distinct([Last Month].customerid)),'###,###') as [Last Month # Customer]
from [Dummy Sales Data] as [This Month]
left join [Dummy Sales Data] as [Last Month]
on [This Month].customerid = [Last Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [This Month].customerid is not null
group by year([This Month].OrderPlacedDate), datename(MONTH,[This Month].OrderPlacedDate), month([This Month].OrderPlacedDate)
order by year([This Month].OrderPlacedDate) asc, [Month Sort] asc, datename(MONTH,[This Month].OrderPlacedDate) asc;
--------------------------------------------------------------------------------------------------------------

---Retention Analysis 2------------------------------------------------------------------------------------------
select month([This Month].OrderPlacedDate) as [Month No.],
	   format(count(distinct([Last Month].customerid)),'###,###') as [Last Month # Customer]
from [Dummy Sales Data] as [This Month]
left join [Dummy Sales Data] as [Last Month]
on [This Month].customerid = [Last Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [This Month].customerid is not null
group by month([This Month].OrderPlacedDate);
--------------------------------------------------------------------------------------------------------------

---- Cohort Analysis-----------------------------------------------------------------------------------------
select [Last Month].customerid, 
	   [Last Month].MasterOrderID, 
	   [Last Month].OrderPlacedDate,
	   format(coalesce(sum([Last Month].TotalPrice),0),'###,###') as [Previous Month Sales],
	   [This Month].customerid, 
	   [This Month].MasterOrderID, 
	   [This Month].OrderPlacedDate,
	   format(coalesce(sum([This Month].TotalPrice),0),'###,###') as [Next Month Sales]
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
-------------------------------------------------------------------------------------------------------------

---- Cohort Analysis on Customers that made purchases for two (2) months-------------------------------------------
select [Last Month].customerid, 
	   [Last Month].MasterOrderID, 
	   [Last Month].OrderPlacedDate,
	   format(coalesce(sum([Last Month].TotalPrice),0),'###,###') as [Previous Month Sales],
	   [This Month].customerid, 
	   [This Month].MasterOrderID, 
	   [This Month].OrderPlacedDate,
	   format(coalesce(sum([This Month].TotalPrice),0),'###,###') as [Next Month Sales]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=2
where [Last Month].customerid is not null
group by [Last Month].customerid, 
	     [Last Month].MasterOrderID, 
		 [Last Month].OrderPlacedDate, 
		 [This Month].customerid, 
		 [This Month].MasterOrderID, 
		 [This Month].OrderPlacedDate
order by [Last Month].customerid asc, [This Month].customerid asc;
------------------------------------------------------------------------------------------------------------------

---- Cohort Analysis for Customers that made purchases for all months (i.e. 3 months)----------------------------------------------------------
select [Last Month].customerid, 
	   [Last Month].MasterOrderID, 
	   [Last Month].OrderPlacedDate,
	   format(coalesce(sum([Last Month].TotalPrice),0),'###,###') as [Previous Month Sales],
	   [This Month].customerid, 
	   [This Month].MasterOrderID, 
	   [This Month].OrderPlacedDate,
	   format(coalesce(sum([This Month].TotalPrice),0),'###,###') as [Next Month Sales]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=3
where [Last Month].customerid is not null
group by [Last Month].customerid, 
	     [Last Month].MasterOrderID, 
		 [Last Month].OrderPlacedDate, 
		 [This Month].customerid, 
		 [This Month].MasterOrderID, 
		 [This Month].OrderPlacedDate
order by [Last Month].customerid asc, [This Month].customerid asc;
------------------------------------------------------------------------------------------------------------------------------------------------

---- Chun Analysis || Chun Customers (i.e. Customers that left the business)---------------------------------------------------------------------
select [Last Month].customerid, 
	   [Last Month].MasterOrderID, 
	   [Last Month].OrderPlacedDate,
	   format(coalesce(sum([Last Month].TotalPrice),0),'###,###') as [Previous Month Sales],
	   [This Month].customerid, 
	   [This Month].MasterOrderID, 
	   [This Month].OrderPlacedDate,
	   format(coalesce(sum([This Month].TotalPrice),0),'###,###') as [Next Month Sales]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [Last Month].customerid is not null
and [Last Month].OrderPlacedDate <> ''
and [This Month].OrderPlacedDate is null
group by [Last Month].customerid, 
	     [Last Month].MasterOrderID, 
		 [Last Month].OrderPlacedDate, 
		 [This Month].customerid, 
		 [This Month].MasterOrderID, 
		 [This Month].OrderPlacedDate
order by [Last Month].customerid asc, [This Month].customerid asc;
--------------------------------------------------------------------------------------------------------------------------------------------

---- Chun Analysis on count || How many Chun Customers (i.e. Customers that left the business)---------------------------------------------------------
select format(count(distinct([Last Month].customerid)),'###,###') as [# Customers left business]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [Last Month].customerid is not null
and [Last Month].OrderPlacedDate <> ''
and [This Month].OrderPlacedDate is null;
---------------------------------------------------------------------------------------------------------------------------------------------

---- Retention Analysis || Retained Customers (i.e. Customers that are still in the business)-------------------------------------
select format(count(distinct([Last Month].customerid)),'###,###') as [# Customers still in business]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate)=1
where [Last Month].customerid is not null
and [Last Month].OrderPlacedDate is not null
and [This Month].OrderPlacedDate is not null;
--------------------------------------------------------------------------------------------------------------------------------------------

---- Retention Analysis for 3 months || Retained Customers (i.e. Customers that made purchases all through the months (i.e. the entire 3 months))-------
select format(count(distinct([Last Month].customerid)),'###,###') as [# Customers that made purchases across the entire 3 months]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate) = 3
where [Last Month].customerid is not null
and [Last Month].OrderPlacedDate is not null
and [This Month].OrderPlacedDate is not null;
------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Retention Analysis for 2 months || Retained Customers (i.e. Customers that made purchases across 2 months)-----------------------------------------
select format(count(distinct([Last Month].customerid)),'###,###') as [# Customers that made purchases across 2 months]
from [Dummy Sales Data] as [Last Month]
left join [Dummy Sales Data] as [This Month]
on [Last Month].customerid = [This Month].customerid
and datediff(MONTH,[Last Month].OrderPlacedDate,[This Month].OrderPlacedDate) = 2
where [Last Month].customerid is not null
and [Last Month].OrderPlacedDate is not null
and [This Month].OrderPlacedDate is not null;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-----Total Customers-------------------------------------------------------------------------------------------------------------------------------------------
select format(coalesce(count(distinct(A.customerid)),0),'###,###') as [Total Customers]
from [Dummy Sales Data] as A
where customerid != '';
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-----Active Customers-------------------------------------------------------------------------------------------------------------------------------------------
select format(coalesce(count(distinct(A.customerid)),0),'###,###') as [# Active Customers]
from [Dummy Sales Data] as A
where customerid != ''
and OrderStatus in ('Awaiting Confirmation', 'Delivered', 'Delivery Rescheduled', 'Dispatched', 'Order Confirmed', 'Ready for dispatch', 'RTO');
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-----Inactive Customers-------------------------------------------------------------------------------------------------------------------------------------------
select 
	format(
	(
	(select  count(distinct(B.customerid))			------------Begin of subquery
		from [Dummy Sales Data] as B
		where B.customerid != '')					------------End of subquery
			-										------------Operator sign (i.e. Minus(-))
	  count(distinct(A.customerid))
	  ),
	  '###,###') as [Inactive Customers] 
from [Dummy Sales Data] as A
where customerid != ''
and OrderStatus in ('Awaiting Confirmation', 'Delivered', 'Delivery Rescheduled', 'Dispatched', 'Order Confirmed', 'Ready for dispatch', 'RTO');	  
---------------------------------------------------------------------------------------------------------------------------------------------------------------

------Lag & Lead: MoM Revenue & Next Month || Year Revenue---------------------------------------------------------------------------------------------------------------------------------
select case
			when datename(MONTH,DSD.OrderPlacedDate) = 'January' then 1
			when datename(MONTH,DSD.OrderPlacedDate) = 'February' then 2
			when datename(MONTH,DSD.OrderPlacedDate) = 'March' then 3
			when datename(MONTH,DSD.OrderPlacedDate) = 'April' then 4
			when datename(MONTH,DSD.OrderPlacedDate) = 'May' then 5
			when datename(MONTH,DSD.OrderPlacedDate) = 'June' then 6
			when datename(MONTH,DSD.OrderPlacedDate) = 'July' then 7
			when datename(MONTH,DSD.OrderPlacedDate) = 'August' then 8
			when datename(MONTH,DSD.OrderPlacedDate) = 'September' then 9
			when datename(MONTH,DSD.OrderPlacedDate) = 'October' then 10
			when datename(MONTH,DSD.OrderPlacedDate) = 'November' then 11
			else 12
			end as [Month Sort],
			datename(MONTH,DSD.OrderPlacedDate) as Month,
			datename(YEAR,DSD.OrderPlacedDate) as Year,
			format(sum(coalesce((DSD.TotalPrice - DSD.Discount),0)),'###,###') as Revenue,
			format(																															--------------------------------Lag section
			(sum(coalesce((DSD.TotalPrice - DSD.Discount),0)) - lag(sum(coalesce((DSD.TotalPrice - DSD.Discount),0))) over(order by datename(MONTH,DSD.OrderPlacedDate) asc)),
			'###,###') as [MoM Revenue],
			concat(round(coalesce(
			((sum(coalesce((DSD.TotalPrice - DSD.Discount),0)) - lag(sum(coalesce((DSD.TotalPrice - DSD.Discount),0))) over(order by datename(MONTH,DSD.OrderPlacedDate) asc))
							/																							-------------------------------------------Operator Sign (i.e. Divide)
			lag(sum(coalesce((DSD.TotalPrice - DSD.Discount),0))) over(order by datename(MONTH,DSD.OrderPlacedDate) asc)),
			0),2),'%') as [% MoM Revenue],
			lead(format(sum(coalesce((DSD.TotalPrice - DSD.Discount),0)),'###,###')) over(order by datename(MONTH,DSD.OrderPlacedDate) asc) as [Next Month Revenue]		------Lead section
from [Dummy Sales Data] as DSD
where DSD.customerid != ''
group by datename(YEAR,DSD.OrderPlacedDate), datename(MONTH,DSD.OrderPlacedDate)
order by datename(YEAR,DSD.OrderPlacedDate) asc, [Month Sort] asc, datename(MONTH,DSD.OrderPlacedDate) asc;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----Cancellation Rate-------------------------------------------------------------------------------------------------------------------------------------------------------------
select round(
	   (cast(
	   count(
	   case
			when DSD.OrderStatus = 'Cancelled' then 1 end) 
			as float)
			/
		count(*)),
		2) as [Cancellation Rate],
	   concat(
	   round(
	   (cast(
	   count(
	   case
			when DSD.OrderStatus = 'Cancelled' then 1 end) 
			as float)
			/
		count(*)) * 100,
		2),
		'%') as [% Cancellation Rate],
	   format(sum(coalesce((DSD.TotalPrice - DSD.Discount),0)),'###,###') as Revenue
from [Dummy Sales Data] as DSD
where DSD.customerid != '';
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Pivoted Analysis on OrderStatus-----------------------------------------------------------------------------------------------------------------------------
select * 
from
	(select *
	from [Dummy Sales Data] as [Source Table]
	where OrderPlacedDate is not null) as y
pivot(
	  count(customerid) 
	  for OrderStatus in ([Cancelled],[Delivered])
)as [Pivot Table];
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-----Crosscheck-----------------------------------------------------------------------------------------------
select * 
from [Dummy Sales Data]
where [Row Number] between 1 and 274;

select * from [Dummy Sales Data]
where OrderPlacedDate != '';
----------------------------------------------------------------------------------------------------
