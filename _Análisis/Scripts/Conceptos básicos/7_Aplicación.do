************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 7_Aplicación.do
* OBJETIVO: Aprender a fusionar varios modulos de la ENAHO
************


*Preambulo 

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // Se debe cambiar por la dirección donde se encuentra tu base de datos

/* La ENAHO, la encuesta más utilizada en el Perú, tiene distintas unidades de observación de acuerdo al módulo específico. 
Algunas son a nivel de persona, a nivel de hogar, nivel de vivienda, por lo que hay tener doble cuidado al momento de manipular los datos de encuestas de hogar.*/

************
*merge 1:1 
************

*Acá fusionaremos el módulo 1: caracteristicas de la vivienda y del hogar con Sumaria: variables calculadas*

use "enaho01-2020-100.dta", clear

merge 1:1 conglome vivienda hogar using "sumaria-2020.dta"
br
describe


************
*merge 1:m 
************

use "enaho01-2020-100.dta", clear

merge 1:m conglome vivienda hogar using "enaho01-2020-200.dta"


************
*merge m:1 
************

use enaho01-2020-200.dta, clear 
merge m:1 conglome vivienda hogar using enaho01-2020-100.dta

/** En el caso de datos no emparejados del módulo 100, estos se deben
	a que el módulo 100 incluye a todo el padrón de viviendas que al inicio  
	de la encuesta se esperaba encontrar*/



