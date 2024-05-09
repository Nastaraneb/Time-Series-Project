#import library
library (TSA)
library (urca)
library(forecast)
library(readxl)
library(timeSeries)

#importing the data 

data <- read.csv("D:\\My Courses\\time series\\Project work\\Case_study.csv")
V84 <- data$V84 # Replace columnName with the name of your column

####################################
#           step 1                 #
####################################

# Creating a time index from 1 to the length of V84
time_index <- 1:length(V84)

# Plotting
plot(time_index, V84, type = "l", # 'l' for line plot
     xlab = "Time", ylab = "V84",
     main = "Time Series Plot of V84")

Yt <- V84
# Plot ACF for Yt
acf(Yt, main="ACF for Yt")
# First difference of Yt ,k=1
diff1_Yt <- diff(Yt, differences = 1)

# Second difference of Yt,k=2
diff2_Yt <- diff(Yt, differences = 2)
#plot(diff2_Yt)
# Plot ACF for the first difference
acf(diff1_Yt, main="ACF for ∇Yt")

# Plot ACF for the second difference
acf(diff2_Yt, main="ACF for ∇^2Yt")
pacf(diff2_Yt, main="PACF for ∇^2Yt")

# Perform the ADF test using the 'ur.df' function from the 'urca' package
V84_ts <- ts(V84)
adf_test_result <- ur.df(V84_ts, type = "drift", lags = 1, selectlags = "Fixed")
summary(adf_test_result)