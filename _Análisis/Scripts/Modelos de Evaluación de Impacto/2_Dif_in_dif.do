************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_Dif_in_dif.do
* OBJETIVO: Diferencias en diferencias
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data" // cambiar directorio

*************

* Cargamos la base de datos
use "Panel101.dta", clear

* Creamos algunas variables
gen time = (year>=1994) & !missing(year)
gen treated = (country>4) & !missing(country)
gen did = time*treated

*Estimación del estimar con el comando reg
reg y time treated did

*Usando el método "hastag"
reg y time##treated

* Usando el comando "diff"
ssc install diff  // se debe instalar previamente
diff y, t(treated) p(time)



