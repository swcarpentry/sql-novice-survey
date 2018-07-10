---
title: "Programming with Databases - Python"
teaching: 20
exercises: 15
questions:
- "How can I access databases from programs written in Python?"
objectives:
- "Write short programs that execute SQL queries."
- "Trace the execution of a program that contains an SQL query."
- "Explain why most database applications are written in a general-purpose language rather than in SQL."
keypoints:
- "General-purpose languages have libraries for accessing databases."
- "To connect to a database, a program must use a library specific to that database manager."
- "These libraries use a connection-and-cursor model."
- "Programs can read query results in batches or all at once."
- "Queries should be written using parameter substitution, not string formatting."
---
To close,
let's have a look at how to access a database from
a general-purpose programming language like Python.
Other languages use almost exactly the same model:
library and function names may differ,
but the concepts are the same.

Here's a short Python program that selects latitudes and longitudes
from an SQLite database stored in a file called `survey.db`:

~~~
import sqlite3

connection = sqlite3.connect("survey.db")
cursor = connection.cursor()
cursor.execute("SELECT Site.lat, Site.long FROM Site;")
results = cursor.fetchall()
for r in results:
    print(r)
cursor.close()
connection.close()
~~~
{: .language-python}
~~~
(-49.85, -128.57)
(-47.15, -126.72)
(-48.87, -123.4)
~~~
{: .output}

The program starts by importing the `sqlite3` library.
If we were connecting to MySQL, DB2, or some other database,
we would import a different library,
but all of them provide the same functions,
so that the rest of our program does not have to change
(at least, not much)
if we switch from one database to another.

Line 2 establishes a connection to the database.
Since we're using SQLite,
all we need to specify is the name of the database file.
Other systems may require us to provide a username and password as well.
Line 3 then uses this connection to create a [cursor]({{ page.root }}/reference/#cursor).
Just like the cursor in an editor,
its role is to keep track of where we are in the database.

On line 4, we use that cursor to ask the database to execute a query for us.
The query is written in SQL,
and passed to `cursor.execute` as a string.
It's our job to make sure that SQL is properly formatted;
if it isn't,
or if something goes wrong when it is being executed,
the database will report an error.

The database returns the results of the query to us
in response to the `cursor.fetchall` call on line 5.
This result is a list with one entry for each record in the result set;
if we loop over that list (line 6) and print those list entries (line 7),
we can see that each one is a tuple
with one element for each field we asked for.

Finally, lines 8 and 9 close our cursor and our connection,
since the database can only keep a limited number of these open at one time.
Since establishing a connection takes time,
though,
we shouldn't open a connection,
do one operation,
then close the connection,
only to reopen it a few microseconds later to do another operation.
Instead,
it's normal to create one connection that stays open for the lifetime of the program.

Queries in real applications will often depend on values provided by users.
For example,
this function takes a user's ID as a parameter and returns their name:

~~~
import sqlite3

def get_name(database_file, person_id):
    query = "SELECT personal || ' ' || family FROM Person WHERE id='" + person_id + "';"

    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return results[0][0]

print("Full name for dyer:", get_name('survey.db', 'dyer'))
~~~
{: .language-python}
~~~
Full name for dyer: William Dyer
~~~
{: .output}

We use string concatenation on the first line of this function
to construct a query containing the user ID we have been given.
This seems simple enough,
but what happens if someone gives us this string as input?

~~~
dyer'; DROP TABLE Survey; SELECT '
~~~
{: .source}

It looks like there's garbage after the user's ID,
but it is very carefully chosen garbage.
If we insert this string into our query,
the result is:

~~~
SELECT personal || ' ' || family FROM Person WHERE id='dyer'; DROP TABLE Survey; SELECT '';
~~~
{: .language-sql}

If we execute this,
it will erase one of the tables in our database.

This is called an [SQL injection attack]({{ page.root }}/reference/#sql-injection-attack),
and it has been used to attack thousands of programs over the years.
In particular,
many web sites that take data from users insert values directly into queries
without checking them carefully first.

Since a villain might try to smuggle commands into our queries in many different ways,
the safest way to deal with this threat is
to replace characters like quotes with their escaped equivalents,
so that we can safely put whatever the user gives us inside a string.
We can do this by using a [prepared statement]({{ page.root }}/reference/#prepared-statement)
instead of formatting our statements as strings.
Here's what our example program looks like if we do this:

~~~
import sqlite3

def get_name(database_file, person_id):
    query = "SELECT personal || ' ' || family FROM Person WHERE id=?;"

    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    cursor.execute(query, [person_id])
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return results[0][0]

print("Full name for dyer:", get_name('survey.db', 'dyer'))
~~~
{: .language-python}
~~~
Full name for dyer: William Dyer
~~~
{: .output}

The key changes are in the query string and the `execute` call.
Instead of formatting the query ourselves,
we put question marks in the query template where we want to insert values.
When we call `execute`,
we provide a list
that contains as many values as there are question marks in the query.
The library matches values to question marks in order,
and translates any special characters in the values
into their escaped equivalents
so that they are safe to use.

We can also use `sqlite3`'s cursor to make changes to our database,
such as inserting a new name.
For instance, we can define a new function called `add_name` like so:

~~~
import sqlite3

def add_name(database_file, new_person):
    query = "INSERT INTO Person VALUES (?, ?, ?);"

    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    cursor.execute(query, list(new_person))
    cursor.close()
    connection.close()


def get_name(database_file, person_id):
    query = "SELECT personal || ' ' || family FROM Person WHERE id=?;"

    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    cursor.execute(query, [person_id])
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return results[0][0]

# Insert a new name
add_name('survey.db', ('barrett', 'Mary', 'Barrett'))
# Check it exists
print("Full name for barrett:", get_name('survey.db', 'barrett'))
~~~
{: .language-python}
~~~
IndexError: list index out of range
~~~
{: .output}

Note that in versions of sqlite3 >= 2.5, the `get_name` function described
above will fail with an `IndexError: list index out of range`,
even though we added Mary's
entry into the table using `add_name`.
This is because we must perform a `connection.commit()` before closing
the connection, in order to save our changes to the database.

~~~
import sqlite3

def add_name(database_file, new_person):
    query = "INSERT INTO Person VALUES (?, ?, ?);"

    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    cursor.execute(query, list(new_person))
    cursor.close()
    connection.commit()
    connection.close()


def get_name(database_file, person_id):
    query = "SELECT personal || ' ' || family FROM Person WHERE id=?;"

    connection = sqlite3.connect(database_file)
    cursor = connection.cursor()
    cursor.execute(query, [person_id])
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return results[0][0]

# Insert a new name
add_name('survey.db', ('barrett', 'Mary', 'Barrett'))
# Check it exists
print("Full name for barrett:", get_name('survey.db', 'barrett'))
~~~
{: .language-python}
~~~
Full name for barrett: Mary Barrett
~~~
{: .output}


> ## Filling a Table vs. Printing Values
>
> Write a Python program that creates a new database in a file called
> `original.db` containing a single table called `Pressure`, with a
> single field called `reading`, and inserts 100,000 random numbers
> between 10.0 and 25.0.  How long does it take this program to run?
> How long does it take to run a program that simply writes those
> random numbers to a file?
>
> > ## Solution
> > ~~~
> > import sqlite3
> > # import random number generator
> > from numpy.random import uniform
> >
> > random_numbers = uniform(low=10.0, high=25.0, size=100000)
> >
> > connection = sqlite3.connect("original.db")
> > cursor = connection.cursor()
> > cursor.execute("CREATE TABLE Pressure (reading float not null)")
> > query = "INSERT INTO Pressure values (?);"
> >
> > for number in random_numbers:
> >     cursor.execute(query, [number])
> >
> > cursor.close()
> > # save changes to file for next exercise
> > connection.commit()
> > connection.close()
> > ~~~
> > {: .language-python}
> >
> > For comparison, the following program writes the random numbers
> > into the file `random_numbers.txt`:
> >
> > ~~~
> > from numpy.random import uniform
> >
> > random_numbers = uniform(low=10.0, high=25.0, size=100000)
> > with open('random_numbers.txt', 'w') as outfile:
> >     for number in random_numbers:
> >         # need to add linebreak \n
> >         outfile.write("{}\n".format(number))
> > ~~~
> > {: .language-python}
> {: .solution}
{: .challenge}

> ## Filtering in SQL vs. Filtering in Python
>
> Write a Python program that creates a new database called
> `backup.db` with the same structure as `original.db` and copies all
> the values greater than 20.0 from `original.db` to `backup.db`.
> Which is faster: filtering values in the query, or reading
> everything into memory and filtering in Python?
>
> > ## Solution
> > The first example reads all the data into memory and filters the
> > numbers using the if statement in Python.
> >
> > ~~~
> > import sqlite3
> >
> > connection_original = sqlite3.connect("original.db")
> > cursor_original = connection_original.cursor()
> > cursor_original.execute("SELECT * FROM Pressure;")
> > results = cursor_original.fetchall()
> > cursor_original.close()
> > connection_original.close()
> >
> > connection_backup = sqlite3.connect("backup.db")
> > cursor_backup = connection_backup.cursor()
> > cursor_backup.execute("CREATE TABLE Pressure (reading float not null)")
> > query = "INSERT INTO Pressure values (?);"
> >
> > for entry in results:
> >     # number is saved in first column of the table
> >     if entry[0] > 20.0:
> >         cursor_backup.execute(query, entry)
> >
> > cursor_backup.close()
> > connection_backup.commit()
> > connection_backup.close()
> > ~~~
> > {: .language-python}
> >
> > In contrast the following example uses the conditional ``SELECT`` statement
> > to filter the numbers in SQL.
> > The only lines that changed are in line 5, where the values are fetched
> > from `original.db` and the for loop starting in line 15 used to insert
> > the numbers into `backup.db`.
> > Note how this version does not require the use of Python's if statement.
> >
> > ~~~
> > import sqlite3
> >
> > connection_original = sqlite3.connect("original.db")
> > cursor_original = connection_original.cursor()
> > cursor_original.execute("SELECT * FROM Pressure WHERE reading > 20.0;")
> > results = cursor_original.fetchall()
> > cursor_original.close()
> > connection_original.close()
> >
> > connection_backup = sqlite3.connect("backup.db")
> > cursor_backup = connection_backup.cursor()
> > cursor_backup.execute("CREATE TABLE Pressure (reading float not null)")
> > query = "INSERT INTO Pressure values (?);"
> >
> > for entry in results:
> >     cursor_backup.execute(query, entry)
> >
> > cursor_backup.close()
> > connection_backup.commit()
> > connection_backup.close()
> > ~~~
> > {: .language-python}
> >
> {: .solution}
{: .challenge}

{% include links.md %}
