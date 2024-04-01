Klass1 <- R6::R6Class(
  classname = "Klass1",
  inherit = NULL,
  cloneable = FALSE,
  private = list(
  ),
  public = list(
    x = NULL,
    nested_public = (function() {
      .this_env <- environment()
      .original_parent_env <- parent.frame()
      list(
        f = function() self$x,
        ..init.. = function(self) {
          new.env(parent = .self$.__enclos_env__)
        }
      )
    })(),
    initialize = function(x) {
      self$x <- x
      
      self$nested_public$..init..(self)
    }
  )
)
o1 <- Klass1$new(1)

o2 <- Klass1$new(2)

o1$f()
o2$f()
o1$f()


## Klass2 <- R6::R6Class(
##   classname = "Klass2",
##   inherit = NULL,
##   cloneable = FALSE,

##   private = list(
##     .data
##   )


tempf <- function(x) {
  force(x)
  listenv::listenv(
    get_x = function() x
  )
}
foo1 <- tempf(1)
foo2 <- tempf(2)



f <- (function() {
  x <- 1
  function() y
})()

y <- 2
f()
