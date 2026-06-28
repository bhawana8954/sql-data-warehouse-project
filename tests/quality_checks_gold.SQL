/*
==============================================================================
Quality Checks
==============================================================================
Script Purpose:
	This script performs quality check to validate the integrity, consistency
	and accuracy of the Gold layer. These checks ensures:
	- Uniqueness of surrogate key in dimension tables.
	- Referential integrity between fact and dimension tables.
	- Validation of relationships in data model for analytical purposes.

Usage Notes:
	- Run these checks after data loading Silver layer.
	- Investigate and resolve any descrepancies found during the checks.
==============================================================================
*/

-- ======================================================================;
-- Checking 'gold.fact_sales';
-- ======================================================================;
-- Check for uniqueness of Product key in gold.dim_products
-- Expectation: No results
SELECT
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ======================================================================;
-- Checking 'gold.fact_sales';
-- ======================================================================;
-- Check the data model connectivity between fact and dimensions
SELECT
	*
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c 
	ON c.customer_key = f.product_key
LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
WHERE p.product_key IS NULL
	OR c.customer_key IS NULL;
