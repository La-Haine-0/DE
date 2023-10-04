WITH OrderSummary AS (
    SELECT
        o.CustomerID,
        SUM(o.TotalAmount) AS TotalOrderAmount,
        SUM(od.Quantity) AS TotalOrderedProducts,
        AVG(pr.Rating) AS AvgProductRating,
        CASE
            WHEN o.OrderDate >= NOW() - INTERVAL '1 month' THEN 'Новые заказы'
            ELSE 'Старые заказы'
        END AS OrderCategory
    FROM
        Orders AS o
    INNER JOIN OrderDetails AS od ON o.OrderID = od.OrderID
    LEFT JOIN ProductReviews AS pr ON od.ProductID = pr.ProductID AND o.CustomerID = pr.CustomerID
    GROUP BY
        o.CustomerID,
        OrderCategory
)

SELECT
    c.CustomerID AS CustomerID,
    c.FirstName AS FirstName,
    c.LastName AS LastName,
    os.OrderCategory AS OrderCategory,
    SUM(os.TotalOrderAmount) AS TotalOrderAmount,
    SUM(os.TotalOrderedProducts) AS TotalOrderedProducts,
    AVG(os.AvgProductRating) AS AvgProductRating
FROM
    Customers AS c
LEFT JOIN OrderSummary AS os ON c.CustomerID = os.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    os.OrderCategory
ORDER BY
    c.CustomerID;
