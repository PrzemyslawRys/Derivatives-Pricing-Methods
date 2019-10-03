getEuropeanPutPriceByMonteCarloQuasiMonteCarlo <-
  function(S0, r, sigma, TTM, K, M){
    
    # Generating pseudo-random numbers from uniform distribution over [0,1]
    # and two-dimensional Halton sequence
    
    N         <- ceiling(M / 2)
    unifMC    <- matrix(runif(N * 2), N, 2)
    unifQMC   <- runif.halton(N, 2, 1)
    
    # Transforming uniform numbers into gaussian by Box-Muller function.
    normMC  <- as.numeric(apply(unifMC,
                                1,
                                FUN = function(x) getGaussianVariablesByBoxMuller(x[1], x[2])))[1:M]
    
    normQMC <- as.numeric(apply(unifQMC,
                                1,
                                FUN = function(x) getGaussianVariablesByBoxMuller(x[1], x[2])))[1:M]
    
    # Calculating theoretical price by analytical Black-Scholes formula.
    d1      <- (log(S0 / K) + (r + sigma ^ 2 / 2) * TTM)/(sigma * sqrt(TTM))
    priceAn <- pnorm(sigma * sqrt(TTM) - d1) * K * exp(-r * TTM) - pnorm(-d1) * S0
    
    # Calculate price by Monte Carlo and Quasi Monte Carlo
    sumMC   <- 0
    sumQMC  <- 0
    sum2MC  <- 0
    
    for (i in 1:M) {
      x.MC    <- max(K - S0 * exp((r - 0.5 * sigma ^ 2) * TTM + sigma * sqrt(TTM) * normMC[i]), 0)
      sumMC   <- sumMC + x.MC
      sumQMC  <- sumQMC + max(K - S0 * exp((r - 0.5 * sigma ^2)*TTM + sigma * sqrt(TTM) * normQMC[i]), 0)
      sum2MC  <- sum2MC + (x.MC - priceAn) ^ 2
    }
    
    priceMC   <- exp(-r * TTM) * sumMC / M
    priceQMC  <- exp(-r * TTM) * sumQMC / M
    b         <- sqrt(sum2MC / (M - 1))
    
    confidence.interval <- priceAn + c(-1, 1)* 1.98 * b / sqrt(M)
    
    # format and save results
    result           <- as.data.frame(matrix(c(priceMC, abs(priceMC - priceAn) / 
                                                 priceAn, priceQMC, abs(priceQMC - priceAn)/priceAn), 2, 2))
    
    names(result)    <- c("Monte Carlo", "Quasi Monte Carlo")
    rownames(result) <- c("price", "relative error")
    result           <- list(result, confidence.interval)
    names(result)    <- c("prices", "confidence.interval95")
    result
  }
