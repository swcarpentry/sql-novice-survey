---
layout: reference
---

## Glossary

{:auto_ids}
aggregation function
:   A function that combines multiple values to produce a single new value (e.g. sum, mean, median).

atomic
:   Describes a value *not* divisible into parts that one might want to
    work with separately. For example, if one wanted to work with
    first and last names separately, the values "Ada" and "Lovelace"
    would be atomic, but the value "Ada Lovelace" would not.

cascading delete
:   An [SQL](#sql) constraint requiring that if a given [record](#record) is deleted,
    all records referencing it (via [foreign key](#foreign-key)) in other [tables](#table)
    must also be deleted.

case insensitive
:   Treating text as if upper and lower case characters were the same.
    See also: [case sensitive](#case-sensitive).

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
:   One or more values in a [database table](#table) that identify
    [records](#record) in another table.

prepared statement
:   A template for an [SQL](#sql) query in which some values can be filled in.

primary key
:   One or more [fields](#fields) in a [database table](#table) whose values are
    guaranteed to be unique for each [record](#record), i.e., whose values
    uniquely identify the entry.

query
:   A textual description of a database operation. Queries are expressed in
    a special-purpose language called [SQL](#sql), and despite the name "query",
    they may modify or delete data as well as interrogate it.

record
:   A set of related values making up a single entry in a [database table](#table),
    typically shown as a row. See also: [fields](#fields).

referential integrity
:   The internal consistency of values in a database. If an entry in one table
    contains a [foreign key](#foreign-key), but the corresponding [records](#record)
    don't exist, referential integrity has been violated.

relational database
:   A collection of data organized into [tables](#table).

sentinel value
:   A value in a collection that has a special meaning, such as 999 to mean "age unknown".

SQL
:   A special-purpose language for describing operations on [relational databases](#relational-database).

SQL injection attack
:   An attack on a program in which the user's input contains malicious SQL statements.
    If this text is copied directly into an SQL statement, it will be executed in the database.

table
:   A set of data in a [relational database](#relational-database) organized into a set
    of [records](#record), each having the same named [fields](#fields).

wildcard
:   A character used in pattern matching. In SQL's `like` operator, the wildcard "%"
     matches zero or more characters, so that `%able%` matches "fixable" and "tablets".
