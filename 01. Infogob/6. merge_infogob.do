clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local middle_infogob "Middle\Infogob"

forvalues i = 2002 (4) 2022 {
* Unión de bases de infogob: autoridades, candidatos y resultados
use 	`middle_infogob'\autoridades_`i', clear
mmerge 	idpersona using `middle_infogob'\candidatos_`i'
mmerge 	idpartido using `middle_infogob'\resultados_`i'
drop if votos_blanco==1
drop if votos_nulos==1
keep if _merge==3

sort Región Provincia Distrito cargo num_votos
egen id_candidato=concat(pri_apell seg_apell nombres)

keep if cargo==1 //me quedo con los alcaldes

egen rank = rank( ptje_votos ), by ( iddistrito ) unique //lugar que ocuparon los candidatos en la eleccion
egen ganador=max(rank), by(idd) 
gen 	perdedor=ganador-rank // 0 y 1 nos indicaran los que quedaron primeros en la eleccion
replace perdedor=. if perdedor>1 // dropeo a los candidatos que no quedaron en los 2 primeros lugares

drop rank ganador
drop if perdedor==. // me quedo con los 2 primeros

bysort iddistrito: egen maxvotos=max(ptje_votos)
gen diferencia_votos=maxvotos-ptje_votos

*Margen de victoria
bysort iddistrito: egen mv_max=max(diferencia_votos)

save `middle_infogob'\union_elecciones_`i', replace // guardo la base de datos de infogob: candidatos 1 y 2

* Margen de victoria del 10%
use `middle_infogob'\union_elecciones_`i', clear
gen margen=1 if diferencia_votos<=10 & diferencia_votos>0 //margen de victoria del 10%
collapse margen, by(iddistrito)
keep if margen==1 // dónde los resultados fueron ajustados al 10%
drop margen
save `middle_infogob'\distrito_mv10_`i', replace //guardar base de distritos que tuvieron resultados ajustados al 10%

* Margen de victoria del 7.5%
use `middle_infogob'\union_elecciones_`i', clear
gen margen=1 if diferencia_votos<=7.5 & diferencia_votos>0 //margen de victoria del 7.5%
collapse margen, by(iddistrito)
keep if margen==1 // dónde los resultados fueron ajustados al 7.5%
drop margen
save `middle_infogob'\distrito_mv7_`i', replace //guardar base de distritos que tuvieron resultados ajustados al 10%

* Margen de victoria del 5%
use `middle_infogob'\union_elecciones_`i', clear
gen margen=1 if diferencia_votos<=5 & diferencia_votos>0 //margen de victoria del 5%
collapse margen, by(iddistrito)
keep if margen==1 // dónde los resultados fueron ajustados al 5%
drop margen
save `middle_infogob'\distrito_mv5_`i', replace //guardar base de distritos que tuvieron resultados ajustados al 10%

* Municipios en los que postuló una mujer (de los 2 primeros candidatos)
use `middle_infogob'\union_elecciones_`i', clear
collapse (mean) mujer, by(iddistrito)
keep if mujer==0.5 // hombre/mujer
drop mujer
save `middle_infogob'\distritos_mujer_`i', replace

* Municipios en los que ganó una mujer
use `middle_infogob'\union_elecciones_`i', clear
mmerge iddistrito using `middle_infogob'\distritos_mujer_`i'
keep if _merge==3
tab mujer actual
save `middle_infogob'\distritos_alcalde_mujer_`i', replace

* Municipios en los que ganó una mujer al 10%
use `middle_infogob'\distritos_alcalde_mujer_`i', clear
mmerge iddistrito using `middle_infogob'\distrito_mv10_`i'
keep if _merge==3
tab mujer actual
save `middle_infogob'\mv10_`i', replace

* Municipios en los que ganó una mujer al 7.5%
use `middle_infogob'\distritos_alcalde_mujer_`i', clear
mmerge iddistrito using `middle_infogob'\distrito_mv7_`i'
keep if _merge==3
tab mujer actual
save `middle_infogob'\mv7_`i', replace

* Municipios en los que ganó una mujer al 5%
use `middle_infogob'\distritos_alcalde_mujer_`i', clear
mmerge iddistrito using `middle_infogob'\distrito_mv5_`i'
keep if _merge==3
tab mujer actual
save `middle_infogob'\mv5_`i', replace

* Municipios en los que postuló una mujer (de los 2 primeros candidatos) y hubo 
* resultados ajustados al 10%
use `middle_infogob'\union_elecciones_`i', clear
mmerge iddistrito using `middle_infogob'\distrito_mv10_`i'
keep if _merge==3
mmerge iddistrito using `middle_infogob'\distritos_mujer_`i'
keep if _merge==3
save `middle_infogob'\hombremujer10_`i', replace

* Municipios en los que postuló una mujer (de los 2 primeros candidatos) y hubo 
* resultados ajustados al 7.5%
use `middle_infogob'\union_elecciones_`i', clear
mmerge iddistrito using `middle_infogob'\distrito_mv7_`i'
keep if _merge==3
mmerge iddistrito using `middle_infogob'\distritos_mujer_`i'
keep if _merge==3
save `middle_infogob'\hombremujer7_`i', replace

* Municipios en los que postuló una mujer (de los 2 primeros candidatos) y hubo 
* resultados ajustados al 5%
use `middle_infogob'\union_elecciones_`i', clear
mmerge iddistrito using `middle_infogob'\distrito_mv5_`i'
keep if _merge==3
mmerge iddistrito using `middle_infogob'\distritos_mujer_`i'
keep if _merge==3
save `middle_infogob'\hombremujer5_`i', replace
}
/*
use distritos_mujer_2014, clear
use distritos_alcalde_mujer_2014, clear
use mv10_2014, clear
tab mujer actual
use mv7_2014, clear
tab mujer actual
use mv5_2014, clear
tab mujer actual
