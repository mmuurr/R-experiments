r_defaults <- function(except = c("datasets"), where = parent.frame()) {
  pkgs <- options()$defaultPackages
  pkgs <- setdiff(pkgs, except)
  if ("methods" %in% pkgs) pkgs <- unique(c("methods", pkgs))
  for(pkg in pkgs) do.call(modules::import, list(str2lang(pkg)), envir = where)
}

modules::export(r_defaults)
