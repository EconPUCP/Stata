************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 1_MPL.do
* OBJETIVO: Modelo de Probabilidad Lineal
************

*Preámbulo
clear all
sysuse lbw 

*************

describe 

tab low // variable dependiente

*MPL
*estimación sin considerar la heterocedasticidad
reg low age lwt i.race smoke ht  //
est store mpl_1

*estimación considerando la heterocedasticidad
reg low age lwt i.race smoke ht, robust  //
est store mpl_2

*comparando los resultados
esttab mpl_1 mpl_2, nomtitle r2 p
