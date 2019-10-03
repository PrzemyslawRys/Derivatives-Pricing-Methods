solveTridiagonalMatrixLinearSystem <- function(A, v){
  n     <- length(v)
  ah    <- numeric(n)
  d     <- numeric(n)
  x     <- numeric(n)
  ah[1] <- A[1,1]
  d[1]  <- v[1]
  
  for (i in 2:n) {
    ah[i] <- A[i,i] - A[i - 1, i] * A[i, i - 1] / ah[i - 1]
    d[i]  <- v[i] - d[i - 1] * A[i, i - 1] / ah[i - 1]
  }
  
  x[n] <- d[n] / ah[n]
  
  for (i in (n-1):1) {
    x[i] <- (d[i] - A[i, i + 1] * x[i + 1]) / ah[i]
  }
  
  x
}
