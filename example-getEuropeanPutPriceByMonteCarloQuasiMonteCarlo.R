library('fOptions')

source("src/fun-getGaussianVariablesByBoxMuller.R")
source("src/fun-getEuropeanPutPriceByMonteCarloQuasiMonteCarlo.R")

getEuropeanPutPriceByMonteCarloQuasiMonteCarlo(
  S0 =  50,      # Initial price.
  r = 0.05,      # Risk-free interest rate.
  sigma = 0.30,  # Volatility.
  TTM =  0.5,    # Time to maturity.
  K = 50,        # Strike.
  M = 1000000)   # Number of simulations.
