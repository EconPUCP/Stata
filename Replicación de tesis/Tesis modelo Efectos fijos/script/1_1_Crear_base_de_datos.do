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

*reetiquetamos algunas variables

foreach x of numlist 7/9{
rename result_0`x' result_`x'
rename p111_0`x' p111_`x'
rename t110_0`x' t110_`x' 
rename nbi1_0`x' nbi1_`x' 
rename nbi2_0`x' nbi2_`x'  
rename nbi3_0`x' nbi3_`x' 
rename nbi4_0`x' nbi4_`x' 
rename nbi5_0`x' nbi5_`x' 
rename p1141_0`x' p1141_`x'  
rename p1121_0`x' p1121_`x' 
rename p110_0`x' p110_`x' 
}

* reshape → transformar la estructura de un conjunto de datos, cambiando su formato de "ancho" a "largo" o viceversa    
reshape long result_ nbi1_ nbi2_ nbi3_ nbi4_ nbi5_ p111_ t110_ p1141_ p1121_ p110_, i(num_hog cong vivi) j(año)
	
*Renombrando el  año
recode año (7=2007)(8=2008)(9=2009)(10=2010)(11=2011)

*Ordenando 
sort num_hog cong vivi año

save "$cleaned/caracteristicas_del_hogar.dta", replace

* Módulo 300 - Educación
*========================
use num_per cong vivi p203_* p203a_* p203b_* p204_* p206_* p207_* p208a_* p209_* p300a_* p301a_* p301b_* p301c_* p301d_* hog_* num* using "$data/enaho01a_2007_2011_300_panel.dta", clear

foreach x of numlist 7/9{
rename p203_0`x' p203_`x'
rename p203a_0`x' p203a_`x' 
rename p203b_0`x' p203b_`x' 
rename p204_0`x' p204_`x' 
rename p206_0`x' p206_`x'
rename p207_0`x'  p207_`x' 
rename p208a_0`x' p208a_`x'  
rename p209_0`x'  p209_`x'
rename p300a_0`x' p300a_`x' 
rename p301a_0`x' p301a_`x' 
rename p301b_0`x' p301b_`x' 
rename hog_0`x' hog_`x' 
rename p301c_0`x' p301c_`x'
rename p301d_0`x' p301d_`x'
}

reshape long p203_ p203a_ p203b_ p204_ p206_ p207_ p208a_ p209_ p300a_ p301a_ p301b_ p301c_ p301d_ hog_ num, i(num_per cong vivi) j(año)
	
*Renombrando el  año
recode año (7=2007)(8=2008)(9=2009)(10=2010)(11=2011)

*Ordenando 
sort num_per cong  vivi año

*Creamos la variable num_hog para poder hacer merge con los módulos a nivel de hogar
rename num num_hog 

save "$cleaned/educación.dta", replace


* Módulo 400 - Salud
*=====================
use num_per cong vivi p4191_* p4192_* p4193_* p4194_* p4195_* p4196_* p4197_* p4198_* p4199_* hog_* num* using  "$data/enaho01A-2007-2011-400-panel.dta", clear

foreach x of numlist 7/9{
rename p4191_0`x' p4191_`x'
rename p4192_0`x' p4192_`x' 
rename p4193_0`x' p4193_`x' 
rename p4194_0`x' p4194_`x' 
rename p4195_0`x' p4195_`x'
rename p4196_0`x' p4196_`x' 
rename p4197_0`x' p4197_`x'  
rename p4198_0`x' p4198_`x' 
rename p4199_0`x' p4199_`x'
rename hog_0`x' hog_`x' 
}

reshape long p4191_ p4192_ p4193_ p4194_ p4195_ p4196_ p4197_ p4198_ p4199_ hog_ num, i(num_per cong vivi) j(año)

*Renombrando el  año
recode año (7=2007)(8=2008)(9=2009)(10=2010)(11=2011)

*Ordenando 
sort num_per cong vivi año

*Creamos la variable num_hog para poder hacer merge con los módulos a nivel de hogar
rename num num_hog 

save "$cleaned/salud.dta", replace


* Módulo 500 - Empleo e Ingresos
*================================
use num_per cong vivi p505_* p506_* p513a1_* ocu500_* hog_* num* using "$data/enaho01A-2007-2011-500-panel.dta", clear

foreach x of numlist 7/9{
rename p505_0`x' p505_`x'
rename p506_0`x' p506_`x' 
rename p513a1_0`x' p513a1_`x' 
rename ocu500_0`x' ocu500_`x' 
rename hog_0`x' hog_`x' 
}

reshape long p505_ p506_ p513a1_ ocu500_ hog_ num, i(num_per cong vivi) j(año)

*Renombrando el  año
recode año (7=2007)(8=2008)(9=2009)(10=2010)(11=2011)

*Ordenando 
sort num_per cong  vivi año

*Creamos la variable num_hog para poder hacer merge con los módulos a nivel de hogar
rename num num_hog 

save "$cleaned/empleo.dta", replace

* Modulo 34 - Sumaria 
*=====================

use num_hog cong vivi mieperho_* pobreza_* estrato_* fac_* dominio_* ubigeo_* gashog2d_* linpe_* linea_* inghog1d_* hpan0708 hpan0809 hpan0910 hpan1011 hpan0711 using "$data/sumaria_2007_2011_panel.dta", clear

foreach x of numlist 7/9{
rename mieperho_0`x' mieperho_`x'
rename pobreza_0`x'  pobreza_`x' 
rename estrato_0`x' estrato_`x' 
rename fac_0`x' fac_`x'
rename dominio_0`x' dominio_`x'
rename ubigeo_0`x' ubigeo_`x'
rename gashog2d_0`x' gashog2d_`x'
rename linpe_0`x' linpe_`x'
rename inghog1d_0`x' inghog1d_`x'
rename linea_0`x' linea_`x'
}

reshape long pobreza_ estrato_ mieperho_  fac_ dominio_ ubigeo_ gashog2d_ linpe_ linea_ inghog1d_ hpan0708_ hpan0809_ hpan0910_ hpan1011_ hpan0711_, i(num_hog cong vivi) j(año)

*Renombrando el  año
recode año (7=2007)(8=2008)(9=2009)(10=2010)(11=2011)

*Ordenando 
sort num_hog año

save "$cleaned/sumaria.dta", replace

*================================
* MERGE DE LAS BASES DE DATOS
*-===============================

use "$cleaned/salud.dta",clear

merge 1:1 num_per num_hog cong vivi año using "$cleaned/empleo.dta", nogenerate

merge 1:1 num_per num_hog cong vivi año using "$cleaned/educación.dta", nogenerate

merge m:1 num_hog cong vivi año using "$cleaned/caracteristicas_del_hogar.dta"

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