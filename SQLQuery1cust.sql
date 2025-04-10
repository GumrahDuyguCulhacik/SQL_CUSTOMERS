--1-Erstellen Sie eine Datenbank namens "Customers" und fügen Sie die angegebene Excel-Datei als Tabelle hinzu.

CREATE TABLE CUSTOMERS 
(ID INT IDENTITY(1,1) PRIMARY KEY,
NAMESURNAME VARCHAR(100), TCNUMBER VARCHAR(11), 
GENDER VARCHAR(1), EMAIL VARCHAR(100),  BIRTHDATE DATE, 
CITYID INT, DISTRICTID INT,
TELNR1 VARCHAR(15), TELNR2 VARCHAR(15))


CREATE TABLE CITIES
(ID INT IDENTITY(1,1) PRIMARY KEY,
CITY VARCHAR (50))

CREATE TABLE DISTRICTS
(ID INT IDENTITY(1,1) PRIMARY KEY,
CITYID INT, DISTRICT VARCHAR (50))

--Diagramm

ALTER TABLE CUSTOMERS
ADD CONSTRAINT FK_Customers_Cities
FOREIGN KEY (CITYID)
REFERENCES CITIES(ID)

ALTER TABLE DISTRICTS
ADD CONSTRAINT FK_Districts_Cities
FOREIGN KEY (CITYID)
REFERENCES CITIES(ID)

ALTER TABLE CUSTOMERS
ADD CONSTRAINT FK_Customers_Districts
FOREIGN KEY (DISTRICTID)
REFERENCES DISTRICTS(ID)

--2-Schreiben Sie eine Abfrage, um Personen abzurufen, deren Name mit dem Buchstaben "A" beginnt, aus der Tabelle "Customers".

SELECT * FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'A%'

--3-Rufen Sie die Kunden ab, die zwischen 1990 und 1995 geboren wurden (einschließlich 1990 und 1995).
SELECT * FROM CUSTOMERS
WHERE YEAR (BIRTHDATE)  BETWEEN 1990 AND 1995

--4-Schreiben Sie eine Abfrage mit JOIN, um die in Istanbul lebenden Personen abzurufen.
SELECT CO.ID, CO.NAMESURNAME, CO.GENDER, CO. CITYID, C.ID, C.CITY, D. DISTRICT  FROM CUSTOMERS CO
JOIN CITIES C ON C.ID = CO.CITYID
JOIN DISTRICTS D ON D.ID = CO.DISTRICTID
WHERE C.CITY = 'ISTANBUL'
ORDER BY  D. DISTRICT

--SELECT * FROM CUSTOMERS 
--WHERE CITYID = 34

--5-Schreiben Sie eine Abfrage mit Subquery, um die in Istanbul lebenden Personen abzurufen.
 SELECT CO.ID, CO.NAMESURNAME, CO.GENDER, CO.CITYID,
   (SELECT C.CITY 
    FROM CITIES C
    WHERE C.ID = CO.CITYID) AS CITY
FROM CUSTOMERS CO
WHERE CO.CITYID IN (
    SELECT C.ID 
    FROM CITIES C
    WHERE C.CITY = 'ISTANBUL')
 
--6-Schreiben Sie eine Abfrage, um die Anzahl der Kunden in jeder Stadt zu erhalten.
SELECT C.CITY, COUNT(*) AS CUSTOMER_COUNT
FROM CUSTOMERS CO
INNER JOIN CITIES C ON CO.CITYID = C.ID
GROUP BY C.CITY
ORDER BY CUSTOMER_COUNT DESC
--7-Bringen Sie die Städte mit mehr als 10 Kunden, zusammen mit der Kundenanzahl, in absteigender Reihenfolge nach der Anzahl der Kunden.
SELECT C.CITY, COUNT(*) AS CUSTOMER_COUNT
FROM CUSTOMERS CO
INNER JOIN CITIES C ON CO.CITYID = C.ID
GROUP BY C.CITY
HAVING COUNT(*) > 10
ORDER BY CUSTOMER_COUNT DESC
--8-Schreiben Sie eine Abfrage, um die Anzahl der männlichen und weiblichen Kunden in jeder Stadt zu erhalten.
SELECT C.CITY, CO.GENDER, COUNT(GENDER) AS GENDER_COUNT
FROM CUSTOMERS CO
INNER JOIN CITIES C ON CO.CITYID = C.ID
GROUP BY C.CITY, CO.GENDER
ORDER BY  C.CITY, CO.GENDER
--9-Fügen Sie ein neues Feld für die Altersgruppe zur "Customers"-Tabelle hinzu. 
--Führen Sie dies sowohl mit Management Studio als auch mit SQL-Code aus. 
--Der Feldname sollte AGEGROUP sein, und der Datentyp VARCHAR(50).
------Mit SQL-Code:
ALTER TABLE CUSTOMERS
ADD AGEGROUP VARCHAR(50)
--10-Aktualisieren Sie das AGEGROUP-Feld in der "Customers"-Tabelle 
--mit folgenden Werten: 20-35 Jahre, 36-45 Jahre, 46-55 Jahre, 55-65 Jahre und über 65 Jahre.
UPDATE CUSTOMERS
SET AGEGROUP = CASE
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 20 AND 35 THEN '20-35 Jahre'
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 Jahre'
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 Jahre'
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 56 AND 65 THEN '55-65 Jahre'
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) > 65 THEN 'über 65 Jahre'
END

SELECT TOP 20 [AGEGROUP] FROM CUSTOMERS
--11-Listen Sie Personen auf, die in Istanbul wohnen, aber nicht aus dem Bezirk "Kadıköy" stammen.
SELECT CO.ID, CO.NAMESURNAME, C.CITY, D. DISTRICT  FROM CUSTOMERS CO
JOIN CITIES C ON C.ID = CO.CITYID
JOIN DISTRICTS D ON D.ID = CO.DISTRICTID
WHERE C.CITY = 'ISTANBUL' AND D. DISTRICT<> 'Kadiköy'
ORDER BY  D. DISTRICT

--12-Wir möchten die Betreiberinformationen der Telefonnummern unserer Kunden abrufen. 
--Fügen Sie neben den Feldern TELNR1 und TELNR2 die Betreiberkennungen wie (532), (505) hinzu.
--Schreiben Sie die entsprechende SQL-Abfrage.
SELECT 
   SUBSTRING(TELNR1, 2, 3) AS Operator1,
   SUBSTRING(TELNR2, 2, 3) AS Operator2
FROM 
    CUSTOMERS

--13-Wir möchten die Betreiberinformationen der Telefonnummern unserer Kunden abrufen. 
--Zum Beispiel: Telefonnummern, die mit "50" oder "55" beginnen, 
--gehören zu Betreiber "X", "54" zu Betreiber "Y" und "53" zu Betreiber "Z". 
--Schreiben Sie eine Abfrage, um die Anzahl der Kunden pro Betreiber zu erhalten.
SELECT
COUNT(*) AS Kundenanzahl,
   CASE 
      WHEN SUBSTRING(TELNR1, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR1, 2, 2) = '53' THEN 'Z'
   END AS Operator1,  
	CASE 
      WHEN SUBSTRING(TELNR2, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR2, 2, 2) = '53' THEN 'Z'
   END AS Operator2
FROM CUSTOMERS
GROUP BY
   CASE 
      WHEN SUBSTRING(TELNR1, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR1, 2, 2) = '53' THEN 'Z'
   END,
   CASE 
      WHEN SUBSTRING(TELNR2, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR2, 2, 2) = '53' THEN 'Z'
   END;

--
SELECT
   CASE 
      WHEN SUBSTRING(TELNR1, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR1, 2, 2) = '53' THEN 'Z'
   END AS Operator1,
   COUNT(*) AS Kundenanzahl1
FROM
   CUSTOMERS
GROUP BY
   CASE 
      WHEN SUBSTRING(TELNR1, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR1, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR1, 2, 2) = '53' THEN 'Z'
   END

UNION ALL

SELECT
   CASE 
      WHEN SUBSTRING(TELNR2, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR2, 2, 2) = '53' THEN 'Z'
   END AS Operator2,
   COUNT(*) AS Kundenanzahl2
FROM
   CUSTOMERS
GROUP BY
   CASE 
      WHEN SUBSTRING(TELNR2, 2, 2) = '50' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '55' THEN 'X'
      WHEN SUBSTRING(TELNR2, 2, 2) = '54' THEN 'Y'
      WHEN SUBSTRING(TELNR2, 2, 2) = '53' THEN 'Z'
   END;
--14-Schreiben Sie eine Abfrage, um die Bezirke in jeder Stadt mit der höchsten Kundenzahl 
--in absteigender Reihenfolge nach Kundenzahl zu erhalten.
WITH RankedDistricts AS (
    SELECT 
        C.CITY,
        D.DISTRICT,
        COUNT(CO.ID) AS CustomerCount,
        ROW_NUMBER() OVER (PARTITION BY C.ID ORDER BY COUNT(CO.ID) DESC) AS RowNumber
    FROM 
        CITIES C
    JOIN 
        DISTRICTS D
    ON 
       C.ID = D.CITYID
    LEFT JOIN 
        CUSTOMERS CO
    ON 
        D.CITYID = CO.DISTRICTID
    GROUP BY 
        C.CITY, C.ID, D.DISTRICT)
SELECT 
    CITY,
    DISTRICT,
    CustomerCount
FROM 
    RankedDistricts
WHERE 
    RowNumber = 1
ORDER BY 
    CustomerCount DESC;



--15-Schreiben Sie eine Abfrage, um die Geburtstage der Kunden als Wochentag (Montag, Dienstag, ...) anzuzeigen.
SET LANGUAGE DEUTSCH

SELECT 
    NAMESURNAME,
    DATENAME(WEEKDAY, BirthDate) AS Weekday
FROM 
    Customers
ORDER BY 
    CASE DATENAME(WEEKDAY, BirthDate)
        WHEN 'MONTAG' THEN 1
        WHEN 'DIENSTAG' THEN 2
        WHEN 'MITTWOCH' THEN 3
        WHEN 'DONNERSTAG' THEN 4
        WHEN 'FREITAG' THEN 5
        WHEN 'SAMSTAG' THEN 6
        WHEN 'SONNTAG' THEN 7
    END 