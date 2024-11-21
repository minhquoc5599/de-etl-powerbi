USE DW
GO
-- Create Dimension
CREATE TABLE Dim_Year (
	YearKey NVARCHAR(4) NOT NULL PRIMARY KEY,
	Year INT NOT NULL
)

CREATE TABLE Dim_Month (
	MonthKey NVARCHAR(6) NOT NULL PRIMARY KEY,
	YearKey NVARCHAR(4) NOT NULL,
	Month INT NOT NULL
)

ALTER TABLE Dim_Month
ADD CONSTRAINT FK_Dim_Month_Dim_Year_YearKey
FOREIGN KEY (YearKey) REFERENCES Dim_Year(YearKey)

CREATE TABLE Dim_Date (
	DateKey NVARCHAR(8) NOT NULL PRIMARY KEY,
	MonthKey NVARCHAR(6) NOT NULL,
	Date INT NOT NULL
)

ALTER TABLE Dim_Date
ADD CONSTRAINT FK_Dim_Date_Dim_Month_MonthKey
FOREIGN KEY (MonthKey) REFERENCES Dim_Month(MonthKey)

CREATE TABLE Dim_SalesPerson (
	BusinessEntityID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Title NVARCHAR(8) NULL,
	FullName NVARCHAR(500) NULL,
	NationalIDNumber NVARCHAR(15) NULL,
	JobTitle NVARCHAR(50) NULL,
	BirthDate DATE NULL,
	Gender NCHAR(1) NULL,
	HireDate DATE NULL
)

CREATE TABLE Dim_Territory (
	TerritoryID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Name NVARCHAR(50) NULL,
	CountryRegionCode NVARCHAR(3) NULL,
	[Group] NVARCHAR(50) NULL
)

CREATE TABLE Dim_ProductCategory (
	ProductCategoryID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL
)	

CREATE TABLE Dim_ProductSubcategory (
	ProductSubcategoryID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	ProductCategoryID INT NOT NULL,
	Name NVARCHAR(50) NOT NULL
)

ALTER TABLE Dim_ProductSubcategory
ADD CONSTRAINT FK_Dim_ProductSubcategory_Dim_ProductCategory_ProductCategoryID
FOREIGN KEY (ProductCategoryID) REFERENCES Dim_ProductCategory(ProductCategoryID)

CREATE TABLE Dim_Product (
	ProductID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL,
	ProductNumber NVARCHAR(25) NOT NULL,
	StandardCost MONEY NOT NULL,
	ListPrice MONEY NOT NULL,
	Weight DECIMAL(8, 2) NULL,
	ProductSubcategoryID INT NOT NULL
)

ALTER TABLE Dim_Product
ADD CONSTRAINT FK_Dim_Product_Dim_ProductSubcategory_ProductSubcategoryID
FOREIGN KEY (ProductSubcategoryID) REFERENCES Dim_ProductSubcategory(ProductSubcategoryID)

--- Create Fact
CREATE TABLE Fact_SalesOrder (
	ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	DateKey NVARCHAR(8) NOT NULL,
	TerritoryID INT NULL,
	SalesPersonID INT NULL,
	Revenue DECIMAL(18, 4) NOT NULL,
	NumberOrder INT NOT NULL
)

ALTER TABLE Fact_SalesOrder
ADD CONSTRAINT FK_Fact_SalesOrder_Dim_Date_DateKey
FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey)

ALTER TABLE Fact_SalesOrder
ADD CONSTRAINT FK_Fact_SalesOrder_Dim_SalesPerson_SalesPersonID
FOREIGN KEY (SalesPersonID) REFERENCES Dim_SalesPerson(BusinessEntityID)

ALTER TABLE Fact_SalesOrder
ADD CONSTRAINT FK_Fact_SalesOrder_Dim_Territory_TerritoryID
FOREIGN KEY (TerritoryID) REFERENCES Dim_Territory(TerritoryID)

CREATE TABLE Fact_Product (
	ID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	DateKey NVARCHAR(8) NOT NULL,
	ProductID INT NOT NULL,
	TerritoryID INT NULL,
	Qty INT NOT NULL
)

ALTER TABLE Fact_Product
ADD CONSTRAINT FK_Fact_Product_Dim_Date_DateKey
FOREIGN KEY (DateKey) REFERENCES Dim_Date(DateKey)

ALTER TABLE Fact_Product
ADD CONSTRAINT FK_Fact_Product_Dim_Product_ProductID
FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID)

ALTER TABLE Fact_Product
ADD CONSTRAINT FK_Fact_Product_Dim_Territory_TerritoryID
FOREIGN KEY (TerritoryID) REFERENCES Dim_Territory(TerritoryID)