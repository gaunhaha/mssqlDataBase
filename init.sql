-- 創建資料庫
CREATE DATABASE MyDatabase;
GO

-- 切換到新創建的資料庫
USE MyDatabase;
GO

-- 在這裡可以添加其他的資料庫初始化操作
-- 例如創建表格、插入初始數據等

CREATE TABLE Users (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Email NVARCHAR(100)
);
GO