************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 5_simulando_un_proceso_MA.do
* OBJETIVO: Simulando un proceso MA
************

*Preámbulo:

set more off
clear
set seed 1
global T=50
set obs $T
gen t=_n
tsset t
**************

* 	Creamos un programa para simular las series 
* Inicio del programa

capture program drop DGP
program define DGP

capture drop et 
gen et = rnormal(0,1)
gen yt$dgp =.
replace yt$dgp =1 in 1

forvalues i=2(1)$T {
quietly replace yt$dgp = $alpha0 + $alpha1 * et[`i'-1] + et[`i'] in `i'
}

end
* Fin del programa

* Proponemos algunos valores para simular las series
capture drop yt*
global alpha0=1
global alpha1=0.5

forvalues dgp=1(1)5 {
gl dgp=`dgp'
DGP
}
*

tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("MA(1), {&alpha}{subscript:0}= $alpha0 {&alpha}{subscript:1}= $alpha1")


* Proponemos otros valores para simular las series
capture drop yt*
global alpha0=1
global alpha1=0.95

forvalues dgp=1(1)5 {
gl dgp=`dgp'
DGP
}
*

tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("MA(1), {&alpha}{subscript:0}= $alpha0 {&alpha}{subscript:1}= $alpha1")
