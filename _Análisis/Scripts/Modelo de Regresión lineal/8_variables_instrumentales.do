************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 8_variables_instrumentales.do
* OBJETIVO: Analizar los supuestos de las VI
************
 
clear all
use "http://fmwww.bc.edu/ec-p/data/wooldridge/openness", clear

* Condición de relevancia
eststo: ivreg2 inf (open = lland) lpcinc, first

* Condición de relevancia con sobreidentificación
eststo: ivreg2 inf (open = lland oil) lpcinc
