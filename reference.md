---
layout: page
title: Introduction to Databases and SQL
subtitle: Reference
---
## [Selecting Data](01-select.html)

*   A relational database stores information in tables,
    each of which has a fixed set of columns and a variable number of records.
*   A database manager is a program that manipulates information stored in a database.
*   We write queries in a specialized language called SQL to extract information from databases.
*   SQL is case-insensitive.

## [Sorting and Removing Duplicates](02-sort-dup.html)

*   The records in a database table are not intrinsically ordered:
    if we want to display them in some order,
    we must specify that explicitly.
*   The values in a database are not guaranteed to be unique:
    if we want to eliminate duplicates,
    we must specify that explicitly as well.

## [Filtering](03-filter.html)

*   Use `where` to filter records according to Boolean conditions.
*   Filtering is done on whole records,
    so conditions can use fields that are not actually displayed.

## [Calculating New Values](04-calc.html)

*   SQL can perform calculations using the values in a record as part of a query.

## [Missing Data](05-null.html)

*   Databases use `null` to represent missing information.
*   Any arithmetic or Boolean operation involving `null` produces `null` as a result.
*   The only operators that can safely be used with `null` are `is null` and `is not null`.

## [Aggregation](06-agg.html)

*   An aggregation function combines many values to produce a single new value.
*   Aggregation functions ignore `null` values.
*   Aggregation happens after filtering.

## [Combining Data](07-join.html)

*   Every fact should be represented in a database exactly once.
*   A join produces all combinations of records from one table with records from another.
*   A primary key is a field (or set of fields) whose values uniquely identify the records in a table.
*   A foreign key is a field (or set of fields) in one table whose values are a primary key in another table.
*   We can eliminate meaningless combinations of records by matching primary keys and foreign keys between tables.

## [Data Hygiene](08-hygiene.html)

*   Every value in a database should be atomic.
*   Every record in a database should have a primary key.
*   Database entries should not contain redundant information.

## [Creating and Modifying Data](09-create.html)

*   Database tables are created using queries that specify their names and the names and properties of their fields.
*   Records can be inserted, updated, or deleted using queries.
*   It is simpler and safer to modify data when every record has a unique primary key.

## [Programming with Databases](10-prog.html)

*   We usually write database applications in a general-purpose language, and embed SQL queries in it.
*   To connect to a database, a program must use a library specific to that database manager.
*   A program may open one or more connections to a single database, and have one or more cursors active in each.
*   Programs can read query results in batches or all at once.

## Glossary

aggregation function
:   A function that combines multiple values to produce a single new value (e.g. sum, mean, median).

atomic
:   Describes a value *not* divisible into parts that one might want to work with separately. For example, if one wanted to work with first and last names separately, the values "Ada" and "Lovelace" would be atomic, but the value "Ada Lovelace" would not.

cascading delete
:   An [SQL](#sql) constraint requiring that if a given [record](#record) is deleted, all records referencing it (via [foreign key](#foreign-key)) in other [tables](#table) must also be deleted.

case insensitive
:   Treating text as if upper and lower case characters were the same. See also: [case sensitive](#case-sensitive).

case sensitive
:   Treating upper and lower case characters as different. See also: [case insensitive](#case-insensitive).

comma-separated values (CSV)
:   A common textual representation for tables in which the values in each row are separated by commas.

cross product
:   A pairing of all elements of one set with all elements of another.

cursor
:   A pointer into a database that keeps track of outstanding operations.

database manager
:   A program that manages a database, such as SQLite.

fields
:   A set of data values of a particular type, one for each [record](#record) in a [table](#table).

filter
:   To select only the records that meet certain conditions.

foreign key
:   One or more values in a [database table](#table-database) that identify a [records](#record-database) in another table.

prepared statement
:   A template for an [SQL](#sql) query in which some values can be filled in.

primary key
:   One or more [fields](#field) in a [database table](#table) whose values are guaranteed to be unique for each [record](#record), i.e., whose values uniquely identify the entry.

query
:   A textual desscription of a database operation. Queries are expressed in a special-purpose language called [SQL](#sql), and despite the name "query", they may modify or delete data as well as interrogate it.

record
:   A set of related values making up a single entry in a [database table](#table), typically shown as a row. See also: [field](#field).

referential integrity
:   The internal consistency of values in a database. If an entry in one table contains a [foreign key](#foreign-key), but the corresponding [records](#record) don't exist, referential integrity has been violated.

relational database
:   A collection of data organized into [tables](#table).

sentinel value
:   A value in a collection that has a special meaning, such as 999 to mean "age unknown".

SQL
:   A special-purpose language for describing operations on [relational databases](#relational-database).

SQL injection attack
:   An attack on a program in which the user's input contains malicious SQL statements. If this text is copied directly into an SQL statement, it will be executed in the database.

table
:   A set of data in a [relational database](#relational-database) organized into a set of [records](#record), each having the same named [fields](#field).

wildcard
:   A character used in pattern matching. In SQL's `like` operator, the wildcard "%" matches zero or more characters, so that `%able%` matches "fixable" and "tablets".
