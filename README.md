# T-SQL Bootcamp 🏥

A ready-to-run T-SQL learning environment using GitHub Codespaces — no installation required.

## ▶️ Open in Codespaces

Click the green **Code** button → **Codespaces** tab → **Create codespace on main**

Wait ~3 minutes for setup to complete. You'll see this message in the terminal when ready:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  T-SQL Bootcamp is ready!
  Open any .sql file in /exercises
  Run queries with Ctrl+Shift+E
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ⌨️ Running Queries

1. Open a `.sql` file from the `exercises/` folder
2. Highlight the query you want to run
3. Press **Ctrl+Shift+E**
4. Results appear in the **Query Results** panel below
5. First time only: select **T-SQL Bootcamp DB** from the connection picker

---

## 🗄️ The Database

We use **BootcampDB** — an NHS-inspired dataset with:

| Table | Description |
|---|---|
| `Patients` | 10 fictional patients with NHS numbers |
| `Wards` | 6 wards including Virtual Wards |
| `Admissions` | Admission history (some still admitted) |
| `Observations` | Vital signs: BP, HR, SpO2, Temperature |

---

## 📚 Exercises

| File | Topic |
|---|---|
| `week-01-select-basics.sql` | SELECT, WHERE, ORDER BY, TOP |
| `week-02-filtering-functions.sql` | Date functions, GROUP BY, HAVING |
| `week-03-joins.sql` | INNER JOIN, LEFT JOIN, multi-table queries |

---

## 🔌 Database Connection Details

If prompted to connect manually:

| Field | Value |
|---|---|
| Server | `localhost` |
| Database | `BootcampDB` |
| Authentication | SQL Login |
| Username | `sa` |
| Password | `Bootcamp123!` |
| Trust certificate | ✅ Yes |

---

## 💡 Tips

- **Stop your Codespace** after each session at github.com/codespaces to save your free hours
- **Don't delete your Codespace** until the course ends — your work is saved inside it
- If something goes wrong, run `bash /workspace/setup/init-db.sh` in the terminal to reset
- Free tier gives you **60 hours/month** — plenty for a weekly bootcamp
