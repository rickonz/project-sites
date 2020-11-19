---
layout: post
title:  "How Likely Will You Get Employed?"
date:   2020-10-03 00:00:00 +0000
categories: data_science
---

In this project, we analyze a campus recruitment data set to investigate the relationship in academic and career performance. By utilizing exploratory data analysis, principle components analysis, multiple linear regression and logistic regression, we discovered work experience, bachelor's degree percentage and area of study are important factors in the placement of employment, and we can use logistic regression model to give accurate prediction based on these key predictors.

### 1. Introduction
One of the biggest challenge students are all facing is getting an ideal job after graduation. Though working hard on coursework, many students are unprepared in competing for recruitment. As the job market getting more and more competitive, it is worthwhile and beneficial to learn what are influencing most on getting good placement in employment and how to be prepared. In this project, we will focus on exploring the relationship between students' academic and career performance. Primarily, we will analyzing the factors that have significant influence on the employment and salary, and try to make prediction with suitable model. The data set we are using include a wide range of students academic information as well as their career status, which is very useful for us to examine the underlying relationships.

### 2. Question of Interest
1. What factors play important roles in employment?  
2. How does degree and percentage related to salary?  
3. Can we predict a student's salary?  
4. Can we predict the placement of a student? 

### 3. Data and Method
#### 3.1 Data
The data set is found in kaggle.com:  
*https://www.kaggle.com/benroshan/factors-affecting-campus-placement/tasks?taskId=735*

The data set is under CC0: Public Domain license. It consists of placement and academic performance data of students in Jain University Bangalore. It includes students’ area of study and percentage in secondary (10th grade), higher secondary school (12th grade), undergraduate, and MBA. It also includes employability (conducted by college), work experience and salary offered to the placed students.  

In this project, we will mainly focus on the data that represents students’ academic and experience from undergraduate study, since they are more relevant to our question of interest in the placement of students. 

The data set is well structured except that there are 67 null values in the salary section because of the non-placement of candidates. We will fill them with zero after we finish exploratory analysis to avoid influencing our data visualization and further analysis.  

The data is drawn from previous students at Jain University Bangalore, which is a world renowned institution. Therefore, it is of high relevance to our questions in investigating the relationship between students' academic and career performance. Given the data only include the information of students from this one university, it would reflect the situation of this or other similar institution very precisely, but might not reflect the student population as a whole. Still, we could draw valuable insights from examining this data set.  

This data set is contributed by Dr. Dhimant Ganatara, professor at Jain University, for the practical session in coursework, so there is little ethical issue to be concerned with, since the information is all public and would not have harm to those who contribute to the data.

#### 3.2 Method
We will first examine the relationship between different variables using exploratory data analysis, mainly between different performance variables and employment or salary, from which we could quickly and clearly visualize the relationships. By analyzing relationships and patterns from visualizations, we would be able to get initial insights for our question 1 and 2.  

Then, given there are many categorical variables, we use one hot encoding to give each of them binary representations, in order to proceed further analysis and inferential models.  

After that, we will begin doing principal components analysis by applying singular value decomposition on ‘status’ and ‘salary’ respectively, in order to determine the most influential factors for employment and salary, since principal components analysis would help us identify potential patterns among components and target variable We can also obtain the amount of variation of target variables explained by each principal component. This step may provide additional information to our question 1 and 2 and would help us in determining the predictors we use for building regression models to answer question 3 and 4.  

With the information we get from the previous step, we would have a general understanding of the relationship between variables and target response ‘status’ and ‘salary’. Then we can start building regression model using ‘scikit-learn’ packages for predicting salary and the status of placement. Since our data set is relatively small, we will not split the data set into training and testing data set for the scope of this project.  

We would fit salary with multiple linear regression model, since salary is a continuous numeric variable. We will first exclude a few outliers that we see from our exploratory analysis, then fit the regression model. To examine the result, we will compute the loss of the model using average squared loss function that indicates the accuracy of our model. We will also using graph to visualize our result to get a sense of how well the model is doing.  

Next we will apply logistic regression model for determining the ‘status’, since it is a binary target variable which could not be predicted appropriately with linear regression model. We will adjust the *class_weight}* parameter in order to avoid bias in prediction, because the proportion of placed and unplaced student in our data set is not fifty to fifty. With the result of the fitted model, we could compute confusion matrix and create visualization to check the accuracy of the model.

#### 4. Analysis, Results and Interpretation
We begin our analysis by first looking at the distribution of students in different areas of study and genders. From Figure 1, we can see that males students are two times more than females students in our data set. The popularity of different degrees tends to be the same among both males and females. In undergraduate, almost 70 percent of the students study 'Comm&Mgmt', and the most of the rest of students are in Sci&Tech. In MBA, the number of students in MktGFin are about 10 percent higher than those in Mkt&HR field.

