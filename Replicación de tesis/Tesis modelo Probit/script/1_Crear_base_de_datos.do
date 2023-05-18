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
global root "C:/Users/Usuario/Desktop/Replica Cozzubo" // cambiar directorio
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

use "$cleaned/caracteristicas_del_hogar.dta",clear

merge 1:1 num_hog cong vivi año using "$cleaned/sumaria.dta", nogenerate

*Nos quedamos solo con las encuestras completas e incompletas
drop if  result_==3 | result_==4 | result_==5 | result_==7 | result_==.


*================================ 
* GUARDANDO ARCHIVO PRINCIPAL
*-===============================

save "$cleaned/data", replace

erase "$cleaned/caracteristicas_del_hogar.dta"
erase "$cleaned/sumaria.dta"
