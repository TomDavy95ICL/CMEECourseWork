#!/usr/bin/perl

use strict;
use warnings;

###########################################
#  makes a csv file in Ryan's format for  #
#   plotting admixture results            #
###########################################

my $in = $ARGV[0]; #JAH plot Rtable
my $out = $ARGV[1]; # Ryan csv outfile

unless ($in and $out) {
	die "\n\nERROR: Not enough arguments.\n\n";
}

unless (-f $in) {
	die "\n\nERROR: Cannot find $in. Check file path.\n\n";
}


open IN, "$in"; #open infile
open OUT, ">$out"; #open outfile to write to

my $header = <IN>; #first line is header

my $k = 0; #number of K from admixture results
while ($header =~ /Pop/g) {
	++$k; #increment K for each match
}

my $outheader = "iid,";

my $i = 1;
until ($i == $k + 1) {
	$outheader = $outheader."Q$i,";
	++$i;
}

$outheader = $outheader."pop,region\n";

print OUT $outheader;

while (<IN>) { #read file line by line
	my $line = $_; #save line
	chomp $line; #get rid of newline
	my @l = split /\t/, $line; #split into elements
	my $id = shift @l;
	my $pop = shift @l;
	my $reg = shift @l;
	my @k = @l;
	my $data = join ",", @k;
	my $outline = "$id,$data,$pop,$reg\n";
	print OUT $outline;
}


exit;