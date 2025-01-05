CREATE TABLE Market(
    ID INT PRIMARY KEY ,
    ime VARCHAR(30),
    adresa VARCHAR(30),
    grad VARCHAR(30),
    rejting INT,
    rakovoditel VARCHAR(30),
    rabotnoVremeOd INT,
    rabotnoVremeDo INT
);

CREATE TABLE Korisnik2(
    ID INT PRIMARY KEY,
    korisnickoIme VARCHAR(40),
    lozinka VARCHAR(20),
    email VARCHAR(30)
);

CREATE TABLE Specijalitet(
    kod INT PRIMARY KEY ,
    ime VARCHAR(30),
    tip VARCHAR(30)
);

CREATE TABLE Narachka(
    ID INT PRIMARY KEY,
    marketID INT,
    specijalitetKod INT,
    korisnikID INT,
    datum DATE,
    CONSTRAINT NarachkaMarketFK FOREIGN KEY (marketID) REFERENCES Market(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT NarachkaSpecijalitetFK FOREIGN KEY (specijalitetKod) REFERENCES Specijalitet(kod) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT NarachkaKorisnikFK FOREIGN KEY (korisnikID) REFERENCES Korisnik2(ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT datumCheck CHECK ( datum >= '2010-10-20')
);


CREATE TABLE Prodazhba(
    marketID INT,
    specijalitetKod INT,
    cena INT,
    PRIMARY KEY (marketID, specijalitetKod),
    CONSTRAINT ProdazbaMarketFK FOREIGN KEY (marketID) REFERENCES Market(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ProdazbaSpecijalitetFK FOREIGN KEY (specijalitetKod) REFERENCES Specijalitet(kod) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AdresiDostava(
    narachkaID INT,
    adresa VARCHAR(30) ,
    PRIMARY KEY (narachkaID, adresa)
);

CREATE TABLE Proizvod(
   kod INT PRIMARY KEY ,
   kategorija VARCHAR(30),
   datumV DATE,
   datumP DATE
);

CREATE TABLE SpecijalitetSostav(
    proizvodKod INT,
    specijalitetKod INT,
    PRIMARY KEY (proizvodKod, specijalitetKod),
    FOREIGN KEY (proizvodKod) REFERENCES Proizvod(kod),
    FOREIGN KEY (specijalitetKod) REFERENCES Specijalitet(kod)
);


