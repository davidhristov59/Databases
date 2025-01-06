CREATE TABLE DEPARTMENT_TRIGGERS (
                                     dptID INT PRIMARY KEY ,
                                     name VARCHAR(50),
                                     location VARCHAR(50)
);

CREATE TABLE EMPLOYEE_TRIGGERS2 (
                                    empID INT PRIMARY KEY ,
                                    name VARCHAR(50),
                                    surname VARCHAR(50),
                                    salary FLOAT,
                                    dptID INT,
                                    FOREIGN KEY (dptid) REFERENCES DEPARTMENT_TRIGGERS(dptid) on DELETE CASCADE ON UPDATE CASCADE
)

-- Insert sample records for DEPARTMENT
INSERT INTO DEPARTMENT_TRIGGERS VALUES
                                    (1, 'Human Resources', 'New York'),
                                    (2, 'Finance', 'San Francisco'),
                                    (3, 'Engineering', 'Austin'),
                                    (4, 'Marketing', 'Chicago'),
                                    (5, 'Sales', 'Seattle'),
                                    (6, 'IT', 'Boston'),
                                    (7, 'Legal', 'Washington DC'),
                                    (8, 'Research', 'Denver'),
                                    (9, 'Operations', 'Houston'),
                                    (10, 'Customer Service', 'Phoenix');

-- Insert sample records for EMPLOYEE
INSERT INTO EMPLOYEE_TRIGGERS2 VALUES
                                   (101, 'Alice', 'Johnson', 90000, 1),
                                   (102, 'Bob', 'Smith', 95000, 2),
                                   (103, 'Carol', 'Williams', 120000, 3),
                                   (104, 'David', 'Brown', 85000, 4),
                                   (105, 'Eve', 'Davis', 78000, 5),
                                   (106, 'Frank', 'Wilson', 89000, 6),
                                   (107, 'Grace', 'Moore', 115000, 7),
                                   (108, 'Hank', 'Taylor', 125000, 8),
                                   (109, 'Ivy', 'Anderson', 98000, 9),
                                   (110, 'Jack', 'Thomas', 72000, 10),
                                   (111, 'Kim', 'Martin', 60000, 1),
                                   (112, 'Leo', 'Garcia', 75000, 2),
                                   (113, 'Mia', 'Martinez', 67000, 3),
                                   (114, 'Nina', 'Robinson', 81000, 4),
                                   (115, 'Oscar', 'Clark', 73000, 5),
                                   (116, 'Pam', 'Rodriguez', 91000, 6),
                                   (117, 'Quinn', 'Lewis', 88000, 7),
                                   (118, 'Ray', 'Walker', 94000, 8),
                                   (119, 'Sara', 'Hall', 77000, 9),
                                   (120, 'Tom', 'Allen', 62000, 10),
                                   (121, 'Uma', 'Young', 88000, 3),
                                   (122, 'Victor', 'King', 86000, 4),
                                   (123, 'Wendy', 'Scott', 73000, 6),
                                   (124, 'Xander', 'Green', 97000, 8),
                                   (125, 'Yara', 'Adams', 88000, 7),
                                   (126, 'Zane', 'Baker', 65000, 5);

--Zorica file
--z1 

--Write a trigger TR\_update\_department that is activated after updating the ID of a particular department.
--The trigger should set the new ID of the department to all employees in that department.

--1 nacin
CREATE TRIGGER TR_update_department3
    AFTER UPDATE ON DEPARTMENT_TRIGGERS
BEGIN
UPDATE EMPLOYEE_TRIGGERS2
SET dptid = NEW.dptID
WHERE dptid = OLD.dptID;
END;
--koga ke se azurira ID-to na departmentot  vo Departments tabelata, isto taka ek se azurira i dptID vo Employees tabelata


--2 nacin
CREATE TRIGGER TR_update_departmentNEW
    AFTER UPDATE OF dptid ON DEPARTMENT_TRIGGERS
    for each row
BEGIN
update EMPLOYEE_TRIGGERS
SET dptid = NEW.dptID
WHERE dptID = OLD.dptID;
end;



--PROVERKA - kaj sto ima 1 vo dptID ke se zameni so 10
UPDATE DEPARTMENT_TRIGGERS
SET dptid = 10
WHERE dptid = 1


--Z2 
--Write a trigger that monitors the attribute location in the DEPARTMENT table. 
--Before updating the value of the location, the new value should consist of only uppercase letters.

--1 nacin 
CREATE TRIGGER TR_caps_location
    BEFORE UPDATE ON DEPARTMENT_TRIGGERS
    FOR EACH ROW
BEGIN
-- Directly assign the uppercase value to NEW.location
UPDATE DEPARTMENT_TRIGGERS
SET location = NEW.dptID
WHERE dptid = OLD.dptID;
END;


--2 nacin
CREATE TRIGGER TR_location_NEW
    BEFORE UPDATE OF location ON DEPARTMENT_TRIGGERS
    FOR EACH ROW
    WHEN NEW.location is NOT NULL
BEGIN
SET NEW.location = UPPER(NEW.location)
END;

--testing 
UPDATE DEPARTMENT_TRIGGERS
SET location = 'miami'
WHERE dptID = 3;

--stavi MIAMI kaj sto ima dptID = 3 


--Z3 
--Add an attribute totalSalary in the DEPARTMENT table that stores the total salary of all the employees in that department.

ALTER TABLE DEPARTMENT_TRIGGERS
    ADD COLUMN totalSalary DECIMAL(18,2) DEFAULT 0;

SELECT * FROM DEPARTMENT_TRIGGERS

WITH salary_as_dept AS (
    SELECT e.dptID, SUM(salary) as total_salary
    from EMPLOYEE_TRIGGERS2  e
)

UPDATE DEPARTMENT_TRIGGERS
SET totalsalary = (select salary
                   FROM salary_as_dept s
                   WHERE DEPARTMENT_TRIGGERS.dptID = s.dptID)


--Z4
--Вметнување на нови торки за вработени

CREATE TRIGGER TR_total1_NEW
    AFTER INSERT ON EMPLOYEE_TRIGGERS2
    FOR EACH ROW
BEGIN
UPDATE DEPARTMENT_TRIGGERS
SET totalsalary = NEW.totalsalary + totalsalary
where dptid = NEW.dptID;
END;

--proverka
INSERT INTO EMPLOYEE_TRIGGERS2 VALUES (130, 'John', 'Doe', 65000, 5);
--ke ima promena vo DEPARTMENT tabelata kaj dptiD = 5 vo total_salary


--Z5 
--Промена на платата на постоечки вработени 
--The salary of an existing employee is updated.

CREATE TRIGGER TR_update_existing_employee
    AFTER UPDATE Of salary on EMPLOYEE_TRIGGERS2
    FOR EACH ROW
BEGIN
UPDATE EMPLOYEE_TRIGGERS2
set totalsalary = totalsalary - OLD.salary + NEW.salary
WHERE dptID = NEW.dptID;
END;

--proverka 
UPDATE EMPLOYEE_TRIGGERS2
SET salary = 95000
WHERE empID = 130;

--za daden employee empID = 130 ,update mu ja platata na 95000

--Z6
--Прераспределба на постоечки вработени од еден во друг оддел
--Moving an employee from one department to another.

CREATE TRIGGER TR_moving_employee
    AFTER UPDATE OF dptid ON EMPLOYEE_TRIGGERS2
    FOR EACH ROW
    when NEW.dptID is not NULL
BEGIN
UPDATE DEPARTMENT_TRIGGERS
SET totalsalary = totalsalary + NEW.salary
WHERE dptid = NEW.dptID

UPDATE DEPARTMENT_TRIGGERS
SET totalsalary = totalsalary + NEW.salary
WHERE dptid = OLD.dptID
END;

--proverka
UPDATE EMPLOYEE
SET dptID = 2
WHERE empID = 130;


--Z7
--Бришење на торки за вработени
CREATE TRIGGER delete_employees
    AFTER DELETE ON EMPLOYEE_TRIGGERS2
    FOR EACH ROW
BEGIN

UPDATE DEPARTMENT_TRIGGERS
SET totalsalary = totalsalary - OLD.salary
WHERE dptID = OLD.dptID;
end;

--proverka
DELETE
FROM EMPLOYEE_TRIGGERS2
WHERE empID = 130;

--Z8
--Да се напише тригер кој ќе го одржува референтниот интегритет на базата и ќе извршува каскадно бришење на сите информации поврзани со одделите кои се бришат од  базата.
CREATE TRIGGER TR_cascade_delete
    AFTER DELETE ON DEPARTMENT_TRIGGERS
    FOR EACH ROW
BEGIN
DELETE FROM EMPLOYEE_TRIGGERS2
WHERE dptid = OLD.dptID;
end;

-- proverka 
DELETE
FROM DEPARTMENT
WHERE dptID = 10;
