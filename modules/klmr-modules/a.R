b <- modules::import("b")
print(ls(b))  ## just to see

val_a <- "module a!"

fun_a <- function() {
  print("in fun_a, printing b$val_b")
  print(b$val_b)
}

