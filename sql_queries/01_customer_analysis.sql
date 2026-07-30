-- ===========================================
-- CUSTOMER ANALYSIS
-- ===========================================

-- 1. Top Customer by Sales in Each Region

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


-- 2. Top 3 Customers by Sales in Each Region

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
)
SELECT
    `Customer Name`,
    Region,
    total_sales,
    ROW_NUMBER() OVER (
        PARTITION BY Region
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_sales;


-- 3. Top Customer by Profit in Each Region

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
