clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_luces "Input\Nightlights"
local middle_luces "Middle\Nightlights"

local middle_ubigeo "Middle\Ubigeos"

use `middle_luces'\pbi1993_2018, clear

replace iddistrito = subinstr(iddistrito,"Ã","Ñ",.)
replace iddistrito = subinstr(iddistrito,"-"," ",.)

tostring Ubigeo, gen(id)
replace id="0"+id if Ubigeo<100000
/*correcciones
Departamento	Provincia	Distrito
LORETO	PUTUMAYO	PUTUMAYO
LORETO	PUTUMAYO	TENIENTE MANUEL CLAVERO
*/
replace id = "160801" if id=="160109"
replace id = "160803" if id=="160114"

mmerge id using ///
`middle_ubigeo'\ubigeo_2014.dta

keep if _merge==3
drop num _merge

gen pbi_growth1 = (pbi2006 - pbi2003) / pbi2003 //2002
gen pbi_growth2 = (pbi2010 - pbi2007) / pbi2007 //2006
gen pbi_growth3 = (pbi2014 - pbi2011) / pbi2011 //2010
gen pbi_growth4 = (pbi2018 - pbi2015) / pbi2015 //2014
*gen pbi_growth5 = (pbi2022 - pbi2019) / pbi2019 //2018

gen pbi_mean1 = (pbi2003 + pbi2004 + pbi2005 + pbi2006) / 4 //2002
gen pbi_mean2 = (pbi2007 + pbi2008 + pbi2009 + pbi2010) / 4 //2006
gen pbi_mean3 = (pbi2011 + pbi2012 + pbi2013 + pbi2014) / 4 //2010
gen pbi_mean4 = (pbi2015 + pbi2016 + pbi2017 + pbi2018) / 4 //2014
*gen pbi_mean5 = (pbi2019 + pbi2020 + pbi2021 + pbi2022) / 4 //2018


reshape long pbi_growth pbi_mean, i(iddistrito id1 id2 id3 Ubigeo id Departamento Provincia Distrito Territorio) j(anho_cargo)

gen 	pbi_1=pbi2003 if anho_cargo==1
replace pbi_1=pbi2007 if anho_cargo==2
replace pbi_1=pbi2011 if anho_cargo==3
replace pbi_1=pbi2015 if anho_cargo==4

gen 	pbi_2=pbi2004 if anho_cargo==1
replace pbi_2=pbi2008 if anho_cargo==2
replace pbi_2=pbi2012 if anho_cargo==3
replace pbi_2=pbi2016 if anho_cargo==4

gen 	pbi_3=pbi2005 if anho_cargo==1
replace pbi_3=pbi2009 if anho_cargo==2
replace pbi_3=pbi2013 if anho_cargo==3
replace pbi_3=pbi2017 if anho_cargo==4

gen 	pbi_4=pbi2006 if anho_cargo==1
replace pbi_4=pbi2010 if anho_cargo==2
replace pbi_4=pbi2014 if anho_cargo==3
replace pbi_4=pbi2018 if anho_cargo==4

recast double pbi_1 pbi_2 pbi_3 pbi_4 pbi_mean
format pbi_1 pbi_2 pbi_3 pbi_4 pbi_mean %10.0gc

lab var pbi_growth "Tasa de crecimiento del PBI (entre el primer y el último año del mandato)"
lab var pbi_mean "Promedio del PBI (para cada distrito durante 4 años)"
lab var pbi_1 "PBI del 1er año de gestión: 2003, 2007, 2011, 2015"
lab var pbi_2 "PBI del 2do año de gestión: 2004, 2008, 2012, 2016"
lab var pbi_3 "PBI del 3er año de gestión: 2005, 2009, 2013, 2017"
lab var pbi_4 "PBI del 4to año de gestión: 2006, 2010, 2014, 2018"

drop pbi1993-pbi2018
/*
gen 	anho_cargo=1 if anho>=2003 & anho<=2006 //2002
replace anho_cargo=2 if anho>=2007 & anho<=2010 //2006
replace anho_cargo=3 if anho>=2011 & anho<=2014 //2010
replace anho_cargo=4 if anho>=2015 & anho<=2018 //2014
replace anho_cargo=5 if anho>=2019 & anho<=2023 //2018

drop if anho_cargo==. //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>OJO

collapse (mean) pbi, by(anho_cargo iddistrito-Territorio)
*/
sort iddistrito anho_cargo

save `middle_luces'\pbi1993_2018_ubigeo, replace
