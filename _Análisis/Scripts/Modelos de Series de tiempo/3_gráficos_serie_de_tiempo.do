************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_gráficos_serie_de_tiempo.do
* OBJETIVO: Gráficos de series de tiempo
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd

*************

* Cargamos la base de datos creada previamente
use "pbi_year", clear
tsset year

gen C_s  =  C*100/PBI
gen I_s  =  I*100/PBI
gen G_s  =  G*100/PBI
gen XN_s = XN*100/PBI

line C_s I_s G_s XN_s year if tin(1995,2015), xtitle("") ytitle("% PBI") ///
xlabel(1995(1)2015, grid labsize(*0.6)) ylabel(0(10)70) ///
legend(order(1 "Consumo" 2 "Inversión" 3 "Gasto" 4 "Exp.Netas") ///
cols(4) size(*0.6) ) lcolor(gs0 gs0 gs0 gs0) lpattern(solid - .- ..--) ///
title("Componentes del PBI") name(linea1, replace)

tsline C_s I_s G_s XN_s if tin(1995,2015), xtitle("") ytitle("% PBI") ///
xlabel(1995(1)2015, grid labsize(*0.6)) ylabel(0(10)70) ///
legend(order(1 "Consumo" 2 "Inversión" 3 "Gasto" 4 "Exp.Netas") ///
cols(4) size(*0.6) ) lcolor(gs0 gs0 gs0 gs0) lpattern(solid - .- ..--) ///
title("Componentes del PBI") name(linea2, replace)

* Ahora, veamos los datos trimestrales

use "pbi_trimestre", clear
tsset trimestre

gen C_s  =  C*100/PBI
gen I_s  =  I*100/PBI
gen G_s  =  G*100/PBI
gen XN_s = XN*100/PBI

tsline  C_s I_s G_s XN_s if tin(1995q1,2015q4), xtitle("") ytitle("% PBI") ///
tlabel(1995q1(8)2015q1 2015q4, grid labsize(*0.5)) ylabel(0(10)70) ///
legend(order(1 "Consumo" 2 "Inversión" 3 "Gasto" 4 "Exp.Netas") ///
cols(4) size(*0.6) ) lcolor(gs0 gs0 gs0 gs0) lpattern(solid - .- ..--) ///
title("Componentes del PBI") name(linea2, replace)

