*Pontificia Universidad Catolica del Perú
*Aplicación: Modelo Probit
*Manual Github - Stata
*******************************************

clear all
set more off
cd ""
use ""

**********************************************
          *Armado de Base de datos*
**********************************************

*1. Descarga de base de datos


*2. Limpieza de base de datos 

unicode analyze basededato.dta
unicode encoding set "latin1" 
unicode translate basededato.dta


*la siguiente linea solo usar para enaho*/

forvalue h=1/2{
unicode analyze enaho01-2020-`h'00.dta
unicode encoding set "latin1" 
unicode translate enaho01-2020-`h'00.dta
}


*3. Construcción de la base de datos

   use "base de datos", replace // se abre el master
   merge 1:1 identificador_de_la_variable using "basededatousing", gen(pegue)

   use "base de datos" // se abre el master
   merge m:1 identificador_de_la_variable using "basededatousing"
   drop _merge 
   
   use "base de datos" // master 
   merge 1:1 identificador_de_la_variable using "basededatousing" 
   drop _merge
   
   
**********************************************
  *Análisis descriptivo de la base de datos*
**********************************************
use ModeloBinario
describe
summarize  variable1 variable2 variable3 variable3 variable4 



tabulate variable1  
tab variable1 variable2 variable3, cols(2)
tab1 variable1 variable2 variable3 variable4 // permite hacer varias tablas         *                                               individuales
tabstat variable1 variable2 variable3 (mean n sd min k sk med r v cv su sem) by (sectores) // se pueden agregar más datos descriptivos que el sumarize*

/*
tabstat price rep78 (mean n sd min k sk med r v cv su sem) by (foreign) co(s) // lo mismo pero sale en columnas mas ordenada* 
tabstat price rep78 (mean n sd min k sk med r v cv su sem) by (foreign) co(v) // lo mismo pero sale en filas mas ordenada* 
*/

line variable1 variable2  // grafico de linea de dos variables
line variable1 variable2 if sector==10, name(linea, replace)  // grafico de linea de *                                           dos variables condicionada a otra variable

graph bar (mean) variable  ///  
caption(Fuente: Elaboración propia). Cálculo de los autores ///
name(temp2,replace) legend(cols(1)) ///
note(Este gráfico ha sido elaborado FECHA U OTROS)

graph bar (mean) variable1, over(categoria)///
caption(Fuente: Elaboración propia). Cálculo de los autores ///
name(temp2,replace) legend(cols(1)) ///
note(Este gráfico ha sido elaborado FECHA U OTROS)


graph bar (mean) variable1 if year<=2003, over(categoria)///
caption(Fuente: Elaboración propia). Cálculo de los autores ///
name(temp2,replace) legend(cols(1)) ///
note(Este gráfico ha sido elaborado FECHA U OTROS)

graph hbar (mean) variable, over(sector, label(angle(horizontal))) title(Crecimiento Promedio de la producción por sector) subtitle(2002-2006) ytitle(Porcentaje(%))

graph hbar (mean) variable, over(sector, label(angle(horizontal))) title(Crecimiento Promedio de la producción por sector) subtitle(2002-2006) ytitle(Porcentaje(%))

********************ESTIMAMOS MODELO LOGIT Y PROBIT*****************************

* Probit model
probit variable1 variable2 variable3 variable3 variable4 

//los coeficientes No son directamente interpretables ni comparables
//los signos nos dan una idea: si es +, es mayor prob de que y=1


*********************ESTIMAMOS SUS CAMBIOS MARGINALES***************************

*para interpretar los coeficientes estimamos su efectos marginales

quietly probit variable1 variable2 variable3 variable3 variable4   

*Estimamos su DERIVADA(util para variables discretas)
margins, dydx(*)

//el cambio en la probabilidad se interpreta en puntos porcentuales

*Estimamos su ELASTICIDAD(util para variables continuas)
margins, eyex(*)

//el cambio en la probabilidad se interpreta en cambios porcentuales

*Estimamos su derivada en la media de las variables
margins, dydx(*) atmeans
//los cambios marginales no son estaticos depende de los coef(X)

*Estimamos su derivada especificando valores de las variables(punto especifico)
margins, dydx(*) at(variable2=1 variable3=35 variable=0)



**********************PREDECIMOS LAS PROBABILIDADES*****************************

* predecimos la esperanza matematica de y (salida positiva)
quietly probit variable1 variable2 variable3 variable3 variable4  
predict pprobit, pr

* predicicon lineal 
predict pprobitxb, xb

summarize lfp pprobit
//la media es la misma pero su maximo y minimo no


************************* EVALUACION DEL MODELO*********************************
*Porcentaje de prediccion correctamnete realizada (Matriz de Confusion)
estat classification

//El modelo tiene (bajo, medio, alta) especificidad

*Graficamos la especificidad y sensibilidad para diferentes puntos de corte
lsens

*Graficamo la curva ROC y el Area bajo ella
lroc
//Si esta area se aproxima a 1 el modelos discrimina bien
//Si el area es proxima a 0.5 el modelo No discrimina nada
//Asegurarse que el area sea mayor a 0.7 para un modelo aceptable
