-- Возвращает список клиентов (имя и фамилия) с наибольшей общей суммой заказов.
SELECT c.FirstName, c.LastName
FROM Customers AS c
INNER JOIN (
    SELECT o.CustomerID, SUM(o.TotalAmount) AS TotalOrderAmount
    FROM Orders AS o
    GROUP BY o.CustomerID
) AS subq
ON c.CustomerID = subq.CustomerID
ORDER BY subq.TotalOrderAmount DESC;

-- Для каждого клиента из пункта 1 выводит список его заказов (номер заказа и общая сумма) в порядке убывания общей суммы заказов.
WITH TopCustomer AS (
    SELECT o.CustomerID, SUM(o.TotalAmount) AS TotalOrderAmount
    FROM Orders AS o
    GROUP BY o.CustomerID
    ORDER BY TotalOrderAmount DESC
)
SELECT o.OrderID, o.TotalAmount
FROM Orders AS o
WHERE o.CustomerID = (SELECT CustomerID FROM TopCustomer)
ORDER BY o.TotalAmount DESC;

-- Выводит только тех клиентов, у которых общая сумма заказов превышает среднюю общую сумму заказов всех клиентов.
WITH AvgOrderAmounts AS (
    SELECT o.CustomerID, AVG(o.TotalAmount) AS AvgOrderAmount
    FROM Orders AS o
    GROUP BY o.CustomerID
)

SELECT c.FirstName, c.LastName
FROM Customers AS c
INNER JOIN AvgOrderAmounts AS a
ON c.CustomerID = a.CustomerID
WHERE a.AvgOrderAmount > (SELECT AVG(AvgOrderAmount) FROM AvgOrderAmounts);
