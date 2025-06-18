-- Q3) Retrieve all employees and their departments
SELECT Name, DepartmentName 
FROM Employees NATURAL JOIN Departments;

-- Q4) Calculate total salary paid per department
SELECT DepartmentName, SUM(Salary) 
FROM Employees NATURAL JOIN Departments
GROUP BY DepartmentName;

-- Q5) List employees earning above a certain salary (e.g., 60000)
SELECT Name, Salary 
FROM Employees 
WHERE Salary > 60000;

-- Q6) Update an employee’s salary (e.g., increase salary of EmployeeID 103 to 80000)
UPDATE Employees
SET Salary = 80000 
WHERE EmployeeID = 103;

SELECT * FROM Employees;

-- Q7) Find the highest-paid employee
SELECT Name, Salary 
FROM Employees
WHERE Salary = (
    SELECT MAX(Salary) 
    FROM Employees
);

-- Q8) Delete an employee record (e.g., delete EmployeeID 110)
DELETE FROM Payroll
WHERE EmployeeID = 110;

DELETE FROM Employees
WHERE EmployeeID = 110;

-- Q9) Retrieve employees who have been with the company for more than 5 years
SELECT Name, JoinDate 
FROM Employees 
WHERE JoinDate < ADD_MONTHS(SYSDATE, -60);

-- Q10) Find employees with salaries above the department average
SELECT Name, Salary
FROM Employees e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);

-- Q11) Retrieve employees who received a salary increase in the last year
SELECT p1.EmployeeID, e.Name, p1.SalaryAmount AS NewSalary, p2.SalaryAmount AS OldSalary
FROM Payroll p1
JOIN Payroll p2 ON p1.EmployeeID = p2.EmployeeID
NATURAL JOIN Employees e
WHERE p1.SalaryMonth = 'February'
  AND p2.SalaryMonth = 'January'
  AND p1.SalaryAmount > p2.SalaryAmount;

-- Q12) List departments with the highest total salary expenses
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
HAVING SUM(Salary) = (
    SELECT MAX(SumPerDept)
    FROM (
        SELECT SUM(Salary) AS SumPerDept
        FROM Employees
        GROUP BY DepartmentID
    )
);

-- Q13) Find the most common salary amount in the payroll
SELECT e1.Salary, COUNT(e1.Salary) AS Z
FROM Employees e1, (SELECT DISTINCT Salary FROM Employees) e2
WHERE e1.Salary = e2.Salary
GROUP BY e1.Salary
HAVING COUNT(e1.Salary) = (
    SELECT MAX(X) 
    FROM (
        SELECT e1.Salary, COUNT(e1.Salary) AS X
        FROM Employees e1, (SELECT DISTINCT Salary FROM Employees) e2
        WHERE e1.Salary = e2.Salary
        GROUP BY e1.Salary
    )
);

-- Q14) Retrieve employees sorted by salary in descending order
SELECT Name, Salary 
FROM Employees
ORDER BY Salary DESC;

-- Q15) Find employees whose salaries increased by more than 10% in the last year
SELECT e.Name, p1.SalaryAmount AS NewSalary, p2.SalaryAmount AS OldSalary
FROM Payroll p1
JOIN Payroll p2 ON p1.EmployeeID = p2.EmployeeID
JOIN Employees e ON e.EmployeeID = p1.EmployeeID
WHERE p1.SalaryMonth = 'February'
  AND p2.SalaryMonth = 'January'
  AND ((p1.SalaryAmount - p2.SalaryAmount) / p2.SalaryAmount) * 100 > 10;

-- Q16) Retrieve payroll records for a specific month (e.g., 'February')
SELECT * 
FROM Payroll 
WHERE SalaryMonth = 'February';

-- Q17) Find employees who received bonuses above a certain amount 
SELECT Name, SalaryMonth, Bonus 
FROM Employees NATURAL JOIN Payroll 
WHERE Bonus > 2000;

-- Q18) List employees with the lowest salaries in each department
SELECT Name, DepartmentName, Salary 
FROM Employees e1,
     (SELECT DepartmentID, MIN(Salary) AS X
      FROM Employees
      GROUP BY DepartmentID) e2,
     Departments d
WHERE e1.DepartmentID = e2.DepartmentID
  AND e2.DepartmentID = d.DepartmentID
  AND e1.Salary = e2.X;