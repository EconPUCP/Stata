************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_Logit_ordenado.do
* OBJETIVO: Logit Ordenado
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data" // cambiar directorio

*************

use "data_modelo_multinomial.dta", clear
describe
tab estado_salud

******************************************
*Estimación del modelo logit ordenado
*******************************************

*Estimación del modelo 
ologit estado_salud edad n_enf_cro ingresos 

*Predict
predict mala buena excelente,pr 
sum mala buena excelente
dotplot mala buena excelente if e(sample)//gráficamos la distribución de las probabilidades para cada estado de salud.

*efectos marginales
mfx, predict(outcome(3))
margins, dydx(*) predict(outcome(3)) post atmeans //*opción 2
 
 
******************************************
*Estimación del modelo probit ordenado
******************************************

*Estimación del modelo 
oprobit estado_salud edad n_enf_cro ingresos 

*Predict
predict mala buena excelente,pr 
sum mala buena excelente


*efectos marginales
mfx, predict(outcome(3))
margins, dydx(*) predict(outcome(3)) post atmeans //*opción 2