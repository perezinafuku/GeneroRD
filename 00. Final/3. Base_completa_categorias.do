clear all
cd "C:\Users\User\Documents\Tesis UNALM\Proyecto de tesis\Análisis\"

local infogob "Middle\Infogob"
local fichas "Middle\Fichas"
local pbi "Middle\Nightlights"
local idh "Middle\PNUD"


local infogob_output "Output\Infogob"

* Municipios en los que postuló una mujer (de los 2 primeros candidatos)
forvalues i = 2002(4)2022 {
use "`infogob'\distritos_mujer_`i'", clear
mmerge iddistrito using "`infogob'\union_elecciones_`i'"
keep if _merge==3

save "`infogob_output'\distritos_mujer_`i'", replace
}

**CONSTRUYENDO LA BASE GENERAL

*Base de distritos en los que participó una mujer (de los 2 primeros candidatos)
use "`infogob_output'\distritos_mujer_2002", clear
append using "`infogob_output'\distritos_mujer_2006"
append using "`infogob_output'\distritos_mujer_2010"
append using "`infogob_output'\distritos_mujer_2014"
append using "`infogob_output'\distritos_mujer_2018"
append using "`infogob_output'\distritos_mujer_2022"

gen 	anho_cargo=1 if anho==2002
replace anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022
drop anho

*Unión con la base de datos de % de votos mujeres
mmerge iddistrito anho_cargo using "`infogob'\padron_append"
keep if _merge==3
********************************************************************************
*Uniendo con las FICHAS de los candidatos
mmerge iddistrito idpersona anho_cargo using "INFOGOB\Hojas de vida\datos"
keep if _merge==3
/*
*Unión con la base de datos de % de regidoras
mmerge iddistrito anho_cargo using regidoras_porcentaje
keep if _merge==3 //me quedo con 682 observaciones
*/
save base1, replace

*Unión con la base del MEF
gen id=_n
collapse id, by(iddistrito)
drop id
gen id=_n
matchit id iddistrito using "UBIGEOS\ubigeo_2014.dta", idu(num) txtu(iddistrito2) override
sort similscore
save "BASE TOTAL\similscore_ubigeo", replace

use "BASE TOTAL\similscore_ubigeo", clear
sort iddistrito
egen rank = rank( similscore ), by ( iddistrito ) unique
egen maximo=max(rank), by(iddistrito)
gen  identifica=maximo-rank 
sort iddistrito rank

keep if identifica==0
isid iddistrito
sort similscore
save "BASE TOTAL\similscore_ubigeo_modificado", replace

use "BASE TOTAL\similscore_ubigeo_modificado", clear
isid iddistrito2
isid iddistrito
drop id num similscore rank maximo identifica n
mmerge iddistrito2 using "UBIGEOS\ubigeo_2014.dta"
keep if _merge==3
mmerge iddistrito using "base1"
keep if _merge==3
rename id distrito_ubigeo

destring distrito_ubigeo, replace
mmerge distrito_ubigeo anho_cargo using "MEF\input\base_mef_division"
keep if _merge==3

mmerge distrito_ubigeo using "PNUD\IDH-Peru"
keep if _merge==3

mmerge distrito_ubigeo using "UBIGEOS\rural_urbano"
keep if _merge==3
lab var rural "1: rural, 0: urbano"

*Labeling las variables
drop 	Región Provincia num Distrito votos_blanco votos_nulos Númerodeelectores  		///
		Electoresvarones F Electoresmujeres Electoresjóvenes Electoresmayoresde70años  ///
		participacion votos_emitidos votos_validos perdedor _merge N joven    ///
		tipo Distrito id_candidato iddistrito2 pri_apell seg_apell nombres

rename H electores_mujeres
rename J electores_jovenes
rename L electores_mayores

lab var edad "Edad del candidato"
lab var idpartido "id del partido"
lab var idpersona "id del candidato: distrito+persona"
lab var cargo "1: alcalde, 0: regidor"
lab var mujer "1:mujer, 0:hombre"
lab var actual "1:si es alcalde, 0: ~"
lab var anho "Anho electoral"
lab var ptje_votos "Porcentaje de votos obtenidos"
lab var diferencia_votos "Diferencia de votos entre el primer y segundo lugar"
lab var anho_cargo "1:2007-2010, 2:2011-2014, 3:2015_2018"

keep if actual==1
replace mv_max=-mv_max if mujer==0

save "BASE TOTAL\base_categorias", replace
