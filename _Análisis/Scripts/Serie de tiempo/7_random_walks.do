************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 7_simulación_random_walks.do
* OBJETIVO: Random walks - Paseos aleatorios
************
	
*Preámbulo:

set more off
clear
set seed 1
global T=50
set obs $T
gen t=_n
tsset t

**********

* Si el parámetro rho =1 se tiene raíz unitaria en la serie
forvalues j=1(1)5 {

	gen et`j'=rnormal(0,1)
	gen yt`j'=.
	replace yt`j'=et`j' in 1
	global rho=1

	forvalues i=2(1)$T {
		quietly replace yt`j'= $rho * yt`j'[`i'-1]+et`j'[`i'] in `i'
	}
}
*

tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("AR(1), {&rho}= $rho")

* Comparemos un AR(1) bajo distintos valores de coeficiente.

gen e_t=rnormal(0,1)

forvalues j=2(2)10 {

	gen y_t`j'=.
	replace y_t`j'=e_t in 1
	global rho=`j'/10

	forvalues i=2(1)$T {
		quietly replace y_t`j' = $rho * y_t`j'[`i'-1]+e_t[`i'] in `i'
	}
}
*

tsline yt*, ttitle("") ytitle("") ///
legend(order(1 "{&rho}= 0.2" 2 "{&rho}= 0.4" 3 "{&rho}= 0.6" 4 "{&rho}= 0.8" 5 "{&rho}= 1" ) ///
 cols(5)) title("AR(1)")


