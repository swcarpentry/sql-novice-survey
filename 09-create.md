---
title: Creating and Modifying Data
teaching: 15
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Write statements that create tables.
- Write statements to insert, modify, and delete records.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I create, modify, and delete tables and data?

::::::::::::::::::::::::::::::::::::::::::::::::::

So far we have only looked at how to get information out of a database,
both because that is more frequent than adding information,
and because most other operations only make sense
once queries are understood.

The `Person`, `Survey`, `Site`, and `Visited` tables from the `survey,db` database were
used during the earlier episodes. We're going to build a new database over the course
of the upcoming episodes. Exit the `SQLite` interactive session if you're still in it.

```sql
.exit
```

Launch `SQLite3` and create a new database, lets call it `newsurvey.db`.
We use a different name to avoid confusion with the currently existing `survey.db` database.

```
$ sqlite3 newsurvey.db
```

Run the `.mode column` and `.header on` commands again if you aren't using the `.sqliterc` file.
(Note if you exited and restarted SQLite3 your settings will change back to the default)

```sql
.mode column
.header on
```

If we want to create and modify data,
we need to know two other sets of commands.

The first pair are [`CREATE TABLE`][create-table] and [`DROP TABLE`][drop-table].
While they are written as two words,
they are actually single commands.
The first one creates a new table;
its arguments are the names and types of the table's columns.
For example,
the following statements create the four tables in our survey database:

```sql
CREATE TABLE Person(id text, personal text, family text);
CREATE TABLE Site(name text, lat real, long real);
CREATE TABLE Visited(id integer, site text, dated text);
CREATE TABLE Survey(taken integer, person text, quant text, reading real);
```

We can get rid of one of our tables using:

```sql
DROP TABLE Survey;
```

Be very careful when doing this:
if you drop the wrong table, hope that the person maintaining the database has a backup,
but it's better not to have to rely on it.

Different database systems support different data types for table columns,
but most provide the following:

| data type | use                                       | 
| --------- | ----------------------------------------- |
| INTEGER   | a signed integer                          | 
| REAL      | a floating point number                   | 
| TEXT      | a character string                        | 
| BLOB      | a "binary large object", such as an image | 

Most databases also support Booleans and date/time values;
SQLite uses the integers 0 and 1 for the former,
and represents the latter as discussed [earlier](03-filter.md).
An increasing number of databases also support geographic data types,
such as latitude and longitude.
Keeping track of what particular systems do or do not offer,
and what names they give different data types,
is an unending portability headache.

When we create a table,
we can specify several kinds of constraints on its columns.
For example,
a better definition for the `Survey` table would be:

```sql
CREATE TABLE Survey(
    taken   integer not null, -- where reading taken
    person  text,             -- may not know who took it
    quant   text not null,    -- the quantity measured
    reading real not null,    -- the actual reading
    primary key(taken, person, quant),    -- key is taken + person + quant
    foreign key(taken) references Visited(id),
    foreign key(person) references Person(id)
);
```

Once again,
exactly what constraints are available
and what they're called
depends on which database manager we are using.

Once tables have been created,
we can add, change, and remove records using our other set of commands,
`INSERT`, `UPDATE`, and `DELETE`.

Here is an example of inserting rows into the `Site` table:

```sql
INSERT INTO Site (name, lat, long) VALUES ('DR-1', -49.85, -128.57);
INSERT INTO Site (name, lat, long) VALUES ('DR-3', -47.15, -126.72);
INSERT INTO Site (name, lat, long) VALUES ('MSK-4', -48.87, -123.40);
```

We can also insert values into one table directly from another:

```sql
CREATE TABLE JustLatLong(lat real, long real);
INSERT INTO JustLatLong SELECT lat, long FROM Site;
```

Modifying existing records is done using the `UPDATE` statement.
To do this we tell the database which table we want to update,
what we want to change the values to for any or all of the fields,
and under what conditions we should update the values.

For example, if we made a mistake when entering the lat and long values
of the last `INSERT` statement above, we can correct it with an update:

```sql
UPDATE Site SET lat = -47.87, long = -122.40 WHERE name = 'MSK-4';
```

Be careful to not forget the `WHERE` clause or the update statement will
modify *all* of the records in the `Site` table.

Deleting records can be a bit trickier,
because we have to ensure that the database remains internally consistent.
If all we care about is a single table,
we can use the `DELETE` command with a `WHERE` clause
that matches the records we want to discard.
For example,
once we realize that Frank Danforth didn't take any measurements,
we can remove him from the `Person` table like this:

```sql
DELETE FROM Person WHERE id = 'danforth';
```

But what if we removed Anderson Lake instead?
Our `Survey` table would still contain seven records
of measurements he'd taken,
but that's never supposed to happen:
`Survey.person` is a foreign key into the `Person` table,
and all our queries assume there will be a row in the latter
matching every value in the former.

This problem is called [referential integrity](../learners/reference.md#referential-integrity):
we need to ensure that all references between tables can always be resolved correctly.
One way to do this is to delete all the records
that use `'lake'` as a foreign key
before deleting the record that uses it as a primary key.
If our database manager supports it,
we can automate this
using [cascading delete](../learners/reference.md#cascading-delete).
However,
this technique is outside the scope of this chapter.

:::::::::::::::::::::::::::::::::::::::::  callout

## Hybrid Storage Models

Many applications use a hybrid storage model
instead of putting everything into a database:
the actual data (such as astronomical images) is stored in files,
while the database stores the files' names,
their modification dates,
the region of the sky they cover,
their spectral characteristics,
and so on.
This is also how most music player software is built:
the database inside the application keeps track of the MP3 files,
but the files themselves live on disk.


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Replacing NULL

Write an SQL statement to replace all uses of `null` in
`Survey.person` with the string `'unknown'`.

:::::::::::::::  solution

## Solution

```sql
UPDATE Survey SET person = 'unknown' WHERE person IS NULL;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Backing Up with SQL

SQLite has several administrative commands that aren't part of the
SQL standard.  One of them is `.dump`, which prints the SQL commands
needed to re-create the database.  Another is `.read`, which reads a
file created by `.dump` and restores the database.  A colleague of
yours thinks that storing dump files (which are text) in version
control is a good way to track and manage changes to the database.
What are the pros and cons of this approach?  (Hint: records aren't
stored in any particular order.)

:::::::::::::::  solution

## Solution

#### Advantages

- A version control system will be able to show differences between versions
  of the dump file; something it can't do for binary files like databases
- A VCS only saves changes between versions, rather than a complete copy of
  each version (save disk space)
- The version control log will explain the reason for the changes in each version
  of the database

#### Disadvantages

- Artificial differences between commits because records don't have a fixed order
  
  

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

[create-table]: https://www.sqlite.org/lang_createtable.html
[drop-table]: https://www.sqlite.org/lang_droptable.html


:::::::::::::::::::::::::::::::::::::::: keypoints

- Use CREATE and DROP to create and delete tables.
- Use INSERT to add data.
- Use UPDATE to modify existing data.
- Use DELETE to remove data.
- It is simpler and safer to modify data when every record has a unique primary key.
- Do not create dangling references by deleting records that other records refer to.

::::::::::::::::::::::::::::::::::::::::::::::::::


