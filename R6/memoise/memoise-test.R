Klass1 <- R6::R6Class(
  private = list(
    x = 0
  ),
  public = list(
    get_x = function() private$x,
    set_x = function(x) private$x <- x
  )
)

Klass2 <- R6::R6Class(
  private = list(
    .x = 0
  ),
  active = list(
    x = function(x) {
      if (missing(x)) private$.x else private$.x <- x
    }
  )
)

f <- function(obj) {
  print("in f")
  invisible(obj)
}

mf <- memoise::memoise(f)

o1 <- Klass1$new()
mf(o1)
mf(o1)

o1$set_x(1)
mf(o1)

o1 <- Klass1$new()
mf(o1)
o2 <- Klass1$new()
mf(o2)

o1 <- Klass2$new()
mf(o1)

o2 <- Klass2$new()
mf(o2)

o1$x <- 1
mf(o1)
mf(o1)
mf(o2)




