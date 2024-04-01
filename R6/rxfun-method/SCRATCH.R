library(tidyverse)

invalidator <- function() {
  .count <- 0
  .rxval <- shiny::reactiveVal(.count)
  invalidate <- function() {
    .count <<- .count + 1
    .rxval(.count)
  }
  depend <- function() {
    .rxval()
  }
  list(
    invalidate = invalidate,
    depend = depend
  )
}

##==============================================================================
## Klass 1 fails
##==============================================================================
if (FALSE) {
  Klass1 <- R6::R6Class(
    classname = "Klass1",
    inherit = NULL,
    cloneable = TRUE,
    private = list(
      .mult = 0,
      .invalidator = NULL
    ),
    public = list(
      initialize = function(mult, invalidator) {
        private$.mult <- mult
        private$.invalidator <- invalidator
      },
      rxfun = shiny::reactive({
        private$.invalidator$depend() * private$.mult
      })
    )
  )

  inv1 <- invalidator()
  inv2 <- invalidator()

  obj1 <- Klass1$new(1, invalidator())
  obj2 <- Klass1$new(2, invalidator())

  obs1 <- shiny::observe(print(obj1$rxfun()))
  obs2 <- shiny::observe(print(obj2$rxfun()))

  shiny:::flushReact()
}
  
##===============================================================================
## Klass 2
##===============================================================================

Klass2 <- R6::R6Class(
  classname = "Klass2",
  inherit = NULL,
  cloneable = TRUE,
  private = list(
    .mult = NULL,
    .invalidator = NULL,
    .rxfun = NULL,
    .rxfun.init = function() {
      private$.rxfun <- shiny::reactive({
        private$.invalidator$depend() * private$.mult
      })
    }
  ),
  public = list(
    initialize = function(mult, invalidator) {
      private$.mult <- mult
      private$.invalidator <- invalidator
      private$.rxfun.init()
    },
    rxfun = function() private$.rxfun()
  )
)


inv1 <- invalidator()
inv2 <- invalidator()

obj1 <- Klass2$new(1, inv1)
obj2 <- Klass2$new(2, inv2)

obs1 <- shiny::observe(print(obj1$rxfun()))
obs2 <- shiny::observe(print(obj2$rxfun()))

shiny:::flushReact()

inv1$invalidate()
## expect: obj1:inv1=1,mult=1,rxfun=1; obj2:silent
shiny:::flushReact()

inv1$invalidate()
inv2$invalidate()
## expect: obj1:inv1=2,mult=1,rxfun=2; obj2:inv2=1,mult=2,rxfun=2
shiny:::flushReact()

inv1$invalidate()
inv2$invalidate()
## expect: obj1:inv1=3,mult=1,rxfun=3; obj2:inv2=2,mult=2,rxfun=4
shiny:::flushReact()


