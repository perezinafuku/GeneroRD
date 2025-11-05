clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_ficha "Input\Fichas"
local middle_ficha "Middle\Fichas"

import delimited "`input_ficha'\resumen_2010.csv"
/*
id              long    %12.0g                
nombres         str35   %35s                  
apellido_pate~o str20   %20s                  
apellido_mate~o str31   %31s                  
dni             long    %12.0g                
sexo            str1    %9s                   
f_nacimiento    str10   %10s                  
cargo_postula~n str23   %23s                  
ubigeo_postul~n long    %12.0g                
lugar_postula~n str57   %57s                  
id_org_politica int     %8.0g                 
nombre_org_po~a str82   %82s                  
estado_postul~n str8    %9s                   
primaria_comp~a str5    %9s                   
secundaria_co~a str5    %9s                   
n_educacion_s~r byte    %8.0g                 n_educacion_superior_universitario
n_educacion_s~i byte    %8.0g                 n_educacion_superior_no_universitario
n_educacion_~so byte    %8.0g                 
n_educacion_~do byte    %8.0g                 
n_educacion_~co byte    %8.0g                 
n_experiencia   byte    %8.0g                 
n_otra_experi~a byte    %8.0g                 
n_sentencias~so byte    %8.0g                 
n_sentencias~to byte    %8.0g                 
n_cargos_part~s byte    %8.0g                 
n_cargos_elec~r byte    %8.0g                 
n_cargos_renu~s byte    %8.0g  
*/
drop id
*
gen Nombres=nombres
replace Nombres = subinstr(nombres, "Ã", "Ñ", .) 

gen Apellido_paterno=apellido_paterno
replace Apellido_paterno = subinstr(apellido_paterno, "Ã", "Ñ", .) 

gen Apellido_materno=apellido_materno
replace Apellido_materno = subinstr(apellido_materno, "Ã", "Ñ", .) 

lab var Nombres "Nombres"
lab var Apellido_paterno "Apellido paterno"
lab var Apellido_materno "Apellido materno"

drop nombres apellido_paterno apellido_materno
*
gen nacimiento_anio=substr(f_nacimiento,7,.)
destring nacimiento_anio, replace
gen anho_postulacion=2010
gen edad =anho_postulacion-nacimiento_anio
lab var edad "Edad"
lab var anho_postulacion "Año de elección a la eleccion"

lab var dni "Documento Nacional de Identidad"
lab var nacimiento_anio "Anho de nacimiento"

gen 	mujer=0
replace mujer=1 if sexo=="F"
label 	define mujer 1 "Mujer" 0 "Hombre"
label 	value mujer mujer
label var mujer "1:mujer, 0:hombre"
drop sexo

gen 	cargo=0
replace cargo=1 if cargo_postulacion=="ALCALDE DISTRITAL"
replace cargo=. if cargo_postulacion=="ACCESITARIO"
replace cargo=. if cargo_postulacion=="ALCALDE PROVINCIAL"
replace cargo=. if cargo_postulacion=="CONSEJERO REGIONAL"
replace cargo=. if cargo_postulacion=="PRESIDENTE REGIONAL"
replace cargo=. if cargo_postulacion=="REGIDOR PROVINCIAL"
replace cargo=. if cargo_postulacion=="VICEPRESIDENTE REGIONAL"
label 	define cargo 1 "ALCALDE DISTRITAL" 0 "REGIDOR DISTRITAL"
label 	value cargo cargo
drop cargo_postulacion

keep if cargo==0 | cargo==1 //me quedo solo con los que postulan a alcalde o regidor

lab var f_nacimiento "Fecha de nacimiento"
lab var cargo "Cargo al que postula"

lab var id_org_politica "Organización Política"

gen Nombre_org_politica=nombre_org_politica
replace Nombre_org_politica = subinstr(nombre_org_politica, "Ã", "Ñ", .) 
lab var nombre_org_politica "Organización Política"
drop nombre_org_politica

lab var Nombre_org_politica "Nombre de la organización política"
lab var primaria_completa "Formación académica: Primaria Completa"
lab var secundaria_completa "Formación académica: Secundaria Completa"
lab var n_educacion_superior_curso "Educacion superior: En curso"
lab var n_educacion_superior_postgrado "Educacion superior: Postgrado"
lab var n_educacion_superior_tecnico "Educacion superior: Tecnico"
lab var n_experiencia "Tiene experiencia laboral"
lab var n_otra_experiencia "Otra experiencia laboral"
lab var n_sentencias_doloso "SENTENCIAS CONDENATORIAS POR DELITOS DOLOSOS Y QUE HUBIERAN QUEDADO FIRMES"
lab var n_sentencias_incumplimiento "SENTENCIAS QUE DECLARARON FUNDADAS O INFUNDADAS EN PARTE"
lab var n_cargos_partidarios "Cargos políticos: Cargos partidarios"
lab var n_cargos_eleccion_popular "Cargos políticos: Cargos de elección popular"

*
generate splitat = strpos(lugar_postulacion," - ")
list lugar_postulacion if splitat == 0

generate str1 region_postulacion = "" 
replace region_postulacion = substr(lugar_postulacion,1,splitat - 1)

generate str1 provincia_postulacion = "" 
replace provincia_postulacion = substr(lugar_postulacion,splitat + 1,.)
replace provincia_postulacion = substr(provincia_postulacion,strpos(provincia_postulacion," ") + 1,.) 

*
generate splitat2 = strpos(provincia_postulacion," - ")
list provincia_postulacion if splitat2 == 0

generate str1 provincia_postulacion2 = "" 
replace provincia_postulacion2 = substr(provincia_postulacion,1,splitat2 - 1)

generate str1 distrito_postulacion = "" 
replace distrito_postulacion = substr(provincia_postulacion,splitat2 + 1,.)
replace distrito_postulacion = substr(distrito_postulacion,strpos(distrito_postulacion," ") + 1,.) 

drop provincia_postulacion splitat2 splitat
rename provincia_postulacion2 provincia_postulacion

lab var region_postulacion "Región"
lab var provincia_postulacion  "Provincia"
lab var distrito_postulacion "Distrito"
lab var ubigeo_postulacion "Ubigeo de postulación"
lab var lugar_postulacion "Lugar de postulación"

replace region_postulacion = subinstr(region_postulacion, "Ã", "Ñ", .) 
replace provincia_postulacion = subinstr(provincia_postulacion, "Ã", "Ñ", .) 
replace distrito_postulacion = subinstr(distrito_postulacion, "Ã", "Ñ", .) 

save `middle_ficha'\fichas_2010, replace
