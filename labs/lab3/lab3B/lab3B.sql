CREATE TABLE Korisnik(
    k_ime INT PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    tip VARCHAR(50),
    pretplata VARCHAR(50),
    datum_reg DATE,
    tel_broj VARCHAR(12),
    email VARCHAR(20),
    CONSTRAINT korisnik_check CHECK(datum_reg >= '2023-01-01' AND datum_reg <= '2023-12-31')
);

CREATE TABLE Premium_Korisnik(
    k_ime INT PRIMARY KEY,
    datum DATE,
    procent_popust DECIMAL DEFAULT 20,
    CONSTRAINT prem_korisnik_fk FOREIGN KEY (k_ime) REFERENCES Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Profil (
    k_ime INT,
    ime VARCHAR(50) ,
    datum DATE,
    CONSTRAINT profil_pk PRIMARY KEY (k_ime, ime),
    CONSTRAINT profil_fk FOREIGN KEY (k_ime) REFERENCES Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Video_Zapis(
    naslov VARCHAR(50) PRIMARY KEY,
    jazik VARCHAR(40) DEFAULT 'English',
    vremetraenje INT,
    datum_d DATE,
    datum_p DATE,
    CONSTRAINT video_zapis_check CHECK(datum_d >= datum_p)
);

CREATE TABLE Video_Zapis_Zanr(

    zanr VARCHAR(50),
    naslov VARCHAR(50),
    CONSTRAINT video_zapis_zanrPK PRIMARY KEY (zanr, naslov),
    CONSTRAINT video_zapis_zanrFK FOREIGN KEY (naslov) REFERENCES Video_Zapis(naslov) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lista_Zelbi(
    k_ime INT,
    ime VARCHAR(50),
    naslov VARCHAR(50),
    CONSTRAINT lista_zelbiPK PRIMARY KEY (naslov, k_ime, ime),
    CONSTRAINT lista_zelbiKorisnikFK FOREIGN KEY (k_ime, ime) REFERENCES Profil(k_ime, ime) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT lista_zelbiVideo_ZapisFK FOREIGN KEY (naslov) REFERENCES Video_Zapis(naslov) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Preporaka(
    ID INT PRIMARY KEY,
    k_ime_od INT,
    k_ime_na INT,
    naslov VARCHAR(50) DEFAULT 'ENGLISH',
    datum DATE,
    komentar VARCHAR(250) NOT NULL ,
    ocena INT,
    FOREIGN KEY (k_ime_od) REFERENCES Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (k_ime_na) REFERENCES Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (naslov) REFERENCES Video_Zapis(naslov) ON DELETE SET DEFAULT ON UPDATE CASCADE,
    CONSTRAINT preporaka_check CHECK(ocena >= 1 AND ocena <= 5),
    CONSTRAINT preporaka_check2 CHECK(datum > '2022-12-07')
);

