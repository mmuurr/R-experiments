modules::import_package("tibble", attach = TRUE)
b <- modules::import("mod-b")

f.a <- function() {
  print(b$f.b())
  print("a")
  print(as_tibble(mtcars))
}

