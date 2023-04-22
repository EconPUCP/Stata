*******************************************
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_creación_de_variables.do
* OBJETIVO: Creación de variables
*******************************************

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:\Users\Usuario\Desktop\Replica Nicolas"
global data "$root/data"
global cleaned "$root/cleaned"

* Abrir base de datos
*================================
use "$cleaned/data.dta", clear

*==========================================
*  INDICADORES DE PRIVACIÓN PARA LAS PcDM
*==========================================

*Enfermedad:
gen enfermedad_nolim=1 if (P601_5==0) & (P605==1 | P605==2 | P605==3 | P605==4 | P605==5 | P605==10 | P605==13 | P605==14 | P605==15)
replace enfermedad_nolim=0 if (P601_5==1) | ((P601_5==0) & (P602_01==1 | P602_02==1 | P602_03==1 | P602_04==1 | P602_05==1 | P602_06==1 | P602_07==1 | P602_08==1 | P602_09==1 | P602_10==1) | (P605==6 | P605==7 | P605==8 | P605==9 | P605==11 | P605==12 | P605==16))

gen enfermedad_lim=1 if (P606==1) & (P611==1 | P611==2 | P611==3 | P611==4 | P611==5 | P611==10 | P611==13 | P611==14 | P611==15)
replace enfermedad_lim=0 if (P606==2) | ((P606==1) & (P607_01==1 | P607_02==1 | P607_03==1 | P607_04==1 | P607_05==1 | P607_06==1 | P607_07==1 | P607_08==1 | P607_09==1 | P607_10==1) | (P611==6 | P611==7 | P611==8 | P611==9 | P611==11 | P611==12 | P611==16))

gen enfermedad=1 if enfermedad_nolim==1 | enfermedad_lim==1
replace enfermedad=0 if enfermedad_nolim==0 & enfermedad_lim==0

*Seguro
gen seguro=1 if P619==2
replace seguro=0 if P619==1

*Tratamiendo 
gen tratamiento=1 if P612_1==2 | P612_2==2 | P612_3==2 | P612_4==2
replace tratamiento=0 if (P612_1==3 | P612_1==1) & (P612_2==3 | P612_2==1) & (P612_3==3 | P612_3==1) & (P612_4==3 | P612_4==1)

*Educación
destring P109_1, replace 
label variable P109_1 "Nivel educativo"
label define P109_1 1"Sin nivel" 2"Inicial" 3"Primaria" 4"Secundaria" 5"Educación básica especial" 6"Superior no universitaria" 7"Superior universitaria" 8"Postgrado"  
label values P109_1 P109_1

gen educacion=1 if P109_1<=2 & P502==2
replace educacion=0 if (P109_1==3 | P109_1==4 | P109_1==5 | P109_1==6 | P109_1==7 | P109_1==8) | P502==1 

*Ayuda
gen ayuda=1 if P904_7==1 
replace ayuda=0 if P904_1==1 | P904_2==1 | P904_3==1 | P904_4==1| P904_5==1

*Trato diferenciado
gen trato_diferenciado=1 if  P901==1 & (P902_2<=6 | P902_3<=6 | P902_4<=6 |P902_5<=6)
replace trato_diferenciado=0 if P901==2 | (P901==1 & ((P902_2==9 | P902_2==.) & (P902_3==9 | P902_3==.) & (P902_4==9 | P902_4==.) & (P902_5==9 | P902_5==.)))

*Traslado
gen traslado=1 if P801_4==1 | P801_1==1 | P801_2==1 | P801_3==1
replace traslado=0 if (P801_1==2 | P801_1==3) & (P801_2==2 | P801_2==3) & (P801_3==2 | P801_3==3)

*Materiales
gen paredes=1 if (P302==3|P302==4|P302==5|P302==6|P302==7|P302==8)
replace paredes=0 if (P302==1|P302==2)

gen pisos=1 if (P303==6|P303==7)
replace pisos=0 if P303==1|P303==2|P303==3|P303==4|P303==5

gen techos=1 if P304==5|P304==6|P304==7 |P304==8
replace techos=0 if P304==1|P304==2|P304==3|P304==4

gen materiales=1 if paredes==1| pisos==1| techos==1
replace materiales=0 if paredes==0 & pisos==0 &techos==0
label var materiales  "Materiales inadecuados de la vivienda"

*Hacinamiento
recode P307 (99=.)
bys P06 P11 P14: egen habitaciones=max(P307)
gen hacinam_ratio=mieperhog/habitaciones
gen hacinamiento=1 if hacinam_ratio>=3
replace hacinamiento=0 if hacinam_ratio<3 & hacinam_ratio!=.
replace hacinamiento=. if habitaciones==.

*Tenencia
gen tenencia=1 if P306==4 | P306==5 | P306==6  
replace tenencia=0 if P306==1 | P306==2 | P306==3 | P306==7

*Agua
gen  agua=1 if P309==3 | P309==4  | P309==5 | P309==6 | P309==7
replace agua=0 if P309==1 | P309==2 

*Saneamiento
gen saneamiento=1 if P310==2 | P310==3 | P310==4  | P310==5 | P310==6 | P310==7
replace saneamiento=0 if P310==1

*Electricidad
gen electricidad=1 if P311==2 | P311==3 | P311==4  | P311==5 | P311==6 | P311==7 
replace electricidad=0 if P311==1

*Voto
destring P107, replace
gen dni=1 if P107==2 | P107==3
replace dni=0 if P107==1

gen voto=1 if (P106>=18) & (P911==2 & (P912_1==1 | P912_2==2 | dni==1))
replace voto=0 if (P106<18) | (P106>=18 & P911==1) | (P106>=18 & P911==2 & P912_1==2 & P912_2==2 & dni==0) | (P106>=70 & P911==3 & dni==0)

*Empleo
gen trabaja=1 if P701==1 | P702==1 | P703==1 | P704_01==1 | P704_02==1 | P704_03==1 | P704_04==1 | P704_05==1 | P704_05==1 | P704_06==1 | P704_07==1 | P704_08==1 | P704_09==1 | P704_10==1 | P704_11==1 | P704_12==1 | P704_13==1
replace trabaja=0 if P701==2 & P702==2 & P703==2 & P704_01==2 & P704_02==2 & P704_03==2 & P704_04==2 & P704_05==2 & P704_05==2 & P704_06==2 & P704_07==2 & P704_08==2 & P704_09==2 & P704_10==2 & P704_11==2 & P704_12==2 & P704_13==2

gen empleo=1 if (trabaja==0 & P733==1) | (trabaja==0 & P733==2 & P734==7)
replace empleo=0 if trabaja==1 | (trabaja==0 & P733==2 & (P734==1 | P734==2 | P734==3 | P734==4 | P734==5 | P734==6 | P734==8))


*===============================================
*   VARIABLES EXÓGENAS DEL MODELO ECONOMÉTRICO
*===============================================

* Edad
rename P106 edad

*Edad^2
gen edad2=edad^2

*indigena
*lengua
gen indigena_lengua=1 if P522==1 | P522==2 | P522==3
replace indigena_lengua=0 if P522==4 | P522==5

gen indigena_auto=1 if P523==1 | P523==2 | P523==3 | P523==4 | P523==5 | P523==6
replace indigena_auto=0 if P523==7 | P523==8 | P523==9 | P523==10 | P523==11

gen indigena=1 if indigena_lengua==1 | indigena_auto==1
replace indigena=0 if (indigena_lengua==0 & indigena_auto==0) | (indigena_lengua==0 & indigena_auto==.) | (indigena_lengua==. & indigena_auto==0)

* mujer
destring P105, replace
gen mujer=1 if P105==2 
replace mujer=0 if P105==1
label define mujer 1"Mujer" 0"Hombre"
label values mujer mujer

*rural
gen rural=1 if Area==2 
replace rural=0 if Area==1
label define rural 1"Rural" 0"Urbana"
label values rural rural
label variable rural "Rural"

*Limitaciones de movilidad:
gen l_movilidad=1 if P203==1
replace l_movilidad=0 if P203==2
label variable l_movilidad "Limitaciones motrices"

*Limitación visual grave o completa
gen l_visual_grave_completa=1 if (P204==1 & P407==3) | (P204==1 & P407==4)
replace l_visual_grave_completa=0 if P204==2 | (P204==1 & P407==1) | (P204==1 & P407==2) 
label variable l_visual_grave_completa "Limitaciones visual grave o completa aún usando anteojos"

*Limitaciones permanente para hablar o comunicarse
gen l_comunicativa=1 if P205==1
replace l_comunicativa=0 if P205==2
label variable l_comunicativa "Limitaciones permanente para hablar o comunicarse"

*Limitación auditiva grave o completa
gen  l_auditiva_grave_completa=1 if (P206==1 & P416==3) | (P206==1 & P416==4)
replace l_auditiva_grave_completa=0 if P206==2 | (P206==1 & P416==1) | (P206==1 & P416==2) 
label variable l_auditiva_grave_completa "Limitación auditiva grave o completa"

*Limitaciones de aprendizaje
gen l_aprendizaje=1 if P207==1 
replace l_aprendizaje=0 if P207==2
label variable l_aprendizaje "Limitaciones de aprendizaje"

*Limitaciones de relaciones interpersonales
gen l_relacional=1 if P208==1
replace l_relacional=0 if P208==2
label variable l_relacional "Limitaciones para relacionarse con los demás"

*Limitaciones de enfermedades
gen l_enfermedad=1 if P209==1
replace l_enfermedad=0 if P209==2
label variable l_enfermedad "Limitaciones - enfermedades crónicas"

*jefe
gen jefe=1 if P103==1
replace jefe=0 if P103!=1
label variable jefe "Jefe del hogar"

*vive solo
gen vive_solo=1 if mieperhog==1
replace vive_solo=0 if mieperhog!=1

*Lima - Callao
destring P01, replace
gen lima_callao=0
replace lima_callao=1 if P01==7 | P01==15  

*mieperhog: esta variable ya se creo en el do file de creación de base de datos

*programa social
gen programa_social=1 if P916_18==0
replace programa_social=0 if P916_18==1
               
*===================
* CÁLCULO DEL IPM
*===================

* Grupo A: 3 años a más
*========================
gen c_i_A = (1/21)*(enfermedad + seguro + tratamiento) + (1/7)*educacion + (1/7)*ayuda + (1/7)*trato_diferenciado + (1/7)*traslado + (1/21)*(materiales + hacinamiento + tenencia) + (1/21)*(agua + saneamiento + electricidad)

* Grupo B: 18 años a  64 años
*==============================
gen c_i_B = (1/27)*(enfermedad + seguro + tratamiento) + (1/9)*educacion + (1/9)*ayuda + (1/9)*trato_diferenciado + (1/9)*traslado + (1/27)*(materiales + hacinamiento + tenencia) + (1/27)*(agua + saneamiento + electricidad) + (1/9)*voto + (1/9)*empleo

set more off

foreach x of numlist 1/9{
*Identificación sí la persona es pobre o no para diferentes cortes
quietly gen pobre_k`x'_A =1 if c_i_A >= 0.`x' & c_i_A<1000
quietly	replace pobre_k`x'_A = 0 if c_i_A<0.`x' & c_i_A!=.
quietly lab var pobre_k`x'_A "Identificacion de pobre con k=0.`x'"
	
quietly	gen pobre_k`x'_B = 1 if c_i_B >= 0.`x' & c_i_B<1000
quietly	replace pobre_k`x'_B = 0 if c_i_B<0.`x' & c_i_A!=.
quietly lab var pobre_k`x'_B "Identificacion de pobre con k=0.`x'"

*Vector de conteo censurado
*Generar el vector censurado de la suma de privaciones individuales ponderadas, 'c(k)'
quietly gen c_k`x'_A = c_i_A if pobre_k`x'_A==1 
quietly replace c_k`x'_A = 0 if pobre_k`x'_A==0 
quietly label var c_k`x'_A "Vector de conteo censurado para pobres con k=0.`x'"
	
quietly	gen c_k`x'_B = c_i_B if pobre_k`x'_B==1 
quietly replace c_k`x'_B = 0 if pobre_k`x'_B==0 
quietly label var c_k`x'_B "Vector de conteo censurado para pobres con k=0.`x'"
	
*Calculamos la suma ponderada censurada solo para los pobres
quietly	gen cc_k`x'_A=c_i_A if pobre_k`x'_A==1
quietly replace cc_k`x'_A=. if pobre_k`x'_A==0
quietly	label var cc_k`x'_A "suma ponderada censurada solo para los pobres con k=0.`x'"
	
quietly	gen cc_k`x'_B=c_i_B if pobre_k`x'_B==1
quietly replace cc_k`x'_B=. if pobre_k`x'_B==0
quietly	label var cc_k`x'_B "suma ponderada censurada solo para los pobres con k=0.`x'"
}                 


*================================
* GUARDANDO ARCHIVOS PRINCIPAL
*-===============================

save "$cleaned/data_para_analisis.dta", replace

erase "$cleaned/data.dta"