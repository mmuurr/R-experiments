library(tidyverse)
library(jsonlite)

source_obj <- list(
  grader_type = "SOME_GRADER_TYPE",
  requested_player_answer_count = 3,
  submitted_player_answer_count = 3,
  normalized_player_answer_table = tibble::tibble(
    player_answer_ix = 1:3,
    raw = letters[1:3],
    word = letters[1:3],
    phrase = letters[1:3]
  ),
  correct_match_ix_table = tibble::tibble(
    player_answer_ix = 1:3,
    question_answer_ix = 3:1
  )
)

tojson_rename_funs = list(
  no_renaming = function(x) x,
  add_type = function(x) list("_type" = "some type") %>% c(x),
  force_copy = function(x) rev(x),
  base_rebuild = function(x) {
    with(x, list(
      graderType = grader_type,
      requestedPlayerAnswerCount = requested_player_answer_count,
      submittedPlayerAnswerCount = submitted_player_answer_count,
      normalizedPlayerAnswerTable = with(normalized_player_answer_table, tibble::tibble(
        playerAnswerIx = player_answer_ix,
        raw = raw,
        word = word,
        phrase = phrase
      )),
      correctMatchIxTable = with(correct_match_ix_table, tibble::tibble(
        playerAnswerIx = player_answer_ix,
        questionAnswerIx = question_answer_ix
      ))
    ))
  },
  simple_rename = function(x) {
    simple_rename(x, c(
      "grader_type" = "graderType",
      "requested_player_answer_count" = "requestedPlayerAnswerCount",
      "submitted_player_answer_count" = 'submittedPlayerAnswerCount',
      'normalized_player_answer_table' = 'normalizedPlayerAnswerTable',
      'correct_match_ix_table' = 'correctMatchIxTable')) %>%
      modify_at("normalizedPlayerAnswerTable", simple_rename, c("player_answer_ix" = 'playerAnswerIx')) %>%
      modify_at('correctMatchIxTable', simple_rename, c('player_answer_ix' = 'playerAnswerIx', 'question_answer_ix' = 'questionAnswerIx'))
  },
  recursive_simple_rename = function(x) {
    simple_rename(
      x, 
      old2new = c(
        "grader_type" = "graderType",
        "requested_player_answer_count" = "requestedPlayerAnswerCount",
        "submitted_player_answer_count" = 'submittedPlayerAnswerCount',
        'normalized_player_answer_table' = 'normalizedPlayerAnswerTable',
        'correct_match_ix_table' = 'correctMatchIxTable',
        'player_answer_ix' = 'playerAnswerIx',
        'question_answer_ix' = 'questionAnswerIx'
      ),
      recursive = TRUE
    )
  },
  base_rebuild_base_df = function(x) {
    with(x, list(
      graderType = grader_type,
      requestedPlayerAnswerCount = requested_player_answer_count,
      submittedPlayerAnswerCount = submitted_player_answer_count,
      normalizedPlayerAnswerTable = with(normalized_player_answer_table, data.frame(
        playerAnswerIx = player_answer_ix,
        raw = raw,
        word = word,
        phrase = phrase
      )),
      correctMatchIxTable = with(correct_match_ix_table, data.frame(
        playerAnswerIx = player_answer_ix,
        questionAnswerIx = question_answer_ix
      ))
    ))
  },
  base_rebuild_rename = function(x) {
    with(x, list(
      graderType = grader_type,
      requestedPlayerAnswerCount = requested_player_answer_count,
      submittedPlayerAnswerCount = submitted_player_answer_count,
      normalizedPlayerAnswerTable = rename(normalized_player_answer_table, playerAnswerIx = player_answer_ix),
      correctMatchIxTable = rename(correct_match_ix_table, playerAnswerIx = player_answer_ix, questionAnswerIx = question_answer_ix)
    ))
  },
  tidy_rename_rebuild = function(x) {
    x %>%
      tidyselect:::rename(
        graderType = grader_type,
        requestedPlayerAnswerCount = requested_player_answer_count,
        submittedPlayerAnswerCount = submitted_player_answer_count,
        normalizedPlayerAnswerTable = normalized_player_answer_table,
        correctMatchIxTable = correct_match_ix_table
      ) %>%
      purrr::modify_at("normalizedPlayerAnswerTable", rename, playerAnswerIx = player_answer_ix, raw = raw, word = word, phrase = phrase) %>%
      purrr::modify_at("correctMatchIxTable", rename, playerAnswerIx = player_answer_ix, questionAnswerIx = question_answer_ix)
  }
)

fromfromjson_rename_funs = list(
  no_renaming = function(x) x,
  base_rebuild = function(x) {
    with(x, list(
      grader_type = graderType,
      requested_player_answer_count = requestedPlayerAnswerCount,
      submitted_player_answer_count = submittedPlayerAnswerCount,
      normalized_player_answer_table = with(normalizedPlayerAnswerTable, tibble::tibble(
        player_answer_ix = playerAnswerIx,
        raw = raw,
        word = word,
        phrase = phrase
      )),
      correct_match_ix_table = with(correctMatchIxTable, tibble::tibble(
        player_answer_ix = playerAnswerIx,
        question_answer_ix = questionAnswerIx
      ))
    ))
  }
)

microbenchmark::microbenchmark(
  source_obj %>% tojson_rename_funs$no_renaming() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$add_type() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$force_copy() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$simple_rename() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$recursive_simple_rename() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$base_rebuild() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$base_rebuild_base_df() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$base_rebuild_rename() %>% jsonlite::toJSON(),
  source_obj %>% tojson_rename_funs$tidy_rename_rebuild() %>% jsonlite::toJSON()
)

json <- source_obj %>% tojson_rename_funs$base_rebuild() %>% jsonlite::toJSON()

microbenchmark::microbenchmark(
  json %>% jsonlite::fromJSON() %>% fromfromjson_rename_funs$no_renaming(),
  json %>% jsonlite::fromJSON() %>% fromfromjson_rename_funs$base_rebuild()
)
  
namepairs <- tibble::tribble(
  ~r_name, ~json_name,
  "grader_type", "graderType",
  "requested_player_answer_count", "requestedPlayerAnswerCount",
  "submitted_player_answer_count", "submittedPlayerAnswerCount",
  "normalized_player_answer_table", "normalizedPlayerAnswerTable",
  "correct_match_ix_table", "correctMatchIxTable",
  "player_answer_ix", "playerAnswerIx",
  "question_answer_ix", "questionAnswerIx",
  "raw", "raw",
  "word", "word",
  "phrase", "phrase"
)

r2json <- namepairs$json_name %>% set_names(namepairs$r_name)
json2r <- namepairs$r_name %>% set_names(namepairs$json_name)


recrename <- function(x) {
  if (rlang::is_null(x)) return(x)
  if (rlang::is_named(x)) {
    names(x) <- r2json[names(x)] %|% names(x)
  }
  if (rlang::is_atomic(x)) {
    recrename(x)
  }
  x
}
r2json[names(source_obj)] %|% names(source_obj)


#' @importFrom rlang %|%
#' @export
simple_rename <- function(x, old2new = character(0), recursive = FALSE, recursive_classes = "list") {
  if (is.null(x) || length(x) == 0) return(x)
  if (is.null(old2new) || length(old2new) == 0 || !rlang::is_named(old2new)) return(x)
  
  if (rlang::is_named(x)) {
    names(x) <- old2new[names(x)] %|% as.character(names(x))
  }

  if (isTRUE(recursive) && isTRUE(inherits(x, recursive_classes))) {
    x <- purrr::modify(x, simple_rename, old2new, recursive)
  }

  x
}

#' @export
#' @describeIn simple_rename
simpleRename <- simple_rename
