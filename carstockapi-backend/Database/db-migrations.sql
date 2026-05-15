
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Dealers;

CREATE TABLE Dealers (
    Id          INTEGER PRIMARY KEY AUTOINCREMENT,
    Name        TEXT NOT NULL,
    Username    TEXT NOT NULL UNIQUE,
    PasswordHash TEXT NOT NULL
);

CREATE TABLE Cars (
    Id          INTEGER PRIMARY KEY AUTOINCREMENT,
    DealerId    INTEGER NOT NULL,
    Make        TEXT NOT NULL,
    Model       TEXT NOT NULL,
    Year        INTEGER NOT NULL,
    Price       REAL NOT NULL DEFAULT 0,
    Stock       INTEGER NOT NULL CHECK (Stock >= 0),
    FOREIGN KEY (DealerId) REFERENCES Dealers(Id)
);
 
-- Customers table (dealer-scoped, matches JWT auth pattern)
CREATE TABLE Customers (
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
(1, 'Toyota', 'Corolla', 2020, 19999.99, 12),
(1, 'Toyota', 'Corolla', 2021, 20999.99, 10),
(1, 'Toyota', 'Camry', 2020, 24999.50, 8),
(1, 'Toyota', 'Camry', 2022, 26999.00, 5),
(1, 'Honda', 'Civic', 2021, 21999.75, 15),
(1, 'Honda', 'Civic', 2022, 22999.50, 10),
(1, 'Ford', 'Mustang', 2021, 35999.00, 3),
(1, 'Ford', 'Mustang', 2022, 37999.00, 2),
(1, 'Tesla', 'Model 3', 2022, 42999.99, 4),
(1, 'Tesla', 'Model 3', 2023, 44999.99, 2),
(2, 'BMW', '3 Series', 2021, 41000, 4),
(2, 'Audi', 'A4', 2020, 39000, 6),
(2, 'Mercedes', 'C-Class', 2019, 42000, 3),
(2, 'Volkswagen', 'Passat', 2022, 28000, 9),
(2, 'Kia', 'Optima', 2021, 23000, 10);

INSERT INTO Customers (DealerId, Name, Email, Phone, CreatedAt) VALUES
(1, 'Alice Johnson', 'alice.johnson@example.com', '555-1234', '2026-05-01 10:15:00'),
(1, 'Bob Smith', 'bob.smith@example.com', '555-5678', '2026-05-02 11:30:00'),
(1, 'Carol Williams', 'carol.williams@example.com', '555-8765', '2026-05-03 09:45:00'),
(1, 'David Brown', 'david.brown@example.com', '555-4321', '2026-05-04 14:20:00'),
(2, 'Eva Davis', 'eva.davis@example.com', '555-2468', '2026-05-05 16:50:00'),
(2, 'Frank Miller', 'frank.miller@example.com', '555-1357', '2026-05-06 08:10:00');

INSERT INTO Sales (DealerId, CarId, CustomerId, SaleAmount, SaleDate, Status) VALUES
(1, 1, 1, 19500.00, '2026-05-10 09:30:00', 'Completed'),
(1, 2, 2, 20500.00, '2026-05-11 11:15:00', 'Completed'),
(1, 4, 3, 26500.00, '2026-05-12 14:45:00', 'Pending'),
(1, 7, 4, 35500.00, '2026-05-13 16:20:00', 'Cancelled'),
(2, 11, 5, 40500.00, '2026-05-14 10:10:00', 'Pending'),
(2, 12, 6, 38500.00, '2026-05-15 13:00:00', 'Completed');