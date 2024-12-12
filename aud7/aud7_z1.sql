CREATE TABLE Snabduvaci (
  s INT PRIMARY KEY,
  ime_s VARCHAR(50) NOT NULL,
  saldo INT CHECK (saldo > 0),
  grad VARCHAR(20) DEFAULT 'Skopje'
);

CREATE TABLE Proizvodi (
  proiz INT,
  vid INT,
  ime_p VARCHAR(50) NOT NULL,
  boja CHAR(5),
  tezina INT,
  grad_p VARCHAR(20) CHECK (grad_p IN ( 'London', 'Paris', 'Rome')),
  CONSTRAINT proizvodi_PK PRIMARY KEY(proiz, vid)
);

CREATE TABLE Ponudi (
  p NUMERIC(5) PRIMARY KEY,
  s INT ,
  pr INT,
  v INT,
  kolicina_nar INT,
  datum_nar DATE,
  kolicina_isp INT,
  datum_isp DATE,
  CHECK (kolicina_isp <= kolicina_nar),
  CONSTRAINT ponudi_FK FOREIGN KEY (pr, v) REFERENCES Proizvodi(proiz,vid) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ponudi_FK2 FOREIGN KEY (s) REFERENCES Snabduvaci(s) ON DELETE CASCADE ON UPDATE CASCADE
);