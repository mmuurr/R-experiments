## sanidate = sanitize + validate

##========================================
## GradeModeType (enum)
##----------------------------------------
## * ALL_OR_NOTHING
## * FRACTIONAL
##========================================

##========================================
## AnswerConfigType
##----------------------------------------
## * MULTICHOICE_ANSWER_CONFIG
## * TEST_ANSWER_CONFIG
##========================================


Enum <- function(enum_name, values) {

  valid_value_regex <- "^[A-Z][A-Z0-9_]*$"

  values <- values |>
    as.character() |>
    unique() |>
    checkmate::assertCharacter(pattern = valid_value_regex)

  values_regex <- sprintf("^(%s)$", paste0(values, collapse = "|"))
  
  enum_name <- (enum_name %||% "") %>%
    as.character() %>%
    checkmate::assertString()

  sanitize <- function(x) {
    x %>%
      as.character() %>%
      stringr::str_to_upper() %>%
      stringr::str_replace_all("-", "_") %>%
      stringr::str_trim()
  }

  validate <- function(x) {
    x %>%
      stringr::str_detect(values_regex)
  }

  new <- function(x, .default = NA_character_, .sanitize = TRUE, .assert = FALSE) {
    .default <- .default %>% as.character() %>% checkmate::assertString(na.ok = TRUE)
    .assert <- .assert %>% checkmate::assertFlag()
    if (.sanitize) x <- sanitize(x)
    valid_lix <- validate(x)
    if (any(!valid_lix)) {
      if (.assert) {
        stop(sprintf("unrecognized %s enum value(s) (%s), must be one of %s", enum_name, paste0(unique(x[!valid_lix]), collapse = ", "), paste0(values, collapse = ", ")))
      } else {
        warning(sprintf("unrecognized %s enum value(s) (%s), replacing with %s", enum_name, paste0(unique(x[!valid_lix]), collapse = ", "), .default))
      }
    }
    x[!valid_lix] <- .default
    return(x)
  }

  retval <- as.list(values) %>% set_names(values)
  retval$values <- values
  retval$new <- new
  return(xfun::as_strict_list(retval))
}

GradeMode <- Enum("GradeMode", c(
  "ALL_OR_NOTHING"
 ,"FRACTIONAL"
))

QuestionType <- Enum("QuestionType", c(
  "MULTICHOICE_QUESTION"
 ,"SINGLETEXT_QUESTION"
 ,"ORDERED_MULTITEXT_QUESTION"
 ,"UNORDERED_MULTITEXT_QUESTION"
))

AnswerConfigType <- Enum("AnswerConfigType", c(
  "TEXT_ANSWER_CONFIG"
 ,"MULTICHOICE_ANSWER_CONFIG"
))




