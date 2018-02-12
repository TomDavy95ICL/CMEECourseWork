#!/usr/bin/RScript

cargs <- commandArgs(T)
if (length(cargs) < 3) stop("not enough arguments")
if (length(cargs) > 3) stop("too many arguments")

in <- cargs[1] #infile
k <- cargs[2] #number of populations
out <- cargs[3] #outfile




d <- read.table(in, header=TRUE, row.names=1, stringsAsFactors=TRUE)


Afr <- subset(d, d$REG=="Afr", Pop0:Pop4)
pdf(file=out)
barplot(t(as.matrix(afr)), col=rainbow(k), xlab="Individual #", ylab="Ancestry", border=NA)
dev.off()