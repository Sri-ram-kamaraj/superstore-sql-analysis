-- ===========================================
-- WINDOW FUNCTION EXAMPLES
-- ===========================================

-- ROW_NUMBER()

SELECT
    c.`Customer Name`,
    c.Region,
    SUM(o.Sales) AS total_sales,
    ROW_NUMBER() OVER(
        PARTITION BY c.Region
        ORDER BY SUM(o.Sales) DESC
    ) AS row_num
FROM orders_fact o
INNER JOIN customers_dim c
    ON o.`Customer ID` = c.`Customer ID`
GROUP BY
    c.`Customer Name`,
    c.Region;


-- DENSE_RANK()

SELECT
    c.`Customer Name`,
    c.Region,
    SUM(o.Sales) AS total_sales,
    DENSE_RANK() OVER(
        PARTITION BY c.Region
        ORDER BY SUM(o.Sales) DESC
    ) AS sales_rank
FROM orders_fact o
INNER JOIN customers_dim c
    ON o.`Customer ID` = c.`Customer ID`
GROUP BY
    c.`Customer Name`,
    c.Region;


-- LAG()

SELECT
    `Order Date`,
    Sales,
    LAG(Sales) OVER(
        ORDER BY `Order Date`
    ) AS previous_sales
FROM orders_fact;


-- LEAD()

SELECT
    `Order Date`,
    Sales,
    LEAD(Sales) OVER(
        ORDER BY `Order Date`
    ) AS next_sales
FROM orders_fact;


-- FIRST_VALUE()

SELECT
    c.Region,
    c.`Customer Name`,
    SUM(o.Sales) AS total_sales,
    FIRST_VALUE(c.`Customer Name`) OVER(
        PARTITION BY c.Region
        ORDER BY SUM(o.Sales) DESC
    ) AS highest_sales_customer
FROM orders_fact o
INNER JOIN customers_dim c
    ON o.`Customer ID` = c.`Customer ID`
GROUP BY
    c.Region,
    c.`Customer Name`;
