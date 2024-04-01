LGR <- lgr::lgr
LGR$set_threshold("trace")

LGR$info("registering deferred for two seconds from now")
later::later(function() {
  LGR$info("in deferred; about to sleep for 5 seconds")
  Sys.sleep(5)
  LGR$info("in deferred; done sleeping")
}, 2)

LGR$info("main: about to sleep")
Sys.sleep(4)
LGR$info("main: back from sleep")


