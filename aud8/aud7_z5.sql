CREATE TABLE FIRMA (
                       ime VARCHAR(100) PRIMARY KEY,       -- Unique name for the firm
                       adresa VARCHAR(200),               -- Address of the firm
                       grad VARCHAR(100),                 -- City where the firm is located
                       drzava VARCHAR(100)                -- Country where the firm is located
);

CREATE TABLE SMETKA2 (
                        SB INT PRIMARY KEY,               -- Unique account number
                        tip VARCHAR(50),                   -- Type of the account (e.g., savings, checking)
                        sostojba DECIMAL(10, 2),           -- Account balance
                        imeBanka VARCHAR(100)              -- Name of the bank
);

CREATE TABLE UPLATA (
                        ime VARCHAR(100),                  -- Foreign key referencing FIRMA
                        SB INT,                           -- Foreign key referencing SMETKA
                        suma DECIMAL(10, 2),               -- Payment amount
                        zadocneto BOOLEAN,                 -- Whether the payment was late
                        PRIMARY KEY (ime, SB),            -- Composite primary key
                        FOREIGN KEY (ime) REFERENCES FIRMA(ime),
                        FOREIGN KEY (SB) REFERENCES SMETKA2(SB)
);

--views - virtuelni tabeli
CREATE VIEW UPLATA_POM AS SELECT * FROM UPLATA;

CREATE VIEW UPLATI_4 AS
    SELECT *
    FROM UPLATA_POM --od pomosnata tabela - view
    WHERE UPLATA_POM.SB = 4;

CREATE VIEW FIRMA_POS2(FIRMA, POSTENSKA_ADRESA) AS
    SELECT ime, adresa || '' || grad || ',' || drzava -- // namesto + za konkatanacija
    FROM FIRMA;


CREATE VIEW ZADOCNETI_PLAKANJA(ime, vkupno, tipSmetka ) AS
    SELECT UPLATA.ime, UPLATA.suma * 1.10, smetka2.tip
    FROM UPLATA, SMETKA2
    WHERE UPLATA.SB = SMETKA2.SB AND
          UPLATA.zadocneto = TRUE;


--koristenje na indeksi
CREATE INDEX smetkaIndeks ON UPLATA(SB); --kreira indeks na kolonata SB vo tabelata

DROP INDEX smetkaIndeks;










