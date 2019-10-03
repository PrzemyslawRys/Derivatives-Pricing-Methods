calculatePriceAsianGeometricContinuousCall <- function(S0, r, sigma, TTM, K){
  b1 <- (log(S0 / K) + 0.5 * (r + (sigma ^ 2) / 6) * TTM) / (sigma * sqrt(TTM / 3))
  b2 <- b1 - sigma * sqrt(TTM / 3)
  
  return(exp(-0.5 * (r + (sigma ^ 2)/6) * TTM) * S0 * pnorm(b1) - exp(-r * TTM) * K * pnorm(b2))
  
}
