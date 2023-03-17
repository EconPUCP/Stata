************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 4_aplicación_mapa.do
* OBJETIVO: Mapas y georreferenciación
************

*Preámbulo 

cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"         //  cambiar cd
global D "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data"  //  cambiar cd
global mapa "$D/DEPARTAMENTOS/DEPARTAMENTOS.shp"
**********************************


*importar base de datos del censo nacional de comisarias, 2017

import dbase using "Cap_100_Infraestructura_2017_1.dbf"

*crearemos la variable dpto_id
g dpto_id= real(substr(UBIGEO,1,2))

collapse (mean) INF109, by(dpto_id)

save "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data/comisarias.dta", replace

*Transformamos los datos de shapefiles a dta
shp2dta using "$mapa", database(dpto) coordinates(dpto_coord) genid(dpto_id)  replace

*Haciendo mapas en Stata anexando con otros datos
use "dpto.dta", clear
merge 1:1 dpto_id using "comisarias.dta"

spmap INF109 using "dpto_coord.dta", id(dpto_id) fcolor(Reds) clnumber(3)  title("Población promedio atendida" "en las comisarias" ) 

