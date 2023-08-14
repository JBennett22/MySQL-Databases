#Q0
SELECT		Bdate, Address
FROM		EMPLOYEE
WHERE		Fname='John' AND Minit='B' AND Lname='Smith';	

#Q1
SELECT		Fname, Lname, Address
FROM		EMPLOYEE, DEPARTMENT
WHERE		Dname='Research' AND Dnumber=Dno;

#Q2
SELECT		Pnumber, Dnum, Lname, Address, Bdate
FROM		PROJECT, DEPARTMENT, EMPLOYEE
WHERE		Dnum=Dnumber AND Mgr_ssn=Ssn AND Plocation='Stafford';

#Q8
SELECT		E.Fname, E.Lname, S.Fname, S.Lname AS SupervisorLName
FROM		EMPLOYEE AS E, EMPLOYEE AS S
WHERE		E.Super_ssn = S.Ssn;

#Q9:
SELECT		Ssn
FROM		EMPLOYEE;

#Q10:
SELECT		Ssn,Dname
FROM		EMPLOYEE,DEPARTMENT;

#Q1C:
SELECT		*
FROM		EMPLOYEE
WHERE		Dno=5;

#Q10A:
SELECT		*
FROM		EMPLOYEE, DEPARTMENT;

#Q1D:
SELECT		*
FROM		EMPLOYEE, DEPARTMENT
WHERE		Dno=Dnumber;

#Q11:
SELECT		ALL Salary
FROM		EMPLOYEE;

#Q11A:
SELECT		DISTINCT Salary
FROM		EMPLOYEE;

#Q12:
(SELECT		DISTINCT Pnumber
FROM		PROJECT, DEPARTMENT, EMPLOYEE
WHERE		Dnum=Dnumber AND Mgr_ssn=Ssn
AND Lname='Smith')
UNION
(SELECT		DISTINCT Pnumber
FROM		PROJECT, WORKS_ON, EMPLOYEE
WHERE		Pnumber=Pno AND Essn=Ssn
AND Lname='Smith');

#Q13:
SELECT		E.Fname, E.Lname
FROM		EMPLOYEE AS E
WHERE		Bdate LIKE '__6%';

#Q14:
SELECT		E.Fname, E.Lname, E.Salary
FROM		EMPLOYEE AS E
WHERE		(Dno = 5) AND (Salary BETWEEN 30000 AND 40000);

#Q15:
SELECT		E.Fname, E.Lname, 1.1*E.Salary AS Increased_sal
FROM		EMPLOYEE AS E, WORKS_ON AS W, PROJECT AS P
WHERE		E.Ssn = W.Essn AND W.Pno = P.Pnumber AND P.Pname = 'ProductX';

#Q16:
SELECT		E.Fname, E.Lname, D.Dname 
FROM		EMPLOYEE AS E, DEPARTMENT AS D
WHERE		Dno=Dnumber
ORDER BY	D.Dname ASC, E.Lname ASC;
