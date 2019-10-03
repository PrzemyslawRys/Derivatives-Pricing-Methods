source("src/fun-getAmericanAndEuropeanCRRPriceAndGreeks.R")
source("src/fun-generateBinomialCRRTree.R")
source("src/fun-getEuropeanPutCRRPriceTree.R")
source("src/fun-getEuropeanPutCRRPrice.R")
source("src/fun-getAmericanPutCRRPriceTree.R")

getAmericanAndEuropeanCRRPriceAndGreeks(S0 = 100,     # Initial price.
                                        r = 0.04,     # Risk-free interest rate.
                                        sigma = 0.25, # Volatility.
                                        TTM = 0.5,    # Time to maturity.
                                        K = 100,      # Strike.
                                        M = 10)       # Number of tree periods.
