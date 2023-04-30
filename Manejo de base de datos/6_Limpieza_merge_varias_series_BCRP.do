/* Crearemos nuestra base de datos con datos mensuales de la tasa de interés, tasa de desempleo y tasa de inflación para lo cual importaremos las series descargadas del BCRP, limpiaremos cada serie para luego realizar un merge y formar nuestra nueva base de datos.*/

cd "" // //colocar el directorio donde está tu base en formato xlsx

*Trabajamos con la 1era serie: importamos y limpiamos la serie de tasa de interés
import excel using "Mensuales-20200803-010124.xlsx", clear 
drop in 1/2
rename (*) (t interes)
drop if interes == "n.d."
destring(interes), replace

gen month = substr(t,1,3)
gen year = substr(t,4,2)

gen mes =. 
replace mes = 1 if month=="Ene"
replace mes = 2 if month=="Feb"
replace mes = 3 if month=="Mar"
replace mes = 4 if month=="Abr"
replace mes = 5 if month=="May"
replace mes = 6 if month=="Jun"
replace mes = 7 if month=="Jul"
replace mes = 8 if month=="Ago"
replace mes = 9 if month=="Sep"
replace mes = 10 if month=="Oct"
replace mes = 11 if month=="Nov"
replace mes = 12 if month=="Dic"

destring(year), replace
replace year = year + 1900 if year>=94
replace year = year + 2000 if year<94

gen date = ym(year, mes)
format date %tm

keep date interes

tempfile interes
save `interes', replace //guardamos en la memoria temporal de Stata


*Trabajamos con la 2da serie: importamos y limpiamos la serie tasa de desempleo
import excel using "Mensuales-20200803-005910.xlsx", clear 
drop in 1/2
rename (*) (t desempleo)
drop if desempleo == "n.d."
destring(desempleo), replace

gen month = substr(t,1,3)
gen year = substr(t,4,2)

gen mes =. 
replace mes = 1 if month=="Ene"
replace mes = 2 if month=="Feb"
replace mes = 3 if month=="Mar"
replace mes = 4 if month=="Abr"
replace mes = 5 if month=="May"
replace mes = 6 if month=="Jun"
replace mes = 7 if month=="Jul"
replace mes = 8 if month=="Ago"
replace mes = 9 if month=="Sep"
replace mes = 10 if month=="Oct"
replace mes = 11 if month=="Nov"
replace mes = 12 if month=="Dic"

destring(year), replace
replace year = year + 1900 if year>=94
replace year = year + 2000 if year<94

gen date = ym(year, mes)
format date %tm

keep date desempleo

tempfile desempleo
save `desempleo', replace //guardamos en la memoria temporal de Stata


* Trabajamos con la 3era serie: importamos y limpiamos la serie de tasa de inflación
import excel using "Mensuales-20200803-011320.xlsx", clear 
drop in 1/2        //eliminamos los encabezados
rename (*) (t inf) // cambiamos nombre de las variables
drop if inf == "n.d." // borramos los datos donde no nay información  
destring(inf), replace  // pasamos 

gen month = substr(t,1,3)
gen year = substr(t,4,2)

gen mes =. 
replace mes = 1 if month=="Ene"
replace mes = 2 if month=="Feb"
replace mes = 3 if month=="Mar"
replace mes = 4 if month=="Abr"
replace mes = 5 if month=="May"
replace mes = 6 if month=="Jun"
replace mes = 7 if month=="Jul"
replace mes = 8 if month=="Ago"
replace mes = 9 if month=="Sep"
replace mes = 10 if month=="Oct"
replace mes = 11 if month=="Nov"
replace mes = 12 if month=="Dic"

destring(year), replace
replace year = year + 1900 if year>=94
replace year = year + 2000 if year<94

gen date = ym(year, mes)
format date %tm

keep date inf

************* Merge  *************
*Realizamos un merge de con las series de tiempo  interés y desempleo


merge 1:1 date using `interes', nogen keep(3)
merge 1:1 date using `desempleo', nogen keep(3)

save "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data/bcrp.dta", replace