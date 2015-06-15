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
>
> Check [Discussion](discussion.html) for database setup instructions

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
