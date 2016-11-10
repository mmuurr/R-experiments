library(parallel)
library(magrittr)

httr::GET("https://httpbin.org/response-headers?foo=bar") %>% httr::status_code()

mclapply(1:4, function(i) {
    httr::GET("https://httpbin.org/response-headers?foo=bar") %>% httr::status_code()
}, mc.cores = 2)

