library(rlang)
library(vctrs)
library(magrittr)

LGR <- lgr::lgr
LGR$add_appender(lgr::AppenderConsole$new(layout = lgr::LayoutJson$new()))
LGR$add_appender(lgr::AppenderConsole$new(layout = lgr::LayoutGlue$new("{pad_right(colorize_levels(toupper(level_name)), 5)} [{timestamp}] {msg}")))

LGR$info("foo")
LGR$info("foo", bar = "baz")
LGR$info("foo {1:10}")


x <- list(foo = "bar")
y <- (x$baz <- "qux")

Klass <- R6::R6Class(
  public = list(
    .data = list(
      x = NULL
    )
  ),
  active = list(
    just_assign = function(x) {
      if (missing(x)) return(self$.data$x)
      self$.data$x <- x
    },
    return_self = function(x) {
      if (missing(x)) return(self$.data$x)
      self$.data$x <- x
      self  ## does nothing since assignments _always_ return the assigned value (invisibly)
    }
  )
)

x <- Klass$new()
y <- (x$just_assign <- 1)  ## y == 1
y <- (x$return_self <- 2)  ## y == 2







MixinBase <- R6::R6Class(
  classname = "MixinBase",
  cloneable = TRUE,
  private   = list(
    finalize = function() self$.parent <- NULL
  ),
  public    = list(
    .parent = NULL,
    initialize = function(...) stop("can't create a stand-alone mixin object"),
    init = function(parent) self$.parent <- parent
  )
)

R6ObjectLgr <- R6::R6Class(
  classname  = "R6ObjectLgr",
  inherit    = NULL,
  cloneable  = TRUE,
  private    = list(
    finalize = function() {
      print("Lgr finalizer")
      #if (!isTRUE(attr(self, "has_been_freed"))) self$free()
      self$free()
    },
    data = list(obj = NULL, lgr = NULL)
  ),
  active     = list(
    obj = function(obj) if (missing(obj)) private$data$obj else private$data$obj <- obj,
    lgr = function(lgr) if (missing(lgr)) (private$data$lgr %||% LGR) else private$data$lgr <- lgr
  ),
  public     = list(
    initialize = function(obj, lgr = NULL) {
      private$data$obj <- obj
      private$data$lgr <- lgr
    },
    free = function() {
      print("Lgr free")
      private$data <- NULL
      attr(self, "has_been_freed") <- TRUE
    },
    logmsg = function(msg = NULL) {
      tryCatch({
        class_name <- class(private$data$obj)[1]
        env_label <- rlang::env_label(private$data$obj)
        sprintf("%s<%s> %s", class_name, env_label, msg) %>% stringr::str_trim()
      }, error = function(e) {
        sprintf("error generating logmsg: %s", conditionMessage(e))
      })
    },
    log = function(level, msg = NULL, ...) {
      self$lgr$log(level, self$logmsg(msg), ...)
    }
  )
)

Base <- R6::R6Class(
  classname  = "Base",
  inherit    = NULL,
  cloneable  = FALSE,
  private    = list(
    finalize = function() {
      print("Base finalizer")
      self$.mixins$obj_lgr <- NULL
    }
  ),
  public     = list(
    .mixins = list(
      obj_lgr = NULL
    ),
    LOG = function(level, msg = NULL, ...) self$.mixins$obj_lgr$log(level, msg, ...),
    initialize = function(...) {
      self$.mixins$obj_lgr <- R6ObjectLgr$new(self, LGR)
      self$LOG("info", "this is a log message", x = 10)
    }
  )
)


Inner <- R6::R6Class(
  private = list(
    finalize = function() {
      print("Inner finalizer")
      self$outer <- NULL  ## clear the reference to outer
    }
  ),
  public = list(
    outer = NULL,
    initialize = function(outer) {
      self$outer <- outer
    }
  )
)

Outer <- R6::R6Class(
  private = list(
    finalize = function() {
      print("Outer finalizer")
      self$inner <- NULL
    }
  ),
  public = list(
    inner = NULL,
    initialize = function() {
      self$inner <- Inner$new(self)
    }
  )
)
    
x <- Outer$new()

## Let's just verify that x and x$inner are what we think they are:
x
x$inner

rm(x)

gc()
