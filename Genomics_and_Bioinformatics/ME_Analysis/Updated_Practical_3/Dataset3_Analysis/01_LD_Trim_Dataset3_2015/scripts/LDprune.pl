#!/usr/bin/perl

use strict;
use warnings;

##################################################
# This prunes SNPs according to LD using Plink   #
##################################################

my $in = $ARGV[0]; #input file prefix to be pruned
my $out = $ARGV[1]; #output file name
my $percent = $ARGV[2]; #percentage of pruned SNPs to randomly select for PCA analysis
chomp $percent; #get rid of newline

unless (-f "$in.bed") { #check input file
	die "\n\nYou must specify an input file. Check file path.\n\n";
}

##################################################
#      Call Plink to perform LD-pruning          #
##################################################


my $file = "--bfile $in"; #input file prefix
my $missing = "--missing-genotype N"; #missing genotype indicator
my $LDprune = "--indep-pairwise 50 5 0.5"; #command for LD based pruning
my $extract = "--extract plink.prune.in"; #command for extracting SNPs
my $thin = "--thin $percent"; #command for percentage of SNPs to randomly retain
my $sex = "--allow-no-sex"; #no sex allowed!!!!
my $missing_SNP = "--geno 0.05";
my $missing_ind = "--mind 0.1";
my $noweb = "--noweb";

system "plink $file $noweb $missing $sex $missing_SNP $missing_ind $LDprune"; #call plink to calculate SNPs to prune

if ($percent < 1 and $percent > 0) {
	system "plink $file $noweb $missing $sex $extract $thin --make-bed"; #call plink to extract pruned SNPs and randomly thin to specified percent
} else {
	system "plink $file $noweb $missing $sex $extract --make-bed";
}
#rename plink output files according to user specification

system "cp plink.bed $out.bed";
system "rm plink.bed";

system "cp plink.fam $out.fam";
system "rm plink.fam";

system "cp plink.bim $out.bim";
system "rm plink.bim";

system "cp plink.log $out.log";
system "rm plink.log";

system "cp plink.prune.in $out.prune.in";
system "rm plink.prune.in";

system "cp plink.prune.out $out.prune.out";
system "rm plink.prune.out";

system "rm plink.nosex";





#################################################
#
#################################################











exit;