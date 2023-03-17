************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 5_exportar_resultados.do
* OBJETIVO: estout y outreg2
************

* Preambulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd
global D "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis" // cambiar cd


************
set more off

* Cargamos la base de datos
use "enaho01a-2019-500.dta", clear


*Insertamos el diseño muestral dado que trabajamos con una encuesta 
svyset conglome [pweight = fac500a], strata(estrato)

*Creamos una variable catégorica de los departamentos
gen dpto = substr(ubigeo,1,2) // Creamos dummies para cada región
destring dpto, replace // dpto es un string, lo convertiremos en var. numérica


reg i524a1 p208a i.p207
estimates store m1

reg i524a1 p208a i.p207 i.dpto
estimates store m2

estout m1 m2

eststo clear // se pide que se limpien los resusltados anteriores
eststo: reg i524a1 p208a i.p207
eststo: reg i524a1 p208a i.p207 i.dpto

estout

* Editando la tabla final
estout, drop(*dpto 1.p207) rename(p208a Edad 2.p207 Mujer _cons Const) ///
mlabels("(1)" "(2)") title("Tabla 1") legend ///
cells("b( star label(Coef.) fmt(2)) p(fmt(2) label(p-value))" ///
 se(fmt(2) label(S.E.)))  stats(r2 N, labels("R-cuadrado" "N. de obs."))

esttab, drop(*dpto 1.p207)rename(p208a Edad 2.p207 Mujer _cons Const) ///
nomtitle title("Tabla 1") legend ///
cells("b( star label(Coef.) fmt(2)) p(fmt(2) label(p-value))" ///
 se(fmt(2) label(S.E.)))  stats(r2 N, labels("R-cuadrado" "N. de obs."))

* Exportando en distintos formatos
* CSV <-> Excel
esttab using "$D/Results/tabla_1.csv", drop(*dpto 1.p207)rename(p208a Edad 2.p207 Mujer _cons Const) ///
nomtitle title("Tabla 1") legend ///
cells("b( star label(Coef.) fmt(2)) p(fmt(2) label(p-value))" ///
 se(fmt(2) label(S.E.)))  stats(r2 N, labels("R-cuadrado" "N. de obs.")) replace

* RTF <-> Word
esttab using "$D/Results/tabla_1.rtf", drop(*dpto 1.p207)rename(p208a Edad 2.p207 Mujer _cons Const) ///
nomtitle title("Tabla 1") legend ///
cells("b( star label(Coef.) fmt(2)) p(fmt(2) label(p-value))" ///
 se(fmt(2) label(S.E.)))  stats(r2 N, labels("R-cuadrado" "N. de obs.")) replace

* Tex <-> Latex
 esttab using "$D/Results/tabla_1.tex", drop(*dpto 1.p207)rename(p208a Edad 2.p207 Mujer _cons Const) ///
nomtitle title("Tabla 1") legend ///
cells("b( star label(Coef.) fmt(2)) p(fmt(2) label(p-value))" ///
 se(fmt(2) label(S.E.)))  stats(r2 N, labels("R-cuadrado" "N. de obs.")) replace 

* Usando outreg2
ssc install outreg2 
reg i524a1 p208a i.p207
outreg2 using "$D/Results/tabla_2.doc" , ///
replace keep(p207 p208a)

reg i524a1 p208a i.p207 i.dpto
outreg2 using "$D/Results/tabla_2.doc" , ///
append keep(p207 p208a) 


