************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 10_ARCH_GARCH.do
* OBJETIVO: Modelos ARCH y GARCH
************

*Preámbulo

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data"

************

use "Diarias_bcrp"

* Creamos una nueva variable de tiempo
gen t = _n

tsset t

tsline igb, ttitle("Periodos, 0 = 01Ene2010") ytitle("") title("Índice General Bursatil")

* Generamos la serie de retorno
gen retorno=(igb - l.igb)/l.igb

tsline retorno, ttitle("Periodos, 0 = 01Ene2010") ytitle("%") title("Tasa de Crecimiento Índice General Bursatil")

dfuller retorno // test ADF para raíz unitaria

* Seleccionamos los rezagos del modelo
ac retorno
pac retorno

varsoc retorno

* Verificamos si hay efectos ARCH
reg retorno 

estat archlm, lags(1)

* Estimamos los modelos

arch retorno, arch(1)

arch retorno, arch(1) garch(1)

predict htgarch, variance
 
tsline htgarch, ttitle("Periodos, 0=01Ene2010") ytitle("") title("Varianza estimada, GARCH(1,1)")
