-- check for null or duplicates in primary key columns in customer information table.

select * from  bronze.crm_cust_info;


select
cst_id,
count(*) from  bronze.crm_cust_info
group by cst_id
having count(*) > 1;

select * from  bronze.crm_cust_info
where cst_id = '29449';

select * from  bronze.crm_cust_info
where cst_id is null;


select min(cst_created_date) as min_created_date, max(cst_created_date) as max_created_date from  bronze.crm_cust_info;


-- check for unwanted spaces in the customer information table

select cst_firstname
from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname);

select cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim(cst_lastname);

select distinct cst_material_status
from bronze.crm_cust_info;

select * from bronze.crm_cust_info
where cst_id is null;

delete from bronze.crm_cust_info
where cst_id is null;
