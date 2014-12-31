#takes the csv files and turns them into a reusable database 'SWC.db'
#for use in the lesson on calling SQLite from python.

import csv, sqlite3

#set up db links
connection = sqlite3.connect("SWC.db")
cursor = connection.cursor()

#declare some tables
cursor.execute("create table if not exists Person(ident text, personal text, family text)")
cursor.execute("create table if not exists Site(name text, lat real, long real);")
cursor.execute("create table if not exists Visited(ident integer, site text, dated text);")
cursor.execute("create table if not exists Survey(taken integer, person text, quant text, reading real);")

#define table population routine:
def populate(tableName, columnNames, nCols, dbConnection):
        fileName = tableName + '.csv'

        csvReader = csv.reader(open(fileName), delimiter=',', quotechar='"')

	#build insert command, looks like "insert into mytable (x, y, z) values (?, ?, ?)"
        sql = 'insert into ' + tableName + ' ' + str(columnNames) + ' values ('
        for i in range(0, nCols):
        	sql += '?,'
        sql = sql[:-1] + ')'

        for row in csvReader:
                dbConnection.execute(sql, row)

#fill the tables
populate('person', '(ident, personal, family)', 3, connection)
populate('site', '(name, lat, long)', 3, connection)
populate('visited', '(ident, site, dated)', 3, connection)
populate('survey', '(taken, person, quant, reading)', 4, connection)

#save & quit
connection.commit()
cursor.close()
connection.close()



