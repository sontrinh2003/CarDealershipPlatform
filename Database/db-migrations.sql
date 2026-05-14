
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Dealers;

CREATE TABLE Dealers (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Username TEXT NOT NULL UNIQUE,
    PasswordHash TEXT NOT NULL
);

CREATE TABLE Cars (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    DealerId INTEGER NOT NULL,
    Make TEXT NOT NULL,
    Model TEXT NOT NULL,
    Year INTEGER NOT NULL,
    Price REAL NOT NULL DEFAULT 0,
    Stock INTEGER NOT NULL CHECK (Stock >= 0),
    FOREIGN KEY (DealerId) REFERENCES Dealers(Id)
);
 
-- Customers table (dealer-scoped, matches JWT auth pattern)
CREATE TABLE IF NOT EXISTS Customers (
    Id        INTEGER PRIMARY KEY AUTOINCREMENT,
    DealerId  INTEGER NOT NULL,
    Name      TEXT    NOT NULL,
    Email     TEXT    NOT NULL,
    Phone     TEXT    NOT NULL DEFAULT '',
    CreatedAt TEXT    NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (DealerId) REFERENCES Dealers(Id)
);
 
-- Sales table (atomic with car stock — use a transaction when inserting)
CREATE TABLE IF NOT EXISTS Sales (
    Id         INTEGER PRIMARY KEY AUTOINCREMENT,
    DealerId   INTEGER NOT NULL,
    CarId      INTEGER NOT NULL,
    CustomerId INTEGER NOT NULL,
    SaleAmount REAL    NOT NULL,
    SaleDate   TEXT    NOT NULL DEFAULT (datetime('now')),
    Status     TEXT    NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (DealerId)   REFERENCES Dealers(Id),
    FOREIGN KEY (CarId)      REFERENCES Cars(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);
 
-- Useful indexes
CREATE INDEX IF NOT EXISTS idx_customers_dealer ON Customers(DealerId);
CREATE INDEX IF NOT EXISTS idx_sales_dealer      ON Sales(DealerId);
CREATE INDEX IF NOT EXISTS idx_sales_date        ON Sales(SaleDate DESC);

INSERT INTO Dealers (Name, Username, PasswordHash) VALUES
('City Motors', 'citymotors', 'password1'),
('Premium Autos', 'premiumautos', 'password2');

INSERT INTO Cars (DealerId, Make, Model, Year, Price, Stock) VALUES
(1, 'Toyota', 'Camry', 2020, 24000, 10),
(1, 'Honda', 'Civic', 2019, 20000, 8),
(1, 'Ford', 'Mustang', 2021, 35000, 5),
(1, 'Chevrolet', 'Malibu', 2018, 18000, 12),
(1, 'Nissan', 'Altima', 2022, 26000, 7);

INSERT INTO Cars (DealerId, Make, Model, Year, Price, Stock) VALUES
(2, 'BMW', '3 Series', 2021, 41000, 4),
(2, 'Audi', 'A4', 2020, 39000, 6),
(2, 'Mercedes', 'C-Class', 2019, 42000, 3),
(2, 'Volkswagen', 'Passat', 2022, 28000, 9),
(2, 'Kia', 'Optima', 2021, 23000, 10);