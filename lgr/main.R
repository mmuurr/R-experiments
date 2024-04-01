library(murlib.core)

root_lgr <- lgr::lgr
foo_lgr <- lgr::get_logger("foo")
bar_lgr <- lgr::get_logger("foo/bar")
baz_lgr <- bar_lgr$spawn("baz")

layout <-
  lgr::LayoutFormat$new(
    fmt = "%L [%t] [%g] %m %f",
    timestamp_fmt = "%FT%H:%M:%OS6%z",
    pad_levels = "left"
  )

root_lgr$appenders[[1]]$set_layout(layout)

new_logfun <- function(lgr = lgr::lgr) {
  function(...) {
    try(lgr$log(...))
  }
}

caller_logfun <- function(logfun_name = "LOG") {
  get0(logfun_name, envir = rlang::caller_env(2), ifnotfound = nop)
}

LOG <- new_logfun(bar_lgr)

root_lgr$set_threshold("trace")

LOG("info", "here's an info message")
LOG("debug", "here's a debug message")
LOG("trace", "here's a trace message")

