clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_ficha "Input\Fichas"
local middle_ficha "Middle\Fichas"

local middle_ubigeo "Middle\Ubigeos"
local middle_infogob "Middle\Infogob"

********************************************************************************
use `middle_ficha'\fichas_2006.dta, clear

*Al menos secundaria completa
gen 	secundaria=0
replace secundaria=1 if secundaria_completa=="True"

*Tiene experiencia laboral
gen 	experiencia_laboral=0
replace experiencia_laboral=1 if n_experiencia>0 | n_otra_experiencia>0

*Tiene antecedentes podiciales y/o judiciales
gen 	ant_penales=0
replace ant_penales	=1 if ant_penales>0

keep 	secundaria experiencia_laboral ant_penales region_postulacion  cargo ///
		provincia_postulacion distrito_postulacion Nombres Apellido_paterno  ///
		Apellido_materno edad

lab var secundaria "Dummy: Tiene al menos secundaria completa"
lab var experiencia_laboral "Dummy: Tiene algún tipo de experiencia laboral"
lab var ant_penales "Dummy: Tiene antecedentes penales y/o judiciales"

*Uniendo a la base de ubigeos
egen iddistrito=concat(region_postulacion provincia_postulacion distrito_postulacion)

replace iddistrito = subinstr(iddistrito,"Ã","Ñ",.)
replace iddistrito = subinstr(iddistrito,"-"," ",.)

mmerge iddistrito using `middle_ubigeo'\ubigeo_2014.dta

keep if _merge==3
rename id distrito_ubigeo
*
gen anho=2006
save `middle_ficha'\ficha_2006_base1, replace

********************************************************************************
use `middle_ficha'\fichas_2010.dta, clear

*Al menos secundaria completa
gen 	secundaria=0
replace secundaria=1 if secundaria_completa=="True"

*Tiene experiencia laboral
gen 	experiencia_laboral=0
replace experiencia_laboral=1 if n_experiencia>0 | n_otra_experiencia>0

*Tiene antecedentes podiciales y/o judiciales
gen 	ant_penales=0
replace ant_penales	=1 if n_sentencias_doloso>0 | n_sentencias_incumplimiento>0

keep 	secundaria experiencia_laboral ant_penales region_postulacion  cargo ///
		provincia_postulacion distrito_postulacion Nombres Apellido_paterno ///
		Apellido_materno edad

lab var secundaria "Dummy: Tiene al menos secundaria completa"
lab var experiencia_laboral "Dummy: Tiene algún tipo de experiencia laboral"
lab var ant_penales "Dummy: Tiene antecedentes penales y/o judiciales"

*Uniendo a la base de ubigeos
egen iddistrito=concat(region_postulacion provincia_postulacion distrito_postulacion)

replace iddistrito = subinstr(iddistrito,"Ã","Ñ",.)
replace iddistrito = subinstr(iddistrito,"-"," ",.)

mmerge iddistrito using `middle_ubigeo'\ubigeo_2014.dta

keep if _merge==3
rename id distrito_ubigeo
*
gen anho=2010
save `middle_ficha'\ficha_2010_base1, replace

********************************************************************************
use `middle_ficha'\fichas_2014.dta, clear

*Al menos secundaria completa
gen 	secundaria=0
replace secundaria=1 if secundaria_completa=="True"

*Tiene experiencia laboral
gen 	experiencia_laboral=0
replace experiencia_laboral=1 if n_experiencia>0 | n_otra_experiencia>0

*Tiene antecedentes podiciales y/o judiciales
gen 	ant_penales=0
replace ant_penales	=1 if n_sentencias_doloso>0 | n_sentencias_incumplimiento>0

keep 	secundaria experiencia_laboral ant_penales  cargo ///
		departamento_postulacion provincia_postulacion distrito_postulacion ///
		ubigeo_postulacion  Nombres Apellido_paterno Apellido_materno edad
		
rename departamento_postulacion region_postulacion
		
keep 	secundaria experiencia_laboral ant_penales region_postulacion  cargo ///
		provincia_postulacion distrito_postulacion Nombres Apellido_paterno ///
		Apellido_materno edad

lab var secundaria "Dummy: Tiene al menos secundaria completa"
lab var experiencia_laboral "Dummy: Tiene algún tipo de experiencia laboral"
lab var ant_penales "Dummy: Tiene antecedentes penales y/o judiciales"

*Uniendo a la base de ubigeos
egen iddistrito=concat(region_postulacion provincia_postulacion distrito_postulacion)

replace iddistrito = subinstr(iddistrito,"Ã","Ñ",.)
replace iddistrito = subinstr(iddistrito,"-"," ",.)

mmerge iddistrito using `middle_ubigeo'\ubigeo_2014_v1.dta

keep if _merge==3
rename id distrito_ubigeo
*
gen anho=2014
save `middle_ficha'\ficha_2014_base1, replace

********************************************************************************
use `middle_ficha'\fichas_2018.dta, clear

*Al menos secundaria completa
rename secundaria_completa secundaria

*Tiene experiencia laboral
rename experiencia experiencia_laboral

*Tiene antecedentes podiciales y/o judiciales
rename antecedentes	ant_penales

* Convertir id a cadena para la concatenación si id es numérico
tostring ubigeo_postulacion, gen(id_str) format(%12.0f)

* Concatenar "0" con ubigeo_postulacion y guardar en una nueva variable
gen str id_reniec = "0" + id_str if ubigeo_postulacion < 100000
replace id_reniec = id_str if id_reniec ==""

keep 	secundaria experiencia_laboral ant_penales  cargo ///
		id_reniec distrito_postulacion ///
		Nombres Apellido_paterno Apellido_materno

*Uniendo a la base de ubigeos
mmerge id_reniec using `middle_ubigeo'\ubigeo_2024.dta

keep if _merge==3
rename id distrito_ubigeo

drop distrito_postulacion

rename department  region_postulacion
rename province  provincia_postulacion 
rename district distrito_postulacion
*
gen anho=2018
save `middle_ficha'\ficha_2018_base1, replace
********************************************************************************
use `middle_ficha'\fichas_2022.dta, clear

*Al menos secundaria completa
rename secundaria_completa secundaria

*Tiene experiencia laboral
rename experiencia experiencia_laboral

*Tiene antecedentes podiciales y/o judiciales
rename antecedentes	ant_penales

* Convertir id a cadena para la concatenación si id es numérico
tostring ubigeo_postulacion, gen(id_str) format(%12.0f)

* Concatenar "0" con ubigeo_postulacion y guardar en una nueva variable
gen str id_reniec = "0" + id_str if ubigeo_postulacion < 100000
replace id_reniec = id_str if id_reniec ==""

keep 	secundaria experiencia_laboral ant_penales  cargo ///
		id_reniec distrito_postulacion ///
		Nombres Apellido_paterno Apellido_materno edad

*Uniendo a la base de ubigeos
mmerge id_reniec using `middle_ubigeo'\ubigeo_2024.dta

keep if _merge==3
rename id distrito_ubigeo

drop distrito_postulacion

rename department  region_postulacion
rename province  provincia_postulacion 
rename district distrito_postulacion
*
gen anho=2022
save `middle_ficha'\ficha_2022_base1, replace

********************************************************************************
********************************************************************************
* UNIENDO A LA BASE DE INFOGOB
use `middle_ficha'\ficha_2006_base1, clear
egen id=concat(Apellido_paterno Apellido_materno Nombres)
replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)
save `middle_ficha'\ficha_2006_base1_nombres, replace

use `middle_infogob'\candidatos_2006.dta, clear
egen id=concat(pri_apell seg_apell nombres)

replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)

replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
replace iddistrito="JUNINYAULISTA ROSA DE SACCO" if iddistrito=="JUNINYAULISANTA ROSA DE SACCO"
replace iddistrito="AYACUCHOLUCANASHUAC HUAS" if iddistrito=="AYACUCHOLUCANASHUAC-HUAS"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUAYA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUALLA"
replace iddistrito="LORETOMAYNASTNTE MANUEL CLAVERO" if iddistrito=="LORETOMAYNASTENIENTE MANUEL CLAVERO"
replace iddistrito="HUANCAVELICAANGARAESHUANCA HUANCA" if iddistrito=="HUANCAVELICAANGARAESHUANCA-HUANCA"
replace iddistrito="PIURASECHURARINCONADA LLICUAR" if iddistrito=="PIURASECHURARINCONADA-LLICUAR"
replace iddistrito="HUANCAVELICAANGARAESHUALLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUALLAY-GRANDE"
replace iddistrito="LIMAYAUYOSAYAUCA" if iddistrito=="LIMAYAUYOSALLAUCA"
replace iddistrito="CALLAOCALLAOCARMEN DE LA LEGUA REYNOSO" if iddistrito=="CALLAOCALLAOCARMEN DE LA LEGUA-REYNOSO"
replace iddistrito="SAN MARTINRIOJAELIAS SOPLIN" if iddistrito=="SAN MARTINRIOJAELIAS SOPLIN VARGAS"
mmerge id iddistrito using `middle_ficha'\ficha_2006_base1_nombres.dta

keep if _merge==3
save `middle_ficha'\ficha_candidatos_2006, replace
******************************
use `middle_ficha'\ficha_2010_base1, clear
egen id=concat(Apellido_paterno Apellido_materno Nombres)
replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)
save `middle_ficha'\ficha_2010_base1_nombres, replace

use `middle_infogob'\candidatos_2010.dta, clear
egen id=concat(pri_apell seg_apell nombres)

replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)

replace iddistrito = subinstr(iddistrito, "ICANAZCA", "ICANASCA", .)

replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
replace iddistrito="AYACUCHOLUCANASHUAC HUAS" if iddistrito=="AYACUCHOLUCANASHUAC-HUAS"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUAYA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUALLA"
replace iddistrito="LORETOMAYNASTNTE MANUEL CLAVERO" if iddistrito=="LORETOMAYNASTENIENTE MANUEL CLAVERO"
replace iddistrito="HUANCAVELICAANGARAESHUANCA HUANCA" if iddistrito=="HUANCAVELICAANGARAESHUANCA-HUANCA"
replace iddistrito="PIURASECHURARINCONADA LLICUAR" if iddistrito=="PIURASECHURARINCONADA-LLICUAR"
replace iddistrito="HUANCAVELICAANGARAESHUALLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUALLAY-GRANDE"
*replace iddistrito="LIMAYAUYOSAYAUCA" if iddistrito=="LIMAYAUYOSALLAUCA"
replace iddistrito="CALLAOCALLAOCARMEN DE LA LEGUA REYNOSO" if iddistrito=="CALLAOCALLAOCARMEN DE LA LEGUA-REYNOSO"
*replace iddistrito="SAN MARTINRIOJAELIAS SOPLIN" if iddistrito=="SAN MARTINRIOJAELIAS SOPLIN VARGAS"
replace iddistrito="ANCASHHUARAZPAMPAS GRANDE" if iddistrito=="ANCASHHUARAZPAMPAS"
replace iddistrito="JUNINCHUPACASAN JUAN DE ISCOS" if iddistrito=="JUNINCHUPACASAN JUAN DE YSCOS"
replace iddistrito="APURIMACAYMARAESIHUAYLLO" if iddistrito=="APURIMACAYMARAESHUAYLLO"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUALLA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUAYA"
replace iddistrito="LIMAHUAROCHIRISAN PEDRO DE LARAOS" if iddistrito=="LIMAHUAROCHIRILARAOS"

mmerge id iddistrito using `middle_ficha'\ficha_2010_base1_nombres.dta
keep if _merge==3
save `middle_ficha'\ficha_candidatos_2010, replace
******************************
use `middle_ficha'\ficha_2014_base1, clear
egen id=concat(Apellido_paterno Apellido_materno Nombres)
replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)
save `middle_ficha'\ficha_2014_base1_nombres, replace

use `middle_infogob'\candidatos_2014.dta, clear
egen id=concat(pri_apell seg_apell nombres)

replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)

replace iddistrito="CALLAOCALLAOCARMEN DE LA LEGUA REYNOSO" if iddistrito=="CALLAOCALLAOCARMEN DE LA LEGUA-REYNOSO"
replace iddistrito="AYACUCHOHUAMANGAANDRES AVELINO CACERES" if iddistrito=="AYACUCHOHUAMANGAANDRES AVELINO CACERES DORREGARAY"
replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
replace iddistrito="AYACUCHOLUCANASHUAC HUAS" if iddistrito=="AYACUCHOLUCANASHUAC-HUAS"
replace iddistrito="HUANCAVELICAANGARAESHUANCA HUANCA" if iddistrito=="HUANCAVELICAANGARAESHUANCA-HUANCA"
replace iddistrito="PIURASECHURARINCONADA LLICUAR" if iddistrito=="PIURASECHURARINCONADA-LLICUAR"
replace iddistrito="HUANCAVELICAANGARAESHUALLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUALLAY-GRANDE"

mmerge id iddistrito using `middle_ficha'\ficha_2014_base1_nombres.dta
keep if _merge==3
save `middle_ficha'\ficha_candidatos_2014, replace
*********************************************************
use `middle_ficha'\ficha_2018_base1, clear
egen id = concat(Apellido_paterno Apellido_materno Nombres)

replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)

replace id = strtrim(id)
replace id = stritrim(id)
replace id = strltrim(id)
replace id = strrtrim(id)
egen iddistrito = concat(region_postulacion provincia_postulacion distrito_postulacion)
replace iddistrito = subinstr(iddistrito, "Ã", "Ñ", .)
replace iddistrito = subinstr(iddistrito, "-", " ", .)
save `middle_ficha'\ficha_2018_base1_nombres, replace

use `middle_infogob'\candidatos_2018.dta, clear
egen id = concat(pri_apell seg_apell nombres)
replace id = strtrim(id)
replace id = stritrim(id)
replace id = strltrim(id)
replace id = strrtrim(id)

replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)
replace iddistrito = subinstr(iddistrito, "ANTONIO RAIMONDI", "ANTONIO RAYMONDI", .)
replace iddistrito = subinstr(iddistrito, "ICANASCA", "ICANAZCA", .)

*replace iddistrito="" if iddistrito==""
replace iddistrito="AMAZONASLUYASAN FRANCISCO DEL YESO" if iddistrito=="AMAZONASLUYASAN FRANCISCO DE YESO"
replace iddistrito="AMAZONASRODRIGUEZ DE MENDOZAMILPUC" if iddistrito=="AMAZONASRODRIGUEZ DE MENDOZAMILPUCC"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUAYA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUALLA"
replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
replace iddistrito="SAN MARTINPICOTACASPISAPA" if iddistrito=="SAN MARTINPICOTACASPIZAPA"
replace iddistrito="PUNOEL COLLAOCAPAZO" if iddistrito=="PUNOEL COLLAOCAPASO"
replace iddistrito="CUSCOLA CONVENCIONQUIMBIRI" if iddistrito=="CUSCOLA CONVENCIONKIMBIRI"
replace iddistrito="AREQUIPAAREQUIPASANTA RITA DE SIGUAS" if iddistrito=="AREQUIPAAREQUIPASANTA RITA DE SIHUAS"
replace iddistrito="APURIMACAYMARAESHUAYLLO" if iddistrito=="APURIMACAYMARAESIHUAYLLO"
replace iddistrito="AYACUCHOLUCANASHUAC HUAS" if iddistrito=="AYACUCHOLUCANASHUAC-HUAS"
replace iddistrito="CALLAOCALLAOCARMEN DE LA LEGUA REYNOSO" if iddistrito=="CALLAOCALLAOCARMEN DE LA LEGUA-REYNOSO"
replace iddistrito="HUANUCOLEONCIO PRADODANIEL ALOMIAS ROBLES" if iddistrito=="HUANUCOLEONCIO PRADODANIEL ALOMIA ROBLES"
replace iddistrito="PIURASECHURARINCONADA LLICUAR" if iddistrito=="PIURASECHURARINCONADA-LLICUAR"
replace iddistrito="HUANCAVELICAANGARAESHUAYLLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUALLAY-GRANDE"
replace iddistrito="HUANCAVELICAANGARAESHUANCA HUANCA" if iddistrito=="HUANCAVELICAANGARAESHUANCA-HUANCA"
replace iddistrito="LIMAYAUYOSAYAUCA" if iddistrito=="LIMAYAUYOSALLAUCA"
replace iddistrito="ANCASHHUARAZPAMPAS" if iddistrito=="ANCASHHUARAZPAMPAS GRANDE"
replace iddistrito="APURIMACGRAUGAMARRA" if iddistrito=="APURIMACGRAUMARISCAL GAMARRA"
replace iddistrito="APURIMACGRAUHUAYLLATI" if iddistrito=="APURIMACGRAUHUAILLATI"
replace iddistrito="TACNATARATAHEROES ALBARRACIN CHUCATAMANI" if iddistrito=="TACNATARATAHEROES ALBARRACIN"
replace iddistrito="CAJAMARCACONTUMAZASANTA CRUZ DE TOLEDO" if iddistrito=="CAJAMARCACONTUMAZASANTA CRUZ DE TOLED"
replace iddistrito="LIMAHUAROCHIRILARAOS" if iddistrito=="LIMAHUAROCHIRISAN PEDRO DE LARAOS"

mmerge id iddistrito using `middle_ficha'\ficha_2018_base1_nombres.dta
keep if _merge==3
save `middle_ficha'\ficha_candidatos_2018, replace
***********************************************
use `middle_ficha'\ficha_2022_base1, clear
egen id = concat(Apellido_paterno Apellido_materno Nombres)
replace id = strtrim(id)
replace id = stritrim(id)
replace id = strltrim(id)
replace id = strrtrim(id)
egen iddistrito = concat(region_postulacion provincia_postulacion distrito_postulacion)
replace iddistrito = subinstr(iddistrito, "Ã", "Ñ", .)
*replace id = subinstr(id, "Ã‘", "Ñ", .)
replace iddistrito = subinstr(iddistrito, "-", " ", .)

replace id = subinstr(id, "Á", "A", .)
replace id = subinstr(id, "É", "E", .)
replace id = subinstr(id, "Í", "I", .)
replace id = subinstr(id, "Ó", "O", .)
replace id = subinstr(id, "Ú", "U", .)
replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)

save `middle_ficha'\ficha_2022_base1_nombres, replace

use `middle_infogob'\candidatos_2022.dta, clear
egen id = concat(pri_apell seg_apell nombres)
replace id = strtrim(id)
replace id = stritrim(id)
replace id = strltrim(id)
replace id = strrtrim(id)

replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)
replace id = subinstr(id, "Á", "A", .)
replace id = subinstr(id, "É", "E", .)
replace id = subinstr(id, "Í", "I", .)
replace id = subinstr(id, "Ó", "O", .)
replace id = subinstr(id, "Ú", "U", .)
replace id = subinstr(id, ".", "", .)
replace id = subinstr(id, "-", "", .)
replace iddistrito = subinstr(iddistrito, "ANTONIO RAIMONDI", "ANTONIO RAYMONDI", .)
replace iddistrito = subinstr(iddistrito, "ICANASCA", "ICANAZCA", .)

*replace iddistrito="" if iddistrito==""
replace iddistrito="AMAZONASLUYASAN FRANCISCO DEL YESO" if iddistrito=="AMAZONASLUYASAN FRANCISCO DE YESO"
replace iddistrito="AMAZONASRODRIGUEZ DE MENDOZAMILPUC" if iddistrito=="AMAZONASRODRIGUEZ DE MENDOZAMILPUCC"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUAYA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUALLA"
replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
replace iddistrito="SAN MARTINPICOTACASPISAPA" if iddistrito=="SAN MARTINPICOTACASPIZAPA"
replace iddistrito="PUNOEL COLLAOCAPAZO" if iddistrito=="PUNOEL COLLAOCAPASO"
replace iddistrito="CUSCOLA CONVENCIONQUIMBIRI" if iddistrito=="CUSCOLA CONVENCIONKIMBIRI"
replace iddistrito="AREQUIPAAREQUIPASANTA RITA DE SIGUAS" if iddistrito=="AREQUIPAAREQUIPASANTA RITA DE SIHUAS"
replace iddistrito="APURIMACAYMARAESHUAYLLO" if iddistrito=="APURIMACAYMARAESIHUAYLLO"
replace iddistrito="AYACUCHOLUCANASHUAC HUAS" if iddistrito=="AYACUCHOLUCANASHUAC-HUAS"
replace iddistrito="CALLAOCALLAOCARMEN DE LA LEGUA REYNOSO" if iddistrito=="CALLAOCALLAOCARMEN DE LA LEGUA-REYNOSO"
replace iddistrito="HUANUCOLEONCIO PRADODANIEL ALOMIAS ROBLES" if iddistrito=="HUANUCOLEONCIO PRADODANIEL ALOMIA ROBLES"
replace iddistrito="PIURASECHURARINCONADA LLICUAR" if iddistrito=="PIURASECHURARINCONADA-LLICUAR"
replace iddistrito="HUANCAVELICAANGARAESHUAYLLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUALLAY-GRANDE"
replace iddistrito="HUANCAVELICAANGARAESHUANCA HUANCA" if iddistrito=="HUANCAVELICAANGARAESHUANCA-HUANCA"
replace iddistrito="LIMAYAUYOSAYAUCA" if iddistrito=="LIMAYAUYOSALLAUCA"
replace iddistrito="ANCASHHUARAZPAMPAS" if iddistrito=="ANCASHHUARAZPAMPAS GRANDE"
replace iddistrito="APURIMACGRAUGAMARRA" if iddistrito=="APURIMACGRAUMARISCAL GAMARRA"
replace iddistrito="APURIMACGRAUHUAYLLATI" if iddistrito=="APURIMACGRAUHUAILLATI"
replace iddistrito="TACNATARATAHEROES ALBARRACIN CHUCATAMANI" if iddistrito=="TACNATARATAHEROES ALBARRACIN"
replace iddistrito="CAJAMARCACONTUMAZASANTA CRUZ DE TOLEDO" if iddistrito=="CAJAMARCACONTUMAZASANTA CRUZ DE TOLED"
replace iddistrito="LIMAHUAROCHIRILARAOS" if iddistrito=="LIMAHUAROCHIRISAN PEDRO DE LARAOS"

mmerge id iddistrito using `middle_ficha'\ficha_2022_base1_nombres.dta
keep if _merge==3
save `middle_ficha'\ficha_candidatos_2022, replace

********************************************************************************
********************************************************************************
use `middle_ficha'\ficha_candidatos_2006, clear
append using `middle_ficha'\ficha_candidatos_2010
append using `middle_ficha'\ficha_candidatos_2014
append using `middle_ficha'\ficha_candidatos_2018
append using `middle_ficha'\ficha_candidatos_2022

gen 	anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022

drop  id1 id2 id3 num region_postulacion  ///
		provincia_postulacion distrito_postulacion cargo Nombres ///
		Apellido_paterno Apellido_materno _merge 
		
rename id id_candidato

keep id_candidato iddistrito distrito_ubigeo secundaria experiencia_laboral ant_penales anho_cargo edad

save `middle_ficha'\fichas_candidatos_append, replace
