library(microbenchmark)

## fl
library(futile.logger)
t1 <- tempfile()
flog.appender(appender.file(t1))
#> NULL

## lg
##library(logging)
#t2 <- tempfile()
#addHandler(writeToFile, file = t2)

## lr
library(logger)
#> The following objects are masked from ‘package:futile.logger’: DEBUG, ERROR, FATAL, INFO, TRACE, WARN
t3 <- tempfile()
log_appender(appender_file(t3))

## lgr
library(lgr)
t4 <- tempfile()
lgr$set_appenders(AppenderFile$new(t4, layout = LayoutJson$new()))

string_fl <- function() flog.info('hi')
string_lg <- function() loginfo('hi')
string_lr <- function() log_info('hi')
string_lgr <- function() lgr$info('hi')
dynamic_fl <- function() flog.info('hi %s', 42)
dynamic_lg <- function() loginfo('hi %s', 42)
dynamic_lr <- function() log_info('hi {42}')
dynamic_lgr <- function() lgr$info('hi', 42)
vector_fl <- function() flog.info(paste('hi', 1:5))
vector_lg <- function() loginfo(paste('hi', 1:5))
vector_lr <- function() log_info('hi {1:5}')
vector_lgr <- function() lgr$info('hi', 1:5)

string_fl <- function() try(flog.info('hi'))
string_lg <- function() try(loginfo('hi'))
string_lr <- function() try(log_info('hi'))
string_lgr <- function() try(lgr$info('hi'))
dynamic_fl <- function() try(flog.info('hi %s', 42))
dynamic_lg <- function() try(loginfo('hi %s', 42))
dynamic_lr <- function() try(log_info('hi {42}'))
dynamic_lgr <- function() try(lgr$info('hi', 42))
vector_fl <- function() try(flog.info(paste('hi', 1:5)))
vector_lg <- function() try(loginfo(paste('hi', 1:5)))
vector_lr <- function() try(log_info('hi {1:5}'))
vector_lgr <- function() try(lgr$info('hi', 1:5))

do_log.sentinel <- NULL
DO_LOG <- function() !is.null(do_log.sentinel)

string_fl <- function() if(DO_LOG()) flog.info('hi')
string_lg <- function() if(DO_LOG()) loginfo('hi')
string_lr <- function() if(DO_LOG()) log_info('hi')
string_lgr <- function() if(DO_LOG()) lgr$info('hi')
dynamic_fl <- function() if(DO_LOG()) flog.info('hi %s', 42)
dynamic_lg <- function() if(DO_LOG()) loginfo('hi %s', 42)
dynamic_lr <- function() if(DO_LOG()) log_info('hi {42}')
dynamic_lgr <- function() if(DO_LOG()) lgr$info('hi', 42)
vector_fl <- function() if(DO_LOG()) flog.info(paste('hi', 1:5))
vector_lg <- function() if(DO_LOG()) loginfo(paste('hi', 1:5))
vector_lr <- function() if(DO_LOG()) log_info('hi {1:5}')
vector_lgr <- function() if(DO_LOG()) lgr$info('hi', 1:5)

string_fl <- function() if (requireNamespace("futile.logger", quietly = TRUE)) flog.info('hi')
string_lg <- function() loginfo('hi')
string_lr <- function() if (requireNamespace("logger", quietly = TRUE)) log_info('hi')
string_lgr <- function() if (requireNamespace("lgr", quietly = TRUE)) lgr$info('hi')
dynamic_fl <- function() if (requireNamespace("futile.logger", quietly = TRUE)) flog.info('hi %s', 42)
dynamic_lg <- function() loginfo('hi %s', 42)
dynamic_lr <- function() if (requireNamespace("logger", quietly = TRUE)) log_info('hi {42}')
dynamic_lgr <- function() if (requireNamespace("lgr", quietly = TRUE)) lgr$info('hi', 42)
vector_fl <- function() if (requireNamespace("futile.logger", quietly = TRUE)) flog.info(paste('hi', 1:5))
vector_lg <- function() loginfo(paste('hi', 1:5))
vector_lr <- function() if (requireNamespace("logger", quietly = TRUE)) log_info('hi {1:5}')
vector_lgr <- function() if (requireNamespace("lgr", quietly = TRUE)) lgr$info('hi', 1:5)

string_fl <- function() flog.debug('hi')
string_lg <- function() logdebug('hi')
string_lr <- function() log_debug('hi')
string_lgr <- function() lgr$debug('hi')
dynamic_fl <- function() flog.debug('hi %s', 42)
dynamic_lg <- function() logdebug('hi %s', 42)
dynamic_lr <- function() log_debug('hi {42}')
dynamic_lgr <- function() lgr$debug('hi', 42)
vector_fl <- function() flog.debug(paste('hi', 1:5))
vector_lg <- function() logdebug(paste('hi', 1:5))
vector_lr <- function() log_debug('hi {1:5}')
vector_lgr <- function() lgr$debug('hi', 1:5)

string_fl <- function() if (requireNamespace("futile.logger", quietly = TRUE)) flog.debug('hi')
string_lg <- function() logdebug('hi')
string_lr <- function() if (requireNamespace("logger", quietly = TRUE)) log_debug('hi')
string_lgr <- function() if (requireNamespace("lgr", quietly = TRUE)) lgr$debug('hi')
dynamic_fl <- function() if (requireNamespace("futile.logger", quietly = TRUE)) flog.debug('hi %s', 42)
dynamic_lg <- function() logdebug('hi %s', 42)
dynamic_lr <- function() if (requireNamespace("logger", quietly = TRUE)) log_debug('hi {42}')
dynamic_lgr <- function() if (requireNamespace("lgr", quietly = TRUE)) lgr$debug('hi', 42)
vector_fl <- function() if (requireNamespace("futile.logger", quietly = TRUE)) flog.debug(paste('hi', 1:5))
vector_lg <- function() logdebug(paste('hi', 1:5))
vector_lr <- function() if (requireNamespace("logger", quietly = TRUE)) log_debug('hi {1:5}')
vector_lgr <- function() if (requireNamespace("lgr", quietly = TRUE)) lgr$debug('hi', 1:5)

string_fl <- function() if (requireNamespace("foo.futile.logger", quietly = TRUE)) flog.debug('hi')
string_lg <- function() logdebug('hi')
string_lr <- function() if (requireNamespace("foo.logger", quietly = TRUE)) log_debug('hi')
string_lgr <- function() if (requireNamespace("foo.lgr", quietly = TRUE)) lgr$debug('hi')
dynamic_fl <- function() if (requireNamespace("foo.futile.logger", quietly = TRUE)) flog.debug('hi %s', 42)
dynamic_lg <- function() logdebug('hi %s', 42)
dynamic_lr <- function() if (requireNamespace("foo.logger", quietly = TRUE)) log_debug('hi {42}')
dynamic_lgr <- function() if (requireNamespace("foo.lgr", quietly = TRUE)) lgr$debug('hi', 42)
vector_fl <- function() if (requireNamespace("foo.futile.logger", quietly = TRUE)) flog.debug(paste('hi', 1:5))
vector_lg <- function() logdebug(paste('hi', 1:5))
vector_lr <- function() if (requireNamespace("foo.logger", quietly = TRUE)) log_debug('hi {1:5}')
vector_lgr <- function() if (requireNamespace("foo.lgr", quietly = TRUE)) lgr$debug('hi', 1:5)

string_fl <- function() try(if (requireNamespace("foo.futile.logger", quietly = TRUE)) flog.debug('hi'))
string_lg <- function() logdebug('hi'))
string_lr <- function() try(if (requireNamespace("foo.logger", quietly = TRUE)) log_debug('hi'))
string_lgr <- function() try(if (requireNamespace("foo.lgr", quietly = TRUE)) lgr$debug('hi'))
dynamic_fl <- function() try(if (requireNamespace("foo.futile.logger", quietly = TRUE)) flog.debug('hi %s', 42))
dynamic_lg <- function() logdebug('hi %s', 42))
dynamic_lr <- function() try(if (requireNamespace("foo.logger", quietly = TRUE)) log_debug('hi {42}'))
dynamic_lgr <- function() try(if (requireNamespace("foo.lgr", quietly = TRUE)) lgr$debug('hi', 42))
vector_fl <- function() try(if (requireNamespace("foo.futile.logger", quietly = TRUE)) flog.debug(paste('hi', 1:5)))
vector_lg <- function() logdebug(paste('hi', 1:5)))
vector_lr <- function() try(if (requireNamespace("foo.logger", quietly = TRUE)) log_debug('hi {1:5}'))
vector_lgr <- function() try(if (requireNamespace("foo.lgr", quietly = TRUE)) lgr$debug('hi', 1:5))

foo <- NULL
microbenchmark(
  if (requireNamespace("lgr", quietly = TRUE)) try(lgr$info("foo", "bar"), silent = TRUE),
  if (requireNamespace("foo.lgr", quietly = TRUE)) try(lgr$info("foo", "bar"), silent = TRUE),
  try(foo$info("foo", "bar"), silent = TRUE),
  try(lgr$info("foo", "bar"), silent = TRUE),
  lgr$info("foo", "bar")
)


microbenchmark(
  string_fl(),
  #string_lg(),
  string_lr(),
  string_lgr(),
  vector_fl(),
  #vector_lg(),
  vector_lr(),
  vector_lgr(),
  dynamic_fl(),
  #dynamic_lg(),
  dynamic_lr(),
  dynamic_lgr()
)



Klass <- R6::R6Class("Klass",
  public = list(
    env1 = function() {
      environment()
    },
    env2 = function() {
      parent.env(environment())
    },
    env3 = function() {
      capture.output(parent.env(environment()))
    }
  )
)
obj <- Klass$new()
obj$env1()
obj$env2()
obj$.__enclos_env__
str(obj$env3())


foo <- NULL
microbenchmark::microbenchmark(
  lgr$info("foo", bar = 1:5, baz = iris),
  try(lgr$info("foo", bar = 1:5, baz = iris), silent = TRUE),
  try(foo$info("foo", bar = 1:5, baz = iris), silent = TRUE),
  lgr$debug("foo", bar = 1:5, baz = iris),
  try(lgr$debug("foo", bar = 1:5, baz = iris), silent = TRUE),
  try(foo$debug("foo", bar = 1:5, baz = iris), silent = TRUE)
)
