use e_commerce;

-- products, sellers, geolocation aur imported by wizard
 
create table payments(
	order_id text,
    payment_sequential int,
    payment_type text,
    payment_installments int,
    payment_value double 
);


CREATE TABLE original_data_with_more_rows (
    UnnamedC_0  INT,
    Gender TEXT,
    EthnicGroup TEXT,
    ParentEdu TEXT,
    LunchType TEXT,
    Testprep TEXT,
    MathScore INT,
    ReadingScore INT,
    WritingScore INT
);


CREATE TABLE orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

create table order_items(
	 order_id TEXT,
     order_item_id int,
     product_id text,
     seller_id text,
     shipping_limit_date text,
     price double,
     freight_value double
);

create table customers(
	customer_id text,
    customer_unique_id text,
    customer_zip_code_prefix text ,
    customer_city text,
    customer_state text
);

-- --------------------------------------------------------- Analysis------------------------------------------------

select*  from customers where  customer_state = "MG";

select*  from customers where  not(customer_state = "MG" or customer_state= "SP");

-- suppose we have to apply condition on more tha 2 states
select* from customers where customer_state in ("MG", "Sp", "RG", "GO");

select* from orders where order_status= "canceled";

select* from payments where payment_type= "UPI" or payment_value >= 500;  -- Yha pr Sirf UPI type hy wo de b de ga ya sirf >= 500 hy

select* from payments where payment_type= "UPI" and (payment_value >= 500  and payment_value >= 1000);
-- instead this we can use between operator:
select* from payments where payment_type= "UPI" and (payment_value  between  500 and 1000);

-- We need to check data on the basis of patterns
select customer_city from customers where customer_city   like "r%";  -- r se start ho city, "%r" --> r pr end ho city,  
select customer_city from customers where customer_city   like "%de%"; --  "%de%" name me de ata ho kahin b

select* from payments order by  payment_type, payment_value  desc;

select* from payments where payment_installments = 1 order by payment_value  desc limit 2,3;  -- phli 2 rows ko skip kr k next 3 de ga

-- ------------------------------------------Aggeregate functions
select count(customer_id) from customers; 
select max(payment_value) from payments;
select min(payment_value) from payments;
select avg(payment_value) from payments;
select sum(payment_value) from payments;

-- Aggregate functions ignore null values (except for COUNT()).
-- count gives the nuumber of rows
-- as in customer-city , cities are repititive-- 
select count(distinct(customer_city)) from customers;

select seller_city , length(seller_city) from sellers; -- length fun gives the length of each name
-- to avouid widespaces in name
select seller_city , length(trim(seller_city)) from sellers;

 select upper(seller_city) from sellers;
 select seller_city , replace(seller_city, "a", "i") from sellers;
 
 -- concat 2 columns in table:
 select* ,    concat(seller_city, "-",  seller_state )  from sellers;
 select order_delivered_customer_date ,
 date(order_delivered_customer_date),
 day(order_delivered_customer_date),
 month(order_delivered_customer_date),
 monthname(order_delivered_customer_date),
 year(order_delivered_customer_date),
 dayname(order_delivered_customer_date)
 from orders;
 
 select datediff( order_estimated_delivery_date, order_delivered_customer_date) from orders;
 
-- ceil gives upper rounded value, floor gives lower rounded value

select* from orders where order_delivered_customer_date is null;
select order_status, count(order_status) from orders; -- sb ko mila k aik single value de ga
select order_status, count(order_status) from orders
group by order_status;
 
 select payment_type, avg(payment_value) from payments where payment_installments=1
 group by payment_type  ;
 
 -- aggeregate value k base pr condition deni ho tou where nhi having use krty
  select payment_type, avg(payment_value) from payments 
 group by payment_type having avg(payment_value)>= 100  ;
 
 select  year(order_purchase_timestamp) as years, sum(payments.payment_value)
from orders join payments on orders.order_id = payments.order_id
group by years ;

-- select (products.productcategory) as category , sum(payments.payment_value) as pay_sum
-- from products join order_items on order_items.product_id = products.product_id
-- join order_items on  order_items.order_id = payments.order_id
-- group by category  order by pay_sum;   error of coulmn name

-- exmple of cte
 with a as(
 select  year(order_purchase_timestamp) as years, sum(payments.payment_value)
from orders join payments on orders.order_id = payments.order_id
group by years )

select years from a;

select* , case
when payments.payment_value <= 100  then "low"
when payments.payment_value >= 500  then "low"
else "medium"
end as exp
from payments;


select time_order  , sum(value_p) over(order by time_order ) as cummulative
from(
select date(orders.order_purchase_timestamp) as time_order , payments.payment_value as value_p 
from payments join orders on orders.order_id = payments.order_id
group by time_order) as sales;

-- we can create view( a virtual table)
create view product_cate  as 
select time_order  , sum(value_p) over(order by time_order ) as cummulative
from(
select date(orders.order_purchase_timestamp) as time_order , payments.payment_value as value_p 
from payments join orders on orders.order_id = payments.order_id
group by time_order) as sales;








