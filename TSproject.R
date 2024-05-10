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


####################################
#           step 2                 #
####################################


# Initialize a matrix to store the AIC and BIC values
model_info <- matrix(NA, nrow = 16, ncol = 4)
colnames(model_info) <- c("p", "q", "AIC", "BIC")
row <- 1

# Loop over potential p and q values
for(p in 1:4){
  for(q in 1:4){
    # Fit ARIMA model with two differences
    model <- Arima(V84, order=c(p,2,q))
    
    # Store p, q, AIC, and BIC in the matrix
    model_info[row, ] <- c(p, q, AIC(model), BIC(model))
    row <- row + 1
  }
}

# Convert matrix to data frame for easier handling
model_info_df <- as.data.frame(model_info)

# Order models based on AIC and BIC
ordered_aic <- model_info_df[order(model_info_df$AIC),]
ordered_bic <- model_info_df[order(model_info_df$BIC),]

# Select best three specifications according to AIC
best_by_aic <- head(ordered_aic, 3)

# Select best three specifications according to BIC
best_by_bic <- head(ordered_bic, 3)

# Print the best models by AIC
print(best_by_aic)

# Print the best models by BIC
print(best_by_bic)


####################################
#           step 3                 #
####################################

#based on prvious section we have 4 orders for arima to check
# c(1,2,1), c(1,2,2), c(4,2,4), c(2,2,1)
best_model <- Arima(V84, order=c(1,2,2)) # example model

# Conduct the Ljung-Box test on the residuals of the model
Box.test(residuals(best_model), lag=10, type="Ljung-Box")

par(mfrow=c(2,2))
# Plot ACF and PACF for the residuals of the model
acf(residuals(best_model), main="ACF of Residuals")
pacf(residuals(best_model), main="PACF of Residuals")

#histogram
residuals_data <- residuals(model)
hist(residuals_data, main="Histogram of Residuals", xlab="Residuals", breaks=30, col="blue")
## QQ plot
qqnorm(residuals_data, main="QQ Plot of Residuals")
qqline(residuals_data, col="red")

# Shapiro-Wilk's Test for Normality
shapiro_test <- shapiro.test(residuals_data)
print(shapiro_test)


# Get the fitted values from the model
fitted_values <- fitted(best_model)

# Convert the original series to a time series object if it's not already
V84_ts <- ts(V84)

# The time series has been differenced twice, so we need to
# undifference the fitted values to be on the same scale as the original data
#undiff_fitted_values <- diffinv(fitted_values, differences = 2, xi = V84_ts[1:2])

par(mfrow=c(1,1))
# Plot the original series
plot(V84_ts, main="Original Series and Fitted Model", xlab="Time", ylab="Values", col="blue")

# Add the fitted values to the plot
lines(fitted_values, col="red")

# Add a legend to the plot
legend("topright", legend=c("Original Series", "Fitted Model"), col=c("blue", "red"), lty=1)
