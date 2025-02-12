CREATE TABLE Korisnik(
    k_ime INT PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    tip VARCHAR(50),
    pretplata VARCHAR(50),
    datum_reg DATE,
    tel_broj VARCHAR(50),
    email VARCHAR(20)
);

CREATE TABLE Premium_Korisnik(
    k_ime INT PRIMARY KEY,
    datum DATE,
    procent_popust DECIMAL DEFAULT 0.20,
    CONSTRAINT prem_kor_fk FOREIGN KEY (k_ime) REFERENCES Korisnik(k_ime)
);

CREATE TABLE Profil(
    k_ime INT,
    ime INT,
    datum DATE,
    CONSTRAINT profil_pk PRIMARY KEY (k_ime, ime),
    CONSTRAINT profil_fk FOREIGN KEY (k_ime) REFERENCES Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE VIDEO_ZAPIS(
    naslov VARCHAR(50) PRIMARY KEY ,
    jazik VARCHAR(50),
    vremetraenje INT,
    datum_d DATE,
    datum_p DATE
);

CREATE TABLE Video_Zapis_zanr(

    naslov VARCHAR(50) REFERENCES VIDEO_ZAPIS(naslov) ON DELETE CASCADE ON UPDATE CASCADE,
    zanr VARCHAR(50),
    CONSTRAINT video_zapis_zanr_pk PRIMARY KEY (naslov, zanr)

);

CREATE TABLE Lista_zelbi(

    naslov VARCHAR(50) REFERENCES VIDEO_ZAPIS(naslov) ON DELETE CASCADE ON UPDATE CASCADE,
    k_ime INT,
    ime INT,
    CONSTRAINT lista_zelbi_pk PRIMARY KEY (naslov, k_ime, ime),
    CONSTRAINT lista_zelbi_fk FOREIGN KEY (k_ime, ime) REFERENCES Profil(k_ime, ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Preporaka(
    ID INT PRIMARY KEY ,
    k_ime_od INT,
    k_ime_na INT,
    naslov VARCHAR(50),
    datum DATE,
    komentar VARCHAR(50),
    ocena INT,
    CONSTRAINT preporaka_fk FOREIGN KEY(k_ime_od, k_ime_na, naslov) REFERENCES Lista_zelbi(k_ime, ime, naslov) ON DELETE CASCADE ON UPDATE CASCADE
);
