*==============================================
* Análisis descriptivo
*==============================================

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Replica Cozzubo"
global data "$root/data"
global cleaned "$root/cleaned"


use "$cleaned/data_para_analisis_final.dta", clear


* Renombrando algunas variables
*======================================
rename fac_ factor07
rename año aniorec

*Declarar que estamos trabajando con un panel de datos
xtset hogar aniorec


*Variables de Corte
*=================================	
	
* Departamento
g dpto1= real(substr(ubigeo,1,2))
lab var dpto1 "Departamentos"
label define dpto ///
1"Amazonas" /// 
2"Ancash" /// 
3"Apurimac" /// 
4"Arequipa" /// 
5"Ayacucho" /// 
6"Cajamarca" /// 
7 "Callao" /// 
8"Cusco" /// 
9"Huancavelica" /// 
10"Huanuco" /// 
11"Ica" /// 
12"Junin" /// 
13"La Libertad" /// 
14"Lambayeque" /// 
15"Lima" /// 
16"Loreto" /// 
17"Madre de Dios" /// 
18"Moquegua" /// 
19"Pasco" ///
20"Piura" ///
21"Puno" /// 
22"San Martin" /// 
23"Tacna" /// 
24"Tumbes" /// 
25"Ucayali" 
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

label define domin02 /// 
1 "Costa urbana" /// 
2 "Costa rural" /// 
3 "Sierra urbana" /// 
4 "Sierra rural" /// 
5 "Selva urbana" /// 
6 "Selva rural" /// 
7 "Lima Metropolitana"
label value domin02 domin02
label var domin02 "Dominios con inferencia ENAHO"

* Región Natural (Costa / Sierra/Selva)
recode dominio (1/3 8 = 1 "Costa") (4/6 = 2 "Sierra") (7 = 3 "Selva"), g(region)

* Regiones Naturales separando LM
g areag = (dominio == 8)
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


*Creando las variables del gasto deflactado a precios de Lima 
*=============================================================

gen ipcmr_pl=inghog1d/(12*ld*mieperho*i00)
gen gpcmr_pl=gashog2d/(12*ld*mieperho*i00)
gen linear_pl=linea/(ld*i00) // Línea de pobreza a precios reales de Lima

*Declarando la muestra
svyset [pweight = factornd07], psu(conglome) strata(estrato)

*======================
* Cálculo de pobreza	
*======================

*Utilizaremos las observaciones de que estuvieronen el panel durante dos años
xtdescribe

* Tasa de pobreza
g pobre = (gpcmr_pl < linear_pl)
label define pobre 0"No pobre" 1"Pobre"
label val pobre pobre

sum pobre [iw=factornd07]
svy:mean pobre, over(aniorec) 
svy:mean pobre, over(aniorec dpto1) cformat(%9.4fc) 

* Brecha pobreza 
g brecha = (linear_pl-gpcmr_pl)/linear_pl if pobre==1
replace brecha = 0 if pobre==0
svy:mean brecha, over(aniorec)
svy:mean brecha, over(aniorec dpto1) cformat(%9.4fc) 

* Severidad
g severidad = ((linear_pl-gpcmr_pl)/linear_pl)^2 if pobre==1
replace severidad = 0 if pobre==0
svy:mean severidad, over(aniorec)
svy:mean severidad, over(aniorec dpto1) cformat(%9.4fc) 


*===============================================
*Pobreza por necesidades básicas insatisfechas
*===============================================

recode NBI (0=0 "No pobre") (1/5=1 "Pobre"), gen(pobre_NBI)
lab var pobre_NBI "Pobreza - Necesidades Basicas Insatisfechas"

tab pobre_NBI

/*
svyset [pweight = factornd07], psu(cong) strata(estrato)
svy: tabulate pobre_NBI anio, col 
*/

*==================
*Pobreza integrada
*==================

gen pob_integrado=4 if pobre==1 & pobre_NBI==1 /*Pobreza Crónica*/
replace pob_integrado=3 if pobre==1 & pobre_NBI==0 /*Pobreza Reciente*/
replace pob_integrado=2 if pobre==0 & pobre_NBI==1 /*Pobreza Inercial*/
replace pob_integrado=1 if pobre==0 & pobre_NBI==0 /*Integrado socialmente*/
label var pob_integrado "Pobreza por el método integrado"
label define pob_integrado 1"Integrado socialmente" 2"Pobreza inercial" 3"Pobreza reciente" 4"Pobre crónico"
label var pob_integrado pob_integrado

*Clasifica No Pobre y Pobre
gen pobreza_integ=pob_integrado
recode pobreza_integ (1=0) (2/4=1)
/*
svyset: conglome [pw=factornd07], strata(estrato)
svy: tabulate pob_integrado Area, col format (%9.1f) percent
*/

* Indice Gini: Descomposición
ineqdeco gpcmr_pl [fw=factornd07], by(aniorec)

