---
layout: page
title: Lesson Title
subtitle: Instructor's Guide
---
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

## Time Estimates

*   @tomwright01: 3 hours

## Resources

*   `code/gen-survey-database.sql`: re-generate survey database used in examples.
*   `code/sqlitemagic.py`: IPython Notebook plugin to handle SQLite databases.
*   `data/*.csv`: CSV versions of data in sample survey database.

## SQLite Setup 

In order to do these lessons,
you will need to have the database they rely on.
To create it,
download the SQL file `code/gen-survey-database.sql` from this repository.
You can get this file without cloning this lesson's GitHub repository
by clicking on the link below and save the file to your local machine:

[https://raw.githubusercontent.com/swcarpentry/sqlite-novice-survey/gh-pages/code/gen-survey-database.sql](https://raw.githubusercontent.com/swcarpentry/sqlite-novice-survey/gh-pages/code/gen-survey-database.sql)

Once you have the file,
you can create the database `survey.db` like this:

~~~ {.bash}
$ sqlite3 survey.db < gen-survey-database.sql
~~~

In order to connect to the created database,
you need to start SQLite *from within the folder that contains the database file `survey.db`*.
To do this, type:

~~~ {.bash}
$ sqlite3 survey.db
~~~

This command opens the database itself and drops you into the database command line prompt:

~~~
SQLite version 3.7.15.2 2013-01-09 11:53:05
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite>
~~~

You can check that you are connected to the right database like this:

~~~ {.bash}
sqlite> .databases
seq  name             file                                                      
---  ---------------  ----------------------------------------------------------
0    main             ~/survey.db
~~~

(Note that the path shown under `file` will probably be different on your machine.)
You can check that the necessary tables `Person`, `Survey`, `Site` and `Visited` exist by typing:

~~~ {.bash}
sqlite> .tables
~~~

Its output should be:

~~~ {.bash}
Person   Site     Survey   Visited
~~~


## How to Exit SQLite3


To exit SQLite3, type:

~~~ {.bash}
sqlite> .quit
~~~
