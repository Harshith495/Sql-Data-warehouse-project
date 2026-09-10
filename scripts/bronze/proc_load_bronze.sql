/*
Here in this file i am loading the data to the created tables from the csv files.
I am using BULK INSERT for inserting the data to the tables, but before that we are truncating the data so we don't duplicate
information if we the the queries multiple times.
*/

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
