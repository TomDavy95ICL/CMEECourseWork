#!/usr/bin/Rscript

cargs <- commandArgs(T)
if (length(cargs) < 2) stop("not enough arguments")
if (length(cargs) > 2) stop("too many arguments")

infile <- cargs[1] #infile from plinkMDS2R.pl
outfile <- cargs[2] 

library(caret)
library(ggplot2)

d <- read.table(file=infile, header=TRUE, row.names=1)


file1 <- paste("plot1_",outfile, sep="")





P1 <- ggplot(data=d, aes(x=C1, y=C2, color=REG)) 



P1 <- P1 + geom_point(size=1) + coord_equal(ratio=1) + theme_bw() + ggtitle("IBS MDS") + xlab("Dimension 1") + ylab("Dimension 2") + scale_color_hue(name="Region") + scale_x_continuous() + scale_y_continuous()





pdf(file=file1)
P1 
dev.off()


