---
layout: page
title: Databases and SQL
subtitle: Selecting Data
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Explain the difference between a table, a record, and a field.
> *   Explain the difference between a database and a database manager.
> *   Write a query to select all values for specific fields from a single table.

A [relational database](reference.html#relational-database)
is a way to store and manipulate information. 
Databases are arranged as [tables](reference.html#table).
Each table has columns (also known as [fields](reference.html#field)) that describe the data,
and rows (also known as [records](reference.html#record)) which contain the data.

When we are using a spreadsheet,
we put formulas into cells to calculate new values based on old ones.
When we are using a database,
we send commands
(usually called [queries](reference.html#query))
to a [database manager](reference.html#database-manager):
a program that manipulates the database for us.
The database manager does whatever lookups and calculations the query specifies,
returning the results in a tabular form
that we can then use as a starting point for further queries.

> ## Changing database managers {.callout}
>
> Every database manager --- Oracle,
> IBM DB2, PostgreSQL, MySQL, Microsoft Access, and SQLite --- stores
> data in a different way,
> so a database created with one cannot be used directly by another.
> However,
> every database manager can import and export data in a variety of formats, like .csv,
> so it *is* possible to move information from one to another.

Queries are written in a language called [SQL](reference.html#sql),
which stands for "Structured Query Language".
SQL provides hundreds of different ways to analyze and recombine data.
We will only look at a handful of queries,
but that handful accounts for most of what scientists do.

The tables below show the database we will use in our examples:

> **Person**: people who took readings.
>
> |ident   |personal |family
> |--------|---------|----------
> |dyer    |William  |Dyer
> |pb      |Frank    |Pabodie
> |lake    |Anderson |Lake
> |roe     |Valentina|Roerich
> |danforth|Frank    |Danforth

> **Site**: locations where readings were taken.
>
> |name |lat   |long   |
> |-----|------|-------|
> |DR-1 |-49.85|-128.57|
> |DR-3 |-47.15|-126.72|
> |MSK-4|-48.87|-123.4 |

> **Visited**: when readings were taken at specific sites.
>
> |ident|site |dated     |
> |-----|-----|----------|
> |619  |DR-1 |1927-02-08|
> |622  |DR-1 |1927-02-10|
> |734  |DR-3 |1930-01-07|
> |735  |DR-3 |1930-01-12|
> |751  |DR-3 |1930-02-26|
> |752  |DR-3 |-null-    |
> |837  |MSK-4|1932-01-14|
> |844  |DR-1 |1932-03-22|

> **Survey**: the actual readings.
>
> |taken|person|quant|reading|
> |-----|------|-----|-------|
> |619  |dyer  |rad  |9.82   |
> |619  |dyer  |sal  |0.13   |
> |622  |dyer  |rad  |7.8    |
> |622  |dyer  |sal  |0.09   |
> |734  |pb    |rad  |8.41   |
> |734  |lake  |sal  |0.05   |
> |734  |pb    |temp |-21.5  |
> |735  |pb    |rad  |7.22   |
> |735  |-null-|sal  |0.06   |
> |735  |-null-|temp |-26.0  |
> |751  |pb    |rad  |4.35   |
> |751  |pb    |temp |-18.5  |
> |751  |lake  |sal  |0.1    |
> |752  |lake  |rad  |2.19   |
> |752  |lake  |sal  |0.09   |
> |752  |lake  |temp |-16.0  |
> |752  |roe   |sal  |41.6   |
> |837  |lake  |rad  |1.46   |
> |837  |lake  |sal  |0.21   |
> |837  |roe   |sal  |22.5   |
> |844  |roe   |rad  |11.25  |

Notice that three entries --- one in the `Visited` table,
and two in the `Survey` table --- don't contain any actual
data, but instead have a special `-null-` entry:
we'll return to these missing values [later](05-null.html).
For now,
let's write an SQL query that displays scientists' names.
We do this using the SQL command `SELECT`,
giving it the names of the columns we want and the table we want them from.
Our query and its output look like this:

~~~ {.sql}
SELECT family, personal FROM Person;
~~~

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

The semicolon at the end of the query
tells the database manager that the query is complete and ready to run.
We have written our commands and column names in lower case,
and the table name in Title Case,
but we don't have to:
as the example below shows,
SQL is [case insensitive](reference.html#case-insensitive).

~~~ {.sql}
SeLeCt FaMiLy, PeRsOnAl FrOm PeRsOn;
~~~

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

You can use SQL's case insensitivity to your advantage. For instance, some people choose to write SQL keywords (such as `SELECT` and `FROM`) in capital letters and **field** and **table** names in lower case. This can make it easier to locate parts of an SQL statement. For instance, you can scan the statement, quickly locate the prominent `FROM` keyword and know the table name follows.
Whatever casing convention you choose,
please be consistent:
complex queries are hard enough to read without the extra cognitive load of random capitalization.
One convention is to use UPPER CASE for SQL statements, to distinguish them from tables and column
names. This is the convention that we will use for this lesson.

Going back to our query,
it's important to understand that
the rows and columns in a database table aren't actually stored in any particular order.
They will always be *displayed* in some order,
but we can control that in various ways.
For example,
we could swap the columns in the output by writing our query as:

~~~ {.sql}
SELECT personal, family FROM Person;
~~~

|personal |family  |
|---------|--------|
|William  |Dyer    |
|Frank    |Pabodie |
|Anderson |Lake    |
|Valentina|Roerich |
|Frank    |Danforth|

or even repeat columns:

~~~ {.sql}
SELECT ident, ident, ident FROM Person;
~~~

|ident   |ident   |ident   |
|--------|--------|--------|
|dyer    |dyer    |dyer    |
|pb      |pb      |pb      |
|lake    |lake    |lake    |
|roe     |roe     |roe     |
|danforth|danforth|danforth|

As a shortcut,
we can select all of the columns in a table using `*`:

~~~ {.sql}
SELECT * FROM Person;
~~~

|ident   |personal |family  |
|--------|---------|--------|
|dyer    |William  |Dyer    |
|pb      |Frank    |Pabodie |
|lake    |Anderson |Lake    |
|roe     |Valentina|Roerich |
|danforth|Frank    |Danforth|

> ## Selecting Site Names {.challenge}
>
> Write a query that selects only site names from the `Site` table.

> ## Query Style {.challenge}
>
> Many people format queries as:
>
> ~~~
> SELECT personal, family FROM person;
> ~~~
>
> or as:
>
> ~~~
> select Personal, Family from PERSON;
> ~~~
>
> What style do you find easiest to read, and why?
