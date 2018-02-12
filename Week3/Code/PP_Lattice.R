graphics.off()
library(lattice)

rm=list(ls())
# Kills any unknown graphics devices such as to prevent errors in 
# graphics generation


# Script that draws and saves three lattice graphs by
# feeding interaction type: One of pred mass, 1x prey
# mass, 1x size ratio of prey mass over pred mass.
# N.B. you would want to use logarithims of masses 



# Boxplot w/ Scatterplot?
# Density Distributions & Calculate Means etc indpendently.



# Sourcing &/ Running This script should result in three outputs;
# >Pred_Lattice.pdf; Prey_Lattice.pdf; SizeRatioLattice.pdf being
# Saved into results directory.

# In addition: Script should calculate the mean and median log predator mass, prey mass
# and predator-prey size ration, by feeding type, and save it as a single
# csv output called PP_Results.csv in results. Table should have appr
# -ropriate headers (Hint: Initialize a new dataframe in the script
# to first store the calculation

# Script should be self-sufficient, require no external inputs
# Should import the above pred/prey dataset from the appr. directory
# and save plots to app. directory

# For calculating statistics by feeding type: can use 2 methods
# a) "Loopy" way
# First by obtaining a list of feeding types (look up the unique or levels functions)
# Then loop over them, using subset to extract the dataset by feeding
# type at each iteration.
# b) "R-savvy" way
# using tapply or ddply and avoiding looping altogether
