clear all
cd "C:\Users\User\Documents\Tesis UNALM\Proyecto de tesis\Análisis\"

local input "Input\Ubigeos"
local middle "Middle\Ubigeos"


forvalues i =2007(1)2015 {
import excel "`input'\Excel\POBLACION-POR GRUPOS QUINQUENALES DE EDAD.xlsx", sheet("`i'") clear

rename E anhos0_4
rename F anhos5_9
rename G anhos10_14
rename H anhos15_19
rename I anhos20_24
rename J anhos25_29
rename K anhos30_34
rename L anhos35_39
rename M anhos40_44
rename N anhos45_49
rename O anhos50_54
rename P anhos55_59
rename Q anhos60_64
rename R anhos65_69
rename S anhos70_74
rename T anhos75_79
rename U anhos80_mas								
rename D Total
rename B distrito_ubigeo

keep distrito_ubigeo Total anhos0_4-anhos80_mas

sort distrito_ubigeo
drop if distrito_ubigeo==""
drop if  anhos80_mas==""

compress

gen anho=`i'
save `middle'\poblacion_`i', replace
}

*append
use `middle'\poblacion_2007, clear
forvalues i = 2008(1)2015 {
append using "`middle'\poblacion_`i'"
save `middle'\poblacion2007_2015, replace
}
destring Total-anhos80_mas, replace float
save `middle'\poblacion2007_2015, replace

use `middle'\poblacion2007_2015, clear
append using "`middle'\poblacion_2017"
drop distrito_nombre
destring distrito_ubigeo, replace
collapse Total anhos0_4 anhos5_9 anhos10_14 anhos15_19 anhos20_24 anhos25_29 ///
			anhos30_34 anhos35_39 anhos40_44 anhos45_49 anhos50_54 anhos55_59 ///
			anhos60_64 anhos65_69 anhos70_74 anhos75_79 anhos80_mas, by( distrito_ubigeo )
gen anho=2016			
save `middle'\poblacion2016_estimated, replace

use `middle'\poblacion_2017, clear 
destring distrito_ubigeo, replace
save `middle'\poblacion_2017_destring, replace

use `middle'\poblacion2007_2015, clear
destring distrito_ubigeo, replace
append using "`middle'\poblacion2016_estimated"
append using "`middle'\poblacion_2017_destring"
save `middle'\poblacion_total, replace
