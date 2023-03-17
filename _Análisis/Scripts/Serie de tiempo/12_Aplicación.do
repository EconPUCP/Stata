************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 12_Aplicación.do
* OBJETIVO: Modelo VAR
************

*Preámbulo
clear all
cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // cambiar cd

************
use "bcrp.dta"

tsset date // establecer que la base de datos es una serie de tiempo
keep if tin(2005m5, 2019m12)

* Vemos las series

tsline interes desempleo inf, ttitle("") ytitle("%") ///
 legend(order(1 "Interés" 2 "Desempleo" 3 "Inflación") cols(3))
  
* Verificamos estacionariedad en cada una de las series
dfuller interes
dfuller desempleo
dfuller inf 

* Vemos el número de rezagos
varsoc interes desempleo inf

* Estimamos el VAR
varbasic inf desempleo interes , lags(1/2)

matrix A1 = (1,0,0 \ .,1,0 \ .,.,1)
matrix B1 = (.,0,0 \ 0,.,0 \ 0,0,.)

svar inf desempleo interes, lags(1/2) aeq(A1) beq(B1)

matlist e(A)
matlist e(B)

irf create svar_irf, step(36) set(irf_2) replace
irf graph sirf, impulse(inf desempleo interes) response(inf desempleo interes) xtitle("Periodos")


