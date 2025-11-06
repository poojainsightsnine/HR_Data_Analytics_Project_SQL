### HR_Data_Analytics_Project_SQL

### Overview
This project contains a complete **SQL-based analysis of an HR database**, designed to explore insights about employees, departments, job roles, salaries, performance, and attrition.  
It includes multiple analytical queries and reusable SQL views — ready for integration with **Power BI dashboards (currently working on it)**.

---

### **Database Used**
**Database name:** `hr`

### 📂 **Tables**
- `employees`
- `departments`
- `job_roles`
- `salaries`
- `performance`

---

###  **Key SQL Operations**

####  Employee Details
- Display all employees with departments and job roles  
- Find employees without managers  
- Show each employee’s manager and department  
- List employees who joined after 2020  
- Find employees with salary above ₹50,000  

####  Department & Job Role Insights
- Total number of employees per department  
- Highest and lowest salary in each department  
- Average salary by job role  
- Employees earning above their job level’s average  
- Department-wise total and average salary  
- Salary trend by year for each employee  

#### Performance & Attrition Analysis
- Latest performance score per employee  
- Department-wise average performance score  
- Attrition count and rate per department  
- Employee count by performance category  

---

## 🧩 **Views Created**
| View Name | Description |
|------------|--------------|
| `EmployeeReport_View` | Combines employee, department, and job role details |
| `hr_latest_performance_view` | Shows the latest performance score per employee |
| `Latest_Salary_View` | Captures the most recent salary data per employee |
| `HR_Final_EmployeeReport_View` | Final master view combining all employee, salary, and performance details |

**---Technical Implementation Highlights**

Data Aggregation: Extensive use of GROUP BY and aggregate functions (AVG, SUM, COUNT, MIN, MAX) for departmental roll-ups.

View Creation: Established several optimized views (e.g., HR_Final_EmployeeReport_View) to create a single, simplified master dataset by integrating employee, department, job role, latest salary, and latest performance data.

Case Logic: Used CASE statements to quantify qualitative data (e.g., converting "Excellent" to 5) for numerical analysis.

## **Technologies Used**
- **Database:** MySQL  
- **Tools:** MySQL Workbench 
- **Language:** SQL  

   git clone https://github.com/<your-username>/HR-Database-Project.git
