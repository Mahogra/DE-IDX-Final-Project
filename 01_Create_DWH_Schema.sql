
-- MEMBUAT DATABASE BARU UNTUK DATA WAREHOUSE
CREATE DATABASE DWH;
GO

-- MEMILIH DATABASE DWH
USE DWH;
GO

-- ===================================================================
-- MEMBUAT SEMUA TABEL DIMENSI DAN FAKTA
-- ===================================================================

-- 1. Tabel Dimensi Akun (DimAccount)
CREATE TABLE DimAccount (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(50),
    Balance DECIMAL(18, 2),
    DateOpened DATE,
    Status VARCHAR(50)
);

-- 2. Tabel Dimensi Cabang (DimBranch)
CREATE TABLE DimBranch (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(255),
    BranchLocation VARCHAR(255)
);

-- 3. Tabel Dimensi Pelanggan (DimCustomer)
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    Address VARCHAR(255),
    CityName VARCHAR(255),
    StateName VARCHAR(255),
    Age INT,
    Gender VARCHAR(50),
    Email VARCHAR(255)
);

-- 4. Tabel Fakta Transaksi (FactTransaction)
CREATE TABLE FactTransaction (
    TransactionID VARCHAR(255) PRIMARY KEY,
    AccountID INT,
    TransactionDate DATETIME,
    Amount DECIMAL(18, 2),
    TransactionType VARCHAR(50),
    BranchID INT
);
GO

-- ===================================================================
-- MENGHUBUNGKAN SEMUA TABEL DWH DENGAN FOREIGN KEY
-- ===================================================================

-- Menghubungkan FactTransaction ke DimAccount
ALTER TABLE FactTransaction 
ADD CONSTRAINT FK_FactTransaction_DimAccount
FOREIGN KEY (AccountID) REFERENCES DimAccount(AccountID);
GO

-- Menghubungkan FactTransaction ke DimBranch
ALTER TABLE FactTransaction 
ADD CONSTRAINT FK_FactTransaction_DimBranch
FOREIGN KEY (BranchID) REFERENCES DimBranch(BranchID);
GO

-- Menghubungkan DimAccount ke DimCustomer
ALTER TABLE DimAccount 
ADD CONSTRAINT FK_DimAccount_DimCustomer
FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID);
GO

PRINT 'DATABASE DWH DAN SEMUA TABEL BERHASIL DIBUAT!';
