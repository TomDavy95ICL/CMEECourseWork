#!/usr/bin/perl

use strict;
use warnings;


########################################################
#  Constructs an R input file from PLINK MDS analysis  #
########################################################


my $in = $ARGV[0]; #infile path
my $pop = $ARGV[1]; #population information file
my $out = $ARGV[2]; #outfile name
chomp $out; #get rid of new line

unless ($in and $out and $pop) {
	die "\n\nYou must specify an input file, a population file and an output file name.\n\n";
}

unless (-f $in) {
	die "\n\nCannot find $in. Check file path.\n\n";
}

unless (-f $pop) {
	die "\n\nCannot find $pop. Check file path.\n\n";
}


##########################################
#  get population information in hashes  #
##########################################


open POP, "$pop"; #open pop file

my %population; # ID => population
my %region; # ID => region

while (<POP>) { #read file line by line
	my $line = $_; #save line
	chomp $line; #get rid of newline
	my @l = split /\t/, $line; #split into elements
	my $ID = $l[0]; #first element is ID
	my $P = $l[3]; #second element is population
	my $R = $l[4]; #third element is region
	$population{$ID} = $P; #add to hash
	$region{$ID} = $R; #add to hash
}

close POP; #close in file

###############################################
#  Read through infile and create outfile     #
###############################################

open IN, "$in"; #open in file to read

open OUT, ">$out"; #open out file to write to 

<IN>; #first line is header

print OUT "ID\tPOP\tREG\tC1\tC2\tC3\tC4\n"; #R table header

while (<IN>) { #read infile line by line
	my $line = $_; #save line
	chomp $line; #get rid of newline
	$line =~ s/^\s{1,}//; #get rid of any whitespace at beginning of line
	my @l = split /\s{1,}/, $line; #split into elements
	my $ID = $l[1]; # sample ID
	my $mds1 = $l[3]; #mds component 1
	my $mds2 = $l[4]; #mds component 2
	my $mds3 = $l[5]; #mds component 3
	my $mds4 = $l[6]; #mds component 4
	my $print = "$ID\t$population{$ID}\t$region{$ID}\t$mds1\t$mds2\t$mds3\t$mds4\n"; #line to print to outfile
	print OUT $print; #print to outfile
}

close IN;
close OUT;



exit;