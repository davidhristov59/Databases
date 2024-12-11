CREATE TABLE Muzicar(
   id INT PRIMARY KEY,
   ime VARCHAR(50),
   prezime VARCHAR(50),
   datum_ragjanje DATE,
   CONSTRAINT muzicarCheck CHECK(datum_ragjanje < '2005-01-01')
);

CREATE TABLE Muzicar_instrument(

   id_muzicar INT,
   instrument VARCHAR(50) ,
   PRIMARY KEY (id_muzicar, instrument),
   CONSTRAINT muzicar_fk FOREIGN KEY(id_muzicar) REFERENCES Muzicar(id) ON DELETE CASCADE on UPDATE CASCADE,
   CONSTRAINT instrument__muzicar CHECK (instrument IN ('guitar', 'bass', 'drums', 'keyboards' , 'vocals'))
);

CREATE TABLE Koncert(
   id INT PRIMARY KEY,
   datum DATE NOT NULL,
   vreme INT,
   CONSTRAINT koncert_fk FOREIGN KEY(id) REFERENCES Muzicar(id)
);

CREATE TABLE Festival_odrzuvanje(
    id INT PRIMARY KEY ,
    datum_od DATE,
    datum_do DATE
);

CREATE TABLE Bend(
    id INT PRIMARY KEY ,
    ime VARCHAR(50),
    broj_muzicari INT
);

CREATE TABLE Ucestvo_festival(
   id_festival INT ,
   datum_od DATE,
   id_bend INT,
   den INT DEFAULT 1 ,
   vremetraenje_nastap INT,
   plata_nastap INT,
   CONSTRAINT ucestvo_pk PRIMARY KEY (id_festival, datum_od, id_bend),
   CONSTRAINT ucestvo_fk FOREIGN KEY (id_festival, datum_od) REFERENCES Festival_odrzuvanje(id, datum_od) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT ucestvo_fk2 FOREIGN KEY (id_bend) REFERENCES Bend(id) ON DELETE SET NULL ON UPDATE CASCADE
);
