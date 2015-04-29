repsaledatatreatm <- function(price,timevar,id,treatm) {
  
  data1  <- data.frame(price,timevar,id,treatm)
  o <- order(id,timevar,price,treatm)
  n = length(o)
  data1 <- data1[o,]
  data0 <- data1[1:(n-1),]
  data1 <- data1[2:n,]
  rsale <- data0$id==data1$id & data0$timevar<data1$timevar
  data0 <- data0[rsale,]
  data1 <- data1[rsale,]
  id <- data1$id
  time0 <- data0$timevar
  time1 <- data1$timevar
  price0 <- data0$price
  price1 <- data1$price
  treat0 <- data0$treatm
  treat1 <- data1$treatm
  rdata <- data.frame(id,time0,time1,price0,price1,treat0,treat1)
  
  return(rdata)
}
