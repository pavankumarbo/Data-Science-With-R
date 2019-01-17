# Imputing Missing Values in R
**1.Should the missing values be imputed?** </br>
    Yes.</br> Historically, replacing missing values has been dealt in experiments and surveys. During surveys, Whenever possible,  missing values are filled with estimated values to completely analyze the data. Often, the variable with missing values is too important to ignore and needs imputed values for proper analysis.</br>
    The challenge is to estimate missing values that won't introduce new bias to the variable due to the values being imputed. Statisticians have developed many methods to solve this challenge.</br>
    Since R language is specially designed for statistical computing, it lets us use these statistical methods invented to deal with missing values for data science purposes. Imputing with python will be dealt in different gist.</br>
    We will discuss some basic methods and popular packages in R that are used to imput missing values.</br>

**2.Demo DataSet**</br>
    I created a dataset to demonstrate imputing of missing values. We have variables *personId*, *Gender*, *Age*, *Income*, *ITRCompliance*. </br>
    personId is a random value. Gender, Age, Income are assumed to be reported by the person in a form, and ITRCompliance is supposedly the data we have regarding if a person has complied with filing Income Tax Returns or not.</br>
  ![dataset](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/dataset.png)</br>

**3.Can we just remove the missing values?**</br>
  Removing values might lead to missing of information. But, if you chose to remove missing values from the dataset, there are different ways to do so to preserve as much information as possible. </br>
1.**List-Wise Deletion** which says remove all the rows that are incomplete. The disadvantage of this method is that , there is a risk of losing either information or  losing statistical power of the learning algorithm or both.</br>
2.**Pair-wise Deletion** which says remove missing values only from the variables of interest, which inturn means that we will have different sample sizes when we change our variables of interest.For example, in our dataset, if Age and gender are our variables of interest, we remove missing values only from these variables, when we are applying leanring algorithm on say income and ITRCompliance, we remove missing values from these variables.This might preserve more data than list-wise deletion but makes analysis complex.
  
**4.Can we impute any data?**</br>
  No. Imputing data is not a trivial solution. There is a very high risk of introducing bias when imputed data adds false meaning to the data. The Missing data is classified into three categories and only one category of data(*Missing at Random*) can be imputed without inducing significant bias.
They are:</br>

**4.1.Missing Not at Random** </br>
    To diagnose this type of data, one needs to have domain knowledge in the area of dataset,
  This type of missing occurs when only a certain interval of all possible values of a variable are observed ,i.e; the missing values are  from different interval of the possible values than those that are observed.</br>
  For example, in this [dataset](https://github.com/TrueCoder1/Data-Science-With-R/blob/master/data/nmar.csv), we can see 247 values of variable *Income* are missing and if we somehow know with high confidence that the missing  values are actually in the higher income category(i.e in the third quartile or right to that) but are missing in dataset. Then this type of missing is **Not Missing at Random**. In other words, missing values of Income variable are because of the high values fo income itself and doesnt depend on any other variable or observed values of Income.</br>
  ![nmarData](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/nmarIncome.png)</br>
  One needs to have domain knowledge to say that missing values are actually a particular category of that variable. These missing values are generally cannot be imputed using statistical methods.</br>
  We need to deal this type of data with either list-wise deletion, pair-wise deletion or removing the variabe itself. Analyst should decide which of these methods to use, to retain the value of the data as much as possible.</br>
  Although, you are free to explore selection models(heckman) and pattern mixture models if you badly feel the need to impute the variable with this missing type of data.</br>

**4.2.Missing Completely at Random**</br>
This type of missing mechanism occurs when missing values are not *Not Missing at Random* and there is no particular pattern in missingness of data.</br>
  For example, In this [dataset](https://github.com/TrueCoder1/Data-Science-With-R/blob/master/data/mcar.csv), we can see that the missing values in variables *Age*, *Income* are not dependent on observed data of any other variable . Both Male and Female have equal share of missing *Age* values and hence there is no pattern or dependency in missingness of data. We should rule out *NMAR* case if we know that missing values of age are not because of either age being high value or low value.</br>
  ![mcarFemaleData](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/mcarFemaleAge.png)
  ![mcarMaleData](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/mcarMaleAge.png)</br>
  
  Formal statistical methods cannot impute this type of missingness. We know that using list-wise deletion or pair-wise deletion introduces bias to the dataset. But we can use list-wise deletion to deal with this type of missing mechanism, becausemissingness is not associated with particular values of other variables and hence, there wont be great bias, provided, missing data is relatively small compared to dataset size.</br>
  
**4.3.Missing At Random**</br>
  This type of missing mechanism is most commonly solved by statistical methods. To diagnose this type of data, We need to confirm first that the mechanism is not _Missing Not at Random_. And then we check if there is a pattern in the missing data such that, missing data is dependent on the values that are observed(non NA).</br>
  For example, in this [dataset](https://github.com/TrueCoder1/Data-Science-With-R/blob/master/data/mar.csv), we can see that 30% of females did not report their age where as all males have reported their age. If we are confident that ages of females who didn't report thier age is not out of range of interval of ages of females who have reported, we can eliminate the possibility of *Not Missing at Random* case. Since we see a pattern that missing values of "Age" are dependent on observed gender values(Female), we can rule out *MCAR* case and say that the missing mechanism is *Missing at Random* </br>.
  ![marData](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/marAge.png)</br>
  
  
**5.After checking for missingness type, How to impute?**

There are some simple single imputing algorithms like:</br>
  **5.1.Mean Substitution** for continuous variables, which  means that substitute the missing values using mean. The disadvantage of this method is that it indtroduces bias as you can see from the following plot that it decrease variance introduces bias to the covariance matrix and brings the estimates of correlation coefficients between variables close to zero
  ![meanSubsitution](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/meanImpute.png)</br>
  
  **5.2.Mode Substitution** for ordinal and nominal(categorical) variables. This method has same disadvantages as *Mean Substitution* method.
  
  **5.3.Linear Regression** can also be used to impute missing values of continuous variables, but again this too decreases the variance within the data.
  
  
  More single imputation methods like *Iterative regression Imputation* ,  *Hot Deck Match Imputation*, *Routine Multivariate Imputation* can be found in this [notes](http://www.stat.columbia.edu/~gelman/arm/missing.pdf) in detail.
  
  
  The better solution is to use multiple Imputations
  We will discuss three R packages **MICE**, **Amelia** and **Hmisc** that use multiple imputation and require missigness to be of type *Missing at Random*. There are other packages too like **mi** and **missForest** that you can explore.
  
  
  **5.4.Imputation using MICE**
  
  MICE is Multiple Imputations using Chained Equations. As the name suggestes it creates m multiple imputed datasets using       conditional probability joint distributions and the algorithm converges in less number of iterations than Markov Chain         Monte Carlo Simulations.</br>
  
  The mice package in R is implemented as follows:</br>
  1. Remove all categorical variables from dataframe before passing to mice() function because it deals only with continupus        variables</br>
  2. Choose maxit(number of iterations needed to converge).The higher the "maxit", the better probability that the algorithm        converges.Beware of the computational costs.</br>
  3. Choose m(number of imputed datasets). The higher the number, the better the coefficient estimates of the predictor              variables using complete datasets(during pooling)</br>
  
  imputed_result <- mice(marData[,c("Income","Age","Gender","ITRCompliance")],m=5,maxit = 10, nnet.MaxNWts = 3000)
  
  To Analyze the how well mice has imputed multiple datasets:</br>
  ```
  stripplot(imputed_result,pch=20,cex=1.2)
  ```
  ![stripplot](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/stripplot.png)</br>
  ```
  densityplot(imputed_result)
  ```
  ![densityplot](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/densityplot.png)</br>
  ```
  xyplot(imputed_result,Age~Gender)</br>
  ```
  ![xyplot](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/xyplot.png)</br>
  
  To get complete imputed dataset:</br>
  ```
  complete(imputed_result)
  ```
  
  If you choose a particular imputed dataset:</br>
  ```
  complete(imputed_result,2)
  ```
  
    
  Data modelling using Mice is as follows:</br>
  1.Use mice() to generate multiple imputed datasets</br>
  2.Use with() to apply different models and analyze multiple datasets</br>
  3.Use pool() to merge the results of analyzing the multiple imputed datasets</br>
  
  To model the data using multiple imputed datasets:</br>
  regressed_result <- with(imputed_result,lm(Age~Gender))
  
  
  To pool multiple results from above step:
  ```
  pooled_result <- pool(regressed_result)
  summary(pooled_result)
  ```
  ![micesummaryregressed](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/miceRegressedResult.png)</br>
  MICE can also be used with MNAR data with some additional work.Given that the model fitted for imputed dataset is wrong for   missing cases due to MNAR, MICE provides a feature to alter the results of imputations according to the pattern in wrongness   of the model for missing cases. This is enabled using post argument(means post processing). More details can be found at:     section 6.2 of this [paper](https://www.jstatsoft.org/article/view/v045i03/v45i03.pdf)
  
  **5.5Imputation using Amelia**
  Amelia is developed by Gary King.There are two versions of Amelia, we will discuss about the latest one.
  The Algorithm used in Amelia uses EMB(Bootstrapped Expectation Maximization) algorithm which bootstraps(sample with replacement) the dataset, creating functions for expectations of log-likelihood(Expectation step) and finally maximises the expectation functions to estimate the distribution of complete case dataset.</br>
  
  To implement Amelia in R:</br>
  1. Keep a note of nominal(categorical) variables and pass into noms argument of amelia() function because amelia too like mice() imputes only continous variables.
  2. Exclude id variables from imputation algorithm by pass id column to argument idvars
  3. Choose m(number of imputed datasets). The higher the number, the more choices of complete imputed datasets to choose from</br>
  amelia_impute <- amelia(marData,m=5,parallel="multicore",noms=c("Gender","ITRCompliance"),idvars="userId")</br>
  
To get complete imputed dataset:</br>
```
amelia_impute$imputations[[5]]
```
![ameliaImputed](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/AmeliaImputeValues.png)</br>

 Data modelling with Amelia using all of the Multiple imputed datasets:</br>
 Similar to mice, if we want to perform analysis on all imputed datasets, we need to import and use "zelig" lbrary, and then:</br>
 ```
 amelia_regressed<- zelig(Income~Age, data=amelia_impute$imputations, model="normal")</br>
 ```
 ![ameliaRegressed](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/AmeliaRegressed.png)</br>
 check [zelig](http://docs.zeligproject.org/articles/index.html#section-core-zelig-model-details) for models to chose from.</br>
  
  
  **5.6.Imputation using Hmisc**
   Using Hmisc is probably simplest use of all other packages discussed. The major advantage of hmisc is that it's *aregimpute* can impute catagorical values also, which mice and amelia can not.
   
   The hmisc pckage is implemented as follows:</br>
   1.Choose n.impute, the higher the number, more imputed datasets are available to pick the best from.</br>
   2.choose method, either "pmm" for both categorical and continuous or "regression" for numerical values</br>
   ```
   hmisc_impute <- aregImpute(data=marData,n.impute=5,formula = ~Gender+Age+ITRCompliance+Income)</br>
   ```
   
   To see imputed values:</br>
   ```
   hmisc_impute$imputed
   ```
   ![hmiscImputed](https://raw.githubusercontent.com/TrueCoder1/Data-Science-With-R/master/images/hmiscImputeSummary.png)
