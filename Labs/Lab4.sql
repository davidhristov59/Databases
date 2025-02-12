1.	Да се вратат имињата и презимињата на сите премиум корисници кои препорачале видео запис со времетраење подолго од 2 часа и за кој оставиле оцена поголема или еднаква на 4, подредени според датумот на регистрација во растечки редослед (времетраењето се чува во минути)

SELECT DISTINCT ime, prezime
FROM Premium_Korisnik JOIN Korisnik ON Premium_Korisnik.k_ime = Korisnik.k_ime
    JOIN Preporaka ON Preporaka.k_ime_od = Korisnik.k_ime 
    JOIN Video_zapis ON Preporaka.naslov = Video_zapis.naslov
WHERE vremetraenje > 120 AND ocena >= 4
ORDER BY datum_reg;

2.	Да се вратат корисничкото име и бројот на видео записи кои му биле препорачани на корисникот кој дал најголем број на препораки.
SELECT k.k_ime, COUNT(p.naslov) AS dobieni_preporaki
FROM Preporaka p JOIN Korisnik k ON k.k_ime = p.k_ime_na
GROUP BY k.k_ime
ORDER BY COUNT(p.naslov) DESC 
LIMIT 1;

3.	За секој профил да се врати името на профилот и просечната оцена на видео записите во листата на желби асоцирана со тој профил. (Просечната оцена на секој видео запис се пресметува од сите оцени за тој видео запис).

SELECT p.ime, AVG(ao) as po_profil
FROM Profil p JOIN Lista_zelbi lz ON p.ime = lz.ime
    JOIN (
        SELECT pr.naslov, AVG(pr.ocena) as ao
        FROM Preporaka pr
        GROUP BY pr.naslov) A 
    ON A.naslov = lz.naslov
GROUP BY p.ime;


4.	Да се вратат жанровите заедно со бројот на препораки со коментар што го содржи зборот „interesting“, подредени според бројот на препораки во опаѓачки ред.


SELECT vzz.zanr, COUNT(p.naslov) AS broj_zanrovi
FROM Video_zapis_zanr vzz JOIN Preporaka p ON vzz.naslov = p.naslov
WHERE komentar LIKE '%interesting%'
GROUP BY vzz.zanr
ORDER BY broj_zanrovi DESC;




5.	Да се врати список со насловите на видеата, времетраењето и бројот на препораки, за видеа кои се во листата на желби на најмалку два различни профили.

WITH najmalku_dva AS (
    SELECT lz.naslov
    FROM Lista_zelbi lz
    GROUP BY lz.naslov
    HAVING COUNT(lz.k_ime) >= 2
)

SELECT vz.naslov, vz.vremetraenje, COUNT(p.naslov) as broj_preporaki
FROM najmalku_dva nd 
    JOIN Video_zapis vz ON vz.naslov = nd.naslov
    LEFT JOIN Preporaka p ON p.naslov = vz.naslov --so LEFT JOIN kazuvam deka site videa od Video_zapis tabelata staveni vo rezultatot i da nemaat preporaki
GROUP BY vz.naslov, vz.vremetraenje
ORDER BY vz.naslov;

6.	Да се вратат имињата на сите корисници кои имаат дадено препораки за видеа кои никој од нивните профили не ги има во листата на желби.

SELECT DISTINCT p.k_ime_od
FROM Korisnik k JOIN Preporaka p ON k.k_ime = p.k_ime_od
WHERE NOT EXISTS(
    SELECT 1
    FROM Lista_zelbi lz, Profil pr
    WHERE lz.ime = pr.ime AND lz.naslov = pr.k_ime
);


















7.	За секој од премиум корисниците со најголем процент на попуст да се врати профилот со најмал број видео записи во листата на желби.


WITH MaxDiscount AS ( --go baram maksimalniot procent na popust na premiumm  korisnikot
    SELECT MAX(procent_popust) AS max_discount
    FROM Premium_korisnik
),


PremiumUsers AS (
    SELECT pk.k_ime, pk.datum, pk.procent_popust
    FROM Premium_korisnik pk
    WHERE pk.procent_popust = (SELECT max_discount FROM MaxDiscount)
),


WishListCounts AS ( 
    SELECT p.k_ime, p.ime, COUNT(lz.naslov) AS br_filmovi
    FROM Profil p
    LEFT JOIN Lista_zelbi lz ON p.k_ime = lz.k_ime AND p.ime = lz.ime --pravam left join za da gi zemam profilite koi nemaat zapis vo listata na zelbi
    GROUP BY p.k_ime, p.ime
),


MinFilmCount AS (
    SELECT wlc.k_ime, MIN(wlc.br_filmovi) AS min_filmovi --najmaliot broj na zapisi 
    FROM WishListCounts wlc
    JOIN PremiumUsers pu ON wlc.k_ime = pu.k_ime
    GROUP BY wlc.k_ime
)

SELECT wlc.k_ime, wlc.ime, wlc.br_filmovi
FROM WishListCounts wlc
JOIN MinFilmCount mfc ON wlc.k_ime = mfc.k_ime AND wlc.br_filmovi = mfc.min_filmovi;


8.	За видео записите кои покриваат само еден жанр, да се излиста просечната оценка од препораки дадени од премиум кон обични корисници.

WITH Eden_Zanr AS ( 
    SELECT vz.naslov
    FROM Video_zapis_zanr vz
    GROUP BY vz.naslov
    HAVING COUNT(vz.zanr) = 1 --gi zimam zapisite koi pokrivaat eden zanr
),


Premium_Korisnici AS ( 
    SELECT k_ime
    FROM Premium_korisnik
),


Preporaki_Od_Premium_Ko_Obicni AS (
    SELECT p.naslov, p.ocena
    FROM Preporaka p
    LEFT JOIN Premium_Korisnici pk ON p.k_ime_od = pk.k_ime --pravam left join za da gi korisnicite koi nemaat dadeno preporaka
    WHERE pk.k_ime IS NOT NULL
      AND p.k_ime_na NOT IN (SELECT k_ime FROM Premium_Korisnici)
),


Filtrirani_Preporaki AS ( --filtrirame preporakite koi se sovpagaat so zanrot 
    SELECT ptr.naslov, ptr.ocena
    FROM Preporaki_Od_Premium_Ko_Obicni ptr JOIN Eden_Zanr ez ON ptr.naslov = ez.naslov
),


Prosek_Oceni AS (
    SELECT fp.naslov, AVG(fp.ocena) AS prosek
    FROM Filtrirani_Preporaki fp
    GROUP BY fp.naslov
)

SELECT naslov, prosek
FROM Prosek_Oceni;


