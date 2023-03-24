************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_selección_de_modelos.do
* OBJETIVO: Selección de modelos para panel de datos
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data"

************

use "panel_enaho_2013_2017.dta", clear

* Declara la base de datos como datos panel
sort id año
xtset id año

*limpiamos los missings o valores perdidos de la data.
drop if año == . | lsalario == . | edad == . | raza == .  | escolaridad == . | sexo == . | experiencia == .  | urbano == . | zona == .

*Aplicaremos el comando  xtbalance
ssc install xtbalance // este comando debe ser instalado
xtbalance, range(2013 2017) miss(id año lsalario edad raza escolaridad sexo experiencia urbano zona)

*=========================================
*Estimación de modelos para panel de datos
*=========================================

* Efectos fijos vs vs Datos agrupados: test F
eststo fe: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, fe // efectos fijos

* Efectos aleatorios vs Datos agrupados: Breusch-Pagan LM test 
quietly xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, re
xttest0
					
* Efectos fijos vs Efectos aleatorios: Hausman test
quietly xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, fe
estimates store fijos
quietly xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, re
estimates store aleatorios
hausman fijos aleatorios

* Efectos fijos vs Efectos aleatorios: testparm
eststo fe: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona i.año, fe
testparm i.año

* Recovering individual-specific effects
quietly xtreg lsalario raza escolaridad sexo experiencia urbano ib4.zona, fe
predict alphafehat, u
sum alphafehat
