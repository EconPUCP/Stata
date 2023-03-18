# Aplicación

Para integrar todos los puntos de la sesión, usaremos el modulo 1226 del Censo Nacional de Comisarias - CENACOM 2017.

Importamos una base de datos en formarto dbf
Colapsaremos una base de datos
Transformaremos un archivo shp a dta
Realizaremos un mapa a nivel departamental

El Censo Nacional de Comisarias - CENACOM 2017 tienen como objetivo disponer de una base de datos con información estadística confiable y oportuna sobre el estado actual de la infraestructura y equipamiento, recursos humanos en las comisarías y unidades especializadas a nivel nacional. 

Trabajaremos con el modulo 1226 (capítulo 100 - infraestructura), podemos descargar los módulos directamente desde la base de microdatos del INEI y descomprimirlos o descargalos ya descomprimidos y limpios desde el siguente enlace, importante darnos cuenta que esta base de datos solo está disponible en formato dbf y spss.

Abrimos nuestro dofile desde la ventata de comandos con el comando `doedit` para digitar nuestros la dirección de nuestro directorio 

```
*Preambulo 

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // Se debe cambiar por la dirección dónde 
                                                                     // se encuentra tu base de datos

```

Importaremos nuestra base de dato: 

```
*importar base de datos del censo nacional de comisarias, 2017

import dbase using "Cap_100_Infraestructura_2017_1.dbf"
```

Nuestra variable de interés es la población atendida en las comisarias por lo que obtendremos el valor promedio de la población atendida, para luego proceder a guardar nuestra nueva base de datos.

```
*crearemos la variable dpto_id
g dpto_id= real(substr(UBIGEO,1,2))

collapse (mean) INF109, by(dpto_id)

save "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data/comisarias.dta", replacez
```

Utilizaremos el comando `shp2dta` para crear dos nuevas bases de datos.

```
*Transformamos los datos de shapefiles a dta
shp2dta using "$mapa", database(dpto) coordinates(dpto_coord) genid(dpto_id)  replace
```

Por último obtenemos el valor promedio de la población atendida en las comisarias por departamentos para crear un mapa de ello.

```
*Haciendo mapas en Stata anexando con otros datos
use "dpto.dta", clear
merge 1:1 dpto_id using "comisarias.dta"

spmap INF109 using "dpto_coord.dta", id(dpto_id) fcolor(Reds) clnumber(3)  title("Población promedio atendida" "en las comisarias" ) 
```

Si hemos seguidos pasos correctamente, debemos llegar a una imagen como esta.

![image](https://user-images.githubusercontent.com/106888200/223929068-1e590ab8-84f1-43a1-841b-101659612c29.png)

****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
