
/*En este do file prepararemos una base con el módulo 500 y el  módulo Sumaria de la ENAHO - PANEL, seleccionaremos unas variables de interés, realizaremos un merge y procederemos a guardar nuestra nueva base*/


clear all

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"
*********

*********Sumaria****************
use "sumaria-2017-2021-panel.dta"
*Con la finalidad de tener un panel balanceado elimino las observaciones de los individuos que no están presente en todos los periodos

tab hpanel_1721, nolabel  
keep if hpanel_1721 == 1 

*Con el comando Keep mantendremoslas variables con las que nos interesa trababajar

keep numpanh conglome vivienda mieperho_17 pobreza_17 estrato_17 factor07_17 mieperho_18 pobreza_18 estrato_18 factor07_18 mieperho_19 pobreza_19 estrato_19 factor07_19 mieperho_20 pobreza_20 estrato_20 factor07_20 mieperho_21 pobreza_21 estrato_21 factor07_21

*La base de datos se encuentra en su forma ancha por lo cual con el comando reshape pondremos en la forma larga, que es la forma ideal del panel
reshape long pobreza_ estrato_ mieperho_  factor07_, i(numpanh conglome vivienda) j(año)

*Renombrando el  año
recode año (17=2017)(18=2018)(19=2019)(20=2020)(21=2021)

*Ordenando 
sort numpanh año

*Guardamos el archivo
save "sumaria_panel.dta", replace

********módulo 100*********
/*Abrimos el módulo 300*/
use "enaho01a-2017-2021-300-panel.dta", clear

tab hpanel_1721, nolabel  
keep if hpanel_1721 == 1 

*Con el comando Keep mantendremoslas variables con las que nos interesa trababajar
keep conglome p201pcor numper p207_17 p207_18 p207_19 p207_20 p207_21 numpanh17 numpanh18 numpanh19 numpanh20 numpanh21 

*La base de datos se encuentra en su forma ancha por lo cual con el comando reshape pondremos en la forma larga, que es la forma ideal del panel
reshape long p207_, i(numper numpanh17 numpanh18 numpanh19 numpanh20 numpanh21 conglome p201pcor) j(año)

*Ordenando 
sort numper año

*Renombrando el  año
recode año (17=2017)(18=2018)(19=2019)(20=2020)(21=2021)

*generamos la varianle numpanh que es identificador pero no está en esta base
gen numpanh=numpanh21

*Ordenando 
sort numpanh año


save "modulo_300_panel.dta", replace

**********************
*Realizamos un merge
**********************
use "modulo_300_panel.dta", clear
merge m:1 numpanh conglome año using "sumaria_panel.dta" 

drop if _merge!=3
drop _merge 

/*Hasta este punto puedes seguir haciendo merge con otras bases según las variables que necesites o puedes proceder a trabajar mejorando más tu base de datos como renombrando variables, recodificando tus variables o generando nuevas variable para luego procedera a guardar tu do file y base de datos*/

save "base_final", replace