*******************************************
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_master_database.do
* OBJETIVO: Creación de la base principal
*******************************************

* TESIS: Desigualdades horizontales entre las personas con discapacidad de movilidad en el Perú : Brechas en la situación de pobreza multidimensional según la procedencia étnica
* AUTOR:  Barrantes Gamba, Nicolás


* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:\Users\Usuario\Desktop\Replica Nicolas" // cambiar directorio
global data "$root/data"
global cleaned "$root/cleaned"


*================================
* CREACIÓN DE LA BASE PRINCIPAL
*-===============================


* Modulo 207: Caracteristicas de las personas con discapacidad
*================================================================

use "$data/CAP_100_DISCAPACIDAD", clear
*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P103 P104 P105 P106 P108 P109_1 P109_2 P109_3 Reg_Nat Area Metrop NOMBREDD FACTOR_PCD
*Ordenamos y guardamos
sort P01 P06 P11 P14
save "$cleaned/caracteristicas_de_las_personas.dta", replace

* Modulo 208: Caracteristicas de la Población total
*===================================================
use "$data/CAP_100_POBLACION TOTAL", clear

*Crearemos la variable de miembros por hogar 
egen num_hogar=group(P06 P11 P14)          
gen huno=1                        
egen mieperhog=sum(huno), by(P06 P11 P14)   
drop huno

*Crearemos la variable de proporción de miembros que tienen discapacidad
egen pcd_hogar = total(P210==1), by(P06 P11 P14) 
gen proporcion_pcd_hogar = pcd_hogar/mieperhog

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P103 P104 P105 P106 P107 P108 P109_1 P109_2 P109_3 P210 Reg_Nat Area Metrop NOMBREDD mieperhog

*Ordenamos y guardamos
sort P01 P06 P11 P14
save "$cleaned/caracteristicas_población_total.dta", replace

* Modulo 209: Clasificación de las Limitaciones
*================================================
use "$data/CAP_200_DISCAPACIDAD", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P105 P106 P203 P204 P205 P206 P207 P208 P209 P209_O P210

*Ordenamos y guardamos
sort P01 P06 P11 P14
save "$cleaned/clasificación_de_las_limitaciones.dta", replace

* Modulo 210: Caracteristicas de la vivienda y del hogar
*========================================================
use "$data/CAP_300_HOGAR Y VIVIENDA", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 NOMBREDD P301 P302 P302_1 P303 P303_1 P304 P306 P307 P309 P310 P311 P312 P313_12 P313_13 P313_14 P313_15 P313_16

*Ordenamos y guardamos
sort P01 P06 P11 P14
save "$cleaned/caracteristicas_vivienda_hogar.dta", replace

* Modulo 211: Características de las Limitaciones
*=================================================
use "$data/CAP_400_LIMITACIONES", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P105 P106 P400_1 P402_1 P402_2 P402_3 P402_4 P402_5 P402_6 P403 P405 P407 P410 P412 P414 P416 P418 P420 P421 P423 P424 P426 P426A P427 P430 

*Ordenamos y guardamos
sort P01 P06 P11 P14 
save "$cleaned/caracteristicas_de_las_limitaciones.dta", replace

* Modulo 212: Educación
*=======================
use "$data/CAP_500_EDUCACION", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P105 P106 P502 P522 P522_1 P523 

*Ordenamos y guardamos
sort P01 P06 P11 P14 
save "$cleaned/educación.dta", replace

* Modulo 213: Salud
*===================
use "$data/CAP_600_SALUD", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P601_1 P601_2 P601_3 P601_4 P601_5 P602_01 P602_02 P602_03 P602_04 P602_05 P602_06 P602_07 P602_08 P602_09 P602_10 P602_11 P602_12 P602_13 P602_14 P602_15 P605 P606 P607_01 P607_02 P607_03 P607_04 P607_05 P607_06 P607_07 P607_08 P607_09 P607_10 P607_11 P607_12 P607_13 P607_14 P607_15 P611 P612_1 P612_2 P612_3 P612_4 P612_5 P612_6 P612_7 P619 

*Ordenamos y guardamos
sort P01 P06 P11 P14 
save "$cleaned/salud.dta", replace

* Modulo 214: Empleo e ingreso
*==============================
use "$data/CAP_700_EMPLEO", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P701 P702 P703 P704_01 P704_02 P704_03 P704_04 P704_05 P704_06 P704_07 P704_08 P704_09 P704_10 P704_11 P704_12 P704_13 P733 P734

*Ordenamos y guardamos
sort P01 P06 P11 P14 
save "$cleaned/empleo.dta", replace

* Modulo 215: Accesibilidad
*===========================
use "$data/CAP_800_ACCESIBILIDAD", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P801_1 P801_2 P801_3 P801_4

*Ordenamos y guardamos
sort P01 P06 P11 P14 
save "$cleaned/accesibilidad.dta", replace

* Modulo 216: Integración social y bienestar
*============================================
use "$data/CAP_900_INTEGRACION", clear

*Seleccioneamos las variables de interés
keep P01 P06 P11 P14 P101 P901 P902_1 P902_2 P902_3 P902_4 P902_5 P902_6 P904_1 P904_2 P904_3 P904_4 P904_5 P904_6 P904_7 P911 P912_1 P912_2 P912_3 P916_01 P916_02 P916_03 P916_04 P916_05 P916_06 P916_07 P916_08 P916_09 P916_10 P916_11 P916_12 P916_13 P916_14 P916_15 P916_16 P916_17 P916_18 

*Ordenamos y guardamos
sort P01 P06 P11 P14 
save "$cleaned/integración_social", replace


*================================
* MERGE DE LAS BASES DE DATOS
*-===============================

use "$cleaned/caracteristicas_de_las_personas.dta"
sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/clasificación_de_las_limitaciones.dta", nogen 

sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/caracteristicas_de_las_limitaciones.dta", nogen 

sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/educación.dta", nogen 

sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/salud.dta", nogen  

sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/empleo.dta", nogen 

sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/accesibilidad.dta", nogen 

sort P06 P11 P14
merge 1:1 P01 P06 P11 P14 P101 using "$cleaned/integración_social.dta", nogen 

sort P06 P11 P14
merge 1:m P01 P06 P11 P14 P101 P103 P104 P105 P106 P108 P109_1 P109_2 P109_3 using "$cleaned/caracteristicas_población_total.dta"
drop if _m!=3
drop _m

sort P06 P11 P14
merge m:1 P01 P06 P11 P14 using "$cleaned/caracteristicas_vivienda_hogar.dta"
drop if _m!=3
drop _m 

*================================
* GUARDANDO ARCHIVOS PRINCIPAL
*-===============================

save "$cleaned/data.dta", replace

erase "$cleaned/caracteristicas_de_las_personas.dta"
erase "$cleaned/clasificación_de_las_limitaciones.dta"
erase "$cleaned/caracteristicas_de_las_limitaciones.dta"
erase "$cleaned/educación.dta"
erase "$cleaned/salud.dta"
erase "$cleaned/empleo.dta"
erase "$cleaned/accesibilidad.dta"
erase "$cleaned/integración_social.dta"
erase "$cleaned/caracteristicas_población_total.dta"
erase "$cleaned/caracteristicas_vivienda_hogar.dta"
