import excel "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\UBIGEOS\Excel\reporte.xlsx", sheet("Output") clear
gen ubigeo =  strpos(B, "AREA")
gen evangelico =  strpos(B, "Evangélica")
gen total =  strpos(B, "Total")
save "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\UBIGEOS\Excel\reporte", replace

forvalues i = 1(3)5621 {

use "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\UBIGEOS\Excel\reporte", clear
keep if ubigeo==1 | evangelico==1 | total==1

local j=`i'+2
local k=`i'+1

keep in `i'/`j'
drop A F
destring C D E, replace force

gen evangelico_pop=C in 2
egen evangelico_pop1=max(evangelico_pop)

gen total_pop=C in 3
egen total_pop1=max(total_pop)

gen prctje_evangelico=evangelico_pop1/total_pop1
keep in 1
keep B prctje_evangelico

tempfile save`i'
save "`save`i''"
  }
  
clear
use "`save1'", clear
forvalues i=1(3)5621 {
  append using "`save`i''"
}

save "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\UBIGEOS\Excel\evangelicos", replace

gen distrito_ubigeo=substr(B,7,.)
destring distrito_ubigeo,replace
duplicates drop distrito_ubigeo, force
keep prctje_evangelico distrito_ubigeo
save "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\UBIGEOS\Excel\evangelicos_base", replace
