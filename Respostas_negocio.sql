-- Consulta 1: Listar usuários que fazem aniversário hoje e têm mais de 1500 vendas em janeiro de 2020
SELECT 
    C.name,
    COUNT(O.order_id) AS total_sales
FROM Order O
LEFT JOIN Customer C ON C.customer_id = O.seller_id
WHERE 
    FORMAT(C.birth_date, 'MM-dd') = FORMAT(GETDATE(), 'MM-dd') 
    AND FORMAT(O.date_purchase, 'yyyy-MM') = '2020-01'
GROUP BY C.customer_id, C.name
HAVING COUNT(O.order_id) > 1500;



-- Consulta 2: Top 5 vendedores por mês em 2020 na categoria "Celulares"
WITH MonthlySales AS (
    SELECT
        FORMAT(O.date_purchase, 'yyyy-MM') AS year_month,
        C.name AS seller_name,
        COUNT(O.order_id) AS total_sales,
        SUM(O.quantity) AS total_items_sold,
        SUM(O.price) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY FORMAT(O.date_purchase, 'yyyy-MM') 
            ORDER BY SUM(O.price) DESC
        ) AS row_num
    FROM [Order] O
    JOIN Customer C ON O.seller_id = C.customer_id
    JOIN Item I ON O.item_id = I.item_id
    JOIN Category CA ON I.category_id = CA.category_id
    WHERE 
        YEAR(O.date_purchase) = 2020
        AND CA.name = 'Celulares'
    GROUP BY 
        FORMAT(O.date_purchase, 'yyyy-MM'),
        C.name
)
SELECT 
    year_month,
    seller_name,
    total_sales,
    total_items_sold,
    total_revenue
FROM MonthlySales
WHERE row_num <= 5
ORDER BY year_month, total_revenue DESC;




-- Stored Procedure para inserir dados na tabela Daily_Item_State
CREATE PROCEDURE Populate_Daily_Item_State AS
BEGIN
    INSERT INTO Daily_Item_State (item_id, price, is_enabled, snapshot_date)
    SELECT 
        I.item_id, 
        I.price, 
        I.is_enabled, 
        GETDATE() AS snapshot_date
    FROM Item I;
END;
