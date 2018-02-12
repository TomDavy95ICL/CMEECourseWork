#!/usr/bin/perl

use strict;
use warnings;

#######################################################
#                        MDS.pl                       #
#     calculates MDS components using PLINK           #
#######################################################

my $inprefix = $ARGV[0];
my $out = $ARGV[1];

# Perform IBD analysis

#system "plink --bfile --noweb $inprefix --geno 0.1 --mind 0.1 --maf 0.05 --genome";
#system "plink --bfile $inprefix --geno 0.01 --mind 0.01 --maf 0.01 --genome";
system "plink --bfile --noweb $inprefix --genome";

system "cp plink.genome $out.genome";

system "rm plink.genome";

system "rm plink.nosex";

# Perform MDS analysis;

#system "plink --bfile $inprefix --geno 0.1 --mind 0.1 --maf 0.05 --read-genome $out.genome --cluster --mds-plot 4";
#system "plink --bfile $inprefix --geno 0.01 --mind 0.01 --maf 0.01 --read-genome $out.genome --cluster --mds-plot 4";
system "plink --bfile --noweb $inprefix --read-genome $out.genome --cluster --mds-plot 4";


system "cp plink.mds $out.mds";

system "rm plink.mds";


exit;
