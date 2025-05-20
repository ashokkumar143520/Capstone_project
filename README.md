# Capstone_project
olympics-analysis-powerbi-sql/
│
├── data/
│   ├── raw/                  # Original data files (CSV, Excel, etc.)
│   └── cleaned/              # Cleaned CSVs or SQL export files
│
├── sql/
│   ├── schema.sql            # SQL schema definitions (if creating tables)
│   ├── insert_data.sql       # Insert statements or bulk loading scripts
│   └── analysis_queries.sql  # Analysis queries (medal trends, athlete stats, etc.)
│
├── powerbi/
│   ├── olympics_dashboard.pbix   # Power BI dashboard file
│   └── screenshots/              # Exported visuals for README or report
│
├── reports/
│   └── olympics_analysis.md  # Summary of insights (Markdown or Word)
│
├── README.md                 # Project overview
└── .gitignore                # Git ignore rules
# Olympics Data Analysis (Power BI + SQL)

This project explores historical Olympic Games data using SQL for data preparation and Power BI for interactive visualizations.

## 📌 Key Features
- SQL queries to extract trends in athlete performance, medal counts, and sports participation
- Power BI dashboard with filters by year, country, sport, and gender
- Athlete demographics breakdown (age, height, weight)

## 🗃️ Data Structure
- `data/raw` contains original datasets (CSV/Excel)
- `sql/` contains schema and analysis queries
- `powerbi/` includes the `.pbix` file and visual exports

## 📊 Tools Used
- SQL (PostgreSQL / MySQL / SQLite — adaptable)
- Power BI Desktop
- Excel / CSV for data prep

## 🚀 How to Use
1. Load data into a local SQL database or Power BI directly.
2. Use SQL queries from `/sql/analysis_queries.sql` to explore the data.
3. Open `capstone_project.pbix` in Power BI Desktop to interact with the dashboard.

