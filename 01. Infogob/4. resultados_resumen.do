clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local middle_infogob "Middle\Infogob"

use `middle_infogob'\ERM2018_Resultados_Distrital, clear
rename Region Región
save "`middle_infogob'\ERM2018_Resultados_Distrital.dta", replace

use `middle_infogob'\ERM2022_Resultados_Distrital, clear
drop Participación
rename F Participación
rename P K
drop Q R
save "`middle_infogob'\ERM2022_Resultados_Distrital.dta", replace

forvalues i = 2002(4)2022 {
use `middle_infogob'\ERM`i'_Resultados_Distrital, clear
/*
Región          str13   %13s                  Región
Provincia       str25   %25s                  Provincia
Distrito        str36   %36s                  Distrito
Electores       long    %10.0gc               Electores
Participación   double  %6.4f                 % Participación
Votosemitidos   long    %10.0gc               Votos emitidos
Votosválidos    long    %10.0gc               Votos válidos
OrganizaciónP~a str81   %81s                  Organización Política
TipoOrganizac~a str32   %32s                  Tipo Organización Política
Votos           long    %10.0gc               Votos
K               double  %6.4f                 % Votos
*/
egen iddistrito=concat(Región Provincia Distrito) // 1647 distritos
*gen n=_n
*collapse (count) n, by(iddistrito) //1647

rename OrganizaciónPolítica partido
rename TipoOrganizaciónPolítica tipo_partido
rename Electores electores
rename Participación participacion
rename Votosemitidos votos_emitidos
rename Votosválidos votos_validos
rename Votos num_votos
lab var num_votos "Votos obtenidos por la organización política"

egen idpartido=concat(iddistrito partido tipo_partido)
*gen n=_n
*collapse (count) n, by(idpartido) // 14830

gen 	votos_blanco=0
replace votos_blanco=1 if partido=="VOTOS EN BLANCO"

gen 	votos_nulos=0
replace votos_nulos=1 if partido=="VOTOS NULOS"

gen ptje_votos=round(K*100, .01)
drop K

gen anho=`i'
save `middle_infogob'\resultados_`i', replace
}
