
getAsianCallPriceByMonteCarloWithControlVariables <-
  function(S0, r, sigma, TTM, K, n, numberOfSimulatedPaths){
  
  # Simulating final payoffs using Monte Carlo methods.
  payoffs <-
    simulateAsianCallPayoffs(S0, r, sigma, TTM, K, n, numberOfSimulatedPaths)
  
  # Discounting main and auxiliary variables.
  discountedPayoffsMain       <- exp(-r * TTM) * payoffs$main
  discountedPayoffsAuxiliary  <- exp(-r * TTM) * payoffs$auxilary
  
  # Calculating optimal theta in order to minimize MSE,
  # what means minimizing variance of price estimator.
  theta <- -cov(discountedPayoffsMain, discountedPayoffsAuxiliary) /
    var(discountedPayoffsAuxiliary)
  
  # Calculating the theoretical price for auxilary option.
  theoreticalPriceDiscrete    <-
    calculatePriceAsianGeometricDiscreteCall(S0, r, sigma, TTM, K, n)
  
  theoreticalPriceContinuous  <-
    calculatePriceAsianGeometricContinuousCall(S0, r, sigma, TTM, K)
  
  # Pseudo-payoffs have the same expected value as payoffs, but lower variance.
  pseudoPayoffsDiscrete   <- discountedPayoffsMain + 
    theta * (discountedPayoffsAuxiliary - theoreticalPriceDiscrete) 
  
  pseudoPayoffsContinuous <- discountedPayoffsMain + 
    theta * (discountedPayoffsAuxiliary - theoreticalPriceContinuous) 
  
  priceDiscrete   <- mean(pseudoPayoffsDiscrete)
  
  priceContinuous <- mean(discountedPayoffsMain + 
            theta * (discountedPayoffsAuxiliary - theoreticalPriceContinuous))
  
  confidenceIntervalDiscrete <-
    priceDiscrete + c(-1, 1) * 1.96 * sd(pseudoPayoffsDiscrete) / sqrt(n)
  
  confidenceIntervalContinuous <-
    priceContinuous + c(-1, 1) * 1.96 * sd(pseudoPayoffsContinuous) / sqrt(n)
  
  list(priceDiscrete = priceDiscrete,
       priceContinuous = priceContinuous,
       confidenceIntervalDiscrete = confidenceIntervalDiscrete,
       confidenceIntervalContinuous = confidenceIntervalContinuous,
       theta = theta,
       theoreticalPriceDiscrete = theoreticalPriceDiscrete,
       theoreticalPriceContinuous = theoreticalPriceContinuous)
}
