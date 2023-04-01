************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_PSM.do
* OBJETIVO: Propensity Score Matching
************

use "http://www.stata-press.com/data/r16/cattaneo2.dta", clear


* Diferencia de medias
ttest bweight, by(mbsmoke)

twoway (kdensity bweight if mbsmoke == 0, lcolor(red)) (kdensity bweight if mbsmoke == 1, lcolor(blue)), legend(order(1 "Tratado" 2 "Control" ))

* Usando el comando psmatch para estimar el efecto del tratamiento
ssc install psmatch2
psmatch2 mbsmoke mmarried c.mage##c.mage medu fbaby, out(bweight) ate

*Usando el comando teffects
teffects psmatch (bweight) (mbsmoke mmarried c.mage##c.mage medu fbaby, probit), atet nn(1)

* Usamos emparejamiento por kernel con distribución normal
psmatch2 mbsmoke mmarried mage medu fbaby, out(bweight) ate kerneltype(normal)