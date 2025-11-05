clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_ficha "Input\Fichas"
local middle_ficha "Middle\Fichas"

import delimited "`input_ficha'\JNE (pedido)\merged_ficha_2018.csv"

/*
nombres         str38   %38s                  
apellido_pate~o str19   %19s                  
apellido_mate~o str27   %27s                  
dni             long    %12.0g                
sexo            str9    %9s                   
cargo_postula~n str23   %23s                  
ubigeo_postul~n long    %12.0g                
distrito_post~n str18   %18s                  
primaria_comp~a byte    %8.0g                 
secundaria_co~a byte    %8.0g                 
tecnico_concl~o byte    %8.0g                 
universitario~o byte    %8.0g                 
postgrado_con~o byte    %8.0g                 
otroestudios_~o byte    %8.0g                 
min_anio_inicio str4    %9s                   
max_anio_fin    str4    %9s                   
total_sentenc~s byte    %8.0g                 
min_anio_desde  str4    %9s                   
max_anio_hasta  str4    %9s 
*/

*gen nacimiento_anio=substr(f_nacimiento,7,.)
*destring nacimiento_anio, replace

gen anho_postulacion=2018
*gen edad =anho_postulacion-nacimiento_anio
*lab var edad "Edad"
lab var anho_postulacion "Año de postulación a la eleccion"

lab var dni "Documento Nacional de Identidad"
*lab var nacimiento_anio "Anho de nacimiento"

gen 	mujer=0
replace mujer=1 if sexo=="FEMENINO"
label 	define mujer 1 "Mujer" 0 "Hombre"
label 	value mujer mujer
label var mujer "1:mujer, 0:hombre"
drop sexo

gen 	cargo=0
replace cargo=1 if cargo_postulacion=="ALCALDE DISTRITAL"
replace cargo=. if cargo_postulacion=="ALCALDE PROVINCIAL"
replace cargo=. if cargo_postulacion=="CONSEJERO REGIONAL"
replace cargo=. if cargo_postulacion=="ACCESITARIO"
replace cargo=. if cargo_postulacion=="REGIDOR PROVINCIAL"
replace cargo=. if cargo_postulacion=="GOBERNADOR REGIONAL"
replace cargo=. if cargo_postulacion=="VICEGOBERNADOR REGIONAL"
label 	define cargo 1 "ALCALDE DISTRITAL" 0 "REGIDOR DISTRITAL"
label 	value cargo cargo
drop cargo_postulacion

destring min_anio_inicio max_anio_fin, replace force
gen anhos_experiencia= max_anio_fin - min_anio_inicio

gen experiencia= (anhos_experiencia>0)

gen antecedentes= (total_sentencias>0)

*lab var f_nacimiento "Fecha de nacimiento"
lab var cargo "Cargo al que postula"
*lab var region_postulacion "Región"
*lab var provincia_postulacion  "Provincia"
lab var distrito_postulacion "Distrito"
*lab var org_politica "Organización Política"
lab var primaria_completa "Formación académica: Primaria Completa"
lab var secundaria_completa "Formación académica: Secundaria Completa"
lab var tecnico_concluido "Tiene educacion tecnica completa"
lab var universitario_concluido "Tiene educacion universitaria completa"
lab var postgrado_concluido "Tiene estudios de postgrados completo"
lab var otroestudios_concluido "Tiene otros estudios de postgrados completo"
lab var experiencia "Tiene experiencia laboral"
lab var anhos_experiencia "Anhos de experiencia laboral"
lab var antecedentes "Antecedentes Judiciales y/o Penales"

gen Nombres=nombres
replace Nombres = subinstr(nombres, "Ã", "Ñ", .) 

gen Apellido_paterno=apellido_paterno
replace Apellido_paterno = subinstr(apellido_paterno, "Ã", "Ñ", .) 

gen Apellido_materno=apellido_materno
replace Apellido_materno = subinstr(apellido_materno, "Ã", "Ñ", .) 

replace Apellido_paterno="CARHUAMANTA" if Apellido_paterno=="CARHUAMANTCARHUAMANTA"

lab var Nombres "Nombres"
lab var Apellido_paterno "Apellido paterno"
lab var Apellido_materno "Apellido materno"

drop nombres apellido_paterno apellido_materno

keep if cargo==0 | cargo==1 //me quedo solo con los que postulan a alcalde o regidor

save `middle_ficha'\fichas_2018, replace
