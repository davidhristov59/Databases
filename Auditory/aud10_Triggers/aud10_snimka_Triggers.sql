CREATE TABLE DEPARTMENT(
                           dptID INT PRIMARY KEY ,
                           name VARCHAR(50) NOT NULL,
                           location VARCHAR(50),
                           boss INT,
                           CONSTRAINT fk_boss FOREIGN key(boss) REFERENCES EMPLOYEE(empID) ON DELETE set NULL
);

CREATE TABLE EMPLOYEE (
                          empID INT PRIMARY KEY ,
                          name VARCHAR(50) NOT NULL ,
                          surname VARCHAR(50) NOT NULL,
                          salary DECIMAL(18,2) not NULL,
                          dptID INT,
                          manager INT,
                          CONSTRAINT manager_FK FOREIGN KEY (manager) REFERENCES EMPLOYEE(empID) on DELETE SET NULL, --sama so sebe se referencira
                          CONSTRAINT dpt_id_FK FOREIGN KEY (dptid) REFERENCES DEPARTMENT(dptid) on DELETE SET NULL
);


INSERT INTO DEPARTMENT (dptID, name, location, boss) VALUES
                                                         (1, 'Human Resources', 'New York', 101),
                                                         (2, 'Finance', 'San Francisco', 102),
                                                         (3, 'Engineering', 'Austin', 103),
                                                         (4, 'Marketing', 'Chicago', 104),
                                                         (5, 'Sales', 'Seattle', 105),
                                                         (6, 'IT', 'Boston', 106),
                                                         (7, 'Legal', 'Washington DC', 107),
                                                         (8, 'Research', 'Denver', 108),
                                                         (9, 'Operations', 'Houston', 109),
                                                         (10, 'Customer Service', 'Phoenix', 110);


INSERT INTO EMPLOYEE (empID, name, surname, salary, dptID, manager) VALUES
                                                                        (101, 'Alice', 'Johnson', 90000, 1, NULL),
                                                                        (102, 'Bob', 'Smith', 95000, 2, NULL),
                                                                        (103, 'Carol', 'Williams', 120000, 3, NULL),
                                                                        (104, 'David', 'Brown', 85000, 4, NULL),
                                                                        (105, 'Eve', 'Davis', 78000, 5, NULL),
                                                                        (106, 'Frank', 'Wilson', 89000, 6, NULL),
                                                                        (107, 'Grace', 'Moore', 115000, 7, NULL),
                                                                        (108, 'Hank', 'Taylor', 125000, 8, NULL),
                                                                        (109, 'Ivy', 'Anderson', 98000, 9, NULL),
                                                                        (110, 'Jack', 'Thomas', 72000, 10, NULL),
                                                                        (111, 'Kim', 'Martin', 60000, 1, NULL),
                                                                        (112, 'Leo', 'Garcia', 75000, 2, NULL),
                                                                        (113, 'Mia', 'Martinez', 67000, 3, NULL),
                                                                        (114, 'Nina', 'Robinson', 81000, 4, NULL),
                                                                        (115, 'Oscar', 'Clark', 73000, 5, NULL),
                                                                        (116, 'Pam', 'Rodriguez', 91000, 6, NULL),
                                                                        (117, 'Quinn', 'Lewis', 88000, 7, NULL),
                                                                        (118, 'Ray', 'Walker', 94000, 8, NULL),
                                                                        (119, 'Sara', 'Hall', 77000, 9, NULL),
                                                                        (120, 'Tom', 'Allen', 62000, 10, NULL),
                                                                        (121, 'Uma', 'Young', 88000, 3, NULL),
                                                                        (122, 'Victor', 'King', 86000, 4, NULL),
                                                                        (123, 'Wendy', 'Scott', 73000, 6, NULL),
                                                                        (124, 'Xander', 'Green', 97000, 8, NULL),
                                                                        (125, 'Yara', 'Adams', 88000, 7, NULL),
                                                                        (126, 'Zane', 'Baker', 65000, 5, NULL);

ALTER TABLE DEPARTMENT
    ADD total_salary DECIMAL (15,2) DEFAULT 0 not NULL;

select * from DEPARTMENT

--snimka aud
--z1
CREATE TRIGGER TR_update_manager
    before UPDATE OF boss on DEPARTMENT --pred promenata
    FOR EACH ROW
    WHEN NEW.boss IS NOT NULL
BEGIN
update EMPLOYEE
set manager = NEW.boss
WHERE dptid = OLD.dptID; --definirame kaj koi redovi ke napravivme promena
END;


--z2
CREATE TRIGGER TR_location
    before update OF location on DEPARTMENT
    FOR EACH ROW
    WHEN NEW.location is NOT NULL
BEGIN
SET NEW.location = upper(NEW.location) --novata vrednost ja pretvarame vo golemi bukvi
END;


--total_salary treba da e konzistentna

--z3
--Вметнување на нови торки за вработени
create TRIGGER TR_insert_employees
    AFTER INSERT ON EMPLOYEE --после додавање на торка на вработен
    FOR EACH ROW
    WHEN NEW.dptID IS NOT NULL
BEGIN
UPDATE DEPARTMENT
SET total_salary = total_salary + NEW.salary
WHERE dptid = NEW.dptID ;
END;


--z4
--Промена на платата на постоечки вработени
CREATE TRIGGER TR_change_salary
    AFTER UPDATE OF salary ON EMPLOYEE
    FOR EACH ROW
BEGIN
UPDATE DEPARTMENT
SET total_salary = total_salary - OLD.salary + NEW.salary --ke ja dodademe razlikata na platata za vraboteniot za odreden deparrmtent
where dptid = NEW.dptID; --Ensures that the update is applied only to the department (DEPARTMENT) to which the updated employee (EMPLOYEE) belongs. NEW.dptID: Refers to the department ID (dptID) of the employee after the update.
END;

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

