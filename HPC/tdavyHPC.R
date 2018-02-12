rm(list=ls())
graphics.off()

neutral_step_speciation <- function(community, v){
  remove <- (unique(community))
  numberline <- seq(1:200)
  NewSpecSample <- setdiff(numberline, remove)
  NewSpec <- sample((NewSpecSample), 1)
  
  indexchoose <- choose_two(community)
  index1 <- indexchoose[1]
  index2 <- indexchoose[2]
  if ((runif(1, 0, 1)) <= (v)){
    community[index1] <- NewSpec
  } else {
    community[index1] <- community[index2]
  }
  return(community)
}


species_richness <- function(community) {
  for (i in community){
    a[i] <- i
  }
  b <- a[!is.na(a)]
  c <- length(b)
  c
}



choose_two <- function(x){
  return(sample(1:(length(x)), 2, replace = F))
}
neutral_generation_speciation <- function(community, v){
  for (i in (1:ceiling(length(community)/2))){
    community <- neutral_step_speciation(community, v)
  }
  return(community)
}

initialise_min <- function(size) {
  x <- vector(length = size)
  x <- x+1
}

neutral_generation_speciation <- function(community, v){
  for (i in (1:ceiling(length(community)/2))){
    community <- neutral_step_speciation(community, v)
  }
  return(community)
}

species_abundance <- function(community){
  s_a1 <- sort(decreasing = TRUE, as.vector(table(community)))
  return(s_a1)
}

octaves <- function(spec_abundance){
  binrange <- vector()
  for(i in 1:ceiling(log2(length(tabulate(spec_abundance)))-1))
    binrange[i] <- 2^(i)-1
  
  return(tabulate(cut(spec_abundance, c(-Inf, binrange, Inf))))
}
### test params

cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name){
  #initialise min community from size
  community <- initialise_min(size)
  initialtime <- (proc.time()[3])
  burn_in_richness <- vector()
  octavector <- vector()
  # output_file_name <- paste(sep="",output_file_name,".rda")
    for(i in 1:2000){
      community <- neutral_generation_speciation(community, speciation_rate)
        
      if((i %% interval_oct) == 0){
          octaindex <- length(octavector)
          octavector[octaindex+1] <- list(octaves(species_abundance(community)))
        }
      if(i <= burn_in_generations){
            if((i %% interval_rich) == 0){
              richindex <- length(burn_in_richness)
              burn_in_richness[richindex+1]<- species_richness(community)
            }
      }
     if((((proc.time()[3]) - initialtime)/60) >= wall_time){
                break
     }else{
       for(i in 1:2000){
         community <- neutral_generation_speciation(community, speciation_rate)
         
         if((i %% interval_oct) == 0){
           octaindex <- length(octavector)
           octavector[octaindex+1] <- list(octaves(species_abundance(community)))
         }
         if(i <= burn_in_generations){
           if((i %% interval_rich) == 0){
             richindex <- length(burn_in_richness)
             burn_in_richness[richindex+1]<- species_richness(community)
           }
         }
         if((((proc.time()[3]) - initialtime)/60) >= wall_time){
           break
         }
       
       }
     }
    }
     
  
runtime <- (((proc.time()[3]) - initialtime)/60)

# print(octavector)
# print(burn_in_richness)
# print(runtime)
# print("hi")
# print(i)
printout <- c(burn_in_richness, octavector, community, runtime, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations)
# save("burn in richness", burn_in_richness, octavector, community, runtime, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file = output_file_name, ascii = T)
sink(file = output_file_name, append = F, type = c(""))
return(0)
}


# iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
iter <- seq(1:100)
set.seed(42) #setting seed for seedbank samplings
    iter <- seedbank[iter]
    set.seed(iter)
    cluster_run()

  
