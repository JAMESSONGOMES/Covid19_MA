# 1- TUTORIAL:  https://www.linkedin.com/pulse/acessando-e-manipulando-os-dados-do-covid-19-brasil-parte-i-a-gomes
# 2- FONTE DE DADOS: https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-cities-time.csv

library(xlsx)

dados= read.csv("https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-cities-time.csv", stringsAsFactors = FALSE)

dados <- dados[c("state","ibgeID","newDeaths","deaths", "newCases","totalCases","date","epi_week")]
df_ma <- subset(dados,state=="MA") #seleciona todos os municipios do MA

#Renomear as variáveis

names(df_ma)[names(df_ma) == "state"] <- "estado"
names(df_ma)[names(df_ma) == "ibgeID"] <- "cod_ibge"
names(df_ma)[names(df_ma) == "newDeaths"] <- "obitos_novos"
names(df_ma)[names(df_ma) == "newCases"] <- "casos_novos"
names(df_ma)[names(df_ma) == "deaths"] <- "obitos_acumulados"
names(df_ma)[names(df_ma) == "totalCases"] <- "casos_acumulados"
names(df_ma)[names(df_ma) == "date"] <- "data"
names(df_ma)[names(df_ma) == "epi_week"] <- "sem_epi"

#seleciona apenas SLZ && e lê o vetor de codigos ibge

library(ggplot2)
library(scales)
library(tidyverse)
library(readxl)
library(lubridate)
library(purrr)

DF_ibge<- read.csv("MA.csv",sep=";")# Lê os códigos IBGE do MA

tamanho <- length(DF_ibge$ibgeID) #quantidade de cidades no MA         



#######################################################################
##############Todos os dados por cidade em CSV e XLSX #################
#######################################################################

i<-1 # o contador i recebe o valor inicial 1

while(i<=tamanho){
  
  df_cidades <- subset(df_ma, cod_ibge==DF_ibge$ibgeID[i]) 
  
  df_cidades$data <- as.Date(df_cidades$data)
  
  # inicio <- ymd(min(df_cidades$data))
  # fim <- ymd(max(df_cidades$data))
  
  
  print(DF_ibge$Cidade[i])
  
  #Exportando os dados para EXCEL
  
  
  
  write.csv(df_cidades, paste (DF_ibge$Cidade[i], ".csv", sep=""), row.names = FALSE)
  write.xlsx(df_cidades,paste (DF_ibge$Cidade[i], ".xlsx", sep=""), row.names = FALSE)
  
  i<-i+1
  
}
####################################################
##############Todos Graficos em PDF#################
####################################################

j<-1
while(j<=tamanho) {
  
  
  p2<-ggplot(data=df_cidades, aes(x=data, y=casos_novos)) + geom_point() + geom_line()
  p2<-p2+labs(x = "Dias", 
              y = "Casos Notificados",
              title = paste ( "Casos Covid19-", DF_ibge$Cidade[j], sep="") )
  p2
  ggsave(paste (DF_ibge$Cidade[j], "1-Notificados.pdf", sep="" ), width=6,height=4 ,p2)
  # dev.off()
  
  
  
  
  #######################################################################################
  #############################################################################################
  #Gráficos de linhas (Casos acumulados)
  #############################################################################################
  
  #Exemplo1
  
  df_cidades$log_acumulados=log(df_cidades$casos_acumulados)
  
  p4<-ggplot(data=df_cidades, aes(x=data, y=log_acumulados)) + geom_point() + geom_line()
  p4<-p4+labs(x = "Dias", 
              y = "Casos acumulados (log)",
              title = paste ( "Casos Covid19-", DF_ibge$Cidade[j], sep="") )
  p4
  ggsave(paste (DF_ibge$Cidade[j],"2-Acumulados.pdf", sep="" ), width=6,height=4 ,p4)
  # dev.off()
  
  j<-j+1
}