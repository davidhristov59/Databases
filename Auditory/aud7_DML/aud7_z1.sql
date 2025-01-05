CREATE TABLE isporacateli(
    id INT,
    ime VARCHAR(50),
    status VARCHAR(50),
    grad VARCHAR(50)
);

ALTER TABLE isporacateli
    ADD PRIMARY KEY (id);

CREATE TABLE delovi(
    id INT,
    ime VARCHAR(50),
    boja VARCHAR(50),
    tezina INT
);

ALTER TABLE delovi
    ADD PRIMARY KEY (id);

CREATE TABLE proizvoditeli(
    id INT,
    ime VARCHAR(50),
    grad VARCHAR(50)
);

ALTER TABLE proizvoditeli
    ADD PRIMARY KEY (id);

CREATE TABLE ponudi2(
    id_ponuda INT ,
    id_isporacatel INT,
    id_delovi INT,
    id_proizvoditel INT,
    kolicina INT,
    CENA INT,
    PRIMARY KEY (id_ponuda,id_isporacatel, id_delovi, id_proizvoditel),
    CONSTRAINT ponudi_fk_isp FOREIGN KEY (id_isporacatel) REFERENCES isporacateli(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ponudi_fk_del FOREIGN KEY (id_delovi) REFERENCES delovi(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ponudi_fk_proiz FOREIGN KEY (id_proizvoditel) REFERENCES proizvoditeli(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO isporacateli VALUES (1, 'Isporacatel1', 'aktiven', 'Skopje');
INSERT INTO isporacateli VALUES (2, 'Isporacatel2', 'aktiven', 'Bitola');
INSERT INTO isporacateli VALUES (3, 'Isporacatel3', 'neaktiven', 'Strumica');
INSERT INTO isporacateli VALUES (8, 'Isporacatel8', 'neaktiven', 'Prilep');


INSERT INTO delovi VALUES (1, 'Del1', 'crvena', 10);
INSERT INTO delovi VALUES (2, 'Del2', 'crna', 30);
INSERT INTO delovi VALUES (3, 'Del3', 'plava', 50);
INSERT INTO delovi VALUES (4, 'Del4', 'rozeva', 150);
INSERT INTO delovi VALUES (5, 'Del5', 'portokalova', 250);

INSERT INTO proizvoditeli VALUES (1, 'Proizvoditel1', 'Skopje');
INSERT INTO proizvoditeli VALUES (2, 'Proizvoditel2', 'Bitola');
INSERT INTO proizvoditeli VALUES (3, 'Proizvoditel3', 'Prilep');

INSERT INTO ponudi2 VALUES (1, 1, 1, 1, 10, 1000);
INSERT INTO ponudi2 VALUES (2, 2, 2, 2, 20, 2000);
INSERT INTO ponudi2 VALUES (3, 3, 3, 3, 30, 3000);

--a
SELECT *
FROM proizvoditeli
WHERE grad = 'Skopje' OR grad='Bitola';

--b
SELECT ponudi2.id_isporacatel
FROM ponudi2
WHERE ponudi2.id_delovi = 5 AND ponudi2.id_proizvoditel = 1;

--v
SELECT delovi.boja
FROM ponudi2, delovi
WHERE ponudi2.id_delovi = delovi.id --spored ID-to
    AND ponudi2.id_isporacatel = 8;

--g
SELECT ponudi2.id_delovi
FROM proizvoditeli, ponudi2
WHERE ponudi2.id_proizvoditel = proizvoditeli.id
    AND proizvoditeli.grad = 'Bitola';

--d
SELECT ponudi2.id_delovi
FROM ponudi2, proizvoditeli, delovi, isporacateli
WHERE ponudi2.id_delovi = delovi.id AND
      ponudi2.id_proizvoditel = proizvoditeli.id AND
      ponudi2.id_isporacatel = isporacateli.id AND
      isporacateli.grad = proizvoditeli.grad;



