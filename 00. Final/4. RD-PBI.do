clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis"

use Output\base_total_1, clear

*Indicator for midterm elections
*gen midterm = anho_next == 2006 | anho_next == 2010 | anho_next == 2014

/*
Generate StateXYear FEs
tostring anho, gen(anho_string)
gen distritianho = iddistrito + anho_string
encode distritianho, gen(distritianho_fes)
xtset distritianho_fes
*/

gen absolute_margin=mv_max

replace mv_max=-mv_max if mujer==0

keep if actual==1
*drop if mv_max==0

* Discontinuity [jump] in winning chances when the victory margin is small.
gen actual_mujer=0
replace actual_mujer=1 if mujer==1 & actual==1

rdplot actual_mujer mv_max if inrange(mv_max,-10,10), ///
p(4) ci(95)  graph_options(xlabel(-10(2.5)10) ylabel(0(0.1)1))
graph export "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\BASE TOTAL\Gráficos\RDplot-jump.png", replace

cmogram actual_mujer mv_max if mv_max>-10 & mv_max<10, ///
cut(0) scatter line(0) qfitci ///
saving("C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\BASE TOTAL\Gráficos\RD-jump.png")

****
gen log_vivienda_real=log(Girado_vivienda_real)
gen log_proteccion_real=log(Girado_proteccion_real)
gen log_educacion_real=log(Girado_educacion_real)
gen log_industria_real=log(Girado_industria_real)
gen log_salud_real=log(Girado_salud_real)
gen log_transporte_real=log(Girado_transporte_real)
gen log_resto_real=log(Girado_resto_real)
gen log_total=log(Girado_real)

*GASTOS PERCÁPITA
gen Girado_vivienda_real_pc=Girado_vivienda_real/Total
gen Girado_proteccion_real_pc=Girado_proteccion/Total
gen Girado_educacion_real_pc=Girado_educacion_real/Total
gen Girado_industria_real_pc=Girado_industria_real/Total
gen Girado_salud_real_pc=Girado_salud_real/Total
gen Girado_transporte_real_pc=Girado_transporte_real/Total
gen Girado_resto_real_pc=Girado_resto_real/Total
gen Girado_real_pc=Girado_real/Total
*
gen log_vivienda_pc=log(Girado_vivienda_real_pc)
gen log_proteccion_pc=log(Girado_proteccion_real_pc)
gen log_educacion_pc=log(Girado_educacion_real_pc)
gen log_industria_pc=log(Girado_industria_real_pc)
gen log_salud_pc=log(Girado_salud_real_pc)
gen log_transporte_pc=log(Girado_transporte_real_pc)
gen log_resto_pc=log(Girado_resto_real_pc)
gen log_total_pc=log(Girado_real_pc)

*PORCENTAJE DE EJECUCION DE PRESUPUESTO
gen Ptje_vivienda_real= Girado_vivienda/PIM_vivienda
gen Ptje_proteccion_real=Girado_proteccion/PIM_proteccion
gen Ptje_educacion_real=Girado_educacion/PIM_educacion
gen Ptje_industria_real=Girado_industria/PIM_industria
gen Ptje_salud_real=Girado_salud/PIM_salud
gen Ptje_transporte_real=Girado_transporte/PIM_transporte
gen Ptje_resto_real= Resto_Girado/Resto_PIM
gen Ptje_real=Girado/PIM
*PORCENTAJE ASIGNADO A CADA ITEM
gen Ptje_vivienda= Girado_vivienda/Girado
gen Ptje_proteccion=Girado_proteccion/Girado
gen Ptje_educacion=Girado_educacion/Girado
gen Ptje_industria=Girado_industria/Girado
gen Ptje_salud=Girado_salud/Girado
gen Ptje_transporte=Girado_transporte/Girado
gen Ptje_resto= Resto_Girado/Girado
*
gen mv_max2=mv_max^2
gen mv_max3=mv_max^3
gen mv_max4=mv_max^4

gen mvXmujer=mv_max*mujer
gen mvXmujer2=mv_max2*mujer
gen mvXmujer3=mv_max3*mujer
gen mvXmujer4=mv_max4*mujer

********************************************************************************
***************************  REGRESIONES   *************************************
********************************************************************************
/*
local bws 2.5 5 10 15 20 25
foreach bandwidth in `bws'{
	reg 	Girado_real_pc mujer mv_max mv_max2 mv_max3 mv_max4 mvXmujer mvXmujer2 ///
			mvXmujer3 mvXmujer4 if absolute_margin < `bandwidth', robust
}
*/
reg pbi_mean 	mujer mv_max mv_max2 mv_max3 mv_max4  ///
			mvXmujer mvXmujer2 mvXmujer3 mvXmujer4 ///
			edad secundaria experiencia_laboral ant_penales  ///
			if inrange(mv_max,-15,15), robust	
foreach name in Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
				Girado_industria_real_pc Girado_educacion_real_pc ///
				Girado_proteccion_real_pc Girado_vivienda_real_pc ///
				Girado_resto_real_pc  {
reg `name' 	mujer mv_max mv_max2 mv_max3 mv_max4  ///
			mvXmujer mvXmujer2 mvXmujer3 mvXmujer4 ///
			edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje, robust
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
		Girado_industria_real_pc Girado_educacion_real_pc ///
		Girado_proteccion_real_pc Girado_vivienda_real_pc ///
		Girado_resto_real_pc, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer, se mtitle noobs
********************************************************************************
foreach name in Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
				Girado_industria_real_pc Girado_educacion_real_pc ///
				Girado_proteccion_real_pc Girado_vivienda_real_pc ///
				Girado_resto_real_pc  {
rd `name' 	mv_max, z0(0) ///
			cov(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje)
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
		Girado_industria_real_pc Girado_educacion_real_pc ///
		Girado_proteccion_real_pc Girado_vivienda_real_pc ///
		Girado_resto_real_pc, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer lwald, se mtitle noobs
********************************************************************************
foreach name in Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
				Girado_industria_real_pc Girado_educacion_real_pc ///
				Girado_proteccion_real_pc Girado_vivienda_real_pc ///
				Girado_resto_real_pc  {
rdrobust `name' mv_max, c(0) p(4) ///
				covs(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje)
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
		Girado_industria_real_pc Girado_educacion_real_pc ///
		Girado_proteccion_real_pc Girado_vivienda_real_pc ///
		Girado_resto_real_pc, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer lwald RD_Estimate, replace b(%10.3f) se sfmt(%10.2f %10.0f %10.3f)	///	
		star(* 0.10 ** 0.05 *** 0.01) noobs nonotes width(\hsize) nonumb
********************************************************************************
********************************************************************************
********************************************************************************
foreach name in Ptje_vivienda_real Ptje_proteccion_real Ptje_educacion_real ///
				Ptje_industria_real Ptje_salud_real Ptje_transporte_real ///
				Ptje_resto_real Ptje_real  {
reg `name' 	mujer mv_max mv_max2 mv_max3 mv_max4  ///
			mvXmujer mvXmujer2 mvXmujer3 mvXmujer4 ///
			edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje ///
			if inrange(mv_max,-15,15), robust
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Ptje_vivienda_real Ptje_proteccion_real Ptje_educacion_real ///
				Ptje_industria_real Ptje_salud_real Ptje_transporte_real ///
				Ptje_resto_real Ptje_real, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer, se mtitle noobs
********************************************************************************
foreach name in Ptje_vivienda_real Ptje_proteccion_real Ptje_educacion_real ///
				Ptje_industria_real Ptje_salud_real Ptje_transporte_real ///
				Ptje_resto_real Ptje_real {
rd `name' 	mv_max if inrange(mv_max,-15,15), z0(0) ///
			cov(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje)
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Ptje_vivienda_real Ptje_proteccion_real Ptje_educacion_real ///
				Ptje_industria_real Ptje_salud_real Ptje_transporte_real ///
				Ptje_resto_real Ptje_real, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer lwald, se mtitle noobs
********************************************************************************
foreach name in Ptje_vivienda_real Ptje_proteccion_real Ptje_educacion_real ///
				Ptje_industria_real Ptje_salud_real Ptje_transporte_real ///
				Ptje_resto_real Ptje_real {
rdrobust `name' mv_max if inrange(mv_max,-15,15), c(0) p(4) ///
				covs(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje)
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Ptje_vivienda_real Ptje_proteccion_real Ptje_educacion_real ///
				Ptje_industria_real Ptje_salud_real Ptje_transporte_real ///
				Ptje_resto_real Ptje_real, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer lwald RD_Estimate, replace b(%10.3f) se sfmt(%10.2f %10.0f %10.3f)	///							///
		star(* 0.10 ** 0.05 *** 0.01) noobs nonotes width(\hsize) nonumb
********************************************************************************
********************************************************************************
********************************************************************************
foreach name in Ptje_vivienda Ptje_proteccion Ptje_educacion Ptje_industria ///
				Ptje_salud Ptje_transporte Ptje_resto {
reg `name' 	mujer mv_max mv_max2 mv_max3 mv_max4  ///
			mvXmujer mvXmujer2 mvXmujer3 mvXmujer4 ///
			edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje ///
			if inrange(mv_max,-15,15), robust
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Ptje_vivienda Ptje_proteccion Ptje_educacion Ptje_industria ///
				Ptje_salud Ptje_transporte Ptje_resto, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer, se mtitle noobs
********************************************************************************
foreach name in Ptje_vivienda Ptje_proteccion Ptje_educacion Ptje_industria ///
				Ptje_salud Ptje_transporte Ptje_resto {
rd `name' 	mv_max if inrange(mv_max,-15,15), z0(0) ///
			cov(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje)
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Ptje_vivienda Ptje_proteccion Ptje_educacion Ptje_industria ///
				Ptje_salud Ptje_transporte Ptje_resto, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer lwald, se mtitle noobs
********************************************************************************
foreach name in Ptje_vivienda Ptje_proteccion Ptje_educacion Ptje_industria ///
				Ptje_salud Ptje_transporte Ptje_resto {
rdrobust `name' mv_max if inrange(mv_max,-15,15), c(0) p(4) ///
				covs(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje)
sum `name' if e(sample)
estadd scalar meany = r(mean)
est store `name'
}
esttab Ptje_vivienda Ptje_proteccion Ptje_educacion Ptje_industria ///
				Ptje_salud Ptje_transporte Ptje_resto, se nostar
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'
}
esttab mujer lwald RD_Estimate, replace b(%10.3f) se sfmt(%10.2f %10.0f %10.3f)	///							///
		star(* 0.10 ** 0.05 *** 0.01) noobs nonotes width(\hsize) nonumb
		
********************************************************************************
*****************************  GRÁFICOS   **************************************
********************************************************************************

foreach name in Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
				Girado_industria_real_pc Girado_educacion_real_pc ///
				Girado_proteccion_real_pc Girado_vivienda_real_pc ///
				Girado_resto_real_pc  {
rdplot `name' Girado_salud_real_pc mv_max if inrange(mv_max,-15,15), c(0) p(4) ///
				covs(edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje) ///
				graph_options(xlabel(-15(2.5)15))
graph export "Gráficos\RDplot-`name'.png", replace
}
/*
tw ///
(lpolyci Girado_educacion_real_pc mv_max if inrange(mv_max,-15,0), deg(4) fcolor(none)) ///
(lpolyci Girado_educacion_real_pc mv_max if inrange(mv_max,0,15), deg(4) fcolor(none)), xline(0) xlabel(-15(2.5)15) xtitle("MV-Hombre vs. Mujer") legend(off)
graph export "Gráficos\RDpolyci-educacion_real.png", replace
*/

*Margen extensivo e intensivo (vote share)

****
esttab 	Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
		Girado_educacion_real_pc using "TexTablas\RD_OLS-TotalMef1.tex",	///
		replace b(%10.3f) se scalars("meany Mean"  			///
		"N Observations" "r2 R squared") ///
		sfmt(%10.2f %10.0f %10.3f) 										///
		star(* 0.10 ** 0.05 *** 0.01) noobs keep(mujer) ///
		nonotes width(\hsize) nonumb mtitle("Total" "SyS" "T" "EyC" )	
/*
cmogram prctje_proteccion mv_max if mv_max>-10 & mv_max<10, ///
cut(0) scatter line(0) qfitci ///
saving("C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\BASE TOTAL\Gráficos\RD-proteccion.png")
*/
clear all
cd "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\BASE TOTAL"

use base_total_1, clear

*Indicator for midterm elections
*gen midterm = anho_next == 2006 | anho_next == 2010 | anho_next == 2014

/*
Generate StateXYear FEs
tostring anho, gen(anho_string)
gen distritianho = iddistrito + anho_string
encode distritianho, gen(distritianho_fes)
xtset distritianho_fes
*/

gen absolute_margin=mv_max

replace mv_max=-mv_max if mujer==0

keep if actual==1

gen log_vivienda_real=log(Girado_vivienda_real)
gen log_proteccion_real=log(Girado_proteccion_real)
gen log_educacion_real=log(Girado_educacion_real)
gen log_industria_real=log(Girado_industria_real)
gen log_salud_real=log(Girado_salud_real)
gen log_transporte_real=log(Girado_transporte_real)
gen log_resto_real=log(Girado_resto_real)
gen log_total=log(Girado_real)

*GASTOS PERCÁPITA
gen Girado_vivienda_real_pc=Girado_vivienda_real/Total
gen Girado_proteccion_real_pc=Girado_proteccion/Total
gen Girado_educacion_real_pc=Girado_educacion_real/Total
gen Girado_industria_real_pc=Girado_industria_real/Total
gen Girado_salud_real_pc=Girado_salud_real/Total
gen Girado_transporte_real_pc=Girado_transporte_real/Total
gen Girado_resto_real_pc=Girado_resto_real/Total
gen Girado_real_pc=Girado_real/Total
*
gen log_vivienda_pc=log(Girado_vivienda_real_pc)
gen log_proteccion_pc=log(Girado_proteccion_real_pc)
gen log_educacion_pc=log(Girado_educacion_real_pc)
gen log_industria_pc=log(Girado_industria_real_pc)
gen log_salud_pc=log(Girado_salud_real_pc)
gen log_transporte_pc=log(Girado_transporte_real_pc)
gen log_resto_pc=log(Girado_resto_real_pc)
gen log_total_pc=log(Girado_real_pc)

*PORCENTAJE DE EJECUCION DE PRESUPUESTO
gen Ptje_vivienda_real= Girado_vivienda/PIM_vivienda
gen Ptje_proteccion_real=Girado_proteccion/PIM_proteccion
gen Ptje_educacion_real=Girado_educacion/PIM_educacion
gen Ptje_industria_real=Girado_industria/PIM_industria
gen Ptje_salud_real=Girado_salud/PIM_salud
gen Ptje_transporte_real=Girado_transporte/PIM_transporte
gen Ptje_resto_real= Resto_Girado/Resto_PIM
gen Ptje_real=Girado/PIM
*PORCENTAJE ASIGNADO A CADA ITEM
gen Ptje_vivienda= Girado_vivienda/Girado
gen Ptje_proteccion=Girado_proteccion/Girado
gen Ptje_educacion=Girado_educacion/Girado
gen Ptje_industria=Girado_industria/Girado
gen Ptje_salud=Girado_salud/Girado
gen Ptje_transporte=Girado_transporte/Girado
gen Ptje_resto= Resto_Girado/Girado
*
gen mv_max2=mv_max^2
gen mv_max3=mv_max^3
gen mv_max4=mv_max^4

gen mvXmujer=mv_max*mujer
gen mvXmujer2=mv_max2*mujer
gen mvXmujer3=mv_max3*mujer
gen mvXmujer4=mv_max4*mujer

forvalues num=1(1)4 {
foreach name in Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
				Girado_industria_real_pc Girado_educacion_real_pc ///
				Girado_proteccion_real_pc Girado_vivienda_real_pc ///
				Girado_resto_real_pc {
rdrobust `name' mv_max, c(0) p(`num') vce(nncluster distrito_ubigeo 3) 
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum `name' if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store `name'
}
esttab Girado_real_pc Girado_salud_real_pc Girado_transporte_real_pc ///
				Girado_industria_real_pc Girado_educacion_real_pc ///
				Girado_proteccion_real_pc Girado_vivienda_real_pc ///
				Girado_resto_real_pc, se nostar
		
matrix C = r(coefs)
*eststo clear
local rnames : rownames C
local models : coleq C
local models : list uniq models
local i 0
foreach name of local rnames {
    local ++i
    local j 0
    capture matrix drop b
    capture matrix drop se
    foreach model of local models {
        local ++j
        matrix tmp = C[`i', 2*`j'-1]
        if tmp[1,1]<. {
            matrix colnames tmp = `model'
            matrix b = nullmat(b), tmp
            matrix tmp[1,1] = C[`i', 2*`j']
            matrix se = nullmat(se), tmp
        }
    }
    ereturn post b
    quietly estadd matrix se
    eststo `name'_`num'
}
}
esttab RD_Estimate_1 RD_Estimate_2 RD_Estimate_3 RD_Estimate_4, replace b(%10.3f) se sfmt(%10.2f %10.0f %10.3f)	///	
		star(* 0.10 ** 0.05 *** 0.01) noobs nonotes width(\hsize) nonumb
clear all
cd "C:\UC\2018_2-Tesis de Magíster en Economía\Base de Datos\INFOGOB"

use base1, clear

gen absolute_margin=mv_max

replace mv_max=-mv_max if mujer==0

keep if actual==1

foreach name in edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje {
rdrobust `name' mv_max, c(0) p(3) 
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum `name' if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store `name'
}
esttab edad secundaria experiencia_laboral ant_penales regidor_mujer_prctje, noobs se scalars("meany Dep. Var. Mean:" "sdy Dep. Var. SD:" "bwsCCT Optimal bandwidth:" "bwCCT Effective N. Obs:") ///
		sfmt(%10.2f %10.2f %10.2f %10.0f) star(* 0.10 ** 0.05 *** 0.01) width(\hsize)
