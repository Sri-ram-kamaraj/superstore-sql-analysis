-- ===========================================
-- PRODUCT ANALYSIS
-- ===========================================

-- 1. Most Profitable Product in Each Category

WITH profitable_product AS (
    SELECT
        p.Category,
        p.`Product Name`,
        ROUND(SUM(o.Profit),2) AS total_profit
    FROM orders_fact o
    INNER JOIN products_dim p
        ON o.`Product ID` = p.`Product ID`
    GROUP BY
        p.Category,
        p.`Product Name`
),
product_rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY Category
               ORDER BY total_profit DESC
           ) AS product_rank
    FROM profitable_product
)
SELECT *
FROM product_rank
WHERE product_rank = 1;


-- 2. Highest Profit Category in the Company

WITH category_profit AS (
    SELECT
        p.Category,
        ROUND(SUM(o.Profit),2) AS total_profit
    FROM orders_fact o
    INNER JOIN products_dim p
        ON o.`Product ID` = p.`Product ID`
    GROUP BY
        p.Category
),
category_rank AS (
    SELECT *,
           DENSE_RANK() OVER (
               ORDER BY total_profit DESC
           ) AS category_rank
    FROM category_profit
)
SELECT *
FROM category_rank
WHERE category_rank = 1;
