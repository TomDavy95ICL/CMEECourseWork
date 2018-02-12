7.1.4:
#~ 	#1# Modify the script TreeHeight.R to do the following:
#~ 		a~ Loads trees.csv and calculates tree heights for all trees in the data. Distances = meters.
		
#~ 		b~ Creates a csv output called TreeHts.csv in Results that contains the calculated tree heights w/ original data in the following format:  "Species // Distance.m // Angle.degrees // Tree.height.m//." Work via source or Rscript.


#This function calculates heights of trees from the angle of elevation
# and the distance from the base using the trigonometric
# formula height = distance * tan(radians)
#
# ARGUMENTS:
# degrees 		The angle of elevation
# distance 		The distance from base
#
# OUTPUT:
# The height of the tree, same units as "distance"


# Requires RScript approach
# i.e. "Rscript $" runs script from bash
# "Rscript myscript.py $input1 $input2" etc.


TreeHeight <- function(degrees, distance){
	radians <- degrees * pi / 180
	height <- distance * tan(radians)
	print(paste("Tree height is:", height, "metre(s)"))
	
	return (height)
}

# Input data from relative path
MyTreeData <- read.csv("../Data/trees.csv", header = T)

# Create vector of tree heights using the TreeHeight function from the existing database
MyTreeHeights <- c(TreeHeight(MyTreeData$Angle.degrees, MyTreeData$Distance.m))

# Append a new column to database, and populate with calculated values
MyTreeData$Tree.Height.m=MyTreeHeights

# Write new file into given .csv, removing row names.
write.table(MyTreeData, "../Data/TreeHts.csv", row.names= F)




