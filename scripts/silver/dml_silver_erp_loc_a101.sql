
-- Inserting the data into silver location table form the bronze location table after the transfermation.

insert into silver.erp_loc_a101(
    cid,
    cntry
)

select 
REPLACE(cid, '-', '') cid, -- Hnadel the invalid customer ID.
case when trim(cntry) = 'DE' then 'Germany'
     when trim(cntry) in ('US','USA') then 'United States'
     when trim(cntry) = '' then 'n/a'
     else trim(cntry)
end as cntry -- Normalize and Handel the missing or blank country codes.
from bronze.erp_loc_a101;



select * from silver.erp_loc_a101;
