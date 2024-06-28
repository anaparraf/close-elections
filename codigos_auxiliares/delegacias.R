library(haven)
library(dplyr)

df_deam <- read_dta("womenservices.dta") |> 
  mutate(municipio = substr(as.character(muniyear), 1, 6)) %>%
  mutate(ano_deleg = as.factor(muniyear %% 10000)) |> 
  select(municipio, ano_deleg, everything(), -muniyear) |> 
  group_by(municipio, ano_deleg) |> 
  summarize(NumberOfDeams = max(NumberOfDeams)) |> 
  arrange(NumberOfDeams)

elections_final |> 
  left_join(df_deam, by= c('codigo_ibge_att' = 'municipio', 'ano'?=?'ano_deleg'))

