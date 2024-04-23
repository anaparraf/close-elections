library(readxl)
library(tidyverse)
library(reshape2)

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

df[['ano']] <- integer(df[['ano']])

df %>% 
  mutate(
    mandato = ifelse(ano <= 2012, 2008,
                     ifelse(ano <= 2016, 2012,
                     ifelse(ano <= 2020, 2016,
                     ifelse(ano <= 2024, 2020, NA))))) %>% view() 
    


mg_vitoria <- read_excel("mg_vitoria_feminina.xlsx")

###
mg_vitoria[['ano']] <- integer(mg_vitoria[['ano']])
df[['ano']] <- integer(df[['ano']])

###

df_final <- mg_vitoria %>%
  left_join(df, by=c('ano','municipio'))


df_final <- df_final %>%
  group_by(municipio, estado, ano)
  mutate(
    D  = if_else(margem_vitoria_mulher > 0, 1, 0)) %>% 
  

ggplot(aes(margem_vitoria_mulher, y=D, colour = factor(D)), data = df_final) +
  geom_point(alpha = 0.5) +
  geom_vline(xintercept = 0, colour = "grey", linetype = 2)+
  stat_smooth(method = "lm", se = F) +
  labs(x = "Test score (X)", y = "Potential Outcome (Y1)")
  
