/* En este do file primero se importa una serie de tiempo descargada del bcrp en formato xlsx y se procederá a su respectiva limpieza para que luego pueda ser guardad en formato dta*/

*Preámbulo

cd "" //colocar el directorio donde está tu base

*****************************************

*Cargamos y limpiamos la serie de tasa de interés
import excel using "Mensuales-20200803-010124.xlsx", clear 

*Borramos la linea 1 y 2 que suele tener información del nombre de la serie
drop in 1/2

*Renombramos las variables
rename (*) (t interes)

*Borramos las observaciones que no tienen información
drop if interes == "n.d."

*Pasar de string a numeric
destring(interes), replace

***************************************
*Trabajar con el formato fecha mensual*
***************************************

*Generar la variable mes

gen month = substr(t,1,3)
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

*Generar la variable año
gen year = substr(t,4,2)
destring(year), replace
replace year = year + 1900 if year>=94
replace year = year + 2000 if year<94

*Generar variable date
gen date = ym(year, mes)
format date %tm

*mantener las variables de interés
keep date interes

*Establecer la data como serie de tiempo y guardar
tsset date // establecer que la base de datos es una serie de tiempo

save "" //colocar el nombre del archivo a guardar y dirección