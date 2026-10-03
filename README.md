<img width="1200" height="500" alt="pic" src="https://github.com/user-attachments/assets/c6c14bd2-1d3b-4a53-92e3-638b653e0788" />

---


---

**Student:** Priya Savaliya — **Student ID:** 10211
**Assigned Set:** Set B (`data-analysis-set-B_10211`)

---

## 🛠️ Tools Used

<div>

<img src="https://img.shields.io/badge/PostgreSQL-16-4169E1?style=for-the-badge&logo=postgresql&logoColor=white"/>
<img src="https://img.shields.io/badge/SQL-JOIN%20%7C%20GROUP%20BY%20%7C%20HAVING-00758F?style=for-the-badge&logo=postgresql&logoColor=white"/>
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
<img src="https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white"/>
<img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white"/>
<img src="https://img.shields.io/badge/Matplotlib-11557C?style=for-the-badge&logo=plotly&logoColor=white"/>
<img src="https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/>
<img src="https://img.shields.io/badge/INDEX%2FMATCH-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/>
<img src="https://img.shields.io/badge/COUNTIFS-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/>
<img src="https://img.shields.io/badge/PivotTable-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/>
<img src="https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/>
<img src="https://img.shields.io/badge/DAX_Measures-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/>

</div>

---

## 🎯 Objective

💡 Question 1: Which department is slowest to resolve tickets and breaches the 24-hour SLA most often?

Answer: The Technical department. Its average resolution time is 28.33 hours, against 19.33 hours for Service. Its SLA breach rate is 50.00% (3 of 6 tickets), against 33.33% (2 of 6) for Service.

Source: S2a_avg_resolution_by_department.csv and python_summary.csv.

---

💡 Question 2: Which channel generates the most SLA breaches?

Answer: Chat, with 3 breaches out of the 5 total. Phone has 2 and Email has 0.

Source: S2c_top_two_channels_by_breach.csv, and the Excel Summary sheet for Email's 0.

---

## 📂 Project Structure

```
data-analysis-set-B_10211/
├── README.md
├── Data/ (tickets.csv, teams.csv, clean_data.csv)
├── sql/ (setup.sql, queries.sql, output/*.csv)
├── python/ (Python_analysis.ipynb, python_summary.csv, python_chart.png)
├── excel/ (excel_analysis.xlsx)
└── powerbi/ (dashboard.pbix)
```

## ♻️ Workflow




<img width="1280" height="420" alt="pic" src="https://github.com/user-attachments/assets/9e6ab962-71b1-41d5-b941-a34596b02ed2" />





---

## 📂 Project Files

| File | Description |
|---|---|
| `Data/tickets.csv` | Raw — 13 rows (1 exact duplicate: `ticket_id 12`) |
| `Data/teams.csv` | Team master — 4 teams, 2 departments |
| `Data/clean_data.csv` | Cleaned & merged — 12 rows, with `breach_flag` |
| `sql/setup.sql` | Creates & seeds `teams` and `tickets` tables (PostgreSQL 16) |
| `sql/queries.sql` | S2a, S2b, S2c analysis queries + S3 integrity diagnostic |
| `sql/output/*.csv` | Query results (S2a, S2b, S2c, S3) |
| `python/Python_analysis.ipynb` | Clean → merge → breach flag → summaries → chart |
| `python/python_summary.csv` | Department-level SLA breach summary |
| `excel/excel_analysis.xlsx` | Raw / Lookup / Clean / Summary sheets |
| `powerbi/dashboard.pbix` | KPI dashboard (cards, bar, line, slicer) |

---

## 🎬 Project Demo

[![Watch Demo](https://img.shields.io/badge/Watch%20Demo-Add%20Your%20Link-0B1F3A?style=for-the-badge&logo=googledrive&logoColor=white)](https://drive.google.com/file/d/1xlZ1wFp4MoYn7CLNcBUet39NIdM255_E/view?usp=sharing)

📹 Add a link to your project walkthrough video here.

---

## 🧬 Data Dictionary

| Column | Type | Meaning |
|---|---|---|
| `ticket_id` | int | Unique ticket ID |
| `month` | string | Jan / Feb / Mar |
| `team_id` | string | FK → `teams.team_id` |
| `channel` | string | Email / Chat / Phone |
| `resolution_hours` | numeric | Hours taken to resolve the ticket |
| `satisfaction` | numeric | Customer rating (1–5) |
| `team` | string | *(clean only)* Team name from `teams` |
| `department` | string | *(clean only)* Service / Technical |
| `breach_flag` | int | *(clean only)* `1` if `resolution_hours > 24`, else `0` |

**Teams master**

| team_id | team | department |
|---|---|---|
| T1 | AccountCare | Service |
| T2 | BillingHelp | Service |
| T3 | AppSupport | Technical |
| T4 | DeviceHelp | Technical |

---

## 🧹 Cleaning & Metrics

```python
tickets["resolution_hours"] = pd.to_numeric(tickets["resolution_hours"])
tickets["satisfaction"]     = pd.to_numeric(tickets["satisfaction"])

tickets = tickets.drop_duplicates()                              # 13 → 12 rows
merged  = tickets.merge(teams, on="team_id", how="left")        # left join
merged["breach_flag"] = (merged["resolution_hours"] > 24).astype(int)

assert len(merged) == 12
assert merged["department"].isna().sum() == 0                    # no unmatched team_id
```

- **breach_flag** = `1` if `resolution_hours > 24`
- **SLA breach rate** = `breached_count / total_tickets × 100`

---

## 📊 Excel Sheet Guide


<img width="1200" height="500" alt="pic" src="https://github.com/user-attachments/assets/3f991cec-8d40-4dfb-bd67-8b8f3a64c235" />


| Sheet | Purpose |
|---|---|
| `Raw` | Original 13-row data (duplicate preserved) |
| `Lookup` | Team master (4 rows) |
| `Clean` | Deduped data, `department` via INDEX/MATCH, `breach_flag` via `IF(resolution_hours>24,1,0)`, row-count check (13 → 12) |
| `Summary` | Breached tickets by channel (COUNTIFS) + PivotTable: avg resolution hours, department × month + chart |

---

## 🐘 SQL Setup & Query Execution Steps


<img width="1200" height="500" alt="pic" src="https://github.com/user-attachments/assets/1cb3a0d0-10ba-43ab-8ecd-ccb5dcd59dd5" />


```bash
psql -U <user> -d <db> -f sql/setup.sql
psql -U <user> -d <db> -f sql/queries.sql
```

```sql

SELECT tm.department, ROUND(AVG(t.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS t JOIN teams AS tm ON t.team_id = tm.team_id
GROUP BY tm.department
ORDER BY avg_resolution_hours DESC;


SELECT tm.team, ROUND(AVG(t.resolution_hours), 2) AS avg_resolution_hours
FROM tickets AS t JOIN teams AS tm ON t.team_id = tm.team_id
GROUP BY tm.team_id, tm.team
HAVING AVG(t.resolution_hours) > 24
ORDER BY avg_resolution_hours DESC;


SELECT t.channel, COUNT(*) AS breach_count
FROM tickets AS t
WHERE t.resolution_hours > 24
GROUP BY t.channel
ORDER BY breach_count DESC, t.channel ASC
LIMIT 2;


SELECT tm.team_id, tm.team, tm.department,
       COUNT(t.ticket_id) AS matched_ticket_count,
       CASE WHEN COUNT(t.ticket_id) = 0 THEN 1 ELSE 0 END AS unmatched_team_flag
FROM teams AS tm LEFT JOIN tickets AS t ON t.team_id = tm.team_id
GROUP BY tm.team_id, tm.team, tm.department
ORDER BY tm.team_id;
```

---

## 🐍 Python — Setup & Run



<img width="1200" height="500" alt="pic" src="https://github.com/user-attachments/assets/f02b5477-cd1a-492e-ba82-b81f2a394f24" />



```bash
pip install -r requirements.txt
jupyter notebook python/Python_analysis.ipynb
```

- **Packages:** `pandas`, `matplotlib`
- **Outputs:** `clean_data.csv`, `python_summary.csv`, `python_chart.png`

```python
department_summary = merged.groupby("department").agg(
    total_tickets=("ticket_id", "count"),
    breached_count=("breach_flag", "sum")
).reset_index()

department_summary["sla_breach_rate_percent"] = (
    department_summary["breached_count"] / department_summary["total_tickets"] * 100
)
```

---

## ⚡ Power BI — Dashboard & Refresh Steps


<img width="1200" height="500" alt="pic" src="https://github.com/user-attachments/assets/89e325ea-0cdb-4820-b62f-3006f2fb03c1" />


**Dashboard contents**

| Visual | Field |
|---|---|
| Card | Ticket Count |
| Card | SLA Breach Rate |
| Card | Avg Satisfaction |
| Clustered bar chart | Avg Satisfaction by Department |
| Line / area chart | Average resolution hours by Month |
| Slicer | Channel |


<img width="1162" height="656" alt="Screenshot 2026-10-03 131935" src="https://github.com/user-attachments/assets/7cce4ce1-59f6-47a1-b523-16873412c153" />



```
Home → Transform Data → Data Source Settings
→ Change Source → point to new local CSV path
→ Close & Apply → Refresh
```



---

## 📈 Results

**Overall:** 12 tickets · 5 SLA breaches · **41.67% breach rate** · avg resolution **23.83 hrs** · avg satisfaction **3.58 / 5**

| Department | Team | Avg Resolution Hrs | Breaches | Breach Rate |
|---|---|---|---|---|
| Technical | AppSupport | 28.67 | 2 / 3 | 66.67% |
| Technical | DeviceHelp | 28.00 | 1 / 3 | 33.33% |
| Service | BillingHelp | 26.67 | 2 / 3 | 66.67% |
| Service | AccountCare | 12.00 | 0 / 3 | 0.00% |

- **By department:** Technical 28.33 hrs vs Service 19.33 hrs
- **Breaches by channel:** Chat 3 · Phone 2 · Email 0
- **Monthly avg resolution:** Jan 24.00 · Feb 24.00 · Mar 23.50
- **Integrity check (S3):** all 4 teams matched 3 tickets each, no orphan `team_id`

**Findings:**
1. Technical is ~9 hrs slower than Service and breaches more often (50% vs 33%).
2. Chat and Phone cause all 5 breaches; Email has none.
3. Breached tickets average **2.60** satisfaction vs **4.29** for on-time tickets.

**Recommendation:** Review **AppSupport**, **DeviceHelp** and the **Chat/Phone** channels first; use AccountCare's workflow as the benchmark.

---

---

## 🔁 Cross-Tool Reconciliation

| Metric | SQL | Python | Excel |
|---|---|---|---|
| Rows after cleaning | 12 | 12 | 12 |
| Total breaches | 5 | 5 | 5 |
| Avg resolution hours (Technical) | 28.33 | 28.33 | 28.33 |
| Avg resolution hours (Service) | 19.33 | 19.33 | 19.33 |

**Note:** the raw `tickets.csv` has 13 rows because `ticket_id 12` appears twice (exact duplicate). SQL (seeded with 12 rows), Python (`drop_duplicates()`) and Excel (`Clean` sheet) all work on the de-duplicated 12 rows. Make sure Power BI also reads the cleaned data, so its Ticket Count card shows **12**.

---

## 📌 Expected Outcomes

- One reconciled set of SLA numbers agreed across SQL, Python, Excel and Power BI
- Department-, team- and channel-level breakdown pinpointing where SLA breaches happen
- Reusable cleaning pipeline (`drop_duplicates` → merge → `breach_flag`)

---

## 🚀 Suggested Next Steps

- Extend the data beyond 3 months and more tickets per team to confirm trends
- Investigate root causes for Chat and Phone breaches (staffing, ticket complexity, escalation)
- Add a priority / ticket-type column to separate genuine delays from complex cases
- Repoint Power BI source to `clean_data.csv` so every tool uses the same dataset

---

## ⚙️ Installation & Setup

```bash
git clone https://github.com/priyasavaliya20-collab/data-analysis-set-B_10211.git
cd data-analysis-set-B_10211
pip install -r requirements.txt
```

---

## 🙏 Thank You

Feedback and suggestions are welcome.

⭐ Star the repo if this was useful.


