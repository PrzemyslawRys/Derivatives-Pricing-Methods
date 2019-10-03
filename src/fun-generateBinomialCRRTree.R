generateBinomialCRRTree <- function(S0, u, M, extended = TRUE){
  if (M <= 0) {
    cat("Error: The number of periods (M) needs to be positive!
          The tree has NOT been produced. \n \n")
    return(NA)
  } else if (u < 1) {
    cat("Warning: The upper multiplier (u) should be higher than one!
          However, the tree has been produced. \n \n")
  }

  if (extended) {
    M <- M + 2
  }
  
  d               <- 1/u
  S               <- matrix(NA, M + 1, M + 1)
  S[1, 1]         <- S0
  S[1, 2:(M + 1)] <- S0 * u^c(1:M)
  
  for (i in 2:(M + 1)) {
    S[i, i:(M + 1)] <- S[i - 1, i:(M + 1)] * d ^ 2
  }
  
  S
}
