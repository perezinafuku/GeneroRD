clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local middle_infogob "Middle\Infogob"

use `middle_infogob'\ERM2018_Candidatos_Distrital, clear
rename Region Región
save "`middle_infogob'\ERM2018_Candidatos_Distrital.dta", replace

forvalues i = 2002(4)2022 {
use `middle_infogob'\ERM`i'_Candidatos_Distrital, clear

/*
Región          str13   %13s                  Región
Provincia       str25   %25s                  Provincia
Distrito        str36   %36s                  Distrito
OrganizaciónP~a str81   %81s                  Organización Política
TipoOrganizac~a str32   %32s                  Tipo Organización Política
Cargo           str17   %17s                  Cargo
N               byte    %10.0gc               N°
Primerapellido  str23   %23s                  Primer apellido
Segundoapellido str34   %34s                  Segundo apellido
Prenombres      str36   %36s                  Prenombres
Sexo            str9    %9s                   Sexo
Joven           str5    %9s                   Joven
Nativo          byte    %10.0g                Nativo
*/

egen iddistrito=concat(Región Provincia Distrito) // 1647 distritos
lab var iddistrito "id distrito"
*gen n=_n
*collapse (count) n, by(iddistrito) 

rename Primerapellido pri_apell
rename Segundoapellido seg_apell
rename Prenombres nombres
rename OrganizaciónPolítica partido
rename TipoOrganizaciónPolítica tipo_partido

egen idpartido=concat(iddistrito partido tipo_partido)
*gen n=_n
*collapse (count) n, by(idpartido) // 11527

egen idpersona=concat(iddistrito pri_apell seg_apell nombres)
*gen n=_n
*collapse (count) n, by(idpersona) // 73418
*isid idpersona

gen 	cargo=0
replace cargo=1 if Cargo=="ALCALDE DISTRITAL"
label 	define cargo 1 "ALCALDE DISTRITAL" 0 "REGIDOR DISTRITAL"
label 	value cargo cargo

gen 	mujer=0
replace mujer=1 if Sexo=="Femenino" | Sexo=="FEMENINO"
label define mujer 1 "Mujer" 0 "Hombre"
label value mujer mujer

gen 	joven=0
replace joven=1 if Joven=="Joven" | Joven=="SI"

drop Nativo //no tiene obs.

drop Cargo Sexo Joven 

gen anho=`i'
save `middle_infogob'\candidatos_`i', replace
}
