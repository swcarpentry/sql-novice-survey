---
title: "Missing Data"
teaching: 15
exercises: 15
questions:
- "How do databases represent missing information?"
- "What special handling does missing information require?"
objectives:
- "Explain how databases represent missing information."
- "Explain the three-valued logic databases use when manipulating missing information."
- "Write queries that handle missing information correctly."
keypoints:
- "Databases use a special value called NULL to represent missing information."
- "Almost all operations on NULL produce NULL."
- "Queries can test for NULLs using IS NULL and IS NOT NULL."
---
Real-world data is never complete --- there are always holes.
Databases represent these holes using a special value called `null`.
`null` is not zero, `False`, or the empty string;
it is a one-of-a-kind value that means "nothing here".
Dealing with `null` requires a few special tricks
and some careful thinking.

By default, SQLite does not display NULL values in its output. The `.nullvalue`
command causes SQLite to display the value you specify for NULLs. We will use
the value `-null-` to make the NULLs easier to see:

~~~
.nullvalue -null-
~~~
{: .sql}

To start,
let's have a look at the `Visited` table.
There are eight records,
but #752 doesn't have a date --- or rather,
its date is null:

~~~
SELECT * FROM Visited;
~~~
{: .sql}

|id   |site |dated     |
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|752  |DR-3 |-null-    |
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

Null doesn't behave like other values.
If we select the records that come before 1930:

~~~
SELECT * FROM Visited WHERE dated < '1930-01-01';
~~~
{: .sql}

|id   |site|dated     |
|-----|----|----------|
|619  |DR-1|1927-02-08|
|622  |DR-1|1927-02-10|

we get two results,
and if we select the ones that come during or after 1930:

~~~
SELECT * FROM Visited WHERE dated >= '1930-01-01';
~~~
{: .sql}

|id   |site |dated     |
|-----|-----|----------|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

we get five,
but record #752 isn't in either set of results.
The reason is that
`null<'1930-01-01'`
is neither true nor false:
null means, "We don't know,"
and if we don't know the value on the left side of a comparison,
we don't know whether the comparison is true or false.
Since databases represent "don't know" as null,
the value of `null<'1930-01-01'`
is actually `null`.
`null>='1930-01-01'` is also null
because we can't answer to that question either.
And since the only records kept by a `WHERE`
are those for which the test is true,
record #752 isn't included in either set of results.

Comparisons aren't the only operations that behave this way with nulls.
`1+null` is `null`,
`5*null` is `null`,
`log(null)` is `null`,
and so on.
In particular,
comparing things to null with = and != produces null:

~~~
SELECT * FROM Visited WHERE dated = NULL;
~~~
{: .sql}

produces no output, and neither does:

~~~
SELECT * FROM Visited WHERE dated != NULL;
~~~
{: .sql}

To check whether a value is `null` or not,
we must use a special test `IS NULL`:

~~~
SELECT * FROM Visited WHERE dated IS NULL;
~~~
{: .sql}

|id   |site|dated     |
|-----|----|----------|
|752  |DR-3|-null-    |

or its inverse `IS NOT NULL`:

~~~
SELECT * FROM Visited WHERE dated IS NOT NULL;
~~~
{: .sql}

|id   |site |dated     |
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

Null values can cause headaches wherever they appear.
For example,
suppose we want to find all the salinity measurements
that weren't taken by Lake.
It's natural to write the query like this:

~~~
SELECT * FROM Survey WHERE quant = 'sal' AND person != 'lake';
~~~
{: .sql}

|taken|person|quant|reading|
|-----|------|-----|-------|
|619  |dyer  |sal  |0.13   |
|622  |dyer  |sal  |0.09   |
|752  |roe   |sal  |41.6   |
|837  |roe   |sal  |22.5   |

but this query filters omits the records
where we don't know who took the measurement.
Once again,
the reason is that when `person` is `null`,
the `!=` comparison produces `null`,
so the record isn't kept in our results.
If we want to keep these records
we need to add an explicit check:

~~~
SELECT * FROM Survey WHERE quant = 'sal' AND (person != 'lake' OR person IS NULL);
~~~
{: .sql}

|taken|person|quant|reading|
|-----|------|-----|-------|
|619  |dyer  |sal  |0.13   |
|622  |dyer  |sal  |0.09   |
|735  |-null-|sal  |0.06   |
|752  |roe   |sal  |41.6   |
|837  |roe   |sal  |22.5   |

We still have to decide whether this is the right thing to do or not.
If we want to be absolutely sure that
we aren't including any measurements by Lake in our results,
we need to exclude all the records for which we don't know who did the work.

In contrast to arithmetic or Boolean operators, aggregation functions
that combine multiple values, such as `min`, `max` or `avg`, *ignore*
`null` values. In the majority of cases, this is a desirable output:
for example, unknown values are thus not affecting our data when we
are averaging it. Aggregation functions will be addressed in more
detail in [the next section]({{ page.root }}{% link _episodes/06-agg.md %}).

> ## Sorting by Known Date
>
> Write a query that sorts the records in `Visited` by date,
> omitting entries for which the date is not known
> (i.e., is null).
>
> > ## Solution
> >
> > ~~~
> > SELECT * FROM Visited WHERE dated IS NOT NULL ORDER BY dated ASC;
> > ~~~
> > {: .sql}
> >
> > |id        |site      |dated     |
> > |----------|----------|----------|
> > |619       |DR-1      |1927-02-08|
> > |622       |DR-1      |1927-02-10|
> > |734       |DR-3      |1930-01-07|
> > |735       |DR-3      |1930-01-12|
> > |751       |DR-3      |1930-02-26|
> > |837       |MSK-4     |1932-01-14|
> > |844       |DR-1      |1932-03-22|
> {: .solution}
{: .challenge}

> ## NULL in a Set
>
> What do you expect the following query to produce?
>
> ~~~
> SELECT * FROM Visited WHERE dated IN ('1927-02-08', NULL);
> ~~~
> {: .sql}
>
> What does it actually produce?
> > ## Solution
> >
> > You might expect the above query to return rows where dated is either '1927-02-08' or NULL.
> > Instead it only returns rows where dated is '1927-02-08', the same as you would get from this
> > simpler query:
> >
> > ~~~
> > SELECT * FROM Visited WHERE dated IN ('1927-02-08');
> > ~~~
> > {: .sql}
> >
> > The reason is that the `IN` operator works with a set of *values*, but NULL is by definition
> > not a value and is therefore simply ignored.
> >
> > If we wanted to actually include NULL, we would have to rewrite the query to use the IS NULL condition:
> >
> > ~~~
> > SELECT * FROM Visited WHERE dated = '1927-02-08' OR dated IS NULL;
> > ~~~
> > {: .sql}
> {: .solution}
{: .challenge}

> ## Pros and Cons of Sentinels
>
> Some database designers prefer to use
> a [sentinel value]({{ page.root }}{% link reference.md %}#sentinel-value)
> to mark missing data rather than `null`.
> For example,
> they will use the date "0000-00-00" to mark a missing date,
> or -1.0 to mark a missing salinity or radiation reading
> (since actual readings cannot be negative).
> What does this simplify?
> What burdens or risks does it introduce?
{: .challenge}
