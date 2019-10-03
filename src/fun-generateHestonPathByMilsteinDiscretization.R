generateHestonPathByMilsteinDiscretization <-
  function(S0, V0, r, sigma, a, b,
           rho, TTM, K, n, negativeCond = TRUE){
  W1 <- rnorm(n)
  W2 <- rho * W1 + sqrt(1 - rho^2) * rnorm(n)
  S  <- S0
  V  <- V0
  
  if (negativeCond) {
    for (j in 1:n) {
      S <- S * exp((r - 0.5 * V) * deltat + sqrt(max(V, 0) * deltat) * W1[j])
      
      V <- V + (a * (b - V) - 0.25 * sigma ^ 2) * deltat + sigma * sqrt(max(V, 0) * deltat) * W2[j] + 
        0.25 * sigma ^ 2 * deltat * W2[j] ^ 2
    }
  } else {
    for (j in 1:n) {
      S <- S * exp((r - 0.5 * V) * deltat + sqrt(V * deltat) * W1[j])
      
      V <- V + (a * (b - V) - 0.25 * sigma ^ 2) * deltat + sigma * sqrt(V * deltat) * W2[j] + 
        0.25 * sigma ^ 2 * deltat * W2[j] ^ 2
    }
  }
  
  S
  }
