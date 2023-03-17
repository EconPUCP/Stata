************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_Logit_multinomial.do
* OBJETIVO: Logit Multinomial
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar directorio

*************
use "base_logit_multinomial.dta"

describe 
tab dedica
tab dedica, nolabel

*Estimando el modelo logit multinomial
mlogit dedica sexo edad conv_cas ing_familiar, base(1)
estimates store logit_m1

mlogit dedica sexo edad conv_cas ing_familiar, base(2) // realizamos un cambio de base
estimates store logit_m2


* Estimamos el promedio de efectos marginales
estimates restore logit_m1   
margins, dydx(*) pr(out(1)) 
margins, dydx(*) predict(outcome(1))

margins, dydx(*) pr(out(2)) // seleccionando otras bases
margins, dydx(*) pr(out(3)) 
margins, dydx(*) pr(out(4)) 

* Estimamos los efectos marginales en el promedio

estimates restore logit_m  
margins, dydx(*) atmeans pr(out(1))


*considerando valores especificos
margins, at(ing_familiar=(10000(5000)40000)) predict(outcome(2)) 
marginsplot, name(estudia, replace) title("Consideremos valores específicos")
