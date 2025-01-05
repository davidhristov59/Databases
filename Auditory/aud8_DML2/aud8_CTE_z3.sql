CREATE TABLE PASSENGER (
                           passportNo VARCHAR(10) PRIMARY KEY,
                           name VARCHAR(20),
                           surname VARCHAR(20),
                           street VARCHAR(50),
                           number INT,
                           city VARCHAR(20),
                           telephone VARCHAR(20)
);

CREATE TABLE FLIGHT_LINE (
                             line_code VARCHAR(10) PRIMARY KEY,
                             from_flight VARCHAR(20),
                             to_flight VARCHAR(20),
                             depart_time VARCHAR(5),
                             arrive_time VARCHAR(5)
);

CREATE TABLE FLIGHT (
                        line_code VARCHAR(10),
                        flightNo VARCHAR(10),
                        date DATE,
                        PRIMARY KEY (line_code, flightNo),
                        FOREIGN KEY (line_code) REFERENCES FLIGHT_LINE(line_code)
);

CREATE TABLE RESERVATION (
                             passportNo VARCHAR(10),
                             line_code VARCHAR(10),
                             flightNo VARCHAR(10),
                             date DATE,
                             PRIMARY KEY (passportNo, line_code, flightNo, date),
                             FOREIGN KEY (passportNo) REFERENCES PASSENGER(passportNo),
                             FOREIGN KEY (line_code, flightNo) REFERENCES FLIGHT(line_code, flightNo)
);

CREATE TABLE EMPLOYEE_FLIGHT (
                          code INT PRIMARY KEY,
                          name VARCHAR(20),
                          surname VARCHAR(20),
                          salary INT
);

CREATE TABLE CREW (
                      line_code VARCHAR(10),
                      flightNo VARCHAR(10),
                      employeeCode INT,
                      PRIMARY KEY (line_code, flightNo, employeeCode),
                      FOREIGN KEY (line_code, flightNo) REFERENCES FLIGHT(line_code, flightNo),
                      FOREIGN KEY (employeeCode) REFERENCES EMPLOYEE_FLIGHT(code)
);

CREATE TABLE PILOT (
                       code INT PRIMARY KEY,
                       FOREIGN KEY (code) REFERENCES EMPLOYEE_FLIGHT(code)
);

CREATE TABLE PLANE_TYPE (
                            modelNo VARCHAR(10) PRIMARY KEY,
                            manufacturer VARCHAR(20),
                            modelName VARCHAR(20)
);

CREATE TABLE PLANE (
                       serialNo VARCHAR(10),
                       modelNo VARCHAR(10),
                       capacity INT,
                       airworthiness VARCHAR(50),
                       PRIMARY KEY(serialNo, modelNo),
                       FOREIGN KEY (modelNo) REFERENCES PLANE_TYPE(modelNo)
);

CREATE TABLE CAN_FLY (
                         pilotCode INT,
                         modelNo VARCHAR(10),
                         PRIMARY KEY (pilotCode, modelNo),
                         FOREIGN KEY (pilotCode) REFERENCES PILOT(code),
                         FOREIGN KEY (modelNo) REFERENCES PLANE_TYPE(modelNo)
);

INSERT INTO PASSENGER (passportNo, name, surname, street, number, city, telephone)
VALUES
    ('P123456789', 'John', 'Doe', 'Main St', 101, 'New York', '555-1234'),
    ('P987654321', 'Jane', 'Smith', 'Broadway', 202, 'Los Angeles', '555-5678'),
    ('P456789123', 'Alice', 'Johnson', 'Elm St', 303, 'Chicago', '555-8765'),
    ('P654321987', 'Bob', 'Brown', 'Oak St', 404, 'Houston', '555-4321'),
    ('P321654987', 'Charlie', 'Williams', 'Pine St', 505, 'Phoenix', '555-6789');

INSERT INTO FLIGHT_LINE (line_code, from_flight, to_flight, depart_time, arrive_time)
VALUES
    ('L001', 'New York', 'Los Angeles', '08:00', '11:00'),
    ('L002', 'Chicago', 'Houston', '09:30', '12:30'),
    ('L003', 'Phoenix', 'New York', '07:00', '14:00'),
    ('L004', 'Los Angeles', 'Chicago', '13:00', '17:00'),
    ('L005', 'Houston', 'Phoenix', '15:30', '18:30');

INSERT INTO FLIGHT (line_code, flightNo, date)
VALUES
    ('L001', 'F101', '2023-12-01'),
    ('L002', 'F102', '2023-12-02'),
    ('L003', 'F103', '2023-12-03'),
    ('L004', 'F104', '2023-12-04'),
    ('L005', 'F105', '2023-12-25');

INSERT INTO RESERVATION (passportNo, line_code, flightNo, date)
VALUES
    ('P123456789', 'L001', 'F101', '2023-12-01'),
    ('P987654321', 'L002', 'F102', '2023-12-02'),
    ('P456789123', 'L003', 'F103', '2023-12-03'),
    ('P654321987', 'L004', 'F104', '2023-12-04'),
    ('P321654987', 'L005', 'F105', '2023-12-25'),
    ('P456789123', 'L005', 'F105', '2023-12-25');

INSERT INTO EMPLOYEE_FLIGHT (code, name, surname, salary)
VALUES
    (1, 'Paul', 'White', 50000),
    (2, 'Susan', 'Green', 55000),
    (3, 'David', 'Blue', 60000),
    (4, 'Linda', 'Black', 62000),
    (5, 'Mark', 'Gray', 58000),
    (6, 'David', 'Yellow', 45000),
    (7, 'Sarah', 'Gray', 52000);

INSERT INTO CREW (line_code, flightNo, employeeCode)
VALUES
    ('L001', 'F101', 1),
    ('L001', 'F101', 3),
    ('L002', 'F102', 2),
    ('L002', 'F102', 4),
    ('L003', 'F103', 2),
    ('L003', 'F103', 4),
    ('L004', 'F104', 1),
    ('L004', 'F104', 3),
    ('L005', 'F105', 3),
    ('L005', 'F105', 1);

INSERT INTO PILOT (code)
VALUES
    (3),
    (4),
    (5),
    (6),
    (7);

INSERT INTO PLANE_TYPE (modelNo, manufacturer, modelName)
VALUES
    ('PT01', 'Boeing', '737'),
    ('PT02', 'Airbus', 'A320'),
    ('PT03', 'Cessna', 'Citation X'),
    ('PT04', 'Boeing', '747'),
    ('PT05', 'Airbus', 'A380');

INSERT INTO PLANE (serialNo, modelNo, capacity, airworthiness)
VALUES
    ('SN001', 'PT01', 200, 'Certified'),
    ('SN002', 'PT02', 180, 'Certified'),
    ('SN003', 'PT03', 12, 'Certified'),
    ('SN004', 'PT04', 350, 'Certified'),
    ('SN005', 'PT05', 550, 'Certified');

INSERT INTO CAN_FLY (pilotCode, modelNo)
VALUES
    (4, 'PT01'),
    (4, 'PT02'),
    (3, 'PT03'),
    (3, 'PT04'),
    (5, 'PT05');

-- 1. Find the names of all passengers who do not have a flight on 25.12.2015.
WITH Reservation_flight AS (

    SELECT r.flightNo, r.passportNo
    FROM Reservation r INNER JOIN FLIGHT f ON r.flightNo = f.flightNo
    WHERE f.date = '2015-12-25'
)

SELECT p.name
FROM PASSENGER p LEFT JOIN Reservation_flight rf ON p.passportNo = rf.passportNo
WHERE rf.flightNo is null; --koi sto nemaat let


--2. Прикажете го вкупниот број на полетувања во кои учествувал секој пилот, вклучително и оние пилоти кои немаат ниту едно полетување.
SELECT p.code, count(c.line_code)
FROM CREW c RIGHT JOIN PILOT p ON p.code = c.employeeCode
group by p.code
order by p.code;

--3. Најдете ги броевите на пасоши на патниците кои немале полетување управувано од пилотот со код 23412.
CREATE VIEW PILOT_FLIGHT(code, line_code, flightNo) AS
    SELECT p.code, c.line_code, c.flightNo
    FROM CREW c INNER JOIN PILOT p on c.employeeCode = p.code;

SELECT * FROM PILOT_FLIGHT;

CREATE VIEW PASSENGER_FLIGHT(passportNo,line_code,flight_no) AS

    SELECT p.passportNo, r.line_code, r.flightNo
    FROM PASSENGER p INNER JOIN RESERVATION r ON p.passportNo = r.passportNo;

SELECT  * FROM PASSENGER_FLIGHT;

SELECT pf.passportNo
FROM PASSENGER_FLIGHT pf LEFT JOIN PILOT_FLIGHT pil_f ON pf.line_code = pil_f.line_code AND
                                                        pf.flight_no = pil_f.flightNo
WHERE pil_f.code = 23412
group by pf.passportNo;


