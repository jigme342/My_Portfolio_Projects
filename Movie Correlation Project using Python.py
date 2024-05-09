#!/usr/bin/env python
# coding: utf-8

# In[125]:


#Import Libraries

import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create

#Read in the data

df = pd.read_csv(r'C:\Users\jigme\Downloads\movies.csv')


# In[126]:


# Lets look at the data

df.head()


# In[127]:


# Lets see if there is any missing data

missing_values = df.isna().any()

#Handle missing data

df.fillna(0, inplace=True)



# In[128]:


# Data types for our columns

df.dtypes


# In[129]:


#Change data type of our budget and gross columns


df['budget'] = df['budget'].astype('int64')

df['gross'] = df['gross'].astype('int64')


# In[130]:


df.head()


# In[131]:


#Create correct year column

df['correctyear'] = df['released'].astype(str).str.extract(r'(\d{4})')
df.head()


# In[132]:


#Sort values by gross 

df = df.sort_values(by=['gross'],inplace=False, ascending=False)


# In[133]:


#Looking at the whole data

pd.set_option('display.max_rows', None)


# In[134]:


#Drop any duplicates

df.drop_duplicates()


# In[135]:


df.head()


# In[136]:


# Assuming Budget has high correlation
# Assuming Company has high correlation


# In[137]:


#Scatter plot with budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Budget per film')

plt.ylabel('Gross Earnings')

plt.show()


# In[138]:


df.head()


# In[139]:


# Plot the budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "red"},line_kws={"color":"blue"})


# In[140]:


#Lets start looking at correlation
numeric_df = df.select_dtypes(include='number')

numeric_df.corr()

# High Correlation between budget and gross


# In[141]:


#Looking at correlation visually

correlation_matrix = numeric_df.corr()
sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')



plt.show()


# In[142]:


# looking at Company 

df.head()


# In[143]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized.head()


# In[144]:


correlation_matrix = df_numerized.corr()
sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')



plt.show()


# In[145]:


df_numerized.corr()


# In[146]:


correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()
corr_pairs


# In[147]:


sorted_pairs = corr_pairs.sort_values()
sorted_pairs


# In[148]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]
high_corr


# In[149]:


# Votes and Budget have the highest correlation to gross earnings
#Company has low correlation

