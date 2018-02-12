#!/usr/bin/perl

use strict;
use warnings;

################################################
#              admixture2R.pl                  #
################################################


# This script takes as input an  admixture Q result file, a plink .fam file, 
# and file cotaining sample region information and makes an R table


my $Q = $ARGV[0]; #ADMIXTURE Q result file
my $fam = $ARGV[1]; #plink .fam file associated with the plink file used as input for admixture
my $pop = $ARGV[2]; #table containing region and population information for each individual
my $out = $ARGV[3]; #output file name

chomp $out; #get rid of newline

unless (-f $Q) {
	die "\n\nYou must specify an ADMIXTURE Q result file.\n\n$Q\n\n";
}

unless (-f $fam) {
	die "\n\nYou must specify a PLINK .fam file.\n\n";
}

unless (-f $pop) {
	die "\n\nYou must specify a population and region file.\n\n";
}


open Q, "$Q"; #open the Q file

my @Q = <Q>; #save q data in array

foreach (@Q) { #get rid of newline and make sure white space is a tab
	chomp $_;
	$_ =~ s/\s/\t/g;
}

my @qline = split /\s/, $Q[0]; #split a line into elements 
my $K = scalar @qline; #number of populations inferred by ADMIXTURE


close Q; #close the file

# Put population and regional data into hashes keyed on sample ID

my %region; # ID => region
my %population; # ID => population

open POP, "$pop"; #open the population file

while (<POP>) {
	my $line = $_; #save line
	chomp $line; #get rid of newline
	my @l = split /\t/, $line; #split line into elements
	my $ID = $l[0]; #ID
	my $P = $l[3]; #population
	my $R = $l[4]; #Region
	$region{$ID} = $R; #add to region hash
	$population{$ID} = $P; #add to population hash
}

close POP;


# Make output file while reading through .fam file

open OUT, ">$out"; #open outfile to write to

my $out_header = "ID\tPOP\tREG\t";

my $i = 1; #pop incrementer
my $popheader = "Pop0"; #string containing the number

until ($i == $K) { #make the population string
	my $add = "\tPop$i";
	$popheader = $popheader.$add;
	++$i;
}

$out_header = $out_header.$popheader;

print OUT "$out_header\n";


my $counter = 0; #array placement counter for @Q

open FAM, "$fam"; #open the .fam file

while (<FAM>) { #read .fam file line by line
	my $line = $_; #save line
	chomp $line; #get rid of newline
	my @l = split /\s/, $line; #split line into elements
	my $ID = $l[1]; #second element is ID
	my $pop = $population{$ID}; #population for the sample
	my $reg = $region{$ID}; #region for the sample
	my $print = "$ID\t$pop\t$reg\t$Q[$counter]\n"; #line to add to outfile
	print OUT $print; #add to out file
	++$counter; #increment counter
}

close FAM; #close .fam file
close OUT; #close out file




exit;