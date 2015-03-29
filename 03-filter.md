---
layout: page
title: Databases and SQL
subtitle: Filtering
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Write queries that select records that satisfy user-specified conditions.
> *   Explain the order in which the clauses in a query are executed.

One of the most powerful features of a database is
the ability to [filter](reference.html#filter) data,
i.e.,
to select only those records that match certain criteria.
For example,
suppose we want to see when a particular site was visited.
We can select these records from the `Visited` table
by using a `WHERE` clause in our query:

~~~ {.sql}
SELECT * FROM Visited WHERE site='DR-1';
~~~

|ident|site|dated     |
|-----|----|----------|
|619  |DR-1|1927-02-08|
|622  |DR-1|1927-02-10|
|844  |DR-1|1932-03-22|

The database manager executes this query in two stages.
First,
it checks at each row in the `Visited` table
to see which ones satisfy the `WHERE`.
It then uses the column names following the `SELECT` keyword
to determine what columns to display.

This processing order means that
we can filter records using `WHERE`
based on values in columns that aren't then displayed:

~~~ {.sql}
SELECT ident FROM Visited WHERE site='DR-1';
~~~

|ident|
|-----|
|619  |
|622  |
|844  |

<img src="fig/sql-filter.svg" alt="SQL Filtering in Action" />

We can use many other Boolean operators to filter our data.
For example,
we can ask for all information from the DR-1 site collected before 1930:

~~~ {.sql}
SELECT * FROM Visited WHERE site='DR-1' AND dated<'1930-01-01';
~~~

|ident|site|dated     |
|-----|----|----------|
|619  |DR-1|1927-02-08|
|622  |DR-1|1927-02-10|

> ## Date types {.callout}
>
> Most database managers have a special data type for dates.
> In fact, many have two:
> one for dates,
> such as "May 31, 1971",
> and one for durations,
> such as "31 days".
> SQLite doesn't:
> instead,
> it stores dates as either text
> (in the ISO-8601 standard format "YYYY-MM-DD HH:MM:SS.SSSS"),
> real numbers
> (the number of days since November 24, 4714 BCE),
> or integers
> (the number of seconds since midnight, January 1, 1970).
> If this sounds complicated,
> it is,
> but not nearly as complicated as figuring out
> [historical dates in Sweden](http://en.wikipedia.org/wiki/Swedish_calendar).

If we want to find out what measurements were taken by either Lake or Roerich,
we can combine the tests on their names using `OR`:

~~~ {.sql}
SELECT * FROM Survey WHERE person='lake' OR person='roe';
~~~

|taken|person|quant|reading|
|-----|------|-----|-------|
|734  |lake  |sal  |0.05   |
|751  |lake  |sal  |0.1    |
|752  |lake  |rad  |2.19   |
|752  |lake  |sal  |0.09   |
|752  |lake  |temp |-16.0  |
|752  |roe   |sal  |41.6   |
|837  |lake  |rad  |1.46   |
|837  |lake  |sal  |0.21   |
|837  |roe   |sal  |22.5   |
|844  |roe   |rad  |11.25  |

Alternatively,
we can use `IN` to see if a value is in a specific set:

~~~ {.sql}
SELECT * FROM Survey WHERE person IN ('lake', 'roe');
~~~

|taken|person|quant|reading|
|-----|------|-----|-------|
|734  |lake  |sal  |0.05   |
|751  |lake  |sal  |0.1    |
|752  |lake  |rad  |2.19   |
|752  |lake  |sal  |0.09   |
|752  |lake  |temp |-16.0  |
|752  |roe   |sal  |41.6   |
|837  |lake  |rad  |1.46   |
|837  |lake  |sal  |0.21   |
|837  |roe   |sal  |22.5   |
|844  |roe   |rad  |11.25  |

We can combine `AND` with `OR`,
but we need to be careful about which operator is executed first.
If we *don't* use parentheses,
we get this:

~~~ {.sql}
SELECT * FROM Survey WHERE quant='sal' AND person='lake' OR person='roe';
~~~

|taken|person|quant|reading|
|-----|------|-----|-------|
|734  |lake  |sal  |0.05   |
|751  |lake  |sal  |0.1    |
|752  |lake  |sal  |0.09   |
|752  |roe   |sal  |41.6   |
|837  |lake  |sal  |0.21   |
|837  |roe   |sal  |22.5   |
|844  |roe   |rad  |11.25  |

which is salinity measurements by Lake,
and *any* measurement by Roerich.
We probably want this instead:

~~~ {.sql}
SELECT * FROM Survey WHERE quant='sal' AND (person='lake' OR person='roe');
~~~

|taken|person|quant|reading|
|-----|------|-----|-------|
|734  |lake  |sal  |0.05   |
|751  |lake  |sal  |0.1    |
|752  |lake  |sal  |0.09   |
|752  |roe   |sal  |41.6   |
|837  |lake  |sal  |0.21   |
|837  |roe   |sal  |22.5   |

We can also filter by partial matches.
For example,
if we want to know something just about the site names beginning with "DR" we can use the [`LIKE` keyword][LIKE].
The percent symbol acts as a [wildcard](reference.html#wildcard),
matching any characters in that place.
It can be used at the beginning, middle, or end of the string:

~~~ {.sql}
SELECT * FROM Visited WHERE site LIKE 'DR%';
~~~

|ident|site |dated     | 
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|752  |DR-3 |          |
|844  |DR-1 |1932-03-22|

There are many, many ways you can manipulate queries in SQL (selecting
only [`DISTINCT`][DISTINCT] values; aggregating with [`GROUP
BY`][GROUP-BY]; combining queries with [`UNION`][UNION]; [scaling][]
and [rounding][] numerical values; [concatenating][], [searching][],
and [slicing][] strings; etc.).  Instead of covering them all now,
we'll hit the most common ones and leave you to learn the rest when
you find yourself needing them.  Search engines are great for this
(for example "sql select unique values" will give you lots of hits
about [`DISTINCT`][DISTINCT]), and the documentation for your database
manager are also a good resource.  For example, the [`LIKE`][LIKE]
docs referenced earlier does a good job laying out the syntax and
effect of the `LIKE` operator (I found the relevant docs by asking a
search engine for "sqlite like comparison").  When the offical
documentation is too dense, you can almost always find a good blog
post or tutorial that covers a particular construct at a slower pace
and a higher level.  That will give a general framework for the idea,
and when you go back to the docs they should make more sense.

> ## Fix This Query {.challenge}
>
> Suppose we want to select all sites that lie more than 30 degrees from the poles.
> Our first query is:
>
> ~~~
> SELECT * FROM Site WHERE (lat > -60) OR (lat < 60);
> ~~~
>
> Explain why this is wrong,
> and rewrite the query so that it is correct.

> ## Finding Outliers {.challenge}
>
> Normalized salinity readings are supposed to be between 0.0 and 1.0.
> Write a query that selects all records from `Survey`
> with salinity values outside this range.

> ## Matching Patterns {.challenge}
>
> Which of these expressions are true?
>
> * `'a' LIKE 'a'`
> * `'a' LIKE '%a'`
> * `'beta' LIKE '%a'`
> * `'alpha' LIKE 'a%%'`
> * `'alpha' LIKE 'a%p%'`

[LIKE]: https://www.sqlite.org/lang_expr.html#like
[DISTINCT]: https://www.sqlite.org/lang_select.html#distinct
[GROUP-BY]: https://www.sqlite.org/lang_select.html#resultset
[UNION]: https://www.sqlite.org/lang_select.html#compound
[scaling]: https://www.sqlite.org/lang_expr.html#binaryops
[rounding]: https://www.sqlite.org/lang_corefunc.html#round
[concatenating]: https://www.sqlite.org/lang_expr.html#binaryops
[searching]: https://www.sqlite.org/lang_corefunc.html#instr
[slicing]: https://www.sqlite.org/lang_corefunc.html#substr
