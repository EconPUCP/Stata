*******************************************
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_Crear_base_de_datos.do
* OBJETIVO: Creación de la base principal
*******************************************

* TESIS: Para nunca más volver: un análisis de la dinámica de la pobreza en el Perú 2007 - 2011
* AUTOR:  Cozzubo Chaparro, Angelo

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Replica Cozzubo"
global data "$root/data"
global cleaned "$root/cleaned"


*================================
* CREACIÓN DE LA BASE PRINCIPAL
*-===============================

* Modulo 100: Características de la vivienda y del hogar
*========================================================
use num_hog cong vivi result_* nbi1_* nbi2_* nbi3_* nbi4_* nbi5_* p111_* t110_* p1141_* p1121_* p110_* using "$data/enaho01_2007_2011_100_panel.dta", clear

foreach x in 07 08 09 10 11{
rename *`x' *20`x'
}

* reshape → transformar la estructura de un conjunto de datos, cambiando su formato de "ancho" a "largo" o viceversa    
reshape long result_ nbi1_ nbi2_ nbi3_ nbi4_ nbi5_ p111_ t110_ p1141_ p1121_ p110_, i(num_hog cong vivi) j(año)
	

*Ordenando 
sort num_hog cong vivi año

save "$cleaned/caracteristicas_del_hogar.dta", replace

* Módulo 300 - Educación
*========================
use num_per cong vivi p203_* p203a_* p203b_* p204_* p206_* p207_* p208a_* p209_* p300a_* p301a_* p301b_* p301c_* p301d_* hog_* num* using "$data/enaho01a_2007_2011_300_panel.dta", clear

foreach x in 07 08 09 10 11{
rename *`x' *20`x'
}

reshape long p203_ p203a_ p203b_ p204_ p206_ p207_ p208a_ p209_ p300a_ p301a_ p301b_ p301c_ p301d_ hog_ num, i(num_per cong vivi) j(año)
	

*Ordenando 
sort num_per cong  vivi año

*Creamos la variable num_hog para poder hacer merge con los módulos a nivel de hogar
egen num_hog=max(num), by(cong vivi num_per)

save "$cleaned/educación.dta", replace


* Módulo 400 - Salud
*=====================
use num_per cong vivi p4191_* p4192_* p4193_* p4194_* p4195_* p4196_* p4197_* p4198_* p4199_* hog_* num* using  "$data/enaho01A-2007-2011-400-panel.dta", clear

foreach x in 07 08 09 10 11{
rename *`x' *20`x'
}

reshape long p4191_ p4192_ p4193_ p4194_ p4195_ p4196_ p4197_ p4198_ p4199_ hog_ num, i(num_per cong vivi) j(año)


*Ordenando 
sort num_per cong vivi año

*Creamos la variable num_hog para poder hacer merge con los módulos a nivel de hogar
egen num_hog=max(num), by(cong vivi num_per)

save "$cleaned/salud.dta", replace


* Módulo 500 - Empleo e Ingresos
*================================
use num_per cong vivi p505_* p506_* p513a1_* ocu500_* hog_* num* using "$data/enaho01A-2007-2011-500-panel.dta", clear

foreach x in 07 08 09 10 11{
rename *`x' *20`x'
}

reshape long p505_ p506_ p513a1_ ocu500_ hog_ num, i(num_per cong vivi) j(año)

*Ordenando 
sort num_per cong  vivi año

*Creamos la variable num_hog para poder hacer merge con los módulos a nivel de hogar
egen num_hog=max(num), by(cong vivi num_per)

save "$cleaned/empleo.dta", replace

* Modulo 34 - Sumaria 
*=====================

use num_hog cong vivi mieperho_* pobreza_* estrato_* fac_* dominio_* ubigeo_* gashog2d_* linpe_* linea_* inghog1d_* hpan0708 hpan0809 hpan0910 hpan1011 hpan0711 using "$data/sumaria_2007_2011_panel.dta", clear

foreach x in 07 08 09 10 11{
rename *`x' *20`x'
}

reshape long pobreza_ estrato_ mieperho_  fac_ dominio_ ubigeo_ gashog2d_ linpe_ linea_ inghog1d_ hpan0708_ hpan0809_ hpan0910_ hpan1011_ hpan0711_, i(num_hog cong vivi) j(año)

*Ordenando 
sort num_hog año

save "$cleaned/sumaria.dta", replace

*================================
* MERGE DE LAS BASES DE DATOS
*-===============================

use "$cleaned/salud.dta",clear

merge 1:1 num_per num_hog cong vivi año using "$cleaned/empleo.dta", nogenerate

merge 1:1 num_per num_hog cong vivi año using "$cleaned/educación.dta", nogenerate

merge m:1 num_hog cong vivi año using "$cleaned/caracteristicas_del_hogar.dta", nogenerate

merge m:1 num_hog cong vivi año using "$cleaned/sumaria.dta", nogenerate
 
*Nos quedamos solo con los miembros del hogar
drop if p204_==2
*drop if num_per==.

*Nos quedamos solo con las encuestras completas e incompletas
*drop if  result_==3 | result_==4 | result_==5 | result_==7 | result_==.


*================================ 
* GUARDANDO ARCHIVO PRINCIPAL
*-===============================

save "$cleaned/data", replace

/*
erase "$cleaned/salud.dta" 
erase "$cleaned/educación.dta"
erase "$cleaned/empleo.dta" 
erase "$cleaned/caracteristicas_del_hogar.dta"
erase "$cleaned/sumaria.dta"