************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_Estructura_del_proyecto.do
* OBJETIVO: Estructura del proyecto
************

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Proyecto"

* Creando carpeta
*=================
* Creamos tres nuevas carpetas dentro del directorio de trabajo que se llame "codes", "data" y "results"
global data "$root/data"
global data "$root/cleaned"
global codes "$root/script"	
global results "$root/results"

* Informamos a STATA que a partir de este momento se extraerá la información de la carpeta que denominamos "data"

use "$data/base_empleo.dta",clear
