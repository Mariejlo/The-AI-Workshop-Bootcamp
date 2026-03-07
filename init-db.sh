#!/bin/bash

echo "🔍 Checking SQL Server status..."

# Check if sqlservr is already running
if ! pgrep -x "sqlservr" > /dev/null; then
  echo "▶️  Starting SQL Server..."
  /opt/mssql/bin/sqlservr &

  echo "⏳ Waiting for SQL Server to be ready..."
  for i in {1..30}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Bootcamp123!' -C -Q "SELECT 1" > /dev/null 2>&1; then
      echo "✅ SQL Server is ready!"
      break
    fi
    echo "   Still waiting... ($i/30)"
    sleep 5
  done
else
  echo "✅ SQL Server is already running."
fi

# Check if BootcampDB already exists
DB_EXISTS=$(/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Bootcamp123!' -C \
  -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = 'BootcampDB'" \
  -h -1 2>/dev/null | tr -d ' \r\n')

if [ "$DB_EXISTS" = "1" ]; then
  echo "✅ BootcampDB already exists. You're ready to go!"
else
  echo "🗄️  Creating and seeding BootcampDB..."
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Bootcamp123!' -C -i /workspaces/The-AI-Workshop-Bootcamp/setup/seed.sql
  echo "🎉 Database setup complete!"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  T-SQL Bootcamp is ready!"
echo "  Open any .sql file in /exercises"
echo "  Run queries with Ctrl+Shift+E"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
