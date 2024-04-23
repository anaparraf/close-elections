# datasus

# install.packages('remotes')
#install.packages('devtools')
library(devtools)
devtools::install_github("rfsaldanha/microdatasus", force = TRUE)

# remotes::install_github("rfsaldanha/microdatasus")

library(microdatasus)


dados <- fetch_datasus(year_start = 2001, year_end = 2001, uf = "all", information_system = "SIM-DOEXT")





