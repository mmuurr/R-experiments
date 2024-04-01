WithoutObs <- R6::R6Class("WithoutObs",
  private = list(
    finalize = function() {
      print(sprintf("%s: running finalize()", class(self)[1]))
    }
  ),
  public = list(
    initialize = function() {
      ## NOP
    }
  )
)

WithObs <- R6::R6Class("WithObs",
  private = list(
    obs = NULL,
    finalize = function() {
      print(sprintf("%s: running finalize()", class(self)[1]))
      private$obs$destroy()
    }
  ),
  public = list(
    initialize = function(rx) {
      private$obs <- shiny::observe(print(rx()))
    },
    destroy_obs = function() {
      private$obs$destroy()
    }
  )
)

rxval <- shiny::reactiveVal(0)
without_obs <- WithoutObs$new()
with_obs <- WithObs$new(rxval)
with_obs$destroy_obs()

rm(without_obs, with_obs)
gc()

shiny:::flushReact()
gc()


