#install.packages("electionsBrR")
library(electionsBR)
# d_candidatos <- elections_tse(year = 2002, type = "candidate")

# df_2020 <- elections_tse(year = 2020, type = "vote_mun_zone", uf = "SP")




# d_candidatos_2020 <- elections_tse(year = 2020, type = "candidate")


# df_selecionado <- d_candidatos_2020[c("NM_CANDIDATO", "DS_GENERO")]


df_mulheres <- df_selecionado %>% 
  filter(DS_GENERO=='FEMININO')



# df_mulheres
# meuDataFrame %>% 
#   filter(idade > 18) %>%
#   select(idade, nome) %>%
#   group_by(idade) %>%
#   summarise(contagem = n())


