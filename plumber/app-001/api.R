library(magrittr)
library(tidyverse)
library(plumber)

shiny::observe({
  invalidateLater(1000)
  print(Sys.time())
})


loop <- function(f, delay) {
  later::later(function() {
    f()
    loop(f, delay)
  }, delay)
}
loop(print_hello, 2)

repeat_later <- function(f, delay) {
  force(f)
  force(delay)
  later_loop <- later::create_loop()
  later_f <- function() {
    print(sys.nframe())
    print(sys.parents())
    f()
    recurse()
  }
  recurse <- function() {
    later::later(later_f, delay, later_loop)
  }
  recurse()
  later_loop  ## return later_loop so it can be destroyed
}

print_time <- function() print(Sys.time())

loop_handle <- repeat_later(print_time, 2)

## this will print the time every 2 seconds until one calls later::destroy_loop(loop_handle)





ROUTER <-
  pr(file = NULL, filters = NULL)

pr_run(ROUTER)


