************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 8_Aplicación_ec_mincer.do
* OBJETIVO: Ecuación de Mincer básica
************
 
*Preámbulo

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd

************

use "enaho01a-2019-500"

* Establecer diseño muestral
svyset conglome [pweight = fac500a], strata(estrato)

* merge del módulo de trabajo con el módulo de educación 
merge 1:1 conglome vivienda hogar codperso using "enaho01a-2019-300.dta", nogen keep(3)

* Logaritmo del ingreso
gen log_ing = log(i524a1)

* Años de educación
gen educ = .
replace educ = 0 if p301a == 1 | educ == 2
replace educ = 6 if p301a == 4
replace educ = p301b if educ == . & (p301a == 3 | p301b == 4 ) 
replace educ = 11 if p301a == 6
replace educ = 6+p301b if educ == . & (p301a == 5 | p301b == 6)
replace educ = 14 if p301a == 8
replace educ = 13 if p301a == 7
replace educ = 16 if p301a == 10
replace educ = 15 if p301a == 9
replace educ = 18 if p301a == 11

* Creamos una base de datos temporal con el nivel educativo del jefe del hogar
preserve
gen educ_jefe = educ if p203 == 1
keep if p203 == 1
keep educ_jefe conglome vivienda hogar codperso
tempfile base_temp
save `base_temp'
duplicates report conglome vivienda hogar
restore

* Juntamos la base con la base tmeporal
merge m:1 conglome vivienda hogar using `base_temp', nogen 

* Creamos un sub grupo de los hijos/as de jefes/as de hogar 
gen hijo_jefehogar = 1 if p203 == 3 
replace hijo_jefehogar = 0 if hijo_jefehogar == .

* Estimamos tres modelos
eststo clear
eststo: svy: 						 reg log_ing educ i.p207 p208
eststo: svy, subpop(hijo_jefehogar): reg log_ing educ i.p207 p208
eststo: svy: 					  	 ivregress 2sls log_ing (educ = educ_jefe) i.p207 p208
eststo: svy, subpop(hijo_jefehogar): ivregress 2sls log_ing (educ = educ_jefe) i.p207 p208

esttab, drop(1.p207) rename(educ Educ 2.p207 Mujer p208a Edad _cons Cons) ///
note("La variable instrumental es el nivel educativo del jefe de hogar") ///
nomtitle title("Ecuación de Mincer")