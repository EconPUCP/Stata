************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 6_prueba_de_hiótesis.do
* OBJETIVO: Contraste de hipótesis
************

* Preámbulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd


************

use "enaho01a-2019-500"

svyset conglome [pweight = fac500a], strata(estrato)

* Nota: no se está considerando el diseño muestral
ttest p208a, by(p207)	

* Comparamos la edad promedio con un valor fijo, sin considerar el diseño muestral
mean p208a
ttest p208a==42.5

* Test de medias, considerando diseño muestral 
svy: mean p208a, over(p207)  coeflegend

test _b[hombre] = _b[mujer] // Usando el comando test
lincom _b[hombre] - _b[mujer] // Usando el comando lincom
*return list
display (r(estimate)/r(se))^2 // Comparamos el F en ambos casos

