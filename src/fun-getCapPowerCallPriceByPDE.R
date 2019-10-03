getCapPowerCallPriceByPDE <-
  function(S0, r, sigma, TTM, K, C, i, Mt, Mx, xmin = 0, xmax = 400, scheme = "implicit"){
  
  # Scheme verification.
  if (scheme!= "implicit" & scheme!="Crank-Nicholson") {
    stop("Inproper scheme type! Execution haulted. Please use 'implicit' or 'Crank-Nicholson'\n")
  }
  
  # Defining payoff function.
  h <- function(s){
    min(C, max(s ^ i - K, 0))
  }
  
  # Transforming variables.
  if (log(xmin) < - 50)
    warning("log(xmin) was to small and in consequence has been substituted by -50.")
  
  deltat <- 0.5 * sigma ^ 2 * TTM / Mt
  deltax <- (log(xmax) - max(log(xmin), -50)) / Mx 
  lambda <- deltat / (deltax ^ 2)
  
  t_grid <- seq(0,  0.5 * sigma ^ 2 * TTM, deltat)
  x_grid <- seq(max(log(xmin), -50), log(xmax), deltax)
  V      <- matrix(NA, Mx + 1, Mt + 1) 
  
  V[, 1]      <- exp(-r * TTM) * unlist(lapply(exp(x_grid), FUN = h))
  V[1, ]      <- numeric(Mt + 1)
  V[Mx + 1, ] <- C * exp(-r * TTM)
  
  if (scheme == "implicit") {
    A       <- diag((2 * lambda + 1), Mx - 1, Mx - 1)
    A[-1, ] <- A[-1, ] + diag(-lambda, Mx - 2, Mx - 1)
    A[, -1] <- A[, -1] + diag(-lambda, Mx - 1, Mx - 2)
    
    for (j in 1:Mt) {
      V[2:Mx, j + 1] <- solveTridiagonalMatrixLinearSystem(A, V[2:Mx, j] +
                                                             lambda * c(V[1, j + 1], numeric(Mx - 3), V[Mx + 1, j + 1]))
    }
    
  } else {
    A       <- diag(lambda + 1, Mx - 1, Mx - 1)
    A[-1, ] <- A[-1, ] + diag(-lambda/2, Mx - 2, Mx - 1)
    A[, -1] <- A[, -1] + diag(-lambda/2, Mx - 1, Mx - 2)
    B       <- -A + diag(2, Mx -1, Mx - 1)
    
    for (j in 1:Mt) {
      V[2:Mx, j + 1] <- 
        solveTridiagonalMatrixLinearSystem(A, B %*% V[2:Mx, j] +  0.5 * lambda * 
                                             c((V[1, j + 1] + V[1, j]), numeric(Mx - 3), (V[Mx + 1, j + 1] + V[Mx + 1, j])))
    }
  }
  
  # Transform V into the natural variables.
  priceTransformed <- V[, Mt + 1]
  STransformed     <- exp(x_grid)
  
  # Calculating V(S0) - geometric average of two prices in nearest grid points.
  whichDownS0 <- length((STransformed[STransformed <= S0]))
  priceTransformedS0 <-   exp((log(priceTransformed[whichDownS0]) * (S0 - STransformed[whichDownS0]) +
                                 log(priceTransformed[whichDownS0 + 1]) *
                                 (STransformed[whichDownS0 + 1] - S0))  /
                                (STransformed[whichDownS0 + 1] - STransformed[whichDownS0]))
  
  # Operating on natural variables in Black-Scholes framework.
  deltax <- xmax / Mx
  deltat <- TTM / Mt
  lambda <- deltat / deltax ^ 2
  
  t_grid <- seq(0,  TTM, deltat)
  x_grid <- seq(xmin, xmax, deltax)
  V      <- matrix(NA, Mx + 1, Mt + 1)
  
  V[1, ]      <- numeric(Mt + 1)
  V[Mx + 1, ] <- C * exp(-r * (TTM - t_grid))
  V[, Mt + 1] <- unlist(lapply(x_grid, FUN = h))
  
  if (scheme == "implicit") {
    theta <- 1
  } else {
    theta <- 1/2
  }
  
  K       <- diag(1 + (sigma ^ 2 * (1:(Mx - 1)) ^ 2 + r) * theta * deltat, Mx - 1, Mx - 1)
  K[-1, ] <- K[-1, ] + diag(-0.5 * (sigma ^ 2 * (1:(Mx - 1)) ^ 2 - r * (1:(Mx - 1))) * theta * deltat,
                            Mx - 2, Mx - 1)
  K[, -1] <- K[, -1] + diag(-0.5 * (sigma ^ 2 * (1:(Mx - 1)) ^ 2 + r * (1:(Mx - 1))) * theta * deltat,
                            Mx - 1, Mx - 2)
  
  L       <- diag(1 - (sigma ^ 2 * (1:(Mx-1)) ^ 2 + r) * (1 - theta) * deltat, Mx - 1, Mx - 1)
  L[-1, ] <- L[-1, ] + diag(0.5 * (sigma ^ 2 * (1:(Mx-1)) ^ 2 - r * (1:(Mx-1))) * (1 - theta) * deltat,
                            Mx - 2, Mx - 1)
  L[, -1] <- L[, -1] + diag(0.5 * (sigma ^ 2 * (1:(Mx-1)) ^ 2 + r * (1:(Mx-1))) * (1 - theta) * deltat,
                            Mx - 1, Mx - 2)
  
  if (scheme == "implicit") {
    for (j in Mt:1){
      V[2:Mx, j] <-
        solveTridiagonalMatrixLinearSystem(K, L %*% V[2:Mx, j + 1] + 
                                    c(0.5 * (sigma ^ 2 - r) * deltat * V[1,j],
                                    numeric(Mx - 3),
      0.5 * (sigma ^ 2 * (Mx - 1) ^ 2 + r * (Mx - 1)) * deltat * V[Mx + 1, j]))
    }
  } else {
    V[2:Mx,j] <-
      solveTridiagonalMatrixLinearSystem(K, L %*% V [2:Mx, j + 1] + 
                c(0.5 * (sigma ^ 2 - r) * deltat * (V[1, j] + V[1, j + 1]) / 2,
                numeric(Mx - 3),
                0.5 * (sigma ^ 2 * (Mx - 1) ^ 2 + r * (Mx - 1)) * deltat *
                (V[Mx + 1, j] + V[Mx + 1, j + 1]) / 2))
  }
  
  priceNatural <- V[, 1]
  SNatural     <- x_grid
  
  # Calculate V(S0) as a weighted average from two nearest points.
  whichDownS0     <- length((SNatural[SNatural <= S0]))
  priceNaturalS0  <- (priceNatural[whichDownS0] * (S0 - SNatural[whichDownS0]) +
                       priceNatural[whichDownS0 + 1] * (SNatural[whichDownS0 + 1] - S0))  /(2 * deltax)
  deltaNatural    <- numeric(Mx)
  deltaNatural[1] <- (priceNatural[2] - priceNatural[1]) /
    (SNatural[2] - SNatural[1])
  for (i in 2:(Mx + 1)) {
    deltaNatural[i] <- (priceNatural[i + 1] - priceNatural[i - 1]) /
      (SNatural[i + 1] - SNatural[i - 1])
  }
  
  whichDownS0    <- length((SNatural[SNatural <= S0]))
  deltaNaturalS0 <- (deltaNatural[whichDownS0] * (S0 - SNatural[whichDownS0]) +
                       deltaNatural[whichDownS0 + 1] * (SNatural[whichDownS0 + 1] - S0))  /(2 * deltax)
  
  deltaTransformed    <- numeric(Mx)
  deltaTransformed[1] <- (priceTransformed[2] - priceTransformed[1]) /
    (STransformed[2] - STransformed[1])
  
  for (i in 2:(Mx + 1)) {
    deltaTransformed[i] <- (priceTransformed[i + 1] - priceTransformed[i - 1]) /
      (STransformed[i + 1] - STransformed[i - 1])
  }
  
  whichDownS0    <- length((STransformed[STransformed <= S0]))
  deltaTransformedS0 <- (deltaTransformed[whichDownS0] * (S0 - STransformed[whichDownS0]) +
                           deltaTransformed[whichDownS0 + 1] * (STransformed[whichDownS0 + 1] - S0))  /
    (STransformed[whichDownS0 + 1] - STransformed[whichDownS0])
  
  list(priceNaturalS0 = priceNaturalS0,
       priceNatural = priceNatural,
       SNatural = SNatural,
       deltaNatural = deltaNatural,
       deltaNaturalS0 = deltaNaturalS0,
       priceTransformedS0 = priceTransformedS0,
       priceTransformed = priceTransformed,
       STransformed = STransformed,
       deltaTransformed = deltaTransformed,
       deltaTransformedS0 = deltaTransformedS0)
}
