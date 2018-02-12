#!/usr/bin/perl

use strict;
use warnings;

# this script first writes an R script and then executes it to create graphs of ADMIXTURE results

my $in = $ARGV[0]; #infile admixture2R.pl RTable file
my $pop = $ARGV[1]; #population information file
my $out = $ARGV[2]; #outfile

unless (-f $in) {
	die "\n\nYou must specify an R in file. Check file path.\n\n";
}

unless (-f $pop) {
	die "\n\nYou must specify a population file. Check file path.\n\n";
}

unless ($out) {
	die "\n\nYou must specify an outfile name.\n\n";
}


open IN, "$in"; #open the infile to read the header line

my $inhead = <IN>; #first line is header

close IN; #close the file

my $k = 0; #number of populations inferred by ADMIXTURE
 
while ($inhead =~ /Pop/g) { #count the number of populations in the header
	++$k; #increment k for each match
}


open POP, "$pop"; #open population file

my %pop; #population => 1, just want key to exist
my %reg; #region => 1, just want key to exist
my %r_title; #3digit => region
my %p_title; #3digit => population

while (<POP>) {
	my $line = $_; #save the line
	chomp $line; #get rid of newline
	my @l = split /\t/, $line; #split the line into elements
	my $population = $l[3]; #population
	my $region = $l[4]; #region
	unless (exists $pop{$population}) { #add key if it doesn't exist
		$pop{$population} = 1;
	}
	unless (exists $reg{$region}) { #add key if it doesn't exist
		$reg{$region} = 1;
	}
	unless (exists $r_title{$population}) { #make region title
		$r_title{$region} = $l[4];
	}
	unless (exists $p_title{$population}) { #make region title
		$p_title{$population} = $l[3];
	}
}

close POP; #close the file

my @P = keys %pop; #all populations
my @R = keys %reg; #all regions

#my @P = keys %p_title; #all populations
#my @R = keys %r_title; #all regions


#write R script for performing plots

open RSCRIPT, ">>plot.R"; #R script

print RSCRIPT "#!/usr/bin/RScript\n\n"; # R shebang

print RSCRIPT "d <- read.table(\"$in\", header=TRUE, row.names=1, stringsAsFactors=TRUE)\n\n"; #R read matrix

my $kminus = $k - 1; #number one less than k 

my $poprange = "Pop0:Pop$kminus"; #range for R matrix

#write R script for populations
foreach my $p (@P) {
	print RSCRIPT "$p <- subset(d, d\$POP==\"$p\", $poprange)\n"; # R population from matrix
}

print RSCRIPT "\n";

foreach my $r (@R) {
	print RSCRIPT "$r <- subset(d, d\$REG==\"$r\", $poprange)\n"; # R population from matrix
}

print RSCRIPT "\npdf(file=\"$out\")\n\n"; #R open pdf outfile

foreach my $p (@P) {
	print RSCRIPT "$p.plot <- barplot(t(as.matrix($p)), col=c(\"aquamarine3\", \"deeppink\", \"blue\", \"brown\", \"chartreuse\", \"darkgoldenrod1\", \"darkgreen\", \"darkorchid4\"), xlab=\"Individual \#\", ylab=\"Ancestry\", main=\"$p_title{$p}\", border=NA, , legend=names(d)[3:dim(d)[2]])\n";
}

#print RSCRIPT "dev.off()"; #R close pdf

print RSCRIPT "\n";

#print RSCRIPT "\npdf(file=\"$out.region\")\n\n"; #R open pdf outfile

foreach my $r (@R) {
	print RSCRIPT "$r.plot <- barplot(t(as.matrix($r)), col=c(\"aquamarine3\", \"deeppink\", \"blue\", \"brown\", \"chartreuse\", \"darkgoldenrod1\", \"darkgreen\", \"darkorchid4\"), xlab=\"Individual \#\", ylab=\"Ancestry\", main=\"$r_title{$r}\", border=NA, legend=names(d)[3:dim(d)[2]])\n";
}

print RSCRIPT "\ndev.off()\n"; #R close pdf


system "chmod +x plot.R"; #make executable

system "./plot.R"; #run the R script

#system "rm plot.R"; #delete the R script













exit;