#!/bin/bash


# usage: ./Analysis.sh [PLINKIN] [outfile_prefix]



PLINK=$1    # Plink file set indicated by the user
OUT=$2      # outfile prefix indicated by the user


# the following are the necessary file names needed for the various steps

FRQX=$OUT".frqx"
GENO=$OUT".geno"
OVE=$OUT"_Ob_v_Ex_het.pdf"
FPLOT=$OUT"_F.pdf"
HWE=$OUT".hwe"
HWEOUT=$OUT"_HWE_outliers.txt"
DIR=$OUT"_results"


# Make a results directory 


mkdir $DIR


# give the commands for running the analyses exactly as you would on the terminal,
# however you should replace the file names with the appropriate variables


plink --bfile $PLINK --freqx --out $OUT   #run plink to calculate genotype proportions


./scripts/frqx2geno.pl $FRQX $GENO   #convert the plink output to .geno format


Rscript ./scripts/Ob_v_Ex_het.R $GENO $OVE   # plot the observed versus expected heterozygosity


Rscript ./scripts/Moving_F.R $GENO $FPLOT      # plot the moving F values


plink --bfile $PLINK --hardy --out $OUT    # run Hardy Weinberg analysis


sort -k9 $HWE | tail -n 50 >$HWEOUT



# Move everything into the results directory

mv $FRQX $DIR
mv $GENO $DIR
mv $OVE $DIR
mv $FPLOT $DIR
mv $HWE $DIR
mv $HWEOUT $DIR
mv $OUT".log" $DIR # also save the plink log. This is the record of what you have done


# cleanup 
 
rm $OUT.nosex  #get rid of unnecessary files



