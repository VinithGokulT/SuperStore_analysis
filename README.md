📊 Superstore Sales & Profit Analysis
Python & SQL Data Analytics Project
________________________________________
📌 Project Overview
This project analyzes the Superstore dataset to uncover insights related to sales performance, profitability, customer behavior, and regional trends.
The project demonstrates a complete analytics workflow, including:
•	Data cleaning using Python (Pandas)
•	Data storage and querying using PostgreSQL (SQL)
•	Advanced analysis using SQL window functions and Python analytics
•	Translating SQL logic into Python for deeper exploration
________________________________________
🗂 Dataset
•	Dataset Name: Superstore Dataset
•	Description: Transaction-level retail data containing:
o	Orders
o	Customers
o	Products
o	Regions
o	Sales, Profit, Discounts, Dates
________________________________________
🛠 Tools & Technologies Used
🔹 Programming & Query Languages
•	Python
•	SQL (PostgreSQL)
🔹 Python Libraries
•	pandas – data cleaning & transformation
•	numpy – numerical operations
•	sqlalchemy – database connection
•	psycopg2 – PostgreSQL driver
•	matplotlib, seaborn – data visualization
🔹 Database
•	PostgreSQL
________________________________________
🔄 Project Workflow
1️⃣ Data Ingestion
•	Loaded raw Superstore CSV data into Pandas
•	Cleaned column names and data types
•	Exported cleaned data into PostgreSQL
________________________________________
2️⃣ Data Cleaning (Python)
Performed:
•	Handling missing values
•	Date parsing (order_date, ship_date)
•	Standardizing column names
•	Converting numeric fields
•	Removing invalid or inconsistent records
________________________________________
3️⃣ SQL Analysis (PostgreSQL)
Key SQL concepts used:
•	GROUP BY, HAVING
•	Aggregations (SUM, AVG, MAX)
•	Window functions
o	ROW_NUMBER()
o	RANK()
o	DENSE_RANK()
•	DATE_TRUNC for time-based analysis
•	CTEs (Common Table Expressions)
Example SQL Analysis:
•	Monthly sales trends
•	Profit contribution by sub-category
•	Top-performing products per region
•	Customer profitability ranking
________________________________________
4️⃣ Python Analysis (Pandas)
Recreated SQL logic using Pandas:
•	Group-by aggregations
•	Ranking with cumcount()
•	Percentage contribution analysis
•	Monthly and regional trend analysis
•	Filtering equivalent to SQL WHERE and HAVING
________________________________________
5️⃣ Visualization
•	Correlation heatmaps
•	Monthly sales trends
•	Top-N product profitability charts
•	Region-wise comparisons
________________________________________
📈 Key Insights Generated
•	Identified top profitable products per region
•	Analyzed monthly sales and profit trends
•	Found loss-making sub-categories
•	Measured profit contribution percentages
•	Ranked customers and products using window-function logic
________________________________________
🧠 Key Concepts Demonstrated
•	SQL ↔ Python translation
•	Window functions in SQL and Pandas
•	Time-based aggregation
•	Ranking & segmentation logic
•	End-to-end data analytics workflow
________________________________________
🚀 How to Run the Project
1.	Clone the repository
2.	Install dependencies
3.	pip install pandas sqlalchemy psycopg2-binary matplotlib seaborn
4.	Load dataset into PostgreSQL
5.	Run SQL queries for analysis
6.	Execute Python notebooks for deeper insights
________________________________________
🎯 Future Enhancements
•	Build an interactive dashboard (Streamlit / Power BI)
•	Automate ETL pipeline
•	Add forecasting models
•	Deploy analytics to cloud database
________________________________________
👤 Author
Vinith Gokul
Data Analyst | Python | SQL | PostgreSQL

