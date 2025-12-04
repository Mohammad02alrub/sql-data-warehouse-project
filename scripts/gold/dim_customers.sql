-- ============================================================================
-- View Name: gold.dim_customers
-- Description:
--     This view creates the Customer Dimension table in the Gold layer.
--     It assigns a surrogate key using ROW_NUMBER() and enriches customer
--     records from the Silver CRM table with demographic and location data
--     from supporting Silver ERP tables.
--     The gender field is standardized by using CRM gender when available,
--     otherwise falling back to ERP data.
--     This dimension provides a unified and analytics-ready customer profile
--     for reporting and downstream fact tables.
-- ============================================================================

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE	
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM 
	silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid;
