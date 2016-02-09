/*
Create database to be used for learners.
The data for the database are available as CSV files.

For more information: https://www.sqlite.org/cli.html#csv
*/

create table Person (ident text, personal text, family text);
create table Site (name text, lat real, long real);
create table Visited (ident text, site text, dated text);
create table Survey (taken integer, person text, quant text, reading real);
.mode csv
.import data/person.csv Person
.import data/site.csv Site
.import data/survey.csv Survey
.import data/visited.csv Visited
