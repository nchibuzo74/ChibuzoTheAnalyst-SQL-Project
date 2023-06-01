-----Create Olist Database
create database Olist;
go
use olist;

---Change the file format of all the Olist dataset
----Import Olist Dataset

---Identify the datatypes of the imported table
EXEC sp_help Products;
exec sp_help [Order Reviews];
exec sp_help [Product Category Name Translate];
exec sp_help [Order Payment];
exec sp_help Orders;
exec sp_help [Order Items];
exec sp_help Customer;
exec sp_help Geolocation;
exec sp_help Sellers;

---Question 1: 
	---(i) What is the total revenue generated by Olist, and how has it changed over time?
select format(sum(op.payment_value),'C') as [Total Revenue] 
from [order payment] as OP
	inner join orders as O
	on op.order_id = o.order_id
	inner join [Order Items] as OI
	on O.order_id = OI.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped');

	----(ii) How has it changed over time? (i.e MoM)
select case 
		when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
		when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
		when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
		when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
		when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
		when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
		when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
		when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
		when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
		when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
		when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
		else 12
		end as [Month Sort],
		format(o.order_purchase_timestamp,'MMMM-dd') as Month, 
		YEAR(o.order_purchase_timestamp) as Year, 
		format(sum(op.payment_value),'C') as [Total Revenue],
		(format(sum(op.payment_value) - LAG(sum(op.payment_value)) over(partition by YEAR(o.order_purchase_timestamp) order by o.order_purchase_timestamp),'C')) as [Month Growth],
		CONCAT(coalesce(round(
		((sum(op.payment_value) - LAG(sum(op.payment_value)) over(partition by YEAR(o.order_purchase_timestamp) order by o.order_purchase_timestamp))
				/
		LAG(sum(op.payment_value)) over(partition by YEAR(o.order_purchase_timestamp) order by o.order_purchase_timestamp)) * 100,
		2),0),'%') as [MoM % Growth]
from [order payment] as OP
	inner join orders as O
	on op.order_id = o.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by format(o.order_purchase_timestamp,'MMMM-dd'), YEAR(o.order_purchase_timestamp), o.order_purchase_timestamp
order by YEAR(o.order_purchase_timestamp) ASC,[Month Sort] ASC, format(o.order_purchase_timestamp,'MMMM-dd') ASC;


---Question 2: How many orders were placed on Olist, and how does this vary by month or season?
	----(i) Total Orders
select format(count(distinct(OI.order_id)),'###,###') 
from [Order Items] as OI
	inner join Orders as O
	on OI.order_id = O.order_id
	inner join [Order Payment] as OP
	on O.order_id = OP.order_id;

----(ia) Total fulfilled Orders 
select format(count(distinct(OI.order_id)),'###,###') 
from [Order Items] as OI
	inner join Orders as O
	on OI.order_id = O.order_id
	inner join [Order Payment] as OP
	on O.order_id = OP.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped');


	----(ii) Variance by Month (MoM growth)
select case 
		when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
		when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
		when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
		when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
		when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
		when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
		when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
		when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
		when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
		when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
		when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
		else 12
		end as [Month Sort],
		format(o.order_purchase_timestamp,'MMMM-dd') as Month, 
		YEAR(o.order_purchase_timestamp) as Year, 
		format(count(distinct(o.order_id)),'###,###') as [Total Orders],
		(count(distinct(o.order_id)) - LAG(count(distinct(o.order_id))) over(order by o.order_purchase_timestamp)) as [Month Growth],
		CONCAT(coalesce(round(
		((count(distinct(o.order_id)) - LAG(count(distinct(o.order_id))) over(order by o.order_purchase_timestamp))
				/
		LAG(count(distinct(o.order_id))) over(order by o.order_purchase_timestamp)) * 100,
		2),0),'%') as [MoM % Growth]
from Orders as O
	inner join [Order Payment] as OP
	on o.order_id = op.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by format(o.order_purchase_timestamp,'MMMM-dd'), YEAR(o.order_purchase_timestamp), o.order_purchase_timestamp
order by YEAR(o.order_purchase_timestamp) ASC,[Month Sort] ASC, format(o.order_purchase_timestamp,'MMMM-dd') ASC;

	----(iii) Variance by Season (Quarter)
select case 
		when format(o.order_purchase_timestamp,'MMMM') = 'January' then 'Quarter 1'
		when format(o.order_purchase_timestamp,'MMMM') = 'February' then 'Quarter 1'
		when format(o.order_purchase_timestamp,'MMMM') = 'March' then 'Quarter 1'
		when format(o.order_purchase_timestamp,'MMMM') = 'April' then 'Quarter 2'
		when format(o.order_purchase_timestamp,'MMMM') = 'May' then 'Quarter 2'
		when format(o.order_purchase_timestamp,'MMMM') = 'June' then 'Quarter 2'
		when format(o.order_purchase_timestamp,'MMMM') = 'July' then 'Quarter 3'
		when format(o.order_purchase_timestamp,'MMMM') = 'August' then 'Quarter 3'
		when format(o.order_purchase_timestamp,'MMMM') = 'September' then 'Quarter 3'
		else 'Quarter 4'
		end as Quater,
		YEAR(o.order_purchase_timestamp) as Year, 
		format(count(distinct(o.order_id)),'###,###') as [Total Orders],
		(count(distinct(o.order_id)) - LAG(count(distinct(o.order_id))) over(order by o.order_purchase_timestamp)) as [Month Growth],
		CONCAT(coalesce(round(
		((count(distinct(o.order_id)) - LAG(count(distinct(o.order_id))) over(order by o.order_purchase_timestamp))
				/
		LAG(count(distinct(o.order_id))) over(order by o.order_purchase_timestamp)) * 100,
		2),0),'%') as [MoM % Growth]
from Orders as O
	inner join [Order Payment] as OP
	on o.order_id = op.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by YEAR(o.order_purchase_timestamp), o.order_purchase_timestamp
order by YEAR(o.order_purchase_timestamp) ASC, Quater ASC;


-----Question 3: What are the most popular product categories on Olist, and how do their sales volumes compare to each other?
	----(ia) The most popular product categories on Olist
select top 1 upper(REPLACE(PCNE.product_category_name_english,'_',' ')) as [Product Category Name],
	   format(COUNT(distinct(P.product_id)),'###,###') as [Popular Product Category] 
from Products as P
	inner join [Product Category Name Translate] as PCNE
	on P.product_category_name = PCNE.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
group by PCNE.product_category_name_english
order by COUNT(P.product_id) desc;

	----(ib) The popular product categories on Olist
select upper(REPLACE(PCNE.product_category_name_english,'_',' ')) as [Product Cat. Name],
	   format(COUNT(distinct(P.product_id)),'###,###') as [Popular Product Category] 
from Products as P
	inner join [Product Category Name Translate] as PCNE
	on P.product_category_name = PCNE.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
group by PCNE.product_category_name_english
order by COUNT(P.product_id) desc;
	
	----(ii) Product category sales volumes compare to each other
select upper(REPLACE(PCNE.product_category_name_english,'_',' ')) as [Product Category Name],
	   format(COUNT(distinct(P.product_id)),'###,###') as [Popular Product Cat.],
	   format(sum(OP.payment_value),'C') as [Sales Volume]
from Products as P
	inner join [Product Category Name Translate] as PCNE
	on P.product_category_name = PCNE.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
	inner join orders as O
	on OI.order_id = O.order_id
	inner join [Order Payment] as OP
	on O.order_id =  OP.order_id
	inner join Customer as C
	on O.customer_id = c.customer_id
	inner join [Order Payment] as OPm
	on OI.order_id = OPm.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by PCNE.product_category_name_english
order by COUNT(P.product_id) desc;

----Question 4: : What is the average order value (AOV) on Olist, and how does this vary by product category or payment method?
select upper(REPLACE(PCNE.product_category_name_english,'_',' ')) as [Product Category Name],
		upper(replace(op.payment_type,'_',' ')) as [Payment Type],
	   format(COUNT(distinct(P.product_id)),'###,###') as [Popular Product Cat.],
	   format(avg(OP.payment_value),'C') as [AOV]
from Products as P
	inner join [Product Category Name Translate] as PCNE
	on P.product_category_name = PCNE.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
	inner join orders as O
	on OI.order_id = O.order_id
	inner join [Order Payment] as OP
	on O.order_id =  OP.order_id
	inner join Customer as C
	on O.customer_id = c.customer_id
	inner join [Order Payment] as OPm
	on OI.order_id = OPm.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by upper(REPLACE(PCNE.product_category_name_english,'_',' ')), upper(replace(op.payment_type,'_',' '))
order by upper(replace(op.payment_type,'_',' ')) asc, format(COUNT(distinct(P.product_id)),'###,###') desc;

---Question 5: How many sellers are active on Olist, and how does this number change over time?
	----(i) How many sellers are active on Olist
select format(count(distinct(S.seller_id)),'###,###') as [Total Sellers] 
from Sellers as S
	inner join Customer as C
	on S.seller_zip_code_prefix = C.customer_zip_code_prefix
	inner join Geolocation as G
	on S.seller_zip_code_prefix = G.geolocation_zip_code_prefix
	inner join [Order Items] as OI
	on S.seller_id = OI.seller_id;

	----(ii) How does this number change over time?
select case
			when format(OI.shipping_limit_date,'MMMM') = 'January' then 1
			when format(OI.shipping_limit_date,'MMMM') = 'February' then 2
			when format(OI.shipping_limit_date,'MMMM') = 'March' then 3
			when format(OI.shipping_limit_date,'MMMM') = 'April' then 4
			when format(OI.shipping_limit_date,'MMMM') = 'May' then 5
			when format(OI.shipping_limit_date,'MMMM') = 'June' then 6
			when format(OI.shipping_limit_date,'MMMM') = 'July' then 7
			when format(OI.shipping_limit_date,'MMMM') = 'August' then 8
			when format(OI.shipping_limit_date,'MMMM') = 'September' then 9
			when format(OI.shipping_limit_date,'MMMM') = 'October' then 10
			when format(OI.shipping_limit_date,'MMMM') = 'November' then 11
			else 12
		end as [Month Sort],
	year(OI.shipping_limit_date) as Year,
	format(OI.shipping_limit_date,'MMMM') as Month,
	format(count(distinct(S.seller_id)),'###,###') as [Total Sellers]
from Sellers as S
	inner join Customer as C
	on S.seller_zip_code_prefix = C.customer_zip_code_prefix
	inner join Geolocation as G
	on S.seller_zip_code_prefix = G.geolocation_zip_code_prefix
	inner join [Order Items] as OI
	on S.seller_id = OI.seller_id
group by year(OI.shipping_limit_date), format(OI.shipping_limit_date,'MMMM')
order by year(OI.shipping_limit_date) asc, [Month Sort] asc, format(OI.shipping_limit_date,'MMMM') asc;

----Question 6: What is the distribution of seller ratings on Olist, and how does this impact sales performance?
select case
			when format(OI.shipping_limit_date,'MMMM') = 'January' then 1
			when format(OI.shipping_limit_date,'MMMM') = 'February' then 2
			when format(OI.shipping_limit_date,'MMMM') = 'March' then 3
			when format(OI.shipping_limit_date,'MMMM') = 'April' then 4
			when format(OI.shipping_limit_date,'MMMM') = 'May' then 5
			when format(OI.shipping_limit_date,'MMMM') = 'June' then 6
			when format(OI.shipping_limit_date,'MMMM') = 'July' then 7
			when format(OI.shipping_limit_date,'MMMM') = 'August' then 8
			when format(OI.shipping_limit_date,'MMMM') = 'September' then 9
			when format(OI.shipping_limit_date,'MMMM') = 'October' then 10
			when format(OI.shipping_limit_date,'MMMM') = 'November' then 11
			else 12
		end as [Month Sort],
	upper(O.order_status),
	year(OI.shipping_limit_date) as Year,
	format(OI.shipping_limit_date,'MMMM') as Month,
	format(count(distinct(S.seller_id)),'###,###') as [Total Sellers],
	format(sum(OP.payment_value),'C') as [Total Sales],
	format(AVG(OP.payment_value),'C') as [Average Sales]
from Sellers as S
	inner join Customer as C
	on S.seller_zip_code_prefix = C.customer_zip_code_prefix
	inner join Geolocation as G
	on S.seller_zip_code_prefix = G.geolocation_zip_code_prefix
	inner join [Order Items] as OI
	on S.seller_id = OI.seller_id
	inner join [Order Payment] as OP
	on OI.order_id = OP.order_id
	inner join Orders as O
	on OP.order_id = O.order_id
group by year(OI.shipping_limit_date), format(OI.shipping_limit_date,'MMMM'), upper(O.order_status)
order by year(OI.shipping_limit_date) asc, [Month Sort] asc, format(OI.shipping_limit_date,'MMMM') asc, upper(O.order_status) asc;


----Alternative to Question 6: What is the distribution of seller ratings on Olist, and how does this impact sales performance?
---Ans: Firstly, you need to calculate the average sales as a bench mark for distribution of seller ratings
select case
			when format(OI.shipping_limit_date,'MMMM') = 'January' then 1
			when format(OI.shipping_limit_date,'MMMM') = 'February' then 2
			when format(OI.shipping_limit_date,'MMMM') = 'March' then 3
			when format(OI.shipping_limit_date,'MMMM') = 'April' then 4
			when format(OI.shipping_limit_date,'MMMM') = 'May' then 5
			when format(OI.shipping_limit_date,'MMMM') = 'June' then 6
			when format(OI.shipping_limit_date,'MMMM') = 'July' then 7
			when format(OI.shipping_limit_date,'MMMM') = 'August' then 8
			when format(OI.shipping_limit_date,'MMMM') = 'September' then 9
			when format(OI.shipping_limit_date,'MMMM') = 'October' then 10
			when format(OI.shipping_limit_date,'MMMM') = 'November' then 11
			else 12
		end as [Month Sort],
	year(OI.shipping_limit_date) as Year,
	format(OI.shipping_limit_date,'MMMM') as Month,
	format(count(distinct(S.seller_id)),'###,###') as [Total Sellers],
	format(sum(OP.payment_value),'C') as [Total Sales],
	format(AVG(OP.payment_value),'C') as [Average Sales],
		case
			when AVG(OP.payment_value) > 173.00 then 'The sellers are excellent'
			when AVG(OP.payment_value) = 173.00 then 'The sellers are good'
			else 'The sellers are fair enough'
		end as Rating
from Sellers as S
	inner join Customer as C
	on S.seller_zip_code_prefix = C.customer_zip_code_prefix
	inner join Geolocation as G
	on S.seller_zip_code_prefix = G.geolocation_zip_code_prefix
	inner join [Order Items] as OI
	on S.seller_id = OI.seller_id
	inner join [Order Payment] as OP
	on OI.order_id = OP.order_id
	inner join Orders as O
	on OP.order_id = O.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by year(OI.shipping_limit_date), format(OI.shipping_limit_date,'MMMM')
order by year(OI.shipping_limit_date) asc, [Month Sort] asc, format(OI.shipping_limit_date,'MMMM') asc, Rating asc;


----Question 7: How many customers have made repeat purchases on Olist, and what percentage of total sales do they account for?
	----(i) How many customers have made repeat purchases on Olist
select format(count(distinct(S.customer_id)),'C') as [Total Customers] 
from Customer as S
	inner join Orders as O
	on S.customer_id = O.customer_id;

	---(ii) What percentage of total sales do they account for?
		---Ans: It basically means market shares of the total sales among the customers
set arithabort off;     ----The set arithabort off controls whether error messages are returned from overflow or divide-by-zero errors during a query
set ansi_warnings off;  ----set ansi_warnings off is used to return null whenever the divide-by-zero error might occur
select upper(S.customer_city) as [Customer City], 
	   S.customer_state, 
	   format(sum(OP.payment_value),'C') as [Total Sales],
	   concat(round(coalesce((OP.payment_value / sum(OP.payment_value)) * 100,0),2),'%') as [% of Total Sales]
from Customer as S
	inner join Orders as O
	on S.customer_id = O.customer_id
	inner join [Order Payment] as OP
	on O.order_id = OP.order_id
	inner join [Order Items] as OI
	on OP.order_id = OI.order_id
where O.order_status in ('delivered','approved','invoiced','processing','shipped')
group by upper(S.customer_city), S.customer_state, OP.payment_value
order by upper(S.customer_city) asc, S.customer_state asc;

-----Wondering state/Revisit ---(ii)
set arithabort off;				----The set arithabort off controls whether error messages are returned from overflow or divide-by-zero errors during a query
set ansi_warnings off;			----set ansi_warnings off is used to return null whenever the divide-by-zero error might occur
select S.customer_city,
		count(S.customer_id) over(partition by S.customer_city order by S.customer_state asc) as [Total Customers],
		sum(OP.payment_value) over(partition by S.customer_city order by S.customer_state asc) as [Total Sales],
		coalesce((OP.payment_value / sum(OP.payment_value)) * 100,0) as [% Total]
from Customer as S
	inner join Orders as O
	on S.customer_id = O.customer_id
	inner join [Order Payment] as OP
	on O.order_id = OP.order_id
	inner join [Order Items] as OI
	on OP.order_id = OI.order_id
where o.order_status in ('delivered','approved','invoiced','processing','shipped')
group by S.customer_city,S.customer_state, OP.payment_value, S.customer_id
order by S.customer_state asc;

----Skip Question 8: What is the average customer rating for products sold on Olist, and how does this impact sales performance?
select format((count(C.customer_id) / count(distinct(C.customer_id))),'###,###') as [Average Customer] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
where O.order_status in ('delivered','approved','invoiced','processing','shipped');
		
-----Skip Question 9: What is the average order cancellation rate on Olist, and how does this impact seller performance?.
select format(COUNT(O.order_id) / COUNT(distinct(O.order_id)),'###,###') as [Average Order Cancelled] 
from Orders as O
	inner join [Order Items] as OI
	on O.order_id = OI.order_id
	inner join [Order Payment] as OP
	on OI.order_id = OP.order_id
where O.order_status = 'canceled';

----Question 10: What are the top-selling products on Olist, and how have their sales trends changed over time
select case
			when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
			when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
			when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
			when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
			when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
			when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
			when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
			when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
			when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
			when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
			when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
			else 12
			end as [Month Sort],
		format(O.order_purchase_timestamp,'MMMM') as Month,
		year(o.order_purchase_timestamp) as Year,
		upper(REPLACE(PCNT.product_category_name_english,'_',' ')) as [Product Category Name],
	   format(count(P.product_id),'###,###') as [Top Selling Product],
	   format(sum(OP.payment_value),'C') as [Total Sales],
	   format(sum(OP.payment_value) - lag(sum(OP.payment_value)) over(order by format(O.order_purchase_timestamp,'MMMM') asc),'C') as [Sales Trend],
	   concat(round(coalesce(
	   (sum(OP.payment_value) - lag(sum(OP.payment_value)) over(order by format(O.order_purchase_timestamp,'MMMM') asc))
			/
		lag(sum(OP.payment_value)) over(order by format(O.order_purchase_timestamp,'MMMM') asc),
		0),2),'%') as [% Sales Trend]
from Products as P
	inner join [Product Category Name Translate] as PCNT
	on P.product_category_name = PCNT.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
	inner join Orders as O
	on OI.order_id = O.order_id
	inner join [Order Payment] as OP
	on OI.order_id = OP.order_id
	where O.order_status in ('delivered','approved','invoiced','processing','shipped')
group by  year(o.order_purchase_timestamp), format(O.order_purchase_timestamp,'MMMM'), upper(REPLACE(PCNT.product_category_name_english,'_',' '))
order by [Month Sort] asc, year(o.order_purchase_timestamp) asc, format(o.order_purchase_timestamp,'MMMM') asc, format(count(P.product_id),'###,###') desc;


----Alternative 1 to Question 10
with CTE as (
		select case
			when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
			when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
			when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
			when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
			when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
			when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
			when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
			when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
			when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
			when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
			when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
			else 12
			end as [Month Sort],
		format(O.order_purchase_timestamp,'MMMM') as Month,
		year(o.order_purchase_timestamp) as Year,
		upper(REPLACE(PCNT.product_category_name_english,'_',' ')) as [Product Category Name],
	   format(count(P.product_id),'###,###') as [Top Selling Product],
	   format(sum(OP.payment_value),'C') as [Total Sales],
	   format(sum(OP.payment_value) - lag(sum(OP.payment_value)) over(order by format(O.order_purchase_timestamp,'MMMM') asc),'C') as [Sales Trend],
	   concat(round(coalesce(
	   (sum(OP.payment_value) - lag(sum(OP.payment_value)) over(order by format(O.order_purchase_timestamp,'MMMM') asc))
			/
		lag(sum(OP.payment_value)) over(order by format(O.order_purchase_timestamp,'MMMM') asc),
		0),2),'%') as [% Sales Trend]
from Products as P
	inner join [Product Category Name Translate] as PCNT
	on P.product_category_name = PCNT.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
	inner join Orders as O
	on OI.order_id = O.order_id
	inner join [Order Payment] as OP
	on O.order_id = OP.order_id
	where O.order_status in ('delivered','approved','invoiced','processing','shipped')
group by  year(o.order_purchase_timestamp), format(O.order_purchase_timestamp,'MMMM'), upper(REPLACE(PCNT.product_category_name_english,'_',' '))
			)
select CTE.[Product Category Name], max([Top Selling Product]) as [Top Selling Product] from CTE
group by CTE.[Product Category Name], CTE.[Top Selling Product]
order by CTE.[Top Selling Product] desc;
---order by format(count(distinct(P.product_id)),'###,###') desc


----Alternative 2 to Question 10
select /*[Product Category Name] as [Product Category Name],*/ max([Top Selling Product]) as Highest
from (
	  select upper(REPLACE(PCNT.product_category_name_english,'_',' ')) as [Product Category Name], 
	  format(count(distinct(P.product_id)),'###,###') as [Top Selling Product] 
	from Products as P
	inner join [Product Category Name Translate] as PCNT
	on P.product_category_name = PCNT.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
	inner join Orders as O
	on OI.order_id = O.order_id
	where O.order_status in ('delivered','approved','invoiced','processing','shipped')
group by upper(REPLACE(PCNT.product_category_name_english,'_',' '))
	) as t;
/*group by [Product Category Name];
order by produ desc;*/

---Question 11: Which payment methods are most commonly used by Olist customers, and how does this vary by product category or geographic region?
select top 1 row_number() over(order by count(OP.payment_type) desc) as [S/N],
	   upper(replace(OP.payment_type,'_',' ')) as [Payment Type],
	  format( count(OP.payment_type),'###,###') as [Most common payment method],
	   upper(replace(PCNT.product_category_name_english,'_',' ')) as [Product Category Name], 
	   upper(G.geolocation_city) as [Geolocation City], 
	   G.geolocation_state
from [Order Payment] as OP
	inner join [Order Items] as OI
	on OP.order_id = OI.order_id
	inner join Orders as O
	on OI.order_id = O.order_id
	inner join Products as P
	on OI.product_id = P.product_id
	inner join [Product Category Name Translate] as PCNT
	on P.product_category_name = PCNT.product_category_name
	inner join Customer as C
	on O.customer_id = C.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
group by PCNT.product_category_name_english, G.geolocation_city, G.geolocation_state, OP.payment_type;


----Question 12: How do customer reviews and ratings affect sales and product performance on Olist?
select upper(OrdR.review_comment_message) as [Review Comment Message], 
	   format(sum(OP.payment_value),'C') as [Total Sales], 
	   Upper(replace(PCNT.product_category_name_english,'_',' ')) as [Product Category Name English] 
from [Order Reviews] as OrdR
	   inner join [Order Items] as OI
	   on OrdR.order_id = OI.order_id
	   inner join [Order Payment] as OPm
	   on OrdR.order_id = OPm.order_id
	   inner join [Order Payment] as OP
	   on OI.order_id = OP.order_id
	   inner join Products as P
	   on OI.product_id = P.product_id
	   inner join [Product Category Name Translate] as PCNT
	   on P.product_category_name = PCNT.product_category_name
where OrdR.review_comment_message <> ''					-----Not equal to empthy can be symbolize either ways like IS NOT NULL, != '', <>''. Either ways will give you same result
group by OrdR.review_comment_message, PCNT.product_category_name_english;


----Question 13: Which product categories have the highest profit margins on Olist, and how can the company increase profitability across different categories?
select 
	upper(replace(PCNT.product_category_name_english,'_',' ')) as [Product Category Name English], 
	format((sum(OP.payment_value) - sum(OI.price)),'C') as [Profit Margin] 
from Products as P
	inner join [Product Category Name Translate] as PCNT
	on P.product_category_name = PCNT.product_category_name
	inner join [Order Items] as OI
	on P.product_id = OI.product_id
	inner join [Order Payment] as OP
	on OI.order_id = OP.order_id
group by upper(replace(PCNT.product_category_name_english,'_',' '))
order by format((sum(OP.payment_value) - sum(OI.price)),'C') desc;

---Question 14: How does Olist's marketing spend and channel mix impact sales and customer acquisition costs, and how can the company optimize its marketing strategy to increase ROI?
	---Ans: This can be achieved with BI tool like Power BI

---Question 15: Geolocation having high customer density. Calculate customer retention rate according to geolocations.
	----(i) Geolocation having high customer density
select top 1 G.geolocation_zip_code_prefix, 
	   format(COUNT(distinct(C.customer_id)),'###,###') as [Customer Density]
from Geolocation as G
	inner join Customer as C
	on G.geolocation_zip_code_prefix = C.customer_zip_code_prefix
group by G.geolocation_zip_code_prefix
order by COUNT(distinct(C.customer_id)) desc;

	----(ii) Calculate customer retention rate according to geolocations.
with E as (
		select G.geolocation_zip_code_prefix, C.customer_id, 
		COUNT(distinct(C.customer_id)) as [Total Customer on Dec, 2017] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
where year(O.order_purchase_timestamp) = 2017 and month(O.order_purchase_timestamp) = 12     ----Start with the number of customers at the end of the time period (E)
group by G.geolocation_zip_code_prefix, C.customer_id
			),
Total_Cus_2017 as (
		select G.geolocation_zip_code_prefix, C.customer_id, 
		COUNT(distinct(C.customer_id)) as [Total Customer in 2017] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
where year(O.order_purchase_timestamp) = 2017
group by G.geolocation_zip_code_prefix, C.customer_id
				   ),
S as (
		select G.geolocation_zip_code_prefix, C.customer_id, 
		COUNT(distinct(C.customer_id)) as [Total Customer on Jan, 2017] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
where year(O.order_purchase_timestamp) = 2017 and month(O.order_purchase_timestamp) = 1          ----Customers at the beginning of the time period (S)
group by G.geolocation_zip_code_prefix, C.customer_id
	 )
----Note N will be E.[Total Customer on Dec 31, 2017] - T.[Total Customer in 2017]
select case
			when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
			when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
			when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
			when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
			when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
			when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
			when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
			when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
			when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
			when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
			when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
			else 12
			end as [Month Sort],
	   format(o.order_purchase_timestamp,'MMMM') as Month,
	   year(o.order_purchase_timestamp) as Year,
	   G.geolocation_zip_code_prefix,
	   count(distinct(C.customer_id)) as [Total Customer],
	   concat(((E.[Total Customer on Dec, 2017] - T.[Total Customer in 2017]) / S.[Total Customer on Jan, 2017]) * 100,'%') as [Customer Retention Rate] 
from Customer as C
	inner join E
	on C.customer_id = E.customer_id
	inner join Total_Cus_2017 as T
	on C.customer_id = T.customer_id
	inner join S
	on C.customer_id = S.customer_id
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
group by year(o.order_purchase_timestamp), 
		 format(o.order_purchase_timestamp,'MMMM'), 
		 G.geolocation_zip_code_prefix, 
		 E.[Total Customer on Dec, 2017], 
		 T.[Total Customer in 2017], 
		 S.[Total Customer on Jan, 2017]
order by [Month Sort] asc, year(o.order_purchase_timestamp), format(o.order_purchase_timestamp,'MMMM');

	----(iii) Calculate customer churn rate according to geolocations.
with E as (
		select G.geolocation_zip_code_prefix, C.customer_id, 
		COUNT(distinct(C.customer_id)) as [Total Customer on Dec, 2017] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
where year(O.order_purchase_timestamp) = 2017 and month(O.order_purchase_timestamp) = 12     ----Start with the number of customers at the end of the time period (E)
group by G.geolocation_zip_code_prefix, C.customer_id
			),
Total_Cus_2017 as (
		select G.geolocation_zip_code_prefix, C.customer_id, 
		COUNT(distinct(C.customer_id)) as [Total Customer in 2017] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
where year(O.order_purchase_timestamp) = 2017
group by G.geolocation_zip_code_prefix, C.customer_id
				   ),
S as (
		select G.geolocation_zip_code_prefix, C.customer_id, 
		COUNT(distinct(C.customer_id)) as [Total Customer on Jan, 2017] 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
where year(O.order_purchase_timestamp) = 2017 and month(O.order_purchase_timestamp) = 1          ----Customers at the beginning of the time period (S)
group by G.geolocation_zip_code_prefix, C.customer_id
	 )
----Note N will be E.[Total Customer on Dec 31, 2017] - T.[Total Customer in 2017]
select case
			when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
			when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
			when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
			when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
			when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
			when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
			when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
			when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
			when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
			when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
			when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
			else 12
			end as [Month Sort],
	   format(o.order_purchase_timestamp,'MMMM') as Month,
	   year(o.order_purchase_timestamp) as Year,
	   G.geolocation_zip_code_prefix,
	   count(distinct(C.customer_id)) as [Total Customer],
	   concat((T.[Total Customer in 2017] / S.[Total Customer on Jan, 2017]) * 100,'%') as [Customer Churn Rate] 
from Customer as C
	inner join E
	on C.customer_id = E.customer_id
	inner join Total_Cus_2017 as T
	on C.customer_id = T.customer_id
	inner join S
	on C.customer_id = S.customer_id
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
group by year(o.order_purchase_timestamp), 
		 format(o.order_purchase_timestamp,'MMMM'), 
		 G.geolocation_zip_code_prefix, 
		 E.[Total Customer on Dec, 2017], 
		 T.[Total Customer in 2017], 
		 S.[Total Customer on Jan, 2017]
order by [Month Sort] asc, year(o.order_purchase_timestamp), format(o.order_purchase_timestamp,'MMMM');


------Rough work
select case
			when format(o.order_purchase_timestamp,'MMMM') = 'January' then 1
			when format(o.order_purchase_timestamp,'MMMM') = 'February' then 2
			when format(o.order_purchase_timestamp,'MMMM') = 'March' then 3
			when format(o.order_purchase_timestamp,'MMMM') = 'April' then 4
			when format(o.order_purchase_timestamp,'MMMM') = 'May' then 5
			when format(o.order_purchase_timestamp,'MMMM') = 'June' then 6
			when format(o.order_purchase_timestamp,'MMMM') = 'July' then 7
			when format(o.order_purchase_timestamp,'MMMM') = 'August' then 8
			when format(o.order_purchase_timestamp,'MMMM') = 'September' then 9
			when format(o.order_purchase_timestamp,'MMMM') = 'October' then 10
			when format(o.order_purchase_timestamp,'MMMM') = 'November' then 11
			else 12
			end as [Month Sort],
	G.geolocation_zip_code_prefix,
	format(O.order_purchase_timestamp,'MMMM') as Month, year(O.order_purchase_timestamp) as Year, COUNT(distinct(C.customer_id)) as Cus 
from Customer as C
	inner join Orders as O
	on C.customer_id = O.customer_id
	inner join Geolocation as G
	on C.customer_zip_code_prefix = G.geolocation_zip_code_prefix
group by G.geolocation_zip_code_prefix, format(O.order_purchase_timestamp,'MMMM'), year(O.order_purchase_timestamp)
order by [Month Sort] asc, year(O.order_purchase_timestamp) asc, format(O.order_purchase_timestamp,'MMMM') asc;

----End of Project on Olist