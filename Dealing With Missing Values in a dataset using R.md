# Imputing Missing Values in R
**Should the missing values be imputed?** \n
Yes. Historically replacing missing values has been dealt in experiments and surveys. During surveys, Whenever possible, missing values are filled to completely analyze the data.
The challenge is to estimate missing values that won't introduce new bias to the variable due to the values being imputed. Statisticians have developed many methods to solve this challenge.
Since R language is specially designed for statistical computing, it lets us use these statistical methods invented to deal with missing values for data science purposes. Imputing with python will be dealt in different gist.
We will discuss some basic methods and popular packages in R that are used to imput missing values.

**DataSet**
I created a dataset to demonstrate imputing of missing values. 
We have variables *personId* *Gender* *Age* *Income* *ITRCompliance*. 
personId is a random value. Gender, Age, Income are assumed to be reported by the person in a form, and ITRCompliance is supposedly the data we have regarding if a person has complied with filing Income Tax Returns or not.

**Can we impute any data?**
No. Imputing data is not a trivial solution. There is a very high risk of introducing bias when imputed data adds false meaning to the data. The Missing data is classified into three categories and only one category of data can be imputed.
They are:
1.**Missing Not at Random** 
  To diagnose this type of data, one needs to have domain knowledge in the area of dataset,
  This type of missing occurs when only a certain interval of all possible values of a variable are observed ,i.e; the missing values are  from different interval of the possible values than those that are observed.
  For example, in our dataset, we can see approximately 60% values of variable *Compliance* are *Complied* and 10% are *Not Complied* and 30% are *NA*. Now if we somehow know with high probability that 30% values are actually *Not Complied* values but are missing in dataset. Then this type of missing is **Not Missing at Random**.
  One need to have domain knowledge to say that missing values are actually a particular category of that variable. These missing values are not imputed using statistical methods.
  We need to deal this type of data with either list-wise deletion, pair-wise deletion or removing the variabe itself. Analyst should decide which of these methods keeps the value of the data as much as possible.
  Although you are free to explore selection models(heckman) and pattern mixture models if you badly feel the need to impute this type of data.
2.**Missing At Random**
3.**Missing Completely at Random**
