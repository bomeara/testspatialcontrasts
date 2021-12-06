Sys.setenv(RSTUDIO_PANDOC="/usr/local/bin/pandoc")
Sys.setenv(PANDOC="/usr/local/bin/pandoc")
system("export PATH=$PATH:/usr/local/bin")

library(targets)
source("_packages.R")
source("R/functions.R")

tar_make()
