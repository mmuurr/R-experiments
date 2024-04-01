PG_PARAMS <- list(
  host = "localhost",
  dbname = "trivia",
  user = "trivia"
)


admin_conn <- do.call(DBI::dbConnect, c(list(RPostgres::Postgres()), PG_PARAMS, list(application_name = "admin")))

pool <- do.call(
  pool::dbPool,
  c(
    list(drv = RPostgres::Postgres()),
    PG_PARAMS,
    list(application_name = "pool"),
    list(validateQuery = "select 1", validationInterval = 0)
  )
)

admin_pid <- DBI::dbGetQuery(admin_conn, "select pid from pg_stat_activity where application_name = 'admin'")[[1]][[1]]
original_pool_pid <- DBI::dbGetQuery(admin_conn, "select pid from pg_stat_activity where application_name = 'pool'")[[1]][[1]]

DBI::dbGetQuery(pool, "select 1")

## now break the connection from within PostgreSQL
DBI::dbExecute(admin_conn, "select pg_terminate_backend(pid) from pg_stat_activity where pid = $1", original_pool_pid)
DBI::dbGetQuery(pool, "select 1")

new_pool_pid <- DBI::dbGetQuery(admin_conn, "select pid from pg_stat_activity where application_name = 'pool'")[[1]][[1]]

print(original_pool_pid)
print(new_pool_pid)


