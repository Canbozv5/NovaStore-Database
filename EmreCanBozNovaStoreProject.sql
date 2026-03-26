/* 1. DATABASE OLUŞTURMA */

CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO


/* 2. TABLO OLUŞTURMA */

CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


/* 3. VERİ EKLEME */

INSERT INTO Categories (CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');


INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
('Laptop', 25000, 10, 1),
('Kulaklık', 1500, 25, 1),
('T-Shirt', 300, 40, 2),
('Kot Pantolon', 900, 15, 2),
('Roman Kitabı', 120, 50, 3),
('Kişisel Gelişim Kitabı', 150, 35, 3),
('Parfüm', 800, 20, 4),
('Yüz Kremi', 350, 18, 4),
('Kahve Makinesi', 2200, 8, 5),
('Masa Lambası', 450, 12, 5);


INSERT INTO Customers (FullName, City, Email) VALUES
('Ahmet Yılmaz', 'İstanbul', 'ahmet@gmail.com'),
('Ayşe Demir', 'Ankara', 'ayse@gmail.com'),
('Mehmet Kaya', 'İzmir', 'mehmet@gmail.com'),
('Fatma Şahin', 'Bursa', 'fatma@gmail.com'),
('Ali Can', 'Antalya', 'ali@gmail.com');


INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2026-02-01', 25000),
(2, '2026-02-03', 1500),
(3, '2026-02-05', 120),
(1, '2026-02-10', 2200),
(4, '2026-02-12', 800),
(5, '2026-02-15', 450),
(2, '2026-02-18', 300),
(3, '2026-02-20', 900);


INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1,1,1),
(2,2,1),
(3,5,1),
(4,9,1),
(5,7,1),
(6,10,1),
(7,3,1),
(8,4,1);


/* 4. SQL SORGULARI */

/* Stok 20'den az ürünler */

SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;


/* Hangi müşteri hangi tarihte sipariş vermiş */

SELECT 
Customers.FullName,
Customers.City,
Orders.OrderDate,
Orders.TotalAmount
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;


/* Ahmet Yılmaz'ın aldığı ürünler */

SELECT 
Customers.FullName,
Products.ProductName,
Products.Price,
Categories.CategoryName
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Customers.FullName = 'Ahmet Yılmaz';


/* Kategori başına ürün sayısı */

SELECT 
Categories.CategoryName,
COUNT(Products.ProductID) AS ProductCount
FROM Categories
LEFT JOIN Products
ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;


/* En çok harcama yapan müşteri */

SELECT 
Customers.FullName,
SUM(Orders.TotalAmount) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FullName
ORDER BY TotalSpent DESC;


/* Siparişlerin üzerinden kaç gün geçmiş */

SELECT 
OrderID,
OrderDate,
DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysAgo
FROM Orders;


/* 5. VIEW OLUŞTURMA */

CREATE VIEW vw_SiparisOzet AS
SELECT 
Customers.FullName,
Orders.OrderDate,
Products.ProductName,
OrderDetails.Quantity
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID;


/* 6. BACKUP KOMUTU */

BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Users\canca\Desktop\Backup\NovaStoreDB.bak';