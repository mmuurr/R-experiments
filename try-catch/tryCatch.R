## no return() in error-handler:
x1 <- tryCatch({
  stop("foo")
  "last line in try expression"
}, error = function(e) {
  print(conditionMessage(e))
})
## x1 = "foo", i.e. the printed message (which is invisibly-returned by print())

## implicit return() in error-handler:
x2 <- tryCatch({
  stop("foo")
  "last line in try expression"
}, error = function(e) {
  print(conditionMessage(e))
  "last line in error-handling function"
})
## x2 = "last line in error-handling function"

## explicit return() in error-handler:
x3 <- tryCatch({
  stop("foo")
  "last line in try expression"
}, error = function(e) {
  print(conditionMessage(e))
  return("last line in error-handling function")
})
## x3 = "last line in error-handling function"

## explicitly-empty return() in error-handler:
x4 <- tryCatch({
  stop("foo")
  "last line in try expression"
}, error = function(e) {
  print(conditionMessage(e))
  return()
})
## x4 = NULL

## explicitly-returning NULL in error-handler:
x5 <- tryCatch({
  stop("foo")
  "last line in try expression"
}, error = function(e) {
  print(conditionMessage(e))
  return(NULL)
})
## x5 = NULL

## in the x5 case, if not catching the result of the tryCatch, should return(invisible(NULL)) to not pollute stdout/stderr
