# T-SQL Bootcamp 🏥

No installation needed. Everything runs in your browser.

## ▶️ Getting Started

1. Click the green **Code** button → **Codespaces** → **Create codespace on main**
2. Wait ~3 minutes for setup to complete
3. Open any `.sql` file and press **Ctrl+Shift+E** to run a query

## 🔌 Connection Details (if prompted)

| Field | Value |
|---|---|
| Profile name | T-SQL Bootcamp DB|
| Server | `db` |
|Authentication | SQL Login|
| Database | `BootcampDB` |
| Username | `sa` |
| Password | `Bootcamp123!` |
| Trust certificate | Yes |


## If the connection fails, try this in the terminal:

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list && \
sudo apt-get update && \
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev && \
/opt/mssql-tools18/bin/sqlcmd -S db -U sa -P 'Bootcamp123!' -C -i /workspaces/The-AI-Workshop-Bootcamp/seed.sql
```
## 📚 Exercises

- `week-01-select-basics.sql`
- `week-02-filtering-functions.sql`
- `week-03-joins.sql`

## 💡 Tips
- Stop your Codespace at **github.com/codespaces** after each session to save free hours
- Free tier = 60 hours/month — plenty for a weekly bootcamp
