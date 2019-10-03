source("src/fun-getHestonCallPriceByMonteCarloMilstein.R")
source("src/fun-generateHestonPathByMilsteinDiscretization.R")

getHestonCallPriceByMonteCarloMilstein(S0 = 50,    # Initial price.
                                       V0 = 0.06,    # Initial volatility.
                                       r = 0.05,     # Risk-free interest rate.
                                       sigma = 0.4, # Volatility of volatility.
                                       a = 2,     # Mean-reverting intensity.
                                       b = 0.08,     # Long-run volatility level.
                                       rho = -0.7,   # Correlation between shocks
                                                     # in price and volatility.
                                       TTM = 2,   # Time to maturity.
                                       K = 45,     # Strike.
                                       n = 501,    # Discretization steps.
                                       M = 100007)   # Simulations number.
