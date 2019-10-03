getAmericanPutCRRPriceTree <- function(priceTree, K, p, r, TTM){
  if(p > 1 | p < 0){
    cat("Error: The probability of upper underlying price movement (p)
           needs to between 0 and 1!
           The price has NOT been produced. \n \n")
    return(NA)
  } else if (K < 0) {
    cat("Warning: The strike is negative!
          However, the option price has been calculated. \n \n")
  }
  
  M         <- ncol(priceTree)
  delta.t   <- TTM / M
  
  valueTree      <- matrix(NA, M, M)
  valueTree[, M] <- ifelse(K - priceTree[, M] > 0, K - priceTree[, M], 0)
  
  for(i in (M - 1):1){
    for(j in 1:i){
      valueTree[j, i] <- max(ifelse(K - priceTree[j, i] > 0, K - priceTree[j, i], 0 ), 
                             exp(-r * delta.t) * (valueTree[j, i + 1] * p + 
                                                    valueTree[j + 1, i + 1] * (1 - p)))
    }
  }
  
  valueTree
}
