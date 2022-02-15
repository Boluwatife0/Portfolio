#!/usr/bin/env python
# coding: utf-8

# In[1]:


# Context
This dataset contains 15,977 survey responses with 24 attributes describing how we live our lives.
get_ipython().set_next_input('How can we reinvent our lifestyles to optimize our individual wellbeing while supporting the UN Sustainable Development Goals');get_ipython().run_line_magic('pinfo', 'Goals')

Content
Your Work-Life Balance survey evaluates how we thrive in both your professional and personal lives: it reflects how well you shape your lifestyle, habits and behaviors to maximize your overall life satisfaction along the following five dimensions:
1. Healthy body, reflecting your fitness and healthy habits;
2. Healthy mind, indicating how well you embrace positive emotions;
3. Expertise, measuring the ability to grow your expertise and achieve something unique;
4. Connection, assessing the strength of your social network and your inclination to discover the world;
5. Meaning, evaluating your compassion, generosity and how much 'you are living the life of your dream'.
This is the link to the survey.

Inspiration
get_ipython().set_next_input('Which new insights can we extract to reinvent our lifestyles and optimize our individual wellbeing');get_ipython().run_line_magic('pinfo', 'wellbeing')
get_ipython().set_next_input('What are the strongest correlations between the various dimensions');get_ipython().run_line_magic('pinfo', 'dimensions')
get_ipython().set_next_input('What are the best predictors of a balanced life');get_ipython().run_line_magic('pinfo', 'life')


# In[1]:


import numpy as np

import pandas as pd

import matplotlib
from matplotlib.pyplot import figure
import matplotlib.pyplot as plt
plt.style.use('ggplot')

import seaborn as sns

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjust the configuration of the plots we create


# In[2]:


# convert excel file to csv

read_file = pd.read_excel (r'/Users/boluogunle/Desktop/Wellbeing_and_lifestyle_data_Kaggle.xlsx')
read_file.to_csv (r'/Users/boluogunle/Desktop/wellbeing_and_lifestyle.csv', index = None, header=True)


# In[3]:


# Load dataset

lifestyle = pd.read_csv('/Users/boluogunle/Desktop/wellbeing_and_lifestyle.csv')


# In[4]:


lifestyle


# In[5]:


new_header = lifestyle.iloc[0] #grab the first row for the header
lifestyle = lifestyle[1:] # takes the data as the header row
lifestyle.columns = new_header #set the header row as the lifestyle header


# In[6]:


lifestyle


# In[7]:


lifestyle.info()


# In[8]:


lifestyle.WEEKLY_MEDITATION.dtype


# In[9]:


lifestyle.Timestamp.dtype


# In[10]:


lifestyle['WEEKLY_MEDITATION'].astype(int)


# In[11]:


lifestyle['Timestamp'].astype(str)


# In[12]:


lifestyle['Timestamp'] = lifestyle['Timestamp'].astype('datetime64[ns]')


# In[13]:


lifestyle.info()


# In[14]:


#changing the invalid value of the 'DAILY_STRESS' column to 0
lifestyle['DAILY_STRESS'] = lifestyle['DAILY_STRESS'].replace(['1/1/00'],'0')


# In[15]:


#Altering the dtype of the columns 
lifestyle = lifestyle.astype({'FRUITS_VEGGIES': 'int64', 'DAILY_STRESS': 'int64', 'PLACES_VISITED': 'int64', 'CORE_CIRCLE': 'int64', 'SUPPORTING_OTHERS':'int64', 'SOCIAL_NETWORK':'int64', 'ACHIEVEMENT':'int64', 'DONATION':'int64','BMI_RANGE':'int64', 'TODO_COMPLETED':'int64', 'FLOW':'int64','DAILY_STEPS':'int64', 'LIVE_VISION':'int64', 'SLEEP_HOURS':'int64', 'LOST_VACATION':'int64', 'DAILY_SHOUTING':'int64', 'SUFFICIENT_INCOME':'int64', 'PERSONAL_AWARDS':'int64', 'TIME_FOR_PASSION':'int64', 'WEEKLY_MEDITATION':'int64', 'WORK_LIFE_BALANCE_SCORE':'float64','AGE':'str'})


# In[16]:


lifestyle.info()


# In[17]:


# setting the datetime as the index
#lifestyle.set_index('Timestamp', inplace = True)


# In[18]:


lifestyle.describe()


# In[19]:


lifestyle.sort_index(inplace=True)


# In[20]:


lifestyle = lifestyle.sort_values(by=['WORK_LIFE_BALANCE_SCORE'], inplace=False, ascending=False)


# In[21]:


# printing the full set of data instead of having dots to represent the large amounts
#pd.set_option('display.max_rows', None)


# In[22]:


lifestyle


# In[23]:


gender_count = lifestyle['GENDER'].value_counts()


# In[24]:


# Pie plot for male and female Participants.

plt.figure(figsize=(12,6))
plt.title("Gender Distribution")
plt.pie(gender_count, labels=gender_count.index, autopct='%1.1f%%', startangle=150, shadow=True)


# In[25]:


plt.figure(figsize=(12,6))
plt.title('Age distribution of the Male and Female Participants.')
plt.xlabel('Age')
plt.ylabel('Number of Participants')
plt.hist(lifestyle['AGE'])


# In[26]:


#Predictions
# I believe that the more the people meditate, the higher their worklife balance score will be
# I believe the more Fruits and veggies you eat, the higher your work life balance score will be
# I think that the higher the core circle of the individual, the lower the work life balance score will be
# the higher the daily stress, the lower the work life balance score will be
# I think all the columns listed above will have a high correlation.


# In[27]:


# Scatter plot with Meditation with work life balance score

plt.scatter(x=lifestyle['WEEKLY_MEDITATION'], y=lifestyle['WORK_LIFE_BALANCE_SCORE'])

plt.title('Meditation vs Work life balance')

plt.xlabel('Meditation')

plt.ylabel('Work life balance score')

plt.show()


# In[28]:


lifestyle.head()


# In[29]:


# Plot Meditation vs Work life balance

sns.regplot(x='WEEKLY_MEDITATION', y='WORK_LIFE_BALANCE_SCORE', data=lifestyle, scatter_kws={'color':'black'}, line_kws={'color':'red'})
# has a correlation of 0.416171


# In[30]:


lifestyle.head()


# In[31]:


# lets start looking at correlation


# In[32]:


lifestyle.corr(method='pearson') # pearson, kendall, spearman


# In[33]:


# High correlation between meditation and work life balance score
# the correlation is 0.416171 or 0.42, this is not a high correlation, however there is a correlation 
# so I was right.


# In[58]:


# Correlation matrix
correlation_matrix = lifestyle.corr(method='pearson')

plt.figure(figsize = (23,11))

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric features')

plt.xlabel('Work life balance features')

plt.ylabel('Work life balance features')

plt.show()


# In[35]:


# Look at Fruits and Veggies


# In[36]:


# Scatter plot with Meditation with work life balance score

plt.scatter(x=lifestyle['FRUITS_VEGGIES'], y=lifestyle['WORK_LIFE_BALANCE_SCORE'])

plt.title('Fruits and Veggies vs Work life balance')

plt.xlabel('Fruits and Veggies')

plt.ylabel('Work life balance score')

plt.show()


# In[37]:


# Plot Fruits and Veggies vs Work life balance

sns.regplot(x='FRUITS_VEGGIES', y='WORK_LIFE_BALANCE_SCORE', data=lifestyle, scatter_kws={'color':'black'}, line_kws={'color':'red'})
# has a correlation of 


# In[38]:


lifestyle_numerized = lifestyle

for col_name in lifestyle_numerized.columns:
    if (lifestyle_numerized[col_name].dtype == 'object'):
        lifestyle_numerized[col_name] = lifestyle_numerized[col_name].astype('category')
        lifestyle_numerized[col_name] = lifestyle_numerized[col_name].cat.codes
        
lifestyle_numerized


# In[39]:


lifestyle.head()


# In[57]:


correlation_matrix = lifestyle_numerized.corr(method='pearson')

plt.figure(figsize = (23, 11))

sns.heatmap(correlation_matrix, annot=True)



plt.title('Correlation Matrix for Numeric features')

plt.xlabel('Work life balance features')

plt.ylabel('Work life balance features')

plt.show()


# In[41]:


lifestyle_numerized.corr()


# In[42]:


# pd.set_option('display.max_rows', None)


# In[43]:


# organise to see which one has the highest correlation quickly

correlation_mat = lifestyle_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs.head()


# In[44]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs.head()


# In[45]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr.head()


# In[46]:


# Achievement and supporting others have the highest corelation to work life balance score

# meditation and fruits and veggies have a low correlation, and i was wrong

#it also looks life the higher your core circle, the higher your work life balance will be


# In[47]:


sns.regplot(x='DAILY_STRESS', y='WORK_LIFE_BALANCE_SCORE', data=lifestyle, scatter_kws={'color':'black'}, line_kws={'color':'red'})
# has a correlation of 


# In[48]:


#daily stress has the lowest correlation to work life balance score and I was right 


# In[49]:


lifestyle.columns


# In[50]:


lifestyle_subset = lifestyle [['ACHIEVEMENT','SUPPORTING_OTHERS','TODO_COMPLETED','PLACES_VISITED','CORE_CIRCLE', 'PERSONAL_AWARDS']]


# In[51]:


lifestyle_subset


# In[52]:


lifestyle_subset.isna().sum()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




