************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 4_descriptivos.do
* OBJETIVO: Análisis descriptivos
************

*Preámbulo
clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" //cambiar por tu directorio

**************

* Cargamos el módulo 500 de la ENAHO

use "enaho01a-2018-500.dta", clear


* Información descriptiva de la base
describe ocu500

codebook ocu500

inspect  ocu500

* Estadísticos descriptivos de los datos

summ ocu500 i524a1

summ ocu500 i524a1, detail

* Se descarga univar
ssc install univar
univar ocu500 i524a1				

* Tablas de frecuencia 

tabulate ocu500

tabulate dominio ocu500, row

