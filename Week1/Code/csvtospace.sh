#!/bin/bash
# Script: csvtospace.sh
#Desc: substitute the csv in the files with spaces
      saves the output into a .ssv file
#Arguments: 1-> tab delimited file
#Date: Oct 17

echo "Creating a comma delimited version of $1 ..."

cat $1 | tr -s "," " " >> $1.ssv

echo "Done! :)"

exit
