
CREATE TABLE MODEL(
    ID INT IDENTITY PRIMARY KEY ,
    Name VARCHAR(50),
    DESCRIPTION varchar(200)
);

INSERT INTO Model( Name)
VALUES ('Jeans'), ('Shirt');

CREATE TABLE SIZE(
    ID INT IDENTITY PRIMARY KEY ,
    Name VARCHAR(50),
    DESCRIPTION varchar(200)
);

INSERT INTO Size( Name)
VALUES ( 'S'), ( 'M'), ('L');

CREATE TABLE COLOR(
    ID INT IDENTITY PRIMARY KEY ,
    Name VARCHAR(50)
);

INSERT INTO Color( Name)
VALUES ('Blue'),  ('Yellow'), ( 'Red');

CREATE TABLE StoreProduct(
    ID IDENTITY INT,
    ModelID INT,
    SizeID INT,
    ColorID INT,
    RetailPrice INT,
    ItemsOnStock INT,
    FOREIGN KEY (ModelID) REFERENCES MODEL(ID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (SizeID) REFERENCES Size(ID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (ColorID) REFERENCES COLOR(ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE FactoryProduct(
                             ID INT IDENTITY PRIMARY KEY ,
                             ModelID INT,
                             SizeID INT,
                             ColorID INT,
                             FactoryPrice INT,
                             FOREIGN KEY (ModelID) REFERENCES MODEL(ID) ON DELETE SET NULL ON UPDATE CASCADE,
                             FOREIGN KEY (SizeID) REFERENCES Size(ID) ON DELETE SET NULL ON UPDATE CASCADE,
                             FOREIGN KEY (ColorID) REFERENCES COLOR(ID) ON DELETE SET NULL ON UPDATE CASCADE
);


--1 
INSERT INTO FactoryProduct (modelid, sizeid, colorid)
	
    SELECT m.ID, s.ID, c.ID
    FROM MODEL m CROSS JOIN SIZE s CROSS JOIN COLOR c
    
    
UPDATE FactoryProduct
SET factoryprice = 50 * modelid * sizeid * colorid

SELECT * from FactoryProduct


INSERT INTO StoreProduct(modelid, sizeid, colorid, retailprice, itemsonstock)
	SELECT fp.ModelID, fp.SizeID, fp.ColorID, 100*modelid*sizeid*colorid
     ,modelid+sizeid+colorid
    FROM FactoryProduct fp 
	WHERE (modelid+sizeid+colorid) % 3 = 0
    
    SELECT * from StoreProduct
    
--2 

CREATE VIEW FactoryProductsNotinStore AS 
SELECT fp.*
from FactoryProduct fp LEFT OUTER join StoreProduct sp ON fp.ModelID = sp.ModelID AND
	fp.SizeID = sp.SizeID AND 
    fp.ColorID = sp.ColorID
WHERE sp.ID is NULL

SELECT * FROM FactoryProductsNotinStore

--3 
CREATE view RedProducts as 
	SELECT id
    FROM COLOR
    WHERE COLOR.Name == 'Red'

--4
delete 
from FactoryProduct fp 
where colorid IN (
  select id
  from COLOR
  where COLOR.Name = 'yellow'
)

--5

SELECT sp.ID
FROM StoreProduct sp LEFT OUTER join FactoryProduct fp ON sp.ModelID = fp.ModelID AND 
	sp.SizeID = fp.SizeID AND 
    sp.ColorID = fp.ColorID
where sp.ID is NULL

--6 
SELECT fp.ModelID, fp.SizeID, fp.SizeID
FROM FactoryProduct fp 
UNION 
SELECT fp.ModelID, fp.SizeID, fp.SizeID
FROM StoreProduct sp 