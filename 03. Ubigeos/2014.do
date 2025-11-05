clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Ubigeos"
local middle_infogob "Middle\Ubigeos"

import excel `input_infogob'\Excel\rptUbigeo-2014.xlsx,  ///
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
replace id1 = subinstr(id1,"ò","o",.)
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
replace id2 = subinstr(id2,"ò","o",.)
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
replace id3 = subinstr(id3,"ò","o",.)
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

replace id1 = subinstr(id1,"_"," ",.)
replace id2 = subinstr(id2,"_"," ",.)
replace id3 = subinstr(id3,"_"," ",.)

replace id1 = subinstr(id1,"-"," ",.)
replace id2 = subinstr(id2,"-"," ",.)
replace id3 = subinstr(id3,"-"," ",.)

drop DEPARTAMENTO PROVINCIA DISTRITO

replace id1=strtrim(id1)
replace id2=strtrim(id2)
replace id3=strtrim(id3)

*Correcciones
replace id3="MILPUCC" if id3=="MILPUC"
replace id2="ANTONIO RAIMONDI" if id2=="ANTONIO RAYMONDI" & id1=="ANCASH"
replace id3="ANTONIO RAIMONDI" if id3=="ANTONIO RAYMONDI" & id1=="ANCASH"
replace id2="CALLAO" if id2=="PROV. CONST. DEL CALLAO" & id1=="CALLAO"

replace id2="NAZCA" if id2=="NASCA" & id1=="ICA"

replace id3="CAPASO" if id3=="CAPAZO" & id1=="PUNO"
replace id3="CASPIZAPA" if id3=="CASPISAPA" & id1=="SAN MARTIN"
replace id3="ELIAS SOPLIN" if id3=="ELIAS SOPLIN VARGAS" & id1=="SAN MARTIN"
replace id3="TNTE MANUEL CLAVERO" if id3=="TENIENTE MANUEL CLAVERO" & id1=="LORETO"
replace id3="STA ROSA DE SACCO" if id3=="SANTA ROSA DE SACCO" & id1=="JUNIN"

replace id3="AYAUCA" if id3=="ALLAUCA" & id1=="LIMA"
replace id3="SAN JUAN DE YSCOS" if id3=="SAN JUAN DE ISCOS" & id1=="JUNIN"
replace id3="HUALLAY GRANDE" if id3=="HUAYLLAY GRANDE" & id1=="HUANCAVELICA"
replace id3="SANTA CRUZ DE TOLED" if id3=="SANTA CRUZ DE TOLEDO" & id1=="CAJAMARCA"
replace id3="SANTA RITA DE SIHUAS" if id3=="SANTA RITA DE SIGUAS" & id1=="AREQUIPA"
replace id3="QUISQUI" if id3=="QUISQUI (KICHKI)" & id1=="HUANUCO"
replace id3="MARISCAL GAMARRA" if id3=="GAMARRA" & id1=="APURIMAC"
replace id3="HUAILLATI" if id3=="HUAYLLATI" & id1=="APURIMAC"
replace id3="PAMPAS" if id3=="PAMPAS GRANDE" & id1=="ANCASH"

replace id2="MAYNAS" if id2=="PUTUMAYO" & id1=="LORETO" & id3=="PUTUMAYO"
replace id2="MAYNAS" if id2=="PUTUMAYO" & id1=="LORETO" & id3=="TNTE MANUEL CLAVERO"



egen iddistrito=concat(id1 id2 id3)

gen num=_n
save `middle_infogob'\ubigeo_2014, replace
