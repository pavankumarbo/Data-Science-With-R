import csv
import numpy as np
import pandas as pd
import random
import sys

class DataGenerator:
	def __init__(self):
		pass

	def __getBaseDF(self):
		userId = ['user'+str(i) for i in np.arange(1000)]
		Gender = np.random.choice(['Male','Female'],1000)
		Age = [np.floor(x) for x in np.random.normal(40,10,1000)]
		ITRCompliance = np.random.choice(['Complied','NotComplied'],1000)
		Income = [np.floor(x) for x in np.random.normal(40000,10000,1000)]
		df = pd.DataFrame()
		df['userId'] = userId
		df['Gender'] = Gender
		df['Age']  = Age
		df['ITRCompliance'] = ITRCompliance
		df['Income'] = Income
		return df

##Females not reporting age and Compliance not being reported for high income people
	def __getmarData(self):
		df = self.__getBaseDF()
		df.loc[df['Gender']=='Female','Age'] = df[df['Gender']=='Female']['Age'].apply(lambda x: np.random.choice(['NA',x]))
		df.loc[df['ITRCompliance']=='NotComplied','Income'] = df[df['ITRCompliance']=='NotComplied']['Income'].apply(lambda x: np.random.choice(['NA',x]))
		return df

##Data is randomly missing for age , income and values
	def __getmcarData(self):
		df = self.__getBaseDF()
		df.loc[np.random.choice(range(1,len(df)),150),'Age']= 'NA'
		df.loc[np.random.choice(range(1,len(df)),150),'Income']= 'NA'
		return df
##High income people are not reportin their income itself.
	def __getnmarData(self):
		df = self.__getBaseDF()
		#ITRCompliance = np.random.choice(['Complied','NotComplied','NA'],100,p=[0.6,0.1,0.3])
		df.loc[df['Income']>40000,'Income'] = df[df['Income']>40000]['Income'].apply(lambda x: np.random.choice(['NA',x]))
		#df['ITRCompliance'] = ITRCompliance
		return df



	def getCSV(self,*args):
		if args[0][1] == 'mar':
			data = self.__getmarData()
			data.to_csv("mar.csv", encoding='utf-8', index=False)
		elif args[0][1] == 'nmar':
			data = self.__getnmarData()
			data.to_csv("nmar.csv", encoding='utf-8', index=False)
		elif args[0][1] == 'mcar':
			data = self.__getmcarData()
			data.to_csv("mcar.csv", encoding='utf-8', index=False)
		else:
			data = self.__getBaseDF()
			data.to_csv("missing.csv", encoding='utf-8', index=False)
			
dg = DataGenerator()
dg.getCSV(sys.argv)
