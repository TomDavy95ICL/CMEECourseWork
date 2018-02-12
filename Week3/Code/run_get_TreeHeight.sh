#!/bin/bash env

MyData='some string'
TestData='../Data/trees.csv'
echo "Please enter path of your .csv or leave empty for tree.csv test"
read MyData

MyData=$MyData
if [[ -z $MyData ]]
then
	echo "**Using Test Data**"
	MyData=$TestData
fi

Rscript get_TreeHeight.R $MyData

#exit
