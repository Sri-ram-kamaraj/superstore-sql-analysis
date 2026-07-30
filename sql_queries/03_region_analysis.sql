-- ===========================================
-- REGION ANALYSIS
-- ===========================================

-- 1. Highest Sales Customer in Each Region

WITH customer_sales AS (
    SELECT
        c.`Customer Name`,
        c.Region,
        SUM(o.Sales) AS total_sales
    FROM orders_fact o
    INNER JOIN customers_dim c
        ON o.`Customer ID` = c.`Customer ID`
    GROUP BY
        c.`Customer Name`,
        c.Region
),
ranked_sales AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY Region
               ORDER BY total_sales DESC
           ) AS sales_rank
    FROM customer_sales
)
SELECT *
FROM ranked_sales
WHERE sales_rank = 1;


-- 2. Highest Profit Customer in Each Region

WITH customer_profit AS (
    SELECT
        c.`Customer Name`,
        c.Region,
        SUM(o.Profit) AS total_profit
    FROM orders_fact o
    INNER JOIN customers_dim c
        ON o.`Customer ID` = c.`Customer ID`
    GROUP BY
        c.`Customer Name`,
        c.Region
),
ranked_profit AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY Region
               ORDER BY total_profit DESC
           ) AS profit_rank
    FROM customer_profit
)
SELECT *
FROM ranked_profit
WHERE profit_rank = 1;


-- 3. Category Contribution (%) by Region

WITH sales_category AS (
    SELECT
        c.Region,
        p.Category,
        SUM(o.Sales) AS total_sales
    FROM orders_fact o
    INNER JOIN customers_dim c
        ON o.`Customer ID` = c.`Customer ID`
    INNER JOIN products_dim p
        ON o.`Product ID` = p.`Product ID`
    GROUP BY
        c.Region,
        p.Category
),
ranked_sales AS (
    SELECT *,
           SUM(total_sales) OVER(PARTITION BY Region) AS region_total
    FROM sales_category
)
SELECT
    Region,
    Category,
    total_sales,
    ROUND((total_sales / region_total) * 100, 2) AS contribution_percent
FROM ranked_sales;
