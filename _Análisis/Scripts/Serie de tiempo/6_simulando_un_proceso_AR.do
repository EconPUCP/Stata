************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 6_simulando_un_proceso_AR.do
* OBJETIVO: Simulando un proceso AR
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

* 	Creamos un programa para simular las series 
* Inicio del programa
capture program drop DGP
program define DGP

capture drop et 
gen et = rnormal(0,1)
gen yt$dgp =.
replace yt$dgp =1 in 1

forvalues i=2(1)$T {
quietly replace yt$dgp = $phi0 + $phi1 * yt$dgp[`i'-1]+et[`i'] in `i'
}

end
* Fin del programa

* Cambiar los valores para simular las series
capture drop yt*
global phi0=1
global phi1=0.5

forvalues dgp=1(1)5 {
global dgp=`dgp'
DGP
}
*

tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("AR(1), {&phi}{subscript:0}= $phi0 {&phi}{subscript:1}= $phi1")