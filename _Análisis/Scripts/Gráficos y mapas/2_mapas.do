************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 2_mapas.do
* OBJETIVO: Mapas y georreferenciación
************

* Preámbulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd
global D "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"
global mapa "$D/DEPARTAMENTOS/DEPARTAMENTOS.shp"


************
* Se debe instalar previamente 
ssc install shp2dta // para convertir archivo shp a dta
ssc install spmap  // sirve para graficar mapas
ssc install mif2dta

*Transformamos los datos de shapefiles a dta
shp2dta using "$mapa", database(dpto) coordinates(dpto_coord) genid(dpto_id)  replace


* Dibujamos un mapa
use "dpto.dta", clear
spmap using "dpto_coord.dta", 						///
id(dpto_id) ocolor(black) title("Limites departamentales del Perú")



*Haciendo mapas en Stata anexando con otros datos
use "dpto.dta", clear
merge 1:1 dpto_id using "gastoporalumno_region.dta"
gen delta = (log(y2018) - log(y2008))*100

spmap delta using "dpto_coord.dta", id(dpto_id) fcolor(Reds) 		

spmap delta using "dpto_coord.dta", id(dpto_id) fcolor(Reds) clnumber(9) // el comando clnumber nos ayuda a seleccionar cuántas categorias queremos que nos separe.		
 
 
 
 
