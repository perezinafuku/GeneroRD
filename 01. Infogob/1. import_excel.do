clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local middle_infogob "Middle\Infogob"

forvalues i =2002(4)2022 {
import excel "`input_infogob'\\`i'\\ERM`i'_Autoridades_Distrital.xlsx", sheet("Sheet 1") firstrow clear
save "`middle_infogob'\ERM`i'_Autoridades_Distrital.dta", replace

import excel "`input_infogob'\\`i'\\ERM`i'_Candidatos_Distrital.xlsx", sheet("Sheet 1") firstrow clear
save "`middle_infogob'\ERM`i'_Candidatos_Distrital.dta", replace

import excel "`input_infogob'\\`i'\\ERM`i'_Padron_Distrital.xlsx", sheet("Sheet 1") firstrow clear
save "`middle_infogob'\ERM`i'_Padron_Distrital.dta", replace

import excel "`input_infogob'\\`i'\\ERM`i'_Resultados_Distrital.xlsx", sheet("Sheet 1") firstrow clear
save "`middle_infogob'\ERM`i'_Resultados_Distrital.dta", replace
}
