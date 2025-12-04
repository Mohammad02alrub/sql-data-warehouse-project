/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- crm_cust_info
SELECT *
FROM silver.crm_cust_info;


-- Check for nulls or duplicates in primary key
-- Expectation: No result

SELECT cst_id, COUNT(*) AS Id_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check for unwanted spaces
-- Expectation: No result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data standardization & consistency
SELECT DISTINCT(cst_gndr)
FROM silver.crm_cust_info;






-- crm_prd_info

SELECT *
FROM silver.crm_prd_info;

-- Check for nulls or duplicates in primary key
-- Expectation: No result

SELECT prd_id, COUNT(*) AS Id_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL ;

-- Check for unwanted spaces
-- Expectation: No result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for nulls or negative numbers
-- Expectation: No result

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data standardization & consistency
SELECT DISTINCT(prd_line)
FROM silver.crm_prd_info;







-- crm_sales_details

SELECT *
FROM silver.crm_sales_details;


-- Check for Invalid Dates
SELECT *
FROM silver.crm_sales_details
WHERE 
	sls_order_dt > sls_ship_dt
	OR sls_order_dt > sls_due_dt;


-- Check Data Consistency: between sales, price, and quantity
-- >> Sales = Price * Quantity
-- >> Values must not be Null, Zero, or Negative

SELECT 
	sls_quantity, sls_price,  sls_sales
FROM 
	silver.crm_sales_details

WHERE 
	sls_quantity * sls_price != sls_sales 
	OR sls_quantity IS NULL OR sls_price IS NULL OR sls_sales IS NULL
	OR sls_quantity <= 0 OR sls_price <= 0 OR sls_sales <= 0;






-- erp_cust_az12

SELECT *
FROM silver.erp_cust_az12;

--Check invalid dates

SELECT 
	DISTINCT(bdate)
FROM 
	silver.erp_cust_az12
WHERE
	bdate < '1925-01-01' OR bdate > GETDATE();


-- Data Standardization & Consistency

SELECT 
	DISTINCT(gen)
FROM 
	silver.erp_cust_az12;






-- erp_loc_a101

SELECT *
FROM silver.erp_loc_a101;

SELECT cid
FROM silver.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);


-- Country Checks

SELECT 
	DISTINCT(cntry)
FROM 
	silver.erp_loc_a101
ORDER BY cntry;







-- erp_px_cat_g1v2

SELECT *
FROM silver.erp_px_cat_g1v2;
