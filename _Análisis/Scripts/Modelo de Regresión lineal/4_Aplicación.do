************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 4_Aplicación.do
* OBJETIVO: Replicar estadísticas oficiales del INEI
************

* Preambulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"

**************************************************
use "sumaria-2018.dta"

* Definimos el diseño muestral 
/*Para Sumaria, no se puede usar de manera directa el factor de expasión, por que se debe generar un nuevo factor de expansión*/

gen factor_hogar =  factor07*mieperho
svyset conglome [pweight =  factor_hogar], strata(estrato) vce(linearized) 

svydescribe

* Creamos la categoría para pobreza 
gen poverty = 1 if pobreza == 1 | pobreza == 2
replace poverty = 0 if pobreza == 3

* Creamos la categoría para pobreza extrema
gen extr_poverty = 1 if pobreza == 1 
replace extr_poverty = 0 if pobreza == 2 | pobreza == 3

/* Creamos categorías para región y provincia.
   Con esto creamos una variable "lima" que sea Lima Metropolitana y Callao
*/
gen dpto = substr(ubigeo,1,2)
gen prov = substr(ubigeo,1,4)

gen lima = 1 if prov =="1501" | dpto == "07"
replace lima = 0 if lima ==. 

* Creamos las categorías rural/urbano
gen rural = 1 if estrato == 6 | estrato == 7 | estrato == 8
replace rural = 0 if rural == .

* Creamos las categorías para dominio geográfico
gen dominio_geo = .
replace dominio_geo = 1 if dominio == 1 | dominio == 2 | dominio == 3 | dominio == 8
replace dominio_geo = 2 if dominio == 4 | dominio == 5 | dominio == 6 
replace dominio_geo = 3 if dominio == 7

*etiquetar a nuestras variables
label define nombre_lima 0"Resto País" 1"Lima"
label values lima nombre_lima

label define nombre_dominio 1"costa" 2"sierra" 3"selva"
label values dominio_geo nombre_dominio

label define nombre_rural 0"urbano" 1"rural"
label values rural nombre_rural


* Tasa de pobreza para el Perú
svy: mean poverty

* Tasa de pobreza para el Lima + Callao y resto del Perú
svy: mean poverty, over(lima)

* Tasa de pobreza rural y urbana
svy: mean poverty, over(rural)

* Tasa de pobreza por dominio geográfico
svy: mean poverty, over(dominio_geo)

* Tasa de pobreza por dominio geográfico y rural o urbano
svy: mean poverty, over(dominio_geo rural)