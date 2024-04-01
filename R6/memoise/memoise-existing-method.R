Klass1 <- R6::R6Class(
  public = list(
    echo = function(x) {
      print("echoing")
      x
    },
    initialize = function() {
      base::unlockBinding("echo", self)
      self$echo <- memoise::memoise(self$echo)
      base::lockBinding("echo", self)
    }
  )
)

Klass2 <- R6::R6Class(
  public = list(
    echo = NULL,
    initialize = function() {
      self$echo <- memoise::memoise(function(x) {
        print("echoing")
        x
      })
    }
  )
)

o1 <- Klass1$new()
o2 <- Klass2$new()


memoise_method <- funtion(obj, method) {
  force(obj)
  force(method)
  function(obj, ...) {
    obj$method
  }
  
  function(...) {
    
  }
}

Klasss1 <- R6::R6Class(
  public = list(
    getx = function(some, other, args) {
      print("getting")
      self$x
    },
    initialize = function() {
      original_getx <- self$getx
      base::unlockBinding(self, "getx")
      self$getx <- function() {

      }
      base::lockBinding(self, "getx")
    }
  )
)
