~#~ Week 1 README.txt ~#~
Tom Davy | Oct 2017 | t.davy17@ic.ac.uk

#~# CONTENTS #~#

1) Code

2) Tree Directory

#~#~#~#~#

1) Code

##boilerplate.sh 

~#Generic bash shell script. Standard boilerplate. -e argument of echo enables interpretation of backslashes, here /n. "/n" (more precisely "n"; the / ensures the bash terminal interprets n as an argument) forces the line to be expressed on a newline.

##CompileLateX.sh

~#Generic LateX/bibtex compilation script. Includes clauses to remove unwanted filetypes (aux / dvi / log / nav / out / snm / toc). Also includes evince, which is a pdf viewer.


##ConcatenateTwoFiles.sh

~#Generic bash script. Reads two files with cat, then exports a sequential newline concatenation to a chosen file.
	## USAGE ## 
		~# bash ConcatenateTwoFiles.sh $inputfile1 $inputfile2 $ouputfilename 

##CountLines.sh

~#Generic bash script for counting lines of file with "wc -l".
	##USAGE##
		~# bash Countlines.sh $file


##FirstBiblio.bib

~# bibtex generic reference file


##FirstExample.bbl

~# Auto-generated bbl file from LaTeX file compilation.


##FirstExample.blg

~#Auto-gen log of LaTeX generation

##FirstExample.pdf

~# pdflatex compilation output of FirstExample.tex and FirstBiblio.bib

##FirstExample.tex

~# LaTeX template. Included examples of bibtext referencing, sectioning and maths formula.

##MyExampleSccript.sh 

~# Echoes users name. Twice. Very cute. Possibly endangered.

##tabtocsv.sh

~# bash script for converting .tsv to .csv. Outputs file in same directory/folder as input file with ammended .csv file extension. Ammended using bash name arguments to firstly strip the filename of all extensions (y and z work to remove any characters after the * and before the /, inclusive). An output is then described as z.csv. Unfortunately this method currently asks for direct description of recipient directory. Though not problematic here, this is inflexible. Some fancy word-play also makes the output message more readable and the program's function obvious.


##UnixPrac1.txt
~#The 5 single line bash commands used for the bash scripting practical


##UnixPrac1_Instruct.txt
~#The 5 tasks set in the bash scripting practical

##UnixPrac1_Test.txt 
~#Testing ground/"echochamber" for sending and revising code

##variables.sh
~# bash script that summates two strings, then two integers. Demonstrates mindfulness in data type usage.

#~#~#~#~#~#~#


3)

.
├── Code
│   ├── boilerplate.sh
│   ├── CompileLaTeX.sh
│   ├── ConcatenateTwoFiles.sh
│   ├── CountLines.sh
│   ├── csvtospace.sh
│   ├── FirstBiblio.bib
│   ├── FirstExample.bbl
│   ├── FirstExample.blg
│   ├── FirstExample.pdf
│   ├── FirstExample.tex
│   ├── MyExampleScript.sh
│   ├── tabtocsv.sh
│   ├── UnixPrac1_Instruct.txt
│   ├── UnixPrac1_Test.txt
│   ├── UnixPrac1.txt
│   └── variables.sh
├── Data
│   ├── fasta
│   │   ├── 407228326.fasta
│   │   ├── 407228412.fasta
│   │   ├── ATGCtest.txt
│   │   ├── ATGCtestx3.txt
│   │   ├── echo
│   │   ├── E.coli.fasta
│   │   ├── expr
│   │   ├── F
│   │   ├── genome.txt
│   │   ├── Genome.txt
│   │   └── Help.txt
│   ├── spawannxs.txt
│   └── temp
│       ├── 1800.csv
│       ├── 1800.csv.csv
│       ├── 1800.csv.ssv
│       ├── 1801.csv
│       ├── 1801.csv.ssv
│       ├── 1801.csv.ssv.csv
│       ├── 1801test
│       ├── 1801test.csv
│       ├── 1801test.tsv
│       ├── 1802.csv
│       ├── 1802.csv.ssv
│       ├── 1803.csv
│       └── 1803.csv.ssv
├── Readme.txt
├── Sandbox
│   ├── Data
│   │   ├── fasta
│   │   │   ├── 407228326.fasta
│   │   │   ├── 407228412.fasta
│   │   │   ├── E.coli.fasta
│   │   │   ├── E.coli.Genome.txt
│   │   │   ├── F
│   │   │   └── Genome.txt
│   │   └── spawannxs.txt
│   ├── ListRootDir.txt
│   ├── TestFind
│   │   ├── Dir1
│   │   │   ├── Dir11
│   │   │   │   └── Dir111
│   │   │   │       └── File111.txt
│   │   │   ├── File1.csv
│   │   │   ├── File1.tex
│   │   │   └── File1.txt
│   │   ├── Dir2
│   │   │   ├── File2.csv
│   │   │   ├── File2.tex
│   │   │   └── File2.txt
│   │   └── Dir3
│   │       └── File3.txt
│   ├── test.txt
│   └── TestWild
│       ├── AnotherFile.csv
│       ├── AnotherFile.txt
│       ├── combined
│       ├── eva
│       │   └── VCF
│       ├── File1.csv
│       ├── File1txt
│       ├── file2.csv
│       ├── File2.txt
│       ├── file3.csv
│       ├── File3.txt
│       ├── file4.csv
│       ├── File4.txt
│       └── README
└── Workings

15 directories, 73 files

[[Printed using Tree]]
