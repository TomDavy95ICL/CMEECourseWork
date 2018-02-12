#!/bin/bash
# Author: Tom Davy [t.davy17@imperial.ac.uk]
# Script: tabtocsv.sh
# Desc: Substitute the tabs in files with commas (.tab -> .csv)
# Arguments: 1-> tab delimited file
# Date: Oct 2017

echo "Creating a comma delimited version of $1 ..."

x="$1.csv"
y=${x%%.*}
z=${y##*/}

cat $1 | tr -s "\t" "," >> ~/CMEECourseWork/Week1/Data/temp/$z.csv

echo -e "\n>>>Created $z.csv!<<<\n"

exit

