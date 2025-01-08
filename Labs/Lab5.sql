Релационата база е дефинирана преку следните релации: 

Pateka(ime, grad, drzava, dolzina, tip)
Trka(ime, krugovi, pateka*)
Odrzana_trka(ime*, datum, vreme)
Vozac(vozacki_broj, ime, prezime, nacionalnost, datum_r)
Tim(ime, direktor)
Sponzori(ime*, sponzor)
Vozi_za(vozacki_broj*, ime_tim*, datum_pocetok, datum_kraj)
Ucestvuva(ID, vozacki_broj*, ime_tim*, ime_trka*, datum_trka*, pocetna_p, krajna_p, poeni)

1.DDL 
Сакаме да водиме евиденција за учествата на трки од возачи кои се избришани од системот, но не сакаме да водиме евиденција за учествата на трки од тимови кои се избришани од системот.
Само возачите кои ја завршиле трката на првите 10 позиции добиваат поени (останатите добиваат 0 поени). 
Трката не смее да има повеќе од 80 кругови.

CREATE TABLE Trka (
    
    ime TEXT PRIMARY KEY, 
    krugovi TEXT, 
    pateka TEXT,
    FOREIGN KEY(pateka) REFERENCES Pateka(ime) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT CH_trka CHECK (krugovi <= 80)
);

CREATE TABLE Odrzana_trka(
    ime TEXT , 
    datum TEXT, 
    vreme INT,
    PRIMARY KEY(ime, datum),
    FOREIGN KEY(ime) REFERENCES Trka(ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ucestvuva(
    ID TEXT PRIMARY KEY, 
    vozacki_broj TEXT, 
    ime_tim TEXT, 
    ime_trka TEXT, 
    datum_trka DATE, 
    pocetna_p TEXT, 
    krajna_p TEXT, 
    poeni DOUBLE,
    CONSTRAINT vozac_fk FOREIGN KEY(vozacki_broj) REFERENCES Vozac(vozacki_broj) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT tim_fk FOREIGN KEY(ime_tim) REFERENCES Tim(ime) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT trka_datum_fk FOREIGN KEY(ime_trka,datum_trka) REFERENCES Odrzana_trka(ime,datum) ON DELETE CASCADE ON UPDATE CASCADE,
    --Odrzana_trka obavezno ne Trka, ako pagaat test primeri a ne znaes sto se ova e 90% so gresen entitet referenciram
    CONSTRAINT ch_pozicija CHECK (krajna_p in (1,2,3,4,5,6,7,8,9,10))
);

2. DML 
Да се напише DML израз со кој ќе се вратат информациите за возачите кои во 2023 година освоиле (еден или повеќе) поени на одржани трки со помалку од 70 кругови подредени според датумот на раѓање по опаѓачки редослед.
 
SELECT DISTINCT v.vozacki_broj, v.ime, v.prezime, v.nacionalnost, v.datum_r
FROM Vozac v JOIN Ucestvuva u ON v.vozacki_broj = u.vozacki_broj
             --JOIN Vozi_za vz ON vz.vozacki_broj = u.vozacki_broj
             JOIN Trka t ON u.ime_trka = t.ime
WHERE u.datum_trka LIKE '2023%' AND u.poeni >= 1 AND t.krugovi < 70
ORDER BY datum_r DESC;

3. Да се напише DML израз со кој за секоја трка ќе се врати возачот кој има најмногу победи на таа трка.
WITH broj_trki AS (

    select ime, vozacki_broj, COUNT(*) count_trki
    from  Ucestvuva u JOIN Odrzana_trka ot ON ot.ime = u.ime_trka
    where krajna_p = 1
    group by ime, vozacki_broj --obavezno group by
), 
max_pobedi AS (

    SELECT ime, MAX(count_trki) max_br_trki
    FROM broj_trki 
    group by ime --obavezno group by
)

SELECT bt.ime race, bt.vozacki_broj driver
FROM broj_trki bt JOIN max_pobedi mp ON bt.count_trki = mp.max_br_trki  
                  AND bt.ime=mp.ime 


4. 
Да се напише/ат соодветниот/те тригер/и за одржување на референцијалниот интегритет на релацијата „УЧЕСТВУВА“ доколку треба да се исполнети следните барања:

Сакаме да водиме евиденција за учествата на трки од возачи кои се избришани од системот.
Не сакаме да водиме евиденција за учествата на трки од тимови кои се избришани од системот.

CREATE TRIGGER T
AFTER DELETE ON Vozac
FOR EACH ROW
BEGIN
    UPDATE Ucestvuva
    SET vozacki_broj = NULL
    WHERE vozacki_broj = OLD.vozacki_broj;
END;

CREATE TRIGGER T2
AFTER DELETE ON Tim
FOR EACH ROW
BEGIN
    DELETE FROM Ucestvuva
    WHERE OLD.ime = ime_tim;
END;
