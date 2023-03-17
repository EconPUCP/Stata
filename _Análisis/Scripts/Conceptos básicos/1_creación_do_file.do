************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_creación_do_file.do
* OBJETIVO: Creación de do-file
************

*Preambulo 

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // Se debe cambiar por la dirección donde se encuentra tu base de datos

*************

* Creamos un do-file escribiendo directamente en el editor.
* Tomemos el siguiente ejemplo:

use "sumaria-2018.dta", clear 
tabulate pobreza
histogram ga03hd
kdensity ga03hd

