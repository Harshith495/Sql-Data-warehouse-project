

-- inserting the data from bronze.crm_prd_info to silver.crm_prd_info

insert into silver.crm_prd_info (
    prd_id, 
    cat_id, 
    prd_key, 
    prd_nm, 
    prd_cost, 
    prd_line, 
    prd_start_dt, 
    prd_end_dt)

select
prd_id,  -- creating a new column cat_id by replacing the '-' with '_' in the first 5 characters of prd_key
replace(substring(prd_key, 1, 5), '-', '_') as cat_id, 
substring(prd_key, 7, len(prd_key)) as prd_key,
prd_nm,  -- handling null values in prd_cost by replacing them with 0
isnull(prd_cost, 0) as prd_cost,
CASE upper(trim(prd_line)) -- mapping the values of prd_line to their corresponding full names
    when  'M' then 'Mountain'
    WHEN 'R' THEN 'Road'
    WHEN 'T' THEN 'Touring'
    WHEN 'S' THEN 'Other sales'
    ELSE 'n/a'
END as prd_line,
cast (prd_start_dt as date) as prd_start_dt, -- calculating the prd_end_dt by taking the lead of prd_start_dt and subtracting 1 day from it
cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) - 1 as date) as prd_end_dt -- handling null values in prd_end_dt by replacing them with 9999-12-31
from bronze.crm_prd_info;


