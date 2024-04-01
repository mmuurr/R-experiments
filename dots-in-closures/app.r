x <- 1
y <- 2

genf <- function(...) {
  force(list(...))
  function() {
    print(list(...))
  }
}

f <- genf(x,y)

f()

x <- 10
y <- 20
f()

rm(x,y)
f()

anyalltrue_replacement <- function(x, null = NULL, empty = null) {
  null_lix <- vapply(x, is.null, logical(1))
  empty_lix <- vapply(x, length, numeric(1)) == 0
  x[null_lix] <- null
  x[empty_lix] <- empty
  x
}

alltrue <- function(..., .na.rm = TRUE, .null = TRUE, .empty = .null) {
  x <- anyalltrue_replacement(list(...), null = .null, empty = .empty)
  all(x, na.rm = .na.rm)
}

anytrue <- function(..., .na.rm = TRUE, .null = FALSE, .empty = .null) {
  x <- anyalltrue_replacement(list(...), null = .null, empty = .empty)
  any(x, na.rm = .na.rm)
}
