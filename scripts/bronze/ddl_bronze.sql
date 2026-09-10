/*
  This script is to create a bronze layer tables and load data into it.
  Here we are droping the tables if existed and then recreating it.
*/


if object_id('bronze.crm_cust_info', 'U') is not null 
drop table bronze.crm_cust_info;


create table bronze.crm_cust_info (
    cst_id int,
    cst_key nvarchar(50),
    cst_firstname nvarchar(50),
    cst_lastname nvarchar(50),
    cst_material_status nvarchar(50),
    cst_gndr nvarchar(50),
    cst_created_date date
);

if object_id('bronze.crm_prd_info', 'U') is not null 
drop table bronze.crm_prd_info;


create table bronze.crm_prd_info (
    prd_id int,
    prd_key nvarchar(50),
    prd_nm nvarchar(50),
    prd_cost int,
    prd_line nvarchar(50),
    prd_start_dt date,
    prd_end_dt date
);

if object_id('bronze.crm_sales_details', 'U') is not null 
drop table bronze.crm_sales_details;

create table bronze.crm_sales_details (
    sls_ord_num nvarchar(50),
    sla_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
);

if object_id('bronze.erp_cust_az12', 'U') is not null 
drop table bronze.erp_cust_az12;

create table bronze.erp_cust_az12 (
    cid nvarchar(50),
    bdate date,
    gen nvarchar(50)
);

if object_id('bronze.erp_loc_a101', 'U') is not null 
drop table bronze.erp_loc_a101;

create table bronze.erp_loc_a101 (
    cid nvarchar(50),
    cntry NVARCHAR(50)
);

if object_id('bronze.erp_px_cat_g1v2', 'U') is not null 
drop table bronze.erp_px_cat_g1v2;

create table bronze.erp_px_cat_g1v2 (
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintenance nvarchar(50)
);

execute bronze.load_bronze;

GO


-- Store Procedure to upload data to bronze layer

create or alter procedure bronze.load_bronze AS 
BEGIN

    Declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
    
    BEGIN TRY
        set @batch_start_time = getdate();
        print '==============================================================';
        print 'Loading data to bronze layer of data warehouse';
        print '==============================================================';



        print '----------------------------------------------------------------';
        print 'Uploading data to bronze layer of customer information';
        print '----------------------------------------------------------------';

        set @start_time = getdate();
        Truncate table bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        set @end_time = getdate();
        print '>>> Time taken to upload data to bronze.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        print '----------------------------------------------------------------';
        print 'Uploading data to bronze layer of product information';
        print '----------------------------------------------------------------';

        set @start_time = getdate();
        print '>>> Truncating table bronze.crm_prd_info';
        Truncate table bronze.crm_prd_info;

        print '>>> inserting data to bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        set @end_time = getdate();
        print '>>> Time taken to upload data to bronze.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        print '----------------------------------------------------------------';
        print 'Uploading data to bronze layer of sales details';
        print '----------------------------------------------------------------';

        set @start_time = getdate();
        print '>>> Truncating table bronze.crm_sales_details';
        Truncate table bronze.crm_sales_details;

        print '>>> inserting data to bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        set @end_time = getdate();
        print '>>> Time taken to upload data to bronze.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        
        print '----------------------------------------------------------------';
        print 'Uploading data to bronze layer of customer information from erp system';
        print '----------------------------------------------------------------';

        set @start_time = getdate();
        print '>>> Truncating table bronze.erp_cust_az12';
        truncate table bronze.erp_cust_az12;

        print '>>> inserting data to bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/datasets/source_erp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
        
        set @end_time = getdate();
        print '>>> Time taken to upload data to bronze.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';


        print '----------------------------------------------------------------';
        print 'Uploading data to bronze layer of location information from erp system';
        print '----------------------------------------------------------------';

        set @start_time = getdate();
        print '>>> Truncating table bronze.erp_loc_a101';
        truncate table bronze.erp_loc_a101; 

        print '>>> inserting data to bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/datasets/source_erp/loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        set @end_time = getdate();
        print '>>> Time taken to upload data to bronze.erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        print '----------------------------------------------------------------';
        print 'Uploading data to bronze layer of product information from erp system';
        print '----------------------------------------------------------------';

        set @start_time = getdate();
        print '>>> Truncating table bronze.erp_px_cat_g1v2';
        truncate table bronze.erp_px_cat_g1v2;

        print '>>> inserting data to bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/datasets/source_erp/px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );

        set @end_time = getdate();
        print '>>> Time taken to upload data to bronze.erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';

        set @batch_end_time = getdate();
        print '==============================================================';
        print 'Total time taken to upload data to bronze layer of data warehouse: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(10)) + ' seconds';
        print '==============================================================';
    END TRY
    BEGIN CATCH
        print '==============================================================';
        print 'Error Occured while loading data to bronze layer of data warehouse';
        print '==============================================================';
        print 'Error Message: ' +ERROR_MESSAGE();
        print 'Error Number: ' +CAST(ERROR_NUMBER() AS NVARCHAR(10));
    End CATCH

END;
GO
