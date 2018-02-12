#!/usr/bin/Rscript

cargs <- commandArgs(T)
if (length(cargs) < 2) stop("not enough arguments")
if (length(cargs) > 2) stop("too many arguments")

infile <- cargs[1]
outfile <- cargs[2]


library(ggplot2)

d <- read.table(infile, header=FALSE)

names(d) = c("K", "error")

P <- ggplot(d, aes(K, error))

P <- P + geom_point() + geom_line() + theme_bw() + scale_x_continuous(breaks=d$K) + ggtitle("Cross Validation Error") 
pdf(file=outfile)
P 
dev.off()




