# function that calculates clustered standard errors
cl  <- function(fm, cluster) {
  library(sandwich)
  M <- length(unique(cluster))   
  N <- length(cluster)              
  K <- fm$rank                   
  dfc <- (M/(M-1))*((N-1)/(N-K-1))
  uj  <- apply(estfun(fm), 2, function(x) tapply(x, cluster, sum));
  vcovCL <- dfc * sandwich(fm, meat = crossprod(uj)/N)
  return(vcovCL)
}