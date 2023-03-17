************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 5_Importar_datos.do
* OBJETIVO: Importar datos en distintos formatos
************

*Preámbulo

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // coloca la dirección donde se encuentra tu base de datos


************

* Usamos el comando 'use' para cargar una base .dta

use "sumaria-2020.dta", clear	// Cargamos una base almacenada en la computadora
br

* Cargamos una base almacenada en internet

use "http://fmwww.bc.edu/ec-p/data/wooldridge/openness", clear // 
br

* Ahora, cargemos una base en ambos formatos de Excel

import excel using "relaciones_extramaritales.xlsx", clear firstrow 
br 
 
import excel using "relaciones_extramaritales.xlsx", clear firstrow  sheet ("Hoja2")
br

import excel using "relaciones_extramaritales.xlsx", clear sheet ("Hoja2") cellrange(A2:D10) // cellrange se usa para seleccionar un rango especifico
br


/* 
- Si se tiene un archivo excel con muchas hojas y no se especifica la opción sheet, Stata cogerá la primera hoja	
- El comando br nos permite ver la base de datos que se ha cargado
*/
	
******************	
* Otros formatos

*Descargaremos la Encuesta Demográfica y de Salud Familiar - ENDES que se encuentra en los microdatos del INEI en los formatos csv, sac y dbf.

import delimited using "RECH0.csv", delimiter(",") clear // formatos .csv
insheet delimited using "RECH0.csv", delimiter(",") clear // formatos .csv
import spss using "RECH0.sav"	// formatos .sav
import dbase using "RECH0.dbf"  // formatos .dbf 

*importemos datos en formato txt  
import delimited using "IOP_1118.txt", delimiter(",") clear // formatos .txt
insheet delimited using "IOP_1118.txt", delimiter(",") clear // formatos .txt

