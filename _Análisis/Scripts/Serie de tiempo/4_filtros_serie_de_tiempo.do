************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 4_filtros_serie_de_tiempo.do
* OBJETIVO: Filtros y suavización de series
************

*Preámbulo

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd

************


* Cargamnos los datos trimestrales

use "pbi_trimestre", clear
tsset trimestre

* Moving average

tssmooth ma PBI_ma = PBI, window(2 1 2)
tssmooth ma C_ma   = C  , window(2 1 2)
tssmooth ma I_ma   = I  , window(2 1 2)
tssmooth ma G_ma   = G  , window(2 1 2)
tssmooth ma XN_ma  = XN , window(2 1 2)

tsline PBI_ma PBI if tin(1995q1,2015q1), xtitle("") ///
legend(order(1 "Series Filtrada" 2 "Series Original") cols(2)) ///
tlabel(1995q1(8)2015q1, labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

/*	Otros filtros */

* Filtro Hodrick-Prescott - HP

tsfilter hp PBI_ciclo = PBI, trend(PBI_tendencia) smooth(1600)

tsline PBI_tendencia PBI, xtitle("") ///
legend(order(1 "Tendencia del PBI" 2 "PBI") cols(2)) ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

tsline PBI_ciclo, xtitle("") ytitle("") title("Ciclo del PBI") ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

* Filtro BK

tsfilter bk PBI_ciclo_bk = PBI , minperiod(6) maxperiod(32) ///
trend(PBI_tendencia_bk)

tsline PBI_tendencia_bk PBI, xtitle("") title("Filtro Baxter - King") ///
legend(order(1 "Tendencia del PBI" 2 "PBI") cols(2)) ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

tsline PBI_ciclo_bk, xtitle("") ytitle("") title("Ciclo del PBI, Filtro Baxter-King") ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

* Filtro CF

tsfilter cf PBI_ciclo_cf = PBI , minperiod(6) maxperiod(32) ///
trend(PBI_tendencia_cf)

tsline PBI_tendencia_cf PBI, xtitle("") title("Filtro Christiano-Fitzgerald") ///
legend(order(1 "Tendencia del PBI" 2 "PBI") cols(2)) ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

tsline PBI_ciclo_cf  PBI_ciclo_bk, xtitle("") ytitle("") ///
title("Ciclo del PBI") ///
legend(order(1 "CF" 2 "BK" )) ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

* Filtro Butterworth

tsfilter bw PBI_ciclo_bw = PBI, maxperiod(32) order(2) trend(PBI_tendencia_bw)

tsline PBI_tendencia PBI_tendencia_bk PBI_tendencia_cf PBI_tendencia_bw, ///
 xtitle("") title("Tendencias estimadas") ///
legend(order(1 "HP" 2 "BK" 3 "CF" 4 "BW") cols(2))  ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)

tsline PBI_ciclo_cf  PBI_ciclo_bk  PBI_ciclo_bw, xtitle("") ytitle("") ///
title("Ciclo del PBI") ///
legend(order(1 "CF" 2 "BK" 3 "BW" ) cols(3)) ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)