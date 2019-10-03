getEuropeanPutCRRPriceTree <- function(priceTree, K, p, r, TTM){
  if(p > 1 | p < 0){
    cat("Error: The probability of upper underlying price movement (p)
          needs to between 0 and 1!
          The price has NOT been produced. \n \n")
    return(NA)
  } else if (K < 0) {
    cat("Warning: The strike is negative!
          However, the option price has been calculated. \n \n")
  }
  
  M              <- ncol(priceTree)
  valueTree      <- matrix(NA, M, M)
  
  for(i in 1:M){
    for(j in 1:i){
      temp.output <-
        capture.output(valueTree[j, i] <- 
        getEuropeanPutCRRPrice(priceTree, K, p, r, TTM * ( (M - i) / (M - 1)), j, i))
    }
  }
  
  valueTree
}
