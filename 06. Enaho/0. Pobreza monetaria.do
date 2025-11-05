cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis" 

local input_enaho "Input\Enaho"

local middle_enaho "Middle\Enaho"

********************************************************************************
*************************POBREZA MONETARIA**************************************
********************************************************************************}

*Descomprimir los archivos "Manualmente"
use `input_enaho'\2004\280-Modulo34\280-Modulo34\sumaria-2004, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2004, replace

use `input_enaho'\2005\281-Modulo34\281-Modulo34\sumaria-2005, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2005, replace

use `input_enaho'\2006\282-Modulo34\282-Modulo34\sumaria-2006, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2006, replace

use `input_enaho'\2007\283-Modulo34\283-Modulo34\sumaria-2007, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2007, replace

use `input_enaho'\2008\284-Modulo34\284-Modulo34\sumaria-2008, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2008, replace

use `input_enaho'\2009\285-Modulo34\285-Modulo34\sumaria-2009, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2009, replace

use `input_enaho'\2010\279-Modulo34\279-Modulo34\sumaria-2010, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2010, replace

use `input_enaho'\2011\291-Modulo34\291-Modulo34\sumaria-2011, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2011, replace

use `input_enaho'\2012\324-Modulo34\sumaria-2012, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2012, replace

use `input_enaho'\2013\404-Modulo34\404-Modulo34\sumaria-2013, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2013, replace

use `input_enaho'\2014\440-Modulo34\440-Modulo34\sumaria-2014, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2014, replace

use `input_enaho'\2015\498-Modulo34\sumaria-2015, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2015, replace

use `input_enaho'\2016\546-Modulo34\546-Modulo34\sumaria-2016, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2016, replace

use `input_enaho'\2017\603-Modulo34\603-Modulo34\sumaria-2017, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2017, replace

use `input_enaho'\2018\634-Modulo34\634-Modulo34\sumaria-2018, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2018, replace

use `input_enaho'\2019\687-Modulo34\687-Modulo34\sumaria-2019, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2019, replace

use `input_enaho'\2020\737-Modulo34\737-Modulo34\sumaria-2020, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2020, replace

use `input_enaho'\2021\759-Modulo34\759-Modulo34\sumaria-2021, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2021, replace

use `input_enaho'\2022\784-Modulo34\784-Modulo34\sumaria-2022, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2022, replace

use `input_enaho'\2023\906-Modulo34\906-Modulo34\sumaria-2023, clear
destring ubigeo, gen(ubigeo2)
gen id_pov=substr(ubigeo,1,4)
save `middle_enaho'\sumaria_2023, replace

foreach num of numlist 2004(1)2023 {
use `middle_enaho'\sumaria_`num', clear

*VARIABLES GEOGRAFICAS (departamento, urbano/rural, costa/sierra/selva)
**************************
*Departamento
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
label variable dpto "dpto"
label define dpto 1 "Amazonas"
label define dpto 2 "Ancash", add
label define dpto 3 "Apurimac", add
label define dpto 4 "Arequipa", add
label define dpto 5 "Ayacucho", add
label define dpto 6 "Cajamarca", add
label define dpto 7 "Callao", add
label define dpto 8 "Cusco", add
label define dpto 9 "Huancavelica", add
label define dpto 10 "Huanuco", add
label define dpto 11 "Ica", add
label define dpto 12 "Junin", add
label define dpto 13 "La_Libertad", add
label define dpto 14 "Lambayeque", add
label define dpto 15 "Lima", add
label define dpto 16 "Loreto", add
label define dpto 17 "Madre_de_Dios", add
label define dpto 18 "Moquegua", add
label define dpto 19 "Pasco", add
label define dpto 20 "Piura", add
label define dpto 21 "Puno", add
label define dpto 22 "San_Martin", add
label define dpto 23 "Tacna", add
label define dpto 24 "Tumbes", add
label define dpto 25 "Ucayali", add
label values dpto dpto
label var dpto "Departamento"

*Generar la variable urbano/rural (usar la variable estrato)
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab var area "Area de residencia"
lab def area 1 "Urbano" 2 "Rural"
lab val area area

*Generar la variable region regiones naturales (usar la variable dominio)
gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7
lab var regnat "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat


*Pobreza Monetaria Total
*Estimamos el gasto mensual promedio de los hogares en terminos per capita
gen gpcm=gashog2d/(mieperho*12)

*Calculamos el factor de ponderacion a nivel de la poblacion
gen facpob=factor*mieperho

*Contrastamos gpcm con la linea de pobreza alimentaria (linpe) y pobreza total (linea)
gen          pobre3=1 if gpcm <  linpe
replace      pobre3=2 if gpcm >= linpe & gpcm < linea
replace      pobre3=3 if gpcm >= linea

*Etiquetamos los valores de la variable 
label define pobre3 1 "pobre_extremo" 2 "pobre_no_extremo" 3 "no_pobre"
label value  pobre3 pobre3
label var    pobre3 "Pobreza Monetaria"
gen          pobre_2=1 if gpcm <  linea
replace      pobre_2=0 if gpcm >= linea

*Etiquetamos los valores de la variable 
label define pobre_2 1 "pobre" 0 "no_pobre"
label value  pobre_2 pobre_2
label var    pobre_2 "Pobreza Monetaria Total"

*Establecemos las caracteristicas de la encuesta usando las variable 
*factor de expansion, conglomerado y estrato
svyset [pweight=facpob], psu(conglome) strata(estrato)


*INCIDENCIA, BRECHA Y SEVERIDAD DE LA POBREZA MONETARIA
*FGT(0): INCIDENCIA; FGT(1): BRECHA & FGT(2): SEVERIDAD
*FGT(0) o (P0): Incidencia de la pobreza, que representa la proporción de pobres
*o de pobres extremos como porcentaje del total de la población.
*FGT(1) o (P1): Brecha de la pobreza, que mide la insuficiencia promedio del consumo
*de los pobres respecto de la línea de pobreza, tomando en cuenta la proporción de la
*población pobre en la población total.
*FGT(2) o (P2): Severidad de la pobreza, que mide la desigualdad entre los pobres.

*Se puede usar el comando povdeco, sepov o svy
povdeco gpcm [w=facpob], varpl(linea)
sepov   gpcm [w=facpob], p(linea)

*diferencias en el formato del output usando "prop" vs. "mean"
svy: prop pobre_2
svy: mean pobre_2
svy: prop pobre_2, over(dpto)

collapse (mean) pobre_2 [pweight=facpob], by(ubigeo2)

egen mean_pobre_2=mean(pobre_2)

gen distrito_pobre=(pobre_2>=mean_pobre_2)
label define distrito_pobre 1 "Distrito pobre" 0 "Distrito no_pobre"
label value  distrito_pobre distrito_pobre
label var    distrito_pobre "Distrito Pobre según Pobreza Monetaria Total (mayor a promedio)"

replace pobre_2=pobre_2*100
label var    pobre_2 "Pobreza Monetaria Total (%)"

replace mean_pobre_2=mean_pobre_2*100

gen anho = `num'

save `middle_enaho'\sumaria_`num'_pobreza, replace
}

use `middle_enaho'\sumaria_2004_pobreza, clear
foreach num of numlist 2005(1)2023 {
                append using `middle_enaho'\sumaria_`num'_pobreza
				
        }
save `middle_enaho'\sumaria_pobreza, replace

use `middle_enaho'\sumaria_pobreza, clear

reshape wide pobre_2 mean_pobre_2 distrito_pobre, i(ubigeo2) j(anho)

gen pobreza_mean1 = (pobre_22004 + pobre_22005 + pobre_22006) / 3 //2002
gen pobreza_mean2 = (pobre_22007 + pobre_22008 + pobre_22009 + pobre_22010) / 4 //2006
gen pobreza_mean3 = (pobre_22011 + pobre_22012 + pobre_22013 + pobre_22014) / 4 //2010
gen pobreza_mean4 = (pobre_22015 + pobre_22016 + pobre_22017 + pobre_22018) / 4 //2014
gen pobreza_mean5 = (pobre_22019 + pobre_22020 + pobre_22021 + pobre_22022) / 4 //2018

reshape long pobreza_mean, i(ubigeo2) j(anho_cargo)

gen 	pobre_21=. if anho_cargo==1
replace pobre_21=pobre_22007 if anho_cargo==2
replace pobre_21=pobre_22011 if anho_cargo==3
replace pobre_21=pobre_22015 if anho_cargo==4
replace pobre_21=pobre_22019 if anho_cargo==5

gen 	pobre_22=pobre_22004 if anho_cargo==1
replace pobre_22=pobre_22008 if anho_cargo==2
replace pobre_22=pobre_22012 if anho_cargo==3
replace pobre_22=pobre_22016 if anho_cargo==4
replace pobre_22=pobre_22020 if anho_cargo==5

gen 	pobre_23=pobre_22005 if anho_cargo==1
replace pobre_23=pobre_22009 if anho_cargo==2
replace pobre_23=pobre_22013 if anho_cargo==3
replace pobre_23=pobre_22017 if anho_cargo==4
replace pobre_23=pobre_22021 if anho_cargo==5

gen 	pobre_24=pobre_22006 if anho_cargo==1
replace pobre_24=pobre_22010 if anho_cargo==2
replace pobre_24=pobre_22014 if anho_cargo==3
replace pobre_24=pobre_22018 if anho_cargo==4
replace pobre_24=pobre_22022 if anho_cargo==5


gen 	distrito_pobre1=. if anho_cargo==1
replace distrito_pobre1=distrito_pobre2007 if anho_cargo==2
replace distrito_pobre1=distrito_pobre2011 if anho_cargo==3
replace distrito_pobre1=distrito_pobre2015 if anho_cargo==4
replace distrito_pobre1=distrito_pobre2019 if anho_cargo==5

gen 	distrito_pobre2=distrito_pobre2004 if anho_cargo==1
replace distrito_pobre2=distrito_pobre2008 if anho_cargo==2
replace distrito_pobre2=distrito_pobre2012 if anho_cargo==3
replace distrito_pobre2=distrito_pobre2016 if anho_cargo==4
replace distrito_pobre2=distrito_pobre2020 if anho_cargo==5

gen 	distrito_pobre3=distrito_pobre2005 if anho_cargo==1
replace distrito_pobre3=distrito_pobre2009 if anho_cargo==2
replace distrito_pobre3=distrito_pobre2013 if anho_cargo==3
replace distrito_pobre3=distrito_pobre2017 if anho_cargo==4
replace distrito_pobre3=distrito_pobre2021 if anho_cargo==5

gen 	distrito_pobre4=distrito_pobre2006 if anho_cargo==1
replace distrito_pobre4=distrito_pobre2010 if anho_cargo==2
replace distrito_pobre4=distrito_pobre2014 if anho_cargo==3
replace distrito_pobre4=distrito_pobre2018 if anho_cargo==4
replace distrito_pobre4=distrito_pobre2022 if anho_cargo==5

lab var pobreza_mean "Promedio de pobreza (para cada distrito durante 4 años)"
lab var pobre_21 "pobre_2 del 1er año de gestión: 2003, 2007, 2011, 2015"
lab var pobre_22 "pobre_2 del 2do año de gestión: 2004, 2008, 2012, 2016"
lab var pobre_23 "pobre_2 del 3er año de gestión: 2005, 2009, 2013, 2017"
lab var pobre_24 "pobre_2 del 4to año de gestión: 2006, 2010, 2014, 2018"

lab var distrito_pobre1 "distrito pobre en 1er año de gestión: 2003, 2007, 2011, 2015"
lab var distrito_pobre2 "distrito pobre en 2do año de gestión: 2004, 2008, 2012, 2016"
lab var distrito_pobre3 "distrito pobre en 3er año de gestión: 2005, 2009, 2013, 2017"
lab var distrito_pobre4 "distrito pobre en 4to año de gestión: 2006, 2010, 2014, 2018"


egen distrito_pobre_sum=rowtotal(distrito_pobre1 distrito_pobre2 distrito_pobre3 distrito_pobre4)
gen distrito_pobre=(distrito_pobre_sum>0)
replace distrito_pobre=. if distrito_pobre_sum==.

drop pobre_22004-distrito_pobre2023 distrito_pobre1-distrito_pobre_sum

label value  distrito_pobre distrito_pobre
label var    distrito_pobre "Provincia Pobre según Pobreza Monetaria Total (mayor a promedio)"

*destring id_pov, replace
rename ubigeo2 id

save `middle_enaho'\sumaria_pobreza, replace
