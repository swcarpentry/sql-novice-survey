---
title: "Data Hygiene"
teaching: 15
exercises: 15
questions:
- "How should I format data in a database, and why?"
objectives:
- "Explain what an atomic value is."
- "Distinguish between atomic and non-atomic values."
- "Explain why every value in a database should be atomic."
- "Explain what a primary key is and why every record should have one."
- "Identify primary keys in database tables."
- "Explain why database entries should not contain redundant information."
- "Identify redundant information in databases."
keypoints:
- "Every value in a database should be atomic."
- "Every record should have a unique primary key."
- "A database should not contain redundant information."
- "Units and similar metadata should be stored with the data."
---

Now that we have seen how joins work, we can see why the relational
model is so useful and how best to use it.  The first rule is that
every value should be [atomic]({{ site.github.url }}/reference/#atomic), i.e., not
contain parts that we might want to work with separately.  We store
personal and family names in separate columns instead of putting the
entire name in one column so that we don't have to use substring
operations to get the name's components.  More importantly, we store
the two parts of the name separately because splitting on spaces is
unreliable: just think of a name like "Eloise St. Cyr" or "Jan Mikkel
Steubart".

The second rule is that every record should have a unique primary key.
This can be a serial number that has no intrinsic meaning,
one of the values in the record (like the `id` field in the `Person` table),
or even a combination of values:
the triple `(taken, person, quant)` from the `Survey` table uniquely identifies every measurement.

The third rule is that there should be no redundant information.
For example,
we could get rid of the `Site` table and rewrite the `Visited` table like this:

|id   |lat   |long   |dated      |
|-----|------|-------|-----------|
|619  |-49.85|-128.57| 1927-02-08|
|622  |-49.85|-128.57| 1927-02-10|
|734  |-47.15|-126.72| 1930-01-07|
|735  |-47.15|-126.72| 1930-01-12|
|751  |-47.15|-126.72| 1930-02-26|
|752  |-47.15|-126.72| -null-    |
|837  |-48.87|-123.40| 1932-01-14|
|844  |-49.85|-128.57| 1932-03-22|

In fact,
we could use a single table that recorded all the information about each reading in each row,
just as a spreadsheet would.
The problem is that it's very hard to keep data organized this way consistent:
if we realize that the date of a particular visit to a particular site is wrong,
we have to change multiple records in the database.
What's worse,
we may have to guess which records to change,
since other sites may also have been visited on that date.

The fourth rule is that the units for every value should be stored explicitly.
Our database doesn't do this,
and that's a problem:
Roerich's salinity measurements are several orders of magnitude larger than anyone else's,
but we don't know if that means she was using parts per million instead of parts per thousand,
or whether there actually was a saline anomaly at that site in 1932.

Stepping back,
data and the tools used to store it have a symbiotic relationship:
we use tables and joins because it's efficient,
provided our data is organized a certain way,
but organize our data that way because we have tools to manipulate it efficiently.
As anthropologists say,
the tool shapes the hand that shapes the tool.

> ## Identifying Atomic Values
>
> Which of the following are atomic values? Which are not? Why?
>
> *   New Zealand
> *   87 Turing Avenue
> *   January 25, 1971
> *   the XY coordinate (0.5, 3.3)
{: .challenge}

> ## Identifying a Primary Key
>
> What is the primary key in this table?
> I.e., what value or combination of values uniquely identifies a record?
>
> |latitude|longitude|date      |temperature|
> |--------|---------|----------|-----------|
> |57.3    |-22.5    |2015-01-09|-14.2      |
{: .challenge}
