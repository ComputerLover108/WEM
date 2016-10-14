#!/usr/bin/python2.7

# Converts a .MDB file (Microsoft Access) database to MySQL, copying structure and data.
# Uses the mdb-tools package.
# Under ubuntu, the following packages are required:
#   sudo apt-get install python2.7 mdbtools mysql-server mysql-client mysql-admin
# though you may also want these, if you're planning to use Python/ODBC with MySQL:
#   sudo apt-get install mysql-navigator libmdbtools libmdbodbc unixodbc python-mysqldb python-pyodbc

# What works:
#   schema copied
#   data copied
# What doesn't work:
#   indexes are not described by mdb-schema, so these must be recreated manually
#   relationships are not supported by mdb-schema, so these must be recreated manually

# We'll do this with calls to other command-line tools.
# See http://nialldonegan.me/2007/03/10/converting-microsoft-access-mdb-into-csv-or-mysql-in-linux/

# REVISED 1 Jan 2013: mdb-schema syntax has changed (-S option gone)
# SEE https://github.com/brianb/mdbtools

import sys, getpass, shlex, subprocess, re, os

def raw_default(prompt, dflt=None):
    prompt = "%s [%s]: " % (prompt, dflt)
    res = raw_input(prompt)
    if not res and dflt:
        return dflt
    return res

def get_external_command_output(command):
    args = shlex.split(command)
    ret = subprocess.check_output(args) # this needs Python 2.7 or higher
    return ret

def get_pipe_series_output(commands, stdinput=None):
    # Python arrays indexes are zero-based, i.e. an array is indexed from 0 to len(array)-1.
    # The range/xrange commands, by default, start at 0 and go to one less than the maximum specified.
    # print commands
    processes = []
    for i in xrange(len(commands)):
        if (i==0): # first processes
            processes.append( subprocess.Popen( shlex.split(commands[i]), stdin=subprocess.PIPE, stdout=subprocess.PIPE) )
        else: # subsequent ones
            processes.append( subprocess.Popen( shlex.split(commands[i]), stdin=processes[i-1].stdout, stdout=subprocess.PIPE) )
    return processes[ len(processes)-1 ].communicate(stdinput)[0] # communicate() returns a tuple; 0=stdout, 1=stderr; so this returns stdout

def replace_type_in_sql(sql, fromstr, tostr):
    whitespaceregroup = "([\ \t\n]+)"
    whitespaceorcommaregroup = "([\ \t\),\n]+)"
    rg1 = "\g<1>"
    rg2 = "\g<2>"
    return re.sub(whitespaceregroup + fromstr + whitespaceorcommaregroup, rg1 + tostr + rg2, sql, 0, re.MULTILINE | re.IGNORECASE)

if len(sys.argv) != 2:  # the program name is one of these
    sys.exit("Syntax: convert_mdb_to_mysql.py mdbfile")
mdbfile = sys.argv[1]
tempfile = raw_default("Temporary filename", "TEMP.txt")
host = raw_default("MySQL hostname", "127.0.0.1") # not "localhost"
port = raw_default("MySQL port number", 3306)
user = raw_default("MySQL username", "root")
password = getpass.getpass("MySQL password: ")
mysqldb = raw_input("MySQL database to create: ")

print "Getting list of tables"
tablecmd = "mdb-tables -1 "+mdbfile
    # -1: one per line (or table names with spaces will cause confusion)
tables = get_external_command_output(tablecmd).splitlines()
print tables

print "Creating new database"
createmysqldbcmd = "mysqladmin create %s --host=%s --port=%s --user=%s --password=%s" % (mysqldb, host, port, user, password)
    # we could omit the actual password and the user would be prompted, but we need to send it this way later (see below), so this is not a huge additional security weakness!
    # Linux/MySQL helpfully obscures the password in the "ps" list.
print get_external_command_output(createmysqldbcmd)

print "Shipping table definitions (sanitized), converted to MySQL types, through some syntax filters, to MySQL"
schemacmd="mdb-schema "+mdbfile+" mysql"

# JAN 2013: Since my previous script, mdb-schema's mysql dialect has got much better.

# Now convert the oddities that emerge:

schemasyntax = get_external_command_output(schemacmd)

# The following presupposes that no fields actually have these names (which are reserved, so they shouldn't!).
# Access data types: http://www.databasedev.co.uk/fields_datatypes.html
# An Access "Long Integer" is 4 bytes.
# There's no Access 8-byte integer (which is a BIGINT under MySQL: http://dev.mysql.com/doc/refman/5.0/en/numeric-types.html ).
#schemasyntax = replace_type_in_sql(schemasyntax, "Text", "VARCHAR")
#schemasyntax = replace_type_in_sql(schemasyntax, "Byte", "INT")
#schemasyntax = replace_type_in_sql(schemasyntax, "Long Integer", "INT")
#schemasyntax = replace_type_in_sql(schemasyntax, "Integer", "INT") # put this after "Long Integer"
#schemasyntax = replace_type_in_sql(schemasyntax, "Single", "FLOAT")
#schemasyntax = replace_type_in_sql(schemasyntax, "Double", "FLOAT")
#schemasyntax = replace_type_in_sql(schemasyntax, "Replication ID", "NUMERIC (16)")
#schemasyntax = replace_type_in_sql(schemasyntax, "DateTime \(Short\)", "DATETIME")
#schemasyntax = replace_type_in_sql(schemasyntax, "Currency", "FLOAT")
#schemasyntax = replace_type_in_sql(schemasyntax, "Boolean", "BOOLEAN") # MySQL: BOOLEAN is a synonym for TINYINT(1)
#schemasyntax = replace_type_in_sql(schemasyntax, "OLE", "VARCHAR")
#schemasyntax = replace_type_in_sql(schemasyntax, "Memo/Hyperlink", "TEXT")

#schemasyntax = re.sub("^--", "#", schemasyntax, 0, re.MULTILINE)
    # mdb-schema uses "---------" for some of its comment lines;
    # MySQL only permits "-- " (with a space) as the start of a comment, or "#": http://dev.mysql.com/doc/refman/5.0/en/ansi-diff-comments.html .
    # one of many alternatives as a pipe filter would be:
    #   "perl -pe 's/^--/#/'"
#schemasyntax = re.sub("^DROP.*$", "", schemasyntax, 0, re.MULTILINE)
    # we're creating a new database, so we don't need DROP statements, and they add to danger if the user specifies an existing database
    # an alternative as a pipe filter would be:
    #   "grep -v '^DROP'"
#schemasyntax = re.sub("([\ \t]+)group([\ \t\),]+)", "\g<1>_group\g<2>", schemasyntax, 0, re.MULTILINE | re.IGNORECASE)
    # Access allows "Group" as a table/field name; MySQL doesn't. See 
    # sed regular expressions are mostly documented in "man grep"
    # perl regular expressions: see http://www.troubleshooters.com/codecorn/littperl/perlreg.htm
    # ... or "sudo apt-get install perl-doc" then "man perl", "perldoc perlretut", and "perldoc perlrequick"
    # ... obviously, doing these replacements in python would also be an option!
    # This filter replaces "group" with "_group" in all relevant output from mdb-schema and mdb-export
    # Use \1, \2... within the SAME regexp; in a replace expression, use $1, $2...
    # In Python, best syntax for backreferences in replacement text is \g<1>, \g<2> and so on.
    # (In Perl, \1 and \2 are backreferences within the same regexp, while $1, $2 are used in replace operations.)
    # Alternative as a pipe filter would be:
    #   "perl -pe 's/([\ \t]+)group([\ \t\),]+)/$1_group$2/gi'"
    # ... no, correctly quoted as `group`, it's fine

# "COMMENT ON COLUMN" produced by mdb-schema and rejected by MySQL:
schemasyntax = re.sub("^COMMENT ON COLUMN.*$", "", schemasyntax, 0, re.MULTILINE)

print "-----------------"
print schemasyntax
print "-----------------"

mysqlcmd = "mysql --host=%s --port=%s --database=%s --user=%s --password=%s" % (host, port, mysqldb, user, password) # regrettably we need the password here, as stdin will be coming from a pipe
# print schemasyntax
print get_pipe_series_output( [mysqlcmd], schemasyntax )

# For the data, we won't store the intermediate stuff in Python's memory, 'cos it's vast; I had one odd single-character mutation
# from "TimeInSession_ms" to "TimeInSession_mc" at row 326444 (perhaps therefore 37Mb or so into a long string).
# And I was trying to export ~1m records in that table alone.
# We'll use pipes instead and let the OS deal with the memory management.

# ... BUT (Jan 2013): now mdb-tools is better, text-processing not necessary - can use temporary disk file
# Turns out the bottleneck is the import to MySQL, not the export from MDB. So see http://dev.mysql.com/doc/refman/5.5/en/optimizing-innodb-bulk-data-loading.html
# The massive improvement is by disabling autocommit. (Example source database is 208M; largest table here is 554M as a textfile; it has 1,686,075 rows.)
# This improvement was from 20 Hz to the whole database in a couple of minutes (~13 kHz).
# Subsequent export from MySQL: takes a second or two to write whole DB (177M textfile).

print "Copying data to MySQL"
#semicolonfilter = "sed -e 's/)$/)\;/'"
#groupfilter = "perl -pe 's/([\ \t]+)group([\ \t\),]+)/$1_group$2/gi'"
for t in tables:
    print "Processing table", t
    #exportcmd = "mdb-export -I mysql -D \"%Y-%m-%d %H:%M:%S\" " + mdbfile + " " + t
        # -I backend: INSERT statements, not CSV
        # -D: date format
        #     MySQL's DATETIME field has this format: "YYYY-MM-DD HH:mm:SS"
        #     so we want this from the export
    #print get_pipe_series_output( [exportcmd, semicolonfilter, groupfilter, mysqlcmd] )
    #print get_pipe_series_output( [exportcmd, mysqlcmd] )

    os.system('echo "SET autocommit=0;" > ' + tempfile)
    exportcmd = 'mdb-export -I mysql -D "%Y-%m-%d %H:%M:%S" ' + mdbfile + ' "' + t + '" >> ' + tempfile
    os.system(exportcmd)
    os.system('echo "COMMIT;" >> ' + tempfile)
    importcmd = mysqlcmd + " < " + tempfile
    os.system(importcmd)

print "Finished."

