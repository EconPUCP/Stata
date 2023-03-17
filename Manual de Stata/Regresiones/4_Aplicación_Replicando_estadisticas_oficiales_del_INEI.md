# Regresiones

### 4 REPLICANDO ESTADISTICAS OFICIALES DEL INEI USANDO ENAHO


Como aplicación vamos a replicar algunos estadísticos oficiales del INEI usando la ENAHO junto a su diseño muestral. Particularmente nos enfocaremos en el porcentaje de población en situación de pobreza monetaria, según ámbito geográfico para el 2018.

![image](https://user-images.githubusercontent.com/106888200/224205636-f6c3869e-0a9d-4bfd-b257-5e6e650cf0e0.png)

En este caso apuntamos a replicar la columna para el 2018.
Vamos a usar el módulo de ‘Sumarias’ de la ENAHO 2018. Este módulo hace un resumen de distintas variables recolectadas en otros módulos. Adicionalmente incluye algunas variables ya trabajadas como la condición de pobreza para cada hogar. Antes de hacer los estimados hay que definir el diseño muestral.

```
* Definimos el diseño muestral 
gen factor_hogar =  factor07*mieperho
svyset conglome [pweight =  factor_hogar], strata(estrato) vce(linearized) 
```

En este caso tenemos que hacer un ajuste previo al factor de expansión para que se estime a nivel de hogar. Se debe multiplicar el factor de expansión por el número de miembros por hogar y considerar esto como nuevo factor de expansión.
Creamos las variables de pobreza a partir de la clasificación propia de la ENAHO:

```
* Creamos la categoría para pobreza 
gen poverty = 1 if pobreza == 1 | pobreza == 2
replace poverty = 0 if pobreza == 3
```

Creamos una serie de categorías para Lima Metropolitana, para urbano/rural, para región natural y región natural cruzado con urbano/rural.

```
* Creamos la categoría para pobreza 
gen poverty = 1 if pobreza == 1 | pobreza == 2
replace poverty = 0 if pobreza == 3

* Creamos la categoría para pobreza extrema
gen extr_poverty = 1 if pobreza == 1 
replace extr_poverty = 0 if pobreza == 2 | pobreza == 3

/* Creamos categorías para región y provincia.
   Con esto creamos una variable "lima" que sea Lima Metropolitana y Callao
   Para ver cómo interpretar los códigos de ubigeo puede entrar
   a la página del INEI:
   http://webinei.inei.gob.pe:8080/sisconcode/proyecto/index.htm?proyectoTitulo=UBIGEO&proyectoId=3
*/
gen dpto = substr(ubigeo,1,2)
gen prov = substr(ubigeo,1,4)

gen lima = 1 if prov =="1501" | dpto == "07"
replace lima = 0 if lima ==. 

* Creamos las categorías rural/urbano
gen rural = 1 if estrato == 6 | estrato == 7 | estrato == 8
replace rural = 0 if rural == .

* Creamos las categorías para dominio geográfico
gen dominio_geo = .
replace dominio_geo = 1 if dominio == 1 | dominio == 2 | dominio == 3 | dominio == 8
replace dominio_geo = 2 if dominio == 4 | dominio == 5 | dominio == 6 
replace dominio_geo = 3 if dominio == 7
```

Una mejor manera de presentar e interpretar los datos es etiquetando a nuestras variables utilizando el comando "label define", veamos el ejemplo:

```
*etiquetar a nuestras variables
label define nombre_lima 0"Resto País" 1"Lima"
label values lima nombre_lima

label define nombre_dominio 1"costa" 2"sierra" 3"selva"
label values dominio_geo nombre_dominio

label define nombre_rural 0"urbano" 1"rural"
label values rural nombre_rural
```

Usamos el comando `mean` para obtener el estimador del promedio. Adicionalmente, usamos la opción `, over()` para las categorías sobre las cuales obtener el promedio estimado.

```
* Tasa de pobreza para el Perú
svy: mean poverty

* Tasa de pobreza para el Lima + Callao y resto del Perú
svy: mean poverty, over(lima)

* Tasa de pobreza rural y urbana
svy: mean poverty, over(rural)

* Tasa de pobreza por dominio geográfico
svy: mean poverty, over(dominio_geo)

* Tasa de pobreza por dominio geográfico y rural o urbano
svy: mean poverty, over(dominio_geo rural)
```

Con esto se obtienen los mismos resultados que en las estadísticas oficiales del INEI. Tomemos como ejemplo los estimados sobre dominio y urbano/rural.
La definición para cada valor de _subpoop_ está dado en el mismo resultado. Por ejemplo _subpoop_1 sería Costa Urbana.

![image](https://user-images.githubusercontent.com/106888200/224217043-5a04904e-9c72-471e-8684-81858a236137.png)

En estos casos también podemos comparar los intervalos de confianza de cada estimador presentados tanto en las estadísticas oficiales como en los resultados del código.


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
