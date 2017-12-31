#!/bin/bash

#Define DB name and location here as you have it in your system. Attention: You may need to copy your Basestation.sqb into another folder. In some occasion the Basestation gets locked. This is done in the rsync line.

THEDATABASE=Basestation.sqb

cd /path/to/your/workspace
echo DB: /path/to/your/workspace/$THEDATABASE

if test -e $THEDATABASE;  then rm $THEDATABASE; fi

echo REMOVED $THEDATABASE

#Go to the Basestation.sqb location/folder to copy the "Virtual Radar instance".
cd /path/to/your/Database
/Folder/Of/TheBasestation.sqb
rsync -h --update --progress $THEDATABASE /path/to/your/Bastestation/Folder/$THEDATABASE

#Go back to your workspace
cd /path/to/workspace
BASESQBSIZE=$(wc -c <$THEDATABASE)

echo CREATED $THEDATABASE $BASESQBSIZE kb

THECSVFILE=/path/to/your/flights.csv

echo CSV File: $THECSVFILE

SQLFILE=/path/to/your/dbquerycommands.txt

echo SQL Commands: $SQLFILE
if test -e flights.csv;  then rm flights.csv; fi

echo REMOVED: $THECSVFILE

# :: allow time for the csv file to be deleted

sleep 2s

echo MERGING FLIGHTS
/usr/bin/sqlite3 "/path/to/your/workspace/$THEDATABASE" < $SQLFILE

# ::allow time for the csv to be written to file

sleep 15s

CSVSIZE=$(wc -c <$THECSVFILE)

echo CREATED $THECSVFILE $CSVSIZE kb

#
# Initiate processing of this CSV file

/usr/bin/php /var/www/html/flights/flightimport.php

echo --------------------------------------------------------------------------

exit
