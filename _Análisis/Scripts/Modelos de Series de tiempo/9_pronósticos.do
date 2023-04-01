************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 9_pronósticos.do
* OBJETIVO: Prónosticos
************

*Preámbulo

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data"

************

use "Mensuales_bcrp"
tsset date 

* Forecasting

tsappend, add(24)	// Expandimos la base
gen ti_g = (ti - l12.ti)/l12.ti 
arima ti_g, ar(1 3 6 7 12 13) // Rezago 1, 2, 6, 7, 12 y 13
estimates store ar

forecast create arma, replace
forecast estimates ar
forecast describe
forecast solve

* Grafiquemos las series

twoway ///
(tsline f_ti_g if tin(2020m6, 2022m5) , lcolor(red)) ///
(tsline ti_g , lcolor(blue)) ///
,legend(off) ttitle("") ytitle("%") tline(2020m5) ///
 tlabel(1995m7(12)2022m5,grid labsize(*0.5) angle(60)) ///
 title("Tasa de Crecimiento de los Términos de Intercambio")
