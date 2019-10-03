getEuropeanPutCRRPrice <-
  function(priceTree, K, p, r, TTM, start.row = 2, start.col = 3){
  if(p > 1 | p < 0){
    cat("Error: The probability of upper underlying price movement (p)
         needs to between 0 and 1!
         The price has NOT been produced. \n \n")
    return(NA)
  } else if (K < 0) {
    cat("Warning: The strike is negative!
          However, the option price has been calculated. \n \n")
  }
  
  M          <- ncol(priceTree) - start.col
  end.prices <- priceTree[start.row:(M + start.row), ncol(priceTree)]
  
  sum(ifelse(K - end.prices > 0, K - end.prices, 0) *
        choose(M, c(0:M)) * p ^ (c(M:0)) * (1 - p) ^ c(0:M) *
        exp(-r * TTM))
}

