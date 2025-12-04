-- ============================================================================
-- View Name: gold.dim_products
-- Description:
--     This view creates the Product Dimension table in the Gold layer.
--     It assigns a surrogate key using ROW_NUMBER() and combines product
--     information from the Silver product table with category details from
--     the Silver category table.
--     Only active (non-historical) products are included by filtering out
--     records where prd_end_dt is NOT NULL.
--     The view provides a clean, enriched product dimension for analytics
--     and reporting.
-- ============================================================================

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance AS maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL -- Filter out all historical data.
