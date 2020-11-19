---
layout: post
title:  "Regression Analysis on U.S. Life Expectancy"
description: ''
date:   2020-06-15 00:00:00 +0000
categories: Multi-Linear-Regression
---

This project focuses on studying the prediction of life expectancy in the United States based on the dataset ***state.x77*** in R library, which is derived from the U.S. Department of Commerce,
Bureau of the Census (1977) *Statistical Abstract of the United States*.  

We will examine the effects of the following 7 variables on life expectancy: 
*Population*  
*Income*  
*Illiteracy*  
*Murder* - murder rate
*HS Grad* - high school graduation rate  
*Area* - land area  
*Frost* - the mean number of days with minimum temperature below freezing  
We find that *Murder*, *HS Grad*, *Frost*, and *Population* are the most related predictors.    

### 1. Questions of Interest
Can we predict life expectancy of a region given its population, income, illiteracy, murder rate, high school graduate percent, land area, and mean number of days with minimum temperature below freezing as predictors?  

### 2. Regression Method
We will approach this question first by applying stepwise and best subsets regression on the 7 potential predictors to determine the best model. Then we will check LINE conditions on this model using residual analysis. If any of the assumptions are not met, we will transform the data and check LINE conditions for the new model. After fitting the model with transformed data, we will interpret our model and summarize our findings.  

### 3. Regression Analysis, Results and Interpretation
#### 3.1 Variable Selection
First, we look at the scatterplot matrix to gain some insight on the relationships between the variables in the data. From the scatterplot below, we can tell that there are some predictors like *Murder* seems to be strongly related to *Life Expectancy*. Others like *Area* and *Income* seem to be moderately or weakly related.  

```{r}
dat=as.data.frame(state.x77)
attach(dat)
names(dat)
pairs(dat[c(4,1,2,3,5,6,7,8)], cex=0.4) #scatterplot matrix
cor(dat)
```
![plot01](https://github.com/rickonz/rickonz.github.io/blob/master/project-docs/126-regression/image/plot01.png?raw=true)

Secondly, we perform variable selection using stepwise regression, including AIC and partial F test, and the best subsets regression to determine the predictors. The results of our AIC test, partial F test, and adjusted $R^2$ criterion chooses four predictors: *Murder*, *HS Grad*, *Frost*, and *Population*. The Mallows’ $C_p$ criterion gives similar result except excluding the fourth predictor *Population*. Therefore, we decide our model to be ***Life Exp ~ Murder + HS Grad + Frost + Population***.  

#### 3.2 Diagnostic Checks and Transformation
Thirdly, we check the LINE conditions for this model. We will not be checking the independence assumption, since we are not given data related to time order.  

![plot08](https://github.com/rickonz/rickonz.github.io/blob/master/project-docs/126-regression/image/plot08.png?raw=true)
![plot06](https://github.com/rickonz/rickonz.github.io/blob/master/project-docs/126-regression/image/plot06.png?raw=true)

The Residual v.s. Fitted plot shows that residuals “bounce randomly” and roughly form a “horizontal band” around the $y=0$ line. However, when looking at the “Residuals vs Predictor” plot, and see a strong funneling effect for the “Residuals v.s. Population” plot. Since a log function has the ability to “spread out” smaller values and bring in larger ones, we will perform log transformation on *Population*. Our model is now *Life Exp ~ Murder + HS Grad + Frost + log(Population)* Then we check our LINE conditions again.  

![plot09](https://github.com/rickonz/rickonz.github.io/blob/master/project-docs/126-regression/image/plot09.png?raw=true)
![plot07](https://github.com/rickonz/rickonz.github.io/blob/master/project-docs/126-regression/image/plot07.png?raw=true)

The “Residuals vs Predictor” plot for *log(Population)* is well-behaved now. The "Residual v.s. Fit" plot and Normal Q-Q plot are both well-behaved. There are no unequal variance or nonlinearity problems.
Our final step is checking for outliers and leverage. After computing for both internally
studentized residuals and studentized deleted (or externally studentized) residuals, none of them
are larger than 3 in absolute value. Thus, there are no unusual Y observations. After computing
the hat values, we find that none of the points has higher hat value than $\frac{3p}{n} = 0.3$. Therefore, there are no outliers or leverage points. And we will not need to investigate for any potentially influential points. Our model has met the LINE conditions.  

#### 3.3 Interpretation
We are now able to observe our model with 4 predictors: *Murder*, *HS Grad*, *Frost*, *log(Population)*.
***Life Expectancy = −0.29*Murder + 0.0546*HSGrad − 0.051*Frost + 0.24*log(Population)***

```{r}
> summary(mod.trans)

Call:
lm(formula = `Life Exp` ~ Murder + `HS Grad` + Frost + I(log(Population)))

Residuals:
     Min       1Q   Median       3Q      Max 
-1.41760 -0.43880  0.02539  0.52066  1.63048 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)        68.720810   1.416828  48.503  < 2e-16 ***
Murder             -0.290016   0.035440  -8.183 1.87e-10 ***
`HS Grad`           0.054550   0.014758   3.696 0.000591 ***
Frost              -0.005174   0.002482  -2.085 0.042779 *  
I(log(Population))  0.246836   0.112539   2.193 0.033491 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.7137 on 45 degrees of freedom
Multiple R-squared:  0.7404,	Adjusted R-squared:  0.7173 
F-statistic: 32.09 on 4 and 45 DF,  p-value: 1.17e-12
```

From the above summary table of our model, the adjusted $R^2$ is 0.7173, telling us that about 71.73% percent variation in life expectancy is explained by our model. Also, the associated p-value $1. 17e^{−12}$ of the whole model is very small, indicating our model is significant.  

*Murder* has negative coefficients -0.29, meaning that we predict a 1 percent increase in murder rate would result in -0.29 years decrease in the mean life expectancy. Similarly, *Frost* has a coefficient -0.00517, indicating that we expect a 1 unit increase in the mean number of days under freezing would bring 0.00517 years decrease in the mean life expectancy. On the other hand, the positive coefficient of *HS Grad* indicates that 1 percentage increase in high school graduation increase mean life expectancy by 0.0546 years. And we expect mean life expectancy to increase 0.5684 years for each ten-fold increase in population. $(0.56836 = 0.246836 × ln(10))$


### 4. Conclusion
In conclusion, we are able to predict the mean life expectancy of people in a U.S. state given its population, local murder rate, high school graduation percentage, and the mean number of days with minimum temperature below freezing. In general, states with higher population and high school graduation percentage would have longer life expectancy, while higher murder rates and more days in freezing temperatures would result in shorter life expectancy.  

Given that the size of the dataset is limited (including only statistics from each state), the accuracy could be improved if we are able to draw more data by smaller region, for example, census by county. It would also be helpful if we could draw more possible related predictors into the dataset, for example, the elevation of the region, unemployment rate, healthcare coverage, air quality, etc. We should also note that the data we draw is from the US census in 1977, which means that necessary adjustment is needed with updated data for contemporary prediction.

### 5. Appendix
[appendix.R]((https://github.com/rickonz/rickonz.github.io/blob/master/project-docs/126-regression/appendix.R?raw=true))