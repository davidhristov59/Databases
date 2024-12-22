
--1zad

--1 opcija (moe - bez join)
SELECT DISTINCT ime, prezime
FROM Vraboten, Transakcija_shalter, Smetka,Shalterski_rabotnik
WHERE Vraboten.ID = Shalterski_rabotnik.ID AND
      Transakcija_shalter.ID_v = Vraboten.ID AND
      Smetka.broj = Transakcija_shalter.broj AND
      suma > 1000 AND
      valuta = 'EUR' AND
      tip = 'isplata'
ORDER BY ime;


--2 opcija (so join)
SELECT DISTINCT ime , prezime
FROM Vraboten JOIN Shalterski_rabotnik ON Vraboten.ID = Shalterski_rabotnik.ID
    JOIN Transakcija_shalter ON Transakcija_shalter.ID_v = Vraboten.ID
    JOIN Smetka ON Smetka.broj = Transakcija_shalter.broj
WHERE suma > 1000 AND valuta='EUR' AND tip='isplata'
ORDER BY ime;

--2 zad

--1 nacin (moe)
SELECT DISTINCT Klient.ime, Klient.prezime
FROM Klient, Transakcija_bankomat, Smetka
WHERE Klient.MBR_k = Transakcija_bankomat.MBR_k_s AND
              Transakcija_bankomat.MBR_k_s = Smetka.MBR_k AND
               Transakcija_bankomat.suma > 400 AND
               valuta = 'USD'
ORDER BY ime;

--2nacin (so join)
SELECT DISTINCT Klient.ime, Klient.prezime
FROM Klient JOIN Transakcija_bankomat ON Klient.MBR_k = Transakcija_bankomat.MBR_k_s
    JOIN Smetka ON Smetka.MBR_k = Transakcija_bankomat.MBR_k_s
WHERE Transakcija_bankomat.suma > 400 AND valuta = 'USD'
ORDER BY ime;


--3 zad
SELECT Smetka.MBR_k, Smetka.broj, Smetka.saldo
FROM Smetka JOIN Transakcija_bankomat ON Smetka.broj = Transakcija_bankomat.broj
    JOIN Transakcija_shalter ON Smetka.broj = Transakcija_shalter.broj
WHERE Smetka.valuta = 'MKD' AND tip='isplata' AND
      Transakcija_shalter.datum LIKE '2021%' AND
      Transakcija_bankomat.datum LIKE '2021%'
ORDER BY Smetka.broj;


--4 zad
SELECT DISTINCT Klient.MBR_k, ime, prezime, adresa, Klient.datum
FROM Klient JOIN Transakcija_bankomat ON Klient.MBR_k = Transakcija_bankomat.MBR_k_s
            JOIN Smetka ON Smetka.broj = Transakcija_bankomat.broj
WHERE valuta = 'EUR'
    AND NOT EXISTS(
        SELECT 1
        FROM Transakcija_shalter
        WHERE Transakcija_shalter.broj = Smetka.broj --AND tip='isplata'
)
ORDER BY Klient.ime;


--5zad BITNA!!
SELECT ts.ID_v, ts.datum, COUNT(*) AS TransactionCount
FROM Transakcija_shalter ts
GROUP BY ts.ID, ts.datum
HAVING COUNT(*)  = (
    SELECT max(TransactionCount)
    FROM Transakcija_shalter ts2
    WHERE ts.ID_v = ts2.ID_v
    --GROUP BY ts.datum
    )
ORDER BY ID_v;


--6zad BITNA !!!!!
SELECT s.broj,  AVG(ts.suma) as AvgTransakcijaShalter, AVG(tb.suma) as AvgTransakcijaBankomat
FROM Smetka s LEFT JOIN Transakcija_shalter ts ON s.broj = ts.broj AND ts.datum LIKE '2021%' AND ts.tip = 'isplata'
    LEFT JOIN Transakcija_bankomat tb ON s.broj = tb.broj LIKE '2021%' AND tip ='isplata'
WHERE valuta = 'EUR' OR valuta='USD' --valuta IN('EUR' , 'USD')
GROUP BY s.broj
ORDER BY s.broj;

-- We use LEFT JOIN in this query to ensure that all accounts (Smetka) with the specified currencies (EUR or USD) are included in the results,
-- even if there are no matching transactions in the Transakcija_shalter or Transakcija_bankomat tables.
-- Inclusion of All Accounts:
-- If an account has no transactions (either at the counter or via ATM), the LEFT JOIN will still include the account in the results, with NULL values for the average transaction amounts.
-- This is important for maintaining a complete list of accounts that meet the currency condition.
-- Default Handling of Missing Data:
-- When there are no transactions for an account, AVG(NULL) returns NULL, indicating no data for that category of transactions.
-- When to Use Other Joins:
-- INNER JOIN: Would exclude accounts without any matching transactions, which might miss accounts that technically qualify based on the currency condition.
--     RIGHT JOIN or FULL JOIN: Rarely needed here, as the focus is on accounts as the primary dataset.
--     By using LEFT JOIN, we guarantee a comprehensive view of all relevant accounts, even those without transactions, which aligns with the problem's requirements.