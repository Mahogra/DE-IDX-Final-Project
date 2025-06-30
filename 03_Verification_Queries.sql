
USE DWH;
GO

-- Pengecekan #1: Menghitung jumlah total baris di tabel fakta
-- Untuk mengetahui berapa banyak transaksi unik yang berhasil dimuat.
PRINT '--- Pengecekan #1: Jumlah Total Data ---';
SELECT COUNT(*) AS TotalRowsInFactTransaction
FROM DWH.dbo.FactTransaction;
GO


-- Pengecekan #2: Memvalidasi bahwa tidak ada TransactionID yang duplikat
-- Hasil dari query ini harus SAMA PERSIS dengan hasil Pengecekan #1.
PRINT '--- Pengecekan #2: Validasi Anti-Duplikasi ---';
SELECT COUNT(DISTINCT TransactionID) AS TotalUniqueTransactionIDs
FROM DWH.dbo.FactTransaction;
GO


-- Pengecekan #3: Melihat 10 data terakhir untuk memastikan formatnya benar
PRINT '--- Pengecekan #3: "Intip" Isi Data ---';
SELECT TOP 10 *
FROM DWH.dbo.FactTransaction
ORDER BY TransactionDate DESC;
GO


-- Pengecekan #4: Tes join "Star Schema" (Tes Paling Penting!)
-- Untuk membuktikan tabel fakta bisa dihubungkan ke semua dimensinya.
-- Jika query ini berhasil, DWH Anda fungsional.
PRINT '--- Pengecekan #4: Tes Join "Star Schema" ---';
SELECT TOP 20
    ft.TransactionID,
    ft.TransactionDate,
    dc.CustomerName,
    da.AccountType,
    ft.Amount,
    ft.TransactionType,
    db.BranchName
FROM
    DWH.dbo.FactTransaction AS ft
JOIN
    DWH.dbo.DimAccount AS da ON ft.AccountID = da.AccountID
JOIN
    DWH.dbo.DimCustomer AS dc ON da.CustomerID = dc.CustomerID
JOIN
    DWH.dbo.DimBranch AS db ON ft.BranchID = db.BranchID
ORDER BY
    ft.TransactionDate DESC;
GO


-- CONTOH CARA MENJALANKAN STORED PROCEDURE
/*
PRINT '--- Contoh Menjalankan Stored Procedure ---';
EXEC DailyTransaction @start_date = '2023-01-01', @end_date = '2023-12-31';
EXEC BalancePerCustomer @name = 'Budi Santoso';
*/
