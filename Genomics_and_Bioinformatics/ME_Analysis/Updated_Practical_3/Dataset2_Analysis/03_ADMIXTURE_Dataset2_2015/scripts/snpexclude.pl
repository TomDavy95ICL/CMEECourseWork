#!/usr/bin/perl

use strict;
use warnings;

####################################################
#                snpinclude.pl                     #
#  writes list of snps to exclude based on arg     #
####################################################





my $map = shift @ARGV; #plink map file
my @chr = @ARGV; #chromosomes to include SNPs from

unless ($map and @chr) {
	die "\n\nERROR: Not enough arguments.\n\n";
}

if (scalar @chr == 1) {
	if ($chr[0] eq "a") { #autosomes
		@chr = qw(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22);
	} elsif ($chr[0] eq "e") { #even chromosomes
		@chr = qw(2 4 6 8 10 12 14 16 18 20 22);
	} elsif ($chr[0] eq "o") { #odd chromosomes
		@chr = qw(1 3 5 7 9 11 13 15 17 19 21);
	}
}

my %in; # chr => 0 ....just want key to exist


foreach (@chr) {
	chomp $_; #get rid of newline
	unless (exists $in{$_}) { #add to hash
		$in{$_} = 0;
	}
} 

print "\nKeeping all SNPs from the following chromosomes:\n";

my @keys = sort {$a <=> $b} keys %in;

foreach (@keys) {
	print "$_\n";
}



unless (open MAP, "$map") {
	die "\n\nERROR: Cannot find plink map $map. Check file path.\n\n";
}

open OUT, ">exclude.txt"; #open a file to write to

while (<MAP>) {
	my $line = $_; #save line
	chomp $line;
	my @l = split /\t/, $line;
	my $chr = $l[0]; #chromosome
	my $snp = $l[1]; #snp
	unless (exists $in{$chr}) {
		print OUT "$snp\n";
	}
}

close OUT;





exit;