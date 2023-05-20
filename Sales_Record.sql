----Separate the content in the order date column to two different columns as Order Date and Time
----The initial dataset was in CSV format
----Change the file format to Excel Binary workbook or Excel workbook
----Remove outliers and abnormalities from the dataset (i.e. remove blank rows and repition of column headers)
----Import the Excel Binary workbook or Excel workbook into SQL Server Management Studio

use Sales_Record;
select * from [dbo].[Sales_January_2019$];
select * from [dbo].[Sales_February_2019$];
select * from [dbo].[Sales_March_2019$];
select * from [dbo].[Sales_April_2019$];
select * from [dbo].[Sales_May_2019$];
select * from [dbo].[Sales_June_2019$];
select * from [dbo].[Sales_July_2019$];
select * from [dbo].[Sales_August_2019$];
select * from [dbo].[Sales_September_2019$];
select * from [dbo].[Sales_October_2019$];
select * from [dbo].[Sales_November_2019$];
select * from [dbo].[Sales_December_2019$];

----February: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_February_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 
																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_February_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_February_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_February_2019$ alter column [Order Date] date;
----Alter Time column
alter table Sales_February_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_February_2019$;

----January: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_January_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_January_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_January_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_January_2019$ alter column [Order Date] date;
----Alter Order Time column
alter table Sales_January_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_January_2019$;

----March: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_March_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_March_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_March_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_March_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_March_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_March_2019$;

----April: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_April_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_April_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_April_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_April_2019$ alter column [Order Date] date;
----Alter Order Time column
alter table Sales_April_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_April_2019$;

----May: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_May_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_May_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_May_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_May_2019$ alter column [Order Date] date;
----Alter Order Time column
alter table Sales_May_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_May_2019$;

----June: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_June_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_June_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_June_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_June_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_June_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_June_2019$;

----July: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_July_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_July_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_July_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_July_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_July_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_July_2019$;

----August: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_August_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_August_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_August_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_August_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_August_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_August_2019$;

----September: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_September_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_September_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_September_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_September_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_September_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_September_2019$;

----October: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_October_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_October_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_October_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_October_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_October_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_October_2019$;

----November: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_November_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_November_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_November_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_November_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_November_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_November_2019$;

----December: Set a postdefine datatype for the dataset
	---Alter Order ID column
alter table Sales_December_2019$ alter column [Order ID] bigint not null;    ----change float to bigint; don't set primary key constraint 																	      ---because the column contain duplicate ID based on trasanction purposes.
	----Alter Quantity Ordered column
alter table Sales_December_2019$ alter column [Quantity Ordered] int;        -----change float to int
	----Alter Price Each column
alter table Sales_December_2019$ alter column [Price Each] money;			------change float to money
	----Alter Order Date column
alter table Sales_December_2019$ alter column [Order Date] date;
	----Alter Order Time column
alter table Sales_December_2019$ alter column Time time;
---Identify the datatypes of the imported table
EXEC sp_help Sales_December_2019$;


----Create a view for the merge dataset
create view Sales_Data 
as 
(select * from [dbo].[Sales_January_2019$])
			union all
(select * from [dbo].[Sales_February_2019$])
			union all
(select * from [dbo].[Sales_March_2019$])
			union all
(select * from [dbo].[Sales_April_2019$])
			union all
(select * from [dbo].[Sales_May_2019$])
			union all
(select * from [dbo].[Sales_June_2019$])
			union all
(select * from [dbo].[Sales_July_2019$])
			union all
(select * from [dbo].[Sales_August_2019$])
			union all
(select * from [dbo].[Sales_September_2019$])
			union all
(select * from [dbo].[Sales_October_2019$])
			union all
(select * from [dbo].[Sales_November_2019$])
			union all
(select * from [dbo].[Sales_December_2019$]);


---Retrieve the records from the view table
select * from Sales_Data;

---Create Store Procedure for this dataset though it's not necessary
create procedure Sales_Date_Stored
as
(select * from [dbo].[Sales_January_2019$])
			union all
(select * from [dbo].[Sales_February_2019$])
			union all
(select * from [dbo].[Sales_March_2019$])
			union all
(select * from [dbo].[Sales_April_2019$])
			union all
(select * from [dbo].[Sales_May_2019$])
			union all
(select * from [dbo].[Sales_June_2019$])
			union all
(select * from [dbo].[Sales_July_2019$])
			union all
(select * from [dbo].[Sales_August_2019$])
			union all
(select * from [dbo].[Sales_September_2019$])
			union all
(select * from [dbo].[Sales_October_2019$])
			union all
(select * from [dbo].[Sales_November_2019$])
			union all
(select * from [dbo].[Sales_December_2019$]);

----To retrieve the data in store procedure
exec Sales_Date_Stored;

---Question 1: What is the total sales for the year?
select format(sum([quantity ordered] * [price each]),'C') as [Total Sales] from Sales_Data;

---Question 2: Sales by Month by Year
select month([order date]) as [Month No], format([order date],'MMMM') as [Month Name], YEAR([order date]) as [Year Sales], 
format(sum([quantity ordered] * [price each]),'C') as [Total Sales],
case 
	when format([order date],'MMMM') = 'January' then 1
	when format([order date],'MMMM') = 'February' then 2
	when format([order date],'MMMM') = 'March' then 3
	when format([order date],'MMMM') = 'April' then 4
	when format([order date],'MMMM') = 'May' then 5
	when format([order date],'MMMM') = 'June' then 6
	when format([order date],'MMMM') = 'July' then 7
	when format([order date],'MMMM') = 'August' then 8
	when format([order date],'MMMM') = 'September' then 9
	when format([order date],'MMMM') = 'October' then 10
	when format([order date],'MMMM') = 'November' then 11
	else 12 end as [Month Sorted]
from Sales_Data
group by month([order date]), format([order date],'MMMM'), YEAR([order date])
order by YEAR([order date]) asc, [Month Sorted] asc;

---Question 3: Sales by Year
select year([order date]) as [Yearly Sales], format(sum([quantity ordered] * [price each]),'C') as [Total Sales] 
from Sales_Data
group by year([order date])
order by year([order date]) asc;

---Question 4: How many customers do we have per month?
select case 
		when format([order date],'MMMM') = 'January' then 1
		when format([order date],'MMMM') = 'February' then 2
		when format([order date],'MMMM') = 'March' then 3
		when format([order date],'MMMM') = 'April' then 4
		when format([order date],'MMMM') = 'May' then 5
		when format([order date],'MMMM') = 'June' then 6
		when format([order date],'MMMM') = 'July' then 7
		when format([order date],'MMMM') = 'August' then 8
		when format([order date],'MMMM') = 'September' then 9
		when format([order date],'MMMM') = 'October' then 10
		when format([order date],'MMMM') = 'November' then 11
		else 12 end as [Month Sorted],
format([order date],'MMMM') as [Month Name], year([order date]) as Year, format(count([Order ID]),'###,###') as Customer
from Sales_Data
group by format([order date],'MMMM'), year([order date])
order by year([order date]) asc, [Month Sorted] asc;

---Question 5: How many customers do we have so far?
select format(count(distinct([Order ID])),'###,###') as Customer from Sales_Data;

----Question 6: How much sales was made so far with numbers of customers?
select case 
		when format([order date],'MMMM') = 'January' then 1
		when format([order date],'MMMM') = 'February' then 2
		when format([order date],'MMMM') = 'March' then 3
		when format([order date],'MMMM') = 'April' then 4
		when format([order date],'MMMM') = 'May' then 5
		when format([order date],'MMMM') = 'June' then 6
		when format([order date],'MMMM') = 'July' then 7
		when format([order date],'MMMM') = 'August' then 8
		when format([order date],'MMMM') = 'September' then 9
		when format([order date],'MMMM') = 'October' then 10
		when format([order date],'MMMM') = 'November' then 11
		else 12 end as [Month Sorted],
format([order date],'MMMM') as [Month Name], year([order date]) as Year,
format(sum([quantity ordered] * [price each]),'C') as [Total Sales], format(count([Order ID]),'###,###') as Customer 
from Sales_Data
group by format([order date],'MMMM'), year([order date])
order by year([order date]) asc, [Month Sorted] asc;

----Question 7: What are the monthly sales growth (MoM)
select case 
		when format([order date],'MMMM') = 'January' then 1
		when format([order date],'MMMM') = 'February' then 2
		when format([order date],'MMMM') = 'March' then 3
		when format([order date],'MMMM') = 'April' then 4
		when format([order date],'MMMM') = 'May' then 5
		when format([order date],'MMMM') = 'June' then 6
		when format([order date],'MMMM') = 'July' then 7
		when format([order date],'MMMM') = 'August' then 8
		when format([order date],'MMMM') = 'September' then 9
		when format([order date],'MMMM') = 'October' then 10
		when format([order date],'MMMM') = 'November' then 11
		else 12 end as [Month Sorted],
FORMAT(SD.[order date],'MMMM') as [Month Name], year(SD.[order date]) as Year, format(sum(SD.[quantity ordered] * SD.[price each]),'C') as [Total Sales],
	format(sum(SD.[quantity ordered] * SD.[price each]) 
		- 
	LAG(sum(SD.[quantity ordered] * SD.[price each])) over(order by SD.[order date] asc),'$###,###.##') as [Revenue Growth],
	CONCAT(round(COALESCE((sum(SD.[quantity ordered] * SD.[price each]) 
		- 
	LAG(sum(SD.[quantity ordered] * SD.[price each])) over(order by SD.[order date] asc))
		/ 
	LAG(sum(SD.[quantity ordered] * SD.[price each])) over(order by SD.[order date] asc) * 100,0),2),'%') as [Revenue Percentage Growth],
	LEAD(format(sum(SD.[quantity ordered] * SD.[price each]),'C')) over(order by SD.[order date] asc) as [Next Month Revenue]
from Sales_Data as SD
	group by SD.[order date], FORMAT(SD.[order date],'MMMM'), year(SD.[order date])
	order by year(SD.[order date]) asc, [Month Sorted] asc;

----Question 8: What are the current and previous month's sales by product?
	----Use the Lag and Lead function.
select SD.Product, format(SD.[order date],'yyyy-MM') as Month, format(sum(SD.[quantity ordered] * SD.[price each]),'C') as [Total Sales],			----With Product
	LAG(format(sum(SD.[quantity ordered] * SD.[price each]),'C')) over (partition by SD.Product order by format(SD.[order date],'yyyy-MM')) as PrevMonthSales,
	LEAD(format(sum(SD.[quantity ordered] * SD.[price each]),'C')) over (partition by SD.Product order by format(SD.[order date],'yyyy-MM')) as NextMonthSales
from Sales_Data as SD
	group by SD.Product, format(SD.[order date],'yyyy-MM');

----Question 9: Alternative, What are the current and previous month's total sales?
	----Use the Lag and Lead function.
select SD.[order id], SD.Product, format(SD.[order date],'yyyy-MM') as Month,					----With Order ID and Product
format(sum(SD.[quantity ordered] * SD.[price each]),'C') as [Total Sales],
LAG(format(sum(SD.[quantity ordered] * SD.[price each]),'C')) over (partition by SD.[order id] order by format(SD.[order date],'yyyy-MM')) as PrevMonthSales,
LEAD(format(sum(SD.[quantity ordered] * SD.[price each]),'C')) over (partition by SD.[order id] order by format(SD.[order date],'yyyy-MM')) as NextMonthSales
from Sales_Data as SD
group by SD.[order id], SD.Product, format(SD.[order date],'yyyy-MM');

--How to declare variable with WHILE function
declare @counter int;
set @counter = 20;
select @counter as _Counter;
begin
while @counter < 30
	select @counter = @counter + 1;
end;
select @counter as _Counter;


----Question 10: Identify the Sales by Month by Year as either High or Low
select case 
		when format([order date],'MMMM') = 'January' then 1
		when format([order date],'MMMM') = 'February' then 2
		when format([order date],'MMMM') = 'March' then 3
		when format([order date],'MMMM') = 'April' then 4
		when format([order date],'MMMM') = 'May' then 5
		when format([order date],'MMMM') = 'June' then 6
		when format([order date],'MMMM') = 'July' then 7
		when format([order date],'MMMM') = 'August' then 8
		when format([order date],'MMMM') = 'September' then 9
		when format([order date],'MMMM') = 'October' then 10
		when format([order date],'MMMM') = 'November' then 11
		else 12 end as [Month Sorted],
format([order date],'MMMM') as [Month Name], YEAR([order date]) as [Year Sales],
format(sum([quantity ordered] * [price each]),'C') as [Total Sales],
case when YEAR([Order Date]) = '2020' then 'Next Year Sales'
else 'Year Sales' end as [Tracker] 
from Sales_Data
group by format([order date],'MMMM'), YEAR([order date])
order by YEAR([order date]) asc, [Month Sorted] asc;


---Question 11: Identify the Sales by Month by Year and its average
select  case 
		when format([order date],'MMMM') = 'January' then 1
		when format([order date],'MMMM') = 'February' then 2
		when format([order date],'MMMM') = 'March' then 3
		when format([order date],'MMMM') = 'April' then 4
		when format([order date],'MMMM') = 'May' then 5
		when format([order date],'MMMM') = 'June' then 6
		when format([order date],'MMMM') = 'July' then 7
		when format([order date],'MMMM') = 'August' then 8
		when format([order date],'MMMM') = 'September' then 9
		when format([order date],'MMMM') = 'October' then 10
		when format([order date],'MMMM') = 'November' then 11
		else 12 end as [Month Sorted],
format([order date],'MMMM') as [Month Name], YEAR([order date]) as [Year Sales],
format(sum([quantity ordered] * [price each]),'C') as [Total Sales], round((sum([quantity ordered] * [price each]) / COUNT([Order ID])),2) as [Average Sales]
from Sales_Data
group by format([order date],'MMMM'), YEAR([order date])
order by YEAR([order date]) asc, [Month Sorted] asc;

---Question 12: Identify the Sales by Month by Year and its average and identify if it's above avg or not
select case 
		when format([order date],'MMMM') = 'January' then 1
		when format([order date],'MMMM') = 'February' then 2
		when format([order date],'MMMM') = 'March' then 3
		when format([order date],'MMMM') = 'April' then 4
		when format([order date],'MMMM') = 'May' then 5
		when format([order date],'MMMM') = 'June' then 6
		when format([order date],'MMMM') = 'July' then 7
		when format([order date],'MMMM') = 'August' then 8
		when format([order date],'MMMM') = 'September' then 9
		when format([order date],'MMMM') = 'October' then 10
		when format([order date],'MMMM') = 'November' then 11
		else 12 end as [Month Sorted],
format([order date],'MMMM') as [Month Name], YEAR([order date]) as [Year Sales], 
format(sum([quantity ordered] * [price each]),'C') as [Total Sales],
round((sum([quantity ordered] * [price each]) / COUNT([Order ID])),2) as [Average Sales],
case 
	when round((sum([quantity ordered] * [price each]) / COUNT([Order ID])),2) >= 185 
		then 'Above Average' else 'Below Performance' 
			end as Tracker
from Sales_Data
group by format([order date],'MMMM'), YEAR([order date])
order by YEAR([order date]) asc, [Month Sorted] asc;

----Question 13: What are the yearly sales growth (YoY)
select year(SD.[order date]) as Year, format(sum(SD.[quantity ordered] * SD.[price each]),'C') as [Total Sales],
	format(sum(SD.[quantity ordered] * SD.[price each]) - LAG(sum(SD.[quantity ordered] * SD.[price each])) over(order by year(SD.[order date]) asc),'$###,###.##') as [YoY Growth],
	CONCAT(round(COALESCE((sum(SD.[quantity ordered] * SD.[price each]) - LAG(sum(SD.[quantity ordered] * SD.[price each])) over(order by year(SD.[order date]) asc)) 
		/ 
	LAG(sum(SD.[quantity ordered] * SD.[price each])) over(order by year(SD.[order date]) asc) * 100,0),2),'%') as [YoY % Growth]
from Sales_Data as SD
	group by year(SD.[order date]);