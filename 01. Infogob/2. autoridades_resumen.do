clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local middle_infogob "Middle\Infogob"

forvalues i = 2018(4)2022 {
use `middle_infogob'\ERM`i'_Autoridades_Distrital, clear

rename Votosorganizaciónpolítica Votosobtenidosporlaorganizac
rename N Votosobtenidosporlaorganiz

save "`middle_infogob'\ERM`i'_Autoridades_Distrital.dta", replace
}


forvalues i = 2002(4)2022 {
use `middle_infogob'\ERM`i'_Autoridades_Distrital, clear
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
*gen n=_n
*collapse (count) n, by(iddistrito)

rename Primerapellido pri_apell
rename Segundoapellido seg_apell
rename Prenombres nombres
rename OrganizaciónPolítica partido
rename TipoOrganizaciónPolítica tipo_partido

egen idpartido=concat(iddistrito partido tipo_partido)
*gen n=_n
*collapse (count) n, by(idpartido) // 3408

egen idpersona=concat(iddistrito pri_apell seg_apell nombres)
*gen n=_n
*collapse (count) n, by(idpersona) // 10248
*isid idpersona

gen 	cargo=0
replace cargo=1 if Cargoelecto=="ALCALDE DISTRITAL"
label 	define cargo 1 "ALCALDE DISTRITAL" 0 "REGIDOR DISTRITAL"
label 	value cargo cargo

gen 	mujer=0
replace mujer=1 if Sexo=="Femenino" | Sexo=="FEMENINO"
label define mujer 1 "Mujer" 0 "Hombre"
label value mujer mujer

gen 	joven=0
replace joven=1 if Joven=="Joven" | Joven=="SI"

drop Nativo //no tiene obs.

gen 	num_votos=Votosobtenidosporlaorganizac
lab var num_votos "Votos obtenidos por la organización política"

gen 	ptje_votos_ganador=round(Votosobtenidosporlaorganiz*100, .01)
lab var ptje_votos_ganador "% Votos obtenidos por la organización política"

gen actual=1 //todos de esta base son autoridades actuales, para hacer el merge
lab var actual "Autoridades actuales, para hacer el merge"
drop Región Provincia  Cargoelecto Sexo Joven Votosobtenidosporlaorganizac Votosobtenidosporlaorganiz

gen anho=`i'
save `middle_infogob'\autoridades_`i', replace
}
