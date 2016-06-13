---
layout: page
title: Databases and SQL
subtitle: Calculating New Values
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Write queries that calculate new values for each selected record.

After carefully re-reading the expedition logs,
we realize that the radiation measurements they report
may need to be corrected upward by 5%.
Rather than modifying the stored data,
we can do this calculation on the fly
as part of our query:

~~~ {.sql}
SELECT 1.05 * reading FROM Survey WHERE quant='rad';
~~~

|1.05 * reading|
|--------------|
|10.311        |
|8.19          |
|8.8305        |
|7.581         |
|4.5675        |
|2.2995        |
|1.533         |
|11.8125       |

When we run the query,
the expression `1.05 * reading` is evaluated for each row.
Expressions can use any of the fields,
all of usual arithmetic operators,
and a variety of common functions.
(Exactly which ones depends on which database manager is being used.)
For example,
we can convert temperature readings from Fahrenheit to Celsius
and round to two decimal places:

~~~ {.sql}
SELECT taken, round(5*(reading-32)/9, 2) FROM Survey WHERE quant='temp';
~~~

|taken|round(5\*(reading-32)/9, 2)|
|-----|---------------------------|
|734  |-29.72                     |
|735  |-32.22                     |
|751  |-28.06                     |
|752  |-26.67                     |

As you can see from this example, though, the string describing our new field (generated from the equation) can become quite unwieldy. SQL allows us to rename our fields, any field for that matter, whether it was calculated or one of the existing fields in our database, for succinctness and clarity. For example, we could write the previous query as: 

~~~ {.sql}
SELECT taken, round(5*(reading-32)/9, 2) as Celsius FROM Survey WHERE quant='temp';
~~~

|taken|Celsius|
|-----|-------|
|734  |-29.72 |
|735  |-32.22 |
|751  |-28.06 |
|752  |-26.67 |

We can also combine values from different fields,
for example by using the string concatenation operator `||`:

~~~ {.sql}
SELECT personal || ' ' || family FROM Person;
~~~

|personal || ' ' || family|
|-------------------------|
|William Dyer             |
|Frank Pabodie            |
|Anderson Lake            |
|Valentina Roerich        |
|Frank Danforth           |

> ## Fixing Salinity Readings {.challenge}
>
> After further reading,
> we realize that Valentina Roerich
> was reporting salinity as percentages.
> Write a query that returns all of her salinity measurements
> from the `Survey` table
> with the values divided by 100.

> ## Unions {.challenge}
>
> The `UNION` operator combines the results of two queries:
>
> ~~~ {.sql}
> SELECT * FROM Person WHERE id='dyer' UNION SELECT * FROM Person WHERE id='roe';
> ~~~
>
> |id  |personal |family |
> |----|-------- |-------|
> |dyer|William  |Dyer   |
> |roe |Valentina|Roerich|
>
> Use `UNION` to create a consolidated list of salinity measurements
> in which Roerich's, and only Roerich's,
> have been corrected as described in the previous challenge.
> The output should be something like:
>
> |taken|reading|
> |-----|-------|
> |619  |0.13   |
> |622  |0.09   |
> |734  |0.05   |
> |751  |0.1    |
> |752  |0.09   |
> |752  |0.416  |
> |837  |0.21   |
> |837  |0.225  |

> ## Selecting Major Site Identifiers {.challenge}
>
> The site identifiers in the `Visited` table have two parts
> separated by a '-':
>
> ~~~ {.sql}
> SELECT DISTINCT site FROM Visited;
> ~~~
>
> |site |
> |-----|
> |DR-1 |
> |DR-3 |
> |MSK-4|
>
> Some major site identifiers are two letters long and some are three.
> The "in string" function `instr(X, Y)`
> returns the 1-based index of the first occurrence of string Y in string X,
> or 0 if Y does not exist in X.
> The substring function `substr(X, I, [L])`
> returns the substring of X starting at index I, with an optional length L.
> Use these two functions to produce a list of unique major site identifiers.
> (For this data,
> the list should contain only "DR" and "MSK").
