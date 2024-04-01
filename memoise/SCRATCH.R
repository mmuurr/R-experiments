library(tidyverse)
library(memoise)

f <- function(x) {
  print(lubridate::now())
  NULL
}
mf <- memoise(f)

##========================================
## let's start with x as a list
##========================================

x <- list()  ## empty list
mf(x)  ## run
mf(x)  ## no-run

x$a <- "foo"
mf(x)  ## run
mf(x)  ## no-run

x$b <- list()
mf(x)  ## run
mf(x)  ## no-run

x$b$c <- "foo"
mf(x)  ## run

## conclusion: the changing list structure constitutes a hash change and a re-run of the function

##========================================
## what about closures with changing 'internal' fields?
##========================================

f <- function(x) {
  print(lubridate::now())
  x()
  return(NULL)
}
mf <- memoise(f)

x <- (function() {
  run_count <- 0
  function() {
    run_count <<- run_count + 1
    print(run_count)
  }
})()

mf(x)  ## time, 1
mf(x)  ## time, 2
mf(x)  ## time, 3

## conclusion: the changing values inside the closure constitutes a hash change.
## what about explcit environment manipulation?

assign("run_count", 10, envir = environment(x))
mf(x)  ## time, 11

##========================================
## rather than closures, let's use an environment directly
##========================================

f <- function(x) {
  print(lubridate::now())
  return(NULL)
}
mf <- memoise(f)

x <- new.env(parent = emptyenv())

mf(x)  ## time
mf(x)  ## no time

x$a <- "foo"
mf(x)  ## time
mf(x)  ## no time

assign("b", "bar", envir = x)
mf(x)  ## time
mf(x)  ## no time

##========================================
## R6 objects?
##========================================

Klass <- R6::R6Class("Klass",
  private = list(
    .run_count = 0
  ),
  active = list(
    run_count = function() private$.run_count
  ),
  public = list(
    increment = function() private$.run_count <- private$.run_count + 1
  )
)

f <- function(x) {
  print(lubridate::now())
  NULL
}
mf <- memoise(f)

x <- Klass$new()
x$run_count

mf(x)  ## time
mf(x)  ## no time

x$increment()
x$run_count

mf(x)  ## time
mf(x)  ## no time

## memoise relies on package "digest".
## here's a demonstration that changing a private field in an R6 object changes the digest:
digest::digest(x)
x$increment()
digest::digest(x)

## the same can be done for any of the above structures (environments, closures, and lists).

## final conclusion:
## memoise is quite robust.
## in-memory caching is probably fine for lots of applications, but should be considered for long-lived processes.
## though, to manage forgetting, there's `drop_cache`, `forget`, and `timeout`.

f <- function(x) print("foo")
mf <- memoise(f, ~timeout(10))  ## the result of `~timeout(10)` is added as part of the function parameter signature used for caching.
## each time mf is called, `timeout(10)` is called.
## `timeout` holds its own internal cache, and will only return a new different value _after_ the timeout has expired.
## this effectively creates a time-bounded memory.


