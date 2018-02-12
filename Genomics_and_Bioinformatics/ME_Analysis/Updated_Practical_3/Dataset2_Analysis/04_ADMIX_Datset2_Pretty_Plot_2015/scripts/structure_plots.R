#!/usr/bin/Rscript

options(stringsAsFactors=F)
library(MASS)
library(RColorBrewer)



############################

structure.plot <- function(x, cex.axis=0.5) {
  qcols <- sapply(names(x), function(y) {length(grep("Q", y)) > 0})
  q <- x[,qcols]
  n <- ncol(q)
  cols <- c("blue", "#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "red", "#A6761D", "#666666", "#E6AB02")[1:n]
  #cols <- brewer.pal(3, "Paired")
  #cols[11] <- "#999999"
  #cols <- c("red", "blue", "green")
  barplot(t(as.matrix(q)), space=0, border=NA, col=cols, axes=F, axisnames=F)
  
  ppos <- c()
  for (p in levels(x$pop)) {
    ppos <- c(ppos, mean(which(x$pop == p)))
  }
  axis(1, at=ppos, labels=levels(qdata$pop), tick=F, las=2, cex.axis=cex.axis)
  
  pmin <- c()
  for (p in levels(x$pop)) {
    pmin <- c(pmin, min(which(x$pop == p)))
  }
  pmin <- pmin - 0.5
  pmin <- pmin[pmin > 1]
  abline(v=pmin)
}

# reorder a Q-dataframe by the component with the largest values
mq_reorder <- function(x) {
  qmeans <- apply(x, 2, mean)
  qmax <- which(qmeans == max(qmeans))
  x[order(x[,qmax], decreasing=T),]
}

##############################################################



#qdata <- read.csv("~/Dropbox/Projects/MENA-African-Admixture/03a_admixture/results/medius-Q-data.csv")
#popinfo <- read.csv("~/Dropbox/Projects/MENA-African-Admixture/03a_admixture/infiles/ordered_popdata.csv")

cargs <- commandArgs(T)
if (length(cargs) < 3) stop("not enough arguments")
if (length(cargs) > 3) stop("too many arguments")


in.d <- cargs[1]
in.pop <- cargs[2]
out <- cargs[3]

qdata <- read.csv(file=in.d)
popinfo <- read.csv(file=in.pop)

##############################################################

# merge order and region information from popinfo,
# while also dropping the initial region column from qdata
qdata <- merge(subset(qdata, select=setdiff(names(qdata), c("region"))), popinfo,
               by.x='pop', by.y='pop')
qdata$pop <- factor(qdata$pop, levels=popinfo$pop, ordered=T)
qdata <- qdata[order(qdata$order),]

##############################################################

qcols <- sapply(names(qdata), function(y) {length(grep("Q", y)) > 0})

for (p in levels(qdata$pop)) {
  prows <- (qdata$pop == p)
  qdata[prows, qcols] <- mq_reorder(qdata[prows, qcols])
}

#tiff(file="~/Dropbox/Projects/MENA-African-Admixture/03a_admixture/results/medius-structure-plot.tiff", width=1700, height=350, antialias="default")
pdf(file=out)
structure.plot(qdata, cex.axis=0.6)
dev.off()
