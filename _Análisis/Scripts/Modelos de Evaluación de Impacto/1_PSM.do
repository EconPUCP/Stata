************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_PSM.do
* OBJETIVO: Propensity Score Matching
************

*Preámbulo

cd ""

*************

use "", clear

* Vemos la correlación entre las variables
twoway ///
(scatter x1 x2 y, msize(*0.4 *0.4) mcolor(red blue)) ///
(lfit x1 y, lcolor(red)) (lfit x2 y, lcolor(blue)) ///
,legend(order(1 "x1" 2 "x2"))

reg y x1 x2

* Diferencia de medias
ttest y, by(t)

twoway ///
(kdensity y if t == 1, lcolor(red)) ///
(kdensity y if t == 0, lcolor(blue)) ///
, legend(order(1 "Tratado" 2 "Control" ))

* Usamos psmatch para estimar el efecto del tratamiento

* ssc install psmatch2 para instalar el paquete
psmatch2 t x1 x2, out(y) ate

* Podemos estimar el mismo resultado usando teffects
teffects psmatch (y) (t x1 x2, probit), atet nn(10)

* Usamos emparejamiento por kernel con distribución normal
psmatch2 t x1 x2, out(y) ate kerneltype(normal)