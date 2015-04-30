---
layout: page
title: Databases and SQL
subtitle: Setting up
minutes: 15
---

### Installation

#### Windows

Download the [sqlite3 program](http://www.sqlite.org/download.html).

#### Mac OS X

<code>sqlite3</code> comes pre-installed on Mac OS X.

#### Linux

<code>sqlite3</code> comes pre-installed on Linux.

### Downloading the example database

Create a directory where you will carry out the exercises for this lesson, and
change to it using the <code>cd</code> command.

Download the file [survey.db](http://files.software-carpentry.org/survey.db) into this directory.

### Testing the installation

#### Command line

Type

    sqlite3 survey.db

Then type the SQLite command <code>.tables</code> to list the tables in the database, and this SQL command:

<code>select * from Site;</code>

Make sure to include the semi-colon **;** at the end of the statement. You should see something like the following.

    SQLite version 3.8.8 2015-01-16 12:08:06
    Enter ".help" for usage hints.
    sqlite> .tables
    Person   Site     Survey   Visited
    sqlite> select * from Site;
    DR-1|-49.85|-128.57
    DR-3|-47.15|-126.72
    MSK-4|-48.87|-123.4

You can change some SQLite settings to make the output easier to read:

    sqlite> .mode column
    sqlite> .header on
    sqlite> select * from Site;
    name        lat         long
    ----------  ----------  ----------
    DR-1        -49.85      -128.57
    DR-3        -47.15      -126.72
    MSK-4       -48.87      -123.4


#### Helpful Commands

* For a list of useful system commands, enter <code>.help</code>
* To exit sqlite and return to the shell command line, you can use either
	* <code>.quit</code> *or*
	* <code>.exit</code>
