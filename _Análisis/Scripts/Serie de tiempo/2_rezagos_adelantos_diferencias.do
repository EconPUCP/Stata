************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_rezagos_adelantos_diferencias.do
* OBJETIVO: Operadores de rezagos, adelantos y diferencias
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"

*************

import excel using "PBI Gasto Real.xlsx", sheet("Anual") clear

rename (*) (year DI C G I Ip X M PBI)
drop in 1/2
drop if year == 2020 // eliminamos 2020 porque no tiene obs.
destring(*), replace
gen XN = X-M // generamos la variable XN
keep year C G I XN PBI
tsset year
save "pbi_year", replace


* Cargamos la serie trimestral del PBI de Perú
import excel using "PBI Gasto Real.xlsx", ///
 sheet("Trimestral") clear

rename (*) (Q DI C G I Ip X M PBI)
drop in 1/2
drop if Q == "T419" | Q == "T120" // eliminamos porque no tiene obs.
destring(*), replace
gen XN = X-M

*crearemos una variable que sea el años
gen year = substr(Q,3,2)
destring(year), replace

replace year = year + 2000 if year<90
replace year = year + 1900 if year<2000

gen q = substr(Q,2,1)
destring(q), replace

*crearemos la variable con trimestres
gen trimestre = yq(year,q)
format trimestre %tq
keep trimestre C G I XN PBI

save "pbi_trimestre", replace

**************************
*		Rezagos			
**************************
use "pbi_year", clear

gen lnpbi = ln(PBI)
gen lnpbi_l1 = l.lnpbi
gen lnpbi_l2 = l2.lnpbi
gen lnpbi_l3 = l3.lnpbi
gen lnpbi_l4 = l4.lnpbi
gen lnpbi_l5 = l5.lnpbi

twoway ///
(line lnpbi year)  ///
(line lnpbi_l1 year ) ///
(line lnpbi_l2 year ) ///
(line lnpbi_l3 year ) ///
(line lnpbi_l4 year ) ///
(line lnpbi_l5 year ), ///
legend(  cols(6) size(*0.5) order(1 "lnPBI" 2 "Rezago 1" 3 "Rezago 2" ///
 4 "Rezago 3" 5 "Rezago 4" 6 "Rezago 5")) xtitle("") ytitle("ln(PBI)") ///
 title("PBI y rezagos") xlabel(1990(2)2018 2019,grid labsize(*0.6)) 

use "pbi_trimestre", clear

tsset trimestre

gen lnpbi = ln(PBI)
gen lnpbi_l1 = l4.lnpbi
gen lnpbi_l2 = l8.lnpbi
gen lnpbi_l3 = l12.lnpbi
gen lnpbi_l4 = l16.lnpbi
gen lnpbi_l5 = l20.lnpbi

twoway ///
(line lnpbi trimestre)  ///
(line lnpbi_l1 trimestre) ///
(line lnpbi_l2 trimestre) ///
(line lnpbi_l3 trimestre) ///
(line lnpbi_l4 trimestre) ///
(line lnpbi_l5 trimestre), ///
legend(  cols(6) size(*0.5) order(1 "lnPBI" 2 "Rezago 1" 3 "Rezago 2" ///
 4 "Rezago 3" 5 "Rezago 4" 6 "Rezago 5")) xtitle("") ytitle("ln(PBI)") ///
 title("PBI y rezagos" "Datos trimestrales") ///
 xlabel(`=q(1990q1)'(8) `=q(2018q1)', format(%tq) labsize(*0.7))

**************************
*	     Adelantos		
**************************

use "pbi_trimestre", clear

tsset trimestre

gen lnpbi = ln(PBI)
gen lnpbi_f1 = f4.lnpbi
gen lnpbi_f2 = f8.lnpbi
gen lnpbi_f3 = f12.lnpbi
gen lnpbi_f4 = f16.lnpbi
gen lnpbi_f5 = f20.lnpbi


**************************
*		Diferencias			
**************************

use "pbi_year", clear

tsset year

gen lnpbi = ln(PBI)
gen g_pbi1 = lnpbi - l.lnpbi //opción 1
gen g_pbi2 = d.lnpbi //opción 2

gen g_pb1l1 = l.d.lnpbi
gen g_pb1l2 = d.l.lnpbi


use "pbi_trimestre", clear
tsset trimestre
gen lnpbi = ln(PBI)
gen g_pbi1 = lnpbi - l4.lnpbi
gen g_pbi2 = d4.lnpbi


