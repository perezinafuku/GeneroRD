clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_ficha "Input\Fichas"
local middle_ficha "Middle\Fichas"

import delimited "`input_ficha'\JNE (pedido)\merged_ficha_2022.csv"

tab cargo_postulacion

replace cargo_postulacion="ALCALDE DISTRITAL" if strpos( cargo_postulacion, "ALCALDE DISTRITAL" )
replace cargo_postulacion="ALCALDE PROVINCIAL" if strpos( cargo_postulacion, "ALCALDE PROVINCIAL")
replace cargo_postulacion="REGIDOR DISTRITAL" if strpos( cargo_postulacion, "REGIDOR DISTRITAL")
replace cargo_postulacion="REGIDOR PROVINCIAL" if strpos( cargo_postulacion, "REGIDOR PROVINCIAL")
replace cargo_postulacion="VICEGOBERNADOR REGIONAL" if strpos( cargo_postulacion, "VICEGOBERNADOR REGIONAL")
replace cargo_postulacion="GOBERNADOR REGIONAL" if strpos( cargo_postulacion, "GOBERNADOR REGIONAL")
replace cargo_postulacion="CONSEJERO REGIONAL" if strpos( cargo_postulacion, "CONSEJERO REGIONAL")
replace cargo_postulacion="ACCESITARIO" if strpos( cargo_postulacion, "ACCESITARIO" )

duplicates drop

*Eliminando duplicados y realizando correcciones
drop if idhojavida==223032
drop if idhojavida==228851
drop if idhojavida==198445

replace max_anio_fin="2022" if idhojavida==233731
drop if idhojavida==212751

drop if idhojavida==241734
drop if idhojavida==151495

replace min_anio_inicio= "2026" if idhojavida==231839
drop if idhojavida==223533

drop if idhojavida==184221

replace instituto= 1 if idhojavida==165797
drop if idhojavida==222074

drop if idhojavida==231628
drop if idhojavida==180548

replace secundaria= 1 if idhojavida==181425
drop if idhojavida==193768

drop if idhojavida==202943
isid dni

gen nacimiento_anio=substr(f_nacimiento,7,.)
destring nacimiento_anio, replace

gen anho_postulacion=2022
gen edad =anho_postulacion-nacimiento_anio
lab var edad "Edad"
lab var anho_postulacion "Año de postulación a la eleccion"

lab var dni "Documento Nacional de Identidad"
lab var nacimiento_anio "Anho de nacimiento"

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

lab var f_nacimiento "Fecha de nacimiento"
lab var cargo "Cargo al que postula"
*lab var region_postulacion "Región"
*lab var provincia_postulacion  "Provincia"
lab var distrito_postulacion "Distrito"
*lab var org_politica "Organización Política"
lab var primaria_completa "Formación académica: Primaria Completa"
lab var secundaria_completa "Formación académica: Secundaria Completa"
lab var tecnico_completa "Tiene educacion tecnica completa"
lab var universitaria_completa "Tiene educacion universitaria completa"
lab var postgrado_completo "Tiene estudios de postgrados completo"
lab var diplomadoyotros_completo "Tiene otros estudios de postgrados completo"
lab var instituto_completo "Tiene estudios en institutos completa"

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

save `middle_ficha'\fichas_2022, replace
