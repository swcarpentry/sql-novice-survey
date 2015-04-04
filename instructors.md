---
layout: page
title: Lesson Title
subtitle: Instructor's Guide
---
## Legend

Relational databases are not as widely used in science as in business,
but they are still a common way to store large data sets with complex structure.
Even when the data itself isn't in a database,
the metadata could be:
for example,
meteorological data might be stored in files on disk,
but data about when and where observations were made,
data ranges,
and so on could be in a database
to make it easier for scientists to find what they want to.

## Overall

*   The first few sections (up to "Missing Data") usually go very quickly.
    The pace usually slows down a bit when null values are discussed
    mostly because learners have a lot of details to keep straight by this point.
    Things *really* slow down during the discussion of joins,
    but this is the key idea in the whole lesson:
    important ideas like primary keys and referential integrity
    only make sense once learners have seen how they're used in joins.
    It's worth going over things a couple of times if necessary (with lots of examples).

*   The sections on creating and modifying data,
    and programming with databases,
    can be dropped if time is short.
    Of the two,
    people seem to care most about how to add data (which only takes a few minutes to demonstrate).

*   Simple calculations are actually easier to do in a spreadsheet;
    the advantages of using a database become clear as soon as filtering and joins are needed.
    Instructors may therefore want to show a spreadsheet with the information from the four database tables
    consolidated into a single sheet,
    and demonstrate what's needed in both systems to answer questions like,
    "What was the average radiation reading in 1931?"

*   Some advanced learners may have heard that NoSQL databases
    (i.e., ones that don't use the relational model)
    are the next big thing,
    and ask why we're not teaching those.
    The answers are:
    1.  Relational databases are far more widely used than NoSQL databases.
    2.  We have far more experience with relational databases than with any other kind,
        so we have a better idea of what to teach and how to teach it.
    3.  NoSQL databases are as different from each other as they are from relational databases.
        Until a leader emerges, it isn't clear *which* NoSQL database we should teach.

## [Selecting Data](01-select.html)

*   FIXME

## [Sorting and Removing Duplicates](02-sort-dup.html)

*   FIXME

## [Filtering](03-filter.html)

*   FIXME

## [Calculating New Values](04-calc.html)

*   FIXME

## [Missing Data](05-null.html)

*   FIXME

## [Aggregation](06-agg.html)

*   FIXME

## [Combining Data](07-join.html)

*   FIXME

## [Data Hygiene](08-hygiene.html)

*   FIXME

## [Creating and Modifying Data](09-create.html)

*   FIXME

## [Programming with Databases](10-prog.html)

*   FIXME

## Time Estimates

*   @tomwright01: 3 hours

## Resources

*   `code/gen-survey-database.sql`: re-generate survey database used in examples.
*   `code/sqlitemagic.py`: IPython Notebook plugin to handle SQLite databases.
*   `data/*.csv`: CSV versions of data in sample survey database.

## SQLite Setup

In order to execute the following lessons interactively,
please install SQLite as mentioned in the setup instructions for your workshop,
then create a directory `swc_sql`:

~~~ {.bash}
$ mkdir swc_sql
$ cd swc_sql
~~~

Next,
download the SQL file `survey.sql` from [http://files.software-carpentry.org/survey.sql](http://files.software-carpentry.org/survey.sql)
and the database file `survey.db` from [http://files.software-carpentry.org/survey.db](http://files.software-carpentry.org/survey.db)
and move both files to your `swc_sql` directory.
When you are done,
`ls` should show that they are present:

~~~ {.bash}
$ ls
survey.db    survey.sql
~~~

To test that your version of SQLite can read the database,
run this command:

~~~ {.bash}
$ sqlite3 survey.db .schema
~~~

(You *must* include the period at the start of `.schema`.)
The output should look like this:

~~~ {.bash}
CREATE TABLE Person(
       id       text,
       personal text,
       family	 text
);
CREATE TABLE Site(
       name text,
       lat  real,
       long real
);
CREATE TABLE Visited(
       id    integer,
       site  text,
       dated text
);
CREATE TABLE Survey(
       taken   integer,
       person  text,
       quant   text,
       reading real
);
~~~

If there is no output,
the most likely cause is that the database `survey.db` isn't in the directory where you're running the command.
In this case,
SQLite creates a new, empty database for you
(just as a text editor creates a new, empty document if you ask it to open a file that doesn't exist yet).

To run commands interactively,
run SQLite on `survey.db` *without* the `.schema` command:

~~~
$ sqlite3 survey.db
SQLite version 3.8.5 2014-08-15 22:37:57
Enter ".help" for usage hints.
sqlite>
~~~

As shown above,
this should give you a prompt that looks like `sqlite>`.
You can now start typing commands,
or,
as the startup line suggests,
type `.help` (again, with a period at the start) to get help.

Finally,
you can check the names and files of attached databases with the command `.databases`:

~~~ {.bash}
sqlite> .databases
seq  name             file
---  ---------------  ----------------------------------------------------------
0    main             /Users/alan_turing/swc_sql/survey.db
~~~

and check that the necessary tables "Person", "Survey", "Site" and "Visited" exist by typing:

~~~ {.bash}
sqlite> .tables
Person   Site     Survey   Visited</code></pre>
~~~

To exit SQLite and return to the Bash shell,
use `.quit`:

~~~ {.bash}
sqlite> .quit
$
~~~
