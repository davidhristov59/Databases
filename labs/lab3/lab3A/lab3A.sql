CREATE TABLE Vraboten(
    ID INT PRIMARY KEY ,
    ime VARCHAR(20),
    prezime VARCHAR(20),
    datum_r DATE,
    datum_v DATE,
    obrazovanie VARCHAR(20),
    plata INT,
    CONSTRAINT check_vraboten CHECK ( obrazovanie IN ('PhD', 'MSc', 'High School','BSc')),
    CONSTRAINT datum_vraboten CHECK(datum_r > datum_v)
);

CREATE TABLE Shalterski_rabotnik(
    ID INT PRIMARY KEY,
    CONSTRAINT sh_rabotnfk FOREIGN KEY (ID) REFERENCES Vraboten(ID)
);

CREATE TABLE Klient(
   MBR_k INT PRIMARY KEY,
   ime VARCHAR(50),
   prezime VARCHAR(50),
   adresa VARCHAR(50) DEFAULT 'Ne e navedena',
   datum DATE
);

CREATE TABLE Smetka(
    MBR_k INT,
    broj INT,
    valuta VARCHAR(10),
    saldo INT,
    CONSTRAINT smetkaPK PRIMARY KEY (MBR_k, broj),
    CONSTRAINT smetkaFK FOREIGN KEY (MBR_k) REFERENCES Klient(MBR_k) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Transakcija_shalter(
   ID INT PRIMARY KEY ,
   ID_v INT,
   MBR_k INT,
   MBR_k_s INT,
   broj INT,
   datum DATE,
   suma NUMERIC,
   tip VARCHAR(20),
   CONSTRAINT ts_shal_vrab_fk FOREIGN KEY (ID_v) REFERENCES Shalterski_rabotnik(ID) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT ts_klient_fk FOREIGN KEY (MBR_k) REFERENCES Klient(MBR_k) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT ts_smetka_fk FOREIGN KEY (MBR_k_s, broj) REFERENCES Smetka(MBR_k, broj) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT datum_izvrsuvanje CHECK ( NOT (datum >= '2020-12-30' AND datum <= '2021-01-14')),
   CONSTRAINT tip_transakcija CHECK(tip IN ('uplata', 'isplata'))
);

CREATE TABLE Bankomat(
    ID INT PRIMARY KEY ,
    lokacija VARCHAR(50) UNIQUE ,
    datum DATE,
    zaliha INT CHECK ( zaliha >= 0)
);

CREATE TABLE Transakcija_bankomat(
    ID INT PRIMARY KEY,
    MBR_k_s INT,
    broj INT,
    ID_b INT DEFAULT -1,
    datum DATE,
    suma INT,
    CONSTRAINT tb_smetka_fk FOREIGN KEY (MBR_k_s, broj) REFERENCES Smetka(MBR_k, broj) ON DELETE CASCADE ON UPDATE CASCADE ,
    CONSTRAINT tb_bankomat_fk FOREIGN KEY (ID_b) REFERENCES Bankomat(ID) ON DELETE CASCADE ON UPDATE CASCADE
);