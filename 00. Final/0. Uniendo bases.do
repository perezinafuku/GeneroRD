clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local input_ubigeo 	"Input\Ubigeos"
local input_ficha 	"Input\Fichas"
local input_luces 	"Input\Nightlights"
local input_pnud 	"Input\PNUD"

local middle_infogob "Middle\Infogob"
local middle_ubigeo "Middle\Ubigeos"
local middle_ficha 	"Middle\Fichas"
local middle_luces 	"Middle\Nightlights"
local middle_pnud 	"Middle\PNUD"

* Municipios en los que postuló una mujer (de los 2 primeros candidatos)
forvalues i = 2002(4)2022 {
use `middle_infogob'\distritos_mujer_`i', clear
mmerge iddistrito using `middle_infogob'\union_elecciones_`i'
keep if _merge==3

save `middle_infogob'\distritos_mujer_`i', replace
}

* Unión de bases de infogob: autoridades, candidatos y resultados
forvalues i=2002(4)2022 {
use 	`middle_infogob'\autoridades_`i', clear
mmerge 	idpersona using `middle_infogob'\candidatos_`i'
mmerge 	idpartido using `middle_infogob'\resultados_`i'
drop if votos_blanco==1
drop if votos_nulos==1
keep if _merge==3

sort Región Provincia Distrito cargo num_votos
egen id_candidato=concat(pri_apell seg_apell nombres)

keep if cargo==0 //me quedo con los regidores
keep if actual==1 //me quedo con los regidores

bysort iddistrito: gen regidores=_n
bysort iddistrito: egen regidor_numero=max(regidores)
bysort iddistrito: egen regidor_mujer=sum(mujer)
bysort iddistrito: gen regidor_mujer_prctje=regidor_mujer/regidor_numero

collapse regidor_mujer_prctje, by(iddistrito)
gen anho=`i'

save `middle_infogob'\regidoras_prctje_`i', replace
}

use `middle_infogob'\regidoras_prctje_2002, clear
append using `middle_infogob'\regidoras_prctje_2006
append using `middle_infogob'\regidoras_prctje_2010
append using `middle_infogob'\regidoras_prctje_2014
append using `middle_infogob'\regidoras_prctje_2018
append using `middle_infogob'\regidoras_prctje_2022
gen 	anho_cargo=1 if anho==2002
replace anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022
drop anho
save `middle_infogob'\regidoras_porcentaje, replace

**CONSTRUYENDO LA BASE GENERAL

*Base de distritos en los que participó una mujer (de los 2 primeros candidatos)
use `middle_infogob'\distritos_mujer_2002, clear
append using `middle_infogob'\distritos_mujer_2006
append using `middle_infogob'\distritos_mujer_2010
append using `middle_infogob'\distritos_mujer_2014
append using `middle_infogob'\distritos_mujer_2018
append using `middle_infogob'\distritos_mujer_2022

gen 	anho_cargo=1 if anho==2002
replace anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022

*Unión con la base de datos de % de votos mujeres
mmerge iddistrito anho_cargo using `middle_infogob'\padron_append
keep if _merge==3
drop anho

*Unión con la base de datos de % de regidoras
mmerge iddistrito anho using `middle_infogob'\regidoras_porcentaje
keep if _merge==3

*Uniendo con las FICHAS de los candidatos
mmerge iddistrito id_candidato anho_cargo ///
using `middle_ficha'\fichas_candidatos_append
*keep if _merge==3>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OJO
drop if _merge==2

duplicates drop

*Unión con la base del PBI
mmerge iddistrito anho using "`middle_luces'\pbi1993_2018_ubigeo.dta"
keep if _merge==3
/*
mmerge id anho using "`middle_pnud'\IDH-Peru.dta"
keep if _merge==3

*mmerge distrito_ubigeo anho using "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\UBIGEOS\poblacion_total.dta"
*keep if _merge==3

*Labeling las variables
drop 	Región Provincia num Distrito votos_blanco votos_nulos Númerodeelectores  		///
		Electoresvarones F Electoresmujeres Electoresjóvenes Electoresmayoresde70años  ///
		participacion votos_emitidos votos_validos perdedor _merge N joven    ///
		tipo

rename H electores_mujeres
rename J electores_jovenes
rename L electores_mayores

lab var idpartido "id del partido"
lab var idpersona "id del candidato: distrito+persona"
lab var id_candidato "id del candidato"
lab var cargo "1: alcalde, 0: regidor"
lab var mujer "1:mujer, 0:hombre"
lab var actual "1:si es alcalde, 0: ~"
lab var anho "Anho electoral"
lab var ptje_votos "Porcentaje de votos obtenidos"
lab var diferencia_votos "Diferencia de votos entre el primer y segundo lugar"
lab var anho_cargo "1:2007-2010, 2:2011-2014, 3:2015_2018"
*lab var municipio "id del municipio"
lab var regidor_mujer_prctje "% regidores mujeres"
*/
save "Output\base_total_1", replace
