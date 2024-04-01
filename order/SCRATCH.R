## I remember the moral of the story here:
##------------------------------------------------------------------------------
## The default implementation of `order` does a bunch of clever things to handle different scenarios somewhat elegantly.
## Matrix inputs, factor inputs, complex number inputs, etc.
## The decision logic needed to handle NAs along the wider input types causes a bit of a slowdown for ordering large vectors.
## When the input is a numeric vector without any surprises, you can simplify things a bit re: NA handling.
##
## The example below uses the microbenchmark package to measure these time differences.
## Both order functions return the same results **for numeric inputs**.
##------------------------------------------------------------------------------

original_order <- function(x) {
  order(x, decreasing = TRUE, na.last = NA)
}

other_order <- function(x) {
  iix <- order(x, decreasing = TRUE, na.last = TRUE)
  iix[!is.na(x[iix])]
}

## This generates a runif sample but allows us to spike in NAs at some rate (`prop_na`).
other_runif <- function(n, min = 0, max = 1, prop_na = 0) {
  x <- runif(n, min, max)
  x[sample(c(TRUE,FALSE), size = n, replace = TRUE, prob = c(prop_na, 1 - prop_na))] <- NA_real_
  x
}

## example usage:
other_runif(20, prop_na = 0.25)  ## there should be ~5 NAs (on average)

## Let's quickly (but not robustly) make sure these two functions are identical in their output. (`identical` calls should return `TRUE`.)

## first with zero NAs:
foo <- other_runif(1e5)
identical(original_order(foo), other_order(foo))

## now with lots of NAs:
foo <- other_runif(1e5, prop_na = 0.75)
identical(original_order(foo), other_order(foo))

## Okay, now let's do some performance comparisons.

## First, let's compare the two orderers when there are zero NAs present:

microbenchmark::microbenchmark(
  original_order(other_runif(1e5)),
  other_order(other_runif(1e5))
)

## The `other_order` is slightly slower.

## Now, let's run that comparison when there are lots of NAs present:

microbenchmark::microbenchmark(
  original_order(other_runif(1e5, prop_na = 0.75)),
  other_order(other_runif(1e5, prop_na = 0.75))
)

## Hm, `other_order` is still slightly slower.

## I think `order` has been updated such that the original speed issue is no longer an issue.
## I might poke around some more to replicate, but it appears that for numeric vector inputs, sticking with `original_order` is probably the right thing to do.
