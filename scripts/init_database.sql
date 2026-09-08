/* 

========================================================================================
Create Database and Schemas
========================================================================================

Script Purpose :

This Scripts creates a Database called as "Datawarehouse" but before creating it, checks if the name already exist or not, if the database already exist we will drop it and 
create the new database. Here we are creating three schemas called as Bronze, Silver and Gold.
*/

-- Use master database
use master;

-- cheack if the database exists and drop it if it does
if exists (select * from sys.databases where name = 'Datawarehouse')
begin
    alter database Datawarehouse set single_user with rollback immediate;
    drop database Datawarehouse;
end
GO


-- create the Datawarehouse database
CREATE DATABASE Datawarehouse;

-- use the Datawarehouse database
use Datawarehouse;

--- schema creation

-- create schema for each layer

create schema Bronze;
GO
create schema Silver;
GO
create schema Gold;
GO


