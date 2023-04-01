************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 8_raíz_unitaria_y_rezagos.do
* OBJETIVO: Test de raíz unitaria - Selección de rezagos
************
*Preámbulo

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data"

************

use "Mensuales_bcrp"
tsset date

* Gráficamos para ver la serie
tsline ti, ytitle("índice (2007 = 100)") ttitle("") ///
title("Términos de Intercambio")

* Augmented Dickey Fuller
dfuller ti, trend

* Phillip Perron
pperron ti, trend

* DF-GLS
dfgls ti, max(6)

* Creamos una serie con la tasa de crecimiento de la variable Mes a Mes
gen ti_g = (ti - l12.ti)/l12.ti

tsline ti_g, ytitle("%") title("") ttitle("") ///
title("Tasa de Crecimiento - Términos de Intercambio")

* Volvemos a usar los test

dfuller ti_g
pperron ti_g
dfgls ti_g, max(6)

/*		Selección de rezagos		*/

* Autocorrelación y Autocorrelación parcial
ac ti_g, title("Autocorrelación")
pac ti_g, title("Autocorrelación Parcial")

corrgram ti_g

* Estimar los modelos

* Creamos una matriz para almacenar los resultados
matrix CritInfor = J(2,7,.) 
matrix colnames CritInfor = Modelo1 Modelo2 Modelo3 Modelo4 Modelo5 Modelo6 Modelo7
matrix rownames CritInfor = AIC BIC

* Estimamos los modelos desde el más simple, aumentando el número de rezagos cada vez

arima ti_g, ar(1) // solo rezago 1
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,1] = aic 
matrix CritInfor[2,1] = bic

arima ti_g, ar(1 3) // Rezago 1 y 3
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,2] = aic 
matrix CritInfor[2,2] = bic

arima ti_g, ar(1 3 6) // Rezago 1, 3 y 6
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,3] = aic 
matrix CritInfor[2,3] = bic

arima ti_g, ar(1 3 6 7) // Rezago 1, 3, 6 y 7
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,4] = aic 
matrix CritInfor[2,4] = bic

arima ti_g, ar(1 3 6 7 12) // Rezago 1, 3, 6, 7 y 12
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,5] = aic 
matrix CritInfor[2,5] = bic

arima ti_g, ar(1 3 6 7 12 13) // Rezago 1, 2, 6, 7, 12 y 13
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,6] = aic 
matrix CritInfor[2,6] = bic

arima ti_g, ar(1 3 6 7 12 13 25) // Rezago 1, 2, 6, 7, 12, 13 y 25
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,7] = aic 
matrix CritInfor[2,7] = bic

matrix list CritInfor

* Analizamos los errores estimados del modelo final

arima ti_g, ar(1 3 6 7 12 13) // Rezago 1, 2, 6, 7, 12 y 13
predict e , resid // residuos estimados
hist e, kdensity kdenopt(lcolor(blue)) normal normopt(lcolor(red))
swilk e

* Forecasting

tsappend, add(24)	// Expandimos la base
 
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
