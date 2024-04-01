modules::use("modbase.R")$r_defaults()

print(runif(10))

f <- function() runif(10)

modules::export(f)
