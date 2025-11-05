clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Ubigeos"
local middle_infogob "Middle\Ubigeos"

import delimited "`input_infogob'\Excel\ubigeo_nvo__x_id_diferente.csv"

keep inei reniec department province district
drop if reniec==""

rename reniec id_reniec
rename inei id
save `middle_infogob'\ubigeo_2024, replace
