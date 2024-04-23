library(electionsBR)
library(tidyverse)
library(ggplot2)
library(broom)
library(rdrobust)
library(rddensity)
library(modelsummary)
library(writexl)

### pegando dados das eleicoes e candidatos ###
# 2004, 2008, 2012, 2016, 2020

##### Base TSE 2004 #####
raw_br2004 <- elections_tse(year = 2004, uf='all', type = 'vote_mun_zone') 
raw_candidato_2004 <- candidate_local(2004, uf='all')

candidatos_2004 <- raw_candidato_2004 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    candidato = NM_CANDIDATO,
    genero = DS_GENERO
  ) %>% 
  filter(cargo == 'PREFEITO')  %>% 
  select(ano, estado, candidato, genero) %>% 
  group_by(ano, estado, candidato) %>% 
  summarise(genero = first(genero))
  
  
br2004 <- raw_br2004 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    municipio = NM_MUNICIPIO,
    zona = NR_ZONA,
    candidato = NM_CANDIDATO,
    votos = QT_VOTOS_NOMINAIS
    ) %>% 
  filter(cargo == 'Prefeito') %>% 
  select(ano, estado,  municipio, zona, candidato, votos) %>% 
  left_join(candidatos_2004, by = c('ano', 'estado', 'candidato')) %>% 
  group_by(ano, estado, municipio, candidato) %>% 
  summarise(votos_totais = sum(votos),
            genero = first(genero)) %>% 
  arrange(ano, estado, municipio, desc(votos_totais)) %>% 
  slice_max(order_by = votos_totais, n = 2) %>% 
  mutate(margem = votos_totais/sum(votos_totais)) %>% 
  group_by(ano, estado, municipio) %>% 
  summarise(cont_fem = sum(genero == 'FEMININO'),
            margem_fem = sum(margem[genero == "FEMININO"]),
            margem_mas = sum(margem[genero == "MASCULINO"]),
            margem_vitoria_mulher = (margem_fem - margem_mas),) %>% 
  filter(cont_fem == 1) %>% 
  select(ano, estado, municipio, margem_vitoria_mulher)
View(br2004)
   
##### Base TSE 2008 #####

raw_br2008 <- elections_tse(year = 2008, uf='all', type = 'vote_mun_zone') 
raw_candidato_2008 <- candidate_local(2008, uf='all')

candidatos_2008 <- raw_candidato_2008 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    candidato = NM_CANDIDATO,
    genero = DS_GENERO
  ) %>% 
  filter(cargo == 'PREFEITO')  %>% 
  select(ano, estado, candidato, genero) %>% 
  group_by(ano, estado, candidato) %>% 
  summarise(genero = first(genero))  

br2008 <- raw_br2008 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    municipio = NM_MUNICIPIO,
    zona = NR_ZONA,
    candidato = NM_CANDIDATO,
    votos = QT_VOTOS_NOMINAIS
  ) %>% 
  filter(cargo == 'Prefeito') %>% 
  select(ano, estado,  municipio, zona, candidato, votos) %>% 
  left_join(candidatos_2008, by = c('ano', 'estado', 'candidato')) %>% 
  group_by(ano, estado, municipio, candidato) %>% 
  summarise(votos_totais = sum(votos),
            genero = first(genero)) %>% 
  arrange(ano, estado, municipio, desc(votos_totais)) %>% 
  slice_max(order_by = votos_totais, n = 2) %>% 
  mutate(margem = votos_totais/sum(votos_totais)) %>% 
  group_by(ano, estado, municipio) %>% 
  summarise(cont_fem = sum(genero == 'FEMININO'),
            margem_fem = sum(margem[genero == "FEMININO"]),
            margem_mas = sum(margem[genero == "MASCULINO"]),
            margem_vitoria_mulher = (margem_fem - margem_mas),) %>% 
  filter(cont_fem == 1) %>% 
  select(ano, estado, municipio, margem_vitoria_mulher)
View(br2008)



##### Base TSE 2012 ####
raw_br2012 <- elections_tse(year = 2012, uf='all', type = 'vote_mun_zone') 
raw_candidato_2012 <- candidate_local(2012, uf='all')

candidatos_2012 <- raw_candidato_2012 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    candidato = NM_CANDIDATO,
    genero = DS_GENERO
  ) %>% 
  filter(cargo == 'PREFEITO')  %>% 
  select(ano, estado, candidato, genero) %>% 
  group_by(ano, estado, candidato) %>% 
  summarise(genero = first(genero))  

br2012 <- raw_br2012 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    municipio = NM_MUNICIPIO,
    zona = NR_ZONA,
    candidato = NM_CANDIDATO,
    votos = QT_VOTOS_NOMINAIS
  ) %>% 
  filter(cargo == 'Prefeito') %>% 
  select(ano, estado,  municipio, zona, candidato, votos) %>% 
  left_join(candidatos_2012, by = c('ano', 'estado', 'candidato')) %>% 
  group_by(ano, estado, municipio, candidato) %>% 
  summarise(votos_totais = sum(votos),
            genero = first(genero)) %>% 
  arrange(ano, estado, municipio, desc(votos_totais)) %>% 
  slice_max(order_by = votos_totais, n = 2) %>% 
  mutate(margem = votos_totais/sum(votos_totais)) %>% 
  group_by(ano, estado, municipio) %>% 
  summarise(cont_fem = sum(genero == 'FEMININO'),
            margem_fem = sum(margem[genero == "FEMININO"]),
            margem_mas = sum(margem[genero == "MASCULINO"]),
            margem_vitoria_mulher = (margem_fem - margem_mas),) %>% 
  filter(cont_fem == 1) %>% 
  select(ano, estado, municipio, margem_vitoria_mulher)
View(br2012)

##### Base TSE 2016 ####
raw_br2016 <- elections_tse(year = 2016, uf='all', type = 'vote_mun_zone') 
raw_candidato_2016 <- candidate_local(2016, uf='all')

candidatos_2016 <- raw_candidato_2016 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    candidato = NM_CANDIDATO,
    genero = DS_GENERO
  ) %>% 
  filter(cargo == 'PREFEITO')  %>% 
  select(ano, estado, candidato, genero) %>% 
  group_by(ano, estado, candidato) %>% 
  summarise(genero = first(genero))  

br2016 <- raw_br2016 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    municipio = NM_MUNICIPIO,
    zona = NR_ZONA,
    candidato = NM_CANDIDATO,
    votos = QT_VOTOS_NOMINAIS
  ) %>% 
  filter(cargo == 'Prefeito') %>% 
  select(ano, estado,  municipio, zona, candidato, votos) %>% 
  left_join(candidatos_2016, by = c('ano', 'estado', 'candidato')) %>% 
  group_by(ano, estado, municipio, candidato) %>% 
  summarise(votos_totais = sum(votos),
            genero = first(genero)) %>% 
  arrange(ano, estado, municipio, desc(votos_totais)) %>% 
  slice_max(order_by = votos_totais, n = 2) %>% 
  mutate(margem = votos_totais/sum(votos_totais)) %>% 
  group_by(ano, estado, municipio) %>% 
  summarise(cont_fem = sum(genero == 'FEMININO'),
            margem_fem = sum(margem[genero == "FEMININO"]),
            margem_mas = sum(margem[genero == "MASCULINO"]),
            margem_vitoria_mulher = (margem_fem - margem_mas),) %>% 
  filter(cont_fem == 1) %>% 
  select(ano, estado, municipio, margem_vitoria_mulher)
View(br2016)




##### Base TSE 2020 ####
raw_br2020 <- elections_tse(year = 2020, uf='all', type = 'vote_mun_zone') 
raw_candidato_2020 <- candidate_local(2020, uf='all')

candidatos_2020 <- raw_candidato_2020 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    candidato = NM_CANDIDATO,
    genero = DS_GENERO
  ) %>% 
  filter(cargo == 'PREFEITO')  %>% 
  select(ano, estado, candidato, genero) %>% 
  group_by(ano, estado, candidato) %>% 
  summarise(genero = first(genero))  

br2020 <- raw_br2020 %>% 
  rename(
    ano = ANO_ELEICAO,
    estado = SG_UF,
    cargo = DS_CARGO,
    municipio = NM_MUNICIPIO,
    zona = NR_ZONA,
    candidato = NM_CANDIDATO,
    votos = QT_VOTOS_NOMINAIS
  ) %>% 
  filter(cargo == 'Prefeito') %>% 
  select(ano, estado,  municipio, zona, candidato, votos) %>% 
  left_join(candidatos_2020, by = c('ano', 'estado', 'candidato')) %>% 
  group_by(ano, estado, municipio, candidato) %>% 
  summarise(votos_totais = sum(votos),
            genero = first(genero)) %>% 
  arrange(ano, estado, municipio, desc(votos_totais)) %>% 
  slice_max(order_by = votos_totais, n = 2) %>% 
  mutate(margem = votos_totais/sum(votos_totais)) %>% 
  group_by(ano, estado, municipio) %>% 
  summarise(cont_fem = sum(genero == 'FEMININO'),
            margem_fem = sum(margem[genero == "FEMININO"]),
            margem_mas = sum(margem[genero == "MASCULINO"]),
            margem_vitoria_mulher = (margem_fem - margem_mas),) %>% 
  filter(cont_fem == 1) %>% 
  select(ano, estado, municipio, margem_vitoria_mulher)
View(br2016)


#### Juntando as bases ####

#  br <- do.call(rbind, list(br2004, br2008, br2012, br2016, br2020))

# trazendo pra um arquivo xlsx
#  write_xlsx(br, "mg_vitoria_feminina.xlsx")


##### puxando a base final
library(readxl)

setwd("C:/Users/Dr_An/OneDrive/Área de Trabalho/Insper_Data/Close_election_Adriano/Dados/municipios")

br <- read_excel('mg_vitoria_feminina.xlsx')















