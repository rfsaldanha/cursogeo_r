##############################################
## Introdução prática com R                 ##
## CursoGeo 2022 - Fiocruz | ICICT | LIS    ##
##############################################


# Instalação --------------------------------------------------------------

# Para utilizar o R, recomendamos que você baixe em seu computador
# a versão mais atual do R neste link:
#
# https://cran.r-project.org
# 
# e, em seguida, também instale o RStudio
#
# https://www.rstudio.com/products/rstudio/download/
#

# Comandos básicos --------------------------------------------------------

# A programação com R começa com comandos básicos para operações aritméticas

# Soma e subtração
2 + 5
2 - 5

# Multiplicação e divisão
2*5
2/5

# Exponenciação
2^5


# Funções -----------------------------------------------------------------

# Outras operações podem ser realizadas com funções no R.

# Raiz quadrada
sqrt(x = 9)

# Log
log(x = 10, base = 10)

# Repare que as funções recebem valores (argumentos) para 
# produzir um resultado. Algumas funções podem receber 
# mais de um argumento.


# Objetos -----------------------------------------------------------------

# Os resultados de operações simples e funções no R podem ser 
# armazenados na memória para utilização posterior através de 
# objetos.
# 
# Na linguagem R, objetos são abstrações na memória que 
# podem conter desde um simples número até complexos bancos 
# de dados e funções. 

# Criar o objeto x
x <- 2

# Imprimir o objeto x
x

# Operações com o objeto x
x^2
x+x

# Apagar o objeto x
rm(x)

# Criar o vetor y
y <- c(2, 5, 10, 11.3, 12)

# Imprimir o vetor y
y

# Elevar o vetor y ao quadrado
y^2

# Apagar o vetor y
rm(y)

# Criar o vetor 'notas'
notas <- c(60, 50, 20, 50, 90)

# Ordenar o vetor 'notas'
notas <- sort(notas)

# Imprimir o vetor 'notas'
notas



# Operadores lógicos ------------------------------------------------------

# Estes operados verificam afirmações de lógica.

# Igualdade
2 == 2
2 == 5
"a" == "a"
"a" == 'A'

# Maior
2 > 3
2 >= 3

# Menor
2 < 4
2 <= 1
c(1,2,2,4,7,10) < 7


# Banco de dados ----------------------------------------------------------

# A interface do R não é recomendada para a criação de 
# banco de dados. Como já existem centenas de opções de softwares
# de qualidade e gratuitos para este fim, os bancos de dados podem 
# ser criados em outros softwares como o Excel e importados 
# posteriormente para o R.
#
# Existem diversos pacotes de funções para ler aquivos de banco 
# de dados  no R, como DBF, SAV, Stata e etc. Mas a forma 
# mais segura e recomendada é exportar os dados no formato 
# CSV para serem importados no R.

# Importar o arquivo 'notas.csv'
dados <- read.csv2(file = "data/notas.csv", header = TRUE)

# Atenção para os nomes das variáveis! Evite a utilização de nomes 
# muito longos, caracteres especiais e acentos.
# 
# Após importar um banco de dados, verifique se tudo 
# correu bem com estes comandos.

# Estrutura do objeto
str(dados)

# Listar os nomes das variáveis
names(dados)

# Imprimir as seis primeiras linhas
head(dados)

# Imprimir as seis últimas linhas
tail(dados)

# Para acessar uma variável específica
dados$nota 


# Estatísticas básica ------------------------------------------------------

# Abaixo temos uma lista comandos para obter estatísticas básicas 
# com o R e alguns gráficos.

# Importar o arquivo 'notas.csv'
dados <- read.csv2(file = "data/notas.csv", header = TRUE)

# Média
mean(dados$nota)

# Mediana
median(dados$nota)

# Variância
var(dados$nota)

# Desvio padrão
sd(dados$nota)

# Valor máximo
max(dados$nota)

# Valor mínimo
min(dados$nota)

# Amplitude
range(dados$nota)

# Coeficiente de variação
sd(dados$nota)/mean(dados$nota)

# Quartis
quantile(dados$nota)

# Sumário
summary(dados$nota)

# Boxplot
boxplot(dados$nota)

# Histograma
hist(dados$nota, main = "Boxplot", xlab = "Classes", ylab = "Frequências", col = "tan")

