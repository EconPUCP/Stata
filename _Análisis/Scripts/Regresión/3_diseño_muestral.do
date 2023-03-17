************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_diseño_muestral.do
* OBJETIVO: Muestreo
************

* Preambulo 

clear all
cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data"

**************************************************
use "enaho01a-2019-500.dta"
 
* Declaramos el diseño muestral
/*
PSU    -> conglome
Weight -> fac500a
Strata -> estrato
*/

svyset conglome [pweight = fac500a], strata(estrato)

svydescribe

*Usamos el prefijo svy: antes del comando de interés para considerar el diseño muestral

svy: tab ocu500
tab ocu500

svy: reg i524a1 p208a i.p207
reg i524a1 p208a i.p207

* Usando subpop para obtener estimado en Lima Metropolitana
gen lima = 1 if dominio==8
replace lima =0 if lima ==.

svy, subpop(lima): reg i524a1 p208a i.p207 /*este es el correcto a usar*/
 reg i524a1 p208a i.p207 if lima ==1 /*el error estandar es distinto y errardo pero los coeficientes correctos*/
 
* Comparamos la regresión simple, solo con pesos y con diseño muestral
* Para usar eststo y esttab debe instalar el paquete estout
ssc install estout
eststo clear
eststo: reg i524a1 p208a i.p207
eststo: reg i524a1 p208a i.p207 [pweight=fac500a]
eststo: svy: reg i524a1 p208a i.p207 /*la manera correcta de estimar*/
esttab

