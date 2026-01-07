--QUESTION - 6/ ANSWER> 
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');

INSERT INTO Products VALUES
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel : The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);

INSERT INTO Customers VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');


INSERT INTO Orders VALUES
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);



--Question -- 7 / answer

SELECT 
    c.CustomerName,
    c.Email,
    COUNT(o.OrderID) AS TotalNumberOfOrders
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerName, 
    c.Email
ORDER BY 
    c.CustomerName;


--Question  - 8/ Answer 

SELECT 
    p.ProductName,
    p.Price,
    p.StockQuantity,
    c.CategoryName
FROM Products p
JOIN Categories c
    ON p.CategoryID = c.CategoryID
ORDER BY 
    c.CategoryName,
    p.ProductName;


--Question - 9 Answer

WITH RankedProducts AS (
    SELECT
        c.CategoryName,
        p.ProductName,
        p.Price,
        ROW_NUMBER() OVER (
            PARTITION BY c.CategoryName
            ORDER BY p.Price DESC
        ) AS rn
    FROM Products p
    JOIN Categories c
        ON p.CategoryID = c.CategoryID
)
SELECT
    CategoryName,
    ProductName,
    Price
FROM RankedProducts
WHERE rn <= 2
ORDER BY CategoryName, Price DESC;


--Question 10 / Answer

--TASK 1

SELECT 
    c.first_name,
    c.last_name,
    c.email,
    SUM(p.amount) AS total_spent
FROM Customer c
JOIN Payment p
    ON c.Customer_id = p.Customer_id
GROUP BY 
    c.Customer_id, c.first_name, c.last_name, c.email
ORDER BY 
    total_spent DESC
LIMIT 5;

--TASK 2

SELECT 
    cat.name AS category_name,
    COUNT(r.rental_id) AS rental_count
FROM category cat
JOIN film_category fc
    ON cat.category_id = fc.category_id
JOIN film f
    ON fc.film_id = f.film_id
JOIN inventory i
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY 
    cat.name
ORDER BY 
    rental_count DESC
LIMIT 3;

--TASK 3
SELECT 
    s.store_id,
    COUNT(i.inventory_id) AS total_films,
    COUNT(CASE WHEN r.rental_id IS NULL THEN 1 END) AS never_rented
FROM store s
JOIN inventory i
    ON s.store_id = i.store_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY 
    s.store_id;

--TASK 4

SELECT 
    MONTH(payment_date) AS month,
    SUM(amount) AS total_revenue
FROM payment
WHERE YEAR(payment_date) = 2023
GROUP BY 
    MONTH(payment_date)
ORDER BY 
    month;


--TASK 5

SELECT 
    c.first_name,
    c.last_name,
    c.email,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email
HAVING 
    COUNT(r.rental_id) > 10;

