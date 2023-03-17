************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_Modelo_probabilidad_no_lineal.do
* OBJETIVO: Modelo Logit - Probit
************

*Preámbulo
clear all
sysuse lbw 

*************

describe 

*modelo logit/probit no se estiman por minimos cuadrados ordinarios, se estiman por máxima verosimilitud

*Estimación de los modelos 

logit low age lwt i.race smoke ht, robust // Logit
estimates store logit

probit low age lwt i.race smoke ht, robust // Probit
estimates store probit

esttab logit probit, mtitle("Logit" "Probit") pr2

*Efectos marginales en el promedio de las variables. 

estimates restore logit
margins, dydx(*) post atmeans
est store em_logit_mean

estimates restore probit
margins, dydx(*) post atmeans
est store em_probit_mean

esttab em_logit_mean em_probit_mean , mtitle("Logit" "Probit") title("Efectos marginal en los promedios de las variables") p 

*Efectos marginales promedios. 

estimates restore logit
margins, dydx(*) post
est store em_logit

estimates restore probit
margins, dydx(*) post 
est store em_probit

esttab em_logit em_probit , mtitle("Logit" "Probit") title("Efectos marginal promedio") p 

* Prediccion de probabilidades
est restore logit
predict p_logit

est restore probit
predict p_probit

twoway (line p_logit low, lcolor(blue)	)(line p_probit low, lcolor(red)), legend(	order( 1 "Logit" 2 "Probit"))

*** Odd ratio con el modelo Logit 
logit low age lwt i.race smoke ht, or // odds - ratios

**************************
* Análisis post-estimación 
**************************

estimates restore logit
* Análisis de predicciones correctas:
estat class
estat class,cutoff(0.60)

* Curva de ROC
lroc

* Sensibilidad ante el punto de corte
lsens,genprob(best_cut)
sum best_cut

** Mejor balance:
estat class,cutoff(0.3124726 )

* Medidas de bondad de ajuste
ssc install fitstat

** Corremos las regresiones y guardamos sus resultados de bondad de ajuste:
qui: estimates restore probit
quietly fitstat, saving(prob)

qui: estimates restore logit
quietly fitstat, saving(log)

fitstat, using(prob) force

/* Definiciones más importantes: 
*LR: estadistico chi cuadrado que evalúa todos los coeficientes, excepto el intercepto, son cero.
*AIC: criterio de Akaike. El menor es mejor.
*BIC: criterio bayesiano. El menor es mejor. 
*/
