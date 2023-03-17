************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_creación_log_file.do
* OBJETIVO: Creación de log-file
************

*SMCL
log using "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Results/Mi_primer_log", replace 
use "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data/sumaria-2018.dta", clear
tabulate pobreza
histogram ga03hd
kdensity ga03hd

log close 

*LOG

log using "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Results/Mi_primer_log", replace tex // empieza a grabar el log-file

use "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data/sumaria-2018.dta", clear
tabulate pobreza
histogram ga03hd
kdensity ga03hd

log close // Se cierra el log-file 