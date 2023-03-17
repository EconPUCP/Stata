************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_Manipulando_variables_de_fecha.do
* OBJETIVO: Manipulando variables de tiempo
************

Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"

*************

* Crearemos variables de tiempo

* Trimestres -> Quarters
clear
set obs 100
gen trimestre = tq(1960q1) +_n -1
format %tq trimestre
tsset trimestre

* Mensuales -> Monthly
clear
set obs 100
gen mes = tm(1960m1) +_n -1
format %tm mes
tsset mes

* Diarios -> Daily
clear
set obs 100
gen diario = td(1jan1960) +_n -1
format %td diario
tsset diario

* Anual -> Yearly
clear
set obs 100
gen anual = 1960 + _n -1
tsset anual 

* Cargamos la serie de fechas para cambiar el formato
use "fechas", clear

gen fecha1_num = date(fecha1,"MDY")
format fecha1_num %td

gen fecha2_num = date(fecha2,"DMY")
format fecha2_num %td

tostring(fecha3), replace
gen fecha3_num = date(fecha3,"YMD")
format fecha3_num %td

tostring(fecha4), replace
gen year = substr(fecha4,1,4)
gen month = substr(fecha4,4,2)
gen day = substr(fecha4,6,.)
destring(year month day), replace

gen fecha4_num = mdy(month,day,year)
format fecha4_num %td
drop year month day 

replace fecha5 =  subinstr(fecha5,"Ene","Jan",1)
gen fecha5_num = date(fecha5,"DMY")
format fecha5_num %td

* Para ver el dia de la semana podemos usar el comando dow()

gen diadelasemana = dow(fecha1_num)


/* 
Si tenemos variables en string en otras frecuencias
podemos usar otro conjunto de comandos para 
transformalos, por ejemplo:

gen week= weekly(stringvar,"wy")       // Semana
gen month= monthly(stringvar,"my") 	   // Mes
gen quarter= quarterly(stringvar,"qy") // Trimestres
gen half = halfyearly(stringvar,"hy")  // Semestres
gen year= yearly(stringvar,"y") 	   // Años

En cambio si los componentes están en números podemos
usar otro conjunto de comandos:

gen daily = mdy(month,day,year)		   // Días 
gen week = yw(year, week)			   // Semanas
gen month = ym(year,month) 			   // Mes
gen quarter = yq(year,quarter) 		   // Trimestres
gen half = yh(year,half-year)		   // Semestres

*/

* Cambiar formatos de las series

* De dia a trimestre
gen trimestre = qofd(fecha1_num)
format trimestre %tq

* De dia a mes
gen mes = mofd(fecha1_num)
format mes %tm

* De dia a semana
gen w = week(fecha1_num)
gen year = year(fecha1_num)
gen semana = yw(year,w)
format semana %tw