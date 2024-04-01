(importRDefaults <- function(.datasets = FALSE) {
  pkgs <- options()$defaultPackages
  if (isTRUE(!.datasets)) pkgs <- setdiff(pkgs, "datasets")
  if ("methods" %in% pkgs) pkgs <- unique(c("methods", pkgs))
  lapply(pkgs, function(pkg) {
    do.call(modules::import, list(str2lang(pkg), attach = TRUE, where = parent.frame(3)))
  })
})()




print(runif(10))
b <- function() runif(10)

modules::export(b)
