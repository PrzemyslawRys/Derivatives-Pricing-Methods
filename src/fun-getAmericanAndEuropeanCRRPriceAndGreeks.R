getAmericanAndEuropeanCRRPriceAndGreeks <- function(S0, r, sigma, TTM, K, M){
  if(sigma <= 0){
    cat("Error: The volatility of underlying (sigma) needs to be positive!
        The price has NOT been calculated. \n \n")
    return(NA)
  } else if ( TTM <= 0 ){
    cat("Error: Time to maturity (TTM) needs to be positive!
          The tree has NOT been produced. \n \n")
    return(NA)
  } else if (M <= 0){
    cat("Error: The number of periods (M) needs to be positive!
          The tree has NOT been produced. \n \n")
    return(NA)
  } else if(K < 0){
    cat("Warning: The strike is negative!
          However, the option price has been calculated. \n \n")
  }
  
  delta.t <- TTM / M 
  u       <- exp(sigma * sqrt(delta.t))
  d       <- exp(-sigma * sqrt(delta.t))
  p       <- (exp(r * delta.t) - d) / (u - d)
  
  S <- generateBinomialCRRTree(S0, u, M)
  
  V.euro.Tree     <- getEuropeanPutCRRPriceTree(S, K, p, r, TTM)
  V.euro.price    <- V.euro.Tree[2, 3]
  
  V.american.Tree  <- getAmericanPutCRRPriceTree(S, K, p, r, TTM)
  V.american.price <- V.american.Tree[2, 3]
  
  V.euro.delta     <- (V.american.Tree[1, 3] - V.american.Tree[3, 3]) / (S0 * (u^2 - d^2))
  
  V.american.delta <- (V.american.Tree[1, 3] - V.american.Tree[3, 3]) / (S0 * (u^2 - d^2))
    
  V.euro.gamma     <- (((V.euro.Tree[1, 3] - V.euro.Tree[2, 3]) / (S0 * (u^2 - 1))) -
                         ((V.euro.Tree[2, 3] - V.euro.Tree[3, 3]) / (S0 * (1 - d^2)))) / 
                          (S0 * (u^2 - d^2)/2 )
    
  V.american.gamma <- (((V.american.Tree[1, 3] - V.american.Tree[2, 3]) / (S0 * (u^2 - 1))) -
                         ((V.american.Tree[2, 3] - V.american.Tree[3, 3]) / (S0 * (1 - d^2)))) / 
                          (S0 * (u^2 - d^2)/2 )
  if(M > 1){
    V.euro.theta     <- (V.euro.Tree[3, 5] - V.euro.Tree[1, 1]) / (4*delta.t)
    V.american.theta <- (V.american.Tree[3, 5] - V.american.Tree[1, 1]) / (4*delta.t)
  } else {
    cat("Warning! For M = 1 theta cannot be calculated! \n")
    V.euro.theta     <- NA
    V.american.theta <- NA
  }

  result           <- as.data.frame(rbind(c(V.euro.price, V.euro.delta, V.euro.gamma, V.euro.theta),
                                c(V.american.price, V.american.delta, V.american.gamma, V.american.theta)))
  names(result)    <- c("Price", "Delta", "Gamma", "Theta")
  rownames(result) <- c("European", "American")
  
  result
}
