# Manage packages -----

#1. Download packages from CRAN
.cran_packages  <-  c("ggplot2", "plyr", "dplyr","seqRFLP", "reshape2", "tibble", "devtools", "Matrix", "mgcv", "readr", "stringr")
.inst <- .cran_packages %in% installed.packages()
if (any(!.inst)) {
  install.packages(.cran_packages[!.inst], repos = "http://cran.rstudio.com/")
}
