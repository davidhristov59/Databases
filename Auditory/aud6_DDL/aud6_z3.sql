CREATE TABLE S(
                  C INT PRIMARY KEY ,
                  D INT
);

CREATE TABLE T(
                  A INT PRIMARY KEY ,
                  B INT,
                  CONSTRAINT t_fk FOREIGN KEY (B) REFERENCES S(C) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO S VALUES (2, 10), (3, 11), (4, 12), (5, 13);
SELECT * FROM S;

INSERT INTO T VALUES (0, 4), (1, 5), (2, 4), (3, 5);
SELECT * FROM T;

SELECT * FROM S;

DELETE FROM S WHERE C=4;

SELECT * FROM S;
SELECT * FROM T; --kaskadno brisenje na tabelata T referencira kon S

UPDATE S SET C=6 WHERE C=5;

SELECT * FROM S;
SELECT * FROM T;

