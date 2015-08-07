-- The `Person` table is used to explain the most basic queries.
-- Note that `danforth` has no measurements.
DROP TABLE IF EXISTS Person;
CREATE TABLE Person(
	ident    TEXT,
	personal TEXT,
	family	 TEXT
);

INSERT INTO Person VALUES('dyer',     'William',   'Dyer');
INSERT INTO Person VALUES('pb',       'Frank',     'Pabodie');
INSERT INTO Person VALUES('lake',     'Anderson',  'Lake');
INSERT INTO Person VALUES('roe',      'Valentina', 'Roerich');
INSERT INTO Person VALUES('danforth', 'Frank',     'Danforth');

-- The `Site` table is equally simple.  Use it to explain the
-- difference between databases and spreadsheets: in a spreadsheet,
-- the lat/long of measurements would probably be duplicated.
DROP TABLE IF EXISTS Site;
CREATE TABLE Site(
	name TEXT,
	lat  REAL,
	long REAL
);

INSERT INTO Site VALUES('DR-1', -49.85, -128.57);
INSERT INTO Site VALUES('DR-3', -47.15, -126.72);
INSERT INTO Site VALUES('MSK-4', -48.87, -123.40);

-- `Visited` is an enhanced `join` table: it connects to the lat/long
-- of specific measurements, and also provides their dates.
-- Note that #752 is missing a date; we use this to talk about NULL.
DROP TABLE IF EXISTS Visited;
CREATE TABLE Visited(
	ident INTEGER,
	site  TEXT,
	dated TEXT
);

INSERT INTO Visited VALUES(619, 'DR-1',  '1927-02-08');
INSERT INTO Visited VALUES(622, 'DR-1',  '1927-02-10');
INSERT INTO Visited VALUES(734, 'DR-3',  '1930-01-07');
INSERT INTO Visited VALUES(735, 'DR-3',  '1930-01-12');
INSERT INTO Visited VALUES(751, 'DR-3',  '1930-02-26');
INSERT INTO Visited VALUES(752, 'DR-3',  null);
INSERT INTO Visited VALUES(837, 'MSK-4', '1932-01-14');
INSERT INTO Visited VALUES(844, 'DR-1',  '1932-03-22');

-- The `Survey` table is the actual readings.  Join it with `Site` to
-- get lat/long, and with `Visited` to get dates (except for #752).
-- Note that Roerich's salinity measurements are an order of magnitude
-- too large (use this to talk about data cleanup).  Note also that
-- there are two cases where we don't know who took the measurement,
-- and that in most cases we don't have an entry (null or not) for the
-- temperature.
DROP TABLE IF EXISTS Survey;
CREATE TABLE Survey(
	taken   INTEGER,
	person  TEXT,
	quant   TEXT,
	reading REAL
);

INSERT INTO Survey VALUES(619, 'dyer', 'rad',    9.82);
INSERT INTO Survey VALUES(619, 'dyer', 'sal',    0.13);
INSERT INTO Survey VALUES(622, 'dyer', 'rad',    7.80);
INSERT INTO Survey VALUES(622, 'dyer', 'sal',    0.09);
INSERT INTO Survey VALUES(734, 'pb',   'rad',    8.41);
INSERT INTO Survey VALUES(734, 'lake', 'sal',    0.05);
INSERT INTO Survey VALUES(734, 'pb',   'temp', -21.50);
INSERT INTO Survey VALUES(735, 'pb',   'rad',    7.22);
INSERT INTO Survey VALUES(735, null,   'sal',    0.06);
INSERT INTO Survey VALUES(735, null,   'temp', -26.00);
INSERT INTO Survey VALUES(751, 'pb',   'rad',    4.35);
INSERT INTO Survey VALUES(751, 'pb',   'temp', -18.50);
INSERT INTO Survey VALUES(751, 'lake', 'sal',    0.10);
INSERT INTO Survey VALUES(752, 'lake', 'rad',    2.19);
INSERT INTO Survey VALUES(752, 'lake', 'sal',    0.09);
INSERT INTO Survey VALUES(752, 'lake', 'temp', -16.00);
INSERT INTO Survey VALUES(752, 'roe',  'sal',   41.60);
INSERT INTO Survey VALUES(837, 'lake', 'rad',    1.46);
INSERT INTO Survey VALUES(837, 'lake', 'sal',    0.21);
INSERT INTO Survey VALUES(837, 'roe',  'sal',   22.50);
INSERT INTO Survey VALUES(844, 'roe',  'rad',   11.25);
