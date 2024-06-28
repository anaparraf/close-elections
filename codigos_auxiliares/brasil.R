library(tidyverse)
library(sf)
library(geobr)

# distrito <- read_sf("geosampa/distrito/SIRGAS_SHP_distrito.shp") %>% 
#   st_set_crs("epsg:31983")
# View(distrito) 

# Read all municipalities in the country at a given year
mun <- read_municipality(code_muni="all", year=2022)

ggplot() + # Inicia o gráfico ggplot
  geom_sf(data = mun,
          # Camada do mapa da base completa (Estado SP)
          alpha = .9,
          color = NA) 

