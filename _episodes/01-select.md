---
title: "Selecting Data"
teaching: 10
exercises: 5
questions:
- "How can I get data from a database?"
objectives:
- "Explain the difference between a table, a record, and a field."
- "Explain the difference between a database and a database manager."
- "Write a query to select all values for specific fields from a single table."
keypoints:
- "A relational database stores information in tables, each of which has a fixed set of columns and a variable number of records."
- "A database manager is a program that manipulates information stored in a database."
- "We write queries in a specialized language called SQL to extract information from databases."
- "Use SELECT... FROM... to get values from a database table."
- "SQL is case-insensitive (but data is case-sensitive)."
---
A [relational database]({{ page.root }}{% link reference.md %}#relational-database)
is a way to store and manipulate information.
Databases are arranged as [tables]({{ page.root }}{% link reference.md %}#table).
Each table has columns (also known as [fields]({{ page.root }}{% link reference.md %}#fields)) that describe the data,
and rows (also known as [records]({{ page.root }}{% link reference.md %}#record)) which contain the data.

When we are using a spreadsheet,
we put formulas into cells to calculate new values based on old ones.
When we are using a database,
we send commands
(usually called [queries]({{ page.root }}{% link reference.md %}#query))
to a [database manager]({{ page.root }}{% link reference.md %}#database-manager):
a program that manipulates the database for us.
The database manager does whatever lookups and calculations the query specifies,
returning the results in a tabular form
that we can then use as a starting point for further queries.

Queries are written in a language called [SQL]({{ page.root }}{% link reference.md %}#sql),
which stands for "Structured Query Language".
SQL provides hundreds of different ways to analyze and recombine data.
We will only look at a handful of queries,
but that handful accounts for most of what scientists do.

> ## Changing Database Managers
>
> Many database managers --- Oracle,
> IBM DB2, PostgreSQL, MySQL, Microsoft Access, and SQLite ---  understand
> SQL but each stores data in a different way,
> so a database created with one cannot be used directly by another.
> However, every database manager
> can import and export data in a variety of formats like .csv, SQL,
> so it *is* possible to move information from one to another.
{: .callout}

> ## Getting Into and Out Of SQLite
>
> In order to use the SQLite commands *interactively*, we need to
> enter into the SQLite console.  So, open up a terminal, and run
>
> ~~~
> $ cd /path/to/survey/data/
> $ sqlite3 survey.db
> ~~~
> {: .bash}
>
> The SQLite command is `sqlite3` and you are telling SQLite to open up
> the `survey.db`.  You need to specify the `.db` file, otherwise SQLite
> will open up a temporary, empty database.
>
> To get out of SQLite, type out `.exit` or `.quit`.  For some
> terminals, `Ctrl-D` can also work.  If you forget any SQLite `.` (dot)
> command, type `.help`.
{: .callout}

Before we get into using SQLite to select the data, let's take a look at the tables of the database we will use in our examples:

<div class="row">
  <div class="col-md-6" markdown="1">

**Person**: people who took readings.

|id      |personal |family
|--------|---------|----------
|dyer    |William  |Dyer
|pb      |Frank    |Pabodie
|lake    |Anderson |Lake
|roe     |Valentina|Roerich
|danforth|Frank    |Danforth

**Site**: locations where readings were taken.

|name |lat   |long   |
|-----|------|-------|
|DR-1 |-49.85|-128.57|
|DR-3 |-47.15|-126.72|
|MSK-4|-48.87|-123.4 |

**Visited**: when readings were taken at specific sites.

|id   |site |dated     |
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|752  |DR-3 |-null-    |
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

  </div>
  <div class="col-md-6" markdown="1">

**Survey**: the actual readings.  The field `quant` is short for quantitative and indicates what is being measured.  Values are `rad`, `sal`, and `temp` referring to 'radiation', 'salinity' and 'temperature', respectively.

|taken|person|quant|reading|
|-----|------|-----|-------|
|619  |dyer  |rad  |9.82   |
|619  |dyer  |sal  |0.13   |
|622  |dyer  |rad  |7.8    |
|622  |dyer  |sal  |0.09   |
|734  |pb    |rad  |8.41   |
|734  |lake  |sal  |0.05   |
|734  |pb    |temp |-21.5  |
|735  |pb    |rad  |7.22   |
|735  |-null-|sal  |0.06   |
|735  |-null-|temp |-26.0  |
|751  |pb    |rad  |4.35   |
|751  |pb    |temp |-18.5  |
|751  |lake  |sal  |0.1    |
|752  |lake  |rad  |2.19   |
|752  |lake  |sal  |0.09   |
|752  |lake  |temp |-16.0  |
|752  |roe   |sal  |41.6   |
|837  |lake  |rad  |1.46   |
|837  |lake  |sal  |0.21   |
|837  |roe   |sal  |22.5   |
|844  |roe   |rad  |11.25  |

  </div>
</div>

Notice that three entries --- one in the `Visited` table,
and two in the `Survey` table --- don't contain any actual
data, but instead have a special `-null-` entry:
we'll return to these missing values
[later]({{ page.root }}{% link _episodes/05-null.md %}).


> ## Checking If Data is Available
>
> On the shell command line,
> change the working directory to the one where you saved `survey.db`.
> If you saved it at your Desktop you should use
>
> ~~~
> $ cd Desktop
> $ ls | grep survey.db
> ~~~
> {: .bash}
> ~~~
> survey.db
> ~~~
> {: .output}
>
> If you get the same output, you can run
>
> ~~~
> $ sqlite3 survey.db
> ~~~
> {: .bash}
> ~~~
> SQLite version 3.8.8 2015-01-16 12:08:06
> Enter ".help" for usage hints.
> sqlite>
> ~~~
> {: .output}
>
> that instructs SQLite to load the database in the `survey.db` file.
>
> For a list of useful system commands, enter `.help`.
>
> All SQLite-specific commands are prefixed with a `.` to distinguish them from SQL commands.
>
> Type `.tables` to list the tables in the database.
>
> ~~~
> .tables
> ~~~
> {: .sql}
> ~~~
> Person   Site     Survey   Visited
> ~~~
> {: .output}
>
> If you had the above tables, you might be curious what information was stored in each table.
> To get more information on the tables, type `.schema` to see the SQL statements used to create the tables in the database.  The statements will have a list of the columns and the data types each column stores.
> ~~~
> .schema
> ~~~
> {: .sql}
> ~~~
> CREATE TABLE Person (id text, personal text, family text);
> CREATE TABLE Site (name text, lat real, long real);
> CREATE TABLE Survey (taken integer, person text, quant text, reading real);
> CREATE TABLE Visited (id integer, site text, dated text);
> ~~~
> {: .output}
>
> The output is formatted as <**columnName** *dataType*>.  Thus we can see from the first line that the table **Person** has three columns:
> * **id** with type _text_
> * **personal** with type _text_
> * **family** with type _text_
>
> Note: The available data types vary based on the database manager - you can search online for what data types are supported.
>
> You can change some SQLite settings to make the output easier to read.
> First,
> set the output mode to display left-aligned columns.
> Then turn on the display of column headers.
>
> ~~~
> .mode column
> .header on
> ~~~
> {: .sql}
>
> To exit SQLite and return to the shell command line,
> you can use either `.quit` or `.exit`.
{: .callout}

For now,
let's write an SQL query that displays scientists' names.
We do this using the SQL command `SELECT`,
giving it the names of the columns we want and the table we want them from.
Our query and its output look like this:

~~~
SELECT family, personal FROM Person;
~~~
{: .sql}

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

The semicolon at the end of the query
tells the database manager that the query is complete and ready to run.
We have written our commands in upper case and the names for the table and columns
in lower case,
but we don't have to:
as the example below shows,
SQL is [case insensitive]({{ page.root }}{% link reference.md %}#case-insensitive).

~~~
SeLeCt FaMiLy, PeRsOnAl FrOm PeRsOn;
~~~
{: .sql}

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

You can use SQL's case insensitivity to your advantage. For instance,
some people choose to write SQL keywords (such as `SELECT` and `FROM`)
in capital letters and **field** and **table** names in lower
case. This can make it easier to locate parts of an SQL statement. For
instance, you can scan the statement, quickly locate the prominent
`FROM` keyword and know the table name follows.  Whatever casing
convention you choose, please be consistent: complex queries are hard
enough to read without the extra cognitive load of random
capitalization.  One convention is to use UPPER CASE for SQL
statements, to distinguish them from tables and column names. This is
the convention that we will use for this lesson.

While we are on the topic of SQL's syntax, one aspect of SQL's syntax
that can frustrate novices and experts alike is forgetting to finish a
command with `;` (semicolon).  When you press enter for a command
without adding the `;` to the end, it can look something like this:

~~~
SELECT id FROM Person
...>
...>
~~~
{: .sql}

This is SQL's prompt, where it is waiting for additional commands or
for a `;` to let SQL know to finish.  This is easy to fix!  Just type
`;` and press enter!

Now, going back to our query,
it's important to understand that
the rows and columns in a database table aren't actually stored in any particular order.
They will always be *displayed* in some order,
but we can control that in various ways.
For example,
we could swap the columns in the output by writing our query as:

~~~
SELECT personal, family FROM Person;
~~~
{: .sql}

|personal |family  |
|---------|--------|
|William  |Dyer    |
|Frank    |Pabodie |
|Anderson |Lake    |
|Valentina|Roerich |
|Frank    |Danforth|

or even repeat columns:

~~~
SELECT id, id, id FROM Person;
~~~
{: .sql}

|id      |id      |id      |
|--------|--------|--------|
|dyer    |dyer    |dyer    |
|pb      |pb      |pb      |
|lake    |lake    |lake    |
|roe     |roe     |roe     |
|danforth|danforth|danforth|

As a shortcut,
we can select all of the columns in a table using `*`:

~~~
SELECT * FROM Person;
~~~
{: .sql}

|id      |personal |family  |
|--------|---------|--------|
|dyer    |William  |Dyer    |
|pb      |Frank    |Pabodie |
|lake    |Anderson |Lake    |
|roe     |Valentina|Roerich |
|danforth|Frank    |Danforth|

> ## Understanding CREATE statements
>
> Use the `.schema` to identify column that contains integers.
>
> > ## Solution
> >
> > ~~~
> > .schema
> > ~~~
> > {: .sql}
> > ~~~
> > CREATE TABLE Person (id text, personal text, family text);
> > CREATE TABLE Site (name text, lat real, long real);
> > CREATE TABLE Survey (taken integer, person text, quant text, reading real);
> > CREATE TABLE Visited (id integer, site text, dated text);
> > ~~~
> > {: .output}
> > From the output, we see that the **taken** column in the **Survey** table (3rd line) is composed of integers.
> {: .solution}
{: .challenge}

> ## Selecting Site Names
>
> Write a query that selects only the `name` column from the `Site` table.
>
> > ## Solution
> >
> > ~~~
> > SELECT name FROM Site;
> > ~~~
> > {: .sql}
> >
> > |name      |
> > |----------|
> > |DR-1      |
> > |DR-3      |
> > |MSK-4     |
> {: .solution}
{: .challenge}

> ## Query Style
>
> Many people format queries as:
>
> ~~~
> SELECT personal, family FROM person;
> ~~~
> {: .sql}
>
> or as:
>
> ~~~
> select Personal, Family from PERSON;
> ~~~
> {: .sql}
>
> What style do you find easiest to read, and why?
{: .challenge}
