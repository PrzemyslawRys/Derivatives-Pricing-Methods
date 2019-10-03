source("src/fun-simulateAsianCallPayoffs.R")
source("src/fun-calculatePriceAsianGeometricDiscreteCall.R")
source("src/fun-calculatePriceAsianGeometricContinuousCall.R")
source("src/fun-getAsianCallPriceByMonteCarloWithControlVariables.R")

optionPrice <- getAsianCallPriceByMonteCarloWithControlVariables(
  S0 = 100,    # Initial price.
  r = 0.01,    # Risk-free interest rate.
  sigma = 0.3, # Volatility.
  TTM = 0.5,   # Time to maturity.
  K = 100,     # Strike.
  n = 101,     # Number of steps in path.
  numberOfSimulatedPaths = 100001)

cat("Option price for the discrete geometric average based control variable:\n",
    optionPrice$priceDisc,
    "\n confidence interval at the significance level 95%:\n", 
    "[", optionPrice$confidenceIntervalDiscrete[1], ", ",
    optionPrice$confidenceIntervalDiscrete[2], "]\n",
    "\n Option price for the continuous geometric average based control variable:\n",
    optionPrice$priceCont,
    "\n confidence interval at the significance level 95%:\n", 
    "[", optionPrice$confidenceIntervalContinuous[1], ", ",
    optionPrice$confidenceIntervalContinuous[2], "]", sep="")

