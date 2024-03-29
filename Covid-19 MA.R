# tutorial e fonte de dados: 

# 1- TUTORIAL:  https://www.linkedin.com/pulse/acessando-e-manipulando-os-dados-do-covid-19-brasil-parte-i-a-gomes
# 2- FONTE DE DADOS: https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-cities-time.csv

library(readr)
library(magrittr)
library(tidyverse)



#CASOS DE TODO BRASIL AT� 2022
dados_br <- read_csv("cases-brazil-cities-time.csv")
gc()

# PR�-VISUALIZA��O DOS DADOS
names(dados_br)
head(dados_br)

#CRIA��O DO DATAFRAME MARANH�O DE 2020 AT� JUNHO DE 2022
df_ma2020 <- subset(dados_br,state=="MA" & date <= "2022-06-01") 


library(lubridate)

#VALIDA��O DOS DADOS COM BOLETIM DA SESMA
teste <- month(df_ma2020$date)
df_ma2020$mes <- teste
casos2020 <- df_ma2020 %>% group_by(mes) %>% summarise (
  Casos20 = sum(newCases),
  Obitos20 = sum(newDeaths)
)
casos2020 
sum(casos2020$Obitos20)
sum(casos2020$Casos20)

write.csv2(df_ma2020,"MAR2020_a_JUN2022.csv")