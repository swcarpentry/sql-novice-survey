---
title: Setup
---

# Software

For this course you will need the UNIX shell (described in the [UNIX Shell lesson](https://swcarpentry.github.io/shell-novice/#install-software)), plus [SQLite3](https://www.sqlite.org/) or
[DB Browser for SQLite](https://sqlitebrowser.org/).

If you are running **macOS** you should already have SQLite installed. You can run `sqlite3 --version`
in a terminal to confirm that it is available. You can also download DB Browser for SQLite from
[their website](https://sqlitebrowser.org/dl/.)

If you are running **Linux**, you may already have SQLite3 installed, please use the command
`which sqlite3` to see the path of the program, otherwise you should be able to get it
from your package manager (on Debian/Ubuntu, you can use the command `apt install sqlite3`).

If you are running **Windows**, download installers and run them as administrator.
Make sure you select the right installer version for your system.
If the installer asks to add the path to the environment variables, check yes, otherwise you have to manually add the path of the executable to the `PATH` environmental variables.
This path informs the system where to find the executable program.

If installing SQLite3 using Anaconda, refer to the [anaconda sqlite docs](https://anaconda.org/anaconda/sqlite).

After the installation and the setting of the paths, close the terminal and reopen a new terminal.
This enables paths and configurations to be loaded.

# Files

Please download the database we'll be using: [survey.db](files/survey.db)


