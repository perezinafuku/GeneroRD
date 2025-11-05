clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local middle_infogob "Middle\Infogob"
local middle_ubigeo "Middle\Ubigeos"
local middle_ficha 	"Middle\Fichas"
local middle_luces 	"Middle\Nightlights"
local middle_pnud 	"Middle\PNUD"

local graficos "Output\Gráficos"

*COVARIABLES: DISCONTINUIDAD
forvalues i=2002(4)2022 {
use 	`middle_infogob'\autoridades_`i', clear
mmerge 	idpersona using `middle_infogob'\candidatos_`i'
mmerge 	idpartido using `middle_infogob'\resultados_`i'
drop if votos_blanco==1
drop if votos_nulos==1
keep if _merge==3

sort Región Provincia Distrito cargo num_votos
egen id_candidato=concat(pri_apell seg_apell nombres)

keep if cargo==1 //me quedo con los alcaldes

keep if mujer==1 //me quedo con las mujeres

keep iddistrito ptje_votos

rename ptje_votos ptje_votos_mujer
save `middle_infogob'\alcaldesas_ptje_votos_`i', replace
}

forvalues i=2002(4)2022 {
use `middle_infogob'\distritos_mujer_`i', clear
mmerge iddistrito using `middle_infogob'\union_elecciones_`i'
keep if _merge==3
keep if actual==1 // quién ganó la elección mujer o varón
mmerge iddistrito using `middle_infogob'\alcaldesas_ptje_votos_`i'
keep if _merge==3
save `middle_infogob'\spillover_ptje_votos_`i', replace
}

use `middle_infogob'\spillover_ptje_votos_2002, clear
append using `middle_infogob'\spillover_ptje_votos_2006
append using `middle_infogob'\spillover_ptje_votos_2010
append using `middle_infogob'\spillover_ptje_votos_2014
append using `middle_infogob'\spillover_ptje_votos_2018
append using `middle_infogob'\spillover_ptje_votos_2022
save `middle_infogob'\spillover_ptje_votos_total, replace

replace mv_max=-mv_max if mujer==0

*Discontinuidad en las preferencias por mujeres políticas					  
rdplot ptje_votos_mujer mv_max, p(3) ///
       graph_options(ytitle(% votos obtenidos por todas las mujeres en t) ///
                     xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export `graficos'\ptje_votos_mujer.pdf, replace				 

* Test McCrary
DCdensity mv_max, breakpoint(0) generate(Xj Yj r0 fhat se_fhat)
graph export `graficos'\DCdensity.pdf, as(pdf) replace

* Densidad
tw (histogram mv_max) (normal mv_max), xline(0) legend(off) graphregion(color(white))
graph export `graficos'\Densidad-MV.pdf, replace

*********************************************************************************
use Output/base_total_1, clear
mmerge iddistrito id_candidato anho_cargo using "`middle_ficha'\fichas_candidatos_append"
keep if _merge==3
replace mv_max=-mv_max if mujer==0
*drop if mv_max==0

keep if actual==1

rdplot edad mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-edad.pdf", replace
					 
rdplot secundaria mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))	
graph export "`graficos'\RD-secundaria.pdf", replace					 
					 
rdplot experiencia_laboral mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-experiencia_laboral.pdf", replace	
					 
rdplot ant_penales mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-ant_penales.pdf", replace	
					 

local covs "edad secundaria experiencia_laboral ant_penales"
local num: list sizeof covs
mat balance = J(`num',2,.)
local row = 1
foreach z in `covs' {
    qui rdrobust `z' mv_max, p(3)
	mat balance[`row',1] = round(e(tau_cl),.001)
	mat balance[`row',2] = round(e(pv_rb),.001)
	local ++row
}
mat rownames balance = `covs'
mat colnames balance = "RD Effect" "Robust p-val"
mat lis balance					 
********************************************************************************
********************************************************************************
*cd "`middle'\"
forvalues i=2002(4)2022 {
use "`middle_infogob'\padron_`i'", clear

keep iddistrito F H J L
rename F Electores_varones
rename H Electores_mujeres
rename J Electores_jovenes
rename L Electores_mayores

keep iddistrito Electores_varones Electores_mujeres Electores_jovenes Electores_mayores
sort iddistrito
save `middle_infogob'\alcaldesas_padron_`i', replace
}

use `middle_infogob'\distritos_mujer_2006, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2006
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle_infogob'\alcaldesas_padron_2002
keep if _merge==3
save `middle_infogob'\spillover_padron_2006, replace

use `middle_infogob'\distritos_mujer_2010, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2010
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle_infogob'\alcaldesas_padron_2006
keep if _merge==3
save `middle_infogob'\spillover_padron_2010, replace

use `middle_infogob'\distritos_mujer_2014, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2014
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle_infogob'\alcaldesas_padron_2010
keep if _merge==3
save `middle_infogob'\spillover_padron_2014, replace

use `middle_infogob'\distritos_mujer_2018, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2018
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle_infogob'\alcaldesas_padron_2014
keep if _merge==3
save `middle_infogob'\spillover_padron_2018, replace

use `middle_infogob'\distritos_mujer_2022, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2022
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle_infogob'\alcaldesas_padron_2018
keep if _merge==3
save `middle_infogob'\spillover_padron_2022, replace

use `middle_infogob'\spillover_padron_2006, clear
append using `middle_infogob'\spillover_padron_2010
append using `middle_infogob'\spillover_padron_2014
append using `middle_infogob'\spillover_padron_2018
append using `middle_infogob'\spillover_padron_2022
save Output\spillover_padron_total, replace

replace mv_max=-mv_max if mujer==0

replace Electores_varones=Electores_varones*100
replace Electores_mujeres=Electores_mujeres*100
replace Electores_jovenes=Electores_jovenes*100
replace Electores_mayores=Electores_mayores*100

rdplot Electores_mujeres mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Electores_mujeres.pdf", replace
					 
rdplot Electores_jovenes mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Electores_jovenes.pdf", replace

					 
rdplot Electores_mayores mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Electores_mayores.pdf", replace


local covs "Electores_mujeres Electores_jovenes Electores_mayores"
local num: list sizeof covs
mat balance = J(`num',2,.)
local row = 1
foreach z in `covs' {
    qui rdrobust `z' mv_max, p(3)
	mat balance[`row',1] = round(e(tau_cl),.001)
	mat balance[`row',2] = round(e(pv_rb),.001)
	local ++row
}
mat rownames balance = `covs'
mat colnames balance = "RD Effect" "Robust p-val"
mat lis balance	
********************************************************************************					 
/*
use `middle'\distritos_mujer_2006, clear
mmerge iddistrito using `middle'\union_elecciones_2006
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle'\alcaldesas_ptje_votos_2002
keep if _merge==3
save `middle'\spillover_padron_2006, replace

use `middle'\distritos_mujer_2010, clear
mmerge iddistrito using `middle'\union_elecciones_2010
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle'\alcaldesas_ptje_votos_2006
keep if _merge==3
save `middle'\spillover_padron_2010, replace

use `middle'\distritos_mujer_2014, clear
mmerge iddistrito using `middle'\union_elecciones_2014
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle'\alcaldesas_ptje_votos_2010
keep if _merge==3
save `middle'\spillover_padron_2014, replace

use `middle'\distritos_mujer_2018, clear
mmerge iddistrito using `middle'\union_elecciones_2018
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle'\alcaldesas_ptje_votos_2014
keep if _merge==3
save `middle'\spillover_padron_2018, replace

use `middle'\distritos_mujer_2022, clear
mmerge iddistrito using `middle'\union_elecciones_2022
keep if _merge==3
keep if actual==1
mmerge iddistrito using `middle'\alcaldesas_ptje_votos_2018
keep if _merge==3
save `middle'\spillover_padron_2022, replace

use `middle'\spillover_padron_2006, clear
append using `middle'\spillover_padron_2010
append using `middle'\spillover_padron_2014
append using `middle'\spillover_padron_2018
append using `middle'\spillover_padron_2022
save `output'\spillover_padron_total, replace

replace mv_max=-mv_max if mujer==0

replace participacion=participacion*100
/*
rdplot numero_mujer mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Candidatas.pdf", replace
	*/
rdplot participacion mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Participacion.pdf", replace
							 
*local covs "hay_mujer prctje_alcalde_candidatas numero_mujer"
local covs " ptje_votos_mujer"
local num: list sizeof covs
mat balance = J(`num',2,.)
local row = 1
foreach z in `covs' {
    qui rdrobust `z' mv_max, p(3)
	mat balance[`row',1] = round(e(tau_cl),.001)
	mat balance[`row',2] = round(e(pv_rb),.001)
	local ++row
}
mat rownames balance = `covs'
mat colnames balance = "RD Effect" "Robust p-val"
mat lis balance
*/					 
********************************************************************************
use `middle_infogob'\distritos_mujer_2002, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2002
keep if _merge==3
keep if actual==1
save `middle_infogob'\spillover_pnud_2002, replace

use `middle_infogob'\distritos_mujer_2006, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2006
keep if _merge==3
keep if actual==1
save `middle_infogob'\spillover_pnud_2006, replace

use `middle_infogob'\distritos_mujer_2010, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2010
keep if _merge==3
keep if actual==1
save `middle_infogob'\spillover_pnud_2010, replace

use `middle_infogob'\distritos_mujer_2014, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2014
keep if _merge==3
keep if actual==1
save `middle_infogob'\spillover_pnud_2014, replace

use `middle_infogob'\distritos_mujer_2018, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2018
keep if _merge==3
keep if actual==1
save `middle_infogob'\spillover_pnud_2018, replace

use `middle_infogob'\distritos_mujer_2022, clear
mmerge iddistrito using `middle_infogob'\union_elecciones_2022
keep if _merge==3
keep if actual==1
save `middle_infogob'\spillover_pnud_2022, replace

use `middle_infogob'\spillover_pnud_2002, clear
append using `middle_infogob'\spillover_pnud_2006
append using `middle_infogob'\spillover_pnud_2010
append using `middle_infogob'\spillover_pnud_2014
append using `middle_infogob'\spillover_pnud_2018
append using `middle_infogob'\spillover_pnud_2022
save `middle_infogob'\spillover_pnud_total, replace

mmerge iddistrito using "`middle_ubigeo'\ubigeo_2014_v1"
keep if _merge==3

mmerge id anho using "`middle_pnud'\IDH-Peru"
keep if _merge==3
***
**************************************************************************>>>OJO
duplicates drop
***
replace mv_max=-mv_max if mujer==0

rdplot IDH mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-IDH.pdf", replace
	
rdplot Esperanza_vida mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Esperanza_vida.pdf", replace

rdplot Poblacion_educ_sec mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Poblacion_educ_sec.pdf", replace

rdplot Ingreso_familiar_pc mv_max, p(3) ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
graph export "`graficos'\RD-Ingreso_familiar_pc.pdf", replace
							 
local covs "IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc"
local num: list sizeof covs
mat balance = J(`num',2,.)
local row = 1
foreach z in `covs' {
    qui rdrobust `z' mv_max, p(3) h(5)
	mat balance[`row',1] = round(e(tau_cl),.001)
	mat balance[`row',2] = round(e(pv_rb),.001)
	local ++row
}
mat rownames balance = `covs'
mat colnames balance = "RD Effect" "Robust p-val"
mat lis balance			
