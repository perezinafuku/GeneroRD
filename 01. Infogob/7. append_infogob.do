clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_infogob "Input\Infogob"
local middle_infogob "Middle\Infogob"

use `middle_infogob'\hombremujer5_2002
append using `middle_infogob'\hombremujer5_2006
append using `middle_infogob'\hombremujer5_2010
append using `middle_infogob'\hombremujer5_2014
append using `middle_infogob'\hombremujer5_2018
append using `middle_infogob'\hombremujer5_2022
save `middle_infogob'\hombremujer5_append, replace

use `middle_infogob'\hombremujer7_2002
append using `middle_infogob'\hombremujer7_2006
append using `middle_infogob'\hombremujer7_2010
append using `middle_infogob'\hombremujer7_2014
append using `middle_infogob'\hombremujer7_2018
append using `middle_infogob'\hombremujer7_2022
save `middle_infogob'\hombremujer7_append, replace

use `middle_infogob'\hombremujer10_2002
append using `middle_infogob'\hombremujer10_2006
append using `middle_infogob'\hombremujer10_2010
append using `middle_infogob'\hombremujer10_2014
append using `middle_infogob'\hombremujer10_2018
append using `middle_infogob'\hombremujer10_2022
save `middle_infogob'\hombremujer10_append, replace
