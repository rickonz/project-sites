# data preparation
dat=as.data.frame(state.x77)
attach(dat)
names(dat)
pairs(dat[c(4,1,2,3,5,6,7,8)], cex=0.4) #scatterplot matrix
cor(dat)

# Stepwise regression using AIC
mod0=lm(`Life Exp`~1)
mod.all = lm(`Life Exp`~., data=dat) # including all predictors in lm()
step(mod0, scope = list(lower = mod0, upper = mod.all))
mod.AIC = lm(`Life Exp` ~ Murder + `HS Grad` + Frost + Population, data=dat)

# Stepwise regression using F-test
mod0=lm(`Life Exp`~1)
add1(mod0, ~.+Population+Income+Illiteracy+Murder+`HS Grad`+Frost+Area, test = 'F')

# 1.choose 'Murder'
mod1 = update(mod0, ~.+Murder)
add1(mod1, ~.+Population+Income+Illiteracy+`HS Grad`+Frost+Area, test = 'F')

# 2.choose 'HS Grad'
mod2 = update(mod1, ~.+`HS Grad`)
summary(mod2)       #check significance after adding 'HS Grad'
add1(mod2, ~.+Population+Income+Illiteracy+Frost+Area, test = 'F')

# 3.choose 'Frost'
mod3 = update(mod2, ~.+Frost)     
summary(mod3)       #check significance after adding 'Frost'
add1(mod3, ~.+Population+Income+Illiteracy+Area, test = 'F')

# 4.choose 'Pop'
mod4 = update(mod3, ~.+Population)
summary(mod4)       #check significance after adding 'Pop'
add1(mod4, ~.+Income+Illiteracy+Area, test = 'F')     

# no more significant predictors, p-values > 0.15
# same model as what we found in AIC

################################################################

# best subset regression
library(leaps)
mod = regsubsets(cbind(Population, Income, Illiteracy, Murder, `HS Grad`, Frost, Area), `Life Exp`)
summary.mod = summary(mod)
summary.mod$which
names(summary.mod)

# from 3rd to 4th, increased almost 2%
# from 4th to 5th, dropping
# so we choose 4 predictors, look back at matrix, find that same as what we found in stepwise regression
summary.mod$adjr2

# only C_p close to p is the third one, 3.74 close to p=4, three predictors
summary.mod$cp

# residuals analysis
yhat=mod.AIC$fitted.values
e=mod.AIC$residuals
plot(yhat, e, xlab = 'Fitted Values', ylab = 'Residual', main = 'Residual vs Fit') # residual v.s. fitted
abline(h = 0, lty = 2)

par(mfrow=c(1,3))
plot(yhat, e, xlab = 'Fitted Values', ylab = 'Residuals' )
abline(h = 0, lty = 2)
hist(e)  #residual histogram
qqnorm(e) # normal q-q plot
qqline(e)

par(mfrow=c(2,2)) 
plot(dat$Murder,e)
abline(h = 0, lty = 2)
plot(dat$`HS Grad`,e)
abline(h = 0, lty = 2)
plot(dat$Frost,e)
abline(h = 0, lty = 2)
plot(dat$Population,e)
abline(h = 0, lty = 2)

# variables transformation

 
  
# residuals analysis for new model
mod.trans <- lm(`Life Exp` ~ Murder+`HS Grad`+Frost+I(log(Population)))  
e2 = resid(mod.trans)
yhat2 = fitted(mod.trans)

par(mfrow=c(1,3))
plot(yhat, e2, xlab = 'Fitted Values', ylab = 'Residuals' )
abline(h = 0, lty = 2)
qqnorm(e2)
qqline(e2)
hist(e2)

par(mfrow=c(2,2)) 
plot(dat$Murder,e2)
abline(h = 0, lty = 2)
plot(dat$`HS Grad`,e2)
abline(h = 0, lty = 2)
plot(dat$Frost,e2)
abline(h = 0, lty = 2)
plot(log(dat$Population),e2)
abline(h = 0, lty = 2)

# internally studentized residuals
rs=rstandard(mod.trans) 
sort(rs)
rsd=rstudent(mod.trans) # studentized deleted
sort(rsd)

n=length(e2)
p=4+1     # four predictors + 1
3*p/n     # rules of thumb, 3 times the mean leverage value
hv=hatvalues(mod.trans)
sort(hv)  # 0.385 > .3

# Difference in Fits (DFFITS)
2*sqrt((p+1)/(n-p-1))
diff=dffits(mod.trans)
sort(diff)  # no abs val greater than .739

# Cook's distance measure
ck=cooks.distance(mod.trans)
sort(ck)   # not influential

summary(mod.trans)


