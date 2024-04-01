m <- fastmap::fastmap()

MyClass <- R6::R6Class("MyClass",
  private = list(
    val = 0
  ),
  public = list(
    initialize = function(val) private$val <- val,
    get = function() private$val,
    set = function(val) private$val <- val
  )
)

o1 <- MyClass$new(1)
o2 <- MyClass$new(2)

m$set("o1", o1)
m$set("o2", o2)

m$as_list()

o2$set(20)

m$as_list()
o2$get()

str((function(x) {
  if (missing(x)) x <- character(0)
  m$remove(x)
})())
