# Gráficos y mapas

### 2. MAPAS Y GEORREFERENCIACIÓN

Stata también permite graficar mapas simples de manera rápida frente a otros softwares como ArcGis o Qgis que, aunque se especializan en mapas, pueden requerir de una curva de aprendizaje más trabajosa. Por lo que usar Stata para hacer mapas simples iniciales puede ser de mucha utilidad. A pesar de esto, un manejo más profundo y específicos de mapas requeriría usar los programas antes mencionados. 
Ahora, comenzaremos conociendo cómo manejar los datos necesarios para hacer mapas. Luego tomaremos estos datos y los combinaremos con datos más estándar para hacer mapas básicos informativos.

### 2.1 MANEJANDO DATOS GEOGRÁFICOS

Los softwares especializados en mapas pueden tomar como insumo distintos tipos de datos. En este caso partiremos de datos llamados shapefiles, estas bases contienen información de ubicaciones espaciales en términos de coordenadas (longitud y latitud). 
Podemos encontrar datos de shapefiles para distintos lugares buscando en google. Busquemos para Perú y descarguemos los shapefiles a nivel departamental (es decir, los límites de los departamentos).

Luego de descargar el archivo lo guardamos en las carpetas en donde guardamos los datos de la sesión. Deberíamos tener una carpeta con los siguientes datos: 

![image](https://user-images.githubusercontent.com/106888200/223744561-7d936cf1-81e8-44d5-89e7-5c1b618da679.png)

La terminación de un archivo shapefile es ‘.shp’. El resto de archivos los podemos mantener en la misma carpeta.

#### 2.1.1 Transformando datos shapefile a datos dta

Recrearemos un ejemplo del curso de Laboratorio de Econometría I - Stata de Diego Quispe Ortogorin. Luego de ordenar los shapefiles que usaremos tenemos que transformalo a un formato que Stata pueda interpretar. 
Para ello usamos el comando shp2dta (se debe instalar previamente si es que no se tiene disponibles). El comando shp2dta (using) el archivo shapefile y crea dos nuevas bases de datos.

```
* Se debe instalar previamente 
ssc install shp2dta // para convertir archivo shp a dta
ssc install spmap  // sirve para graficar mapas
ssc install mif2dta

*Transformamos los datos de shapefiles a dta
shp2dta using "$mapa", database(dpto) coordinates(dpto_coord) genid(dpto_id)  replace
```

Adicionalmente, indicamos el nombre de la nueva variable indicador, dpto_id. Por último, indicamos el comando replace.
Los nombres de estas bases están dadas en data() y en coord(), ambas son dpto y dpto_coord. Abramos las bases nuevas:

![image](https://user-images.githubusercontent.com/106888200/223776669-cfe6bee0-d982-4359-9922-5d91a9542401.png)

En la base dpto encontramos los nombres de los departamentos junto a las variables indicador, ‘IDPPTO’ y ’dpto_id’.

![image](https://user-images.githubusercontent.com/106888200/223776921-bb5d21b4-a7f2-4d65-945c-ea55c0f5a9f8.png)

En la base dpto_coord encontramos las coordenadas de los límites de cada unidad, en este caso las regiones.
Luego de transformar los datos podemos hacer un gráfico simple de los límites departamentales del Perú: 

```
* Dibujamos un mapa
use "dpto.dta", clear
spmap using "dpto_coord.dta", 						///
id(dpto_id) ocolor(black) title("Limites departamentales del Perú")
```

Luego de cargar la base que transformamos previamente usamos el comando spmap (hay que instalarlo previamente) usando (using) la base de coordenadas que creamos previamente. Adicionalmente, hay que indicar el indicador de cada departamento, en este caso dpto_id indica el indicador. Adicionalmente podemos definit el color de cada unidad (o polígonos) usando `ocolor`.
Obtendríamos un mapa como el siguiente:

![image](https://user-images.githubusercontent.com/106888200/223777437-67057f1a-c8b9-47af-b939-87a3e4766d37.png)

### 2.2 HACIENDO MAPAS EN STATA 

Juntemos estos datos iniciales con alguna base externa. En este caso vamos a usar una base de datos de gasto público por alumno en educación secundaria que construimos a partir de los datos del INEI. En este caso hemos trabajado previamente el excel inicial para tener un formato fácil de cargar al programa y que tenga una variable indicador igual al que usamos en las bases de mapas, es decir dpto_id.

```
*Haciendo mapas en Stata anexando con otros datos
use "dpto.dta", clear
merge 1:1 dpto_id using "gastoporalumno_region.dta"
gen delta = (log(y2018) - log(y2008))*100

spmap delta using "dpto_coord.dta", id(dpto_id) fcolor(Reds) 		
```

Luego de cargar la base de mapas la juntamos con la base previamente construida ‘gastoporalumno_region’ usando la variable indicador. Posteriormente creamos una variable delta que mida la tasa de crecimiento entre le gasto del 2018 y el del 2008. Luego usamos un código similar al previo, pero indicando que se use la variable nueva.

![image](https://user-images.githubusercontent.com/106888200/223778388-ed41a108-708b-4a36-86ca-903631bcd274.png)

Los departamentos con mayor crecimiento en este gasto público serían Amazonas, Madre de Dios, Puno, Apurímac, Ayacucho y Huancavelica.
Las posibilidades para hacer mapas en Stata son bastante extensas por lo que se recomienda ver algunos recursos virtuales como guías o documentación en la ayuda del programa escribiendo help spmap o help shp2dta.



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
