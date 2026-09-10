
-- Inserting the cleaned and transformed data into the silver layer of the data warehouse

Insert into silver.crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_material_status,
    cst_gndr,
    cst_created_date
)

select 
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,
    case 
        when upper(trim(cst_material_status)) = 'M' then 'Married' 
        when upper(trim(cst_material_status)) = 'S' then 'Single' 
        else 'N/A' 
        end as cst_marital_status, -- Normalizing the marital status values to 'Married', 'Single', or 'N/A'
    case 
        when upper(trim(cst_gndr)) = 'M' then 'Male' 
        when upper(trim(cst_gndr)) = 'F' then 'Female' 
        else 'N/A' 
        end as cst_gender, -- Normalizing the gender values to 'Male', 'Female', or 'N/A'
    cst_created_date
from (
select 
    *,
    row_number() over (partition by cst_id order by cst_created_date desc) as row_num
    from bronze.crm_cust_info
    )t
where row_num = 1; -- selecting the most recent record for each customer based on cst_created_date



select * from silver.crm_cust_info;
