microbenchmark::microbenchmark(

  f1 <- local({
    x <- 1
    function() x
  }),
  
  f2 <- (function() {
    x <- 2
    function() x
  })()

)

## Unit: nanoseconds
##                                                  expr  min     lq    mean median     uq   max neval
##          f1 <- local({     x <- 1     function() x }) 4504 4776.5 5366.58   4941 5166.5 37844   100
##  f2 <- (function() {     x <- 2     function() x })()  493  510.5  589.08    525  592.5  2292   100
