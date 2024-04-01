library(tidyverse)
library(plumber)

#* @post /foo/<x>
#* @parser json
#* @serializer text
function(req, x) {
  print(as.list(req))
  #req$argsPath$x
  x
}
