clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_ficha "Input\Fichas"
local middle_ficha "Middle\Fichas"

import delimited "`input_ficha'\resumen_2014.csv"

/*
id              long    %8.0g                 
nombres         str36   %36s                  
apellido_pate~o str40   %40s                  
apellido_mate~o str40   %40s                  
dni             long    %12.0g                
sexo            str1    %9s                   
f_nacimiento    str10   %10s                  
cargo_postula~n str23   %23s                  
ubigeo_postul~n long    %12.0g                
departamento_~n str13   %13s                  
provincia_pos~n str25   %25s                  
distrito_post~n str36   %36s                  
primaria_comp~a str5    %9s                   
secundaria_co~a str5    %9s                   
n_educacion_s~r byte    %8.0g                 n_educacion_superior_universitario
n_educacion_~do byte    %8.0g                 
n_educacion_~co byte    %8.0g                 
n_experiencia   byte    %8.0g                 
n_otra_experi~a byte    %8.0g                 
n_sentencias~so byte    %8.0g                 
n_sentencias~to byte    %8.0g                 
n_cargos_part~s byte    %8.0g                 
n_cargos_elec~r byte    %8.0g                 
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

gen 	mujer=0
replace mujer=1 if sexo=="F"
label 	define mujer 1 "Mujer" 0 "Hombre"
label 	value mujer mujer
label var mujer "1:mujer, 0:hombre"
drop sexo
*
*lab var edad "Edad"
gen lastpart = substr(f_nacimiento, strpos(f_nacimiento, "/") + 1, .)
gen anho_nacimiento = substr(lastpart, strpos(lastpart, "/") + 1, .)
destring anho_nacimiento, replace
gen anho_postulacion=2010
gen edad =anho_postulacion-anho_nacimiento
drop lastpart

lab var edad "Edad"
lab var anho_postulacion "Año de elección a la eleccion"
lab var dni "Documento Nacional de Identidad"
lab var f_nacimiento "Fecha de nacimiento"
lab var anho_nacimiento "Anho de nacimiento"

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

keep if cargo==0 | cargo==1 

lab var cargo "Cargo al que postula"


lab var ubigeo_postulacion "Ubigeo de postulacion"
lab var departamento_postulacion "Departamento de postulacion"
lab var provincia_postulacion "Provincia de postulacion"
lab var distrito_postulacion "Distrito de postulacion"
lab var primaria_completa "1:si tiene primaria concluida"
lab var secundaria_completa "1:si tiene secundaria concluida"
lab var n_educacion_superior_universitar "Educación superior: Universitaria"
lab var n_educacion_superior_postgrado "Educación superior: Postgrado"
lab var n_educacion_superior_tecnico "Educación superior: Técnico"
lab var n_experiencia "Experiencia Laboral"
lab var n_otra_experiencia "Otra experiencia"
lab var n_sentencias_doloso "Relación de sentencias por delitos dolosos"
lab var n_sentencias_incumplimiento "Relación de sentencias por incumplimiento"
lab var n_cargos_partidarios "Cargos políticos: cargos partidarios"
lab var n_cargos_eleccion_popular "Cargos políticos: de eleccion popular"

save `middle_ficha'\fichas_2014, replace
