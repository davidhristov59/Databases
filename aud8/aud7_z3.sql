CREATE TABLE PROIZVOD2 (
                          sifra VARCHAR(10) PRIMARY KEY,  -- Unique code for the product
                          imePr VARCHAR(100),             -- Name of the product
                          edMer VARCHAR(10),              -- Unit of measurement
                          kol INT,                        -- Quantity
                          nabCena DECIMAL(10, 2),         -- Purchase price
                          rabat INT,                      -- Discount percentage
                          prodCena DECIMAL(10, 2)         -- Sale price
);

INSERT INTO PROIZVOD2 (sifra, imePr, edMer, kol, nabCena, rabat, prodCena) VALUES
                                                                              ('L12', 'Leb T-400', 'parce', 120, 20.00, 5, 20.00),
                                                                              ('M3', 'Maslo rastitelno', 'lit', 89, 65.01, 0, 72.00),
                                                                              ('M8', 'Maslo od maslinki', 'lit', 34, 209.35, 0, 250.00),
                                                                              ('K14', 'Domati', 'kgr', 345, 56.00, 10, 60.00),
                                                                              ('M16', 'Maslo bez holesterol', 'lit', 99, 70.50, 0, 75.00),
                                                                              ('L3', 'Leb od furna', 'parce', 206, 25.00, 5, 25.00),
                                                                              ('K22', 'Piperki', 'kgr', 870, 48.89, 10, 50.00),
                                                                              ('K30', 'Jagodi', 'kgr', 200, 100.50, 10, 120.00),
                                                                              ('L2', 'Lepinja', 'parce', 189, 23.00, 3, 23.00);

SELECT imePr, nabCena, prodCena * 100/118 as prodCenaBezDDV
FROM PROIZVOD2;


SELECT imePr, nabCena, prodCena, (prodCena - PROIZVOD2.nabCena) razlikaProdNabCena
FROM PROIZVOD2;

SELECT SIFRA, IMEPR, EDMER, KOL, NABCENA, RABAT, PRODCENA
FROM PROIZVOD2
WHERE imePr LIKE 'Maslo%'; --% zamenuva poveke karakteri
--WHERE name LIKE '% oil'; za Olive oil

SELECT SIFRA, IMEPR, EDMER, KOL, NABCENA, RABAT, PRODCENA
FROM PROIZVOD2
WHERE edMer = 'lit' OR edMer = 'kgr';

SELECT *
FROM PROIZVOD2
WHERE prodCena >= 50.00 AND prodCena <= 250.00;