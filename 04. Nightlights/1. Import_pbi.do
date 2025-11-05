clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_luces "Input\Nightlights"
local middle_luces "Middle\Nightlights"

import excel "`input_luces'\Excel_Estimación-del-PBI-a-nivel-subnacional.xlsx", sheet("PIB_Dist") firstrow

foreach v of varlist F-AE {
   local x : variable label `v'
   rename `v' pbi`x'
}

egen iddistrito=concat(Departamento Provincia Distrito)
lab var iddistrito "id distrito"

save `middle_luces'\pbi1993_2018, replace
