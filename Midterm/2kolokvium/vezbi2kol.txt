Релационата база е дефинирана преку следните релации: 

Muzej(shifra, ime_muzej, opis, grad, tip, rabotno_vreme)
Izlozba(ime_i, opis, sprat, prostorija, datum_od, datum_do, shifra_muzej*)
Izlozba_TD(ime_i*) 
Izlozba_TD_ime(ime_i*, ime_td)
Izlozba_UD(ime_i*)
Umetnicko_delo(shifra, ime, godina, umetnik)
Izlozeni(shifra_d*, ime_i*, datum_pocetok, datum_kraj)


1. 
CREATE TABLE Muzej(
    shifra text PRIMARY KEY , 
    ime_muzej varchar(50), 
    opis varchar(200), 
    grad varchar(20), 
    tip varchar(20), 
    rabotno_vreme INT, 
    CONSTRAINT check_tip check (tip in ('otvoreno', 'zatvoreno')),
    constraint check_sifra check (shifra like 'o%' or tip='zatvoreno')
);

CREATE TABLE Umetnicko_delo(
    shifra text PRIMARY KEY, 
    ime varchar(30), 
    godina INT , 
    umetnik varchar(30)
);

CREATE TABLE Izlozeni(
    shifra_d text , 
    ime_i VARCHAR(30), 
    datum_pocetok DATE, 
    datum_kraj DATE,
    PRIMARY KEY(shifra_d, ime_i),
    FOREIGN KEY(shifra_d) references Umetnicko_delo(shifra) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(ime_i) references Izlozba_UD(ime_i) ON DELETE CASCADE ON UPDATE CASCADE
                        --PRAVAM IZLOZBA NA UMETNICKO DELO !!! , ne references izlozba, 
);


2. 
SELECT ud.ime, ud.umetnik
FROM Umetnicko_delo ud JOIN Izlozeni i ON ud.shifra = i.shifra_d 
                        JOIN Izlozba iz ON i.ime_i = iz.ime_i
WHERE iz.datum_od = i.datum_pocetok AND iz.datum_do = i.datum_kraj
ORDER BY ud.ime

3. 
--1nacin

SELECT  ud.umetnik
FROM Umetnicko_delo ud
EXCEPT 
SELECT DISTINCT ud.umetnik
FROM Umetnicko_delo ud JOIN Izlozeni i ON ud.shifra = i.shifra_d 
                       JOIN Izlozba iz ON iz.ime_i = i.ime_i 
                       JOIN Muzej m ON m.shifra = iz.shifra_muzej
WHERE tip = 'zatvoreno'
ORDER BY ud.umetnik


--2 nacin 
--SELECT ud.umetnik
--FROM Umetnicko_delo ud
--WHERE umetnik not in (
  --  SELECT ud.umetnik
    
 --   FROM Umetnicko_delo ud 
 --   JOIN Izlozeni i ON ud.shifra = i.shifra_d 
  --  JOIN Izlozba iz ON iz.ime_i = i.ime_i 
  --  JOIN Muzej m ON m.shifra = iz.shifra_muzej
    
  --  WHERE tip = 'zatvoreno'
--)
--ORDER BY ud.umetnik

4.
WITH broj_muzei AS (

    SELECT m.ime_muzej, COUNT(DISTINCT ud.shifra) AS broj_umetnicki_dela
    FROM Umetnicko_delo ud JOIN Izlozeni i ON ud.shifra = i.shifra_d
                           JOIN Izlozba iz ON i.ime_i = iz.ime_i
                           JOIN Muzej m ON m.shifra = iz.shifra_muzej
    WHERE datum_pocetok LIKE '2023%'
), max_dela AS (
    SELECT MAX(broj_umetnicki_dela) as max_broj_dela
    FROM broj_muzei
)

SELECT ime_muzej
FROM max_dela md JOIN broj_muzei bm ON bm.broj_umetnicki_dela = md.max_broj_dela


--2 nacin  - bez umetnicko_delo vo FROM 

-- with broj_muzei AS (

--     SELECT m.ime_muzej, COUNT(DISTINCT iz.shifra_d) as broj_umetnicki_dela
--     FROM Muzej m 
--     JOIN Izlozba i ON m.shifra = i.shifra_muzej 
--     JOIN Izlozeni iz ON iz.ime_i = i.ime_i 
--     WHERE iz.datum_pocetok LIKE '2023%'

-- ), max_dela AS (
        
--         SELECT MAX(broj_umetnicki_dela) as max_izlozeni_dela
--         FROM broj_muzei
--     )
    
-- SELECT ime_muzej
-- FROM max_dela md JOIN broj_muzei broj ON md.max_izlozeni_dela = broj.broj_umetnicki_dela


5.

CREATE TRIGGER otvoreno
AFTER INSERT ON Izlozeni
FOR EACH ROW
BEGIN
    UPDATE Umetnicko_delo 
    SET br_izlozbi_otvoreno = br_izlozbi_otvoreno + 1 
    WHERE shifra = NEW.shifra_d AND NEW.ime_i IN ( --izlozeni
        SELECT ime_i
        FROM Izlozba iz JOIN Muzej m ON iz.shifra_muzej = m.shifra
        WHERE m.tip = 'otvoreno'
    ); 
END;

CREATE TRIGGER zatvoreno
AFTER INSERT ON Izlozeni
FOR EACH ROW 
BEGIN
    
    UPDATE Umetnicko_delo
    SET br_izlozbi_zatvoreno = br_izlozbi_zatvoreno + 1
    WHERE shifra = NEW.shifra_d AND NEW.ime_i IN ( --izlozeni
        SELECT ime_i
        FROM Izlozba iz JOIN Muzej m ON iz.shifra_muzej = m.shifra
        WHERE m.tip = 'zatvoreno'
    ); 
END;
