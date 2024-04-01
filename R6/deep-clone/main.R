library(R6)

Val <- R6Class("Val",
  inherit = NULL,
  cloneable = TRUE,
  private = list(
    priv_val = NULL
  ),
  public = list(
    pub_val = NULL,
    initialize = function(val) {
      private$priv_val <- val
      self$pub_val <- val
    }
  )
)

Container <- R6Class("Container",
  inherit = NULL,
  cloneable = TRUE,
  private = list(
    priv_r6 = NULL
  ),
  public = list(
    pub_r6 = NULL,
    initialize = function(val) {
      private$priv_r6 <- Val$new(val)
      self$pub_r6 <- private$priv_r6
    }
  )
)

o1 <- Container$new(1)
o1$pub_r6$pub_val

o2 <- o1$clone(deep = FALSE)
o2$pub_r6$pub_val
o1$pub_r6$pub_val <- 11
o2$pub_r6$pub_val

o3 <- o1$clone(deep = TRUE)
