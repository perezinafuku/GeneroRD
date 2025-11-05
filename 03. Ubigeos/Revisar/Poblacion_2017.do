clear all
cd "C:\Users\User\Documents\Tesis UNALM\Proyecto de tesis\Análisis\"

local input "Input\Ubigeos"
local middle "Middle\Ubigeos"

import excel "`input'\Excel\Conteo2017-GruposQuinquenales.xlsx", sheet("`i'") clear

rename B distrito_ubigeo
rename C distrito_nombre
rename D anhos0_4
rename E anhos5_9
rename F anhos10_14
rename G anhos15_19
rename H anhos20_24
rename I anhos25_29
rename J anhos30_34
rename K anhos35_39
rename L anhos40_44
rename M anhos45_49
rename N anhos50_54
rename O anhos55_59
rename P anhos60_64
rename Q anhos65_69
rename R anhos70_74
rename S anhos75_79
rename T anhos80_84
rename U anhos85_89
rename V anhos90_94
rename W anhos95_mas

drop A X

sort distrito_ubigeo
drop if distrito_ubigeo==""
drop if distrito_ubigeo=="Código"
drop if distrito_ubigeo=="TOTAL"

destring anhos0_4-anhos95_mas, replace
egen anhos80_mas=rowtotal(anhos80_84 anhos85_89 anhos90_94 anhos95_mas)

gen anho=2017

drop anhos80_84 anhos85_89 anhos90_94 anhos95_mas

egen Total=rowtotal(anhos0_4 anhos5_9 anhos10_14 anhos15_19 anhos20_24 anhos25_29 anhos30_34 anhos35_39 anhos40_44 anhos45_49 anhos50_54 anhos55_59 anhos60_64 anhos65_69 anhos70_74 anhos75_79 anhos80_mas), missing
save `middle'\poblacion_2017, replace
