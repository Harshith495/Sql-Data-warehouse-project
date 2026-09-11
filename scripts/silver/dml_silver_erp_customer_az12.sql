-- Inserting the data from bronze layer erp_customer to silver layer erp_customer
TRUNCATE TABLE silver.erp_cust_az12;
INSERT into silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)

select 
case when cid like 'NAS%' then substring(cid, 4, len(cid))
    else cid 
end as cid,
case when bdate >getdate() then null 
else bdate 
end as bdate,
  -- following the proper case for every row
case when upper(trim(gen)) in ('F', 'FEMALE') THEN 'Female'
    when upper(trim(gen)) in ('M', 'MALE') THEN 'Male'
    else 'n/a'
end as gen
from bronze.erp_cust_az12;


select * from silver.erp_cust_az12;
