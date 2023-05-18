*******************************************
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_Creación_de_variables.do
* OBJETIVO: Creación de la base principal
*******************************************

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Replica Cozzubo" // cambiar directorio
global data "$root/data"
global cleaned "$root/cleaned"


*========================
* CREACIÓN DE VARIABLES
*========================

* Abrir base de datos
*==========================
use "$cleaned/data", clear


* Renombramos algunas variables
rename p*_ p*
rename l*_ l*
rename n*_ n*
rename *o_ *o
rename num_hog hogar
rename cong conglome
rename vivi vivienda
rename result_ result
rename inghog1d_ inghog1d
rename gashog2d_ gashog2d
rename fac_ factor07
rename año aniorec


*Variables de Corte
*===================	
	
* Departamento
g dpto1= real(substr(ubigeo,1,2))
lab var dpto1 "Departamentos"
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" /// 
7 "Callao" 8"Cusco" 9"Huancavelica"  10"Huanuco"  11"Ica" 12"Junin" /// 
13"La Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre de Dios" 18"Moquegua" /// 
19"Pasco" 20"Piura" 21"Puno" 22"San Martin" 23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto1 dpto

* Generamos un identificador para area rural y urbana
replace estrato = 1 if dominio ==8 
recode estrato (1/5=1 "Urbana") (6/8=2 "Rural"), gen(area)
lab var area "Urbana = 1 Rural = 2"

* Dominios con inferencia en ENAHO*
g domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8

label define domin02 1 "Costa urbana" 2 "Costa rural" 3 "Sierra urbana" /// 
4 "Sierra rural" 5 "Selva urbana" 6 "Selva rural" 7 "Lima Metropolitana"
label value domin02 domin02
label var domin02 "Dominios con inferencia ENAHO"

* Región Natural (Costa / Sierra/Selva)
recode dominio (1/3 8 = 1 "Costa") (4/6 = 2 "Sierra") (7 = 3 "Selva"), g(region)

* Regiones Naturales separando LM
g areag = (dominio==8)
replace areag = 2 if dominio >= 1 & dominio <= 7 & area==1
replace areag = 3 if dominio >= 1 & dominio <= 7 & area==2

lab define areag 1 "Lima_Metro" 2 "Resto_Urbano" 3 "Rural" 
label values areag  areag

* Indicador sub conjunto Región Lima y Callao
g limareg=1 if(substr(ubigeo,1,4))=="1501"
replace limareg=2 if(substr(ubigeo,1,2))=="07"
replace limareg=3 if((substr(ubigeo,1,4))>="1502" & (substr(ubigeo,1,4))<"1599")

label define limareg 1 "Lima Prov" 2 "Prov Const. Callao" 3 "Región Lima"
label val limareg limareg

* Redondeo del factor
gen factornd07=round(factor07*mieperho,1)

	
* Generar Departamentos (lima incluye callao)
clonevar dpto = dpto1		
replace dpto=15 if dpto==7 // dpto==7 corresponde al Callao

* Utilizaremos los deflactores	
merge m:1 aniorec dpto using "$data/deflactores_base2020_new.dta"
drop if _m==2
drop _m

* Generamos 17 dominios para aplicar deflactores espaciales

g       dominioA=1 if dominio==1 & area==1
replace dominioA=2 if dominio==1 & area==2
replace dominioA=3 if dominio==2 & area==1
replace dominioA=4 if dominio==2 & area==2
replace dominioA=5 if dominio==3 & area==1
replace dominioA=6 if dominio==3 & area==2
replace dominioA=7 if dominio==4 & area==1
replace dominioA=8 if dominio==4 & area==2
replace dominioA=9 if dominio==5 & area==1
replace dominioA=10 if dominio==5 & area==2
replace dominioA=11 if dominio==6 & area==1
replace dominioA=12 if dominio==6 & area==2
replace dominioA=13 if dominio==7 & area==1
replace dominioA=14 if dominio==7 & area==2
replace dominioA=15 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==1
replace dominioA=16 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==2
replace dominioA=17 if dominio==8 & area==1
replace dominioA=17 if dominio==8 & area==2

label define dominioA ///
1 "Costa norte urbana" /// 
2 "Costa norte rural" /// 
3 "Costa centro urbana" /// 
4 "Costa centro rural" /// 
5 "Costa sur urbana" /// 
6 "Costa sur rural" ///	
7 "Sierra norte urbana" ///	
8 "Sierra norte rural" ///	
9 "Sierra centro urbana" /// 
10 "Sierra centro rural" ///	
11 "Sierra sur urbana" /// 
12 "Sierra sur rural" /// 
13 "Selva alta urbana" ///	
14 "Selva alta rural" /// 
15 "Selva baja urbana" /// 
16 "Selva baja rural" /// 
17"Lima Metropolitana" 
lab val dominioA dominioA 

merge m:1 dominioA using "$data/despacial_ldnew.dta"
drop _m


*================================ 
* GUARDANDO ARCHIVO PRINCIPAL
*-===============================

save "$cleaned/data_final", replace

