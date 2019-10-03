### Makefile
### A simple Makefile to automate common tasks in the project.
###
### Author: Nathan Campos <nathanpc@dreamintech.net>

# General definitions.
PROJECT = package-wait
RM = rm -f
SQLITE = sqlite3
MANAGER = ./manage_data.pl

# Directories.
DATADIR = data

# Important files.
DATABASE = $(DATADIR)/database.db

#all: $(PROJECT)

init: $(DATABASE)
	$(MANAGER) -i --csv data/raw-2019-10-02.csv

sqlite: $(DATABASE)
	$(SQLITE) $(DATABASE)

$(DATABASE):
	sqlite3 $(DATABASE) < build_database.sql

clean:
	$(RM) $(DATABASE)

