rm(list=ls())
graphics.off()


# Function to find species richness from 1d vector of 'community'
# vector. i.e. species_richness(c(1,4,4,5,1,6,1) ->> prints 4.
# This is performed via an initial for loop that sorts the community vector
# onto a numberline, where missing values in that numberline are represente by NA.
# These NAs are then filtered out <b>, and the length of this vector is the richness <c>.
species_richness <- function(community) {
  a <- vector()
  for (i in community){
	  a[i] <- i
	}
  b <- a[!is.na(a)]
  c <- length(b)
	c
}

# Function to create an initial community of maximum species diversity according to size.
# This is easily made using the seq command, with limits from 1 to <size>.
initialise_max <- function(size) {
	seq(from  = 1, to = size)
}

# Function to create an initial community of minimum species diversity according to size.
# This is created by initialising an empty vector (a vector of 0s) of length <size>.
# Addition of +1 to this vector adds 1 to every value, creating a homogenous starting state.
initialise_min <- function(size) {
	x <- vector(length = size)
	x <- x+1
}
	
# A function to choose two integers, from 1 to X, w/o replacement.
# Acheived through sampling a vector (1:x) twice with replace = F.
choose_two <- function(x){
 return(sample(1:x, 2, replace = F))
}


# One neutral step of replacement. Firstly, a vector of index values to manipulte
# is generated from choose_two& the length of the community vector.
# Subsequently, this vector is split <index1> & <index2>
# And these vectors are used to inform the copying of the community
# vector value from one index to the next <line 49>.
neutral_step <- function(community){
  indexchoose <- choose_two(length(community))
  index1 <- indexchoose[1]
  index2 <- indexchoose[2]
  community[index1] <- community[index2]
  community
  }
	

# the ceiling of length community denotes the number of steps
# in a generation <line 57>. A neutral step is then applied
# for each value of i in 1 to this value.
neutral_generation <- function(community){
  for (i in (1:(ceiling(length(community)/2)))){
    community <- neutral_step(community)
} 
return(community)

}


# Creates blank richness vector <richvect>; prior to neutral steps, places richness at index [1] in this.
# Then applies a step to initial community & inserts new richness into indexed position of richvect
neutral_time_series <- function(initial, duration){
  richvect <- vector()
    richvect[1] <- species_richness(initial)
      for (i in 1:duration){
        initial <- neutral_generation(initial)
          richvect[i+1] <- species_richness(initial)
        
    }
return(richvect)
}


question_8 <- function(){
  plot(neutral_time_series(initialise_max(100), 200), type="l", main = "Species Richness Coalesence According to Neutral Theory", xlab = "Generations", ylab = "Species Richness")
}



# To allow for speciation, a generic number line of 1:200 is populated for new species to be drawn from.
# A list of numbers not in the current population is set as NewSpecSample. This is then sampled once for 
# a number to represent the new species.
# Similar code from neutral_step is used here. Importantly, speciation rate is
# represented here by a runif from 0 to 1, where a loop allocates one of the chosen
# community indexes a new species is the runif value is less than or equal to one. an
# else statement allows the normal birth death step without speciation otherwise.

neutral_step_speciation <- function(community, v){
  remove <- (unique(community))
  numberline <- seq(1:200)
  NewSpecSample <- setdiff(numberline, remove)
  NewSpec <- sample((NewSpecSample), 1)
  
  indexchoose <- choose_two((length(community)))
  index1 <- indexchoose[1]
  index2 <- indexchoose[2]
    if ((runif(1, 0, 1)) <= (v)){
      community[index1] <- NewSpec
    } else {
      community[index1] <- community[index2]
    }
  return(community)
}



# The same as neutral_generation with neutral_step_speciation instead of neutral_step
neutral_generation_speciation <- function(community, v){
  for (i in (1:ceiling(length(community)/2))){
    community <- neutral_step_speciation(community, v)
  }
  return(community)
}

# Neutral_time_series using neutral_generation_speciation.
neutral_time_series_speciation <- function(community, v, duration){
    richvect <- vector()
    richvect[1] <- species_richness(community)
    for (i in 1:duration){
      community <- neutral_generation_speciation(community, v)
      richvect[i+1] <- species_richness(community)
      
    }
    return(richvect)
  }


question_12 <- function(){
  bmp("question12.bmp")
  plot12vect_max<-((neutral_time_series_speciation(community = initialise_max(100), v = 0.1, duration = 200)))
  plot12vect_min<-((neutral_time_series_speciation(community = initialise_min(100), v = 0.1, duration = 200)))
  plot(plot12vect_max, type = "l", ylab = "Species Richness", xlab = "Generation", col=50); lines(plot12vect_min, col=100)
  dev.off()
  }

# Table allows counting the number of times each species appears. Converting back into a vector and sorting
# by decreasing value outputs appropriate species_abundance.
species_abundance <- function(community){
  s_a1 <- sort(decreasing = TRUE, as.vector(table(community)))
return(s_a1)
}


# An appropriate length of binrange values is first determined by finding log^2 of length of tabulated
# species_abundance (i.e. assuming highest possible outcome).
# This is then cut between -Inf, the given range of bin values and +Inf. Tabulation puts
# this into appropriate output.
octaves <- function(spec_abundance){
  binrange <- vector()
  for(i in 1:ceiling(log2(length(tabulate(spec_abundance)))-1))
    binrange[i] <- 2^(i)-1
  
  return(tabulate(cut(spec_abundance, c(-Inf, binrange, Inf))))
}


y <- c(1,3)
x <- c(1, 0, 5, 2)

# Firstly, the diference in length is found between the 2 vectors <diffL>.
# Then, a 3rd vector of zeroes, of the size difference, is made. sqrt and ^2 are needed
# To ensure the length is positive.
# An if loop then determines which initial vector to append these 0s to.
# Finally the two vectors are added as <z>.

sum_vect <- function(x,y){
  diffL <- (length(x)-length(y))
  zerofill <- integer(sqrt(diffL^2))
  if((diffL)>0){
    y <- append(y, zerofill, after = length(y))
   }
  
  if((diffL)<0){
    x <- append(x, zerofill, after = length(x))
    }
    z <- x + y
    return(z)
}


question_16 <- function(){
  ###communitymax###
  communitymax<-((neutral_generation_speciation(community = initialise_max(100), v = 1)))
  #burn-in of 200 generations.w
  for(i in seq(1:199)){
    communitymax<-((neutral_generation_speciation(community = communitymax, v = 0.1)))
  }
  #initial octave binning
  max_species_octave <- octaves(species_abundance(communitymax))
  #running simulation
 
  # A nested loop allows for 2000 generations, wherein the octave is formed every 20 generations.
  for(i in seq(1:100)){
    for(i in seq(1:20)){
      communitymax<-((neutral_generation_speciation(community = communitymax, v = 0.1)))
    }
    max_species_octave <- sum_vect(max_species_octave, octaves(species_abundance(communitymax)))
  }
  ##communitymin##
  communitymin<-((neutral_generation_speciation(community = initialise_min(100), v = 1)))
  for(i in seq(1:199)){
    communitymin<-((neutral_generation_speciation(community = communitymin, v = 0.1)))
  }
  #initial octave binning
  min_species_octave <- octaves(species_abundance(communitymin))
  #running simulation
  
  for(i in seq(1:100)){
    for(i in seq(1:20)){
      communitymin<-((neutral_generation_speciation(community = communitymin, v = 0.1)))
    }
    min_species_octave <- sum_vect(min_species_octave, octaves(species_abundance(communitymin)))
    # print(min_species_octave)
  }
  barplot((max_species_octave / 201), col = "transparent", border = "red", ylab = "Abundance", xlab = "Octave Index (2^x)") 
  barplot((min_species_octave / 201), col = "transparent", border = "blue", add = TRUE)
}

##

# Co-ordinate points firstly initialised as 2 value vectors <a> througgh <c>, and X starts at a.
# A runif function is used to decide on which point to move 1/2 way towards, though
# this is done explicitly and has potential to be used with a table instead, I'd reckon.
chaos_game <- function(){
a <- c(0, 0)
b <- c(3, 4)
c <- c(4, 1)

X <- a

X1 <- vector()
  for(i in 1:2000){
    coordchoose <- (ceiling(runif(1, 0, 3)))
     if(coordchoose == 1){
       X1 <- a
     }
     if(coordchoose == 2){
       X1 <- b
     }
     if(coordchoose == 3){
       X1 <-c
     }
  # The position vector to add to X is determined by subtracting the chosen points
  # co-ordinates minus current co-ords, over two.
    Move.dx <- ((X1[1] - X[1])/2)
    Move.dy <- ((X1[2] - X[2])/2)
  # Xm (Xmove) vector made to make reference to Move.dx/y easier subsequently.
  # X is then apended with these movement co-ordinates in preparation for the loop.
  # Finally, a point is plotted using xy.coords.
  Xm <- c(Move.dx, Move.dy)
  X <- c(Xm[1],Xm[2])
  Xplot <- xy.coords(Xm[1], Xm[2])  # use xy.coords to convert from operable vector to plottable coords.
  points(Xplot, cex = 0.1)
  #  
   
  }
}


# Testplot for creating a plot for lines

testplot <- function(){
  plot(1, xlim=c(-5,10), ylim=c(-5,10), cex = 0.0001)
}

start_position <- c(0,0)
direction <- pi/5
length <- 3

turtle <- function(start_position, direction, length){
  # e.g. For Testing! start_position = c(3,0); direction <- 2; length <- 3
  # Sin = Opp / Hyp. Wherein Length = Hypotenuse.
  # Cos is mandatory here. Otherwise negative values will not be possible when calculating subsequent
  # Angles (from 3rd line in this case).
  # Cos = Adj/Hyp. Hence Cos(x)*Hyp = Adjacent side length of R.A. triangle.
  Move.dx <- ((sin(direction)*length)) # Adjacent Length
  Move.dy <- ((cos(direction)*length)) # Opposite Length.
  start_position[1] -> x # seperating co-ord vector
  start_position[2] -> y # "
  segments(x, y, (x + Move.dx), (y + Move.dy)) # Drawing the line, with end_position being x + Move.dx etc.
  end_position <- c((x + Move.dx), (y + Move.dy))
  return(end_position)
}

elbow <- function(start_position, direction, length){
  turtle(start_position, direction, length)
  turtvect <- turtle(start_position, direction, length) # storing turtle output 
  
  
  start_position <- c(turtvect[1], turtvect[2]) # storing turtle output co-ords.
  direction<- direction + (pi/4) # Adding pi/4 to angle. sin and cos MUST be used otherwise this will 'tick' over about pi/2 and give the wrong angle when sin is applied.
  length <- 0.95*length
  
  turtle(start_position, direction, length)

}


spiral <- function(start_position, direction, length){
  turtle(start_position, direction, length)
  turtvect <- turtle(start_position, direction, length)  
  start_position <- c(turtvect[1], turtvect[2])
  direction <- direction+(pi/4)
  length <- 0.95*length
  
  spiral(start_position, direction, length)
  
}

# Adds conditional if loop to ensure line length is controller to dodge infinite recursion.
spiral2 <- function(start_position, direction, length, e){

if(length > e){  
  
turtle(start_position, direction, length)
turtvect <- turtle(start_position, direction, length)  

start_position <- c(turtvect[1], turtvect[2])
direction <-(direction+(pi/4))
length <- 0.95*length

spiral2(start_position, direction, length, e)
  
}else{
  return(1)

}

}

# Within length determining loop, two tree functions determine new branches at initial 
# direction + pi/4 and - pi/4 (achieved by subtracting pi/2 from the first addition of pi/4).
tree <- function(start_position, direction, length, e){
  
  if(length > e){  
    
    turtle(start_position, direction, length)
    turtvect <- turtle(start_position, direction, length)  
    
    start_position <- c(turtvect[1], turtvect[2])
    direction <-(direction+ (pi/4))
    length <- 0.65*length
    
    tree(start_position, direction, length, e)
    direction <- direction - (pi/2)
    tree(start_position, direction, length, e)
    
  }else{
    return(1)
    
  }
  
}


# Similar to Tree; Here the length is re-determiend each time instead of once within the loop.
fern <- function(start_position, direction, length, e){
  
  if(length > e){  
    
    turtle(start_position, direction, length)
    turtvect <- turtle(start_position, direction, length)  
    
    start_position <- c(turtvect[1], turtvect[2])
    direction <-(direction - (pi/4))
    length <- 0.38*length
    fern(start_position, direction, length, e)
    
    direction <- direction + (pi/4)
    length <- (length/0.38)*0.87
    fern(start_position, direction, length, e)
    
  }else{
    return(1)
    
  }
  
}

fern_2 <- function(start_position, direction, length, e, dir){
  
  if(length > e){
    
    turtle(start_position, direction, length)
    turtvect <- turtle(start_position, direction, length)  
    start_position <- c(turtvect[1], turtvect[2])
   
    direction <- ((direction) - (pi/4)) 
    length <- 0.38*length
    dir <- dir*(-1)
    fern_2(start_position, direction, length, e, dir)
    
    direction <-((direction) + (pi/4))
    length <- (length/0.38)*0.87
    dir <- dir*(-1)
    fern_2(start_position, direction, length, e, dir)
    
    direction <- ((direction) - (pi/4)) 
    length <- 0.38*length
    dir <- dir*(-1)
    fern_2(start_position, direction, length, e, dir)
    
    direction <-((direction) + (pi/4))
    length <- (length/0.38)*0.87
    dir <- dir*(-1)
    fern_2(start_position, direction, length, e, dir)
    
  }else{
    return(1)

}
  
}







testplot()
  






