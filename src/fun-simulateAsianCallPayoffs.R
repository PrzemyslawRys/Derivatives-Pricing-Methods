simulateAsianCallPayoffs <-
  function(S0, r, sigma, TTM, K, n, numberOfSimulatedPaths){
    payoffsMain <- numeric(numberOfSimulatedPaths)
    payoffsAux  <- numeric(numberOfSimulatedPaths)
    deltaT      <- TTM / n
    
    for (i in 1:numberOfSimulatedPaths) {
      # Generating path from Black-Scholes model. 
      normDev <- rnorm(n)
      S       <- S0 * exp(cumsum((r - 0.5 * sigma ^ 2) * deltaT +
                                   sqrt(deltaT) * sigma * normDev))
      
      # Calculating payoff from the discrete arithmetic Asian call option.
      payoffsMain[i] <- ifelse(mean(S) > K, mean(S) - K, 0)
      
      # Calculating payoff from the geometric Asian call option.
      payoffsAux[i] <- ifelse(exp(mean(log(S))) > K, exp(mean(log(S))) - K, 0)
    }
    
    list(main = payoffsMain,
         auxilary = payoffsAux)
}
