************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 5_Aplicación.do
* OBJETIVO: Incidencia de la pobreza monetaría ENAHO 2020
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" //cambiar cd

*************

use "pwt1001.dta"

describe

* Creamos nuevas variables 
gen GDB=rgdpna/pop // PBI per cápita
gen logGDP=ln(rgdpna/pop) // logaritmo del PBI per cápita
gen logK=ln(rnna/pop) // logaritmo del stock de capital per cápita
gen logTFP=ln(rtfpna) // logaritmo de la productividad total de factores
gen openness=(csh_x-csh_m) // indicador de grado apertura de un país
gen share=csh_i // participación del capital en la formación de la producción
gen labor=emp/pop 
gen humanx=hc // indice del capital humano

* Nos quedamos solo con un conjunto de observaciones de acuerdo al país.

keep if countrycode == "PER" | countrycode == "CHL" | countrycode == "COL"

* Obtenemos los estadísticos descriptivos del PBI per cápita entre los años 2010 y 2019.

bys countrycode: summ GDB if year>= 2010 & year<=2019

*Grafiquemos algunas variables

local paises PER CHL COL
local graph_op `"xtitle("Año") lpattern(solid) lcolor(green) xlabel(1940(10)2020)"'

foreach x of local paises{
	line GDB year if countrycode == "`x'", `graph_op' ytitle("`x'") name("`x'" ,replace)
}
graph combine PER CHL COL, ycommon title("PBI per cápita, miles de USD")

foreach x of local paises{
	line logGDP year if countrycode == "`x'", `graph_op' ytitle("`x'") name("`x'" ,replace)
}
graph combine PER CHL COL, ycommon title("Logaritmo PBI per cápita")

foreach x of local paises{
	line logK year if countrycode == "`x'", `graph_op' ytitle("`x'") name("`x'" ,replace)
}
graph combine PER CHL COL, ycommon title("Logaritmo del stock de capital per cápita")