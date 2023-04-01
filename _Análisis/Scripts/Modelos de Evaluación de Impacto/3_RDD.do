************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_RDD.do
* OBJETIVO: Diseño de regresión discontinua
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data"


*************

use data_for_analysis.dta, clear


********************************
****** Scope of analysis *******
********************************

***Lima Province
gen limaprov=(substr(ubigeo,1,4)=="1501")

***Households without wage workers
tab depend1, m
bys num_hog: egen hog_depend1=sum(depend1)
replace hog_depend1=1 if hog_depend1>=1
gen formal=(hog_depend1==1) // Individuals that belong to a household in which at least one member is formally employed.

***Filters
keep if limaprov==1 // Focus on Lima Province.
drop if ifh==. // 3 observations without IFH.
drop if consulta==. // 1 observation without information on health.
tab formal, m // Full sample: 4,161 obs.


*********************************
********** Variables  ***********
*********************************

***RDD variables (Z)

gen z_ifh=ifh-corte
clonevar Z1=z_ifh
label var Z1 "IFH index minus threshold"

gen eligibleZ1=Z1<=0 
label var eligible "eligibility"
label def eligible 0 "Ineligible" 1 "Eligible"
label val eligibleZ1 eligible

gen interaccion_EZ1=Z1*eligibleZ1

gen Z2=p1172_01-20 // Cutoff = 20 soles.
gen Z3=p1172_02-25 // Cutoff = 25 soles.
gen eligibleZ2=Z2<=0 | Z2==.
gen eligibleZ3=Z3<=0 | Z3==.
generate high=(formal==0 & agua==1 & electricidad==1 & eligibleZ2==0 & eligibleZ3==0) // Informal individuals accessing water and electricity with high consumption.

generate high_eligibleZ1=high*eligibleZ1
gen interaccion_high=Z1*high

gen eligible=1 if formal==0 & (agua~=1 | electricidad~=1) & eligibleZ1==1 // Eligible definition based on IFH, electricity and water.
replace eligible=0 if formal==0 & (agua~=1 | electricidad~=1) & eligibleZ1==0
replace eligible=0 if formal==0 & agua==1 & electricidad==1 & eligibleZ1==0
replace eligible=0 if formal==0 & agua==1 & electricidad==1 & eligibleZ1==1 & (eligibleZ2==0 & eligibleZ3==0)
replace eligible=1 if formal==0 & agua==1 & electricidad==1 & eligibleZ1==1 & (eligibleZ2==1 | eligibleZ3==1)


***Creando los global para los controles y yfinlist

global controles mujer edad educ mieperho hhmujer
lab var mujer "women"
lab var edad "age"
lab var educ "years of education"
lab var mieperho "number of household members"
lab var hhmujer "women as head of household"


global yfinlist consulta consulta_ins consulta_pins consulta_oop ///
		medicinas medicinas_ins medicinas_pins medicinas_oop ///
		analisis analisis_ins analisis_oop ///
		rayos rayos_ins rayos_oop ///
		examenes examenes_ins examenes_oop ///
		lentes  lentes_oop ///
		otros otros_ins otros_pins otros_oop ///
		hospinter hospinter_ins hospinter_pins hospinter_oop ///
		hospital intervencion ///
		dental dental_ins dental_oop ///
		ojos ojos_ins ojos_oop ///
		vacunas vacunas_ins ///
		anticon anticon_ins anticon_oop  ///
		campana atencion curative


*** RDRobust regressions ***
****************************

** redefining forcing variable
ssc install lpdensity
rddensity Z1_change, c(0) plot graph_opt(graphregion(color(white))) 




gen Z1_change=(-1)*Z1 

** outcomes

ssc install rdrobust

foreach var of varlist $yfinlist {
rdrobust `var' Z1_change if formal==0 & high==0, c(0) p(1) covs($controles) bwselect(msetwo) all
}

