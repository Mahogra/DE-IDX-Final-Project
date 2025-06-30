USE DWH;
GO

-- ===================================================================
-- STORED PROCEDURE #1: DailyTransaction
-- ===================================================================

CREATE OR ALTER PROCEDURE DailyTransaction

    @start_date DATE,
    @end_date DATE
AS
BEGIN
    -- Perintah ini agar tidak muncul pesan "(x rows affected)"
    SET NOCOUNT ON;

    -- Query utama untuk menghitung ringkasan
    SELECT
        CONVERT(DATE, TransactionDate) AS Date,
        COUNT(TransactionID) AS TotalTransactions,
        SUM(Amount) AS TotalAmount
    FROM
        FactTransaction
    WHERE
        -- Filter berdasarkan rentang tanggal dari parameter
        CONVERT(DATE, TransactionDate) BETWEEN @start_date AND @end_date
    GROUP BY
        -- Mengelompokkan data berdasarkan hari
        CONVERT(DATE, TransactionDate)
    ORDER BY
        Date ASC;
END;
GO

-- ===================================================================
-- STORED PROCEDURE #2: BalancePerCustomer
-- ===================================================================

CREATE OR ALTER PROCEDURE BalancePerCustomer
    -- Parameter input kita adalah nama nasabah
    @name VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.CustomerName,
        a.AccountType,
        a.Balance AS InitialBalance, -- Saldo awal dari tabel DimAccount
        -- Rumus saldo terkini: Saldo awal +/- total perubahan dari transaksi
        a.Balance + SUM(
            -- ISNULL digunakan jika seorang nasabah belum pernah bertransaksi
            ISNULL(
                -- CASE WHEN untuk menentukan transaksi itu menambah atau mengurangi saldo
                CASE
                    WHEN ft.TransactionType = 'Deposit' THEN ft.Amount   -- Jika deposit, nominalnya positif (menambah)
                    ELSE -ft.Amount -- Jika bukan (misal: Withdrawal), nominalnya negatif (mengurangi)
                END,
            0) -- Jika tidak ada transaksi (NULL), anggap perubahannya 0
        ) AS CurrentBalance
    FROM
        DimCustomer AS c
    JOIN
        DimAccount AS a ON c.CustomerID = a.CustomerID
    -- Kita menggunakan LEFT JOIN ke transaksi, karena mungkin ada akun yang belum pernah bertransaksi
    LEFT JOIN
        FactTransaction AS ft ON a.AccountID = ft.AccountID
    WHERE
        c.CustomerName = @name      -- Filter berdasarkan parameter nama
        AND a.Status = 'active'     -- Filter hanya untuk akun yang aktif sesuai permintaan soal
    GROUP BY
        c.CustomerName, a.AccountType, a.Balance -- Grouping untuk setiap jenis akun per nasabah
    ORDER BY
        a.AccountType;
END;
GO

PRINT 'KEDUA STORED PROCEDURE BERHASIL DIBUAT/DIPERBARUI!';
