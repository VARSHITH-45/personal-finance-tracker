-- Use the database we created
USE `personal_finance_tracker`;

-- ----------------------------------------------------
-- Query 1: Monthly Expense Summary per User
-- This is the direct answer to your request.
-- It shows total spending for each user, for each month.
-- ----------------------------------------------------
SELECT
    u.username,
    DATE_FORMAT(e.transaction_date, '%Y-%m') AS month_year,
    SUM(e.amount) AS total_expenses
FROM Expenses e
JOIN Users u ON e.user_id = u.user_id
-- We group by the user and the formatted month
GROUP BY e.user_id, month_year
-- Ordering makes it easier to read
ORDER BY u.username, month_year;


-- ----------------------------------------------------
-- Query 2: Detailed Monthly Expense Summary (by Category)
-- This is more granular. Shows *where* the money
-- went each month.
-- ----------------------------------------------------
SELECT
    u.username,
    DATE_FORMAT(e.transaction_date, '%Y-%m') AS month_year,
    c.name AS category_name,
    SUM(e.amount) AS total_spent_in_category
FROM Expenses e
JOIN Users u ON e.user_id = u.user_id
JOIN Categories c ON e.category_id = c.category_id
GROUP BY e.user_id, month_year, e.category_id
ORDER BY u.username, month_year, total_spent_in_category DESC;


-- ----------------------------------------------------
-- Query 3: Full Monthly Financial Summary (Income, Expenses, Net Balance)
-- This is the "big picture" query. It uses Common Table
-- Expressions (CTEs) to calculate monthly income and expenses
-- separately, then joins them together to show your net profit/loss.
-- ----------------------------------------------------
WITH
-- First, get all unique user-month combinations from both tables
AllMonths AS (
    SELECT user_id, DATE_FORMAT(transaction_date, '%Y-%m') AS month_year FROM Income
    UNION -- UNION automatically gets distinct values
    SELECT user_id, DATE_FORMAT(transaction_date, '%Y-%m') AS month_year FROM Expenses
),
-- Then, get total income per user/month
MonthlyIncome AS (
    SELECT
        user_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS month_year,
        SUM(amount) AS total_income
    FROM Income
    GROUP BY user_id, month_year
),
-- Next, get total expenses per user/month
MonthlyExpenses AS (
    SELECT
        user_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS month_year,
        SUM(amount) AS total_expenses
    FROM Expenses
    GROUP BY user_id, month_year
)
-- Finally, join it all together
SELECT
    u.username,
    am.month_year,
    -- IFNULL ensures we show 0.00 instead of NULL if there was no income/expense
    IFNULL(mi.total_income, 0.00) AS total_income,
    IFNULL(me.total_expenses, 0.00) AS total_expenses,
    -- Calculate the net balance for the month
    (IFNULL(mi.total_income, 0.00) - IFNULL(me.total_expenses, 0.00)) AS net_balance
FROM AllMonths am
-- Start with all months, join the user...
JOIN Users u ON am.user_id = u.user_id
-- LEFT JOIN to the income summary...
LEFT JOIN MonthlyIncome mi ON am.user_id = mi.user_id AND am.month_year = mi.month_year
-- LEFT JOIN to the expense summary...
LEFT JOIN MonthlyExpenses me ON am.user_id = me.user_id AND am.month_year = me.month_year
ORDER BY u.username, am.month_year;
