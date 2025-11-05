clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local input_pnud "Input\PNUD"
local middle_pnud "Middle\PNUD"

*PNUD: DATA 2003-2017
import excel "`input_pnud'\IDH-y-Componentes-2003-2019.xlsx", sheet("Variables del IDH 2003-2017") clear

*import excel "IDH-Perú.xlsx", sheet("IDH 2003") clear

drop if A==""
drop if F==""

keep in 11/l

rename A distrito_ubigeo

rename F Habitantes2003
rename G Habitantes2007
rename H Habitantes2010
rename I Habitantes2011
rename J Habitantes2012
rename K Habitantes2015
rename L Habitantes2017

rename N IDH2003
rename O IDH2007
rename P IDH2010
rename Q IDH2011
rename R IDH2012
rename S IDH2015
rename T IDH2017

rename V Esperanza_vida2003
rename W Esperanza_vida2007
rename X Esperanza_vida2010
rename Y Esperanza_vida2011
rename Z Esperanza_vida2012
rename AA Esperanza_vida2015
rename AB Esperanza_vida2017

rename AD Poblacion_educ_sec2003
rename AE Poblacion_educ_sec2007
rename AF Poblacion_educ_sec2010
rename AG Poblacion_educ_sec2011
rename AH Poblacion_educ_sec2012
rename AI Poblacion_educ_sec2015
rename AJ Poblacion_educ_sec2017

rename AL Anhos_educacion2003
rename AM Anhos_educacion2007
rename AN Anhos_educacion2010
rename AO Anhos_educacion2011
rename AP Anhos_educacion2012
rename AQ Anhos_educacion2015
rename AR Anhos_educacion2017

rename AT Ingreso_familiar_pc2003
rename AU Ingreso_familiar_pc2007
rename AV Ingreso_familiar_pc2010
rename AW Ingreso_familiar_pc2011
rename AX Ingreso_familiar_pc2012
rename AY Ingreso_familiar_pc2015
rename AZ Ingreso_familiar_pc2017


drop B-E M U AC AK AS BA-BF

destring  Habitantes* IDH* Esperanza_vida* Poblacion_educ_sec* Anhos_educacion* Ingreso_familiar_pc*, replace

compress
reshape long Habitantes IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc, i(distrito_ubigeo) j(anho)

lab var Habitantes "Población: Habitantes"
lab var IDH "Índice de Desarrollo Humano"
lab var Esperanza_vida "Esperanza de vida al nacer"
lab var Poblacion_educ_sec "Población con Educ. secundaria completa"
lab var Anhos_educacion "Años de educación (Poblac. 25 y más)"
lab var Ingreso_familiar_pc "Ingreso familiar per cápita"

save `middle_pnud'\IDH-Peru2003-2017, replace

*PNUD: DATA 2018
import excel "`input_pnud'\IDH-y-Componentes-2003-2019.xlsx", sheet("IDH 2018") clear

keep in 10/l

drop if A==""
drop if F==""
sort A

rename A distrito_ubigeo
rename F Habitantes
rename G IDH 
rename H Esperanza_vida
rename I Poblacion_educ_sec
rename J Anhos_educacion
rename K Ingreso_familiar_pc

keep distrito_ubigeo Habitantes IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc

lab var Habitantes "Población: Habitantes"
lab var IDH "Índice de Desarrollo Humano"
lab var Esperanza_vida "Esperanza de vida al nacer"
lab var Poblacion_educ_sec "Población con Educ. secundaria completa"
lab var Anhos_educacion "Años de educación (Poblac. 25 y más)"
lab var Ingreso_familiar_pc "Ingreso familiar per cápita"

destring Habitantes IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc, replace
gen anho=2018
drop if distrito_ubigeo=="REGIÓN LIMA PROVINCIAS"
save `middle_pnud'\IDH-Peru2018, replace

*PNUD: DATA 2019
import excel "`input_pnud'\IDH-y-Componentes-2003-2019.xlsx", sheet("IDH 2019") clear

keep in 10/l

drop if A==""
drop if F==""
sort A

rename A distrito_ubigeo
rename F Habitantes
rename Q IDH 
rename G Esperanza_vida
rename H Poblacion_educ_sec
rename I Anhos_educacion
rename J Ingreso_familiar_pc

keep distrito_ubigeo Habitantes IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc

lab var Habitantes "Población: Habitantes"
lab var IDH "Índice de Desarrollo Humano"
lab var Esperanza_vida "Esperanza de vida al nacer"
lab var Poblacion_educ_sec "Población con Educ. secundaria completa"
lab var Anhos_educacion "Años de educación (Poblac. 25 y más)"
lab var Ingreso_familiar_pc "Ingreso familiar per cápita"

destring Habitantes IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc, replace
gen anho=2019
drop if distrito_ubigeo=="REGIÓN LIMA PROVINCIAS"
save `middle_pnud'\IDH-Peru2019, replace
