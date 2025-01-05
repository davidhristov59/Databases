CREATE TABLE PART (
                      PARTNUM INT PRIMARY KEY,           -- Unique identifier for the part
                      DESCRIPTION VARCHAR(100),          -- Description of the part
                      PRICE DECIMAL(10, 2)               -- Price of the part
);

CREATE TABLE ORDERS2 (
                        ORDEREDON DATE,                    -- Date the order was placed
                        NAME VARCHAR(100),                 -- Name of the customer
                        PARTNUM INT,                       -- Foreign key referencing PART
                        QUANTITY INT,                      -- Quantity ordered
                        REMARKS VARCHAR(50),               -- Remarks for the order
                        FOREIGN KEY (PARTNUM) REFERENCES PART(PARTNUM)
);

INSERT INTO PART (PARTNUM, DESCRIPTION, PRICE) VALUES
                                                   (54, 'PEDALS', 54.25),
                                                   (42, 'SEATS', 24.50),
                                                   (46, 'TIRES', 15.25),
                                                   (23, 'MOUNTAIN BIKE', 350.45),
                                                   (76, 'ROAD BIKE', 530.00),
                                                   (10, 'TANDEM', 1200.00);


INSERT INTO ORDERS2 (ORDEREDON, NAME, PARTNUM, QUANTITY, REMARKS) VALUES
                                                                     ('1996-05-15', 'TRUE WHEEL', 23, 6, 'PAID'),
                                                                     ('1996-05-19', 'TRUE WHEEL', 76, 3, 'PAID'),
                                                                     ('1996-09-02', 'TRUE WHEEL', 10, 1, 'PAID'),
                                                                     ('1996-06-30', 'TRUE WHEEL', 42, 8, 'PAID'),
                                                                     ('1996-06-30', 'BIKE SPEC', 54, 10, 'PAID'),
                                                                     ('1996-05-30', 'BIKE SPEC', 10, 2, 'PAID'),
                                                                     ('1996-05-30', 'BIKE SPEC', 23, 8, 'PAID'),
                                                                     ('1996-01-17', 'BIKE SPEC', 76, 11, 'PAID'),
                                                                     ('1996-01-17', 'LE SHOPPE', 76, 5, 'PAID'),
                                                                     ('1996-06-01', 'LE SHOPPE', 10, 3, 'PAID'),
                                                                     ('1996-06-01', 'AAA BIKE', 10, 1, 'PAID'),
                                                                     ('1996-07-01', 'AAA BIKE', 76, 4, 'PAID'),
                                                                     ('1996-07-01', 'AAA BIKE', 46, 14, 'PAID'),
                                                                     ('1996-07-11', 'JACKS BIKE', 76, 14, 'PAID');


SELECT * FROM PART;
SELECT * FROM ORDERS2;

--VGNEZDENI QUERIES

--1
SELECT *
FROM ORDERS2
WHERE PARTNUM IN (SELECT PARTNUM
                  FROM PART
                  WHERE PART.DESCRIPTION LIKE 'ROAD%');

--2
SELECT AVG(p.PRICE * o.QUANTITY) AS AVG_PRICE --prosecna cena na narackite - moram so mnozenje vaka bidejki vo naracki nemam price
FROM PART p, ORDERS2 o
WHERE o.PARTNUM = p.partnum;

--3
SELECT O.NAME, O.ORDEREDON
FROM ORDERS2 O, PART P
WHERE O.PARTNUM = P.PARTNUM AND O.QUANTITY * P.PRICE > (SELECT AVG(o1.QUANTITY * p1.PRICE)
                                                        FROM ORDERS2 o1, PART p1
                                                        WHERE o1.PARTNUM = p1.PARTNUM);

--4
SELECT O.NAME, AVG(QUANTITY) AS AVG_QUANTITY
FROM ORDERS2 O
GROUP BY O.NAME;

--5
SELECT O.NAME, AVG(QUANTITY) as AVG_QUANTITY
FROM ORDERS2 O
GROUP BY O.NAME
HAVING AVG(QUANTITY) > (SELECT AVG(QUANTITY) --просечната нарачана количина по нарачател да биде поголема од просечната нарачана количина за сите нарачки:
                        FROM ORDERS2 O2);

--6
--BITNA !!!
SELECT o.PARTNUM, SUM(o.QUANTITY * p.PRICE) AS TOTAL, COUNT(o.PARTNUM) as BrojNaracki
FROM ORDERS2 o, PART p
WHERE o.PARTNUM = P.PARTNUM
GROUP BY o.PARTNUM
--Дополнително да се отфрлата  сите шифри на производи зкои вкупната сума е помала или еднаква на просечната остварена продажба за тој ПРОИЗВОД.
HAVING sum(o.QUANTITY * p.PRICE) <= (SELECT AVG(o1.QUANTITY * p1.PRICE)
                                    FROM orders2 o1, PART p1
                                    WHERE o1.PARTNUM = p1.PARTNUM AND p1.PARTNUM = o.PARTNUM);


