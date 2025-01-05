CREATE TABLE SEKTORI (
    SEKTOR INT PRIMARY KEY,         -- Unique identifier for the sector
    IME_SEKTOR VARCHAR(100) NOT NULL, -- Name of the sector
    GRAD VARCHAR(100) NOT NULL        -- City of the sector
);

INSERT INTO SEKTORI (SEKTOR, IME_SEKTOR, GRAD) VALUES
  (1, 'Finance', 'Skopje'),
  (2, 'IT', 'Bitola'),
  (3, 'HR', 'Ohrid');

CREATE TABLE VRABOTENI (
    id INT PRIMARY KEY,
    ime VARCHAR(50),
    kvalifikacija VARCHAR(50),
    plata INT,
    sektor_id INT NOT NULL,
    FOREIGN KEY (sektor_id) REFERENCES SEKTORI(SEKTOR)
);

INSERT INTO VRABOTENI(id, ime, kvalifikacija, plata, sektor_id) VALUES
(1, 'David Hristov', 'MBA', 75000, 1),
(2, 'Igor Stojanov', 'MSc', 50000, 2),
(3, 'Petar Petrov', 'BSc', 30000, 3);

CREATE TABLE PROEKTI(
  id INT PRIMARY KEY,
    ime VARCHAR(50),
    sredstva INT
);

INSERT INTO PROEKTI(id, ime, sredstva) VALUES
(1, 'AI Research', 100000),
(2, 'HR Optimization', 200000),
(3, 'Financial Audit', 300000);

CREATE TABLE UCESTVA(
    id_ucestvo INT ,
    id_vraboten INT,
    id_proekt INT,
    funkcija VARCHAR(50),
    PRIMARY KEY (id_ucestvo,id_vraboten, id_proekt),
    FOREIGN KEY (id_vraboten) REFERENCES VRABOTENI(id),
    FOREIGN KEY (id_proekt) REFERENCES PROEKTI(id)
);

INSERT INTO UCESTVA (id_ucestvo, id_vraboten, id_proekt, FUNKCIJA) VALUES
                                                   (1, 3,1, 'Team Lead'),
                                                   (2, 1,2, 'Developer'),
                                                   (3, 2,3, 'Consultant'),
                                                   (2, 3, 2,'Analyst');

--a
SELECT VRABOTENI.ime, SEKTORI.IME_SEKTOR
FROM VRABOTENI, SEKTORI
WHERE VRABOTENI.sektor_id = SEKTORI.SEKTOR AND
        VRABOTENI.kvalifikacija = 'MSc' AND  --MSc namesto VKV
      VRABOTENI.plata > 10000
ORDER BY ime;

--b
SELECT VRABOTENI.ime
FROM VRABOTENI, SEKTORI
WHERE VRABOTENI.sektor_id = SEKTORI.SEKTOR AND
      SEKTORI.GRAD = 'Skopje';

--v
SELECT DISTINCT SEKTORI.IME_SEKTOR, KVALIFIKACIJA
FROM SEKTORI, VRABOTENI
WHERE SEKTORI.SEKTOR = VRABOTENI.sektor_id
ORDER BY IME_SEKTOR;

--g
SELECT VRABOTENI.IME
FROM VRABOTENI, SEKTORI
WHERE VRABOTENI.sektor_id = SEKTORI.SEKTOR AND
      sektor_id IN (4,7);

--d Razlika megju 2 mnozestva
(SELECT SEKTORI.SEKTOR
FROM SEKTORI)
EXCEPT
(SELECT VRABOTENI.sektor_id
 FROM VRABOTENI);

--gj
SELECT DISTINCT VRABOTENI.id
FROM VRABOTENI
INTERSECT
(SELECT VRABOTENI.id
    FROM VRABOTENI
    WHERE VRABOTENI.kvalifikacija = 'MSc');

--e
SELECT AVG(plata) as prosek
FROM VRABOTENI
WHERE VRABOTENI.kvalifikacija = 'MSc' --MSc namesto VKV
GROUP BY VRABOTENI.id; --moze i bez group by

--zh)
SELECT COUNT(DISTINCT UCESTVA.funkcija)
FROM UCESTVA
WHERE UCESTVA.id_vraboten = 946;
