clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_pnud "Input\PNUD"
local middle_pnud "Middle\PNUD"

use `middle_pnud'\IDH-Peru2003-2017, clear
append using `middle_pnud'\IDH-Peru2018
append using `middle_pnud'\IDH-Peru2019
compress

gen 	anho_cargo=1 if anho>=2003 & anho<=2006
replace anho_cargo=2 if anho>=2007 & anho<=2010
replace anho_cargo=3 if anho>=2011 & anho<=2014
replace anho_cargo=4 if anho>=2015 & anho<=2018
replace anho_cargo=5 if anho>=2019 & anho<=2023

rename distrito_ubigeo id

collapse (mean) Habitantes IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc, by(id anho_cargo)

destring id, replace

save `middle_pnud'\IDH-Peru, replace
