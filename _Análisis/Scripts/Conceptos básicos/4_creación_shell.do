************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 4_creación_shell.do
* OBJETIVO: Crear la cáscara de una base de datos
************

*Crear la cáscara de una base de datos


* Fijamos el número de observaciones

clear // Limpiamos el navegador de datos previos
set obs 12 // Se consideran solo 100 filas

gen value =.  // Valor a almacenar *estamos generando una variable vacia*

gen note = "" // Nota del valor almacenado se pone comilla porque trabajaremos con letra

gen mes = _n // Mes *se genera con n con el numero de cada espacio*

/* Reemplazamos los datos para cada mes 	*/

* Enero
replace value = 0.2 if mes == 1

replace note = "Los archivos históricos indican que ...." if mes == 1

* Febrero
replace value = 0.4 if mes == 2

replace note = "A diferencia del mes previo, ahora ..." if mes == 2