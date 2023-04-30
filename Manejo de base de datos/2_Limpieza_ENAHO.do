
/*En este do file prepararemos una base con el módulo 100 y el  módulo Sumaria, seleccionaremos unas variables de interés, realizaremos un merge y procederemos a guardar nuestra nueva base*/

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar directorio

**********************
use "enaho01-2020-100", clear

br // visualizarremos las variables y seleccionaremos las que nos interesan

*Con el comando Keep mantendremoslas variables con las que nos interesa trababajar

keep conglome vivienda hogar ubigeo dominio estrato  factor07 nbi1 nbi2 nbi3 nbi4 nbi5 

/*Siempre se debe mantener las variable conglome vivienda hogar en los modulos a nivel de hogar y conglome vivienda hogar codperso en los modulos a nivel de persona para poder realizar el merge, las variables dominio y ubigeo nos permiten en la ENAHO a realizar las variables de corte, mientras que las variables factor07 y estrato nos ayudan a establecer el diseño muestral*/

*Realizaremos merge con el módulo de sumaria.

merge 1:1 conglome vivienda hogar using "sumaria-2020.dta", keepus (pobreza mieperho)

drop if _merge!=3
drop _merge

/*Hasta este punto puedes seguir haciendo merge con otras bases según las variables que necesites o puedes proceder a trabajar mejorando más tu base de datos como renombrando variables, recodificando tus variables o generando nuevas variable para luego procedera a guardar tu do file y base de datos*/

save "nuevabase_1", replace // dirección y nombre de archivo.

