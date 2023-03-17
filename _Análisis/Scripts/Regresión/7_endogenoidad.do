************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 7_endogenoidad.do
* OBJETIVO: Endogeneidad y variables instrumentales
************
 
clear all
use "http://fmwww.bc.edu/ec-p/data/wooldridge/openness", clear

* Estimamos un modelo por MC2E
* Manualmente
reg open lland lpcinc 
predict open_hat, xb
reg inf open_hat lpcinc

* Usando ivregress
ivregress 2sls inf (open = lland) lpcinc

* Usando ivreg2
ssc install ivreg2  /// *si tienes un problema al 
                    /// insatalar ivreg2, también 
			        /// instala ranktest
ivreg2 inf (open = lland) lpcinc

* Comparamos los resultados
eststo clear
eststo: reg inf open_hat lpcinc
eststo: ivregress 2sls inf (open = lland) lpcinc
eststo: ivreg2 inf (open = lland) lpcinc
esttab, rename(open_hat Apertura open Apertura lpcinc logIngpc _cons Const) mtitle("Manualmente" "ivregress" "ivreg2")

* Estimemos el modelo usando el método generalizado de momentos o GMM

eststo clear
eststo: ivregress 2sls inf (open = lland) lpcinc
eststo: ivregress gmm  inf (open = lland) lpcinc
esttab , mtitle("2SLS" "GMM")
