#!/bin/bash

# 啟動 SQL Server
/opt/mssql/bin/sqlservr & 
PID=$!

# 等待 SQL Server 完全啟動
echo "Waiting for SQL Server to start..."
status=1
i=0
while [ $status -ne 0 ] && [ $i -lt 60 ]; do
    i=$((i+1))
    # 嘗試連接到 SQL Server
    /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "${MSSQL_SA_PASSWORD}" -Q "SELECT @@VERSION" > /dev/null 2>&1
    status=$?
    if [ $status -ne 0 ]; then
        echo "Waiting... ($i/60)"
        sleep 1
    fi
done

if [ $status -ne 0 ]; then
    echo "Error: SQL Server failed to start within 60 seconds."
    exit 1
fi

echo "SQL Server started successfully"

# 執行初始化腳本
echo "Running initialization script..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "${MSSQL_SA_PASSWORD}" -i /var/opt/mssql/scripts/init.sql
if [ $? -ne 0 ]; then
    echo "Error: Failed to run initialization script"
    exit 1
fi

echo "Initialization complete"

# 保持容器運行
wait $PID 