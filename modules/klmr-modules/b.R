a <- modules::import("a")

val_b <- "module b!"

fun_b <- function() {
  print("in fun_b, calling a$fun_a()")
  a$fun_a()
}
