************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_manipulacióndevariables.do
* OBJETIVO: Comandos de manipulación
************

* Preambulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar dirección donde tengas tu base de datos
global Canadá "_Canadá.dta"


**************************************************

* Cargamos la base de datos haciendo uso del global

use "$Canadá", clear

generate gap = flife - mlife

gen tipo = "" /*estamos creando una variable vacia*/
replace tipo = "Pais" 		if place == "Canada"
replace tipo = "Territorio" if place == "Yukon"         | place == "Northwest Territories"
replace tipo = "Provincia"  if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
							   place == "New Brunswick" | place == "Quebec" 	 		  | place == "Ontario" 		| ///
							   place == "Manitoba"		| place == "Saskatchewan"		  | place == "Alberta"		| ///
							   place == "British Columbia"

							   
							   					   
* Eliminemos algunas observaciones de distintas maneras

use "$Canadá", clear

generate gap = flife - mlife

gen tipo = ""
replace tipo = "Pais" 		if place == "Canada"
replace tipo = "Territorio" if place == "Yukon"         | place == "Northwest Territories"
replace tipo = "Provincia"  if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
							   place == "New Brunswick" | place == "Quebec" 	 		  | place == "Ontario" 		| ///
							   place == "Manitoba"		| place == "Saskatchewan"		  | place == "Alberta"		| ///
							   place == "British Columbia"

drop mlife flife /*eliminamos por columna*/

drop if tipo == "Territorio" /*eliminamos por condición*/

drop in 1 /*eliminamos por ubicación*/


* Repitamos el ejercicio anterior pero usando el comando keep

use "$Canadá", clear

generate gap = flife - mlife

gen tipo = ""
replace tipo = "Pais" 		if place == "Canada"
replace tipo = "Territorio" if place == "Yukon"         | place == "Northwest Territories"
replace tipo = "Provincia"  if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
							   place == "New Brunswick" | place == "Quebec" 	 		  | place == "Ontario" 		| ///
							   place == "Manitoba"		| place == "Saskatchewan"		  | place == "Alberta"		| ///
							   place == "British Columbia"

keep place pop unemp gap tipo
 
keep if tipo == "Provincia" | tipo == "Pais" 

keep in 2/11

* Usando el comando by

use "$Canadá", clear

gen tipo = .
replace tipo = 1 if place == "Canada"
replace tipo = 2 if place == "Yukon"         | place == "Northwest Territories"
replace tipo = 3 if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
					place == "New Brunswick" | place == "Quebec" 	 		   | place == "Ontario" 	 | ///
					place == "Manitoba"		 | place == "Saskatchewan"		   | place == "Alberta"		 | ///
					place == "British Columbia"

bysort tipo: summ pop unemp


* Usando etiquetas en Stata

use "$Canadá", clear

*Etiquetamos la base de datos
label data "Esta base de datos contiene información acerca del desempleo y las expectativas de vida por género en Canadá."

*Etiquetamos cada variable en la base de dato
label variable place "Lugar, puede ser país, territorio o provincia"

label variable pop   "Población, en miles de personas"

label variable unemp "Tasa de desempleo"

label variable mlife "Expectativa de vida para el hombre"

label variable flife "Expectativa de vida para la mujer"

* Creamos la variable tipo como número 
gen tipo = .
replace tipo = 1 if place == "Canada"
replace tipo = 2 if place == "Yukon"         | place == "Northwest Territories"
replace tipo = 3 if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
					place == "New Brunswick" | place == "Quebec" 	 		   | place == "Ontario" 	 | ///
					place == "Manitoba"		 | place == "Saskatchewan"		   | place == "Alberta"		 | ///
					place == "British Columbia"

label define tipo_l 1 "País" 2 "Territorios" 3 "Provincias"
label values tipo tipo_l

* Comando recode

use "$Canadá", clear

gen		capital 	= 1 if place == "Ontario"
replace capital		= 0 if place != "Ontario"

recode capital (0=1) (1=2) 

 
* Comando if 

use "$Canadá", clear

generate gap = flife - mlife

gen 	unemp_place = 1 if unemp>=10 & unemp !=.
replace unemp_place = 0 if unemp<10	 & unemp !=.

gen		capital 	= 1 if place == "Ontario"
replace capital		= 0 if place != "Ontario"

replace unemp 		= 0 if unemp == .


* Comando in

use "$Canadá", clear

generate gap = flife - mlife

gen 	unemp_place = 1 in 1/6
replace unemp_place = 0 in 7/13

gen		capital 	= 1 in 7
replace capital		= 0 in 1/6 
replace capital 	= 0 in 8/13

replace unemp 		= 0 in 12/13


*Ahora ordenemos los datos de acuerdo al desempleo y usemos el comando in

use "$Canadá", clear

sort unemp

generate gap = flife - mlife

gen 	unemp_place = 1 in 1/6
replace unemp_place = 0 in 7/13

gen		capital 	= 1 in 7
replace capital		= 0 in 1/6 
replace capital 	= 0 in 8/13

replace unemp 		= 0 in 12/13
