************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 6_merge_append.do
* OBJETIVO: fusión y anexión de bases
************

*Preámbulo

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // coloca la dirección donde se encuentra tu base de datos

************

* Fusionando dos bases con 1:1
use "pwt90_africa.dta", clear

merge 1:1 ifscode date using  "pwt90_africa_2.dta"

* Fusionando dos bases con m:1
drop _merge
merge m:1 country using  "pwt90_africa_capital.dta", nogen

* Anexación de datos

append using "pwt90_sudamerica.dta"

