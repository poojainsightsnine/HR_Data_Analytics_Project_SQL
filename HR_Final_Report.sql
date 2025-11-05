###########################################################
#  HR Database Analysis Project
#  Author: Pooja Parashar
#  Description: Comprehensive SQL analysis for HR database
#  Includes employee, department, salary, performance & attrition analysis
#  Database: hr
###########################################################
use hr;
############---Employee Details--------########### 
#----1.Display All employees with their departments and job roles.----
select e.emp_id,jr.job_role,d.dept_name from employees as e
join 
departments as d on e.dept_id=d.dept_id
join 
job_roles as jr on jr.job_id=e.job_id;
-- #----2.Find Employees who dont have manager assigned---  
select emp_id,full_name from employees where trim(manager_id) ="" ;
#---3.Display each employees name, manager_name and department----
SELECT 
    e.emp_id,
    m.manager_id,
    e.full_name AS employee_name,
    m.full_name AS manager_name,
    d.dept_name
FROM
    employees AS e
	left JOIN
    employees AS m ON e.manager_id = m.emp_id
    left JOIN
    departments AS d ON d.dept_id = e.dept_id;
#---4.list all employees who joined after 2020----
SELECT 
    emp_id, full_name, year(hire_date)
FROM
    employees
WHERE
    YEAR(hire_date) > 2020
ORDER BY hire_date;
#---5.Find employees whoose salary is above 50000
select emp_id,full_name,salary from employees where salary>50000; 
#######---Department and job role insights----########
-- ---1.show total number of employees in each department---
select count(e.emp_id),d.dept_name from employees as e 
join 
departments as d 
on 
d.dept_id=e.dept_id
group by d.dept_name 
order by count(e.emp_id) desc;
#----2.find the highest and lowest salary in each department-----
select min(e.salary),max(e.salary),d.dept_name from employees as e 
join 
departments as d
on d.dept_id=e.dept_id
group by d.dept_name;
#----3.List all job roles with their average salary-----
select jr.job_role as average_job_role,avg(e.salary) as average_salary from employees as e
join 
job_roles as jr  on e.job_id=jr.job_id
group by job_role;
#---4.find employees whoose salary is higher than their job levels  average---
select e.emp_id,e.salary,jr.job_level,jr.job_level from employees as e
join 
job_roles as jr on e.job_id=jr.job_id
where
 e.salary>(
		select avg(e2.salary) from employees as e2 
        join job_roles as jr2 on jr2.job_id = e2.job_id
        where jr2.job_level=jr.job_level);	
#---5.show department-wise total and average salary---
SELECT 
    d.dept_name,
    AVG(e.salary) AS average_salary,
    SUM(e.salary) AS total_salary
FROM
    employees AS e
        JOIN
    departments AS d ON d.dept_id = e.dept_id
GROUP BY d.dept_name;
-- ---6.Show salary trend by year for each employee---
select e.emp_id,s.salary_amount,s.`year`  from employees as e
left join salaries as s on e.emp_id=s.emp_id
group by e.emp_id,s.salary_amount,s.`year`
order by e.emp_id asc,s.year desc;
#########----Performance and Attirition------#############
#--1.list employees with their latest performance score---
SELECT 
    e.emp_id,
    e.full_name,
    p.performance_score,
    p.`year` AS latest_year
FROM
    performance AS p
        JOIN
    employees AS e ON e.emp_id = p.emp_id
WHERE
    p.`year` = (SELECT 
            MAX(`year`)
        FROM
            performance AS p2
        WHERE
            p2.emp_id = p.emp_id)
ORDER BY e.emp_id;
####----3.find Attirition count per department------
select d.dept_name,count(case e.attrition_flag 
			when "yes" then 1
	  end) as attirition_count
from employees as e     
left join departments as d on d.dept_id=e.dept_id
group by d.dept_name
order by attirition_count desc;
####4.Show department-wise average performance score----
select d.dept_name,round(avg(case p.performance_score 
					   when "Excellent" then 5
                       when "Good" then 4
                       when "Average" then 3
                       when "Below Average" then 2
                       when "Poor" then 1
					end),2) as Average_Performance_Score
from employees as e 
join
performance as p on e.emp_id=p.emp_id 
join 
departments as d on e.dept_id=d.dept_id
group by d.dept_name;
###---5.Show Attirition rate per department----
select d.dept_name,round(count(case e.attrition_flag 
			when "yes" then 1
	  end)/count(e.emp_id),2)*100 as attirition_rate_percentage
from employees as e     
left join departments as d on d.dept_id=e.dept_id
group by d.dept_name
order by attirition_rate desc;
-- ----6.count how many employees fall in each performance category-----
select count(e.emp_id),p.performance_score from employees as e 
join performance as p on e.emp_id=p.emp_id
group by p.performance_score 
order by count(e.emp_id) desc;
###---Hr Summary Table---
SELECT 
    e.emp_id,
    e.full_name,
    e.gender,
    e.age,
    d.dept_name,
    jr.job_role,
    jr.job_level,
    e.salary,
    e.hire_date,
    e.manager_id,
    e.attrition_flag
FROM
    employees AS e
        JOIN
    departments AS d ON d.dept_id = e.dept_id
        JOIN
    job_roles AS jr ON e.job_id = jr.job_id;
###########MasterTableForHR###########
-- creating view --
create view EmployeeReport_View as
select 
	e.emp_id,
    e.first_name,
    e.last_name,
    e.gender,
    e.age,
    e.hire_date,
    e.salary,
    e.manager_id,
    e.attrition_flag,
    d.dept_id,
    d.dept_name,
    jr.job_id,
    jr.job_role,
    jr.job_level
from employees as e 
join departments as d on e.dept_id=d.dept_id
join job_roles as jr on jr.job_id=e.job_id;
select * from EmployeeReport_View ;
-- 2.creating view for Latest performance score as per employee
create view hr_latest_performance_view as 
select p1.emp_id,p1.performance_score,p1.`year` from performance as p1
where p1.year=(select max(p2.`year`) from performance as p2 where p1.emp_id=p2.emp_id); 
select * from hr_latest_performance_view; 
-- 3.latest salary view---
create view Latest_Salary_View as
select s1.emp_id,
       s1.salary_amount,
       s1.year
       from salaries as s1
       where s1.year = (select max(s2.year) from salaries as s2 where s1.emp_id=s2.emp_id);
-- 4.Combining report+join salary + performance_view
-- drop view  HR_Final_EmployeeReport_View;
create view HR_Final_EmployeeReport_View as 
select 
     EReV.*,
     lpV.performance_score,
     case 
		when lpV.performance_score = "Excellent" then 5
        when lpV.performance_score = "Good" then 4
        when lpV.performance_score = "Average" then 3
        when lpV.performance_score = "Below Average" then 2
        when lpV.performance_score = "Poor" then 1
     End as Performance_score_num,   
     lpV.`year`,
	 lsV.salary_amount
from EmployeeReport_View as EReV
left join hr_latest_performance_view as lpV on lpV.emp_id=EReV.emp_id
left join Latest_Salary_View as lsV on lsV.emp_id=EReV.emp_id;
select * from HR_Final_EmployeeReport_View;

    
     


