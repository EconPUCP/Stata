*******************************************
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_analisis_descriptivo.do
* OBJETIVO: Creación de la base principal
*******************************************

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Replica Cozzubo"
global data "$root/data"
global cleaned "$root/cleaned"


* Abrir base de datos
*==========================
use "$cleaned/data_final", clear


*======================
* Cálculo de pobreza	
*======================

*Creando las variables del gasto deflactado a precios de Lima 
gen ipcmr_pl=inghog1d/(12*ld*mieperho*i00)
gen gpcmr_pl=gashog2d/(12*ld*mieperho*i00)
gen linear_pl=linea/(ld*i00) // Línea de pobreza a precios reales de Lima

*Declarando la muestra
svyset [pweight = factornd07], psu(conglome) strata(estrato)


* Tasa de pobreza
*=================

g pobre = (gpcmr_pl < linear_pl)
label define pobre 0"No pobre" 1"Pobre"
label val pobre pobre

***Fig. 04
svy:mean pobre, over(aniorec) 

***Fig 06 y cuadro. 18 
svy:mean pobre, over(aniorec dpto1) cformat(%9.4fc) 

* Brecha pobreza 
*================

g brecha = (linear_pl-gpcmr_pl)/linear_pl if pobre==1
replace brecha = 0 if pobre==0

***Fig 07 y cuadro. 19
svy:mean brecha, over(aniorec dpto1) cformat(%9.4fc) 

* Severidad
*===========

g severidad = ((linear_pl-gpcmr_pl)/linear_pl)^2 if pobre==1
replace severidad = 0 if pobre==0

***Fig 08. y cuadro. 20
svy:mean severidad, over(aniorec dpto1) cformat(%9.4fc) 


*===============================================
*Pobreza por necesidades básicas insatisfechas
*===============================================

gen NBI=nbi1+nbi2+nbi3+nbi4+nbi5
recode NBI (0=0 "No pobre") (1/5=1 "Pobre"), gen(pobre_NBI)
lab var pobre_NBI "Pobreza - Necesidades Basicas Insatisfechas"

tab pobre_NBI

svy: tabulate pobre_NBI anio, col 

***Fig 10
foreach x in 07 08 09 10 11{
svy: tab nbi1 if aniorec==20`x'
svy: tab nbi2 if aniorec==20`x'
svy: tab nbi3 if aniorec==20`x'
svy: tab nbi4 if aniorec==20`x'
svy: tab nbi5 if aniorec==20`x'
}

*==================
*Pobreza integrada
*==================

gen pob_integrado=4 if pobre==1 & pobre_NBI==1 /*Pobreza Crónica*/
replace pob_integrado=3 if pobre==1 & pobre_NBI==0 /*Pobreza Reciente*/
replace pob_integrado=2 if pobre==0 & pobre_NBI==1 /*Pobreza Inercial*/
replace pob_integrado=1 if pobre==0 & pobre_NBI==0 /*Integrado socialmente*/
label var pob_integrado "Pobreza por el método integrado"
label define pob_integrado 1"Integrado socialmente" 2"Pobreza inercial" 3"Pobreza reciente" 4"Pobre crónico"
label var pob_integrado pob_integrado

*Clasifica No Pobre y Pobre
gen pobreza_integ=pob_integrado
recode pobreza_integ (1=0) (2/4=1)

*==================
* Mapas de pobreza
*==================

*crearemos la variable dpto_id
g dpto_id= real(substr(ubigeo,1,2))

collapse (mean) pobre, by(dpto_id aniorec)

save "$data/data_para_mapas", replace

*Transformamos los datos de shapefiles a dta
shp2dta using "$data/DEPARTAMENTOS/DEPARTAMENTOS.shp", database(dpto) coordinates(dpto_coord) genid(dpto_id)  replace

*Haciendo mapas en Stata anexando con otros datos
use "dpto.dta", clear
merge 1:m dpto_id using "$data/data_para_mapas"

***Fig. 05
foreach x in 07 08 09 10 11{
spmap pobre if aniorec==20`x' using "dpto_coord.dta", id(dpto_id) fcolor(Blues) clnumber(5)  title("Pobreza por regiones Perú 20`x'" ) 
}
