************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_graficos_de_stata.do
* OBJETIVO: Visualización de datos en gráficos
************

* Preambulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" /// cambiar directorio


**************************************************
use "IfoGAME.dta"


* Describimos la base

describe

* Histogramas

hist mag 	// Histograma por default

hist mag, width(0.5) // Se define la distancia entre cada bin

hist mag, bin(10) // Se define el número bins que queremos

* Agregamos algunas opciones adicionales
hist mag, bin(20) percent normal 								  ///
 xtitle("Máxima Escala Richter por Terremoto") 					  ///
 ytitle("Porcentaje, %")								   		  ///
 title("Distribución de Terremotos" "Toda la muestra, 1979-2010") ///
 normopts(lcolor(red)) kdensity kdenopts(lcolor(blue))

* Kernel 
 
kdensity mag if iso =="PER" | iso == "CHL" , 						  ///
 lcolor(blue) normal normopts(lcolor(red)) 			  				  ///
 legend(order(1 "Densidad Estimada" 2 "Distribución nomral") cols(2)) ///
 xtitle("Máxima Escala Richter por Terremoto") 					      ///
 ytitle("Densidad")								   		  			  ///
 title("Distribución de Terremotos" "Perú y Chile, 1979-2010")
 
* Scatter - Gráfico de dispersión
 
scatter mag combi, 														           ///
 xtitle("Velocidad Máxima del viento en nodos para tormentas y huracanes", size(*0.8)) ///
 ytitle("Máxima Escala Richet por Terremoto", size(*0.8))		   		  			   ///
 title("Terremotos y Velocidad de tormentas" "Toda la muestra, 1979-2010", size(*0.8)) ///
 msize(*0.8) mcolor(green)

* Establecemos una muestra más pequeña
 
scatter mag combi if year ==2000, mcolor(blue) msize(*0.5)							   ///
 mlabel(iso) mlabcolor(blue) 														   ///
 xlabel(0(20)150, grid labsize(*0.5)) 												   ///
 ylabel(2(1)8,    grid labsize(*0.5))												   ///
 xtitle("Velocidad Máxima del viento en nodos para tormentas y huracanes", size(*0.8)) ///
 ytitle("Máxima Escala Richet por Terremoto", size(*0.8))		   		  			   ///
 title("Terremotos y Velocidad de tormentas" "2010", size(*0.8))

 * Usando el comando twoway

  /*
 twoway (Gráfico 1) (Gráfico 2) (Gráfico 3)
 
 twoway ///
 (Gráfico 1) ///
 (Gráfico 2) ///
 (Gráfico 3) 
 
 */
 
twoway ///
 (scatter mag combi if year ==1990, mcolor(blue)  msize(*0.4) mlabel(iso) mlabcolor(blue)  mlabsize(*0.8) ) ///
 (scatter mag combi if year ==2000, mcolor(green) msize(*0.4) mlabel(iso) mlabcolor(green) mlabsize(*0.8) ) ///
 (scatter mag combi if year ==2010, mcolor(red)   msize(*0.4) mlabel(iso) mlabcolor(red)   mlabsize(*0.8) ) ///
 ,legend(order(1 "1990" 2 "2000" 3  "2010") cols(3))										     			///
 xlabel(0(20)150, grid labsize(*0.5)) 												   						///
 ylabel(2(1)8,    grid labsize(*0.5))												   						///
 xtitle("Velocidad Máxima del viento en nodos para tormentas y huracanes", size(*0.8))		 				///
 ytitle("Máxima Escala Richet por Terremoto", size(*0.8))		   		  			   		 				///
 title("Terremotos y Velocidad de tormentas" "1990-2000-2010", size(*0.8)) 


 
* Usando scatter y lfit

twoway ///
 (scatter mag combi if year == 2000, mcolor(blue) msize(*0.4) mlabel(iso) mlabcolor(blue)) 	///
 (lfit    mag combi if year == 2000, lcolor(red) lpattern(dash) )							///
 ,legend(off)        																		///
 xlabel(0(20)140, grid labsize(*0.5)) 												   		///
 ylabel(2(1)8,    grid labsize(*0.5))												   		///
 xtitle("Velocidad Máxima del viento en nodos para tormentas y huracanes", size(*0.8))		///
 ytitle("Máxima Escala Richet por Terremoto", size(*0.8))		   		  			   		///
 title("Terremotos y Velocidad de tormentas" "2000", size(*0.8)) 


preserve

keep if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
		iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
		iso == "CRI" | iso == "HND" | iso == "SLV" | iso =="CAN"
 
collapse (sum) quake, by(year)
line quake year, lcolor(blue) lpattern(longdash) ///
xlabel(1980(2)2010, labsize(*0.8) grid) 		///
ylabel(0(1)10, labsize(*0.8) grid) ///
xtitle("") ytitle("Total de terremotos") ///
title("Número de terremotos por año" "Paises con costa al Pacífico, 1979-2010", size(*0.8))

restore

* Usando by para indicar distintos grupos

preserve

gen sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				  iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
			      iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					  iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | /// 
					  iso == "BRN" | iso == "PNG" 
				
replace sample = 3 if sample == .

collapse (sum) quake, by(sample year)

label define sample_label 1 "América" 2 "Asia"  3 "Resto"
label values sample sample_label

line quake year, by(sample, cols(1))     ///
xlabel(1980(2)2010, labsize(*0.8) grid)  ///
xtitle("") ytitle("Total de terremotos") ///
title("Número de terremotos por año")

restore
 
* Box plot

preserve

gen sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				  iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
			      iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					  iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | /// 
					  iso == "BRN" | iso == "PNG" 
					  
replace sample = 3 if sample == .

label define sample_label 1 "América" 2 "Asia"  3 "Resto"
label values sample sample_label

gen log_d =log(damage_cor*1000000)

graph box log_d  if damage_cor !=0 | damage_cor !=. , by(sample, row(1))  ///
ytitle("Log(Daño Material, dólares)") 
 
restore
 
* Pie

preserve
gen sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				  iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
			      iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					  iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | /// 
					  iso == "BRN" | iso == "PNG" 
					  
replace sample = 3 if sample == .

label define sample_label 1 "América" 2 "Asia"  3 "Resto"
label values sample sample_label

gen     decadas = 1 if year >= 1979 & year < 1989
replace decadas = 2 if year >= 1989 & year < 1999
replace decadas = 3 if year >= 1999 & year <= 2010

label define decadas_label 1 "[1979-1989[" 2 "[1989-1999[" 3 "[1999-2010[" 
label value decadas decadas_label

graph pie quake, over(decadas) sort plabel(_all percent)						     ///
 pie(1, color(red) explode) pie(2, color(blue) explode) pie(3, color(green) explode) ///
 legen(order( 1 "[1979-1989[" 2 "[1989-1999[" 3 "[1999-2010[") cols(3))  			 ///
 title("Porcentaje de terremotos por décadas")
 
restore
 
  
 * Bar
 
preserve
gen sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				  iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
			      iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					  iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | /// 
					  iso == "BRN" | iso == "PNG" 
					  
replace sample = 3 if sample == .

label define sample_label 1 "América" 2 "Asia"  3 "Resto"
label values sample sample_label

graph hbar (mean) mag maxvei, over(sample)   								      ///
bar(1, color(blue)) bar(2, color(red))  										  ///
legend(title("Promedio de:", size(*0.4)) cols(1) size(*0.45) pos(5) ring(0)      ///
order( 1 "Magnitud Richter de terremotos" 2 "Índice de Explosividad Volcánica"))

restore
 

* Diferentes esquemas de gráficos
set scheme s1color
hist mag, name(a1, replace)

set scheme s2color
hist mag, name(a2, replace)

set scheme s1mono
hist mag, name(a3, replace)

set scheme s2mono
hist mag, name(a4, replace)

set scheme economist
hist mag, name(a5, replace)

set scheme sj
hist mag, name(a6, replace)


graph combine a1 a2 a3 a4 a5 a6, title("Diferentes esquemas de gráfico")