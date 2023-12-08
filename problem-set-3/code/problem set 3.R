## initial setup
rm(list=ls())
require(pacman)
p_load(tidyverse,rio,data.table)

## Punto 1.1
rutas <- list.files("input/" , recursive=T , full.names=T)

## Punto 1.2 

## Extraer las rutas
rutas_resto <- str_subset(string = rutas , pattern = "Resto - Ca")

## Cargar en lista
lista_resto <- import_list(file = rutas_resto)

## Textear la cadena de caracteres 
rutas_resto[1]
str_sub(rutas_resto[35],start = 14 , 17)

## Agregar ruta
View(lista_resto[[1]])
lista_resto[[1]]$path <- rutas_resto[1]

## Aplicar loop  
for (i in 1:length(lista_resto)){
  lista_resto[[i]]$path <- rutas_resto[i]  
  lista_resto[[i]]$year <- str_sub(lista_resto[[i]]$path,start = 14 , 17)
}
View(lista_resto[[20]])

## Punto 1.3
lista_resto[[36]] <- NULL
df_resto <- rbindlist(l=lista_resto , use.names=T , fill=T)

## export
export(df_resto,"problem-set-3/output/db_full.rds")


##punto 2

rm(list=ls())

install.packages(ggplot2)

library(ggplot2)

df_resto <- import("problem-set-3/output/db_full.rds")

# Visualización 1: Gráfico de barras

graph_1 <- df_resto %>% 
  group_by(P6020) %>% 
  summarise(promedio = mean(P6050, na.rm = TRUE)) %>% 
  ggplot(data = . , mapping = aes(x = as.factor(P6020) , y = promedio, fill = as.factor(P6020))) + 
  geom_bar(stat = "identity") + 
  scale_fill_manual(values = c("2" = "red", "1" = "blue"), label = c("1" = "Hombre", "2" = "Mujer"), name = "Sexo") +
  labs(title = "distribución por género en los hogares Colombianos",
       x = "Sexo",
       y = "Unidad de gasto") +
  theme_classic()

  print(graph_1)
  
# Visualización 2: Gráfico de densidad
  
graph_2 <- filter(df_resto, !is.na(P6020) & P6040 < 60) %>% 
  ggplot(data=. , mapping = aes(x = P6030S3 , group = as.factor(P6020), fill = as.factor(P6020))) + 
  geom_density() + scale_fill_discrete(label = c("1"="hombre" , "2"="mujer") , name = "género") + 
  labs(x = "edad" , y = "",
       title = "Hombres y mujeres que no han llegado a la tercera edad") + 
       theme_dark()
print(graph_2)
  
  

