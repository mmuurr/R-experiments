f <- function(i) {
  print(sys.nframe())
  if (i < 10) f(i+1) else NULL
}


repeat_later <- function(f, delay) {
  force(f)
  force(delay)
  later_loop <- later::create_loop()
  later_f <- function() {
    f()
    recurse()
  }
  recurse <- function() {
    later::later(later_f, delay, later_loop)
  }
  recurse()
  later_loop  ## return later_loop so it can be destroyed
}


print_time <- function() {
  print(Sys.time())
  i <<- i + 1
}
