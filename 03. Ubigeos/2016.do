clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Ubigeos"
local middle_infogob "Middle\Ubigeos"

import excel `input_infogob'\Excel\rptUbigeo-2016.xlsx,  ///
			sheet("ubicacionGeografica") cellrange(A2:J2171) firstrow clear

drop A C D G H I J
drop if DISTRITO==""
drop if DISTRITO==" "

sort DEPARTAMENTO

drop if DEPARTAMENTO=="DEPARTAMENTO"
sort DEPARTAMENTO PROVINCIA DISTRITO

gen id1 = ""
replace id1 = substr(DEPARTAMENTO,1,2)

gen id2 = ""
replace id2 = substr(PROVINCIA,1,2)

gen id3 = ""
replace id3 = substr(DISTRITO,1,2)

egen id=concat(id1 id2 id3)
lab var id "Ubigeo"
drop id1 id2 id3

gen id1 = ""
replace id1 = substr(DEPARTAMENTO,4,.)
replace id1 = subinstr(id1,"á","a",.)
replace id1 = subinstr(id1,"é","e",.)
replace id1 = subinstr(id1,"í","i",.)
replace id1 = subinstr(id1,"ó","o",.)
replace id1 = subinstr(id1,"ú","u",.)
replace id1 = subinstr(id1,"Á","A",.)
replace id1 = subinstr(id1,"É","E",.)
replace id1 = subinstr(id1,"Í","I",.)
replace id1 = subinstr(id1,"Ó","O",.)
replace id1 = subinstr(id1,"Ú","U",.)
replace id1 = subinstr(id1,"À","A",.)
replace id1 = subinstr(id1,"à","a",.)

gen id2 = ""
replace id2 = substr(PROVINCIA,4,.)
replace id2 = subinstr(id2,"á","a",.)
replace id2 = subinstr(id2,"é","e",.)
replace id2 = subinstr(id2,"í","i",.)
replace id2 = subinstr(id2,"ó","o",.)
replace id2 = subinstr(id2,"ú","u",.)
replace id2 = subinstr(id2,"Á","A",.)
replace id2 = subinstr(id2,"É","E",.)
replace id2 = subinstr(id2,"Í","I",.)
replace id2 = subinstr(id2,"Ó","O",.)
replace id2 = subinstr(id2,"Ú","U",.)
replace id2 = subinstr(id2,"À","A",.)
replace id2 = subinstr(id2,"à","a",.)


gen id3 = ""
replace id3 = substr(DISTRITO,4,.)
replace id3 = subinstr(id3,"á","a",.)
replace id3 = subinstr(id3,"é","e",.)
replace id3 = subinstr(id3,"í","i",.)
replace id3 = subinstr(id3,"ó","o",.)
replace id3 = subinstr(id3,"ú","u",.)
replace id3 = subinstr(id3,"Á","A",.)
replace id3 = subinstr(id3,"É","E",.)
replace id3 = subinstr(id3,"Í","I",.)
replace id3 = subinstr(id3,"Ó","O",.)
replace id3 = subinstr(id3,"Ú","U",.)
replace id3 = subinstr(id3,"À","A",.)
replace id3 = subinstr(id3,"à","a",.)


lab var id1 "Departamento"
lab var id2 "Provincia"
lab var id3 "Distrito"

replace id1=upper(id1)
replace id2=upper(id2)
replace id3=upper(id3)
replace id1 = subinstr(id1,"ñ","Ñ",.)
replace id2 = subinstr(id2,"ñ","Ñ",.)
replace id3 = subinstr(id3,"ñ","Ñ",.)

drop DEPARTAMENTO PROVINCIA DISTRITO

replace id1=strtrim(id1)
replace id2=strtrim(id2)
replace id3=strtrim(id3)

egen iddistrito2=concat(id1 id2 id3)

gen num=_n
save `middle_infogob'\ubigeo_2016, replace
