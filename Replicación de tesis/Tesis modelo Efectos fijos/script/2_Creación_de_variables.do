*==============================================
* CREACIÓN DE VARIABLES
*==============================================

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:/Users/Usuario/Desktop/Replica Cozzubo"
global data "$root/data"
global cleaned "$root/cleaned"

* Abrir base de datos
*================================
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
rename ocu500_ ocu500

*=========================
* CREACIÓN DE VARIABLES
*=========================

*Variables explicativas
*=======================

*Empleo - jefe del hogar


*Nivel educativo
{
* Nivel educativo
gen educ=.
replace educ=0 if p301a==1 | p301a==2
replace educ=1 if p301a==3 | p301a==4
replace educ=2 if p301a==5 | p301a==6
replace educ=3 if p301a==7 | p301a==8
replace educ=4 if p301a==9 | p301a==10
replace educ=5 if p301a==11
label variable educ "Nivel educativo"
label define niveduc 0 "Sin nivel" 1 "Primaria" 2 "Secundaria" 3 "Superior no universitaria" 4 "Superior universitaria" 5 "Postgrado" 
label values educ niveduc

* Escolaridad (años)
gen sch=.
replace sch=0  if p301a==1 | p301a==2  // Sin nivel, nivel inicial
replace sch=0  if p301a==3 & (p301b==0 & p301c==0)  // Sin nivel :799
replace sch=1  if (p301a==3 & p301b==1) | (p301a==3 & p301c==1) | (p301a==4 & p301b==1) | (p301a==4 & p301c==1)     
replace sch=2  if (p301a==3 & p301b==2) | (p301a==3 & p301c==2) | (p301a==4 & p301b==2) | (p301a==4 & p301c==2) 
replace sch=3  if (p301a==3 & p301b==3) | (p301a==3 & p301c==3) | (p301a==4 & p301b==3) | (p301a==4 & p301c==3) 
replace sch=4  if (p301a==3 & p301b==4) | (p301a==3 & p301c==4) | (p301a==4 & p301b==4) | (p301a==4 & p301c==4) 
replace sch=5  if (p301a==3 & p301b==5) | (p301a==3 & p301c==5) | (p301a==4 & p301b==5) | (p301a==4 & p301c==5) 
replace sch=6  if (p301a==3 & p301b==6) | (p301a==3 & p301c==6) | (p301a==4 & p301b==6) | (p301a==4 & p301c==6)  
replace sch=7  if (p301a==5 & p301b==1) | (p301a==6 & p301b==1)                                                  
replace sch=8  if (p301a==5 & p301b==2) | (p301a==6 & p301b==2)   											   
replace sch=9  if (p301a==5 & p301b==3) | (p301a==6 & p301b==3)   												 
replace sch=10 if (p301a==5 & p301b==4) | (p301a==6 & p301b==4)   												
replace sch=11 if (p301a==5 & p301b==5) | (p301a==6 & p301b==5)   								
replace sch=12 if (p301a==6 & p301b==6) 										
replace sch=12 if (p301a==7 & p301b==1) | (p301a==8 & p301b==1) | (p301a==9 & p301b==1) | (p301a==10 & p301b==1) 
replace sch=13 if (p301a==7 & p301b==2) | (p301a==8 & p301b==2) | (p301a==9 & p301b==2) | (p301a==10 & p301b==2) 
replace sch=14 if (p301a==7 & p301b==3) | (p301a==8 & p301b==3) | (p301a==9 & p301b==3) | (p301a==10 & p301b==3)
replace sch=15 if (p301a==7 & p301b==4) | (p301a==8 & p301b==4) | (p301a==9 & p301b==4) | (p301a==10 & p301b==4) 
replace sch=16 if (p301a==7 & p301b==5) | (p301a==8 & p301b==5) | (p301a==9 & p301b==5) | (p301a==10 & p301b==5) 
replace sch=17 if (p301a==9 & p301b==6) | (p301a==10 & p301b==6) | (p301a==11 & p301b==1)
replace sch=18 if (p301a==9 & p301b==7) | (p301a==10 & p301b==7) | (p301a==11 & p301b==2)
label variable sch "Escolaridad (años)"
}
*Nivel educativo - jefe del hogar 
gen educacion_jh=sch if p203==1

*Nivel educativo - hogar 
egen educacion_h=mean(sch), by(conglome vivienda hogar año)

*Necesidades básicas - hogar
gen NBI= nbi1+nbi2+nbi3+nbi4+nbi5


*Nivel de dependencia



*Programas sociales - Distrito



*Desigualdad - Región

* Índice de Gini
*================ 


*ineqdeco ypc [aw=facpob07] , by(ano)
*ineqdeco ypc [aw=facpob07] , by(area)
*ineqdeco ypc [aw=facpob07] if ano==2011, by(departamento)



*Variables hipótesis
*=======================

*jefatura del hogar  - hogar
*conyugue 
gen conyugue=1 if p203==1 & (p209==1 | p209==2)
replace conyugue=0 if p203==1 & (p209==3 | p209==4 | p209==5 | p209==6) | p203==0 


*Generación de ingresos  - hogar




*Seguro  - hogar
*cualquier tipo de seguro
gen seguro=1 if  p4191==1|p4192==1|p4193==1|p4194==1|p4195==1|p4196==1|p4197==1|p4198==1
replace seguro=0 if  p4191==0 & p4192==0 & p4193==0 & p4194==0 & p4195==0 & p4196==0 & p4197==0 & p4198==0

egen pc_seguro= total(seguro==1), by(conglome vivienda hogar año)
gen seguro_essalud=pc_seguro/mieperho

*cualquier seguro menos sis 
gen seguro_sin_sis=1 if  p4191==1|p4192==1|p4193==1|p4194==1|p4196==1|p4197==1|p4198==1
replace seguro_sin_sis=0 if  p4191==0 & p4192==0 & p4193==0 & p4194==0 & p4196==0 & p4197==0 & p4198==0

egen pc_seguro_no_sis= total(seguro_sin_sis==1), by(conglome vivienda hogar año)
gen seguro_no_sis=pc_seguro_no_sis/mieperho


*Variable dependiente
*=======================

*Transición entre periodos - hogar


*Variables de control
*======================

*Ubicación geográfica

*Edad
egen edad_h=mean(p208a), by(conglome vivienda hogar año)

*Género
recode p207 (2=0 "Mujeres") (1=1 "Hombres"), g(sexo)
lab var sexo "Sexo: Mujeres=0 | Hombres=1"

egen num_hombres = total(sexo==1), by(conglome vivienda hogar año)
gen hombres_h=num_hombres/mieperho

gen hombre_jh=1 if p203==1 & sexo==1
replace hombre_jh=0 if (p203==1 & sexo==0)

*Etnicidad
rename p300a lengua
replace lengua=. if lengua==9
label variable lengua "Lengua Materna"

gen lenguacat=.
label variable lenguacat "Categoría de Lengua Materna"
replace lenguacat=1 if lengua==4 & !missing(lengua) 
replace lenguacat=2 if lengua<4 & !missing(lengua) 
replace lenguacat=3 if lengua>4 & lengua<8 & !missing(lengua)
replace lenguacat=4 if lengua==8 & !missing(lengua) 
label define lenguacat 1 "Castellano" 2 "Quechua/Aymara/Otra lengua nativa" ///
3 "Inglés/Portugués/Otra lengua extranjera" 4 "Sordo mudo"
label values lenguacat lenguacat

egen total_lenguacat= total(lenguacat==2), by(conglome vivienda hogar año)
gen lengua_h=total_lenguacat/mieperho

*Télefono
gen telefono=1 if p1141==1
replace telefono=0 if p1141==0

*Agua
gen agua=1 if p110==1 | p110==2
replace agua=0 if p110==3 | p110==4 | p110==5 | p110==6 | p110==7 

*Electricidad
gen electricidad=1 if p1121==1
replace electricidad=0 if p1121==0 


*Colapsar la base a nivel de hogar
keep if p203==1


drop if año==año[_n-1]

*Establecer a los datos como un panel de datos
xtset hogar año

save "$cleaned/data_para_analisis_final.dta", replace