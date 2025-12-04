-- crm_cust_info

SELECT *
FROM bronze.crm_cust_info;

-- Check for nulls or duplicates in primary key
-- Expectation: No result

SELECT cst_id, COUNT(*) AS Id_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL ;

-- Check for unwanted spaces
-- Expectation: No result
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data standardization & consistency
SELECT DISTINCT(cst_gndr)
FROM bronze.crm_cust_info








-- crm_prd_info

SELECT *
FROM bronze.crm_prd_info;

-- Check for nulls or duplicates in primary key
-- Expectation: No result

SELECT prd_id, COUNT(*) AS Id_count
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL ;

-- Check for unwanted spaces
-- Expectation: No result
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for nulls or negative numbers
-- Expectation: No result

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data standardization & consistency
SELECT DISTINCT(prd_line)
FROM bronze.crm_prd_info








-- crm_sales_details

SELECT *
FROM bronze.crm_sales_details
WHERE sls_quantity != 1;


-- Check for Invalid Dates
SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE 
	sls_due_dt <= 0
	OR LEN(sls_due_dt) != 8
	OR sls_due_dt > 20500101
	OR sls_due_dt < 19000101;



SELECT *
FROM bronze.crm_sales_details
WHERE 
	sls_order_dt > sls_ship_dt
	OR sls_order_dt > sls_due_dt;


-- Check Data Consistency: between sales, price, and quantity
-- >> Sales = Price * Quantity
-- >> Values must not be Null, Zero, or Negative

SELECT 
	sls_sales AS old_sales, sls_price AS old_price,  sls_quantity,
	CASE	
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != ABS(sls_price * sls_quantity) THEN ABS(sls_price * sls_quantity)
		ELSE sls_sales
	END sls_sales,
	CASE	
		WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details
WHERE 
	sls_quantity * sls_price != sls_sales 
	OR sls_quantity IS NULL OR sls_price IS NULL OR sls_sales IS NULL
	OR sls_quantity <= 0 OR sls_price <= 0 OR sls_sales <= 0;







-- erp_cust_az12

SELECT *
FROM bronze.erp_cust_az12;

--Check invalid dates

SELECT 
	DISTINCT(bdate)
FROM 
	bronze.erp_cust_az12
WHERE
	bdate < '1925-01-01' OR bdate > GETDATE();


-- Data Standardization & Consistency

SELECT 
	DISTINCT(gen)
FROM 
	bronze.erp_cust_az12;







-- erp_loc_a101

SELECT *
FROM bronze.erp_loc_a101;

SELECT cid
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

SELECT cst_key FROM silver.crm_cust_info

-- Country Checks

SELECT 
	DISTINCT(cntry) AS old_cntry,
	CASE	
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN cntry = '' OR cntry IS NULL THEN 'n/a' 
		ELSE cntry
	END AS cntry
FROM 
	bronze.erp_loc_a101
ORDER BY cntry;








-- erp_px_cat_g1v2

SELECT 
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2;

-- Check unwanted spaces

SELECT 
	cat
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat;

SELECT 
	subcat
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(subcat) != subcat;

SELECT 
	maintenance
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(maintenance) != maintenance;


-- Data Standardization

SELECT 
	DISTINCT cat
FROM 
	bronze.erp_px_cat_g1v2;


SELECT 
	DISTINCT subcat
FROM 
	bronze.erp_px_cat_g1v2;


SELECT 
	DISTINCT maintenance
FROM 
	bronze.erp_px_cat_g1v2;
