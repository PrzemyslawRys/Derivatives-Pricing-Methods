source("src/fun-getCapPowerCallPriceByPDE.R")
source("src/fun-solveTridiagonalMatrixLinearSystem.R")

result <- 
  getCapPowerCallPriceByPDE(S0 = 90,     # Initial price.
                            r = 0.05,    # Risk-free interest rate.
                            sigma = 0.3, # Volatility.
                            TTM = 0.5,   # Time to maturity.
                            K = 200,     # Strike.
                            C = 250,     # Payoff cap.
                            i = 1.2,     # Final price exponent.
                            Mt = 3000,   # Number of points in time grid.
                            Mx = 3000,   # Number of points in price grid.
                            xmin = 10,    # Minimal considered starting price.
                            xmax = 400,  # Maximal considered starting price.
                            scheme = "implicit") # Or "Crank-Nicholson".

cat("The option price is equal to ", result$priceTransformedS0, 
    "\n and the option delta is equal to ", result$deltaTransformedS0, ".", sep ="")

plot(result$STransformed, result$priceTransformed, type = "l",
     main = "The option price",
     xlab = "S0",
     ylab = "price")

plot(result$STransformed, result$deltaTransformed, type = "l",
     main = "The option delta",
     xlab = "S0",
     ylab = "delta")
