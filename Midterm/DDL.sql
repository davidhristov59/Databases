Релационата база е дефинирана преку следните релации:

Vraboten(ID, ime, prezime, datum_r, datum_v, obrazovanie, plata)
Shalterski_rabotnik(ID*)
Klient(MBR_k, ime, prezime, adresa, datum)
Smetka(MBR_k*, broj, valuta, saldo)
Transakcija_shalter(ID, ID_v*, MBR_k*, MBR_k_s*, broj*, datum, suma, tip)
Bankomat(ID, lokacija, datum, zaliha)
Transakcija_bankomat(ID, MBR_k_s*, broj*, ID_b*, datum, suma).

1.
Да се напишат соодветните DDL изрази за ентитетните множества „ТРАНСАКЦИЈА_ШАЛТЕР“, „ВРАБОТЕН“ и „ШАЛТЕРСКИ_РАБОТНИК“, како и за евентуалните релации кои произлегуваат од истите, доколку треба да бидат исполнети следните барања:
Доколку се избрише одреден вработен, информациите за извршените трансакции треба да останат зачувани во базата на податоци.
Датумот на извршување на трансакција не смее да биде во периодот од 30.12.2020 до 14.01.2021.
Типот на трансакцијата може да има една од двете вредности "uplata" или "isplata"
Датумот на раѓање на вработениот мора да биде пред неговиот датум на вработување

CREATE TABLE Vraboten (
    ID INT PRIMARY KEY, 
    ime VARCHAR(50), 
    prezime VARCHAR(50), 
    datum_r date, 
    datum_v date, 
    obrazovanie VARCHAR(50), 
    plata int,
    CONSTRAINT check_date CHECK  (datum_r <= datum_v)
);

CREATE TABLE Shalterski_rabotnik(

    ID INT PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Vraboten (ID) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Transakcija_shalter(

    ID INT PRIMARY KEY, 
    ID_v INT, 
    MBR_k INT, 
    MBR_k_s INT, 
    broj INT, 
    datum DATE, 
    suma INT, 
    tip INT ,
    CONSTRAINT vraboten_fk FOREIGN KEY (ID_v) REFERENCES Shalterski_rabotnik (ID) ON DELETE SET NULL on update cascade,
    CONSTRAINT klient_fk FOREIGN KEY (MBR_k) REFERENCES Klient (MBR_k) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT transakcija_shalter_fk FOREIGN KEY (MBR_k_s, broj) REFERENCES Smetka (MBR_k_s, broj) ON DELETE cascade ON UPDATE CASCADE,
    CONSTRAINT check_tip CHECK(tip in ('uplata', 'isplata')),
    CONSTRAINT check_date CHECK (NOT(datum >= '2020-12-30' AND datum <= '2021-01-14'))
);


2. 
Lice(id, mbr, ime, prezime, data_r, vozrast, pol)
Med_lice(id*, staz)
Test(id*, shifra, tip, datum, rezultat, laboratorija)
Vakcina(shifra, ime, proizvoditel)
Vakcinacija(id_lice*, id_med_lice*, shifra_vakcina*)
Vakcinacija_datum(id_lice*, id_med_lice*, shifra_vakcina*, datum)

Да се напишат соодветните DDL изрази за ентитетните множества „ВАКЦИНАЦИЈА“ и „ТЕСТ“, како и за евентуалните релации кои произлегуваат од истите, доколку треба да бидат исполнети следните барања:
Mедицинските лица не може себеси да си даваат вакцина.
Лабораторијата „lab-abc“ прави само „seroloshki“ тестови.
Не сакаме да водиме информации за тестовите на лицата кои се избришани од базата на податоци.

CREATE TABLE Vakcinacija(

    id_lice INT, 
    id_med_lice INT , 
    shifra_vakcina INT,
    PRIMARY KEY(id_lice, id_med_lice, shifra_vakcina),
    CONSTRAINT lice_fk FOREIGN KEY (id_lice) REFERENCES Lice(id) ON DELETE SET DEFAULT ON UPDATE CASCADE,
    CONSTRAINT med_lice_fk FOREIGN KEY (id_med_lice) REFERENCES Med_lice(id) ON DELETE SET DEFAULT ON UPDATE CASCADE,
    CONSTRAINT shifra_vakcina_fk FOREIGN KEY (shifra_vakcina) REFERENCES Vakcina(shifra) ON DELETE SET DEFAULT ON UPDATE CASCADE,
    CONSTRAINT check_med CHECK (id_med_lice <> id_lice) --<> oznacuva not equal to
);

CREATE TABLE Test(
    id INT , 
    shifra INT, 
    tip TEXT, 
    datum DATE, 
    rezultat TEXT, 
    laboratorija TEXT,
    PRIMARY KEY (id, shifra),
    FOREIGN KEY(id) REFERENCES Lice(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CH_lab CHECK (laboratorija<>'lab-abc' OR tip = 'seroloshki') 
);

CREATE TABLE Vakcinacija_datum(

    id_lice INT, 
    id_med_lice INT, 
    shifra_vakcina INT, 
    datum DATE,
    PRIMARY KEY(id_lice, id_med_lice, shifra_vakcina, datum),
    CONSTRAINT vakcinacija_fk FOREIGN KEY(id_lice,id_med_lice, shifra_vakcina) REFERENCES Vakcinacija(id_lice, id_med_lice, shifra_vakcina) ON DELETE SET NULL ON UPDATE CASCADE
);

3. 
Muzicar(id, ime, prezime, datum_ragjanje)
Muzicar_instrument(id_muzicar*, instrument)
Bend(id, ime, godina_osnovanje)
Bend_zanr(id_bend*, zanr)
Nastan(id, cena, kapacitet)
Koncert(id*, datum, vreme)
Festival(id*, ime)
Festival_odrzuvanje(id*, datum_od, datum_do)
Muzicar_bend(id_muzicar*, id_bend*, datum_napustanje)
Festival_bend(id_festival*, datum_od*, id_bend*)
Koncert_muzicar_bend(id_koncert*, id_muzicar*, id_bend*)
  
Да се напишат соодветните DDL изрази за ентитетните множества „БЕНД“ и „ФЕСТИВАЛ_БЕНД“, како и за евентуалните релации кои произлегуваат од истите, доколку треба да бидат исполнети следните барања:
Бендот со шифра (id или id_bend) 5 не може да настапува на фестивалот со шифра (id_festival) 2.

Сакаме да водиме евиденција за настапите на фестивали за бендови што се бришат од системот.
Се чуваат податоци само за бендови кои се основани во 1970 или подоцна.

CREATE TABLE Bend(
    id TEXT PRIMARY KEY, 
    ime TEXT, 
    godina_osnovanje INT,
    CONSTRAINT check_godina CHECK (godina_osnovanje>=1970)
);

CREATE TABLE BEND_ZANR(
    
    id_bend INT , 
    zanr VARCHAR(50),
    PRIMARY KEY(id_bend, zanr),
    FOREIGN KEY(id_bend) REFERENCES Bend(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Festival_bend(

    id_festival INT, 
    datum_od DATE,
    id_bend INT, 
    primary key(id_festival, datum_od, id_bend),
    --moram vo 1 linija so foreign key za festival_odrzuvanje, inaku nema da saka vo posebni linii
    --CONSTRAINT datum_od_fk FOREIGN KEY(datum_od) REFERENCES Festival_odrzuvanje(datum_od) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT bend_fk FOREIGN KEY(id_bend) REFERENCES Bend(id) ON DELETE CASCADE ON DELETE SET DEFAULT ON UPDATE CASCADE,
    CONSTRAINT bend_fk FOREIGN KEY(id_festival, datum_od) REFERENCES Festival_odrzuvanje(id, datum_od) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT bend_sifri CHECK (id_bend <> '5' or id_festival<> '2')
    --CONSTRAINT bend_sifri CHECK (not(id_bend = '5' and id_festival = '2'))
);

4. 
	
Релационата база е дефинирана преку следните релации: 
  
Korisnik(kor_ime, ime, prezime, pol, data_rag, data_reg)
Korisnik_email(kor_ime*, email)
Mesto(id, ime)
Poseta(id, kor_ime*, id_mesto*, datum)
Grad(id_mesto*, drzava)
Objekt(id_mesto*, adresa, geo_shirina, geo_dolzina, id_grad*)
Sosedi(grad1*, grad2*, rastojanie)

Да се напишат соодветните DDL изрази за ентитетните множества „КОРИСНИК“ и „ПОСЕТА“, како и за евентуалните релации кои произлегуваат од истите, доколку треба да бидат исполнети следните барања:
Сакаме да водиме евиденција за посетите на местата од корисниците кои се избришани од системот.
Е-маил адресата завршува на „.com“ и истата треба да содржи најмалку 10 карактери.
Датумот на посета на место не смее да биде пo датумот на внесување на записот во базата.

CREATE TABLE Korisnik(
    
    kor_ime VARCHAR(30) PRIMARY KEY, 
    ime VARCHAR(30), 
    prezime VARCHAR(30), 
    pol VARCHAR(30), 
    data_rag date, 
    data_reg date
);

CREATE TABLE Korisnik_email(

    kor_ime VARCHAR(30), 
    email VARCHAR(30),
    primary key(kor_ime, email),
    foreign key(kor_ime) references Korisnik(kor_ime) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CH_email CHECK (email LIKE '%.com' AND LENGTH(email) >= 10) 
);

CREATE TABLE Poseta(
    
    id INT primary key, 
    kor_ime VARCHAR(30), 
    id_mesto INT, 
    datum DATE,
    CONSTRAINT korisnik_fk foreign key(id_mesto) references Mesto(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT mesto_fk foreign key(kor_ime) references Korisnik(kor_ime) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT CH_datum CHECK (datum <= '2024-01-06') --do denes 
);

5. 
Korisnik(k_ime, ime, prezime, tip, pretplata, datum_reg, tel_broj, email)
Premium_korisnik(k_ime*, datum, procent_popust)
Profil(k_ime*, ime, datum)
Video_zapis(naslov, jazik, vremetraenje, datum_d, datum_p)
Video_zapis_zanr(naslov*, zanr)
Lista_zelbi(naslov*, k_ime*, ime*)
Preporaka(ID, k_ime_od*, k_ime_na*, naslov*, datum, komentar, ocena)

Да се напишат соодветните DDL изрази за ентитетните множества „ВИДЕО ЗАПИС“ и „ПРЕПОРАКА“, како и за евентуалните релации кои произлегуваат од истите, доколку треба да бидат исполнети следните барања:
Сакаме да водиме евиденција за препорачаните видео записи од корисници кои се избришани од системот.
Корисникот не може себе да си препорача видео запис.
Датумот на препорака не може да биде во иднина (т.е. не смее да биде по тековниот датум).


CREATE TABLE Video_zapis(
    naslov VARCHAR(50) PRIMARY KEY, 
    jazik VARCHAR(50), 
    vremetraenje INT, 
    datum_d DATE, 
    datum_p DATE
);

CREATE TABLE Video_zapis_zanr(
    
    naslov varchar(40),  
    zanr varchar(40),
    primary key(naslov, zanr),
    constraint videoz_fk foreign key(naslov) references Video_zapis(naslov) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Preporaka(

    ID INT PRIMARY KEY, 
    k_ime_od VARCHAR(50), 
    k_ime_na VARCHAR(50), 
    naslov VARCHAR(50), 
    datum date, 
    komentar VARCHAR(50), 
    ocena  INT,
    constraint korisnik_fk foreign key(k_ime_od) references Korisnik(k_ime) ON DELETE SET NULL ON UPDATE CASCADE,
    constraint korisnik2_fk foreign key(k_ime_na) references Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint video_zapis_fk foreign key(naslov) references Video_zapis(naslov) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint datum_fk CHECK (not(datum >= '2024-01-06')),
    constraint rec_rel_fk CHECK (k_ime_od <> k_ime_na)
);

6. so istata rel baza 
  
Да се напишат соодветните DDL изрази за ентитетните множества „ЛИСТА_ЖЕЛБИ“, „КОРИСНИК“ и „ПРЕМИУМ_КОРИСНИК“, како и за евентуалните релации кои произлегуваат од истите, доколку треба да бидат исполнети следните барања:
Доколку не се внесе процентот на попуст за премиум корисник, тогаш сакаме да се додели предодредена вредност 10.
Сакаме да водиме евиденција во листите на желби за видео записите кои се избришани од системот.
Корисниците регистрирани пред 01.01.2015 не може да бидат претплатени на „pretplata 3“.

CREATE TABLE Korisnik(
    k_ime varchar(50) primary key,
    ime varchar(50), 
    prezime varchar(50), 
    tip varchar(50), 
    pretplata int, 
    datum_reg date, 
    tel_broj int, 
    email varchar(100),
    CONSTRAINT CH_date CHECK (datum_reg >= '2015-01-01' or  pretplata='3')
);

CREATE TABLE Premium_korisnik(
    k_ime varchar(50) primary key, 
    datum date, 
    procent_popust INT default 10,
    foreign key(k_ime) references Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lista_zelbi(
    ID int primary key, 
    naslov varchar(50), 
    k_ime varchar(50), 
    ime varchar(50),
    constraint vz_fk FOREIGN KEY(naslov) references Video_zapis(naslov) ON DELETE SET NULL ON UPDATE CASCADE,
    constraint p_fk FOREIGN KEY(k_ime, ime) references Profil(k_ime, ime) ON DELETE CASCADE ON UPDATE CASCADE
);

7. so istata rel baza od video_Zapis
Доколку јазикот на видео записот не е наведен, треба да се пополни со предефинирана вредност 'English'
Доколку процентот на попуст на премиум корисниците не е наведен, треба да се пополни со предефинирана вредност од 20 проценти
Полето за чување на телефонскиот број на корисникот потребно е да биде со максимална големина од 12 карактери
Коментар при препорака мора да биде внесен при што не смее да надмине големина од 250 карактери
Датумот на достапност на видео запис не може да биде пред датумот на премиера (може да бидат исти)
Оцената на препораката мора да биде од 1 до 5
Доколку некој видео запис се избрише од системот, препораките за тој запис треба да останат зачувани во базата на податоци со предефинирана вредност за наслов на записот 'Deleted'
При промена или бришење на корисникот, промената треба да се проследи и до табелата со премиум корисници.
Валидни препораки кои се внесуваат во базата мора да се по започнување на системот за стриминг на 7ми декември 2022 година
Регистрацијата на корисници во системот е дозволена од почеток на 2023 година до крајот на 2024 година

CREATE TABLE Korisnik(
    k_ime varchar(50) primary key,
    ime varchar(50), 
    prezime varchar(50), 
    tip varchar(50), 
    pretplata int, 
    datum_reg date, 
    tel_broj varchar(12), 
    email varchar(100),
    constraint reg_ch check (datum_reg >= '2023-01-01' and datum_reg <= '2024-12-12')
);

CREATE TABLE Premium_korisnik(
    k_ime varchar(50) primary key, 
    datum date, 
    procent_popust INT default 20,
    foreign key(k_ime) references Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lista_zelbi(
    naslov varchar(50), 
    k_ime varchar(50), 
    ime varchar(50),
    primary key(naslov, k_ime, ime),
    constraint vz_fk FOREIGN KEY(naslov) references Video_zapis(naslov) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint p_fk FOREIGN KEY(k_ime, ime) references Profil(k_ime, ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Video_zapis(
    naslov VARCHAR(50) PRIMARY KEY, 
    jazik VARCHAR(50) DEFAULT 'English', 
    vremetraenje INT, 
    datum_d DATE, 
    datum_p DATE,
    CONSTRAINT CH_datum check (datum_d >= datum_p)
);

CREATE TABLE Video_zapis_zanr(
    naslov varchar(40),  
    zanr varchar(40),
    primary key(naslov, zanr),
    foreign key(naslov) references Video_zapis(naslov) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Preporaka(
    ID INT PRIMARY KEY, 
    k_ime_od VARCHAR(50), 
    k_ime_na VARCHAR(50), 
    naslov VARCHAR(50) default 'Deleted', 
    datum date, 
    komentar VARCHAR(250) NOT NULL, 
    ocena  INT ,
    foreign key (k_ime_od) references Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key (k_ime_na) references Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
    foreign key (naslov) references Video_zapis(naslov) ON DELETE SET DEFAULT ON UPDATE CASCADE,
    constraint CH_ocena check (ocena in (1,2,3,4,5)),
    constraint ch_preporaka check (datum >= '2022-12-07')
);

CREATE TABLE Profil(
    k_ime varchar(30), 
    ime varchar(30), 
    datum date,
    primary key(k_ime, ime),
    foreign key(k_ime) references Korisnik(k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

8. 
Vraboten(ID, ime, prezime, datum_r, datum_v, obrazovanie, plata)
Shalterski_rabotnik(ID*)
Klient(MBR_k, ime, prezime, adresa, datum)
Smetka(MBR_k*, broj, valuta, saldo)
Transakcija_shalter(ID, ID_v*, MBR_k*, MBR_k_s*, broj*, datum, suma, tip)
Bankomat(ID, lokacija, datum, zaliha)
Transakcija_bankomat(ID, MBR_k_s*, broj*, ID_b*, datum, suma).

Да се напишат DDL изразите за сите ентитетни множества кои се дефинирани во релациониот модел. Дополнително, потребно е да бидат исполнети следните барања:

Доколку се избрише одреден вработен, информациите за извршените трансакции треба да останат зачувани во базата на податоци.
Информацијата за ID на банкомат која се чува во трансакциите спроведени на банкомат треба да има предефинирана вредност од -1.
Информацијата за образованието на вработениот мора да биде пополнето и да биде некоја од вредностите 'PhD', 'MSc', 'High School', 'BSc'
Датумот на извршување на трансакција на банкомат не смее да биде во периодот од 30.12.2020 до 14.01.2021.
Типот на трансакцијата може да има една од двете вредности 'uplata' или 'isplata'
Вредноста на залихата во банкоматите не смее да има вредност помала од 0.
Датумот на раѓање на вработениот мора да биде пред неговиот датум на вработување
Локациите на банкоматите мора да имаат различни (уникатни) вредности
Адресата на клинетите треба да има предефинирана вреднот 'Ne e navedena' 
Доколку се затвори одреден банкомат и истиот се избрише од базата, информациите за извршените трансакции за дадениот банкомат треба да останат зачувани во базата на податоци со предефинирана вредност.

CREATE TABLE Vraboten (
    ID INT PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    datum_r DATE,
    datum_v DATE,
    obrazovanie VARCHAR(50),
    plata INT,
    CONSTRAINT stepenObrazovanie CHECK (obrazovanie IN ('PhD','MSc','High School','BSc')),
    CONSTRAINT datumRaganje CHECK (datum_r < datum_v)
);

CREATE TABLE Klient (
    MBR_k INT PRIMARY KEY,
    ime VARCHAR(50),
    prezime VARCHAR(50),
    adresa VARCHAR(50) DEFAULT 'Ne e navedena',
    datum DATE
);

CREATE TABLE Shalterski_rabotnik(
    ID INT PRIMARY KEY,
    FOREIGN KEY (ID) REFERENCES Vraboten(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Bankomat (
    ID INT PRIMARY KEY,
    lokacija VARCHAR(50) UNIQUE,
    datum DATE,
    zaliha INT,
    CONSTRAINT zalihaBankomat CHECK (zaliha >= 0)
);

CREATE TABLE Smetka(
    MBR_k INT,
    broj INT,
    valuta INT,
    saldo INT,
    PRIMARY KEY (MBR_k, broj),
    FOREIGN KEY (MBR_k) REFERENCES Klient(MBR_k) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Transakcija_bankomat(
    ID INT PRIMARY KEY,
    MBR_k_s INT ,
    broj INT,
    ID_b INT DEFAULT -1,
    datum DATE,
    suma INT,
    CONSTRAINT TransBank_FK FOREIGN KEY (ID_b) REFERENCES Bankomat(ID) ON DELETE set default ON UPDATE CASCADE,
    CONSTRAINT datum_Izvrsuvanje1 CHECK (NOT (datum >= '2020-12-30' AND datum <= '2021-10-14')),
    FOREIGN KEY (MBR_k_s, broj) REFERENCES Smetka(MBR_k, broj) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Transakcija_shalter(
    ID INT PRIMARY KEY,
    ID_v INT,
    MBR_k INT,
    MBR_k_s INT,
    broj INT,
    datum DATE,
    suma INT,
    tip VARCHAR(50),
    FOREIGN KEY (ID_v) REFERENCES Shalterski_rabotnik(ID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (MBR_k) REFERENCES Klient(MBR_k) ON DELETE CASCADE ON UPDATE CASCADE
    FOREIGN KEY (MBR_k_s, broj) REFERENCES Smetka(MBR_k, broj) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT datum_Izvrsuvanje CHECK (NOT (datum >= '2020-12-30' AND datum <= '2021-10-14')),
    CONSTRAINT tip_Transakcija CHECK (tip IN ('uplata', 'isplata'))
);
