-- Table creation for CLIENT
CREATE TABLE CLIENT (
                        clID INT PRIMARY KEY,
                        name VARCHAR(30),
                        passportNo VARCHAR(255),
                        address VARCHAR(50)
);


-- Table creation for ADD_OPT
CREATE TABLE ADD_OPT (
                         aoID INT PRIMARY KEY,
                         description VARCHAR(255),
                         type VARCHAR(10),
                         price DECIMAL
);

-- Table creation for PACKAGE
CREATE TABLE PACKAGE (
                         packID INT PRIMARY KEY,
                         city VARCHAR(50),
                         hotel VARCHAR(50)
);

-- Table creation for T_AGENCY
CREATE TABLE T_AGENCY (
                          taID INT PRIMARY KEY,
                          name VARCHAR(50),
                          address VARCHAR(255),
                          telephone VARCHAR(15)
);

-- Table creation for VACATION
CREATE TABLE VACATION (
                          vacID INT PRIMARY KEY,
                          startDate DATE,
                          endDate DATE,
                          country VARCHAR(20),
                          taID INT,
                          FOREIGN KEY (taID) REFERENCES T_AGENCY(taID)
);

-- Table creation for EMPLOYEE
CREATE TABLE EMPLOYEE_Travel_A (
                          empID INT PRIMARY KEY,
                          name VARCHAR(20),
                          surname VARCHAR(20),
                          birthYear INT,
                          education VARCHAR(15),
                          taID INT,
                          FOREIGN KEY (taID) REFERENCES T_AGENCY(taID)
);

-- Table creation for GUIDE
CREATE TABLE GUIDE (
                       empID INT PRIMARY KEY,
                       FOREIGN KEY (empID) REFERENCES EMPLOYEE_Travel_A(empID)
);

-- Table creation for TRANSPORT
CREATE TABLE TRANSPORT (
                           packID INT,
                           transport VARCHAR(40),
                           PRIMARY KEY (packID, transport),
                           FOREIGN KEY (packID) REFERENCES PACKAGE(packID)
);

-- Table creation for CONTENT
CREATE TABLE CONTENT (
                         vacID INT,
                         packID INT,
                         price DECIMAL,
                         PRIMARY KEY (vacID, packID),
                         FOREIGN KEY (vacID) REFERENCES VACATION(vacID),
                         FOREIGN KEY (packID) REFERENCES PACKAGE(packID)
);

-- Table creation for GUIDANCE
CREATE TABLE GUIDANCE (
                          empID INT,
                          vacID INT,
                            percent DECIMAL,
                          PRIMARY KEY (empID, vacID),
                          FOREIGN KEY (empID) REFERENCES GUIDE(empID),
                          FOREIGN KEY (vacID) REFERENCES VACATION(vacID)
);

-- Table creation for F_LANGUAGE
CREATE TABLE F_LANGUAGE (
                            empID INT,
                            flang VARCHAR(30),
                            PRIMARY KEY (empID, flang),
                            FOREIGN KEY (empID) REFERENCES EMPLOYEE_Travel_A(empID)
);

-- Table creation for CHOICE
CREATE TABLE CHOICE (
                        choiceID INT PRIMARY KEY,
                        clID INT,
                        aoID INT,
                        vacID INT,
                        FOREIGN KEY (clID) REFERENCES CLIENT(clID),
                        FOREIGN KEY (aoID) REFERENCES ADD_OPT(aoID),
                        FOREIGN KEY (vacID) REFERENCES VACATION(vacID)
);

-- Inserting sample records into CLIENT
INSERT INTO CLIENT VALUES (1, 'John Doe', 'AB123456', '123 Main St');


-- Inserting sample records into T_AGENCY
INSERT INTO T_AGENCY VALUES (1, 'TravelCo', '456 Park Ave', '555-1234');
INSERT INTO T_AGENCY VALUES (2, 'TravelTribe', '123 Park Ave', '222-1235');


-- Additional sample records for EMPLOYEE
INSERT INTO EMPLOYEE_Travel_A VALUES (1, 'Alice', 'Smith', 1985, 'Masters', 1);
INSERT INTO EMPLOYEE_Travel_A VALUES (2, 'Bob', 'Johnson', 1980, 'Bachelors', 1);

-- Sample records for GUIDE
INSERT INTO GUIDE VALUES (1);
INSERT INTO GUIDE VALUES (2);

-- Sample records for F_LANGUAGE
INSERT INTO F_LANGUAGE VALUES (1, 'English');
INSERT INTO F_LANGUAGE VALUES (2, 'Spanish');
INSERT INTO F_LANGUAGE VALUES (1, 'French');
INSERT INTO F_LANGUAGE VALUES (2, 'German');

-- Sample records for ADD_OPT
INSERT INTO ADD_OPT VALUES (1, 'Extra luggage', 'Baggage', 50.00);
INSERT INTO ADD_OPT VALUES (2, 'Priority boarding', 'Flight', 30.00);
INSERT INTO ADD_OPT VALUES (3, 'Tour guide', 'Service', 100.00);
INSERT INTO ADD_OPT VALUES (4, 'Travel insurance', 'Insurance', 20.00);

-- Sample records for additional VACATION
INSERT INTO VACATION VALUES (1, '2023-02-10', '2023-02-17', 'Malaysia', 1);
INSERT INTO VACATION VALUES (2, '2023-03-15', '2023-03-22', 'Romania', 1);

-- Sample records for additional PACKAGE
-- Note: Introducing more cities to satisfy certain query conditions
INSERT INTO PACKAGE VALUES (1, 'CityC', 'HotelC');
INSERT INTO PACKAGE VALUES (2, 'CityD', 'HotelD');

-- More records for TRANSPORT
-- Note: These are added to existing records to satisfy query conditions
INSERT INTO TRANSPORT VALUES (1, 'Car');
INSERT INTO TRANSPORT VALUES (2, 'Bicycle');
INSERT INTO TRANSPORT VALUES (2, 'Motorbike');


-- Additional sample records for CONTENT
-- Note: These records correspond to VACATION and PACKAGE
INSERT INTO CONTENT VALUES (1, 1, 200.00);
INSERT INTO CONTENT VALUES (1, 2, 250.00);
INSERT INTO CONTENT VALUES (2, 1, 150.00);
INSERT INTO CONTENT VALUES (2, 2, 300.00);

-- Sample records for CHOICE
-- These records link CLIENT, ADD_OPT, and VACATION
INSERT INTO CHOICE VALUES (1, 1, 1, 1);
INSERT INTO CHOICE VALUES (2, 1, 2, 1);
INSERT INTO CHOICE VALUES (3, 1, 3, 2);
INSERT INTO CHOICE VALUES (4, 1, 4, 2);

-- Sample records for GUIDANCE
-- Assuming 'percent' is the percentage of the total price for a vacation
INSERT INTO GUIDANCE VALUES (1, 1, 10.00);
INSERT INTO GUIDANCE VALUES (2, 1, 15.00);
INSERT INTO GUIDANCE VALUES (1, 2, 12.00);
INSERT INTO GUIDANCE VALUES (2, 2, 18.00);


--Z1
SELECT v.vacID, sum(c.price) as Price
FROM VACATION v INNER JOIN CONTENT c ON v.vacID = c.vacID
WHERE v.country LIKE 'M%a%ia'
group by v.vacID;

--Z2
SELECT p.hotel, count(DISTINCT t.transport) as COUNT_TRANSPORT
FROM PACKAGE p INNER JOIN Transport t ON p.packID = t.packID
group by p.hotel
HAVING count(DISTINCT t.transport) > 1; --go utnale baranjeto , nema 3

--Z3
WITH vacation_cities AS (
    SELECT c.vacID, count(P.city) as num_cities
    FROM CONTENT c INNER JOIN PACKAGE P on c.packID = P.packID
    group by c.vacID
    HAVING count(p.city) >= 2
    )

SELECT v.*
FROM VACATION v INNER JOIN vacation_cities vc ON v.vacID = vc.vacID;

--4 !!!!!!!
WITH vacation_transports AS (
    SELECT c.vacID, count(DISTINCT t.transport) as broj_vozila
    FROM CONTENT c INNER JOIN TRANSPORT t on c.packID = T.packID
    GROUP BY c.vacID
    ),
    max_transports AS (

        SELECT MAX(broj_vozila) as max_transports
        FROM vacation_transports
    )

SELECT v.*
FROM vacation_transports vt INNER JOIN max_transports mt ON vt.broj_vozila = mt.max_transports
    INNER JOIN VACATION v on vt.vacID = v.vacID;


--Zadaca5 !!!
WITH guide_earnings AS (
    SELECT g.empID, sum(g2.percent * c.price / 100) AS total_earnings
    FROM GUIDE g INNER JOIN GUIDANCE G2 on g.empID = G2.empID
        INNER JOIN VACATION V on G2.vacID = V.vacID
        INNER JOIN CONTENT C on V.vacID = C.vacID
    WHERE v.startDate BETWEEN '2023-01-01' AND '2023-12-31' --smenet e datumot vo 2023
    GROUP BY g.empID
),
    average_earnings AS (
        SELECT avg(total_earnings) as avg_earnings
        FROM guide_earnings
    )

SELECT ge.empID, total_earnings as profit
FROM guide_earnings ge CROSS JOIN average_earnings ae  --moze i so ,
WHERE total_earnings > avg_earnings;


--Zadaca6
SELECT c.clID, SUM(DISTINCT c3.price) AS total_sum
FROM CLIENT c
INNER JOIN CHOICE C2 on c.clID = C2.clID
INNER JOIN CONTENT C3 ON c2.vacID = c3.vacID --radi cenata
group by c.clID;


