
--- 1) Extracting raw dataset -> Dataset imported from Excel into SQL Server
select * from dbo.financial_loan

--- 2) *Data Transformation Queries - Used for KPI calculation and dashboard creation*
-- A) SUMMARY -> KPI's
---1) Total loan applications ? :
SELECT COUNT(id) AS TOTAL_LOAN_APPLIACTIONS FROM dbo.financial_loan 

--2) Previous month-to-date total loan applications ? :
SELECT COUNT(id) AS PMTD_TOTAL_LOAN_APPLICATIONS FROM dbo.financial_loan 
WHERE MONTH(issue_date)= 8 ;

-- 3) Total Funded(loan) Amount : 
SELECT SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT FROM dbo.financial_loan 

-- 4) Current MTD Total Funded(loan) Amount : 
SELECT SUM(loan_amount) AS CMTD_TOTAL_FUNDED_AMOUNT FROM dbo.financial_loan
WHERE MONTH(issue_date)= 9 AND YEAR(issue_date)=2021

--5) Previous MTD Total Funded(loan) Amount :  
SELECT SUM(loan_amount) AS PMTD_TOTAL_FUNDED_AMOUNT FROM dbo.financial_loan
WHERE MONTH(issue_date)= 8 AND YEAR(issue_date)=2021

-- 6) Total Amount received :
SELECT SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED FROM dbo.financial_loan

-- 7) Current Total Amount received :
SELECT SUM(total_payment) AS CMTD_TOTAL_AMOUNT_RECEIVED FROM dbo.financial_loan
WHERE MONTH (issue_date)=9 AND YEAR (issue_date)=2021

--8) Current Total Amount received :
SELECT SUM(total_payment) AS PMTD_TOTAL_AMOUNT_RECEIVED FROM dbo.financial_loan
WHERE MONTH (issue_date)=8 AND YEAR (issue_date)=2021

-- 9) Average Interest Rate :
SELECT AVG(int_rate) * 100 AS AVG_INT_RATE FROM dbo.financial_loan

--10) Round off this :
SELECT ROUND(AVG(int_rate),4) * 100 AS AVG_INT_RATE FROM dbo.financial_loan

--11) Current MTD Average Interest Rate :
SELECT ROUND(AVG(int_rate),4) * 100 AS CMTD_AVG_INT_RATE FROM dbo.financial_loan
WHERE MONTH (issue_date)=9 AND YEAR (issue_date)=2021

--12) Previous MTD Average Interest Rate :
SELECT ROUND(AVG(int_rate),4) * 100 AS PMTD_AVG_INT_RATE FROM dbo.financial_loan
WHERE MONTH (issue_date)=8 AND YEAR (issue_date)=2021

--13) Average DTI :
SELECT ROUND(AVG(dti),4) AS AVG_DTI FROM dbo.financial_loan

--14) Current MTD AVG DTI :
SELECT ROUND(AVG(dti),4) AS CMTD_AVG_DTI FROM dbo.financial_loan
WHERE MONTH (issue_date)=9 AND YEAR (issue_date)=2021

--15) Previous MTD Avg DTI :
SELECT ROUND(AVG(dti),4)*100 AS PMTD_AVG_DTI FROM dbo.financial_loan
WHERE MONTH (issue_date)= 8 AND YEAR (issue_date)=2021

-----------------------------------------------------------------------------------------------------
-- Good loan KPI's :
select * from dbo.financial_loan
--16) Application Percentage : 
select loan_status from dbo.financial_loan
SELECT 
       (COUNT(CASE WHEN loan_status ='Fully Paid' OR loan_status='Current' THEN id END)*100)
       / 
       COUNT(id) AS GOOD_LOAN_PERCENTAGE
FROM dbo.financial_loan

--17) applications of good loan :
SELECT COUNT(id) AS GOOD_LOAN_APPLICATIONS FROM dbo.financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--18) funded amount of good loan :
SELECT SUM (loan_amount) AS GOOD_LOAN_FUNDED_AMOUNT FROM dbo.financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--19) Amnt received og good loan :
SELECT SUM (total_payment) AS GOOD_LOAN_AMOUNT_RECEIVED FROM dbo.financial_loan
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-------------------------------------------------------------------------------
---- Bad loan KPI's
--20) percemtage of bad loan issued
SELECT
    (COUNT (CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	 COUNT (id) AS BAD_LOAN_PERCENTAGE
FROM dbo.financial_loan

-- 21) applications :
SELECT COUNT(id) AS BAD_LOAN_APPLICATIONS FROM dbo.financial_loan
WHERE loan_status = 'Charged Off'

--22) Amnt received of bad loan:
SELECT SUM(total_payment) AS BAD_LOAN_AMOUNT_RECEIVED FROM dbo.financial_loan
WHERE loan_status = 'Charged Off'
----------------------------------------------------------------------------------------------------------------------------
-- 23)Loan status 
SELECT
        loan_status,
        COUNT(id) AS LOAN_COUNT,
        SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED,
        SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT,
        AVG(int_rate * 100) AS INTREST_RATE,
        AVG(dti * 100) AS AVG_DTI
FROM dbo.financial_loan
GROUP BY loan_status

--24) current loan status :
SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_TOTAL_AMOUNT_RECEIVED, 
	SUM(loan_amount) AS MTD_TOTAL_FUNDED_AMOUNT
FROM dbo.financial_loan
WHERE MONTH(issue_date) = 9
GROUP BY loan_status
--------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- B) OVERVIEW (CHART BASED) : I will perform multiple visulaisation charts on Tableau/PowerBI/Excel based on below 25) to 30) .
--25)  Month :
SELECT 
	  MONTH (issue_date) AS MONTH_NUMBER, 
	  DATENAME (MONTH, issue_date) AS MONTH_NAME, 
	  COUNT (id) AS TOTAL_LOAN_APPLICATIONS,
	  SUM (loan_amount) AS TOTAL_FUNDED_AMOUNT,
	  SUM (total_payment) AS TOTAL_AMOUNT_RECEIVED
      FROM dbo.financial_loan
      GROUP BY MONTH (issue_date), DATENAME (MONTH, issue_date)
      ORDER BY MONTH (issue_date)

--26) State :
SELECT 
	address_state AS STATE, 
	COUNT(id) AS TOTAL_LOAN_APPLICATIONS,
	SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT,
	SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM dbo.financial_loan
GROUP BY address_state
ORDER BY address_state

--27 ) Term :
SELECT 
	term AS Term, 
	COUNT(id) AS TOTAL_LOAN_APPLICATIONS,
	SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT,
	SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM dbo.financial_loan
GROUP BY term
ORDER BY term
 
 --28) Employee length :
 SELECT 
	emp_length AS EMPLOYEE_LENGTH, 
	COUNT(id) AS TOTAL_LOAN_APPLICATIONS,
	SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT,
	SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM dbo.financial_loan
GROUP BY emp_length
ORDER BY emp_length

--29) Purpose :
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS TOTAL_LOAN_APPLICATIONS,
	SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT,
	SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM dbo.financial_loan
GROUP BY purpose
ORDER BY purpose

-- 30) Home Ownership :

SELECT 
	home_ownership AS HOME_OWNERSHIP, 
	COUNT(id) AS TOTAL_LOAN_APPLICATIONS,
	SUM(loan_amount) AS TOTAL_FUNDED_AMOUNT,
	SUM(total_payment) AS TOTAL_AMOUNT_RECEIVED
FROM dbo.financial_loan
GROUP BY home_ownership
ORDER BY home_ownership
-----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

-- D) Advanced SQL Queries :
-- i) CTE (Common Table Expressions) :
-- Q-31 : Find average annual income for each home ownership type.

WITH CTE_Income AS (
    SELECT home_ownership, AVG(annual_income) AS avg_income
    FROM dbo.financial_loan
    GROUP BY home_ownership
)
SELECT * FROM CTE_Income;

--Q-32 : Find top 3 highest loan amounts for each grade.
WITH CTE_RankedLoans AS (
    SELECT grade, loan_amount,
           ROW_NUMBER() OVER(PARTITION BY grade ORDER BY loan_amount DESC) AS rn
    FROM dbo.financial_loan
)
SELECT * FROM CTE_RankedLoans WHERE rn <= 3;

-- Q-33 : Show loan status distribution (count of each status).
WITH LoanStatus AS (
    SELECT loan_status, COUNT(*) AS cnt
    FROM dbo.financial_loan
    GROUP BY loan_status
)
SELECT * FROM LoanStatus;

-- ii ) SUBQUERIES :
--Q-34 : Find all borrowers who earn more than the average income.
SELECT id, emp_title, annual_income
FROM dbo.financial_loan
WHERE annual_income > (SELECT AVG(annual_income) FROM dbo.financial_loan);

-- Q-35 : Find states where total loan issued is above the overall average loan issued per state.
SELECT address_state, SUM(loan_amount) AS total_state_loan
FROM dbo.financial_loan
GROUP BY address_state
HAVING SUM(loan_amount) > (
    SELECT AVG(state_total) 
    FROM (
        SELECT SUM(loan_amount) AS state_total
        FROM dbo.financial_loan
        GROUP BY address_state
    ) t
);

---iii) Window functions : 
--- Q-36 : Rank borrowers by loan amount within each grade. :
SELECT id, grade, loan_amount,
       RANK() OVER(PARTITION BY grade ORDER BY loan_amount DESC) AS loan_rank
FROM dbo.financial_loan;

--Q-37 : Show the previous loan amount (LAG) and next loan amount (LEAD) for each borrower ordered by issue_date.
SELECT id, loan_amount, issue_date,
       LAG(loan_amount) OVER(ORDER BY issue_date) AS prev_loan,
       LEAD(loan_amount) OVER(ORDER BY issue_date) AS next_loan
FROM dbo.financial_loan;

--Q-38 : Find cumulative (running) loan amount disbursed by issue_date.
SELECT issue_date, loan_amount,
       SUM(loan_amount) OVER(ORDER BY issue_date) AS cumulative_loan
FROM dbo.financial_loan;

-- Q-39 : For each state, find borrower with the highest annual income.
SELECT id, address_state, annual_income
FROM (
    SELECT id, address_state, annual_income,
           ROW_NUMBER() OVER(PARTITION BY address_state ORDER BY annual_income DESC) AS rn
    FROM dbo.financial_loan
) t
WHERE rn = 1;

-- Q-40 : Find average interest rate and loan amount by grade.
SELECT grade, AVG(int_rate) AS avg_rate, AVG(loan_amount) AS avg_loan
FROM dbo.financial_loan
GROUP BY grade;

-- Q-41 : Find the top 5 purposes with highest total loan issued.
SELECT TOP 5 purpose, SUM(loan_amount) AS total_loans
FROM dbo.financial_loan
GROUP BY purpose
ORDER BY total_loans DESC;

--Q-42 : Find states where the average annual income is greater than ₹80,000. :
SELECT address_state, AVG(annual_income) AS avg_income
FROM dbo.financial_loan
GROUP BY address_state
HAVING AVG(annual_income) > 80000;

 ---iv) CTAS (Create Table As Select)
 -- Q-45 : Create a table of all loans that are charged off.
 SELECT *
INTO charged_off_loans
FROM dbo.financial_loan
WHERE loan_status = 'Charged Off';

EXEC sp_help charged_off_loans;

---Q-46 ; Create a table of top 10 borrowers by loan amount.
SELECT TOP 10 id, emp_title, annual_income, loan_amount, grade, loan_status
INTO top_10_borrowers
FROM dbo.financial_loan
ORDER BY loan_amount DESC;

SELECT * FROM top_10_borrowers;
