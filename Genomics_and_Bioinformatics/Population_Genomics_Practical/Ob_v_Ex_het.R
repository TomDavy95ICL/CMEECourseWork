#!/usr/local/bin RScript

# A script that outputs a plot of the observed versus 
# expected heterozygosity as a .pdf file


cargs <- commandArgs(T)
if (length(cargs) < 2) stop("not enough arguments")
if (length(cargs) > 2) stop("too many arguments")

infile <- cargs[1] # input data file name
outfile <- cargs[2] # output file name

require(methods)
require(dplyr)
require(ggplot2)
require(reshape2)

g<-read.table(file=infile, header=TRUE)
head(g)

#Using mutate from dplyr: summing the possible genotypes in one step (colSums would also work in base)
g<-mutate(g, nObs = nA1A1 + nA1A2 + nA2A2)
head(g)

# summary(g$nObs)

# quick 'qplot' plot of nObs:
# 
# qplot(nObs, data=g)

# Some observations are less than the expected 938 individuals genotypes. This is due to statisical base calling errors.
# e.g. the lowest count is 887, or 94.6% of the total number of expected genotypes.
# With the filter set to a missing rate of 1.5%, this is higher than expected.



## Calculating genotype and allele frequencies.

# Compute genotype frequencies
g<-mutate(g, p11=nA1A1/nObs, p12=nA1A2/nObs, p22=nA2A2/nObs)

# Compute allele frequencies from genotype frequencies
g<-mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)
head(g)

# Plot the frequency of the major Allele (A2) vs the frequency of the minor allele (A1).
# qplot(p1, p2, data=g)


# Plotting genotype on allele frequencies
# To use ggplot2 tidy, date must be 'tidy' (one row per pairs of points we will plot)
# To do this we require a subset melt.

gTidy<-select(g, c(p1,p11,p12,p22)) %>%
  melt(id='p1',value.name="Genotype.Proportion")

# head(gTidy)
# dim(gTidy)

# Plot

# ggplot(gTidy) + geom_point(aes(x=p1,
#                                y = Genotype.Proportion,
#                                color=variable,
#                                shape=variable))

# Addition of Hardy-Weinbery Proportions:

# ggplot(gTidy)+ geom_point(aes(x=p1,y=Genotype.Proportion, color=variable,shape=variable))+ stat_function(fun=function(p) p^2, geom="line", colour="red",size=2.5) + stat_function(fun=function(p) 2*p*(1-p), geom="line", colour="green",size=2.5) + stat_function(fun=function(p) (1-p)^2, geom="line", colour="blue",size=2.5)

# Testing Hardy Weinberg. Pearson's Chi-squared test. Using pchisq function.
# Herein there is one degree of freedom (3 obs per SNP, but sum to a single total sample size)
# We have to use the data once to get the estimated allele frequency, which reduces us down to 1 d.f.

g<-mutate(g, X2=(nA1A1-nObs*p1^2)^2 / (nObs*p1^2) + (nA1A2-nObs*2*p1*p2)^2/(nObs*2*p1*p2)+(nA2A2-nObs*p2^2)^2/(nObs*p2^2)^2/(nObs*p2^2))

# addition of p-value between expected and observed

g<-mutate(g,pval=1-pchisq(X2,1))
# head(g$pval)

# reminder: "a p-value gives us the frequency at which that the observed departure from expectations would occur if the null hypothesis is true.
# If data are relatively rare under the null, we reject the null and hence infer a departure from H-W expectations
# # This is problematic in this context: With the high amount of SNPs we are analyzing, if the null is universally true, 5% of SNPs would be expected to be rejected using the standard frequentists paradigm
# See: The Multiple Testing Problem
# To deal with the MTP: There are two frameworks
# The Bonferonni approach & The false-discovery-rate (FDR) approach.
# Herein we will do a simple check to see if our data are globally consistent with the null.

# Let's see how many tests have p-values less than 0.05. Is it larger than expected?

# sum(g$pval < 0.05, na.rm=TRUE)

# = 13944 of 19560. Clearly far higher, suggesting a departure from H-W equilibrium.

# Another visualisation:  Fisher states that under null hypothesis, well designed test should be distributed uniformly from 0 to 1.

# qplot(pval, data=g)

# An enrichment towards low p-values relative to normal distribution! A systematic departure from H-W!.


# # Plotting expected vs Observed heterozygosity:

# Let's qplot exp vs obs Hz:

Ob_v_Ex<-qplot(2*p1*(1-p1), p12, data=g) + geom_abline(intercept=0, slope=1, color="red", size=1.5)

pdf(outfile)
print(Ob_v_Ex)
dev.off()

# i.e. plotting 2pq vs 2*p1*q1. An excess of homozygosity.

# To interpret, consider Sewall Wright's 'Correlation of uniting gametes'.
# To produce an A1A1, we need an A1 bearing sperm & A1 bearing egg.
# If these events are independent of eachother, we would expect A1A1 at predicted rate p1^2.
# However, what if unifying gametes are positively correlated, that is an A-bearing sperm is more fertile with an A-bearing egg.
# Hence we will have more A1A1 and less A1A2 than predicted. If pop structure allows this
# Then we will have an excess of homo, defic. of hetero.

# Local assortive mating explains this. A1s are more likely to meet A1s.


# Compute the average deficiencies of Hz relatice to expected proportion.

# Hz relative to Expected
# 
# g<-mutate(g, AvgHzDef = mean((2*g$p1*(1-g$p1)-g$p12) / (2*g$p1*(1-g$p1))
#                              
#                              # A common rule of thumb is 10% for global human sample. This is approximate.
#                              
#                              # It is a reiminder that human populations are not very structured. Most alleles are globally spread
#                              # and not very deeply structured to make allele correlations.
#                              
#                              
#                              # Finding specific loci that depart from H-W.
#                              
#                              # i.e. loci with erroneous genotypes, dramatically geographically clustering alleles such as to have few Hzs
#                              
#                              # To find loci - compute relative deficiency PER snp. This is the F statistic (Sewall Wright). Let's add this.
#                              
#                              g<-mutate(g, F=(2*p1*(1-p1)-p12)/(2*p1*1-p1))
#                              plot(g$F, xlab = "SNP number")
#                              
#                              # Notably, some SNPS display a high or low F value. 
#                              # If this is due to genotype error, it will be isolated.
#                              # Actual inbreeding will occur within a sliding window
#                              # Herein we will use a sliding window of 5 SNPs (should use cM or kb)
#                              
#                              # the stats::filter command below calls the filter function from stats library.
#                              # The code instructs to take 5 values centered around an SNP, weighting by 1/5 and summing. Hence, a movaging average through the genome.
#                              
#                              movingavg<-function(x, n=5){stats::filter(x, rep(1/n,n), sides=2)} 
#                              plot(movingavg(g$F), xlab="SNP number")
#                              
#                              movingavg <- function(x, n=5){stats::filter(x, rep(1/n,n), sides = 2)} plot(movingavg(g$F), xlab="SNP number")
#                              
#                              # extracting outliers
#                              
#                              outlier=which (movingavg(g$f) == max(movingavg(g$F), na.rm=TRUE)
#                                             g[outlier,]
#                                             
#                                             outlier=which (movingavg(g$F) == max(movingavg(g$F),na.rm=TRUE)) 
#                                             g[outlier,]
#                                             
#                                             
#                                             
#                                             
#                                             # Task: Write a series of R scripts
#                                             # 
#                                             # Now that you have completed the exercise write two short R scripts ( name them Ob_v_Ex.R and Moving_F.R)  that take as an argument an input file .geno file and output the following:
#                                             #   
#                                             #   1. Ob_v_Ex_het.R:   A script that outputs a plot of the observed versus expected heterozygosity as a .pdf file.
#                                             # 2. Moving_F.R:   A script that outputs a .pdf plot of the moving average F value.
#                                             # 
#                                             # Execute your script using the bash terminal and make sure the expected result is produced. E.g.
#                                             # 
#                                             # 
#                                             # chmod +x Ob_v_Ex_het.R
#                                             # ./Ob_v_Ex_het.R [input_file.geno] [output_file.pdf]
#                                             # 
#                                             # 
#                                             # The first line gives you executable permissions, and the second instructs bash to execute the program on the input file specified in the first argument and save the output to a file named by the second argument.
#                                             # 
#                                             # Did your script produce the expected pdf file?	
#                                             #   
#                                             #   
#                                             #   
#                                             #   
#                                             #   Tips for writing R scripts:
#                                             #   
#                                             #   You will need to write your script using a good text editor. The first line of your script should be the shebang:
#                                             #   
#                                             #   #!/usr/bin/Rscript
#                                             #   
#                                             #   or possibly:
#                                             #   
#                                             #   #!/usr/local/bin/Rscript
#                                             #   
#                                             #   The shebang tells the operating system what kind of program you are writing.
#                                             # 
#                                             # To pass arguments from the command to your R script use the following code:
#                                             #   
#                                             #   
#                                             #   cargs <- commandArgs(T)
#                                             # if (length(cargs) < 2) stop("not enough arguments")
#                                             # if (length(cargs) > 2) stop("too many arguments")
#                                             # 
#                                             # infile <- cargs[1] # input data file name
#                                             # outfile <- cargs[2] # output file name
#                                             # 
#                                             # 
#                                             # This code will allow you to pass any input file name you want to the script and will you to output a file with a user defined name.
#                                             
# 
