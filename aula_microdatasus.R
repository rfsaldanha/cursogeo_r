##############################################
## Pacotes: microdatasus                    ##
## CursoGeo 2022 - Fiocruz | ICICT | LIS    ##
##############################################


# O que são pacotes? ------------------------------------------------------

# Pacotes (packages, libraries) são um conjunto de funções 
# e outros objetos no R criados para ajudar questões específicas.
# 
# Existem mais de 18.300 pacotes para o R. Boa parte deles 
# pode ser acessada nestes links:
# 
# https://cran.r-project.org/web/packages/available_packages_by_name.html
#
# https://cran.r-project.org/web/views/
#
# O R e seus pacotes são criados e mantidos pela comunidade de 
# usuários, em geral, de forma voluntária.


# microdatasus ------------------------------------------------------------

# O pacote microdatasus foi criado para o auxílio no download e 
# pré-processamento de microdados do DataSUS (arquivos DBC).
# 
# Você pode saber mais sobre ele nesta publicação: 
# http://ref.scielo.org/dhcq3y
#
# Para instalar o pacote microdatasus, execute os 
# seguintes comandos:

install.packages("remotes")
remotes::install_github("rfsaldanha/microdatasus")

# Após instalado, o R precisa saber que queremos 
# usar o pacote.

library(microdatasus)

# Este pacote tem duas funções básicas: uma para o download de 
# dados do DataSUS, e outras para o pré-processamento dos
# dados baixados.

# Exemplo: download de dados do SIM 
# processados entre 2013 e 2014 no RJ
dados <- fetch_datasus(
  year_start = 2013, year_end = 2014, 
  uf = "RJ", 
  information_system = "SIM-DO"
)

View(dados)

# Pré-processamento dos dados
dados <- process_sim(dados)
View(dados)

# Acesse o help do pacote para conhecer todas as opções.
help(package = "microdatasus")


# Exemplo de análise ------------------------------------------------------

### Algumas análises

# Pacotes necessários
library(tidyverse)
library(lubridate)
library(viridis)
library(microdatasus)

# Download dos dados
# SIM
dados_sim <- fetch_datasus(year_start = 2015, year_end = 2017, 
                           uf = "RJ", 
                           information_system = "SIM-DO")

# SIH
dados_sih <- fetch_datasus(year_start = 2017, month_start = 1,
                           year_end = 2017, month_end = 3, 
                           uf = c("RJ"),
                           information_system = "SIH-RD")

# SINASC
dados_sinasc <- fetch_datasus(year_start = 2015, year_end = 2017,
                              uf = "RJ",
                              information_system = "SINASC")

# CNES
estab <- fetch_datasus(year_start = 2017, month_start = 12,
                       year_end = 2017, month_end = 12, 
                       uf = "RJ",
                       information_system = "CNES-ST")


### Pré-processamento dos dados
dados_sim_pre <- process_sim(dados_sim)
dados_sih_pre <- process_sih(dados_sih)
dados_sinasc_pre <- process_sinasc(dados_sinasc)



### Algumas análises

dados_sim_pre %>%
  select(SEXO, CAUSABAS) %>%
  filter(grepl("^X", CAUSABAS)) %>%
  group_by(SEXO) %>%
  summarize(count = n()) %>%
  ggplot(aes(x = SEXO, y = count)) +
  geom_col() +
  xlab("Sexo") + ylab("Contagem") + 
  ggtitle("Óbitos por causas violentas") +
  coord_flip()

dados_sih_pre %>%
  select(ESPEC, SEXO) %>%
  group_by(ESPEC, SEXO) %>%
  summarize(count = n()) %>%
  group_by(ESPEC) %>%
  mutate(perc = count/sum(count)*100) %>%
  ggplot(aes(x = ESPEC, y = perc)) +
  geom_col(aes(fill = SEXO)) +
  xlab("Especialidade") + ylab("Percentual") + 
  labs(fill = "Sexo") +
  ggtitle("Especialidade da internação e sexo") +
  coord_flip() +
  theme(legend.position = "bottom")


dados_sinasc_pre %>%
  select(PARTO, DTNASC) %>%
  na.omit() %>%
  mutate(dia_semana = wday(DTNASC, week_start = 1, label = TRUE, abbr = TRUE, locale = "pt_BR")) %>%
  group_by(PARTO, dia_semana) %>%
  summarise(count = n()) %>%
  group_by(dia_semana) %>%
  mutate(perc = count/sum(count)*100) %>%
  ggplot(aes(x = dia_semana, y = perc)) +
  geom_col(aes(fill = PARTO)) +
  xlab("Dia da semana") + ylab("Percentual") + 
  labs(fill = "Parto") +
  ggtitle("Parto e dia da semana") +
  coord_flip() +
  theme(legend.position = "bottom")



dados_sinasc_pre %>%
  select(PARTO, DTNASC, HORANASC, CODESTAB) %>%
  mutate(HORANASC = substring(HORANASC, 0, 2)) %>%
  mutate(dia_semana = wday(DTNASC, week_start = 1, label = TRUE, abbr = TRUE, locale = "pt_BR")) %>%
  left_join(estab, by = c("CODESTAB" = "CNES")) %>%
  select(PARTO, HORANASC, dia_semana, VINC_SUS) %>%
  mutate(VINC_SUS = if_else(VINC_SUS == 1, "Vinculo com SUS", "Sem vinculo com SUS")) %>%
  na.omit() %>%
  group_by(PARTO, HORANASC, dia_semana, VINC_SUS) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = HORANASC, y = dia_semana, fill = count)) +
  geom_tile() +
  coord_equal() +
  scale_fill_viridis(trans = "pseudo_log") +
  facet_wrap(~ VINC_SUS + PARTO) +
  xlab("Horário") + ylab("Dia da semana") + 
  labs(fill = "Partos") +
  ggtitle("Número de partos por dia da semana, tipo, horário e vínculo com o SUS") +
  theme(legend.position = "bottom")
