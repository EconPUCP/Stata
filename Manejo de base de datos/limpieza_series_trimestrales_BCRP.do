
/* En este do file primero se importa una serie de tiempo descargada del bcrp en formato xlsx y se procederá a su respectiva limpieza para que luego pueda ser guardad en formato dta*/


*Preámbulo

cd "" //colocar el directorio donde está tu base en formato xlsx

*****************************************

*Cargamos y limpiamos la serie de trimestral del PBI real (s/. 2007)
import excel using "Trimestral-20200731-210453.xlsx", clear 

*Borramos la linea 1 y 2 que suele tener información del nombre de la serie
drop in 1/2

*Renombramos las variables
rename (*) (t pbi)

*Borramos las observaciones que no tienen información
drop if interes == "n.d."

*Pasar de string a numeric
destring(pbi), replace

***************************************
*Trabajar con el formato fecha mensual*
***************************************

*Generar la variable trimestre
gen tri = substr(t,1,2)
gen q = .
replace q = 1 if tri == "T1"
replace q = 2 if tri == "T2"
replace q = 3 if tri == "T3"
replace q = 4 if tri == "T4"

*Generar la variable año
gen year = substr(t,3,2)
destring(year), replace // de string a numeric
replace year = year + 1900 if year>=80
replace year = year + 2000 if year<80

*Generar variable date
gen date = yq(year, q)
format date %tq

*mantener las variables de interés
keep date pbi

*Establecer la data como serie de tiempo y guardar
tsset date // establecer que la base de datos es una serie de tiempo

save "" //colocar el nombre del archivo a guardar y dirección

