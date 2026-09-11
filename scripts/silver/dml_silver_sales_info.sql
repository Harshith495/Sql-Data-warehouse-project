

-- Inserting data into silver.crm_prd_info from bronze.crm_prd_info

TRUNCATE TABLE silver.crm_sales_details;
insert into silver.crm_sales_details (
    sls_ord_num,
    sla_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)

select 
sls_ord_num,
sla_prd_key,
sls_cust_id,
-- coverting int to date format for sls_order_dt, sls_ship_dt, sls_due_dt
(SELECT TRY_CAST(CAST(sls_order_dt AS CHAR(8)) AS DATE) AS sls_order_dt) AS sls_order_dt,
(SELECT TRY_CAST(CAST(sls_ship_dt AS CHAR(8)) AS DATE) AS sls_ship_dt) AS sls_ship_dt,
(SELECT TRY_CAST(CAST(sls_due_dt AS CHAR(8)) AS DATE) AS sls_due_dt) AS sls_due_dt,
-- handling null and negative values for sls_sales and sls_price and recalculating sls_sales if it is not equal to sls_quantity * sls_price
case when sls_sales is null or sls_sales<=0 or sls_sales != sls_quantity * sls_price 
        then sls_quantity * abs(sls_price)
    else sls_sales
    end as sls_sales,
sls_quantity,
-- handling null and negative values for sls_price and recalculating sls_price if it is not equal to sls_sales / sls_quantity
case when sls_price is null or sls_price<=0  
        then abs(sls_sales) / nullif(sls_quantity,0)
    else sls_price
    end as sls_price
from bronze.crm_sales_details;
