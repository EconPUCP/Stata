************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 11_var_svar.do
* OBJETIVO: Modelo VAR - SVAR
************

*Preámbulo

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data"

************

use "Mensuales2_bcrp"

* Selección de rezagos
tsset date

varsoc ti im, maxlag(8)

var ti im, lags(1/2)

matrix varcov = e(Sigma)
matrix list varcov

* Caudalidad a la Granger

vargranger

* Función de Impulso Respuesta (IRF)

var ti im, lags(1/2)

irf create var_irf , step(36) set(irf_1) replace

irf graph oirf, impulse(ti im) response(ti im) xtitle("Periodos") 

irf graph coirf, impulse(ti im) response(ti im) xtitle("Periodos") 

irf graph fevd, impulse(ti im) response(ti im) xtitle("Periodos") 

* VAR Estructural

matrix A1 = (1,0 \ .,1)

matrix B1 = (.,0 \ 0,.)

svar im ti, lags(1/2) aeq(A1) beq(B1)

matlist e(A)
matlist e(B)

irf create svar_irf , step(36) set(irf_2) replace

irf graph sirf, impulse(ti im) response(ti im) xtitle("Periodos") 


