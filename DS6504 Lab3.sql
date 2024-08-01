-- Create a new database

CREATE database Lab3
Use Lab3

DROP TABLE IF EXISTS Category;
CREATE table Category
(
	CategoryID INT NOT NULL
		CONSTRAINT PK_Category
		PRIMARY KEY,
	CategoryName VARCHAR(30) NOT NULL
)

CREATE table Products
(
	ProductID INT NOT NULL
		CONSTRAINT PK_Products
		PRIMARY KEY,
	ProductName VARCHAR(30) NOT NULL,
	ProductPrice FLOAT NOT NULL,
	ProductCategoryID INT
		CONSTRAINT FK_Product_Category
		REFERENCES Category(CategoryID)
)

INSERT INTO Category 
VALUES (1, 'Beverages'),
		(2, 'Dry food'), 
		(3, 'Produce'), 
		(4, 'Candy'), 
		(5, 'Frozen food'), 
		(6, 'Chilled food');

INSERT INTO Products
VALUES (1, 'Cola', 3.5, 1),
		(2, 'Fanta', 3.5, 1),
		(3, 'Water', 2, 1),
		(4, 'Chips', 3.4, 2),
		(5, 'Musli bar', 5, 2),
		(6, 'Nuts', 3.2, 2),
		(7, 'Onions', 1.59, 3),
		(8, 'Lettuce', 2.35, 3),
		(9, 'Carrots', 1.90, 3),
		(10, 'Marshmallows', 6.5, 4),
		(11, 'Sour lollies', 4.70, 4),
		(12, 'Lollipops', 1.40, 4),
		(13, 'Ice cream', 3.45, 5),
		(14, 'Burger patties', 10.25, 5),
		(15, 'Lasagna', 25, 5),
		(16, 'Milk', 3.56, 6),
		(17, 'Cheese', 7.60, 6),
		(18, 'Hummus', 5, 6);


-- change the 'ProductPrice' data type to 'money'
ALTER TABLE Products
ALTER COLUMN ProductPrice money;
-- check the data type https://www.mssqltips.com/sqlservertutorial/183/information-schema-columns/
select * from information_schema.columns WHERE COLUMN_NAME = 'ProductPrice';

-- view the products that cost between $5 and $15
-- using FORMAT to show the currency symbol https://www.mssqltips.com/sqlservertip/7023/sql-format-currency-options/
-- order by price ascending
SELECT ProductName as 'Product Name', FORMAT(ProductPrice, 'C') as 'Price'
FROM Products 
WHERE ProductPrice BETWEEN 5 AND 15
ORDER BY ProductPrice;

-- Show the number of products in the 'Dry Food' category
-- by joining the category table on the categoryID column
-- and filtering for the 'Dry Food' category
SELECT COUNT(ProductID) AS 'Number of Products in Dry Food'
FROM Products
JOIN Category ON Products.ProductCategoryID = Category.CategoryID
WHERE CategoryName = 'Dry Food';

-- add a column to the Products table for inventory
ALTER TABLE Products
ADD Stock int

-- Insert data into the newly created stock column
-- using UPDATE and CASE https://stackoverflow.com/questions/25674737/update-multiple-rows-with-different-values-in-one-query-in-mysql
UPDATE Products 
SET Stock = (CASE WHEN ProductName = 'Cola' THEN 1
				  WHEN ProductName = 'Fanta'THEN 10
				  WHEN ProductName = 'Water' THEN 67
			      WHEN ProductName = 'Chips' THEN 20
		          WHEN ProductName = 'Musli bar' THEN 25
		          WHEN ProductName = 'Nuts' THEN 80
			      WHEN ProductName = 'Onions'THEN 37
		          WHEN ProductName = 'Lettuce' THEN 25
		          WHEN ProductName = 'Carrots' THEN 55
		          WHEN ProductName = 'Marshmallows' THEN 41
		          WHEN ProductName = 'Sour lollies' THEN 66
				  WHEN ProductName = 'Lollipops' THEN 75
		          WHEN ProductName = 'Ice cream' THEN 35
		          WHEN ProductName = 'Burger patties' THEN 100
		          WHEN ProductName = 'Lasagna' THEN 0
		          WHEN ProductName = 'Milk' THEN 42
		          WHEN ProductName = 'Cheese' THEN 33
		          WHEN ProductName = 'Hummus' THEN 0
			END);
		
-- Calculate total stock value by category
-- start by calculating stock value for each product
SELECT CategoryName, ProductName, 
	 FORMAT((ProductPrice * Stock), 'C')  AS 'Stock Value'
FROM Products
JOIN Category ON Category.CategoryID = Products.ProductCategoryID;

-- Sum the values and group by categories
SELECT CategoryName,
	FORMAT(SUM(ProductPrice * Stock), 'C') as 'Category Stock Value'
FROM Products
JOIN Category ON Category.CategoryID = Products.ProductCategoryID
GROUP BY CategoryName;




