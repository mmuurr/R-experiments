b <- modules::use("b.R")

val_a <- "a!"

fun_a <- function() {
  print("in fun_a, printing b$val_b")
  print(b$val_b)
}
