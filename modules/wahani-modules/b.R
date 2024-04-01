a <- modules::use("a.R")

val_b <- "b!"

fun_b <- function() {
  print("in fun_b, calling a$fun_a")
  a$fun_a()
}
