#install.packages("readxl")
#install.packages("data.table")
#install.packages("tidyr")
#install.packages("openxlsx")
#install.packages("dplyr")

library(openxlsx)
library(data.table)
library(readxl)
library(tidyr)
library(dplyr)

setwd("C:/Users/User/Documents/Tesis UNALM/Proyecto de tesis/Análisis/Input/Fichas/JNE (pedido)")

################################################################################
# Base de candidatos
# Importar datos desde la hoja "Hoja1"
Candidatos_2022 <- read_excel("2022_Candidatos.xlsx")

# Renombrar las variables de candidatos
setnames(Candidatos_2022, old = c("NOMBRES", "APELLIDOPATERNO", 
                                  "APELLIDOMATERNO", "NUMERODOCUMENTO",
                                  "SEXO", "FENACIMIENTO" ,"CARGO",
                                  "UBIGEOPOSTULA", "POSTULADISTRITO"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "sexo","f_nacimiento", "cargo_postulacion",
                 "ubigeo_postulacion", "distrito_postulacion"))

# Seleccionar columnas
Candidatos_2022 <- Candidatos_2022 %>%
  select(IDHOJAVIDA, "nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "sexo","f_nacimiento", "cargo_postulacion",
         "ubigeo_postulacion", "distrito_postulacion")

# Eliminar duplicados basados en todas las variables
Candidatos_2022 <- Candidatos_2022 %>%
  distinct(.keep_all = TRUE)

################################################################################
# Base de educacion PRIMARIA Y SECUNDARIA

# Importar datos desde la hoja "Hoja1"
Educacion_2022 <- read_excel("2022_FormacionAcademicaBasica.xlsx")

#Renombrando variables
setnames(Educacion_2022, old = c("CONCLUIDOEDUPRIMARIA", "CONCLUIDOEDUSECUNDARIA"), 
         new = c("primaria_completa", "secundaria_completa"))

# Seleccionar columnas
Educacion_2022 <- Educacion_2022 %>%
  select(IDHOJAVIDA, "primaria_completa", "secundaria_completa")

# Eliminar filas donde CENTROLABORAL es NA usando base R
Educacion_2022 <- Educacion_2022[!is.na(Educacion_2022$primaria_completa), ]
Educacion_2022 <- Educacion_2022[!is.na(Educacion_2022$secundaria_completa), ]

Educacion_2022$primaria_completa <- ifelse(Educacion_2022$primaria_completa=="SI", 1, 0)
Educacion_2022$secundaria_completa <- ifelse(Educacion_2022$secundaria_completa=="SI", 1, 0)

# Eliminar duplicados basados en todas las variables
Educacion_2022 <- Educacion_2022 %>%
  distinct(.keep_all = TRUE)

# Seleccionar columnas y collapsar
Educacion_2022_collapsed <- Educacion_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(primaria_completa  = sum(primaria_completa, na.rm = TRUE),
            secundaria_completa  = sum(secundaria_completa, na.rm = TRUE)) %>%
  ungroup()


################################################################################
# FORMACIÓN ACADEMICA
### TECNICO
# Importar datos desde la hoja "Hoja1"
FormacionAcademicaNouniv_2022 <- read_excel("2022_FormacionAcademicaNouniv.xlsx")

#Renombrando variables
setnames(FormacionAcademicaNouniv_2022, old = c("CONCLUIDONOUNI"), 
         new = c("instituto_completo"))

# Seleccionar columnas
FormacionAcademicaNouniv_2022 <- FormacionAcademicaNouniv_2022 %>%
  select(IDHOJAVIDA, "instituto_completo")

FormacionAcademicaNouniv_2022$instituto_completo <- ifelse(FormacionAcademicaNouniv_2022$instituto_completo=="SI", 1, 0)

# Seleccionar columnas y collapsar
FormacionAcademicaNouniv_2022 <- FormacionAcademicaNouniv_2022 %>%
  select("IDHOJAVIDA", "instituto_completo")%>%
  distinct()

# Seleccionar columnas y collapsar
FormacionAcademicaNouniv_2022_collapsed <- FormacionAcademicaNouniv_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(instituto_completo  = sum(instituto_completo, na.rm = TRUE)) %>%
  ungroup()

### Postgrado
# Importar datos desde la hoja "Hoja1"
FormacionAcademicaPost_2022 <- read_excel("2022_FormacionAcademicaPost.xlsx")

#Renombrando variables
setnames(FormacionAcademicaPost_2022, old = c("CONCLUIDOPOSGRADO"), 
         new = c("postgrado_completo"))

# Seleccionar columnas
FormacionAcademicaPost_2022 <- FormacionAcademicaPost_2022 %>%
  select(IDHOJAVIDA, "postgrado_completo")

FormacionAcademicaPost_2022$postgrado_completo <- ifelse(FormacionAcademicaPost_2022$postgrado_completo=="SI", 1, 0)

# Seleccionar columnas y collapsar
FormacionAcademicaPost_2022 <- FormacionAcademicaPost_2022 %>%
  select("IDHOJAVIDA", "postgrado_completo")%>%
  distinct()

# Seleccionar columnas y collapsar
FormacionAcademicaPost_2022_collapsed <- FormacionAcademicaPost_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(postgrado_completo  = sum(postgrado_completo, na.rm = TRUE)) %>%
  ungroup()

### Postgrado otro
# Importar datos desde la hoja "Hoja1"
FormacionAcademicaPostOtr_2022 <- read_excel("2022_FormacionAcademicaPostOtr.xlsx")

#Renombrando variables
setnames(FormacionAcademicaPostOtr_2022, old = c("CONCLUIDOPOSGRADOOTRO"), 
         new = c("diplomadoyotros_completo"))

# Seleccionar columnas
FormacionAcademicaPostOtr_2022 <- FormacionAcademicaPostOtr_2022 %>%
  select(IDHOJAVIDA, "diplomadoyotros_completo")

FormacionAcademicaPostOtr_2022$diplomadoyotros_completo <- ifelse(FormacionAcademicaPostOtr_2022$diplomadoyotros_completo=="SI", 1, 0)

# Seleccionar columnas y collapsar
FormacionAcademicaPostOtr_2022 <- FormacionAcademicaPostOtr_2022 %>%
  select("IDHOJAVIDA", "diplomadoyotros_completo")%>%
  distinct()

# Seleccionar columnas y collapsar
FormacionAcademicaPostOtr_2022_collapsed <- FormacionAcademicaPostOtr_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(diplomadoyotros_completo  = sum(diplomadoyotros_completo, na.rm = TRUE)) %>%
  ungroup()

### TECNICO
# Importar datos desde la hoja "Hoja1"
FormacionAcademicaTec_2022 <- read_excel("2022_FormacionAcademicaTec.xlsx")

#Renombrando variables
setnames(FormacionAcademicaTec_2022, old = c("CONCLUIDOEDUTECNICO"), 
         new = c("tecnico_completa"))

# Seleccionar columnas
FormacionAcademicaTec_2022 <- FormacionAcademicaTec_2022 %>%
  select(IDHOJAVIDA, "tecnico_completa")

FormacionAcademicaTec_2022$tecnico_completa <- ifelse(FormacionAcademicaTec_2022$tecnico_completa=="SI", 1, 0)

# Seleccionar columnas y collapsar
FormacionAcademicaTec_2022 <- FormacionAcademicaTec_2022 %>%
  select("IDHOJAVIDA", "tecnico_completa")%>%
  distinct()

# Seleccionar columnas y collapsar
FormacionAcademicaTec_2022_collapsed <- FormacionAcademicaTec_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(tecnico_completa  = sum(tecnico_completa, na.rm = TRUE)) %>%
  ungroup()

### UNIVERSITARIO
# Importar datos desde la hoja "Hoja1"
FormacionAcademicaUniv_2022 <- read_excel("2022_FormacionAcademicaUniv.xlsx")

#Renombrando variables
setnames(FormacionAcademicaUniv_2022, old = c("CONCLUIDOEDUUNI"), 
         new = c("universitaria_completa"))

# Seleccionar columnas
FormacionAcademicaUniv_2022 <- FormacionAcademicaUniv_2022 %>%
  select(IDHOJAVIDA, "universitaria_completa")

FormacionAcademicaUniv_2022$universitaria_completa <- ifelse(FormacionAcademicaUniv_2022$universitaria_completa=="SI", 1, 0)

# Seleccionar columnas y collapsar
FormacionAcademicaUniv_2022 <- FormacionAcademicaUniv_2022 %>%
  select("IDHOJAVIDA", "universitaria_completa")%>%
  distinct()

# Seleccionar columnas y collapsar
FormacionAcademicaUniv_2022_collapsed <- FormacionAcademicaUniv_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(universitaria_completa  = sum(universitaria_completa, na.rm = TRUE)) %>%
  ungroup()

################################################################################
#EXPERIENCIA LABORAL
# Importar datos desde la hoja "Hoja1"
ExperienciaLaboral_2022 <- read_excel("2022_ExperienciaLaboral.xlsx")

# Experiencia hasta la actualidad
ExperienciaLaboral_2022$ANIOTRABAJOHASTA <- ifelse(ExperienciaLaboral_2022$ANIOTRABAJOHASTA=="0000", 2024, ExperienciaLaboral_2022$ANIOTRABAJOHASTA)

# Calcular el valor mínimo de INICIO por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES
ExperienciaLaboral_2022 <- ExperienciaLaboral_2022 %>%
  group_by(IDHOJAVIDA) %>%
  mutate(MIN_ANIO_INICIO = min(ANIOTRABAJODESDE, na.rm = TRUE)) %>%
  ungroup()
# Calcular el valor máximo de FIN por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES
ExperienciaLaboral_2022 <- ExperienciaLaboral_2022 %>%
  group_by(IDHOJAVIDA) %>%
  mutate(MAX_ANIO_FIN = max(ANIOTRABAJOHASTA, na.rm = TRUE)) %>%
  ungroup()

# Seleccionar columnas y collapsar
ExperienciaLaboral_2022 <- ExperienciaLaboral_2022 %>%
  select(IDHOJAVIDA, MIN_ANIO_INICIO, MAX_ANIO_FIN)%>%
  distinct()

# Renombrar las variables
setnames(ExperienciaLaboral_2022, old = c("MIN_ANIO_INICIO","MAX_ANIO_FIN"), 
         new = c("min_anio_inicio", "max_anio_fin"))

# Seleccionar columnas
ExperienciaLaboral_2022 <- ExperienciaLaboral_2022 %>%
  select(IDHOJAVIDA, "min_anio_inicio", "max_anio_fin")

################################################################################
#SENTENCIAS PENALES
# Importar datos desde la hoja "Hoja1"
Sentencias_2022 <- read_excel("2022_SentenciasPenal.xlsx")
#Sentencias_2022 <- read_excel("2022_SentenciasObliga.xlsx")

# Eliminar duplicados basados en todas las variables
Sentencias_2022 <- Sentencias_2022 %>%
  distinct(.keep_all = TRUE)

# Agrupar por IDHOJAVIDA, y contar el número de repeticiones
Sentencias_2022_collapsed <- Sentencias_2022 %>%
  group_by(IDHOJAVIDA) %>%
  summarise(TOTAL_SENTENCIAS = n()) %>%
  ungroup()

# Renombrar las variables
setnames(Sentencias_2022_collapsed, old = c("TOTAL_SENTENCIAS"), 
         new = c("total_sentencias"))

# Seleccionar columnas
Sentencias_2022_collapsed <- Sentencias_2022_collapsed %>%
  select(IDHOJAVIDA,"total_sentencias")

################################################################################
#CARGO PARTIDARIO
CargoPartidario_2022 <- read_excel("2022_CargoPartidario2.xlsx")

# Calcular el valor mínimo de DESDE
CargoPartidario_2022 <- CargoPartidario_2022 %>%
  group_by(IDHOJAVIDA) %>%
  mutate(MIN_ANIO_DESDE = min(ANIOCARGOPARTIDESDE, na.rm = TRUE)) %>%
  ungroup()
# Calcular el valor máximo de HASTA
CargoPartidario_2022 <- CargoPartidario_2022 %>%
  group_by(IDHOJAVIDA) %>%
  mutate(MAX_ANIO_HASTA = max(AÑOCARGOPARTIDARIOHASTA, na.rm = TRUE)) %>%
  ungroup()

# Seleccionar columnas y collapsar
CargoPartidario_2022 <- CargoPartidario_2022 %>%
  select(IDHOJAVIDA, MIN_ANIO_DESDE, MAX_ANIO_HASTA)%>%
  distinct()

################################################################################
################################################################################
################################################################################
merged_fichas <- Candidatos_2022 %>%
  left_join(Educacion_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(FormacionAcademicaNouniv_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(FormacionAcademicaPost_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(FormacionAcademicaPostOtr_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(FormacionAcademicaTec_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(FormacionAcademicaUniv_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(ExperienciaLaboral_2022, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(Sentencias_2022_collapsed, by = c("IDHOJAVIDA"))

merged_fichas <- merged_fichas %>%
  left_join(CargoPartidario_2022, by = c("IDHOJAVIDA"))

# Reemplazar NA con 0 en las columnas col1, col2 y col3
merged_fichas <- merged_fichas %>%
  mutate(across(c("primaria_completa", "secundaria_completa",
                  "instituto_completo","postgrado_completo",
                  "diplomadoyotros_completo",
                  "tecnico_completa", "universitaria_completa",
                  "total_sentencias"),
                ~ replace_na(., 0)))

names(merged_fichas)

# Contar los valores de 1 y 0 en primaria_completa usando dplyr
conteo <- merged_fichas %>%
  group_by(diplomadoyotros_completo) %>%
  summarise(count = n())
print(conteo)

# Exportar el dataframe a un archivo CSV
write.csv(merged_fichas, "merged_ficha_2022.csv", row.names = FALSE, fileEncoding = "latin1")
print(merged_df)

if (nrow(Educacion_2022) == nrow(unique(Educacion_2022, by = IDHOJAVIDA))) {
  print("La variable 'id' identifica de forma única la base de datos.")
} else {
  print("La variable 'id' NO identifica de forma única la base de datos.")
}  
names(Candidatos_2022)

print(unique(FormacionAcademicaPost_2022$postgrado_completo))
