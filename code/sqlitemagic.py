"""sqlitemagic provices a simple magic for interacting with SQLite
databases stored on disk.

Usage:

%%sqlite filename.db
select personal, family from person;

produces:

personal|family
Alan|Turing
Grace|Hopper
"""

# This file is copyright 2013 by Greg Wilson: see
# https://github.com/gvwilson/sqlitemagic/blob/master/LICENSE
# for the license.
# Inspired by https://github.com/tkf/ipython-sqlitemagic.

import sqlite3
import sys
from IPython.core.magic import Magics, magics_class, cell_magic
from IPython.display import display, HTML

@magics_class
class SqliteMagic(Magics):
    '''Provide the 'sqlite' calling point.'''

    @cell_magic
    def sqlite(self, filename, query):
        connection = sqlite3.connect(filename)
        cursor = connection.cursor()
        try:
	    if query.startswith('.'):
	        self.meta_command(cursor, query)
	    else:
                cursor.execute(query)
                results = cursor.fetchall()
                header = [f[0] for f in cursor.description]
                display(HTML(self.tablify(results, header)))
        except Exception, e:
            print >> sys.stderr, "exception", e
        cursor.close()
        connection.close()

    def tablify(self, rows, header=None):
        if header==None:
	    header_row = ''
	else:
	    header_row = self.rowify_header(header)
        return '<table>\n' + header_row + '\n'.join(self.rowify(r) for r in rows) + '\n</table>'

    def rowify(self, row):
        row = list(row)
        for i, r in enumerate(row):
            if r is None:
                row[i] = "NULL"
        return '<tr>' + ''.join('<td>' + str(r) + '</td>' for r in row) + '</tr>'

    def rowify_header(self, row):
        return '<tr>' + ''.join('<th>' + str(r) + '</th>' for r in row) + '</tr>'

    def meta_command(self, cursor, line):
        parts = line.split()
        command = parts[0]
        if command=='.schema':
	    if len(parts)>1:
	        table = parts[1]
	        select_clause = ' where name="'+table+'"'
	    else:
	        select_clause = ''
	    query = 'select sql from sqlite_master' + select_clause
	    cursor.execute(query)
            results = cursor.fetchall()
            display(HTML(self.tablify(results)))
        else:
            print >> sys.stderr, "Unsupported meta-command: ", command

def load_ipython_extension(ipython):
    ipython.register_magics(SqliteMagic)
