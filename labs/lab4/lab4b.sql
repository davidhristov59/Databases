--1zad

--1 nacin (so join) - podobar
SELECT DISTINCT ime, prezime
FROM Premium_Korisnik JOIN Korisnik ON Premium_Korisnik.k_ime = Korisnik.k_ime
    JOIN Preporaka ON Preporaka.k_ime_od = Korisnik.k_ime
    JOIN Video_zapis ON Preporaka.naslov = Video_zapis.naslov
WHERE vremetraenje > 120 AND ocena = 4
ORDER BY datum_reg;


--2 nacin (moj)
SELECT DISTINCT ime, prezime
FROM Premium_Korisnik pk, Korisnik k, Video_zapis vz, Preporaka p
WHERE k.k_ime = pk.k_ime AND
      p.k_ime_od = k.k_ime AND
      vz.naslov = p.naslov AND
      vremetraenje > 120 AND
      ocena = 4
ORDER BY datum_reg;


--2zad

--1 nacin
SELECT p.k_ime_od, COUNT(p.naslov) AS broj_preporaki
FROM Korisnik k JOIN Preporaka p ON k.k_ime=p.k_ime_od
    JOIN Video_zapis vz ON vz.naslov = p.naslov
GROUP BY p.k_ime_od
HAVING COUNT(vz.naslov) = (
    SELECT max(broj_preporaki) --dal najgolem broj na preporaki
    FROM (
             SELECT COUNT(p2.naslov) AS broj_preporaki
             FROM Preporaka p2
             GROUP BY p2.k_ime_od
         )
    );

--2 nacin
SELECT p.k_ime_od, COUNT(p.naslov) AS broj_preporaki
FROM Preporaka p
GROUP BY p.k_ime_od
ORDER BY COUNT(p.naslov) DESC --gi dava userite so max reccomendations
LIMIT 1;--Limits the result to the top user with the most recommendations. - go dava userot so najmnogu reccomendations


--3zad
SELECT p.ime, AVG(p.ocena) AS avg_ocena
FROM Profil p JOIN Lista_zelbi lz ON p.ime = lz.ime
     JOIN Preporaka p ON p.naslov = lz.naslov
GROUP BY p.ime ;


--4zad
SELECT vzz.zanr, COUNT(p.naslov) AS broj_preporaki
FROM Video_zapis_zanr vzz JOIN Preporaka p ON vzz.naslov = p.naslov
WHERE komentar LIKE '%interesting%'
GROUP BY vzz.zanr
ORDER BY broj_preporaki DESC;


--5zad
SELECT vz.naslov, vz.vremetraenje, COUNT(p.naslov) AS broj_preporaki
FROM Preporaka p JOIN Video_zapis vz ON p.naslov = vz.naslov
    JOIN Lista_zelbi lz ON vz.naslov = lz.naslov
GROUP BY vz.naslov, vz.vremetraenje
HAVING COUNT(DISTINCT lz.ime) >=  2;


--6zad

--1 opcija
SELECT DISTINCT ime
FROM Korisnik k JOIN Preporaka p ON k.k_ime = p.k_ime_od
WHERE NOT EXISTS(
    SELECT 1
    FROM Lista_zelbi lz, Profil pr
    WHERE lz.ime = pr.ime AND lz.naslov = pr.k_ime
);

--2 opcija
SELECT DISTINCT ime
FROM Korisnik k JOIN Preporaka p ON k.k_ime = p.k_ime_od
WHERE NOT EXISTS(
    SELECT 1
    FROM Lista_zelbi lz
    WHERE lz.naslov = p.naslov AND lz.ime = p.k_ime_od --probaj i bez lz.ime = p.k_ime_od
);