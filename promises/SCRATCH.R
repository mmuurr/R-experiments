library(magrittr)
library(promises)
library(future)

# Block until all pending later tasks have executed
wait_for_it <- function(timeout = 30) {
  start <- Sys.time()
  while (!later::loop_empty()) {
    if (difftime(Sys.time(), start, units = "secs") > timeout) {
      stop("Waited too long")
    }
    later::run_now()
    Sys.sleep(0.01)
  }
}

# Block until the promise is resolved/rejected. If resolved, return the value.
# If rejected, throw (yes throw, not return) the error.
extract <- function(promise) {
  promise_value <- NULL
  promise_error <- NULL
  promise %>%
    then(function(x) promise_value <<- x) %>%
    catch(function(x) promise_error <<- x)

  wait_for_it()
  if (!is.null(promise_error)) stop(promise_error) else return(promise_value)
}


tempf <- function(promise) {
  promise %>%
    then(function(val) {
      print("first then")
      stop("foo")
      val + 1
    }) %>%
    then(function(val) {
      print("second then")
      val + 1
    }) %>%
    catch(function(err) {
      print("error handler")
      stop(err)
    })
}



f <- future({
  print("starting")
  Sys.sleep(5)
  print("completing")
  0
})


v <- {
  cat("Hello, world!\n")
  Sys.sleep(3.14)
  3.14
}
v

v %<-% {
  cat("Hello, world!\n")
  Sys.sleep(3.14)
  3.14
}
v


f <- future({
  cat("hello")
  Sys.sleep(3.14)
  print(x)
  x <- 3.14
  3.14
}, globals = FALSE)
print("foo")
print(value(f))
print("bar")



sleep <- Sys.sleep

future_tempf <- function(mult) {
  future({
    cat(Sys.getpid(), sep = "\n")
    Sys.sleep(3.14)
    3.14 * mult
  })
}
f <- purrr::map(1:9, future_tempf)
purrr::map_dbl(f, value)




plan(multisession(workers = 2))

sleep <- Sys.sleep
pid <- Sys.getpid
slow_f <- function(x) {
  cat(sprintf("BEGIN: logging %s from pid %s\n", x, pid()), file = "output.txt", append = TRUE)
  sleep(1)
  cat(sprintf("END: logging %s from pid %s\n", x, pid()), file = "output.txt", append = TRUE)
}
handle <- function(x) {
  future(slow_f(x))
  x
}

plan(multicore, workers = "localhost")
cat(sprintf("REPL pid = %s\n", pid()), file = "output.txt", append = FALSE)
f <- purrr::map(1:5, handle)



emit <- function(x = "<NO VAL>", label = "<NO LABEL>", file = "output.txt", append = TRUE) {
  cat(sprintf("label: %s; pid: %s; time: %s; val: %s\n",
    label,
    Sys.getpid(),
    Sys.time(),
    x
  ), file = file, append = append)
}

tempf <- function(x, delay = 2) {
  later::with_temp_loop(
    later::later(function() { emit(x, "later"); Sys.sleep(2) }, delay = delay)
  )
}

emit(label = "REPL", append = FALSE)
tempf(1)
tempf(2)
print("foo")
tempf(3)
tempf(4)
print("bar")




## How to get _exactly_ two R sessions in multisession?

sleep <- Sys.sleep
pid <- Sys.getpid
now <- function() format(Sys.time(), "%H:%M:%OS6")
msg <- function(label) {
  cat(sprintf("%s pid=%s now=%s\n", label, pid(), now()))
}

f <- function(label) {
  msg(label)
  sleep(2)
  NULL
}

plan(multicore, workers = 2)
f1 <- future(f("f1"))
f2 <- future(f("f2"))
msg("MAIN")
sleep(2)
value(f1)
value(f2)

plan(multicore, workers = 1)
f1 <- future(f("f1"))
f2 <- future(f("f2"))
msg("MAIN")
sleep(2)
value(f1)
value(f2)





later::later(function() print("foo"), delay = 3)
later::with_temp_loop({
  later::later(function() print("bar"), delay = 3)
  later::run_now(Inf)
})
while (TRUE) {
  print(now())
  sleep(1)
}
