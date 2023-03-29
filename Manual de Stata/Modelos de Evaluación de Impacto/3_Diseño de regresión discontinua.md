#  Evaluación de Impacto

### 3 DISEÑO DE REGRESIÓN DISCONTINUA

El método de regresión discontinua es un método cuasiexperimental utilizado para identificar efectos causales. Este método se basa en cortes que surgen por ley o por diseño y que implican una discontinuidad en alguna variable $(X_1)$.

Este método nos permite investigar el efecto de la variable $T_i$ sobre $Y_i$, donde $T_i$ será una variable dummy que especifica si el individuo $i$ forma parte del grupo de “tratamiento” ($T_i$ = 1) o de “control” ($T_i$ = 0).

Cada individuo tiene dos resultados potenciales, de los cuales únicamente observamos uno (el realizado). $Y^T_i$ es el nivel de la variable dependiente que $i$ tendría si forma parte del grupo de tratamiento, $Y^C_i$ el que tendría si forma parte del grupo de control y $Y_i$ el nivel observado.

A diferencia que en el caso de experimentos donde ambos grupos (tratamiento y control) son determinados de forma aleatoria, en este caso son determinados por una regla objetiva de decisión. Dicha regla deberá especificar cortes especificos en los cuales la probabilidad de formar parte del grupo de tratamiento o control cambie de forma abrupta (i.e. discontinua).

El cambio discontinuo en la probabilidad de formar parte del grupo de tratamiento puede ser de dos tipos:

### 3.1 REGRESIÓN DISCONTINUA "SHARP"

Este tipo de discontinuidad se refiere al caso en el cual la probabilidad de formar parte del grupo de tratamiento pasa de 0 a 1 despúes del corte que determina la discontinuidad. Se utiliza cuando el tratamiento(variable $D_i$) es una función perfecta y discontinua de algún tipo de score(variable $score_i$)

$$D_i=\begin{cases} 1,&\text{if $score_i$ <= $X_0$} \\ 
0,&\text{if $score_i$ > $X_0$}\end{cases}$$

En este caso, el modelo más sencillo a aplicar es:

$$Y_i=\alpha+\beta X_i+\rho D_i+ \eta_i$$

donde $\rho$ es el parámetro de interes. 

La asignación al tratamiento se interpreta como aleatoria en elvecindario de la discontinuidad. Es decir, para un segmento de la población se asume que estar marginalmente por encima o por debajo del cut-off es algo que está fuera de control delindividuo. 

En estricto, se obtiene LATE (Local Average Treatment Effect). Esd ecir, se obtiene el impacto del programa para aquellos en el vecindario de la discontinuidad. 


### 3.2 REGRESIÓN DISCONTINUA "FUZZY"

En este tipo de discontinuidad la probabilidad de formar parte del grupo de tratamiento tiene un cambio discontinuo en el punto de corte $G_i = k$. Sin embargo, la probabilidad no cambia de 0 a 1. Este tipo de discontinuidad suele darse en casos en los cuales el punto de corte determina la elegibilidad al tratamiento, pero que la participación en el grupo de tratamiento no es obligatoria.

En ocasiones la discontinuidad determina quien recibe acceso alprograma, pero no de manera perfecta.

La regresión discontinua borrosa (fuzzy RD) se utiliza cuando eltratamiento (variable $D_i$) es más probable de ocurrir cuando los individuos cumplen cierto criterio.

En este caso se tiene un modelo de dos ecuaciones:

Primero, se estima una ecuacion de probabilidad de acceder altratamieno, $D_i$

$$D_i=\gamma_0+\pi T_i+g(x_i)+ \zeta_i$$

Donde $T_i$ es una variable binaria que se activa cuando el individuocumple cierto criterio. Se asume que $T_i$ es una función de $x_i$. Luego se obtiene $\hat{D_i}$ (el valor predicho de $D_i$) y se reemplaza en la ecuación de interés.

$$Y_i=\alpha+\rho \hat{D_i}+ i(x_i) +\eta_i$$

el coeﬁciente $\rho$ mide el impacto del programa. Las funciones $g(x_i)$ y $i(x_i)$ permiten controlar por no linearidades.

RD (en su versión nítida y borrosa) permite obtener estimadoresinsesgados del impacto de un programa en el vecindario de la discontinuidad. Por otro lado, el resultado que se obtiene (LATE) no esnecesariamente generalizable.

### 3.3 REGRESIÓN DISCONTINUA EN STATA

Para ejemplificar un RDD en Stata, utilizaremos el paquete de replicación del paper "The effects of access to health insurance: Evidence from a regression discontinuity design in Peru" de Bernal, Carpio y Klein (2017). Este paquete de replicación lo puedes descargar directamente desde el siguiente [enlace](https://www.sciencedirect.com/science/article/pii/S0047272717301299#ec0010 "enlace") o descargarlo de la base de datos de este repositorio. 

El paquete de replicación contiene 4 do files, nosotros nos concentraremos en el do file 4, donde los autores estiman el efecto del seguro social de salud dirigido a los pobres en Perú mediante un diseño de regresión discontinua. 

Abrimos nuestro dofile con el comando `doedit` y establecemos nuestro direcctorio.

```
cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data"

use data_for_analysis.dta, replace
```

Una vez abierta la base de datos y nos quedamos con observaciones para Lima y eliminamos los missing values:

```
***Lima Province
gen limaprov=(substr(ubigeo,1,4)=="1501")

***Households without wage workers
tab depend1, m
bys num_hog: egen hog_depend1=sum(depend1)
replace hog_depend1=1 if hog_depend1>=1
gen formal=(hog_depend1==1) // Individuals that belong to a household in which at least one member is formally employed.

***Filters
keep if limaprov==1 // Focus on Lima Province.
drop if ifh==. // 3 observations without IFH.
drop if consulta==. // 1 observation without information on health.
tab formal, m // Full sample: 4,161 obs.
```

![image](https://user-images.githubusercontent.com/128189216/228531694-1f260454-7b7f-46d3-938d-57186ca652e9.png)

Luego se procede a crear la variable de asignación, restando el corte al índice de focalización de hogares estimado. 

```
***variables (Z)

gen z_ifh=ifh-corte
clonevar Z1=z_ifh
label var Z1 "IFH index minus threshold"
```
Adicionalmente se crea una dummy  y = 1 para las personas que son elegibles, todas aquellas observaciones que están por debajo del corte, y y = 0 en caso contrario. 

```
gen eligibleZ1=Z1<=0 
label var eligible "eligibility"
label def eligible 0 "Ineligible" 1 "Eligible"
label val eligibleZ1 eligible
```

Se crea una interacción entre nuestro corte estandarizado y  la variable de elegible.

```
gen interaccion_EZ1=Z1*eligibleZ1

gen Z2=p1172_01-20 // Cutoff = 20 soles.
gen Z3=p1172_02-25 // Cutoff = 25 soles.
gen eligibleZ2=Z2<=0 | Z2==.
gen eligibleZ3=Z3<=0 | Z3==.
generate high=(formal==0 & agua==1 & electricidad==1 & eligibleZ2==0 & eligibleZ3==0) // Informal individuals accessing water and electricity with high consumption.

generate high_eligibleZ1=high*eligibleZ1
gen interaccion_high=Z1*high

gen eligible=1 if formal==0 & (agua~=1 | electricidad~=1) & eligibleZ1==1 // Eligible definition based on IFH, electricity and water.
replace eligible=0 if formal==0 & (agua~=1 | electricidad~=1) & eligibleZ1==0
replace eligible=0 if formal==0 & agua==1 & electricidad==1 & eligibleZ1==0
replace eligible=0 if formal==0 & agua==1 & electricidad==1 & eligibleZ1==1 & (eligibleZ2==0 & eligibleZ3==0)
replace eligible=1 if formal==0 & agua==1 & electricidad==1 & eligibleZ1==1 & (eligibleZ2==1 | eligibleZ3==1)
```

```
***Bandwith 20
gen bw20=Z1>-20
replace bw20=0 if Z1>20
replace bw20=. if formal==1
summ bw20
plot bw20 Z1
```




Se creará un global para la especificación del modelo y de los controles

```
global specification eligibleZ1 Z1 interaccion_EZ1 high high_eligibleZ1 interaccion_high
global ylist $yuse $yfin $yexpenditures2 $yexp2detail $yhealth
global controles mujer edad educ mieperho hhmujer
```






```
*Sample 20 (Effects)
foreach var of varlist $ylist {
quietly regress `var' $specification $controles_c if formal==0 & bw20==1, vce(robust)
estimates store `var'
```


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/5_Importar_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
