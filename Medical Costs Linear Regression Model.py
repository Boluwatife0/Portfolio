#!/usr/bin/env python
# coding: utf-8

# In[40]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import linear_model
import seaborn as sns


# In[2]:


df = pd.read_csv("insurance.csv")
df


# In[3]:


df.info()


# In[4]:


df_numerized = df

for col_name in df_numerized.columns:
    if (df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized


# In[5]:


df.age.median()


# In[6]:


df.head(20)


# In[7]:


df.bmi.median()


# In[8]:


df.children.median()


# In[9]:


df.charges.median()


# In[10]:


#Define X and Y


# In[11]:


x = df.drop(['charges'], axis = 1).values
y = df['charges'].values


# In[12]:


print(x)


# In[13]:


print(y)


# In[14]:


# Split data into training and test set


# In[15]:


x.shape, y.shape


# In[16]:


#Data Split


# In[17]:


from sklearn.model_selection import train_test_split
x_train, x_test, y_train, y_test = train_test_split(x,y,test_size=0.2, random_state=0)


# In[18]:


# Data Dimension


# In[19]:


x_train.shape, y_train.shape


# In[20]:


x_test.shape, y_test.shape


# In[21]:


# Train the model on the training set


# In[22]:


from sklearn import linear_model 
from sklearn.metrics import mean_squared_error, r2_score


# #Build linear regression model

# In[23]:


model = linear_model.LinearRegression()


# In[24]:


# Built training model


# In[25]:


model.fit(x_train,y_train)


# In[ ]:


# Prediction Results


# In[26]:


y_pred = model.predict(x_test)


# In[31]:


print('Coefficients:', model.coef_)
print('Intercept:', model.intercept_)
print('Mean squared error (MSE): %.2f'
     % mean_squared_error(y_test, y_pred))
print('Coefficient of determination (R^2): %.2f'
      % r2_score(y_test, y_pred))


# In[32]:


df.columns.values


# In[33]:


# String Formatting  ---by default r2_score returns a floating number 


# In[34]:


r2_score(y_test, y_pred)


# In[35]:


r2_score(y_test, y_pred).dtype


# In[36]:


#Make the Scatter Plot


# In[37]:


y_test


# In[38]:


y_pred


# In[41]:


sns.scatterplot(y_test,y_pred)


# In[42]:


sns.scatterplot(y_test,y_pred, marker = "+")


# In[43]:


sns.scatterplot(y_test,y_pred, alpha = 0.5)


# In[ ]:


L

