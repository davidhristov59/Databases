CREATE TABLE COMPANY(
  Cname VARCHAR(50) PRIMARY KEY ,
  address VARCHAR(50),
  city VARCHAR(50),
  country VARCHAR(50)
);

INSERT INTO COMPANY (Cname, address, city, country) VALUES
                                                        ('Company A', '123 Main St', 'New York', 'USA'),
                                                        ('Company B', '456 Elm St', 'London', 'UK'),
                                                        ('Company C', '789 Pine Ave', 'Toronto', 'Canada'),
                                                        ('Company D', '321 Oak Rd', 'Sydney', 'Australia'),
                                                        ('Company E', '654 Maple Ln', 'Dublin', 'Ireland'),
                                                        ('Company F', '987 Cedar Blvd', 'Berlin', 'Germany'),
                                                        ('Company G', '246 Birch St', 'Paris', 'France'),
                                                        ('Company H', '135 Walnut Dr', 'Madrid', 'Spain'),
                                                        ('Company I', '864 Spruce Ct', 'Rome', 'Italy'),
                                                        ('Company J', '975 Cherry Pl', 'Amsterdam', 'Netherlands'),
                                                        ('Company K', '1122 Cedar Ave', 'Seoul', 'South Korea'),
                                                        ('Company L', '2233 Oak Street', 'Beijing', 'China'),
                                                        ('Company M', '3344 Birch Road', 'Cape Town', 'South Africa'),
                                                        ('Company N', '4455 Elm Lane', 'Moscow', 'Russia'),
                                                        ('Company O', '5566 Pine Path', 'Mexico City', 'Mexico');

SELECT * FROM COMPANY;

CREATE TABLE ACCOUNT(
    AccNum INT PRIMARY KEY ,
    type varchar(10),
    balance FLOAT,
    bankName varchar(50)
);

INSERT INTO ACCOUNT (AccNum, type, balance, bankName) VALUES
                                                          (101, 'Savings', 5000.00, 'Bank A'),
                                                          (102, 'Checking', 1500.00, 'Bank B'),
                                                          (103, 'Savings', 7500.00, 'Bank C'),
                                                          (104, 'Checking', 3000.00, 'Bank D'),
                                                          (105, 'Savings', 2000.00, 'Bank E'),
                                                          (106, 'Checking', 10000.00, 'Bank F'),
                                                          (107, 'Savings', 5500.00, 'Bank G'),
                                                          (108, 'Checking', 8000.00, 'Bank H'),
                                                          (109, 'Savings', 4500.00, 'Bank I'),
                                                          (110, 'Checking', 6000.00, 'Bank J'),
                                                          (111, 'Savings', 3200.00, 'Bank K'),
                                                          (112, 'Checking', 2400.00, 'Bank L'),
                                                          (113, 'Savings', 5600.00, 'Bank M'),
                                                          (114, 'Checking', 7800.00, 'Bank N'),
                                                          (115, 'Savings', 9100.00, 'Bank O');


CREATE TABLE PAYMENT(
    Cname varchar(50),
    AccNum INT,
    amount FLOAT,
    late BIT,
    PRIMARY KEY (Cname, AccNum),
    FOREIGN KEY (Cname) REFERENCES COMPANY(Cname),
    FOREIGN KEY (AccNum) REFERENCES ACCOUNT(AccNum)
);

ALTER TABLE PAYMENT
    ALTER COLUMN late TYPE INTEGER USING late::integer;

INSERT INTO PAYMENT(Cname, AccNum, amount, late) VALUES
                                                     ('Company A', 101, 200.00, 0),
                                                     ('Company B', 102, 450.00, 1),
                                                     ('Company C', 103, 300.00, 0),
                                                     ('Company D', 104, 500.00, 1),
                                                     ('Company E', 105, 250.00, 0),
                                                     ('Company F', 106, 600.00, 1),
                                                     ('Company G', 107, 350.00, 0),
                                                     ('Company H', 108, 700.00, 1),
                                                     ('Company I', 109, 400.00, 0),
                                                     ('Company J', 110, 800.00, 1),
                                                     ('Company K', 111, 520.00, 0),
                                                     ('Company L', 112, 630.00, 1),
                                                     ('Company M', 113, 740.00, 0),
                                                     ('Company N', 114, 850.00, 1),
                                                     ('Company O', 115, 960.00, 0);


--A)
-- CTE to extract all information from PAYMENT table
WITH cte_payment AS (
    SELECT *
    FROM PAYMENT
)

SELECT *
FROM cte_payment
LIMIT 5;


-- Use CTE to extract the number of payments that are in the database
WITH cte_payment as(
    SELECT *
    FROM PAYMENT
)

SELECT COUNT(*)
FROM cte_payment;

-- Create temporary table to extract all information from PAYMENT table
SELECT *
INTO temp_payment
FROM PAYMENT;

-- so temp table mozeme da izbroime kolku plakanja ima
SELECT COUNT(*)
FROM temp_payment;

-- Create VIEW to extract all information from PAYMENT table
CREATE VIEW view_payment AS
        SELECT *
        FROM PAYMENT;

SELECT *
FROM view_payment;

--B)
-- Define a CTE that will store payments for account number 104.

WITH cte_payment_account AS ( --celata logika mi e vo CTE, samo go povikuvam dole
    SELECT *
    FROM PAYMENT, ACCOUNT
    WHERE ACCOUNT.AccNum = 104
)

SELECT *
FROM cte_payment_account;

--c)
--Create a view that will store the companies’ names and their postal information (in a single attribute)
CREATE OR REPLACE VIEW company_view2(name, postal_info) AS
SELECT c.Cname, address || ', ' || country
FROM COMPANY c;

SELECT * FROM company_view2;

--d)
--Using CTE, Temp table and View,store the total number of payments made per country and
-- the total amount paid in these payments.

--CTE
WITH country_payments AS (

    SELECT country, count(*) as Total_Payments, SUM(amount) as Total_Amount
    FROM COMPANY c, PAYMENT p
    WHERE p.Cname = c.Cname
    GROUP BY country
)

SELECT *
FROM country_payments
ORDER BY Total_Payments desc
LIMIT 3;

--Temp Table
SELECT country, count(*) as Total_Payments, SUM(amount) as Total_Amount
INTO temp_country
FROM PAYMENT p , COMPANY c
WHERE p.Cname = c.Cname
group by country;

--View
CREATE VIEW Country_view (country, number_of_payments,total_amount) AS
    SELECT country, count(*) as Total_Payments, SUM(amount) as Total_Amount
    FROM COMPANY c, PAYMENT p
    WHERE c.Cname = p.Cname
    group by country;


--Explicit Joins

--test tables
CREATE TABLE table1(
    ID INT,
    Value VARCHAR(10)
);

INSERT INTO Table1 (ID, Value)
VALUES (1,'First'),
       (2,'Second'),
       (3,'Third'),
       (4,'Forth'),
       (5,'Fifth');

CREATE TABLE table2(
    ID INT,
    Value VARCHAR(10));

INSERT INTO Table2 (ID, Value)
VALUES (1,'First'),
       (2,'Second'),
       (3,'Third'),
       (6,'Sixth'),
       (7,'Seventh'),
       (8,'Eighth');

--Inner-Join
SELECT *
FROM table1 t1 INNER JOIN  table2 t2 ON t1.ID = t2.ID; --Со овој тип на спојување ги спојува торките од двете табели за кои важи дека го исполнуваат условот за спојување.

--Left-Outer Join
-- se vrakaat site torki od levata tabela
--A LEFT OUTER JOIN is a type of join in SQL that retrieves all rows from the left table (the table listed before the JOIN keyword) and only the matching rows from the right table (the table listed after the JOIN keyword). If there is no match for a row in the left table, the result will still include the row, but with NULL values for the columns from the right table.
SELECT *
FROM table1 t1 LEFT JOIN table2 t2 ON t1.ID = t2.ID

--Right-Outer Join
--Ова спојување е многу слично на претходното. Единствената разлика е во тоа што тука во резултатот ги имаме сите торки од десната табела и само оние торки од левата табела кои го задоволуваат условот за спојување
SELECT *
FROM table1 t1 RIGHT JOIN table2 t2 ON t1.ID = t2.ID

--FULL OUTER JOIN
--Овој тип на спојување ги враќа сите торки од двете табели без разлика дали ги задоволуваат условите за спојување. За оние торки од левата табела за кои не постои соодветна торка од десната табела сите атрибути од десната табела добиваат вредности NULL
SELECT *
FROM table1 t1 FULL OUTER JOIN table2 t2 ON t1.ID = t2.ID;

--Cross JOIN
--Dekartov Proizvod (site so site)
SELECT *
FROM table1 t1 CROSS JOIN table2 t2;

