-- build_database.sql
-- Builds the basis of our package database.
--
-- Author: Nathan Campos <nathanpc@dreamintech.net>

CREATE TABLE Packages(
    id INTEGER NOT NULL PRIMARY KEY,
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    carrier TEXT NOT NULL,
    shipped TEXT NOT NULL,
    delivered TEXT NOT NULL,
	wait_period INTEGER NOT NULL
);

