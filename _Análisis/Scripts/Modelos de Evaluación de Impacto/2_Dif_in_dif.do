************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_Dif_in_dif.do
* OBJETIVO: Diferencias en diferencias
************

*Preámbulo

cd ""

*************

* Creamos las categorías
gen time = (year>=1994) & !missing(year)

gen treated = (country>4) & !missing(country)

gen did = time*treated

* Estimamos el modelo (las tres formas encuentran lo mismo)
reg y time treated did

reg y time treated time#treated

reg y time##treated

* Usamos diff

*ssc install diff
diff y, t(treated) p(time)