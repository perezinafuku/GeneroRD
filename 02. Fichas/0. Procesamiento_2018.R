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

# Importar datos desde la hoja "Hoja1"
#BienInmueble_2018 <- read_excel("2018_BienInmueble.xlsx")
#BienMueble_2018 <- read_excel("2018_BienMueble.xlsx")
#Ingreso_2018 <- read_excel("2018_Ingreso.xlsx")
#MueblesOtros_2018 <- read_excel("2018_MueblesOtros.xlsx")
#Renuncias_2018 <- read_excel("2018_Renuncias.xlsx")
#SentenciasDetalle_2018 <- read_excel("2018_SentenciasDetalle.xlsx")

# Ver las primeras filas del dataframe
#head(BienInmueble_2018)

# Ver los nombres de las variables
#names(ExperienciaLaboral_2018)

# Verificar unicidad
#if (nrow(Candidatos_2018) == nrow(unique(Candidatos_2018, by = DOCUMENTOIDENTIDAD))) {
#  print("La variable 'id' identifica de forma única la base de datos.")
#} else {
#  print("La variable 'id' NO identifica de forma única la base de datos.")
#}   

################################################################################
# Base de candidatos
# Importar datos desde la hoja "Hoja1"
Candidatos_2018 <- read_excel("2018_Candidatos.xlsx")

# Renombrar las variables de candidatos
setnames(Candidatos_2018, old = c("NOMBRES", "APELLIDOPATERNO", 
                                  "APELLIDOMATERNO", "DOCUMENTOIDENTIDAD",
                                  "SEXO", "CARGOELECCION",
                                  "UBIGEOPOSTULA", "DISTRITOELECTORAL"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "sexo", "cargo_postulacion",
                 "ubigeo_postulacion", "distrito_postulacion"))

# Seleccionar columnas
Candidatos_2018 <- Candidatos_2018 %>%
  select("nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "sexo", "cargo_postulacion",
         "ubigeo_postulacion", "distrito_postulacion")

################################################################################
# Base de educacion PRIMARIA Y SECUNDARIA

# Importar datos desde la hoja "Hoja1"
Educacion_2018 <- read_excel("2018_Educacion.xlsx")

# Eliminar filas donde TIPOESTUDIO es NA usando base R
Educacion_2018 <- Educacion_2018[!is.na(Educacion_2018$TIPOESTUDIO), ]

#Long to wide
Educacion_2018_wide <- Educacion_2018 %>%
  pivot_wider(
    id_cols = c("PATERNO", "MATERNO", "NOMBRES", "DOCUMENTOIDENTIDAD"),
    names_from = c("TIPOESTUDIO", "SITUACION"),
    values_from = IDPROCESOELECTORAL
  )

#Creando dummys para primaria|secundaria completa
Educacion_2018_wide$PRIMARIA_SI <- ifelse(is.na(Educacion_2018_wide$PRIMARIA_SI), 0, 1)
Educacion_2018_wide$SECUNDARIA_SI <- ifelse(is.na(Educacion_2018_wide$SECUNDARIA_SI), 0, 1)

#Renombrando variables
setnames(Educacion_2018_wide, old = c("NOMBRES", "PATERNO", 
                                  "MATERNO", "DOCUMENTOIDENTIDAD",
                                  "PRIMARIA_SI", "SECUNDARIA_SI"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "primaria_completa", "secundaria_completa"))

# Seleccionar columnas
Educacion_2018_wide <- Educacion_2018_wide %>%
  select("nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "primaria_completa", "secundaria_completa")
################################################################################
#FORMACIÓN ACADEMICA
# Importar datos desde la hoja "Hoja1"
FormacionAcademica_2018 <- read_excel("2018_FormacionAcademica.xlsx")

#Long to wide
FormacionAcademica_2018$n <- 1

FormacionAcademica_2018_wide <- FormacionAcademica_2018 %>%
  pivot_wider(
    id_cols = c("PATERNO", "MATERNO", "NOMBRES", "DOCUMENTOIDENTIDAD"),
    names_from = c("TIPOESTUDIO", "SITUACION"),
    values_from = ORDENESTUDIO
  )

# Exportando a Excel por los NULL
nombre_archivo <- "FormacionAcademica_2018_wide.xlsx"

# Definir la ruta completa del archivo Excel (en este caso se guardará en el directorio de trabajo actual)
ruta_archivo <- file.path(getwd(), nombre_archivo)

# Exportar el dataframe a Excel por los NULL
write.xlsx(FormacionAcademica_2018_wide, file = ruta_archivo, rowNames = FALSE)

# Importando el Excel
FormacionAcademica_2018_wide <- read_excel("FormacionAcademica_2018_wide.xlsx")

FormacionAcademica_2018_wide$`ESTUDIOS TÉCNICOS_CONCLUIDO` <- ifelse(is.na(FormacionAcademica_2018_wide$`ESTUDIOS TÉCNICOS_CONCLUIDO`), 0, 1)
FormacionAcademica_2018_wide$`ESTUDIOS UNIVERSITARIOS_CONCLUIDO` <- ifelse(is.na(FormacionAcademica_2018_wide$`ESTUDIOS UNIVERSITARIOS_CONCLUIDO`), 0, 1)
FormacionAcademica_2018_wide$`POSTGRADO_CONCLUIDO` <- ifelse(is.na(FormacionAcademica_2018_wide$`POSTGRADO_CONCLUIDO`), 0, 1)
FormacionAcademica_2018_wide$OTROS_CONCLUIDO <- ifelse(is.na(FormacionAcademica_2018_wide$OTROS_CONCLUIDO), 0, 1)

#Renombrando variables
setnames(FormacionAcademica_2018_wide, old = c("NOMBRES", "PATERNO", 
                                      "MATERNO", "DOCUMENTOIDENTIDAD",
                                      "ESTUDIOS TÉCNICOS_CONCLUIDO", 
                                      "ESTUDIOS UNIVERSITARIOS_CONCLUIDO",
                                      "POSTGRADO_CONCLUIDO", "OTROS_CONCLUIDO"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "tecnico_concluido", "universitario_concluido",
                 "postgrado_concluido", "otroestudios_concluido"))

# Seleccionar columnas
FormacionAcademica_2018_wide <- FormacionAcademica_2018_wide %>%
  select("nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "tecnico_concluido", "universitario_concluido",
         "postgrado_concluido", "otroestudios_concluido")
################################################################################
#EXPERIENCIA LABORAL

# Importar datos desde la hoja "Hoja1"
ExperienciaLaboral_2018 <- read_excel("2018_ExperienciaLaboral.xlsx")

# Eliminar filas donde CENTROLABORAL es NA usando base R
ExperienciaLaboral_2018 <- ExperienciaLaboral_2018[!is.na(ExperienciaLaboral_2018$CENTROLABORAL), ]

# Experiencia hasta la actualidad
ExperienciaLaboral_2018$FIN <- ifelse(ExperienciaLaboral_2018$FIN==0, 2024, ExperienciaLaboral_2018$FIN)
ExperienciaLaboral_2018$FIN <- ifelse(ExperienciaLaboral_2018$DOCUMENTOIDENTIDAD==42711044, 2024, ExperienciaLaboral_2018$FIN)

# Calcular el valor mínimo de INICIO por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES
ExperienciaLaboral_2018 <- ExperienciaLaboral_2018 %>%
  group_by(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES) %>%
  mutate(MIN_ANIO_INICIO = min(INICIO, na.rm = TRUE)) %>%
  ungroup()
# Calcular el valor máximo de FIN por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES
ExperienciaLaboral_2018 <- ExperienciaLaboral_2018 %>%
  group_by(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES) %>%
  mutate(MAX_ANIO_FIN = max(FIN, na.rm = TRUE)) %>%
  ungroup()

# Seleccionar columnas y collapsar
ExperienciaLaboral_2018 <- ExperienciaLaboral_2018 %>%
  select(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES, MIN_ANIO_INICIO, MAX_ANIO_FIN)%>%
  distinct()

# Verificar unicidad
if (nrow(ExperienciaLaboral_2018) == nrow(unique(ExperienciaLaboral_2018, by = DOCUMENTOIDENTIDAD))) {
  print("La variable 'id' identifica de forma única la base de datos.")
} else {
  print("La variable 'id' NO identifica de forma única la base de datos.")
}

# Renombrar las variables
setnames(ExperienciaLaboral_2018, old = c("NOMBRES", "PATERNO", 
                                  "MATERNO", "DOCUMENTOIDENTIDAD",
                                  "MIN_ANIO_INICIO","MAX_ANIO_FIN"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "min_anio_inicio", "max_anio_fin"))

# Seleccionar columnas
ExperienciaLaboral_2018 <- ExperienciaLaboral_2018 %>%
  select("nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "min_anio_inicio", "max_anio_fin")
################################################################################
#SENTENCIAS PENALES

# Importar datos desde la hoja "Hoja1"
Sentencias_2018 <- read_excel("2018_Sentencias.xlsx")

# Eliminar duplicados basados en todas las variables
Sentencias_2018 <- Sentencias_2018 %>%
  distinct(.keep_all = TRUE)

# Crear la nueva variable DOLOSO_O_PECULADO_FLAG basada en la presencia de las palabras "doloso" o "peculado" en la columna delito
Sentencias_2018 <- Sentencias_2018 %>%
  mutate(DOLOSO_O_PECULADO_FLAG = ifelse(grepl("doloso|peculado|malversa|patrimonio", DELITOPENAL, ignore.case = TRUE), 1, 0))

# Agrupar por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES, y contar el número de repeticiones
#Sentencias_2018_collapsed <- Sentencias_2018 %>%
#  group_by(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES) %>%
#  summarise(TOTAL_SENTENCIAS  = sum(DOLOSO_O_PECULADO_FLAG, na.rm = TRUE)) %>%
#  ungroup()

# Agrupar por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES, y contar el número de repeticiones
Sentencias_2018_collapsed <- Sentencias_2018 %>%
  group_by(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES) %>%
  summarise(TOTAL_SENTENCIAS = n()) %>%
  ungroup()

# Renombrar las variables
setnames(Sentencias_2018_collapsed, old = c("NOMBRES", "PATERNO", 
                                          "MATERNO", "DOCUMENTOIDENTIDAD",
                                          "TOTAL_SENTENCIAS"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "total_sentencias"))

# Seleccionar columnas
Sentencias_2018_collapsed <- Sentencias_2018_collapsed %>%
  select("nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "total_sentencias")

################################################################################
#CARGO PARTIDARIO
CargoPartidario_2018 <- read_excel("2018_CargoPartidario.xlsx")

# Calcular el valor mínimo de DESDE por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES
CargoPartidario_2018 <- CargoPartidario_2018 %>%
  group_by(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES) %>%
  mutate(MIN_ANIO_DESDE = min(DESDE, na.rm = TRUE)) %>%
  ungroup()
# Calcular el valor máximo de HASTA por DOCUMENTOIDENTIDAD, PATERNO, MATERNO y NOMBRES
CargoPartidario_2018 <- CargoPartidario_2018 %>%
  group_by(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES) %>%
  mutate(MAX_ANIO_HASTA = max(HASTA, na.rm = TRUE)) %>%
  ungroup()

# Seleccionar columnas y collapsar
CargoPartidario_2018 <- CargoPartidario_2018 %>%
  select(DOCUMENTOIDENTIDAD, PATERNO, MATERNO, NOMBRES, MIN_ANIO_DESDE, MAX_ANIO_HASTA)%>%
  distinct()

# Verificar unicidad
if (nrow(CargoPartidario_2018) == nrow(unique(CargoPartidario_2018, by = DOCUMENTOIDENTIDAD))) {
  print("La variable 'id' identifica de forma única la base de datos.")
} else {
  print("La variable 'id' NO identifica de forma única la base de datos.")
}

# Renombrar las variables
setnames(CargoPartidario_2018, old = c("NOMBRES", "PATERNO", 
                                        "MATERNO", "DOCUMENTOIDENTIDAD",
                                       "MIN_ANIO_DESDE","MAX_ANIO_HASTA"), 
         new = c("nombres", "apellido_paterno", 
                 "apellido_materno", "dni",
                 "min_anio_desde","max_anio_hasta"))

# Seleccionar columnas
CargoPartidario_2018 <- CargoPartidario_2018 %>%
  select("nombres", "apellido_paterno", 
         "apellido_materno", "dni",
         "min_anio_desde","max_anio_hasta")

################################################################################
################################################################################
################################################################################
merged_fichas <- Candidatos_2018 %>%
  left_join(Educacion_2018_wide, by = c("nombres", "apellido_paterno", 
                                        "apellido_materno", "dni"))
merged_fichas <- merged_fichas %>%
  left_join(FormacionAcademica_2018_wide, by = c("nombres", "apellido_paterno", 
                                        "apellido_materno", "dni"))
merged_fichas <- merged_fichas %>%
  left_join(ExperienciaLaboral_2018, by = c("nombres", "apellido_paterno", 
                                                 "apellido_materno", "dni"))
merged_fichas <- merged_fichas %>%
  left_join(Sentencias_2018_collapsed, by = c("nombres", "apellido_paterno", 
                                            "apellido_materno", "dni"))
merged_fichas <- merged_fichas %>%
  left_join(CargoPartidario_2018, by = c("nombres", "apellido_paterno", 
                                              "apellido_materno", "dni"))

names(merged_fichas)

# Contar los valores de 1 y 0 en primaria_completa usando dplyr
conteo <- merged_fichas %>%
  group_by(postgrado_concluido) %>%
  summarise(count = n())
print(conteo)

# Reemplazar NA con 0 en las columnas col1, col2 y col3
merged_fichas <- merged_fichas %>%
  mutate(across(c("primaria_completa", "secundaria_completa", 
                  "tecnico_concluido", "universitario_concluido", 
                  "postgrado_concluido", "otroestudios_concluido", 
                  "total_sentencias"),
                  ~ replace_na(., 0)))

# Exportar el dataframe a un archivo CSV
write.csv(merged_fichas, "merged_ficha_2018.csv", row.names = FALSE, fileEncoding = "latin1")

print(merged_df)
#id 		n_cargos_partidarios	n_cargos_eleccion_popular