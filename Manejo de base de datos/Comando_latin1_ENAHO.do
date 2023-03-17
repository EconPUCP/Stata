
/*En este do file encontrarás loops para poder corregir 
el problema de las tildes y "Ñ" en los módulos de la 
ENAHO con el comando latin1*/


clear
cd "" // colocar el directorio donde se encuentran tus bases de datos

* Para el módulo de Sumaria*
unicode analyze sumaria-2020.dta  
unicode encoding set "latin1" 
unicode translate sumaria-2020.dta

*Para los otros módulos de la ENAHO
forvalue h=1/2{
unicode analyze enaho01-2020-`h'00.dta
unicode encoding set "latin1" 
unicode translate enaho01-2020-`h'00.dta
}

*Para módulos con terminación a,b.
unicode analyze enaho01a-2020-400.dta
unicode encoding set "latin1" 
unicode translate enaho01a-2020-400.dta
