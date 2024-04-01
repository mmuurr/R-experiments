library(tidyverse)
library(microbenchmark)

NROW <- 1e6

data_tbl <- tibble::tibble(chr_col = sample(letters, NROW, TRUE), int_col = as.integer(sample(1:100, NROW, TRUE)))
query_chr <- sample(letters[1:3], size = 10e3, replace = TRUE)
query_int <- sample(as.integer(1:3), size = 10e3, replace = TRUE)
query_tbl.full <- tibble::tibble(chr_col = query_chr, int_col = query_int)
query_tbl.chr <- select(query_tbl.full, chr_col)
query_tbl.int <- select(query_tbl.full, int_col)


microbenchmark(
  filter(data_tbl, chr_col %in% query_chr),
  inner_join(data_tbl, select(query_tbl.full, chr_col), by = "chr_col"),
  inner_join(data_tbl, query_tbl.chr, by = "chr_col"),
  inner_join(data_tbl, tibble::tibble(chr_col = query_chr), by = "chr_col"),
  filter(data_tbl, int_col %in% query_int),
  inner_join(data_tbl, select(query_tbl.full, int_col), by = "int_col"),
  inner_join(data_tbl, query_tbl.int, by = "int_col"),
  inner_join(data_tbl, tibble::tibble(int_col = query_int), by = "int_col"),
  times = 25
)

## Conclusion:
## RDBMSs are optimized for joins, and thus using joins as a filtering mechanism often yields speed benefits.
## Filtering in-R-memory tibbles, however, is substantially faster with `filter` as opposed to using a join.
## Yet-to-be-tested: what about with remote (e.g. RDBMS-backed) tables?
