---
title: "Aggregation"
teaching: 10
exercises: 10
questions:
- "How can I calculate sums, averages, and other summary values?"
objectives:
- "Define aggregation and give examples of its use."
- "Write queries that compute aggregated values."
- "Trace the execution of a query that performs aggregation."
- "Explain how missing data is handled during aggregation."
keypoints:
- "Use aggregation functions to combine multiple values."
- "Aggregation functions ignore `null` values."
- "Aggregation happens after filtering."
- "Use GROUP BY to combine subsets separately."
- "If no aggregation function is specified for a field, the query may return an arbitrary value for that field."
---
We now want to calculate ranges and averages for our data.
We know how to select all of the dates from the `Visited` table:

~~~
SELECT dated FROM Visited;
~~~
{: .sql}

|dated     |
|----------|
|1927-02-08|
|1927-02-10|
|1930-01-07|
|1930-01-12|
|1930-02-26|
|-null-    |
|1932-01-14|
|1932-03-22|

but to combine them,
we must use an [aggregation function]({{ page.root }}{% link reference.md %}#aggregation-function)
such as `min` or `max`.
Each of these functions takes a set of records as input,
and produces a single record as output:

~~~
SELECT min(dated) FROM Visited;
~~~
{: .sql}

|min(dated)|
|----------|
|1927-02-08|

![SQL Aggregation](../fig/sql-aggregation.svg)

~~~
SELECT max(dated) FROM Visited;
~~~
{: .sql}

|max(dated)|
|----------|
|1932-03-22|

`min` and `max` are just two of
the aggregation functions built into SQL.
Three others are `avg`,
`count`,
and `sum`:

~~~
SELECT avg(reading) FROM Survey WHERE quant = 'sal';
~~~
{: .sql}

|avg(reading)    |
|----------------|
|7.20333333333333|

~~~
SELECT count(reading) FROM Survey WHERE quant = 'sal';
~~~
{: .sql}

|count(reading)|
|--------------|
|9             |

~~~
SELECT sum(reading) FROM Survey WHERE quant = 'sal';
~~~
{: .sql}

|sum(reading)|
|------------|
|64.83       |

We used `count(reading)` here,
but we could just as easily have counted `quant`
or any other field in the table,
or even used `count(*)`,
since the function doesn't care about the values themselves,
just how many values there are.

SQL lets us do several aggregations at once.
We can,
for example,
find the range of sensible salinity measurements:

~~~
SELECT min(reading), max(reading) FROM Survey WHERE quant = 'sal' AND reading <= 1.0;
~~~
{: .sql}

|min(reading)|max(reading)|
|------------|------------|
|0.05        |0.21        |

We can also combine aggregated results with raw results,
although the output might surprise you:

~~~
SELECT person, count(*) FROM Survey WHERE quant = 'sal' AND reading <= 1.0;
~~~
{: .sql}

|person|count(\*)|
|------|--------|
|lake  |7       |

Why does Lake's name appear rather than Roerich's or Dyer's?
The answer is that when it has to aggregate a field,
but isn't told how to,
the database manager chooses an actual value from the input set.
It might use the first one processed,
the last one,
or something else entirely.

Another important fact is that when there are no values to aggregate ---
for example, where there are no rows satisfying the `WHERE` clause ---
aggregation's result is "don't know"
rather than zero or some other arbitrary value:

~~~
SELECT person, max(reading), sum(reading) FROM Survey WHERE quant = 'missing';
~~~
{: .sql}

|person|max(reading)|sum(reading)|
|------|------------|------------|
|-null-|-null-      |-null-      |

One final important feature of aggregation functions is that
they are inconsistent with the rest of SQL in a very useful way.
If we add two values,
and one of them is null,
the result is null.
By extension,
if we use `sum` to add all the values in a set,
and any of those values are null,
the result should also be null.
It's much more useful,
though,
for aggregation functions to ignore null values
and only combine those that are non-null.
This behavior lets us write our queries as:

~~~
SELECT min(dated) FROM Visited;
~~~
{: .sql}

|min(dated)|
|----------|
|1927-02-08|

instead of always having to filter explicitly:

~~~
SELECT min(dated) FROM Visited WHERE dated IS NOT NULL;
~~~
{: .sql}

|min(dated)|
|----------|
|1927-02-08|

Aggregating all records at once doesn't always make sense.
For example,
suppose we suspect that there is a systematic bias in our data,
and that some scientists' radiation readings are higher than others.
We know that this doesn't work:

~~~
SELECT person, count(reading), round(avg(reading), 2)
FROM  Survey
WHERE quant = 'rad';
~~~
{: .sql}

|person|count(reading)|round(avg(reading), 2)|
|------|--------------|----------------------|
|roe   |8             |6.56                  |

because the database manager selects a single arbitrary scientist's name
rather than aggregating separately for each scientist.
Since there are only five scientists,
we could write five queries of the form:

~~~
SELECT person, count(reading), round(avg(reading), 2)
FROM  Survey
WHERE quant = 'rad'
AND   person = 'dyer';
~~~
{: .sql}

person|count(reading)|round(avg(reading), 2)|
------|--------------|----------------------|
dyer  |2             |8.81                  |

but this would be tedious,
and if we ever had a data set with fifty or five hundred scientists,
the chances of us getting all of those queries right is small.

What we need to do is
tell the database manager to aggregate the hours for each scientist separately
using a `GROUP BY` clause:

~~~
SELECT   person, count(reading), round(avg(reading), 2)
FROM     Survey
WHERE    quant = 'rad'
GROUP BY person;
~~~
{: .sql}

person|count(reading)|round(avg(reading), 2)|
------|--------------|----------------------|
dyer  |2             |8.81                  |
lake  |2             |1.82                  |
pb    |3             |6.66                  |
roe   |1             |11.25                 |

`GROUP BY` does exactly what its name implies:
groups all the records with the same value for the specified field together
so that aggregation can process each batch separately.
Since all the records in each batch have the same value for `person`,
it no longer matters that the database manager
is picking an arbitrary one to display
alongside the aggregated `reading` values.

Just as we can sort by multiple criteria at once,
we can also group by multiple criteria.
To get the average reading by scientist and quantity measured,
for example,
we just add another field to the `GROUP BY` clause:

~~~
SELECT   person, quant, count(reading), round(avg(reading), 2)
FROM     Survey
GROUP BY person, quant;
~~~
{: .sql}

|person|quant|count(reading)|round(avg(reading), 2)|
|------|-----|--------------|----------------------|
|-null-|sal  |1             |0.06                  |
|-null-|temp |1             |-26.0                 |
|dyer  |rad  |2             |8.81                  |
|dyer  |sal  |2             |0.11                  |
|lake  |rad  |2             |1.82                  |
|lake  |sal  |4             |0.11                  |
|lake  |temp |1             |-16.0                 |
|pb    |rad  |3             |6.66                  |
|pb    |temp |2             |-20.0                 |
|roe   |rad  |1             |11.25                 |
|roe   |sal  |2             |32.05                 |

Note that we have added `quant` to the list of fields displayed,
since the results wouldn't make much sense otherwise.

Let's go one step further and remove all the entries
where we don't know who took the measurement:

~~~
SELECT   person, quant, count(reading), round(avg(reading), 2)
FROM     Survey
WHERE    person IS NOT NULL
GROUP BY person, quant
ORDER BY person, quant;
~~~
{: .sql}

|person|quant|count(reading)|round(avg(reading), 2)|
|------|-----|--------------|----------------------|
|dyer  |rad  |2             |8.81                  |
|dyer  |sal  |2             |0.11                  |
|lake  |rad  |2             |1.82                  |
|lake  |sal  |4             |0.11                  |
|lake  |temp |1             |-16.0                 |
|pb    |rad  |3             |6.66                  |
|pb    |temp |2             |-20.0                 |
|roe   |rad  |1             |11.25                 |
|roe   |sal  |2             |32.05                 |

Looking more closely,
this query:

1.  selected records from the `Survey` table
    where the `person` field was not null;

2.  grouped those records into subsets
    so that the `person` and `quant` values in each subset
    were the same;

3.  ordered those subsets first by `person`,
    and then within each sub-group by `quant`;
    and

4.  counted the number of records in each subset,
    calculated the average `reading` in each,
    and chose a `person` and `quant` value from each
    (it doesn't matter which ones,
    since they're all equal).

> ## Counting Temperature Readings
>
> How many temperature readings did Frank Pabodie record,
> and what was their average value?
>
> > ## Solution
> >
> > ~~~
> > SELECT count(reading), avg(reading) FROM Survey WHERE quant = 'temp' AND person = 'pb';
> > ~~~
> > {: .sql}
> >
> > |count(reading)|avg(reading)|
> > |--------------|------------|
> > |2             |-20.0       |
> {: .solution}
{: .challenge}

> ## Averaging with NULL
>
> The average of a set of values is the sum of the values
> divided by the number of values.
> Does this mean that the `avg` function returns 2.0 or 3.0
> when given the values 1.0, `null`, and 5.0?
>
> > ## Solution
> > The answer is 3.0.
> > `NULL` is not a value; it is the absence of a value.
> > As such it is not included in the calculation.
> >
> > You can confirm this, by executing this code:
> > ```
> > SELECT AVG(a) FROM (
> >     SELECT 1 AS a
> >     UNION ALL SELECT NULL
> >     UNION ALL SELECT 5);
> > ```
> > {: .sql}
> {: .solution}
{: .challenge}

> ## What Does This Query Do?
>
> We want to calculate the difference between
> each individual radiation reading
> and the average of all the radiation readings.
> We write the query:
>
> ~~~
> SELECT reading - avg(reading) FROM Survey WHERE quant = 'rad';
> ~~~
> {: .sql}
>
> What does this actually produce, and can you think of why?
>
> > ## Solution
> > The query produces only one row of results when we what we really want is a result for each of the readings.
> > The `avg()` function produces only a single value, and because it is run first, the table is reduced to a single row.
> > The `reading` value is simply an arbitrary one.
> >
> > To achieve what we wanted, we would have to run two queries:
> >
> > ~~~
> > SELECT avg(reading) FROM Survey WHERE quant='rad';
> > ~~~
> > {: .sql}
> >
> > This produces the average value (6.5625), which we can then insert into a second query:
> >
> > ~~~
> > SELECT reading - 6.5625 FROM Survey WHERE quant = 'rad';
> > ~~~
> > {: .sql}
> >
> > This produces what we want, but we can combine this into a single query using subqueries.
> >
> > ~~~
> > SELECT reading - (SELECT avg(reading) FROM Survey WHERE quant='rad') FROM Survey WHERE quant = 'rad';
> > ~~~
> > {: .sql}
> >
> > This way we don't have execute two queries.
> >
> > In summary what we have done is to replace `avg(reading)` with `(SELECT avg(reading) FROM Survey WHERE quant='rad')` in the original query.
> >
> {: .solution}
{: .challenge}

> ## Ordering When Concatenating
>
> The function `group_concat(field, separator)`
> concatenates all the values in a field
> using the specified separator character
> (or ',' if the separator isn't specified).
> Use this to produce a one-line list of scientists' names,
> such as:
>
> ~~~
> William Dyer, Frank Pabodie, Anderson Lake, Valentina Roerich, Frank Danforth
> ~~~
> {: .sql}
>
> Can you find a way to order the list by surname?
{: .challenge}
