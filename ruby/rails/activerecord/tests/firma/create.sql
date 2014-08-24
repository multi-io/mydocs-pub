CREATE TABLE kunde
(
    id            INT PRIMARY KEY, 
    name          VARCHAR(40) NOT NULL,
    geburtsjahr   INT,
    wohnsitz_id   INT REFERENCES adresse(id),
    geburtsort_id INT REFERENCES stadt(id)
);


CREATE TABLE produkt
(
    id         INT PRIMARY KEY,
    name       VARCHAR(40) NOT NULL,
    preis      INT NOT NULL
);


CREATE TABLE bestellung
(
    id          INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    produkt_id  INT REFERENCES produkt(id),
    kunde_id    INT REFERENCES kunde(id),
    anzahl      INT NOT NULL
);


CREATE TABLE firma
(
    id         INT PRIMARY KEY,
    name       VARCHAR(40),
);


CREATE TABLE produkt_hersteller
(
    produkt_id  INT REFERENCES produkt(id),
    firma_id    INT REFERENCES firma(id),
);


CREATE TABLE stadt
(
    id         INT PRIMARY KEY, 
    name       VARCHAR(40) NOT NULL,
    ewzahl     INT,
);


CREATE TABLE adresse
(
    id         INT PRIMARY KEY,
    stadt_id   INT REFERENCES stadt(id),
    strasse    VARCHAR(40),
    nr         INT
);
