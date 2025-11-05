clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local middle_infogob "Middle\Infogob"

forvalues i = 2002(4)2022 {
use `middle_infogob'\ERM`i'_Padron_Distrital, clear
/*
Región          str13   %13s                  Región
Provincia       str25   %25s                  Provincia
Distrito        str36   %36s                  Distrito
Cargoelecto     str17   %17s                  Cargo electo
Primerapellido  str17   %17s                  Primer apellido
Segundoapellido str24   %24s                  Segundo apellido
Prenombres      str31   %31s                  Prenombres
OrganizaciónP~a str81   %81s                  Organización Política
TipoOrganizac~a str32   %32s                  Tipo Organización Política
Sexo            str9    %9s                   Sexo
Joven           str5    %9s                   Joven
Nativo          byte    %10.0g                Nativo
Votosobtenido~c long    %10.0gc               Votos obtenidos por la organización política
Votosobtenido~z double  %6.4f                 % Votos obtenidos por la organización política
*/

egen iddistrito=concat(Región Provincia Distrito) // 1618 distritos
lab var iddistrito "id distrito"

drop if L==.

compress

gen anho=`i'
save `middle_infogob'\padron_`i', replace
}

use `middle_infogob'\padron_2002, clear
append using `middle_infogob'\padron_2006
append using `middle_infogob'\padron_2010
append using `middle_infogob'\padron_2014
append using `middle_infogob'\padron_2018
append using `middle_infogob'\padron_2022
gen 	anho_cargo=1 if anho==2002
replace anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022
drop anho
save `middle_infogob'\padron_append, replace
