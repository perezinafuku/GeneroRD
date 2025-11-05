clear all
cd "C:\Users\Tania Perez Inafuku\Desktop\FICHAS"

use fichas_2014.dta, clear
egen id2=concat(Apellido_paterno Apellido_materno Nombres)
save fichas_2014_id, replace

use "C:\Users\Tania Perez Inafuku\Desktop\INFOGOB\candidatos_2014", clear
egen id=concat(pri_apell seg_apell nombres)
keep if cargo==1
gen n=_n
matchit n id using fichas_2014_id.dta, idu(dni) txtu(id2) override
