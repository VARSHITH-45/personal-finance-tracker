**Personal Finance Tracker Database**

A complete SQL database solution for personal finance management, featuring a normalized schema, advanced reporting queries, and a summary project report.

**Project Overview**

This project provides the complete database backend for a personal finance application. The core objective is to create a structured, normalized database to log income and expenses, categorize transactions, and generate insightful financial summaries.

The repository includes the foundational database schema, a set of powerful queries for analysis, and a final, professional project report detailing the implementation.

**Tools Used**

.Database: MySQL (developed using MySQL Workbench)

.Reporting: PDF (generated from LaTeX)

**Project Components**

This project is broken down into three main deliverables:

**1. Database Schema (finance_tracker_schema.sql)**

This file contains the complete SQL Data Definition Language (DDL) to create the entire database structure from scratch.

**Users:** Table to store user information.

**Categories**: A flexible, user-defined table for tagging both income and expenses (e.g., "Salary", "Groceries", "Rent").

**Income:** Table to log all incoming funds, linked to a user and a category.

**Expenses:** Table to log all outgoing funds, linked to a user and a category.

**Relationships:** Foreign keys are established to ensure data integrity.

**Dummy Data:** The script also includes INSERT statements with sample data to make the database queryable immediately.

**2. SQL Queries & Views (finance_tracker_queries.sql)**

This file contains a collection of SQL Data Manipulation Language (DML) queries used to analyze the financial data and generate reports.

**Monthly Expense Summary:** Aggregates total expenses by user and month.

**Detailed Category Spending:** A granular breakdown of spending per category for each month.

**Net Balance View (v_monthly_financial_summary):** A powerful VIEW that joins income and expenses to provide a complete monthly financial summary (Total Income, Total Expenses, Net Balance) for each user. This view simplifies future reporting.

**3. Project Report (Project_Report_Finance_Tracker.pdf)**

A professional, 2-page project summary report delivered as a PDF. The report is suitable for management or stakeholder review and contains:

.Introduction & Abstract

.Tools Used

.Steps Involved in Building the Project

.Conclusion

**How to Use**

**Create Database:** Execute the finance_tracker_schema.sql script in a MySQL environment (like MySQL Workbench) to create the database, tables, and populate them with sample data.

**Run Reports:** Open and run the queries in finance_tracker_queries.sql against the newly created database to see the financial summaries.

**View Project Summary:** Open Project_Report_Finance_Tracker.pdf to read the formal project report.
