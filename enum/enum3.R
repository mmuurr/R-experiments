x <- c("all_or_NOTHing", "fractional", NA, "Fractional   ")

GradeMode <- SimpleEnum(c("all_or_nothing", "fractional"))

y <- GradeMode$cast(x)

y %=enum=% "all_or_nothing"



valid_enum_val_regex <- "^[A-Z_][A-Z0-9_]*$"
SimpleEnum <- R6::R6Class(
  classname = "SimpleEnum",
  inherit = NULL,
  cloneable = FALSE,
  public = list(
    enum_vals = character(0),
    initialize = function(enum_vals, ...) {
      self$enum_vals <-
        enum_vals |>
        stringr::str_trim() |>
        stringr::str_to_upper() |>
        checkmate::assert_character(pattern = valid_enum_val_regex, any.missing = FALSE, all.missing = FALSE, unique = TRUE)
    },
    cast = function(x) {
      
    }
  )
)


GradeMode <- list(
  ALL_OR_NOTHING = "ALL_OR_NOTHING",
  FRACTIONAL = "FRACTIONAL"
)
