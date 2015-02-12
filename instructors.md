---
layout: page
title: Lesson Title
subtitle: Instructor's Guide
---
## Legend

FIXME

## Overall

*   FIXME

## [Selecting Data](01-select.html)

## [Sorting and Removing Duplicates](02-sort-dup.html)

## [Filtering](03-filter.html)

## [Calculating New Values](04-calc.html)

## [Missing Data](05-null.html)

## [Aggregation](06-agg.html)

## [Combining Data](07-join.html)

## [Data Hygiene](08-hygiene.html)

## [Creating and Modifying Data](09-create.html)

## [Programming with Databases](10-prog.html)

----------------------------------------

## Time Estimates

*   @tomwright01: 3 hours

## Resources

*   `code/gen-survey-database.sql`: re-generate survey database used in examples.
*   `code/sqlitemagic.py`: IPython Notebook plugin to handle SQLite databases.
*   `data/*.csv`: CSV versions of data in sample survey database.

## Notes

*   Run `sqlite3 survey.db < gen-survey-database.sql` to re-create
    survey database before loading notebooks.

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
       ident    text,
       personal text,
       family	 text
);
CREATE TABLE Site(
       name text,
       lat  real,
       long real
);
CREATE TABLE Visited(
       ident integer,
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
