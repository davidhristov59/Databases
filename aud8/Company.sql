CREATE TABLE EMPLOYEE
(
    Fname VARCHAR(20),
    Minit CHAR(1),
    Lname VARCHAR(20),
    Ssn	  CHAR(9) PRIMARY KEY ,
    Bdate DATE,
    Address	VARCHAR(30),
    Sex	CHAR(1),
    Salary	NUMERIC(5),
    Super_ssn	CHAR(9),
    Dno	NUMERIC(1),
    FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE (Ssn)  --reccurent relation. Ex. An employee can be a boss and also just an employee
);

INSERT INTO EMPLOYEE VALUES ('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5);
INSERT INTO EMPLOYEE VALUES ('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000, '987654321', 4);
INSERT INTO EMPLOYEE VALUES ('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, '888665555', 4);
INSERT INTO EMPLOYEE VALUES ('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5);
INSERT INTO EMPLOYEE VALUES ('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000, '987654321', 4);
INSERT INTO EMPLOYEE VALUES ('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, null, 1);

-- Prvo pravam insert na James bidejki James nema SuperSSN i nema supervisori nad nego. Potoa pravam insert na toj sto go ima SuperSSN kako SSN na James sto znaci Alicia e supervizor na James i taka natamu

SELECT * FROM EMPLOYEE;

CREATE TABLE DEPARTMENT
(
    Dname		VARCHAR(20),
    Dnumber		NUMERIC(1) PRIMARY KEY ,
    Mgr_ssn		CHAR(9),
    Mgr_start_date	DATE,

    FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE (Ssn)
);

INSERT INTO DEPARTMENT VALUES ('Headquarters', 1, '888665555', '1981-06-19');
INSERT INTO DEPARTMENT VALUES ('Research', 5, '333445555', '1988-05-22');
INSERT INTO DEPARTMENT VALUES ('Administration', 4, '987654321', '1995-01-01');

SELECT * FROM DEPARTMENT;

--Za Department 1 glaven menadzer e James bidejki go ima toj SSN vo Mgr_ssn

-- this alter is needed to allow PROJECT and DEPARTMENT to reference each other
ALTER TABLE EMPLOYEE ADD FOREIGN KEY (Dno) REFERENCES DEPARTMENT (Dnumber);

CREATE TABLE PROJECT
(
    Pname		VARCHAR(20),
    Pnumber		NUMERIC(3),
    Plocation	VARCHAR(20),
    Dnum NUMERIC(1),

    PRIMARY KEY (Pnumber),
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
);

INSERT INTO PROJECT VALUES ('ProductX', 1, 'Bellaire', 5);
INSERT INTO PROJECT VALUES ('ProductY', 2, 'Sugarland', 5);
INSERT INTO PROJECT VALUES ('ProductZ', 3, 'Houston', 5);
INSERT INTO PROJECT VALUES ('Computerization', 10, 'Stafford', 4);
INSERT INTO PROJECT VALUES ('Reorganization', 20, 'Houston', 1);
INSERT INTO PROJECT VALUES ('Newbenefits', 30, 'Stafford', 4);

SELECT * FROM PROJECT;

CREATE TABLE WORKSON
(
    Essn		CHAR(9),
    Pno		NUMERIC(3),
    Hours	NUMERIC(3,1),

    PRIMARY KEY (Essn, Pno),

    FOREIGN KEY (Essn)
        REFERENCES EMPLOYEE (Ssn),

    FOREIGN KEY (Pno)
        REFERENCES PROJECT(Pnumber)
);

INSERT INTO WORKSON VALUES ('123456789', 1, 32.5);
INSERT INTO WORKSON VALUES ('123456789', 2, 7.5);
INSERT INTO WORKSON VALUES ('666884444', 3, 40.0);
INSERT INTO WORKSON VALUES ('453453453', 1, 20.0);
INSERT INTO WORKSON VALUES ('453453453', 2, 20.0);
INSERT INTO WORKSON VALUES ('333445555', 2, 10.0);
INSERT INTO WORKSON VALUES ('333445555', 3, 10.0);
INSERT INTO WORKSON VALUES ('333445555', 10, 10.0);
INSERT INTO WORKSON VALUES ('333445555', 20, 10.0);
INSERT INTO WORKSON VALUES ('999887777', 30, 30.0);
INSERT INTO WORKSON VALUES ('999887777', 10, 10.0);
INSERT INTO WORKSON VALUES ('987987987', 10, 35.0);
INSERT INTO WORKSON VALUES ('987987987', 30, 5.0);
INSERT INTO WORKSON VALUES ('987654321', 30, 20.0);
INSERT INTO WORKSON VALUES ('987654321', 20, 15.0);
INSERT INTO WORKSON VALUES ('888665555', 20, null);

SELECT * FROM WORKSON;

CREATE TABLE DEPENDENT
(
    Essn		CHAR(9),
    DependentName	VARCHAR(20),
    Sex		CHAR(1),
    Bdate		DATE,
    Relationship 	VARCHAR(10),

    PRIMARY KEY (Essn, DependentName),

    FOREIGN KEY (Essn)
        REFERENCES EMPLOYEE (Ssn)
);

INSERT INTO DEPENDENT VALUES ('333445555', 'Alice', 'F', '1986-04-05', 'Daughter');
INSERT INTO DEPENDENT VALUES ('333445555', 'Theodore', 'M', '1983-10-25', 'Son');
INSERT INTO DEPENDENT VALUES ('333445555', 'Joy', 'F', '1958-05-03', 'Spouse');
INSERT INTO DEPENDENT VALUES ('987654321', 'Abner', 'M', '1942-02-28', 'Spouse');
INSERT INTO DEPENDENT VALUES ('123456789', 'Michael', 'M', '1988-01-04', 'Son');
INSERT INTO DEPENDENT VALUES ('123456789', 'Alice', 'F', '1988-12-30', 'Daughter');
INSERT INTO DEPENDENT VALUES ('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

SELECT * FROM DEPENDENT;

CREATE TABLE DEPT_LOCATIONS
(
    Dnumber NUMERIC(3),
    Dlocation VARCHAR(20),

    FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber),
    PRIMARY KEY (Dnumber, Dlocation)
);

INSERT INTO DEPT_LOCATIONS VALUES (1, 'Houston');
INSERT INTO DEPT_LOCATIONS VALUES (4, 'Stafford');
INSERT INTO DEPT_LOCATIONS VALUES (5, 'Bellaire');
INSERT INTO DEPT_LOCATIONS VALUES (5, 'Sugarland');
INSERT INTO DEPT_LOCATIONS VALUES (5, 'Houston');

--Prasalnik0

SELECT Bdate,Address
FROM EMPLOYEE
WHERE Fname='John' AND Minit='B' AND Lname='Smith';

--Prasalnik 25
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Address LIKE '%Houston, TX%';

--Prasalnik 1
SELECT Fname,Lname, Address
FROM EMPLOYEE, DEPARTMENT --2 tabeli koristime
WHERE Dname='Research' AND Dno=Dnumber; --Deparment number mora da e ist so Dno vo Employee


--Prasalnik2
SELECT PROJECT.Pnumber, PROJECT.Dnum, EMPLOYEE.Lname, EMPLOYEE.Address, EMPLOYEE.Bdate
FROM PROJECT, EMPLOYEE, DEPARTMENT
WHERE Plocation='Stafford' AND
      Dnum=DEPARTMENT.Dnumber AND  --go povrzuva proektot so negoviot upravuvacki oddel
      EMPLOYEE.Ssn = DEPARTMENT.Mgr_ssn; --go povrzuva upravuvackiot oddel so vraboteniot koj e rakovoditel na toj oddel


--Prasalnik8
SELECT E.Fname, E.Lname, S.Fname, S.Lname
FROM EMPLOYEE AS E, EMPLOYEE AS S
WHERE E.Super_ssn = S.Ssn; --fakticki ke go zeme ssnot na glavniot od employee i ke napravi join so SSN NA GLAVNIOT

--Q11 - da nemame duplikati
SELECT DISTINCT EMPLOYEE.Salary
FROM EMPLOYEE;

--Prasalnik13
SELECT DISTINCT Essn
FROM WORKSON
WHERE Pno IN (1,2,3);

--Prasalnik14
SELECT EMPLOYEE.Fname,EMPLOYEE.Lname
FROM EMPLOYEE
WHERE Super_ssn IS NULL;

--Prasalnik15 - Agregatni Funkcii
SELECT max(Salary), min(Salary), avg(Salary)
FROM EMPLOYEE;

--Prasalnik16
SELECT max(Salary), min(Salary), avg(Salary)
FROM EMPLOYEE,DEPARTMENT
WHERE DEPARTMENT.Dnumber = EMPLOYEE.Dno  --vrabotenite koi rabotat vo odreden oddel
  AND Dname='Research';

---Prasalnik17
SELECT COUNT(*)
FROM EMPLOYEE;

--Prasalnik18
SELECT COUNT(*)
FROM EMPLOYEE, DEPARTMENT
WHERE Dno=Dnumber AND Dname='Research';

--Prasalnik20
SELECT Dno, COUNT(*), avg(Salary)
FROM EMPLOYEE
GROUP BY Dno; --grupiraj gi po brojot na oddel, znaci ZA SEKOJ ODDEL

--Prasalnik21
SELECT PROJECT.Pnumber, PROJECT.Pname, count(*)
FROM PROJECT, WORKSON
WHERE PROJECT.Pnumber = WORKSON.Pno
GROUP BY Pnumber;

--Prasalnik22
SELECT PROJECT.Pnumber, PROJECT.Pname, COUNT(*)
FROM PROJECT, WORKSON
WHERE WORKSON.Pno = PROJECT.Pnumber
GROUP BY PROJECT.Pnumber
HAVING COUNT(*) > 2; --rabotat poveke od 2 vraboteni

--Prasalnik28
SELECT DEPARTMENT.Dname, EMPLOYEE.LName, EMPLOYEE.FName, PROJECT.Pname
FROM DEPARTMENT,EMPLOYEE,PROJECT,WORKSON
WHERE WORKSON.Pno = PROJECT.Pnumber
  AND DEPARTMENT.Dnumber = EMPLOYEE.Dno
  AND EMPLOYEE.Ssn=WORKSON.Essn
ORDER BY DEPARTMENT.Dname, EMPLOYEE.Lname;

--Trigger
CREATE TABLE Emps_Deleted_Log (
     Fname VARCHAR(50),
     Lname VARCHAR(50)
);

CREATE OR REPLACE FUNCTION log_deleted_employee()
    RETURNS TRIGGER AS $$
BEGIN
    -- Insert the deleted employee's data into the log table
    INSERT INTO Emps_Deleted_Log (Fname, Lname)
    VALUES (OLD.Fname, OLD.Lname);
    RETURN NULL; -- Triggers require a return value in PostgreSQL
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Emp_Delete
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
EXECUTE FUNCTION log_deleted_employee();

--Test the Trigger

--DELETE FROM EMPLOYEE
--WHERE Fname='Ramesh';

--SELECT * FROM Emps_Deleted_Log;

--Views (kreira virtuelna tabela)

CREATE VIEW WORKS_ON_NEW AS
SELECT FNAME, LNAME, PNAME, Hours
FROM EMPLOYEE, PROJECT, WORKSON
WHERE SSN=ESSN AND PNO=PNUMBER;

SELECT WORKS_ON_NEW.Fname, WORKS_ON_NEW.Lname
FROM WORKS_ON_NEW
WHERE PNAME='ProductX';


