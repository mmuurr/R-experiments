library(tidyverse)

new_df <- function() {
  tibble::tibble(foo = runif(10), bar = -runif(10))
}

dfs <- map(seq_len(100), function(i) new_df())

serialize.by_row <- function(df) jsonlite::toJSON(df, dataframe = "rows")
deserialize.by_row <- function(json) json %>% jsonlite::fromJSON(simplifyDataFrame = TRUE) %>% as_tibble()

serialize.by_col <- function(df) jsonlite::toJSON(df, dataframe = "columns")
deserialize.by_col <- function(json) json %>% jsonlite::fromJSON() %>% as_tibble()

rename.snakecase <- function(df) {
  names(df) <- snakecase::to_upper_camel_case(names(df))
  df
}
rename.rename <- function(df) {
  dplyr::rename(df, Foo = foo, Bar = bar)
}
rename.select <- function(df) {
  dplyr::select(df, Foo = foo, Bar = bar)
}

deserialize.by_row.manual <- function(json) {
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    {
      tibble::tibble(
        foo = map_dbl(., "foo", .default = NA_real_),
        bar = map_dbl(., "bar", .default = NA_real_),
        baz = map_dbl(., "baz", .default = NA_real_)
      )
    }
}

deserialize.by_col.manual.purrr_pluck <- function(json) {
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    {
      tibble::tibble(
        foo = pluck(., "foo", .default = NA_real_),
        bar = pluck(., "bar", .default = NA_real_)
      )
    }
}

deserialize.by_col.manual.as_tibble <- function(json) {
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    tibble::as_tibble()
}

deserialize.by_col.manual.base_pluck <- function(json) {
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    { tibble::tibble(
      foo = as.numeric(.$foo),
      bar = as.numeric(.$bar),
      baz = as.numeric(.$baz %||% NA_real_)
    ) }
}

microbenchmark::microbenchmark(
  jsons.by_row <- map(dfs, serialize.by_row),
  jsons.by_col <- map(dfs, serialize.by_col)
)

microbenchmark::microbenchmark(
  map(jsons.by_row, deserialize.by_row),
  map(jsons.by_col, deserialize.by_col),
  map(jsons.by_row, deserialize.by_row.manual),
  map(jsons.by_col, deserialize.by_col.manual.purrr_pluck),
  map(jsons.by_col, deserialize.by_col.manual.base_pluck),
  map(jsons.by_col, deserialize.by_col.manual.as_tibble)
)


microbenchmark::microbenchmark(
  map(jsons.by_row, deserialize.by_row) %>% map(rename.snakecase),
  map(jsons.by_col, deserialize.by_col) %>% map(rename.snakecase)
)

microbenchmark::microbenchmark(
  map(jsons.by_row, deserialize.by_row) %>% map(rename.rename),
  map(jsons.by_col, deserialize.by_col) %>% map(rename.rename)
)

microbenchmark::microbenchmark(
  map(jsons.by_row, deserialize.by_row) %>% map(rename.select),
  map(jsons.by_col, deserialize.by_col) %>% map(rename.select)
)



x <- map(seq_len(1e6), function(i) {
  list(foo = runif(10))
})
microbenchmark::microbenchmark(walk(x, function(x) x$foo), times = 1)

x <- map(seq_len(1e6), function(i) {
  list(foo = runif(10))
})
microbenchmark::microbenchmark(walk(x, function(x) x[["foo"]]), times = 1)

x <- map(seq_len(1e6), function(i) {
  list(foo = runif(10))
})
microbenchmark::microbenchmark(walk(x, function(x) pluck(x, "foo")), times = 1)


df <- new_df()
microbenchmark::microbenchmark(
{
  json <- jsonlite::toJSON(df)
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE)
},
{
  json <- jsonlite::toJSON(df)
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    { tibble::tibble(
      foo = map_dbl(., "foo", .default = NA_real_),
      bar = map_dbl(., "bar", .default = NA_real_)
    ) }
},
{
  json <- jsonlite::toJSON(df, dataframe = "columns")
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE)
},
{
  json <- jsonlite::toJSON(df, dataframe = "columns")
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    { tibble::tibble(foo = .$foo, bar = .$bar) }
},
{
  json <- jsonlite::toJSON(df, dataframe = "columns")
  json %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE) %>%
    tibble::as_tibble()
},
times = 1e3
)


new_x <- function() {
  list(
    rename_me = 1:3,
    leave_me = 3:1,
    rename_me_too = tibble::tibble(
      rename_me = 11:13,
      leave_me = 13:11
    )
  )
}
x <- new_x()


microbenchmark::microbenchmark(
{
  new_x()
},
{
  with(new_x(), list(
    RenameMe = rename_me,
    leave_me = leave_me,
    RenameMeToo = with(rename_me_too, tibble::tibble(
      Rename_me = rename_me,
      leave_me = leave_me
    ))
  ))
},
{
  new_x() %>%
    jsonlite::toJSON()
},
{
  with(new_x(), list(
    RenameMe = rename_me,
    leave_me = leave_me,
    RenameMeToo = with(rename_me_too, tibble::tibble(
      Rename_me = rename_me,
      leave_me = leave_me
      ))
  )) %>%
    jsonlite::toJSON()
},
{
  new_x() %>%
    risio.utils::rename_with_case("lowerCamel", recursive = TRUE) %>%
    jsonlite::toJSON()
},
unit = "ms"
)


json <- '
{
  "_type": "OUTER OUTER",
  "RenameMe": [1,2,3],
  "leave_me": [3,2,1],
  "RenameMeToo": [
    { "_type": "INNER", "RenameMe": 11, "leave_me": 13 },
    { "_type": "INNER", "RenameMe": 12, "leave_me": 12 },
    { "_type": "INNER", "RenameMe": 13, "leave_me": 11 }
  ]
}
'

fromfromJSON <- function(x, ...) {
  UseMethod("fromfromJSON", x)
}


fromfromJSON.default <- function(x, ...) {
  print("in default")
  str(x)
  if (rlang::is_atomic(x) || rlang::is_null(x) || rlang::is_raw(x) || rlang::is_bytes(x)) {
    x
  } else if (rlang::is_list(x)) {
    if (!is.null(x$`_type`)) {
      x <- risio.utils::prepend_class(x, x$`_type`)
      x$`_type` <- NULL
      fromfromJSON(x, ...)
    } else {
      purrr::map(x, fromfromJSON, ...)
    }
  } else {
    x
  }
}


fromfromJSON.INNER <- function(x, ...) {
  print("in INNER")
  str(x)
  with(x, list(
    rename_me = fromfromJSON(RenameMe),
    leave_me = fromfromJSON(leave_me)
  )) %>% risio.utils::prepend_class("Inner")
}

fromfromJSON.OUTER <- function(x, ...) {
  print("in OUTER")
  str(x)
  with(x, list(
    rename_me = fromfromJSON(RenameMe),
    leave_me = fromfromJSON(leave_me),
    rename_me_too = fromfromJSON(RenameMeToo)
  )) %>% risio.utils::prepend_class("Outer")
}

`fromfromJSON.OUTER OUTER` <- function(x, ...) {
  print("in OUTER OUTER")
  str(x)
  with(x, list(
    rename_me = fromfromJSON(RenameMe),
    leave_me = fromfromJSON(leave_me),
    rename_me_too = fromfromJSON(RenameMeToo)
  )) %>% risio.utils::prepend_class("OuterOuter")
}



json %>% jsonlite::fromJSON() %>% fromfromJSON(foo = "bar") %>% str()
