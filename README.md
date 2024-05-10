# Time-Series-Project
 Step 1: Preliminary Analysis of Orders
- Plot the time series data (Yt).
- Analyze the differencing order (d):
  - Display the autocorrelation function of (Yt) and ∇kYt, where ∇Yt = Yt − Yt−1.
  - Implement the Augmented Dickey-Fuller test (ADF) to assess stationarity.
  - Determine the suggested order for d.
- Analyze the autoregressive and moving average orders (p, q):
  - Plot the autocorrelation function (ACF) and partial autocorrelation function (PACF) of relevant series.
  - Provide upper bounds for p and q (pmax and qmax) based on ACF and PACF.

Step 2: Estimation and Selection of ARIMA Models
- Assume known differencing order.
- Compute AIC and BIC for 16 remaining models (0 ≤ p ≤ pmax, 0 ≤ q ≤ qmax).
- Provide a table with estimates of the best three specifications.

Step 3: Diagnostic Tests
- Conduct Ljung-Box test for absence of correlations of error terms.
- Analyze normality of residuals using histograms, QQ plots, and Shapiro-Wilk's test.
- Determine preferred model specification considering all results and principle of parsimony.
- Plot original time series and best-fitted model.

Step 4: Forecast
- Generate forecast plot with 95% confidence interval for h-step predictions (h = 10, h = 25) using the preferred specification.
