importPackages <- function(args){
  installed.packages <- installed.packages()
  required.packages <- args
  
  packages.to.install <- setdiff(required.packages,installed.packages)
  install.packages(packages.to.install)
  sapply(required.packages,library,character.only=TRUE)
}

setwd(getwd())
importPackages(c("mice","Zelig","lattice","ggplot2","VIM","missForest","Hmisc","Amelia"))


marData <- read.csv("data/mar.csv")
mcarData <- read.csv("data/mcar.csv")
nmarData <- read.csv("data/nmar.csv")

summary(nmarData[,'Income'])

summary(mcarData[mcarData$Gender=="Male","Age"])
summary(mcarData[mcarData$Gender=="Female","Age"])

summary(marData[marData$Gender=="Male","Age"])
summary(marData[marData$Gender=="Female","Age"])



mean(marData[!is.na(marData$Age),'Age'])
##filling with mean
marData[is.na(marData$Age),'Age'] <- mean(marData[!is.na(marData$Age),'Age'])

qplot(seq_along(marData$Age), marData$Age,xlab = "Index",y_lab="Age")


##filling with regression
marData[is.na(marData$Age),'Age'] <- mean(marData[!is.na(marData$Age),'Age'])

ggplot(nmarData,aes(Age,Gender))+geom_jitter()
##filling with Linear Regression
#check pattern using md.pattern from mice
md.pattern(mcarData)
md.pattern(nmarData)
md.pattern(marData)


#use aggr from VIM to check pattern and number of missing values
aggr(mcarData,col=c("Blue","Red"),numbers=TRUE,labels=names(mcarData), cex.axis=.7,sortVars=TRUE,sortCombs=TRUE,only.miss=TRUE,combined=FALSE)


#use margin matrix from VIM
marginmatrix(marData)
marginmatrix(mcarData)
marginmatrix(nmarData)

#use scattmatrixMiss from VIM
scattmatrixMiss(mcarData)
scattmatrixMiss(nmarData)


marData <- read.csv("mar.csv")
mcarData <- read.csv("mcar.csv")
nmarData <- read.csv("nmar.csv")

#Imputing using mice
imputed_result <- mice(marData[,c("Income","Age","Gender","ITRCompliance")],m=5,maxit = 10, nnet.MaxNWts = 3000)
xyplot(imputed_result,Income~ITRCompliance)
stripplot(imputed_result,pch=20,cex=1.2)
densityplot(imputed_result)
complete(imputed_result)
complete(imputed_result,2)

regressed_result <- with(imputed_result,lm(Age~Gender))
mice_impute <- complete(imputed_result)
summary(mice_impute[mice_impute$Gender=="Female","Age"])
summary(pool(regressed_result))

#Imputing using Amelia
amelia_impute <- amelia(marData,m=5,parallel="multicore",noms=c("Gender","ITRCompliance"),idvars="userId")
summary(amelia_impute$imputations[[5]])

amelia_regressed<- zelig(Age~Gender, data=amelia_impute$imputations, model = "normal")
summary(amelia_regressed)

#Imputing using hmisc
hmisc_impute <- aregImpute(data=marData,n.impute=5,formula = ~Gender+Age+ITRCompliance+Income)
summary(hmisc_impute$imputed$Income[,1])
