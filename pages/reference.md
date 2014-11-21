---
layout: page
title: Introduction to Databases and SQL
subtitle: Reference
---
## Selecting Data

*   A relational database stores information in tables,
    each of which has a fixed set of columns and a variable number of records.
*   A database manager is a program that manipulates information stored in a database.
*   We write queries in a specialized language called SQL to extract information from databases.
*   SQL is case-insensitive.

## Sorting and Removing Duplicates
 
*   The records in a database table are not intrinsically ordered:
    if we want to display them in some order,
    we must specify that explicitly.
*   The values in a database are not guaranteed to be unique:
    if we want to eliminate duplicates,
    we must specify that explicitly as well.

## Filtering

*   Use `where` to filter records according to Boolean conditions.
*   Filtering is done on whole records,
    so conditions can use fields that are not actually displayed.

## Calculating New Values

*   SQL can perform calculations using the values in a record as part of a query.

## Missing Data

*   Databases use `null` to represent missing information.
*   Any arithmetic or Boolean operation involving `null` produces `null` as a result.
*   The only operators that can safely be used with `null` are `is null` and `is not null`.

## Aggregation

*   An aggregation function combines many values to produce a single new value.
*   Aggregation functions ignore `null` values.
*   Aggregation happens after filtering.

## Combining Data

*   Every fact should be represented in a database exactly once.
*   A join produces all combinations of records from one table with records from another.
*   A primary key is a field (or set of fields) whose values uniquely identify the records in a table.
*   A foreign key is a field (or set of fields) in one table whose values are a primary key in another table.
*   We can eliminate meaningless combinations of records by matching primary keys and foreign keys between tables.
*   Keys should be atomic values to make joins simpler and more efficient.

## Creating and Modifying Data

*   Database tables are created using queries that specify their names and the names and properties of their fields.
*   Records can be inserted, updated, or deleted using queries.
*   It is simpler and safer to modify data when every record has a unique primary key.

## Programming with Databases

*   We usually write database applications in a general-purpose language, and embed SQL queries in it.

*   To connect to a database, a program must use a library specific to that database manager.

*   A program may open one or more connections to a single database, and have one or more cursors active in each.

*   Programs can read query results in batches or all at once.

## Glossary

Key Word 1
:   Definition of first term

Key Word 2
:   Definition of second term
