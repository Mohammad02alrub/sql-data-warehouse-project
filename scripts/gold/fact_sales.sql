-- ============================================================================
-- View Name: gold.fact_sales
-- Description:
--     This view creates the Fact Sales table in the Gold layer by joining
--     cleaned Silver sales data with the Product and Customer dimension tables.
--     It selects key business metrics such as order dates, sales amount,
--     quantity, and price, and enriches the fact records with product_key
--     and customer_key for reporting and analysis.
-- ============================================================================

CREATE VIEW gold.fact_sales AS

SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers AS cu
ON sd.sls_cust_id = cu.customer_id
