---
layout: page
title: Databases and SQL
---
In the late 1920s and early 1930s,
William Dyer,
Frank Pabodie,
and Valentina Roerich led expeditions to the
[Pole of Inaccessibility](http://en.wikipedia.org/wiki/Pole_of_inaccessibility)
in the South Pacific,
and then onward to Antarctica.
Two years ago,
their expeditions were found in a storage locker at Miskatonic University.
We have scanned and [OCR][]'d the data they contain,
and we now want to store that information
in a way that will make search and analysis easy.

Three common options for storage are
text files,
spreadsheets,
and databases.
Text files are easiest to create,
and work well with version control,
but then we would have to build search and analysis tools ourselves.
Spreadsheets are good for doing simple analyses,
but they don't handle large or complex data sets well.
Databases, however, include powerful tools for search and analysis,
and can handle large, complex data sets.
These lessons will show how to use a database to explore the expeditions' data.

> ## Prerequisites {.prereq}
>
> If SQLite is being used from the shell,
> learners will need to be able to navigate directories
> and run simple commands from the command line.
> If a GUI such as the Firefox SQLite plugin is being used,
> learners will need to know how to install browser plugins
> (and have permission to do so).


> ## Getting ready {.getready}
>
> ####Step 1: Install SQLite
> You will need a working SQLite installation, as well as a set of sample files
> in order to follow this lesson. 
>
> If you are using Windows
> you will need a working shell. In our workshops, we recommend [Git Bash](https://msysgit.github.io/).
> After you've installed Git Bash, running the
> [Software Carpentry Installer](https://github.com/swcarpentry/windows-installer)
> will provide you with a working SQLite installation.
> Alternatively, if you already have a working shell, you can 
> download and install the [SQLite program](http://www.sqlite.org/download.html)
> on its own.
> SQLite comes pre-installed on Mac and Linux, so there is nothing to be done
> in this step if you use either of these operating systems.
>
> ####Step 2: Download the sample files
> 1. Make a new folder in your Desktop called `sql-novice-survey`.
> 2. Download [survey.db](http://files.software-carpentry.org/survey.db) and move the file to this folder.
> 3. You can access this folder from the Unix shell with:
>
> ~~~ {.input}
> $ cd && cd Desktop/sql-novice-survey
> ~~~
>
> ####Step 3: Start SQLite
> 1. Make sure you are in the folder where you downloaded the survey.db file
>    (see step 2 above):
>
> 	  ~~~ {.input}
>     $ ls
>     ~~~
>
>     should produce the following result:
>
>     ~~~ {.output}
>     sqlite.db
>     ~~~
> 2. Start SQLite with
>
> 	  ~~~ {.input}
>     $ sqlite3 survey.db
>     ~~~
>
>     You should get something like
>
>     ~~~ {.output}
>     SQLite version 3.8.8 2015-01-16 12:08:06
>     Enter ".help" for usage hints.
>     sqlite>
>     ~~~
>
> 3. Check that the database was properly loaded:
>
>     ~~~ {.input}
>     sqlite> .tables
>     ~~~
>
>     should produce
>
>     ~~~ {.output}
>     Person   Site     Survey   Visited
>     ~~~
>
>     If you don't see a list of tables, exit SQLite by typing `.quit` and make sure you are
>     in the folder where you've downloaded the sample database (step 2).
>
> 4. Configure SQLite for easier readabilty:
>
>     ~~~ {.input}
>     sqlite> .mode column
>     sqlite> .headers on
>     ~~~
>
> More detailed setup instructions are available in the [Discussion](discussion.html) section.


## Topics

1.  [Selecting Data](01-select.html)
2.  [Sorting and Removing Duplicates](02-sort-dup.html)
3.  [Filtering](03-filter.html)
4.  [Calculating New Values](04-calc.html)
5.  [Missing Data](05-null.html)
6.  [Aggregation](06-agg.html)
7.  [Combining Data](07-join.html)
8.  [Data Hygiene](08-hygiene.html)
9.  [Creating and Modifying Data](09-create.html)
10. [Programming with Databases](10-prog.html)

## Other Resources

*   [Reference](reference.html)
*   [Discussion](discussion.html)
*   [Instructor's Guide](instructors.html)

[OCR]: https://en.wikipedia.org/wiki/Optical_character_recognition
