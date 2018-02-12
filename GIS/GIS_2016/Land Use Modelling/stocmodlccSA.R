################# STOCMODLCC ##################
## Stochastic Modelling of Land Cover Change ##
#######  Graphical User Interface in R  #######
###############################################
## Copyright (C) 2014  Isabel MD Rosa

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation version 3 of the License, or any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details at http://www.gnu.org/licenses/

#### clean workspace ####
rm(list=ls())

######## libraries to import ##########
is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1]) 
if(is.installed("gWidgets")==TRUE){require("gWidgets")}else{install.packages("gWidgets");require("gWidgets")}
if(is.installed("gWidgetsRGtk2")==TRUE){require("gWidgetsRGtk2")}else{install.packages("gWidgetsRGtk2");require("gWidgetsRGtk2")}
if(is.installed("sp")==TRUE){require("sp")}else{install.packages("sp");require("sp")}
if(is.installed("maptools")==TRUE){require("maptools")}else{install.packages("maptools");require("maptools")}
if(is.installed("randomForest")==TRUE){require("randomForest")}else{install.packages("randomForest");require("randomForest")}
if(is.installed("cvTools")==TRUE){require("cvTools")}else{install.packages("cvTools");require("cvTools")}
if(is.installed("caret")==TRUE){require("caret")}else{install.packages("caret");require("caret")}
if(is.installed("rpart")==TRUE){require("rpart")}else{install.packages("rpart");require("rpart")}
if(is.installed("tree")==TRUE){require("tree")}else{install.packages("tree");require("tree")}
if(is.installed("boot")==TRUE){require("boot")}else{install.packages("boot");require("boot")}
if(is.installed("nnet")==TRUE){require("nnet")}else{install.packages("nnet");require("nnet")}
if(is.installed("MASS")==TRUE){require("MASS")}else{install.packages("MASS");require("MASS")}
if(is.installed("kernlab")==TRUE){require("kernlab")}else{install.packages("kernlab");require("kernlab")}
if(is.installed("stringr")==TRUE){require("stringr")}else{install.packages("stringr");require("stringr")}
if(is.installed("raster")==TRUE){require("raster")}else{install.packages("raster");require("raster")}
if(is.installed("ROCR")==TRUE){require("ROCR")}else{install.packages("ROCR");require("ROCR")}



## open GUI window
options(guiToolkit="RGtk2")
win<-gwindow("::.:: StocModLCC v1.0 ::.::", visible=TRUE,width=500,height=200)

group_mm<-ggroup(horizontal=FALSE,container=win)

## main menu text
btn<-glabel("Welcome to StocModLCC main menu!",cont=group_mm,anchor=c(-1,0))
font(btn)<-list(family="times",size="x-large",weight="bold")

btn2<-glabel("Please choose one of the following options:",cont=group_mm,anchor=c(-1,0))
font(btn2)<-list(family="times",size="medium",weight="bold",style="italic")

#create container to have size by side buttons
group_mm2 <- ggroup(horizontal = TRUE, container=group_mm)

## One transition button and options
oneT_button<-gbutton("One Transition only",cont=group_mm2,handler=function(h,...){
win1T<-gwindow("::.:: StocModLCC v1.0 - One Transition Only::.::", visible=TRUE,width=500,height=200)

### ONE TRANSITION ONLY (win1T) ###
## create a container
group <- ggroup(horizontal = FALSE, container=win1T)

## field to select working directory
start_dir <- gfilebrowse(text = "Select working directory ...",quote = FALSE ,type = "selectdir" , cont = group)

## function to import all ascii files in directory
variables<-c()
input_data <- function(){
	print("In progress...")
	setwd(svalue (start_dir))
	filenames<<- list.files(getwd(), pattern="*.asc", full.names=TRUE)
		filenames2<-list.files(getwd(), pattern="*.asc", full.names=FALSE)
	data_container <- lapply(filenames, readAsciiGrid)
	if(length(filenames)>0&length(filenames)==length(data_container)){gmessage ("Data imported successfully" , title = "Importing data")}
	else{gmessage("Something went wrong... please try again!" , title = "Oops!");print("Please check if you chose the correct directory")}
	print("Check if all datasets have the same dimensions")
	for(i in 1:length(filenames))
	{
		print(dim(as.matrix(data_container[[1]])))
		num_rows<<-dim(as.matrix(data_container[[1]]))[1]
		num_cols<<-dim(as.matrix(data_container[[1]]))[2]
	#	new_var<<-substr(filenames[i],str_locate_all(pattern=getwd(),filenames[i])[[1]][1,2]+2,str_locate_all(pattern=".asc",filenames[i])[[1]][1,1]-1)
		new_var<<-substr(filenames2[i],1,str_locate_all(pattern=".asc",filenames2[i])[[1]][1,1]-1)
		variables<<-c(variables,new_var)	

	}
	
	print("Files imported: ")
	print(filenames)	
	spatial.points<<-as.data.frame(SpatialPoints(data_container[[1]]))
	original_data<<-as.data.frame(spatial.points)
	return(data_container)
	print("Please continue")
}

see_data <- function(){
	for(i in 1:length(filenames))
	{
		map_to_plot<-readAsciiGrid(paste(filenames[i],sep=""),as.image=T,plot.image = TRUE)
		par(ask=TRUE)
	}
	print("Please continue")
}

#create container to have size by side buttons
group2 <- ggroup(horizontal = TRUE, container=group)

## button to read files
inputs_button <- gbutton("Import All Ascii Files",container=group2,handler = function(h,...){dataset<<-input_data()})

#see the data
visual_button<- gbutton("Visualise data" , cont = group2,handler = function(h,...) see_data())

#create container to have size by side buttons
group5 <- ggroup(horizontal = TRUE, container=group)
group6 <- ggroup(horizontal = TRUE, container=group)


## button to prepare matrix for modelling
matrix_button <- gbutton("Start StocModLCC",cont = group2, handler=function(h,...){
	print("In progress...")
	for(j in 1:length(variables))
	{
		original_data<<-data.frame(original_data,c(as.matrix(dataset[[j]])))
	}	

	colnames(original_data)<<-c("x","y",variables)
	data_to_model<<-original_data[is.na(rowSums(original_data))==FALSE,]
	gmessage ("Now let's set up the model!" , title = "StocModLCC ready")
	print("Please continue")

	## section to define explanatory and independent variables
	glabel ("Land cover/use (t1): " , cont = group5 , anchor = c(-1,0))
	addSpace(group5,25)
	dependent_check<<- gcheckboxgroup(variables, container=group6, use.table=TRUE,width=100)
	size(dependent_check)<-c(110,100)
	addSpace(group6,25)
	glabel ("Land cover/use (t2): " , cont = group5 , anchor = c(-1,0))
	addSpace(group5,25)
	dependent2_check<<- gcheckboxgroup(variables, container=group6, use.table=TRUE,width=100)
	size(dependent2_check)<-c(110,100)
	addSpace(group6,25)
	glabel ("Variables to consider: " , cont = group5 , anchor = c(-1,0))
	addSpace(group5,25)
	independent_check<<- gcheckboxgroup(variables, container=group6, use.table=TRUE,width=100)
	size(independent_check)<-c(110,100)
	addSpace(group6,25)
	glabel ("Categorical variables: " , cont = group5 , anchor = c(-1,0))
	addSpace(group5,25)
	categorical_check<<- gcheckboxgroup(variables, container=group6, use.table=TRUE,width=100)
	size(categorical_check)<-c(110,100)
	addSpace(group6,25)

#create container to have size by side buttons
group99 <- ggroup(horizontal = TRUE, container=group)

## button to compute transitions matrix
transitions_button <- gbutton("Compute Transitions Matrix",container=group99,handler = function(h,...){

	print("In progress...")
	#identify unique land cover
	land_cover_t1<<-original_data[,colnames(original_data)==svalue(dependent_check)]
	land_cover_t2<<-original_data[,colnames(original_data)==svalue(dependent2_check)]
	lc1<<-unique(land_cover_t1)
	lc2<<-unique(land_cover_t2)
	
	#create a dataset per land cover
	for(i in svalue(lc1)[is.na(svalue(lc1))==FALSE])
	{
		assign(paste("land",i,sep=""),land_cover_t1[land_cover_t1==i&is.na(land_cover_t1)==FALSE], envir = .GlobalEnv)
		assign(paste("persistence",i,sep=""),land_cover_t2[land_cover_t1==i&is.na(land_cover_t1)==FALSE], envir = .GlobalEnv)
	}
	change_lc<<-ifelse(land_cover_t1==land_cover_t2,0,1)
	original_data<<-data.frame(original_data,change_lc)
	data_to_model<<-original_data[is.na(rowSums(original_data))==FALSE,]
	print("LAND COVER IN TIME 1:")
	print(table(land_cover_t1))
	print("LAND COVER IN TIME 2:")
	print(table(land_cover_t2))
	print("LAND COVER CHANGE FROM TIME 1 TO TIME 2:")
	print(table(change_lc))
	
	gmessage ("Transitions matrix is ready for plotting!" , title = "Transitions matrix")
	print("Please continue")
})

## button to plot transitions matrix
plot_transitions_button <- gbutton("Plot Transitions",container=group99,handler = function(h,...){
		par(mfrow=c(1,sum(is.na(svalue(lc1))==FALSE)))
		for(i in svalue(lc1)[is.na(svalue(lc1))==FALSE]){
			barplot(table(get(paste("persistence",i,sep=""))),xlab=paste("Land Cover Class in t1: ",i,sep=""),ylab="Change in Land Cover (pixels) in t2")
		}
		print("Please continue")
		})

## button to calculate neighbourhood
neibs_button <- gbutton("Calculate neighbourhood",container=group99,handler = function(h,...){
	ginput(paste("Please insert land cover class:",sep=""), icon="info", handler = function(h,...){lc_neibs<<-as.numeric(h$input)})
	lc_matrix<<-matrix(land_cover_t1,nrow = num_rows,ncol = num_cols)
	var_names<<-svalue(independent_check)
	lc_raster<<-raster(ifelse(lc_matrix==lc_neibs,1,0))
	ginput(paste("Please insert neighborhood size (number of pixels - MUST be an odd number):",sep=""), icon="info", handler = function(h,...){ws<<-as.numeric(h$input)})
	assign(paste("neibs",lc_neibs,sep=""),c(as.matrix(focal(lc_raster,w=matrix(ws,ws),na.rm=TRUE))), envir = .GlobalEnv)
	var_names<<-c(var_names,paste("neibs",lc_neibs,sep=""))
	neibscalc<<-ifelse(is.na(original_data[,ncol(original_data)])==FALSE & is.na(get(paste("neibs",lc_neibs,sep="")))==TRUE,0,get(paste("neibs",lc_neibs,sep="")))
	original_data<<-data.frame(original_data,neibscalc)
	data_to_model<<-original_data[is.na(rowSums(original_data))==FALSE,]
	names(data_to_model)[length(names(data_to_model))]<<-paste("neibs",lc_neibs,sep="")
	names(original_data)[length(names(original_data))]<<-paste("neibs",lc_neibs,sep="")
	gmessage ("Neighborhood determined!" , title = "Contagion")

})

#Start Model Calibration
btn_cal<-glabel("Model Calibration",cont=group,anchor=c(-1,0))
font(btn_cal)<-list(family="times",size="large",weight="bold")

#create container to have size by side buttons
group98 <- ggroup(horizontal = TRUE, container=group)

	## section to choose method of model calibration
	glabel ("Choose calibration method: " , cont = group98 , anchor = c(-1,0))
	availMethods<<-c("",LogisticRegression="glm")
	counter<<-1
	obj2_val<<-gcombobox(names(availMethods),container=group98,handler=function(h,...){
		##add check for stepwise
		if(counter==1){check_box<<-gcheckbox("Perform Automatic Stepwise (only valid for Logistic Regression)",checked = FALSE,cont = group)}
		#only allow the stepwise option when Logistic Regression is selected
		if(svalue(obj2_val)=="LogisticRegression"){enabled(check_box)<-TRUE
		counter<<-counter+1}
		else{enabled(check_box)<-FALSE
		counter<<-counter+1}})

#create container to have size by side buttons
group97 <- ggroup(horizontal = TRUE, container=group)

	## section to choose how much is for training and for testing
	glabel ("Proportion for training and testing: " , cont = group97, anchor = c(-1,0))
	obj_val<-gcombobox(c("","0.5/0.5","0.7/0.3"), container=group97)

	##start calibration bit
	counter2<<-1
	counter33<<-1
	counter3<<-1
	explanatory<<-c()
	#create container to have size by side buttons
	group4 <- ggroup(horizontal = TRUE, container=group)

	fit_button<<- gbutton("Calibrate your model",cont = group4, handler=function(h,...){

		print("In progress...")
		
		#determines whether there are any categorical variables in the dataset
		if(length(svalue(categorical_check))>0){

		##first transform variables into factors where needed
		for(fac in 1:length(svalue(categorical_check)))
		{
			original_data[,colnames(original_data)==svalue(categorical_check)[fac]]<-as.factor(original_data[,colnames(original_data)==svalue(categorical_check)[fac]])
			data_to_model[,colnames(data_to_model)==svalue(categorical_check)[fac]]<-as.factor(data_to_model[,colnames(data_to_model)==svalue(categorical_check)[fac]])
			ginput(paste("Please enter reference level for ",svalue(categorical_check)[fac],sep=""), icon="info", handler = function(h,...){baseline<<-h$input})
			data_to_model[,colnames(data_to_model)==svalue(categorical_check)[fac]]<<-relevel(data_to_model[,colnames(data_to_model)==svalue(categorical_check)[fac]],ref=baseline)
		}

		}
		

		### prepare training and testing datasets #####
		if(svalue(obj_val)==""|svalue(obj_val)=="5-fold validation"|svalue(obj_val)=="10-fold validation"){print("Please select a valid way to get your training and testing data")}
		perc_test<<-as.numeric(substr(svalue(obj_val),5,7))
		ID<<-1:nrow(data_to_model)
		n.test<<-round(perc_test*length(ID),0)
		IDs.test<<-sample(ID, n.test)
		IDs.train<<-ID[ID%in%IDs.test==FALSE] 
		test.data<<-data_to_model[IDs.test,c(3:ncol(data_to_model))] 
		train.data<<-data_to_model[IDs.train,c(3:ncol(data_to_model))]

		##select appropriate calibration method according to results from combobox
		if(svalue(obj2_val)=="LogisticRegression"){
			input.glm<<-c(match(var_names,names(train.data)))
			full.model<<-glm(factor(train.data[,names(train.data)=="change_lc"])~.,data=train.data[,input.glm],family=binomial,na.action=na.exclude)
			print(summary(full.model))
			#necessary later on
			newinputs.glm<<-input.glm}
			#show stepwise results
			if(svalue(check_box)==TRUE){print("STEPWISE RESULTS START HERE")
			ginput("Please insert forward or backward", icon="info", handler = function(h,...){step_dir<<-h$input})
			stepwise.model<<-stepAIC(full.model,direction = svalue(step_dir))
			print(summary(stepwise.model))
			#get original mean and sd value of parameters in the final model
			if(svalue(check_box)==TRUE){sd.fit<<-sqrt(diag(vcov(stepwise.model)));mean.fit<<-coef(stepwise.model)}else{sd.fit<<-sqrt(diag(vcov(full.model)));mean.fit<<-coef(full.model)}
			}

		##add button to update results
		if(counter2==1){update_button<<-gbutton("Update model",cont = group4,handler= function(h,...){ginput("Please enter variable to remove:", icon="info", handler = function(h,...){var_add<<-h$input})
			if(svalue(check_box)==TRUE){stepwise.inputs<<-match(names(get_all_vars(model.frame(stepwise.model)))[-1],names(train.data))}else{stepwise.inputs<<-match(names(get_all_vars(model.frame(full.model)))[-1],names(train.data))}
			newinputs.glm<<-stepwise.inputs[stepwise.inputs!=match(var_add,names(train.data))]
			if(svalue(check_box)==TRUE){stepwise.model<<-glm(factor(train.data[,names(train.data)=="change_lc"])~.,data=train.data[,newinputs.glm],family=binomial,na.action=na.exclude)}else{full.model<<-glm(factor(train.data[,names(train.data)=="change_lc"])~.,data=train.data[,newinputs.glm],family=binomial,na.action=na.exclude)}
			print("NEW MODEL")
			if(svalue(check_box)==TRUE){print(summary(stepwise.model))}else{print(summary(full.model))}
			#get original mean and sd value of parameters in the final model
			if(svalue(check_box)==TRUE){sd.fit<<-sqrt(diag(vcov(stepwise.model)));mean.fit<<-coef(stepwise.model)}else{sd.fit<<-sqrt(diag(vcov(full.model)));mean.fit<<-coef(full.model)}
			})

		CI_button<<-gbutton("Get GLM C.I.",cont = group4,handler= function(h,...){
			if(svalue(check_box)==TRUE){confint.model<<-confint(stepwise.model,level = 0.95)}else{confint.model<<-confint(full.model,level = 0.95)}
			print("## 95% Confidence Interval ##")
			print(confint.model)})}

		##if all goes well
		gmessage ("Model fitted successfully!" , title = "Model calibration")
		if(svalue(check_box)==TRUE){capture.output(summary(stepwise.model),file=paste(getwd(),"/outputs/best_model.txt",sep=""))}else{capture.output(summary(full.model),file=paste(getwd(),"/outputs/best_model.txt",sep=""))}
		counter2<<-counter2+1

		## section to choose a way to evaluate the model
		if(counter33==1){glabel("Select method for model evaluation: " , cont = group , anchor = c(-1,0))
		group96 <- ggroup(horizontal = TRUE, container=group)
		obj3_val<-gcombobox(c("ROC and AUC","pseudo-R2"), container=group96)}
		counter33<<-counter33+1
		evaluation_button<-gbutton("Evaluate your model",cont = group96, handler=function(h,...){
			
			#ROC curve + AUC
			if(svalue(obj3_val)=="ROC and AUC"){print("Started model evaluation...")
				if(svalue(check_box)==TRUE){fitted.values<-fitted(stepwise.model)}else{fitted.values<-fitted(full.model)}
				pred<-prediction(fitted.values,factor(train.data[,names(train.data)=="change_lc"]))
				perf<-performance(pred,"tpr","fpr")
				auc.data<-performance(pred,"auc")
				auc.model<<-slot(auc.data, "y.values")
				jpeg(paste(getwd(),"/outputs/roc.jpg",sep=""))
				plot(perf,colorize=TRUE,main=paste("AUC = ",auc.model,sep=""))
				print("ROC curve pasted into Outputs folder")
				dev.off()}
			
			#pseudo-R2
			if(svalue(obj3_val)=="pseudo-R2"){print("Started model evaluation...")
				if(svalue(check_box)==TRUE){print(paste("Pseudo-R2: ",1-(stepwise.model$deviance/stepwise.model$null.deviance),sep=""))}else{print(paste("Pseudo-R2: ",1-(full.model$deviance/full.model$null.deviance),sep=""))}
			}
		
			gmessage ("Model evaluation completed!" , title = "Goodness-of-fit")
			print("Please continue")

			## section to run future simulations
			if(counter3==1){
			counter3<<-counter3+1
			counter4<<-1
			btn_sim<-glabel("Start Model Simulations",cont=group,anchor=c(-1,0))
			font(btn_sim)<-list(family="times",size="large",weight="bold")
			group3<-ggroup(horizontal = TRUE, container=group)
			glabel("Choose number of iterations and time steps: ",cont = group3,anchor = c(-1,0))
			iterations<<-gedit("100", width = 5,container=group3,coerce.with=as.numeric)
			steps<<-gedit("1",width = 5,container=group3,coerce.with=as.numeric)
			parameters<<-c()
			group5 <- ggroup(horizontal = TRUE, container=group)
			simulations_button <- gbutton("Simulate Future/Past Land Cover Change",cont = group5, handler=function(h,...){
				
				lc1_cover<<-c()
				lc2_cover<<-c()
				results<<-c()
				defor_rate<<-c()
				coef_models<<-c()
				#get original mean and sd value of parameters in the final model
				if(svalue(check_box)==TRUE){sd.fit<<-sqrt(diag(vcov(stepwise.model)));mean.fit<<-coef(stepwise.model)}else{sd.fit<<-sqrt(diag(vcov(full.model)));mean.fit<<-coef(full.model)}

				#predict future change - start iterations loop
				for(iter in 0:(svalue(iterations)-1)){
					
					print(paste("Starting iteration: ",iter,sep=""))

					#reset to initial forest cover
					current_forest<<-original_data[,names(original_data)==svalue(dependent_check)]

					#random paramters - get a new sample of parameters every new iteration
					random_parameters<<-c()
					for(pp in 1:length(mean.fit)){
						#rnorm(1,mean.fit[pp],sd.fit[pp])
						random_par<<-mean.fit[pp]
						random_parameters<<-c(random_parameters,random_par)
					}				
					coef_models<<-rbind(coef_models,random_parameters)
					
					#reset data to predict	
					predictdata<<-original_data

					#start time steps loop
					for(tt in 0:(svalue(steps)-1)){

						print(paste("Starting time step: ",tt,sep=""))

						#get current forest cover
						lc1_cover<<-c(lc1_cover,sum(is.na(current_forest)==FALSE & current_forest==1));
						lc2_cover<<-c(lc2_cover,sum(is.na(current_forest)==FALSE & current_forest==0))
					

						#get probability of deforestation for new data
						predictdata[,names(predictdata)==svalue(dependent_check)]<<-current_forest
						if(svalue(check_box)==TRUE){stepwise.model$coefficients<-random_parameters;prob.defor<<-predict(stepwise.model, predictdata, type = "response")}else{full.model$coefficients<-random_parameters;prob.defor<<-predict(full.model, predictdata, type = "response")}
						rand.numb<<-runif(length(prob.defor))
						one_zero<<-ifelse(current_forest==1 & rand.numb<prob.defor,1,0)
						current_forest<<-ifelse(one_zero==1,0,current_forest)
						
						#update neighbourhood
						lc_sim_matrix<<-matrix(current_forest,nrow = num_rows,ncol = num_cols)
						lc_sim_raster<<-raster(ifelse(lc_sim_matrix==lc_neibs,1,0))
						neibsprevcalc<<-c(as.matrix(focal(lc_sim_raster,w=matrix(ws,ws),na.rm=TRUE)))
						predictdata$neibs0<<-ifelse(is.na(predictdata[,ncol(predictdata)])==FALSE & is.na(neibsprevcalc)==TRUE,0,neibsprevcalc)
				
						#export annual deforestation map
						one_zero<<-ifelse(one_zero==1,1,-9999)
						out<<-data.frame(one_zero,spatial.points)
						if(names(out)[2]=='x'){coordinates(out)=~x+y}else{coordinates(out)=~s1+s2} 
						gridded(out)=TRUE
						out.grid<<-as(out,"SpatialGridDataFrame")
						writeAsciiGrid(out.grid,paste(getwd(),"/outputs/predchange_i",iter,"_",tt,"yr.asc",sep=""),attr=1,na.value=-9999)
						rm(out)

						#calculate deforestation rate
						na_rm_defor<<-ifelse(is.na(one_zero),0,one_zero)
						defor_rate<<-c(defor_rate,sum(na_rm_defor==1))

					}
				}

				#export land cover change rates
				print("EXPORTING RATE OF CHANGE")
				seq_iter<<-sort(rep(0:(svalue(iterations)-1),(svalue(steps))))
				seq_tt<<-rep(0:(svalue(steps)-1),(svalue(iterations)))
				results<<-cbind(seq_iter,seq_tt,lc1_cover,lc2_cover,defor_rate)
				colnames(results)<<-c("Iteration","TimeStep","LandCover1","LandCover0","Change")
				write.csv(results,paste(getwd(),"/outputs/predicted_rates.csv",sep=""))

				#export annual and cumulative probability maps
				print("EXPORTING ANNUAL PROBABILITY MAPS")
				#annual probability map
				for(tt in 0:(svalue(steps)-1))
				{
					print(paste("Starting year ",tt,sep=""))
					alldef<<-ifelse(is.na(one_zero),0,0)
					for(iter in 0:(svalue(iterations)-1))
					{
						print(paste("Iteration ",iter,sep=""))
						defor<<-as.matrix(readAsciiGrid(paste(getwd(),"/outputs/predchange_i",iter,"_",tt,"yr.asc",sep="")))
						newdef<<-ifelse(is.na(defor),0,defor)
						alldef<<-alldef+newdef
					}
	
					#Add NoData values
					prob.year<<-c(alldef/svalue(iterations))

					#Export ascii map
					print("Exporting annual probability map in .ASC")
					prob.year<<-ifelse(is.na(c(land_cover_t1)),-9999,prob.year)
					out3<<-data.frame(prob.year,spatial.points)
					if(names(out3)[2]=='x'){coordinates(out3)=~x+y}else{coordinates(out3)=~s1+s2} 
					gridded(out3)=TRUE
					out.grid3<<-as(out3,"SpatialGridDataFrame")
					writeAsciiGrid(out.grid3,paste(getwd(),"/outputs/probyear",tt,".asc",sep=""),attr=1,na.value=-9999)
					rm(out3)
				}


				#get cumulative deforestation probability
				sum.prob<<-ifelse(is.na(land_cover_t1),0,0)
		
				print("EXPORTING CUMULATIVE PROBABILITY MAPS")
				#Load probability maps from 2002 to 2050
				for(tt in 0:(svalue(steps)-1))
				{
					print(paste("Starting year ",tt,sep=""))
					data2<<-as.matrix(readAsciiGrid(paste(getwd(),"/outputs/probyear",tt,".asc",sep="")))
					newdata<<-ifelse(is.na(data2),0,data2)

					sum.prob<<-sum.prob+newdata
					sum.vec<<-c(sum.prob)
				
					#Export ascii map
					print("Exporting final map in .ASC")
					sum.vec<<-ifelse(is.na(c(land_cover_t1)),-9999,sum.vec)
					out4<<-data.frame(sum.vec,spatial.points)
					if(names(out4)[2]=='x'){coordinates(out4)=~x+y}else{coordinates(out4)=~s1+s2} 
					gridded(out4)=TRUE
					out.grid4<<-as(out4,"SpatialGridDataFrame")
					writeAsciiGrid(out.grid4,paste(getwd(),"/outputs/cumprobyr",tt,".asc",sep=""),attr=1,na.value=-9999)
					rm(out4)

				}
				

				if(svalue(check_box)==TRUE){colnames(coef_models)<-names(stepwise.model$coefficients)}else{colnames(coef_models)<-names(full.model$coefficients)}
				write.csv(coef_models,paste(getwd(),"/outputs/coefficients.csv",sep=""),row.names=FALSE)
				gmessage ("Simulations finished! Please check results" , title = "Future simulations")
				

				#add buttons to visualize results
				#plot rates
				#Error bar function
				error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
					if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
					stop("vectors must be same length")
					arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
				}
				ylabelvec<<-c("Land Cover 1","Land Cover 0","Change")

				if(counter4==1){rates_button<- gbutton("Rates (barplot)" , cont = group5,handler = function(h,...){ 
					par(oma=c(2,2,2,2),mar=c(5,5,4,4),mfrow=c(1,3))
					for(nn in 1:3){
						mean.values<<-tapply(results[,nn+2],results[,2],mean)
						CI.values<<-1.96*(tapply(results[,nn+2],results[,2],sd)/sqrt(100))	
						barx<<-barplot(mean.values,beside=T,ylim=c(0,max(mean.values+CI.values)),axis.lty=1, xlab="Time Step", ylab=paste("Average Number of pixels of ",ylabelvec[nn]," (95% C.I.)",sep=""),cex.axis=1.2,cex.lab=1.2)
						error.bar(barx,mean.values,CI.values)
		
					}
				})}
				
				#see cumulative deforestation probability
				if(counter4==1){see_cum_prob_data <- function(){
					par(oma=c(2,2,2,2),mar=c(5,5,4,4),mfrow=c(1,1))
					for(i in 0:(svalue(steps)-1))
					{
						prob_to_plot<-readAsciiGrid(paste(getwd(),"/outputs/cumprobyr",i,".asc",sep=""),as.image=T,plot.image = TRUE)
						par(ask=TRUE)

					}
				}
				outputs_button<- gbutton("Probability Maps" , cont = group5,handler = function(h,...) see_cum_prob_data())}
				
				
				


			#section to validate model outputs
			if(counter4==1){
			btn_val<-glabel("Model Output Validation",cont=group,anchor=c(-1,0))
			font(btn_val)<-list(family="times",size="large",weight="bold")
			glabel ("Select method(s) for validation: " , cont = group , anchor = c(-1,0))
			obj5_val<<- gcheckboxgroup(c("PMOC (on change)","Confusion Matrix"),checked = FALSE, container=group)
			group91<-ggroup(horizontal = TRUE, container=group)
			spin_button<-gspinbutton(from = 0, to = 50,by = 1,value = 1,container = group91, width=5)
			validation_button<- gbutton("Start Validation" , cont = group91,handler = function(h,...){
			for(v in 1:svalue(spin_button))
					{						
						ginput("Please insert file path, including file name and extension (.asc):",icon="info",handler=function(h,...){val_file<<-h$input})
						print(paste("Starting time step: ",v,sep=""))
						obs02<<-as.matrix(readAsciiGrid(paste(val_file,sep="")))
						def02<<-ifelse(is.na(obs02),0,obs02*2)					

						if("PMOC (on change)"%in%svalue(obj5_val)){
							percmatch<-c()
							percomiss<-c()
							perccomis<-c()

							percMvec<-c()
							percOvec<-c()
							percCvec<-c()
							Mvec<-c()
							Ovec<-c()
							Cvec<-c()

							for(i in 0:(svalue(iterations)-1)){

								print(paste("Starting iteration: ",i+1,sep=""))
									
								#Import predicted data
								pred02<-as.matrix(readAsciiGrid(paste(getwd(),"/outputs/predchange_i",i,"_",v,"yr.asc",sep="")))
								preddef02<-ifelse(is.na(pred02),0,pred02)
	
								#Calculate match, omission, comission
								results_pmoc<<-def02-preddef02

								M<-sum(results_pmoc==1)
								O<-sum(results_pmoc==2)
								C<-sum(results_pmoc==-1)
	
								Mvec<-c(Mvec,M)
								Ovec<-c(Ovec,O)
								Cvec<-c(Cvec,C)

								total<-M+O+C

								percM<-(M/total)*100
								percO<-(O/total)*100
								percC<-(C/total)*100

								percMvec<-c(percMvec,percM)
								percOvec<-c(percOvec,percO)
								percCvec<-c(percCvec,percC)

							}

							percmatch<-cbind(percmatch,percMvec)
							percomiss<-cbind(percomiss,percOvec)
							perccomis<-cbind(perccomis,percCvec)

						}
						#Export values
						write.csv(percmatch,paste(getwd(),"/outputs/annperfmatch.csv",sep=""))
						write.csv(perccomis,paste(getwd(),"/outputs/anncomission.csv",sep=""))
						write.csv(percomiss,paste(getwd(),"/outputs/annomission.csv",sep=""))
						gmessage ("Validations finished! Please check results" , title = "Validatons")

						#include confusion matrix in the next version		
						if("Confusion Matrix"%in%svalue(obj5_val)){gmessage ("Confusion matrix not yet available...",title = "Available soon!")}
		
					}

				
				})
				counter4<<-counter4+1}

			})}

		})
	
	})

})

})
font(oneT_button)<-c(color="blue",style="bold")
size(oneT_button)<-c(150,120)

# MORE THAN ONE TRANSITION - no competition 
midT_button<-gbutton(">1 Transition \n (no competition)",cont=group_mm2,handler=function(h,...) gmessage("This section is still being developed... ", icon="warning", title = "Coming Soon!"))
font(midT_button)<-c(color="blue",style="bold")
size(midT_button)<-c(150,120)


# MORE THAN ONE TRANSITION - with competition 
lastT_button<-gbutton(">1 Transition \n (with competition)",cont=group_mm2,handler=function(h,...) gmessage("This section is still being developed... ", icon="warning" , title = "Coming Soon!"))
font(lastT_button)<-c(color="blue",style="bold")
size(lastT_button)<-c(150,120)

# text at the bottom of main menu
btn3<-glabel("Any queries, please e-mail: info@stocmodlcc.net \n or visit http://stocmodlcc.net/",cont=group_mm,anchor=c(-1,0))
font(btn3)<-list(family="times",size="medium",weight="bold",style="italic")







