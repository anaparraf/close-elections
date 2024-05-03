# datasus

# install.packages('remotes')
#install.packages('devtools')
library(devtools)
devtools::install_github("rfsaldanha/microdatasus")

# remotes::install_github("rfsaldanha/microdatasus")

library(microdatasus)



dados <- fetch_datasus(year_start = 2000, year_end = 2024, uf = "all", information_system = "SIM-DOEXT")

data_sus_homicidios <- dados  |>  
  rename(sexo = SEXO,
         raca = RACACOR,
         civil = ESTCIV,
         escolaridade = ESC,
         local = LOCOCOR,
         data = DTOBITO,
         municipio = CODMUNOCOR,
         nascimento = DTNASC,
         idade = IDADE) |> 
  filter(CAUSABAS >= 'X85' & CAUSABAS <= 'Y09')  |> 
  mutate(ano_obito = substr(data, 5, 8)) |> 
  select(data, ano_obito, municipio, sexo, raca, civil, escolaridade, local, nascimento, idade) |> 
  mutate(mandato = ifelse(ano_obito <= 2004, 2000, 
                          ifelse(ano_obito <= 2008, 2004,
                                 ifelse(ano_obito <= 2012, 2008,
                                        ifelse(ano_obito <= 2016, 2012,
                                               ifelse(ano_obito <= 2020, 2016,
                                                      ifelse( ano_obito <=2024, 2020)))))))



  
library(data.table)

fwrite(data_sus_homicidios, "datasus_completo.csv")


mandatos <- bind_rows(mandato2000, mandato2004, mandato2008, mandato2012, mandato2016, mandato2020) 

# library(writexl)

setwd("C:/Users/Dr_An/OneDrive/Área de Trabalho/Insper_Data/Close_election_Adriano/Dados/municipios")

# write_xlsx(mandatos, "homicidios_mandatos.xlsx")

library(readxl)

raw <- read_excel("municipios_notificacoes_viva_fem.xlsx", sheet = "Planilha1")

df <- raw %>% 
  rename(
    municipio = `Município de notificação`
  ) %>% 
  select(-'2003') %>% 
  melt('municipio') %>% 
  rename(ano = variable,
         notificacoes = value) %>% 
  mutate(cd_municipio = substr(municipio,start = 1 , stop = 6),
         municipio = substr(municipio, start = 8, stop = nchar(municipio)))


mandatos$municipio <- as.character(mandatos$municipio)
mandatos$municipio <- ifelse(nchar(df$municipio) == 7, substr(df$municipio, 1, nchar(df$municipio)-1), df$municipio)

















