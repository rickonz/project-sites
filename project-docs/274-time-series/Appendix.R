setwd("/Users/xuanedx1/Desktop/PSTAT 274/Final Project")
library(dplyr)
library(MASS)
library(ggplot2)
library(ggfortify)
library(forecast)
library(astsa)
library(TSA)
library("GeneCycle")

# loading data
data <- read.csv("data.csv")
by_year <- data %>% group_by(year) %>% summarise(
  energy = mean(energy), .groups = 'drop')
df <- by_year$energy

# plot
tsdat <- ts(df, start=1921,end=2020)
plot.ts(tsdat, main='Average Song Track Energy', ylab='Index')

# partition dataset for training and validation
df.train = df[c(1:95)]
df.test = df[c(96:100)]

# plot
plot.ts(df.train, main='Average Song Track Energy', ylab = expression(X[t]))
nt = length(df.train)

# mean and linear trend
fit <- lm(df.train~as.numeric(1:nt));abline(fit, col='red')
abline(h=mean(df.train),col='blue')
abline(h=mean(df.train[c(1:30)]),col='green')
fit <- lm(df.train[c(1:30)]~as.numeric(1:30));abline(fit, col='purple')

hist(df.train, col='light blue', xlab='', main='Histogram of the Data')
acf(df.train, lag.max=40, main='ACF of the Data')

# box-cox transform
bcTransform = boxcox(df.train ~ as.numeric(1:length(df.train)))
lambda = bcTransform$x[which(bcTransform$y==max(bcTransform$y))]
df.bc = (1/lambda)*(df.train^lambda-1)
plot.ts(df.bc, main='BC Transformed Data', ylab = expression(X[t]))

# compare original v.s. transformed histigram
hist(df.bc, col='light blue', xlab='', main='BC Transformed Histogram')
hist(df.train, col='light blue', xlab='', main='Original Histogram')
var(df.bc)
var(df.train)

# decomposition
y <- ts(as.ts(df.train), frequency=12)
decomp <- decompose(y)
plot(decomp)

# compare variance
d1 = diff(df.train, 1)
# var(d1)
d2 = diff(d1, 1)
# var(d2)  ## difference once, since var(y2)>var(y1)

# plot
plot.ts(d1, main = 'De-trended Time Series');abline(h=mean(d1), col='blue')
fit <- lm(d1 ~ as.numeric(1:length(d1))); abline(fit, col="red")

op = par(no.readonly = TRUE)
par(mfrow = c(1,2))
acf(d1, main='ACF; De-trended')
hist(d1, col='light blue', xlab='', main=expression(nabla~Y[t]))
m <- mean(d1)
std <- sqrt(var(d1))
curve(dnorm(x,m,std), add=TRUE )
par(op)

acf(d1, main = expression(nabla~Y[t]))   ## stationary,lags: 1,3,6
pacf(d1, main = expression(nabla~Y[t]))  ## lags: 1,2

# Model Candidates: p=1,3,6 q=1,2
source('sarima.R')
source('AICc.R')
p <- c(1,3,6)
q <- c(1,2)

aicc1 = matrix(NA, nr=3, nc=3)
colnames(aicc1) = c('p','q','AICc')
for (i in 1:3){
  aicc1[i, 1] = p[i]
  aicc1[i, 2] = q[1]
  aicc1[i, 3] = AICc(arima(d1, order = c(p[i], 0, q[1]), method='ML'))
}
aicc1

aicc2 = matrix(NA, nr=3, nc=3)
colnames(aicc2) = c('p','q','AICc')
for (i in 1:3){
  aicc2[i, 1] = p[i]
  aicc2[i, 2] = q[2]
  aicc2[i, 3] = AICc(arima(d1, order = c(p[i], 0, q[2]), method='ML'))
}
aicc2

arima(d1, order=c(3,0,2), method='ML')
arima(d1, order=c(3,0,2), fixed=c(NA,NA,0,NA,NA,NA), method='ML', transform.pars = FALSE)
AICc(arima(d1, order=c(3,0,2), fixed=c(NA,NA,0,NA,NA,NA), method='ML',transform.pars = FALSE))


arima(d1, order=c(6,0,1), method='ML')
arima(d1, order=c(6,0,1), fixed=c(NA,0,NA,NA,0,NA,NA,NA),
method='ML',transform.pars = FALSE)
AICc(arima(d1, order=c(6,0,1), fixed=c(NA,0,NA,NA,0,NA,NA,NA),
method='ML',transform.pars = FALSE))

arima(d1, order=c(6,0,2), method='ML')
arima(d1, order=c(6,0,2), fixed=c(NA,NA,0,NA,0,NA,NA,NA,NA),
method='ML',transform.pars = FALSE)
AICc(arima(d1, order=c(6,0,2), fixed=c(NA,NA,0,NA,0,NA,NA,NA,NA),
method='ML',transform.pars = FALSE))


# plotting roots, check invertibility/stationarility
source("plot.roots.R")
op = par(no.readonly = TRUE)
par(mfrow = c(1,2))
plot.roots(NULL,polyroot(c(1, 0.2314, 0, 0.1806, -0.1438, 0, 0.3437))) ## ar part
plot.roots(NULL,polyroot(c(1, -0.5834))) #ma part
par(op)

op = par(no.readonly = TRUE)
par(mfrow = c(1,2))
plot.roots(NULL,polyroot(c(1, 0.5342, -0.1713, 0, -0.2227, 0, 0.3637))) ## ar part
plot.roots(NULL,polyroot(c(1, -0.9717, 0.4637))) #ma part
par(op)

# diagnostic checking
fit1 <- arima(d1, order=c(6,0,1), fixed=c(NA,0,NA,NA,0,NA,NA,NA), method='ML', transform.pars = FALSE)
res1 <- residuals(fit1)
mean(res1)
hist(res1,density=20,breaks=20, col="blue", xlab="", prob=TRUE, main='Histogram of Residual; Model A')
m1 <- mean(res1)
std1 <- sqrt(var(res1))
curve( dnorm(x,m1,std1), add=TRUE )
plot.ts(res1, main='Residuals; Model A')

fitt1 <- lm(res1 ~ as.numeric(1:length(res1))); abline(fitt1, col="red")
abline(h=mean(res1), col="blue")
qqnorm(res1, main= "Normal Q-Q Plot; Model A")
qqline(res1,col="blue")
shapiro.test(res1)  ## do not pass?

Box.test(res1, lag=10, type = c("Box-Pierce"), fitdf = 7)
Box.test(res1, lag=10, type = c("Ljung-Box"), fitdf = 7)
Box.test(res1^2, lag=10, type = c("Ljung-Box"), fitdf = 0)

acf(res1, lag.max=20, main='ACF of Residuals; Model A')
pacf(res1, lag.max=20, main='PACF of Residuals; Model A')
ar(res1, aic = TRUE, order.max = NULL, method = c("yule-walker"))

fit2 <- arima(d1, order=c(6,0,2),
fixed=c(NA,NA,0,NA,0,NA,NA,NA,NA), method='ML',transform.pars = FALSE)
res2 <- residuals(fit2)
mean(res2)
hist(res2,density=20,breaks=20, col="blue", xlab="",
prob=TRUE, main='Histogram of Residual; Model B')
m2 <- mean(res2)
std2 <- sqrt(var(res2))
curve( dnorm(x,m2,std2), add=TRUE )
plot.ts(res2, main='Residuals; Model B')

fitt2 <- lm(res2 ~ as.numeric(1:length(res2))); abline(fitt2, col="red")
abline(h=mean(res2), col="blue")
qqnorm(res2 ,main= "Normal Q-Q Plot for Model B")
qqline(res2, col="blue")
shapiro.test(res2)

Box.test(res2, lag=10, type = c("Box-Pierce"), fitdf = 7)
Box.test(res2, lag=10, type = c("Ljung-Box"), fitdf = 7)
Box.test(res2^2, lag=10, type = c("Ljung-Box"), fitdf = 0)

acf(res2, lag.max=20,  main='ACF of Residuals; Model B')
pacf(res2, lag.max=20, main='PACF of Residuals; Model B')
ar(res2, aic = TRUE, order.max = NULL, method = c("yule-walker"))


# spectral analysis
periodogram(df.train)
periodogram(res2)
fisher.g.test(res2)
cpgram(res2,main="")

# forcasting
fit1 <- arima(df.train, order=c(6,1,2),
fixed=c(NA,NA,0,NA,0,NA,NA,NA), method='ML',transform.pars = FALSE)
pred.tr <- predict(fit1, n.ahead = 5)
U.tr= pred.tr$pred + 2*pred.tr$se # upper bound of prediction interval
L.tr= pred.tr$pred - 2*pred.tr$se # lower bound

# plot with true value
ts.plot(df, xlim = c(1,100),  ylim = c(min(df.train),max(U.tr)), col="red",
        main='Forecasting on Time Series', ylab='Index')
lines(U.tr, col="blue", lty="dashed")
lines(L.tr, col="blue", lty="dashed")
points((length(df.train)+1):(length(df.train)+5), pred.tr$pred, col="green")
points((length(df.train)+1):(length(df.train)+5), df.test, col="black")

# zoom in
ts.plot(df, xlim = c(75,100),  ylim = c(min(df.train),max(U.tr)), col="red",
        main='Forecasting on Time Series', ylab='Index')
lines(U.tr, col="blue", lty="dashed")
lines(L.tr, col="blue", lty="dashed")
points((length(df.train)+1):(length(df.train)+5), pred.tr$pred, col="green")
points((length(df.train)+1):(length(df.train)+5), df.test, col="black")