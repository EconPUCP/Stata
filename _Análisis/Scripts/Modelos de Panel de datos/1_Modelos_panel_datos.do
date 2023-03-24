************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_Modelos_panel_datos.do
* OBJETIVO: Modelos de panel de datos
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data"

************

use "panel_enaho_2013_2017.dta", clear

* Declara la base de datos como datos panel
sort id año
xtset id año
xtdescribe

*limpiamos los missings o valores perdidos de la data.
drop if año == . | lsalario == . | edad == . | raza == .  | escolaridad == . | sexo == . | experiencia == .  | urbano == . | zona == .
xtdescribe

*Aplicaremos el comando  xtbalance
ssc install xtbalance // este comando debe ser instalado
xtbalance, range(2013 2017) miss(id año lsalario edad raza escolaridad sexo experiencia urbano zona)
xtdescribe

xtsum lsalario edad raza escolaridad sexo experiencia urbano zona

*==================
* Pooled OLS estimator
*==================

eststo pooled_ols: reg lsalario raza escolaridad sexo experiencia urbano i.zona

*=============================
*Estimación por efectos fijos
*=============================

* LSDV
eststo lsdv: reg lsalario raza escolaridad sexo experiencia urbano i.zona i.id

* FE
eststo fe: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, fe

* LSDV -AREG
eststo alsdv: areg lsalario raza escolaridad sexo experiencia urbano ib4.zona, absorb(id)

estimates table lsdv fe alsdv, drop(i.id)

*==================================
*Estimación por efectos temporales
*==================================

* LSDV
eststo lsdv_it: reg lsalario raza escolaridad sexo experiencia urbano ib4.zona i.id i.año

* FE
eststo fe_it: xtreg lsalario raza escolaridad sexo experiencia urbano ib4.zona i.año, fe

* LSDV -AREG
eststo alsdv_it: areg lsalario raza escolaridad sexo experiencia urbano ib4.zona i.año, absorb(id)

estimates table lsdv_it fe_it alsdv_it, drop(i.id i.año)

*==================================
*Estimación por efectos aleatorios
*==================================

* Random effects estimator
eststo re: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, re

	

	
	
			