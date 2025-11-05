clear all
cd "C:\Users\User\Documents\Tesis UNALM\Tesis\Análisis\"

local do_infogob 	"Dofiles\01. Infogob"
local do_ficha 		"Dofiles\02. Fichas"
local do_ubigeo 	"Dofiles\03. Ubigeos"
local do_luces 		"Dofiles\04. Nightlights"
local do_pnud 		"Dofiles\05. PNUD"
local do_final 		"Dofiles\00. Final"

local input_infogob "Input\Infogob"
local input_ubigeo 	"Input\Ubigeos"
local input_ficha 	"Input\Fichas"
local input_luces 	"Input\Nightlights"
local input_pnud 	"Input\PNUD"
local input_enaho "Input\Enaho"

local middle_infogob "Middle\Infogob"
local middle_ubigeo "Middle\Ubigeos"
local middle_ficha 	"Middle\Fichas"
local middle_luces 	"Middle\Nightlights"
local middle_pnud 	"Middle\PNUD"
local middle_enaho "Middle\Enaho"

* Características demográficas:
use `middle_infogob'\union_elecciones_2002, clear
append using `middle_infogob'\union_elecciones_2006
append using `middle_infogob'\union_elecciones_2010
append using `middle_infogob'\union_elecciones_2014
append using `middle_infogob'\union_elecciones_2018
append using `middle_infogob'\union_elecciones_2022

duplicates drop

drop if  mv_max==0
drop if ptje_votos==0

gen 	anho_cargo=1 if anho==2002
replace anho_cargo=2 if anho==2006
replace anho_cargo=3 if anho==2010
replace anho_cargo=4 if anho==2014
replace anho_cargo=5 if anho==2018
replace anho_cargo=6 if anho==2022

duplicates tag iddistrito anho_cargo id_candidato, gen(dup)
drop dup

mmerge iddistrito id_candidato anho_cargo using `middle_ficha'\fichas_candidatos_append
drop if _merge==2
drop _merge

duplicates drop

duplicates tag iddistrito anho_cargo id_candidato, gen(dup)

collapse (mean)  cargo mujer joven num_votos ptje_votos_ganador actual anho ///
				electores participacion votos_emitidos votos_validos votos_blanco votos_nulos ptje_votos  perdedor maxvotos diferencia_votos mv_max Ausentismo H J L edad secundaria experiencia_laboral ant_penales, by(iddistrito id_candidato anho_cargo)

gen gano_mujer=(mujer==1 & actual==1)

replace edad=. if actual==. //solo necesito la info del que ganó la elección
replace secundaria=. if actual==. //solo necesito la info del que ganó la elección
replace experiencia_laboral=. if actual==. //solo necesito la info del que ganó la elección
replace ant_penales=. if actual==. //solo necesito la info del que ganó la elección
collapse (sum) mujer gano_mujer (mean) mv_max participacion	maxvotos (max) edad secundaria experiencia_laboral ant_penales, by(iddistrito anho_cargo) // 9922 elecciones

gen compitio_mujer=(mujer==1)

replace gano_mujer=. if mujer==0 | mujer==2
replace mv_max=. if mujer==0 | mujer==2
replace participacion=. if mujer==0 | mujer==2
replace maxvotos=. if mujer==0 | mujer==2

replace participacion=participacion*100
*Correcciones
replace iddistrito="AMAZONASLUYASAN FRANCISCO DEL YESO" if iddistrito=="AMAZONASLUYASAN FRANCISCO DE YESO"
replace iddistrito="AMAZONASRODRIGUEZ DE MENDOZAMILPUC" if iddistrito=="AMAZONASRODRIGUEZ DE MENDOZAMILPUCC"
replace iddistrito="ANCASHANTONIO RAYMONDIACZO" if iddistrito=="ANCASHANTONIO RAIMONDIACZO"
replace iddistrito="ANCASHANTONIO RAYMONDICHACCHO" if iddistrito=="ANCASHANTONIO RAIMONDICHACCHO"
replace iddistrito="ANCASHANTONIO RAYMONDIMIRGAS" if iddistrito=="ANCASHANTONIO RAIMONDIMIRGAS"
replace iddistrito="ANCASHANTONIO RAYMONDICHINGAS" if iddistrito=="ANCASHANTONIO RAIMONDICHINGAS"
replace iddistrito="ANCASHANTONIO RAYMONDISAN JUAN DE RONTOY" if iddistrito=="ANCASHANTONIO RAIMONDISAN JUAN DE RONTOY"
replace iddistrito="ANCASHBOLOGNESIANTONIO RAYMONDI" if iddistrito=="ANCASHBOLOGNESIANTONIO RAIMONDI"
replace iddistrito="APURIMACAYMARAESHUAYLLO" if iddistrito=="APURIMACAYMARAESIHUAYLLO"
replace iddistrito="APURIMACCHINCHEROSANCO_HUALLO" if iddistrito=="APURIMACCHINCHEROSANCO HUALLO"
replace iddistrito="APURIMACGRAUHUAYLLATI" if iddistrito=="APURIMACGRAUHUAILLATI"
replace iddistrito="APURIMACGRAUGAMARRA" if iddistrito=="APURIMACGRAUMARISCAL GAMARRA"
replace iddistrito="AREQUIPAAREQUIPASANTA RITA DE SIGUAS" if iddistrito=="AREQUIPAAREQUIPASANTA RITA DE SIHUAS"
replace iddistrito="AYACUCHOLUCANASHUAC HUAS" if iddistrito=="AYACUCHOLUCANASHUAC-HUAS"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUAYA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUALLA"
replace iddistrito="CALLAOCALLAOCARMEN DE LA LEGUA REYNOSO" if iddistrito=="CALLAOCALLAOCARMEN DE LA LEGUA-REYNOSO"
replace iddistrito="HUANCAVELICAANGARAESHUAYLLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUALLAY-GRANDE"
replace iddistrito="HUANCAVELICAANGARAESHUANCA HUANCA" if iddistrito=="HUANCAVELICAANGARAESHUANCA-HUANCA"
replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
replace iddistrito="HUANUCOLEONCIO PRADODANIEL ALOMIAS ROBLES" if iddistrito=="HUANUCOLEONCIO PRADODANIEL ALOMIA ROBLES"
replace iddistrito="LA LIBERTADGRAN CHIMUCOMPIN" if iddistrito=="LA LIBERTADGRAN CHIMUMARMOT"
replace iddistrito="LIMAYAUYOSAYAUCA" if iddistrito=="LIMAYAUYOSALLAUCA"
replace iddistrito="PIURASECHURARINCONADA LLICUAR" if iddistrito=="PIURASECHURARINCONADA-LLICUAR"
replace iddistrito="PUNOEL COLLAOCAPAZO" if iddistrito=="PUNOEL COLLAOCAPASO"
replace iddistrito="SAN MARTINPICOTACASPISAPA" if iddistrito=="SAN MARTINPICOTACASPIZAPA"

mmerge iddistrito anho_cargo using "`middle_luces'\pbi1993_2018_ubigeo"
drop if _merge==2
drop _merge

* Características electorales:
lab var compitio_mujer "Quedaron en los 2 primeros: Mujer VS. Hombre"
lab var gano_mujer "Ganó la alcaldía una mujer"
lab var mv_max "Margen de Victoria"
lab var participacion "Participación electoral"
lab var maxvotos "\% Votos obtenidos por el ganador"

estpost sum compitio_mujer gano_mujer mv_max participacion maxvotos
est store A
esttab A, label cells("count mean sd min max") noobs

* Características del alcalde:
lab var edad "Edad"
lab var secundaria "Tiene al menos educación secundaria"
lab var experiencia_laboral "Tiene experiencia laboral"
lab var ant_penales "Tiene antecedentes penales"

estpost sum edad secundaria experiencia_laboral ant_penales
est store B
esttab B, label cells("count mean sd min max") noobs

* Estadísticas del PBI
replace pbi_growth=pbi_growth*100

gen pbi_growth_1=((pbi_2 - pbi_1) / pbi_1)*100
gen pbi_growth_2=((pbi_3 - pbi_2) / pbi_2)*100
gen pbi_growth_3=((pbi_4 - pbi_3) / pbi_3)*100

gen pbi_growth_mean=(pbi_growth_1+pbi_growth_2+pbi_growth_3)/3

*gen pbi_mean_pc=pbi_mean/Habitantes

estpost sum pbi_growth pbi_growth_mean pbi_mean pbi_1 pbi_2 pbi_3 pbi_4
est store C
esttab C, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc)) sd(fmt(%12.2fc)) min(fmt(%12.2fc)) max(fmt(%12.0fc))") noobs

*Correcciones
replace iddistrito="AMAZONASLUYASAN FRANCISCO DE YESO" if iddistrito=="AMAZONASLUYASAN FRANCISCO DEL YESO"
replace iddistrito="AMAZONASRODRIGUEZ DE MENDOZAMILPUCC" if iddistrito=="AMAZONASRODRIGUEZ DE MENDOZAMILPUC"
replace iddistrito="ANCASHANTONIO RAIMONDIACZO" if iddistrito=="ANCASHANTONIO RAYMONDIACZO"
replace iddistrito="ANCASHANTONIO RAIMONDICHACCHO" if iddistrito=="ANCASHANTONIO RAYMONDICHACCHO"
replace iddistrito="ANCASHANTONIO RAIMONDIMIRGAS" if iddistrito=="ANCASHANTONIO RAYMONDIMIRGAS"
replace iddistrito="ANCASHANTONIO RAIMONDICHINGAS" if iddistrito=="ANCASHANTONIO RAYMONDICHINGAS"
replace iddistrito="ANCASHANTONIO RAIMONDISAN JUAN DE RONTOY" if iddistrito=="ANCASHANTONIO RAYMONDISAN JUAN DE RONTOY"
replace iddistrito="ANCASHBOLOGNESIANTONIO RAIMONDI" if iddistrito=="ANCASHBOLOGNESIANTONIO RAYMONDI"
replace iddistrito="APURIMACGRAUHUAILLATI" if iddistrito=="APURIMACGRAUHUAYLLATI"
replace iddistrito="APURIMACGRAUMARISCAL GAMARRA" if iddistrito=="APURIMACGRAUGAMARRA"
replace iddistrito="AREQUIPAAREQUIPASANTA RITA DE SIHUAS" if iddistrito=="AREQUIPAAREQUIPASANTA RITA DE SIGUAS"
replace iddistrito="HUANUCOAMBOTOMAY-KICHWA" if iddistrito=="HUANUCOAMBOTOMAY KICHWA"
replace iddistrito="HUANUCOLEONCIO PRADODANIEL ALOMIA ROBLES" if iddistrito=="HUANUCOLEONCIO PRADODANIEL ALOMIAS ROBLES"
replace iddistrito="LA LIBERTADGRAN CHIMUMARMOT" if iddistrito=="LA LIBERTADGRAN CHIMUCOMPIN"
replace iddistrito="LIMAYAUYOSALLAUCA" if iddistrito=="LIMAYAUYOSAYAUCA"
replace iddistrito="PUNOEL COLLAOCAPASO" if iddistrito=="PUNOEL COLLAOCAPAZO"
replace iddistrito="SAN MARTINPICOTACASPIZAPA" if iddistrito=="SAN MARTINPICOTACASPISAPA"
replace iddistrito="APURIMACCHINCHEROSANCO HUALLO" if iddistrito=="APURIMACCHINCHEROSANCO_HUALLO"
replace iddistrito="AYACUCHOHUAMANGAANDRES AVELINO CACERES" if iddistrito=="AYACUCHOHUAMANGAANDRES AVELINO CACERES DORREGARAY"
replace iddistrito="AYACUCHOVICTOR FAJARDOHUALLA" if iddistrito=="AYACUCHOVICTOR FAJARDOHUAYA"
replace iddistrito="HUANCAVELICAANGARAESHUALLAY GRANDE" if iddistrito=="HUANCAVELICAANGARAESHUAYLLAY GRANDE"
replace iddistrito="HUANUCOAMBOTOMAY KICHWA" if iddistrito=="HUANUCOAMBOTOMAY-KICHWA"
				
mmerge iddistrito using `middle_ubigeo'\ubigeo_2014_v1
drop if _merge==2
drop _merge

bysort iddistrito: egen id_v2=max(Ubigeo)

replace id_v2=20109 if iddistrito=="ANCASHHUARAZPAMPAS GRANDE"

drop id1 id2 id3 Ubigeo id
rename id_v2 id

merge m:1 id anho_cargo using "`middle_pnud'\IDH-Peru.dta"
drop if _merge==2
drop _merge

*Indicadores demográficos
estpost sum IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc 
est store D
esttab D, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc)) sd(fmt(%12.2fc)) min(fmt(%12.2fc)) max(fmt(%12.0fc))") noobs

*Estadísticas diferenciadas por género
estpost sum pbi_growth pbi_growth_mean pbi_mean pbi_1 pbi_2 pbi_3 pbi_4 if gano_mujer==1
est store E
esttab E, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc)) sd(fmt(%12.2fc)) min(fmt(%12.2fc)) max(fmt(%12.0fc))") noobs

estpost sum pbi_growth pbi_growth_mean pbi_mean pbi_1 pbi_2 pbi_3 pbi_4 if gano_mujer==0
est store F
esttab F, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc)) sd(fmt(%12.2fc)) min(fmt(%12.2fc)) max(fmt(%12.0fc))") noobs

estpost sum IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc if gano_mujer==1
est store G
esttab G, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc)) sd(fmt(%12.2fc)) min(fmt(%12.2fc)) max(fmt(%12.0fc))") noobs

estpost sum IDH Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc if gano_mujer==0
est store H
esttab H, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc)) sd(fmt(%12.2fc)) min(fmt(%12.2fc)) max(fmt(%12.0fc))") noobs

esttab E F, label cells("count(fmt(%12.0fc)) mean(fmt(%12.2fc))") noobs
esttab G H, label cells("count(fmt(%12.0fc)) mean(fmt(%12.3fc))") noobs

replace id=160703 if iddistrito=="LORETOALTO AMAZONASMANSERICHE" & id==.
replace id=160801 if iddistrito=="LORETOMAYNASPUTUMAYO" & id==.
replace id=160702 if iddistrito=="LORETOALTO AMAZONASCAHUAPANAS" & id==.
replace id=160705 if iddistrito=="LORETOALTO AMAZONASPASTAZA" & id==.
replace id=150121 if iddistrito=="LIMALIMAPUEBLO LIBRE" & id==.
replace id=160701 if iddistrito=="LORETOALTO AMAZONASBARRANCA" & id==.
replace id=160704 if iddistrito=="LORETOALTO AMAZONASMORONA" & id==.
replace id=160803 if iddistrito=="LORETOMAYNASTENIENTE MANUEL CLAVERO" & id==.
replace id=190308 if iddistrito=="PASCOOXAPAMPACONSTITUCION" & id==.
replace id=100112 if iddistrito=="HUANUCOHUANUCOYACUS" & id==.
replace id=090511 if iddistrito=="HUANCAVELICACHURCAMPACOSME" & id==.
replace id=110305 if iddistrito=="ICANASCAVISTA ALEGRE" & id==.
replace id=200115 if iddistrito=="PIURAPIURAVEINTISEIS DE OCTUBRE" & id==.
replace id=050116 if iddistrito=="AYACUCHOHUAMANGAANDRES AVELINO CACERES" & id==.
replace id=050509 if iddistrito=="AYACUCHOLA MARSAMUGARI" & id==.
replace id=050409 if iddistrito=="AYACUCHOHUANTACANAYRE" & id==.
replace id=110302 if iddistrito=="ICANASCACHANGUILLO" & id==.
replace id=110304 if iddistrito=="ICANASCAMARCONA" & id==.
replace id=110303 if iddistrito=="ICANASCAEL INGENIO" & id==.
replace id=050510 if iddistrito=="AYACUCHOLA MARANCHIHUAY" & id==.
replace id=030611 if iddistrito=="APURIMACCHINCHEROSLOS CHANKAS" & id==.
replace id=050411 if iddistrito=="AYACUCHOHUANTAPUCACOLPA" & id==.
replace id=030609 if iddistrito=="APURIMACCHINCHEROSROCCHACC" & id==.
replace id=030220 if iddistrito=="APURIMACANDAHUAYLASJOSE MARIA ARGUEDAS" & id==.
replace id=090721 if iddistrito=="HUANCAVELICATAYACAJAROBLE" & id==.
replace id=100608 if iddistrito=="HUANUCOLEONCIO PRADOCASTILLO GRANDE" & id==.
replace id=080912 if iddistrito=="CUSCOLA CONVENCIONVILLA VIRGEN" & id==.
replace id=100705 if iddistrito=="HUANUCOMARAÑONSANTA ROSA DE ALTO YANAJANCA" & id==.
replace id=100610 if iddistrito=="HUANUCOLEONCIO PRADOSANTO DOMINGO DE ANDA" & id==.
replace id=120609 if iddistrito=="JUNINSATIPOVIZCATAN DEL ENE" & id==.
replace id=050410 if iddistrito=="AYACUCHOHUANTAUCHURACCAY" & id==.
replace id=100113 if iddistrito=="HUANUCOHUANUCOSAN PABLO DE PILLAO" & id==.
replace id=250305 if iddistrito=="UCAYALIPADRE ABADALEXANDER VON HUMBOLDT" & id==.
replace id=090719 if iddistrito=="HUANCAVELICATAYACAJAQUICHUAS" & id==.
replace id=090722 if iddistrito=="HUANCAVELICATAYACAJAPICHOS" & id==.
replace id=150712 if iddistrito=="LIMAHUAROCHIRISAN PEDRO DE LARAOS" & id==.
replace id=080914 if iddistrito=="CUSCOLA CONVENCIONMEGANTONI" & id==.
replace id=230111 if iddistrito=="TACNATACNALA YARADA LOS PALOS" & id==.
replace id=080913 if iddistrito=="CUSCOLA CONVENCIONVILLA KINTIARINA" & id==.
replace id=050412 if iddistrito=="AYACUCHOHUANTACHACA" & id==.
replace id=100609 if iddistrito=="HUANUCOLEONCIO PRADOPUEBLO NUEVO" & id==.
replace id=090720 if iddistrito=="HUANCAVELICATAYACAJAANDAYMARCA" & id==.
replace id=160804 if iddistrito=="LORETOPUTUMAYOYAGUAS" & id==.
replace id=100607 if iddistrito=="HUANUCOLEONCIO PRADOPUCAYACU" & id==.
replace id=080911 if iddistrito=="CUSCOLA CONVENCIONINKAWASI" & id==.
replace id=100704 if iddistrito=="HUANUCOMARAÑONLA MORADA" & id==.
replace id=090723 if iddistrito=="HUANCAVELICATAYACAJASANTIAGO DE TUCUMA" & id==.
replace id=250304 if iddistrito=="UCAYALIPADRE ABADNESHUYA" & id==.
replace id=070107 if iddistrito=="CALLAOCALLAOMI PERU" & id==.
replace id=160802 if iddistrito=="LORETOPUTUMAYOROSA PANDURO" & id==.
replace id=030610 if iddistrito=="APURIMACCHINCHEROSEL PORVENIR" & id==.
replace id=050511 if iddistrito=="AYACUCHOLA MARORONCCOY" & id==.
replace id=160803 if iddistrito=="LORETOPUTUMAYOTENIENTE MANUEL CLAVERO" & id==.
replace id=080916 if iddistrito=="CUSCOLA CONVENCIONCIELO PUNCO" & id==.
replace id=250307 if iddistrito=="UCAYALIPADRE ABADBOQUERON" & id==.
replace id=080915 if iddistrito=="CUSCOLA CONVENCIONKUMPIRUSHIATO" & id==.
replace id=090725 if iddistrito=="HUANCAVELICATAYACAJACOCHABAMBA" & id==.
replace id=090724 if iddistrito=="HUANCAVELICATAYACAJALAMBRAS" & id==.
replace id=211105 if iddistrito=="PUNOSAN ROMANSAN MIGUEL" & id==.
replace id=050513 if iddistrito=="AYACUCHOLA MARRIO MAGDALENA" & id==.
replace id=050413 if iddistrito=="AYACUCHOHUANTAPUTIS" & id==.
replace id=250306 if iddistrito=="UCAYALIPADRE ABADHUIPOCA" & id==.
replace id=050512 if iddistrito=="AYACUCHOLA MARUNION PROGRESO" & id==.
replace id=050514 if iddistrito=="AYACUCHOLA MARNINABAMBA" & id==.
replace id=180107 if iddistrito=="MOQUEGUAMARISCAL NIETOSAN ANTONIO" & id==.
replace id=050515 if iddistrito=="AYACUCHOLA MARPATIBAMBA" & id==.
replace id=080918 if iddistrito=="CUSCOLA CONVENCIONUNION ASHÁNINKA" & id==.
replace id=030612 if iddistrito=="APURIMACCHINCHEROSAHUAYRO" & id==.
replace id=221006 if iddistrito=="SAN MARTINTOCACHESANTA LUCIA" & id==.

gen id_str = string(id)

gen id_pov=substr(id_str,1,3) if id<100000
replace id_pov=substr(id_str,1,4) if id>=100000

destring id_pov, replace

mmerge id anho_cargo using "`middle_enaho'\sumaria_pobreza"
drop if _merge==2
drop _merge



********************************************************************************
********************************************************************************
********************************************************************************
* REGRESIONES
********************************************************************************
replace mv_max=-mv_max if gano_mujer==0

*Gráficos de las covariables
rdplot Esperanza_vida mv_max,  ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))

rdplot Anhos_educacion mv_max,  ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))

rdplot secundaria mv_max,  ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
					 
rdplot experiencia_laboral mv_max,  ///
       graph_options(xtitle(MV hombre-mujer en t) ///
                     graphregion(color(white)))
/*
rdplot maxvotos mv_max if inrange(mv_max,-10,10), ///
p(4) ci(95)  graph_options(xlabel(-10(2.5)10) ylabel(0(0.1)1))

cmogram actual_mujer mv_max if mv_max>-10 & mv_max<10, ///
cut(0) scatter line(0) qfitci
*/
gen mv_max2=mv_max^2
gen mv_max3=mv_max^3
gen mv_max4=mv_max^4
/*
gen pbi_growth_1=((pbi_2 - pbi_1) / pbi_1)*100
gen pbi_growth_2=((pbi_3 - pbi_2) / pbi_2)*100
gen pbi_growth_3=((pbi_4 - pbi_3) / pbi_3)*100

gen pbi_growth_mean=(pbi_growth_1+pbi_growth_2+pbi_growth_3)/3
*/

ttest pbi_growth, by(gano_mujer)
corr Habitantes Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc Territorio

reg pbi_growth Habitantes Esperanza_vida Poblacion_educ_sec Anhos_educacion Ingreso_familiar_pc Territorio
vif
********************************************************************************
********************************************************************************
********************************************************************************
*Sobre el crecimiento del PBI
rdrobust pbi_growth mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m11

rdrobust pbi_growth mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m12

rdrobust pbi_growth mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m13

esttab pbi_growth_m11 pbi_growth_m12 pbi_growth_m13, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)

*Sobre el crecimiento promedio del PBI
rdrobust pbi_growth_mean mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m21

rdrobust pbi_growth_mean mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m22

rdrobust pbi_growth_mean mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m23

esttab pbi_growth_m21 pbi_growth_m22 pbi_growth_m23,  se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)

*Sobre el IDH promedio
rdrobust IDH mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m31

rdrobust IDH mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m32

rdrobust IDH mv_max, c(0) covs( Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m33

rdrobust IDH mv_max, c(0) covs(mv_max2 mv_max3 Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m34

esttab pbi_growth_m31 pbi_growth_m32 pbi_growth_m33 pbi_growth_m34, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)
********************************************************************************
********************************************************************************
********************************************************************************
*Sobre el crecimiento del PBI, controlando por el comportamiento delictivo
gen nocorrupta=(ant_penales==0)
replace nocorrupta=. if ant_penales==.

gen mujer_nocorrupta=nocorrupta*gano_mujer

rdrobust pbi_growth mv_max, c(0) covs( mujer_nocorrupta Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m111

rdrobust pbi_growth mv_max, c(0) covs(mujer_nocorrupta Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m112

esttab pbi_growth_m111 pbi_growth_m112, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)

*Sobre la tasa de crecimiento promedio anual del PBI
rdrobust pbi_growth_mean mv_max, c(0) covs(mujer_nocorrupta Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m211

rdrobust pbi_growth_mean mv_max, c(0) covs(mujer_nocorrupta Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m212

esttab pbi_growth_m211 pbi_growth_m212, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)

*Sobre el IDH promedio

rdrobust IDH mv_max, c(0) covs(mujer_nocorrupta Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m311

rdrobust IDH mv_max, c(0) covs(mujer_nocorrupta Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_m312

esttab pbi_growth_m311 pbi_growth_m312, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)
********************************************************************************
********************************************************************************
********************************************************************************
*Sobre el crecimiento del PBI, controlando por la tasa de pobreza

gen mujer_distrito_pobre=distrito_pobre*gano_mujer

rdrobust pbi_growth mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(5)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_a

rdrobust pbi_growth mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(10)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_b

rdrobust pbi_growth mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_c

rdrobust pbi_growth mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_d

esttab pbi_growth_a pbi_growth_b pbi_growth_c pbi_growth_d, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)
		
		
*Sobre la tasa de crecimiento promedio anual del PBI
rdrobust pbi_growth_mean mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(5)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_e

rdrobust pbi_growth_mean mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(10)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_f

rdrobust pbi_growth_mean mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_g

rdrobust pbi_growth_mean mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_h

esttab pbi_growth_e pbi_growth_f pbi_growth_g pbi_growth_h, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)

*Sobre el IDH promedio

rdrobust IDH mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(15)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_i

rdrobust IDH mv_max, c(0) covs(mujer_distrito_pobre Habitantes Esperanza_vida Poblacion_educ_sec Ingreso_familiar_pc Territorio) h(40)
	estadd scalar bwl = e(N_h_l)
	estadd scalar bwr = e(N_h_r)
	estadd scalar bwCCT = e(N_h_l) +  e(N_h_r)
	estadd scalar bwsCCT =e(h_l)
	sum pbi_growth if e(bwCCT)
	estadd scalar meany = r(mean)
	estadd scalar sdy = r(sd)
	est store pbi_growth_j

esttab pbi_growth_i pbi_growth_j, se star(* 0.10 ** 0.05 *** 0.01) ///
						scalars("meany Prom. Var. Dep.:" "sdy SD. Var. Dep.:" "bwsCCT Ancho de banda óptimo:" "bwCCT N. Obs. Efectivas (NOE):" "bwl NOE Hombres:" "bwr NOE Mujeres:") ///
							noobs nonotes width(\hsize)
