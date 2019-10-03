getHestonCallPriceByMonteCarloMilstein <-
  function(S0, V0, r, sigma, a, b, rho, TTM, K, n, M){
    # Checking condition for possibility of negative V from Milstein scheme.
    negativeCond  <- (2 * a * b < sigma ^ 2)
    if(negativeCond)
      warning("The model parameters can cause the negative variance generation in Milstein scheme. \n")
    
    # Setting predefined values.
    payoffs   <- numeric(M)
    deltat    <- TTM / n
    
    # Simulating payoffs from Heston model.
    for (i in 1:M) {
      ## Calculating payoff from simulated path.
      payoffs[i] <-  
        max(generateHestonPathByMilsteinDiscretization(S0, V0, r, sigma, a, b,
                                                       rho, TTM, K, n, negativeCond) - K,
            0) 
    }
    payoffs <- exp(-r * TTM) * payoffs
    
    # Calculating price and the confidence interval.
    price        <- mean(payoffs)
    payoffStdev  <- sd(payoffs)
    confInterval <- price + c(-1, 1) * 1.98 * sd(payoffs) / sqrt(M)
    
    list(price = price,
         confInterval95 = confInterval)
  }