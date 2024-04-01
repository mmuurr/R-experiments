mod_a <- modules::use("mod-a.R")

mod <- modules::module(
  aaa <- "foo"
)

mod$a
mod$aa
mod$aaa

mod <- new.env(parent = emptyenv())
mod$aaa <- "foo"
