************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_Estructura_del_proyecto.do
* OBJETIVO: Crear la estructura del proyecto
************
* Este código se usa al inicio de todo proyecto para crear una estructura del proyecto siguiendo los nuevos estándares de replicación y reproducibilidad de código exigidos, entre otros, por la American Economics Association. 
* La American Economics Association Data Editor ha solicitado que se deje de usar "cd" y en lugar de eso se coloque la raíz de la carpeta del proyecto en un macro global (21/02/2022).
* Con la sintaxis "global root" se crea una macro global llamada "root" y se asigna la ruta a esa macro. Esa macro global contendrá la ruta de la carpeta raíz. En adelante, en lugar de escribir la ruta completa, solo será necesario escribir "root". De esa manera se organiza y simplifica el código, y se hace posible que otras personas (o tu mismo) puedan correr todo el código que has producido en otros equipos tan solo con cambiar la ruta asignada a global. 

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Proyecto"

* Creando carpeta
*=================
* Creamos tres nuevas carpetas dentro del directorio de trabajo que se llamen "codes", "data" y "results"
global data "$root/data"
global data "$root/cleaned"
global codes "$root/script"	
global results "$root/results"

* Informamos a STATA que a partir de este momento se extraerá la información de la carpeta que denominamos "data"

use "$data/base_empleo.dta",clear
