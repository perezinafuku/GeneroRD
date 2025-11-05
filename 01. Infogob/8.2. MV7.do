clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local middle_infogob "Middle\Infogob"

local middle_ubigeo "Input\Ubigeos"

use "`middle_infogob'\hombremujer7_append", clear
gen id=_n
collapse id, by(iddistrito) // 1658 distritos
drop id
gen id=_n

replace iddistrito = subinstr(iddistrito,"Ã","Ñ",.)
replace iddistrito = subinstr(iddistrito,"-"," ",.)

mmerge iddistrito using ///
`middle_ubigeo'\ubigeo_2014.dta

keep if _merge==3
mmerge iddistrito using "`middle_infogob'\hombremujer7_append"
keep if _merge==3
rename id distrito_ubigeo

gen 	anho_cargo=1 if anho==2002
replace anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022

save `middle_infogob'\hombremujer7_append_ubigeo, replace
