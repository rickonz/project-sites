---
layout: post
title:  "How Likely Will You Get Employed?"
description: ''
date:   2020-10-03 00:00:00 +0000
categories: Projects
---

In this project, we analyze a campus recruitment data set to investigate the relationship in academic and career performance, by utilizing exploratory data analysis(EDA), principle components analysis(PCA), multiple linear regression and logistic regression.  

we discovered work experience, bachelor's degree percentage and area of study are important factors in the placement of employment, and we can use logistic regression model to give accurate prediction based on these key predictors.

### 1. Introduction
One of the biggest challenge students are all facing is getting an ideal job after graduation. Though working hard on coursework, many students are unprepared in competing for recruitment. As the job market getting more and more competitive, it is worthwhile and beneficial to learn what are influencing most on getting good placement in employment and how to be prepared.  

In this project, we will focus on exploring the relationship between students' academic and career performance. Primarily, we will analyzing the factors that have significant influence on the employment and salary, and try to make prediction with suitable model. The data set we are using include a wide range of students academic information as well as their career status, which is very useful for us to examine the underlying relationships.

### 2. Question of Interest
1. What factors play important roles in employment?  
2. How does degree and percentage related to salary?  
3. Can we predict a student's salary?  
4. Can we predict the placement of a student? 

### 3. Data and Method
#### 3.1 Data
The data set is found in kaggle.com: [Campus Recruitment](https://www.kaggle.com/benroshan/factors-affecting-campus-placement/tasks?taskId=735)

The data set is under CC0: Public Domain license. It consists of placement and academic performance data of students in Jain University Bangalore. It includes: 
- **sl_no:** Serial number  
- **gender:** Gender  
- **ssc_p:** Secondary Education percentage- 10th Grade  
- **ssc_b:** Board of Education- Central/ Others  
- **hsc_p:** Higher Secondary Education percentage- 12th Grade  
- **hsc_b:** Board of Education- Central/ Others  
- **hsc_s:** Specialization in Higher Secondary Education  
- **degree_p:** Degree Percentage  
- **degree_t:** Under Graduation(Degree type)- Field of degree education  
- **workex:** Work Experience   
- **etest_p:** Employability test percentage ( conducted by college)  
- **specialization:** Post Graduation(MBA)- Specialization  
- **mba_p:** MBA percentage  
- **status:** Status of placement- Placed/Not placed  
- **salary:** Salary offered by corporate to candidates 

In this project, we will mainly focus on the data that represents students’ academic and experience from undergraduate study, since they are more relevant to our question of interest in the placement of students. 

The data is drawn from previous students at Jain University Bangalore, which is a world renowned institution. Therefore, it is of high relevance to our questions in investigating the relationship between students' academic and career performance. Given the data only include the information of students from this one university, it would reflect the situation of this or other similar institution very precisely, but might not reflect the student population as a whole. Still, we could draw valuable insights from examining this data set.  

*This data set is contributed by Dr. Dhimant Ganatara, professor at Jain University, for the practical session in coursework, so there is little ethical issue to be concerned with, since the information is all public and would not have harm to those who contribute to the data.

*The data set is well structured except that there are 67 null values in the salary section because of the non-placement of candidates. We will fill them with zero after we finish exploratory analysis to avoid influencing our data visualization and further analysis.  

#### 3.2 Method
We will first examine the relationship between different variables using exploratory data analysis, mainly between different performance variables and employment or salary, from which we could quickly and clearly visualize the relationships. By analyzing relationships and patterns from visualizations, we would be able to get initial insights for our question 1 and 2.  

Then, given there are many categorical variables, we use one hot encoding to give each of them binary representations, in order to proceed further analysis and inferential models.  

After that, we will begin doing principal components analysis by applying singular value decomposition on *status* and *salary* respectively, in order to determine the most influential factors for employment and salary, since principal components analysis would help us identify potential patterns among components and target variable We can also obtain the amount of variation of target variables explained by each principal component. This step may provide additional information to our question 1 and 2 and would help us in determining the predictors we use for building regression models to answer question 3 and 4.  

With the information we get from the previous step, we would have a general understanding of the relationship between variables and target response ‘status’ and ‘salary’. Then we can start building regression model using ‘scikit-learn’ packages for predicting salary and the status of placement. Since our data set is relatively small, we will not split the data set into training and testing data set for the scope of this project.  

We would fit salary with multiple linear regression model, since salary is a continuous numeric variable. We will first exclude a few outliers that we see from our exploratory analysis, then fit the regression model. To examine the result, we will compute the loss of the model using average squared loss function that indicates the accuracy of our model. We will also using graph to visualize our result to get a sense of how well the model is doing.  

Next we will apply logistic regression model for determining the *status*, since it is a binary target variable which could not be predicted appropriately with linear regression model. We will adjust the *class_weight}* parameter in order to avoid bias in prediction, because the proportion of placed and unplaced student in our data set is not fifty to fifty. With the result of the fitted model, we could compute confusion matrix and create visualization to check the accuracy of the model.

### 4. Analysis, Results and Interpretation
#### 4.1 What factors play important roles in employment?
We begin our analysis by first looking at the distribution of students in different areas of study and genders. From Figure 1, we can see that males students are two times more than females students in our data set. The popularity of different degrees tends to be the same among both males and females. In undergraduate, almost 70 percent of the students study 'Comm&Mgmt', and the most of the rest of students are in Sci&Tech. In MBA, the number of students in MktGFin are about 10 percent higher than those in Mkt&HR field.

--- visualization (3).png ---

Then, we take a look at the employability. It is conducted by college to imply students’ probability of being applied. From figure 2, we indeed see the students who got employed have higher median employability, but the employability of both placed and unplaced students spans  approximately the same range. So the employability matters for actual placement, but the effect is very significant.

--- visualization (4).png ---

Another interesting factor is work experience. It is clearly seen in figure 3 that the proportion of unplaced students is significantly lower among those who have previous work experience compared to students who do not have work experience. However, the proportion of students with work experience is  smaller than students without experience.

--- visualization (5).png --- 

Does gender play a role? To some degree. Figure 4 shows that the proportion for placed students in male is about 10 percent greater than that in females.

--- visualization (6).png ---

We can also observe that students study *Mkt&Fin* in MBA are more likely to be employed than those who study *Mkt&HR*; and the proportion students being employed in *Comm&Mgmt* and *Sci&Tech* area in undergraduate do not have a significance, but others degree have a significant lower rate of placement.

--- visualization (7).png --- 

As shown in figure 6, higher bachelor's percentage indicates more likelihood of placement, whereas MBA percentage does not distinguish too much between placed and unplaced student.

#### 4.2 How does degree and percentage related to salary?
Next, we continue to examine the factors that influence the salary. From figure 7 and 8, we do not see areas of study and percentage in undergraduate and MBA an effect on salary, since the bar graph reflect generally same amount of mean salary for each areas of study and the scatter plot does not show an obvious linear relationship between salary and both percentage. However, an interesting to notice in scatter plot is that there are a few outliers in scatter plot with very high salary. A few males students with low percentage in bachelor's MBA percentage but high salary. A few females with high bachelor's and MBA percentage but do not stand out in salary.

--- visualization (12).png ---
--- visualization (10).png ---

#### 4.3 Can we predict a student’s salary?
Since we do not observe significant pattern related to salary visually, we then use principle component analysis to find out if there is influential factor on salary. After using one hot encoding, we transform all the categorical variables into binary form. Then we use singular value decomposition with salary as the target variable with principle components number set to 5, and plot the first 2 principle components as oppose to target variable, salary.

--- visualization (14).png ---

The result as shown in figure 9 does not show a obvious pattern between our computed principle components and target variable. So we then computed the explained variance of each principle components. We see from figure 10 that all of the 5 principle components explain a very low variance of our target variable, which indicates we are unable to find significant predictors through principle components analysis. 

--- visualization (15).png --- 

Therefore, we check the correlation matrix to find out the exact correlation. As in figure 11, the absolute value of correlation between all variables and salary is lower than 0.2, which means that there is weak linear relationship. Therefore, we would most likely not getting accurate prediction with linear regression on this topic. 

--- visualization (13).png ---

However, we could still try to fit a multiple linear regression model to examine the fit and loss. We first exclude the outliers that we see in figure 8. To do this, we only use the student data with a salary of 600,000 or below. After fitting the model, we computed the loss by average squared error and get a value of 3320467395 which is very larger, and our plot of predicted value v.s. true value also shows that fitting linear regression model would not be ideal in this case.

--- visualization (21).png ---

#### 4.4 Can we predict the placement of a student?
However, we indeed find some factors that are influencing the likelihood of being employed. Thus, we could apply logistic regression to predict placement status of students. From what we learned from 5.1, we choose bachelor's degree percentage, work experience, gender, bachelor's degree type and MBA specialization as our predictors, and status as target variables. Using logistic regression model in sci-kit learn package to fit our data, we are able to get the result confusion matrix [[ 19,  48],[  9, 139]]). We compute the probability of four kinds of result in confusion matrix and plot a heat map as figure 12 where we can visualize it more clearly. In this model, we have probability of 0.26 in true negative, 0.05 in false negative, 0.16 in false positive and 0.53 in true positive result. In general, our model is of approximately 79 percent accuracy, which predict most placement correctly. 

--- visualization (19).png ---

### 5. Conclusion and Future Work
From the analysis above, we discover that several factors are having effect on the placement of employment to different degree. The factors that have most influence are *work experience*. Those who have previous working experience are significantly of more likelihood to be employed; the bachelor's degree percentage also plays some role, but in MBA this factors does not distinguish anymore. This shows the importance of accumulating practical experience outside from the coursework.  

The area of study in undergraduate study does not distinguish much in placement, however, in MBA, *Mkt&Fin* have more proportion of placement than that in *Mkt&HR*. The male also have some advantages in getting jobs based on this data set. Interestingly, the employability which is calculated to evaluate the students' possibility of being employed does not show a significance indication on students' actual placement status. Combining these analysis, we are able to fit a logistic regression model that will predict the placement of a student with nearly 80 percent accuracy given their bachelor degree percentage, gender, work experience, and areas of study in undergraduate and MBA.  

In the analysis of salary, we did not find significant relationship and determinants to conduct a accurate prediction, since the linearity between the potential factors and salary are not strong enough. This could also due to the size of our data set. Because our observation is limited, the salary distribution does not have much variation. Therefore, it is hard to find variables that have an obvious linear relationship to it.  

To further proceed the result we have achieved, it would be helpful to apply the method on a larger data set and, ideally, have distributed salary values. Also, the result would be more generalized if the students are composed from a greater scope, foe example, from many different other university in different area.  

*A challenge I encountered in this project, but also an meaningful lesson, is how to find a appropriate graph to show the relationship I want to present in a unbiased way. I found the part that took me the most time is to think what kind of graph I should use in a specific situation rather than figure out how to code them. One thing I learn is that rather than thinking about what kind of graph I should code, try to figure out the relationship between the variable first would helps a lot, especially there relationship based on their numerical or categorical characteristic. Once I have that in mind, I would be above to have a blue print about what I could plot with these variable in mind, and then try different method to choose the best way.  

*Another very important note is pay attention to the relationship between count and proportion of the variable in a given set, since the visualization would give completely different result, which could be deceiving. The example is Figure 4, initially I plot the grouped bar chart that show the number, which seem that male has a significant advantage in getting job. However, after plotting a proportion graph relative to the size of their own group, the difference is not that noticeable. The previous distinction is largely due to the size of male it self is greater than the size of female. (graph in appenix)

### 6. Appendix
- 

