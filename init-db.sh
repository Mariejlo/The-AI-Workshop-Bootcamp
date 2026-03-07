#!/bin/bash
set -e

echo "📦 Installing SQL Server 2022..."

# Add Microsoft repo using Ubuntu 22.04 packages (compatible with 22.04 base image)
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/22.04/mssql-server-2022 jammy main" \
  > /etc/apt/sources.list.d/mssql-server-2022.list

apt-get update -q
apt-get install -y mssql-server

echo "⚙️  Configuring SQL Server..."
MSSQL_SA_PASSWORD='Bootcamp123!' \
MSSQL_PID='Developer' \
ACCEPT_EULA='Y' \
/opt/mssql/bin/mssql-conf setup

echo "▶️  Starting SQL Server..."
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be ready
echo "⏳ Waiting for SQL Server to start..."
for i in {1..30}; do
  if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Bootcamp123!' -C -Q "SELECT 1" > /dev/null 2>&1; then
    echo "✅ SQL Server is running!"
    exit 0
  fi
  echo "   Still waiting... ($i/30)"
  sleep 5
done

echo "❌ SQL Server did not start in time. Check logs with: cat /var/opt/mssql/log/errorlog"
exit 1
