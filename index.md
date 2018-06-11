---
layout: lesson
root: .
---

In the late 1920s and early 1930s,
William Dyer,
Frank Pabodie,
and Valentina Roerich led expeditions to the
[Pole of Inaccessibility](https://en.wikipedia.org/wiki/Pole_of_inaccessibility)
in the South Pacific,
and then onward to Antarctica.
Two years ago,
their expeditions were found in a storage locker at Miskatonic University.
We have scanned and OCR the data they contain,
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

> ## Prerequisites
>
> * This lesson requires the Unix shell, plus [SQLite3](http://www.sqlite.org/) or [DB Browser for SQLite](http://sqlitebrowser.org/).
> * Please download the database we will use: [survey.db]({{ page.root }}/files/survey.db)
{: .prereq}
