#!/usr/bin/perl

use strict;
use warnings;


#################################################
#      Runs admixture cross validation          #
#################################################


my $in = $ARGV[0]; #input plink file
my $k_range = $ARGV[1]; #range of K values to check

