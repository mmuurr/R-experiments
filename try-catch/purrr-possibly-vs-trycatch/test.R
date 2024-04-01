microbenchmark::microbenchmark(
  tryCatch((function() TRUE)(), error = function(e) FALSE),
  purrr::possibly(function() TRUE, FALSE)()
)
