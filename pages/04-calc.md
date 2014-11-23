---
layout: page
title: Databases and SQL
subtitle: Calculating New Values
minutes: 30
---
> ## Learning Objectives {.objectives}
> *   Write queries that calculate new values for each selected record.

After carefully re-reading the expedition logs,
we realize that the radiation measurements they report
may need to be corrected upward by 5%.
Rather than modifying the stored data,
we can do this calculation on the fly
as part of our query:

~~~ {.sql}
select 1.05 * reading from Survey where quant="rad";
~~~

<table>
<tr><td>10.311</td></tr>
<tr><td>8.19</td></tr>
<tr><td>8.8305</td></tr>
<tr><td>7.581</td></tr>
<tr><td>4.5675</td></tr>
<tr><td>2.2995</td></tr>
<tr><td>1.533</td></tr>
<tr><td>11.8125</td></tr>
</table>

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
select taken, round(5*(reading-32)/9, 2) from Survey where quant="temp";
~~~

<table>
<tr><td>734</td><td>-29.72</td></tr>
<tr><td>735</td><td>-32.22</td></tr>
<tr><td>751</td><td>-28.06</td></tr>
<tr><td>752</td><td>-26.67</td></tr>
</table>

We can also combine values from different fields,
for example by using the string concatenation operator `||`:

~~~ {.sql}
select personal || " " || family from Person;
~~~

<table>
<tr><td>William Dyer</td></tr>
<tr><td>Frank Pabodie</td></tr>
<tr><td>Anderson Lake</td></tr>
<tr><td>Valentina Roerich</td></tr>
<tr><td>Frank Danforth</td></tr>
</table>

> It may seem strange to use `personal` and `family` as field names
> instead of `first` and `last`,
> but it's a necessary first step toward handling cultural differences.
> For example,
> consider the following rules:
> 
> <table>
>   <tr> <th>Full Name</th> <th>Alphabetized Under</th> <th>Reason</th> </tr>
>   <tr> <td>Liu Xiaobo</td> <td>Liu</td> <td>Chinese family names come first</td> </tr>
>   <tr> <td> Leonardo da Vinci</td> <td>Leonardo</td> <td>"da Vinci" just means "from Vinci"</td> </tr>
>   <tr> <td> Catherine de Medici</td> <td>Medici</td> <td>family name</td> </tr>
>   <tr> <td> Jean de La Fontaine</td> <td>La Fontaine</td> <td>family name is "La Fontaine"</td> </tr>
>   <tr> <td> Juan Ponce de Leon</td> <td>Ponce de Leon</td> <td>full family name is "Ponce de Leon"</td> </tr>
>   <tr> <td> Gabriel Garcia Marquez</td> <td>Garcia Marquez</td> <td>double-barrelled Spanish surnames</td> </tr>
>   <tr> <td> Wernher von Braun</td> <td>von <em>or</em> Braun</td> <td>depending on whether he was in Germany or the US</td> </tr>
>   <tr> <td> Elizabeth Alexandra May Windsor</td> <td>Elizabeth</td> <td>monarchs alphabetize by the name under which they reigned</td> </tr>
>   <tr> <td> Thomas a Beckett</td> <td>Thomas</td> <td>and saints according to the names by which they were canonized</td> </tr>
> </table>
> 
> Clearly,
> even a two-part division into "personal" and "family"
> isn't enough...

> ## FIXME {.challenge}
>
> After further reading,
> we realize that Valentina Roerich
> was reporting salinity as percentages.
> Write a query that returns all of her salinity measurements
> from the `Survey` table
> with the values divided by 100.

> ## FIXME {.challenge}
>
> The `union` operator combines the results of two queries:
>
> ~~~ {.sql}
> select * from Person where ident="dyer" union select * from Person where ident="roe";
> ~~~
> 
> <table>
> <tr><td>dyer</td><td>William</td><td>Dyer</td></tr>
> <tr><td>roe</td><td>Valentina</td><td>Roerich</td></tr>
> </table>
> 
> Use `union` to create a consolidated list of salinity measurements
> in which Roerich's, and only Roerich's,
> have been corrected as described in the previous challenge.
> The output should be something like:
> 
> <table>
>   <tr> <td>619</td> <td>0.13</td> </tr>
>   <tr> <td>622</td> <td>0.09</td> </tr>
>   <tr> <td>734</td> <td>0.05</td> </tr>
>   <tr> <td>751</td> <td>0.1</td> </tr>
>   <tr> <td>752</td> <td>0.09</td> </tr>
>   <tr> <td>752</td> <td>0.416</td> </tr>
>   <tr> <td>837</td> <td>0.21</td> </tr>
>   <tr> <td>837</td> <td>0.225</td> </tr>
> </table>

> ## FIXME {.challenge}
>
> The site identifiers in the `Visited` table have two parts
> separated by a '-':
>
> ~~~ {.sql}
> select distinct site from Visited;
> ~~~
> 
> <table>
> <tr><td>DR-1</td></tr>
> <tr><td>DR-3</td></tr>
> <tr><td>MSK-4</td></tr>
> </table>
> 
> Some major site identifiers are two letters long and some are three.
> The "in string" function `instr(X, Y)`
> returns the 1-based index of the first occurrence of string Y in string X,
> or 0 if Y does not exist in X.
> The substring function `substr(X, I)`
> returns the substring of X starting at index I.
> Use these two functions to produce a list of unique major site identifiers.
> (For this data,
> the list should contain only "DR" and "MSK").
