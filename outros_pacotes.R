##############################################
## Mapas e outros pacotes                   ##
## CursoGeo 2022 - Fiocruz | ICICT | LIS    ##
##############################################


# Pacote geobr ------------------------------------------------------------

# https://github.com/ipeaGIT/geobr

# Instalação
# devtools::install_github("ipeaGIT/geobr", subdir = "r-package")
library(tidyverse)
library(geobr)

base_uf <- geobr::read_state(simplified = TRUE)

dados <- read_csv2(file = "data/ocup_leitos_covid19_20220706_101045.csv") %>%
  mutate(uf = str_to_title(string = uf))

dados_mapa <- left_join(base_uf, dados, by = c("name_state" = "uf"))

g <- dados_mapa %>%
  # Remove registros com NAs
  na.omit() %>%
  # Cria uma variável com a data de coleta formatada
  mutate(
    data_coleta_char = as.character(format(data_coleta, "%d/%m/%Y")),
    data_coleta_char = fct_reorder(data_coleta_char, data_coleta)
  ) %>%
  # Início da criação do mapa
  ggplot() +
  # Adiciona o mapa das UFs ao gráfico, colorindo pela variável alerta
  geom_sf(aes(fill = alerta), color = "white", lwd = .2) +
  # Cor das UFs conforme o alerta  
  scale_fill_manual(values=c("Baixo" = "#55a95a", "Médio" = "#f4b132", "Crítico" = "#ca373c"), breaks = c("Baixo", "Médio", "Crítico")) +
  # Títulos
  labs(title = "Taxa de ocupação (%) de leitos de UTI Covid-19 para adultos", fill = "Alerta", caption = "Observatório Covid-19 | Fiocruz") +
  ylab("") + xlab("") +
  # Adequações do tema
  theme(
    legend.position="bottom",
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()
  ) +
  # Produz um mapa para cada data de coleta
  facet_wrap(~ data_coleta_char) 

ggsave(filename = "leitos.pdf", plot = g, width = 210, height = 297, units = "mm")
