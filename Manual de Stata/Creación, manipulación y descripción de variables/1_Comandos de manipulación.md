# Creación, manipulación y descripción de variables

###  1 COMANDOS DE MANIPULACIÓN

Para manejar los datos debemos aprender a crearlos y reemplazarlos de acuerdo a las distintas condiciones o situación que enfrentemos. 

### 1.1 MANEJO DE VARIABLES: GEN, REPLACE, KEEP, DROP, LABEL Y RECODE


#### 1.1.1 Generate y replace

Los comandos `generate` y `replace` sirven para permitirnos crear nuevas variables o modificar los valores existentes. Tomemos un ejemplo, consideremos que Canadá, como en la mayoría de países desarrollados, las mujeres tienden a vivir más que los hombres. Para analizar estas diferencias por región, puede ser de interés cargar una base de datos y generar una nueva variable que mida la diferencia entre la expectativa de vida de las mujeres menos la expectativa de vida de los hombres.

Veamos el ejemplo: Cargamos la base de datos, a partir de esto creamos una nueva variable.

![image](https://user-images.githubusercontent.com/106888200/223461243-c66fbe59-56f7-47fd-b6d5-fea5fade7917.png)

Como vemos tenemos distintas unidades de observación. Al inicio tenemos al país en general y luego tanto provincias como territorios (siguiendo la propia división del país). Para poder diferenciar esto creamos una nueva variable y reemplazamos de acuerdo a lo que corresponda:
Creamos una variable vacía con el comando gen y luego reemplazamos de acuerdo a los lugares usando el comando replace junto al comando if (este último fue visto ligeramente en la semana previa pero será retomado en puntos adelante).

```
clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar dirección donde                                                                     //tengas tu base de datos
global Canadá "_Canadá.dta"

**************************************************

* Cargamos la base de datos haciendo uso del global

use "$Canadá", clear

generate gap = flife - mlife

gen tipo = "" /*estamos creando una variable vacia*/
replace tipo = "Pais" 		if place == "Canada"
replace tipo = "Territorio" if place == "Yukon"         | place == "Northwest Territories"
replace tipo = "Provincia"  if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
							   place == "New Brunswick" | place == "Quebec" 	 		  | place == "Ontario" 		| ///
							   place == "Manitoba"		| place == "Saskatchewan"		  | place == "Alberta"		| ///
							   place == "British Columbia"

```
La nueva base incluye la brecha inicial junto a las categorías de cada lugar:

![image](https://user-images.githubusercontent.com/106888200/223466780-a775f626-c660-4042-8943-5eb196a1b628.png)


#### 1.1.1 Keep y drop

Los comandos `keep` y `drop` sirven para mantener y eliminar variables respectivamente. Ambas variables pueden ser utilizadas de distintas maneras al ser combinadas con los comandos `if` y `in`.

![image](https://user-images.githubusercontent.com/106888200/223467443-5e448c0d-9d83-4554-b7ea-6edb1eb9dfc6.png)
![image](https://user-images.githubusercontent.com/106888200/223467602-bd9b0187-66da-4fa9-a0ef-a3e6a0d658ec.png)

De las tres opciones que se permiten usar: i) la primera elimina o mantiene variables (es decir, las columnas en el editor de datos); ii) la segunda, permite agregar condiciones a lo primero usando el comando if (similar a como se usó el comando if en el tópico previo); y, iii) la tercera, elimina o mantiene variable de acuerdo al ‘lugar’ de la observación (es decir, ya no eliminamos/mantenemos columnas sino filas). 

Veamos, en el primer caso eliminamos las variables mlife y flife, las medidas de expectativa de vida para hombre y mujer.

```
* Eliminemos algunas observaciones de distintas maneras

use "$Canadá", clear

generate gap = flife - mlife

gen tipo = ""
replace tipo = "Pais" 		if place == "Canada"
replace tipo = "Territorio" if place == "Yukon"         | place == "Northwest Territories"
replace tipo = "Provincia"  if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
							   place == "New Brunswick" | place == "Quebec" 	 		  | place == "Ontario" 		| ///
							   place == "Manitoba"		| place == "Saskatchewan"		  | place == "Alberta"		| ///
							   place == "British Columbia"

drop mlife flife /*eliminamos por columna*/

drop if tipo == "Territorio" /*eliminamos por condición*/

drop in 1 /*eliminamos por ubicación*/
```

En el segundo caso eliminamos las observaciones que son territorios. Si queremos quedarnos solo con las observaciones que son Provincias debemos eliminar el dato para el país. Para ello, veamos el tercer caso. Aquí usamos drop in 1 para eliminar el dato que se encuentra en la posición número 1. De esa manera nos quedamos con la siguiente base de datos:

![image](https://user-images.githubusercontent.com/106888200/223468202-0d5a547a-339e-410e-9e72-a0dd901ad2bf.png)

Realicemos el mismo ejemplo usando el comando keep.


```
* Repitamos el ejercicio anterior pero usando el comando keep

use "$Canadá", clear

generate gap = flife - mlife

gen tipo = ""
replace tipo = "Pais" 		if place == "Canada"
replace tipo = "Territorio" if place == "Yukon"         | place == "Northwest Territories"
replace tipo = "Provincia"  if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
							   place == "New Brunswick" | place == "Quebec" 	 		  | place == "Ontario" 		| ///
							   place == "Manitoba"		| place == "Saskatchewan"		  | place == "Alberta"		| ///
							   place == "British Columbia"

keep place pop unemp gap tipo
 
keep if tipo == "Provincia" | tipo == "Pais" 

keep in 2/11

```

Al igual que en el caso anterior, podemos usar keep para mantener el resto de las variables a excepción de las variables de expectativas de vida. Luego podemos mantener las observaciones que son Provincia y País. Y, por último, podemos mantener sólo las observaciones para provincia usando el comando in. Con respecto a este último punto, nos quedamos con las observaciones que se encuentran desde la 2da posición hasta la posición 11. De esta manera, acabamos con la misma base de datos. Es decir, tanto keep y drop pueden ser usadas de la misma manera de acuerdo a lo que convenga.

### 1.2 ESPECIFICANDO CONDICIONES: IF, IN Y BY

Los comandos de condiciones, o qualifiers en inglés sirven para establecer que cierto comando, rutina o código se lleve a cabo para cierto grupo de variables u observaciones de acuerdo a la/s condiciones impuestas. 
En puntos previos ya hemos usado los comandos if e in, ahora indagaremos un poco más y aprenderemos un nuevo comando: by. Este comando repite las tareas que se asignan para un subconjunto de datos.
Veamos un ejemplo:

![image](https://user-images.githubusercontent.com/106888200/223468473-e940bad4-efa5-4536-9404-383d806811c4.png)

Luego de crear una nueva variable que categorice a cada tipo de observación queremos obtener algunos estadísticos descriptivos por grupo. En este caso, la forma del código cambia ligeramente, ahora se pone al inicio de la línea seguido por la variable que indique los subgrupos y dos puntos. Posteriormente se indica la operación que se debe repetir.

```
use "$Canadá", clear

gen tipo = .
replace tipo = 1 if place == "Canada"
replace tipo = 2 if place == "Yukon"         | place == "Northwest Territories"
replace tipo = 3 if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
					place == "New Brunswick" | place == "Quebec" 	 		   | place == "Ontario" 	 | ///
					place == "Manitoba"		 | place == "Saskatchewan"		   | place == "Alberta"		 | ///
					place == "British Columbia"

bysort tipo: summ pop unemp
```

![image](https://user-images.githubusercontent.com/106888200/223469134-5098309e-7365-4d35-9966-cd56a20a0b2b.png)


En este caso usamos la opción bysort para que automáticamente se ordene (sort) los datos y el programa pueda repetir la tarea en cada subgrupo.

#### 1.2.1 Etiquetas

Stata permite etiquetar la base de datos (data label), etiquetar las variables dentro de la base de datos (variable label) y etiquetar los valores de cada variables (value labels).

- data label:
Etiqueta la base de datos en conjunto, nos permite tener una descripción de todo dentro de la base.
- variable label:
Etiqueta cada variable dentro de la base. Sirve para saber qué es o qué mide cada variable.
- value label: 
Etiqueta los valores de las variables. Se usa, por ejemplo, cuando los valores en sí no son informativos sino las categorías que representan.
Démosle etiquetas tanto a la base de datos como a cada variable:

```
* Usando etiquetas en Stata

use "$Canadá", clear

*Etiquetamos la base de datos
label data "Esta base de datos contiene información acerca del desempleo y las expectativas de vida por género en Canadá."

*Etiquetamos cada variable en la base de dato
label variable place "Lugar, puede ser país, territorio o provincia"

label variable pop   "Población, en miles de personas"

label variable unemp "Tasa de desempleo"

label variable mlife "Expectativa de vida para el hombre"

label variable flife "Expectativa de vida para la mujer"
```

Para ver las etiquetas abrimos la ventana de variables y de propiedades en la interfaz inicial o en el editor/navegador de variables:

![image](https://user-images.githubusercontent.com/106888200/223469820-54cef17c-7798-4fab-b6a7-d0ccb66f0ccb.png)

Las etiquetas de valores tienen más sentido cuando se tienen variables categóricas como por ejemplo el género de la persona, el distrito de origen o alguna característica adicional. Tomemos como ejemplo que re creamos la variable tipo del inicio pero considerándola como números en vez de cadenas (string). En primer lugar, se deben definir las etiquetas de cada categoría. Por ejemplo, 1 será ‘País’; 2, ‘Territorio’; y, 3, ‘Provincia’. Para ello usamos el comando label define seguido por el nombre del conjunto de etiquetas y el par de valor y etiqueta respectivo a modificar. Veamos:

```
* Creamos la variable tipo como número 
gen tipo = .
replace tipo = 1 if place == "Canada"
replace tipo = 2 if place == "Yukon"         | place == "Northwest Territories"
replace tipo = 3 if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
					place == "New Brunswick" | place == "Quebec" 	 		   | place == "Ontario" 	 | ///
					place == "Manitoba"		 | place == "Saskatchewan"		   | place == "Alberta"		 | ///
					place == "British Columbia"

label define tipo_l 1 "País" 2 "Territorios" 3 "Provincias"
label values tipo tipo_l
```

Como resultado obtenemos lo siguiente:

![image](https://user-images.githubusercontent.com/106888200/223470128-79101db6-9868-4932-ace3-ae6b74a13c2d.png)

Como vemos, ahora los nombres están en azul indicando que son etiquetas y no valores en cadena.

#### 1.2.1 Recode

El comando recode sirve para recodificar los valores de una variable. Esto significa cambiar los valores de manera conjunta.

![image](https://user-images.githubusercontent.com/106888200/223470503-7b1dd510-1dfa-4ef4-a35c-31b78b803757.png)

La tabla presenta la sintaxis de las distintas opciones que permite. Veamos un ejemplo simple. En este caso tenemos una variable que toma el valor de 1 cuando se tiene a la región con la capital y 0 para el resto de lugares. Queremos recodificar estas categorías haciendo que la capital tenga el valor 2 y el resto de lugares el valor 1.
Luego de indicar la variable a recodificar, indicamos el orden de las variables entre paréntesis:

```
* Comando recode

use "$Canadá", clear

gen		capital 	= 1 if place == "Ontario"
replace capital		= 0 if place != "Ontario"

recode capital (0=1) (1=2) 
```

Obtenemos lo siguiente:

![image](https://user-images.githubusercontent.com/106888200/223470840-fae8689e-5b59-475d-a7a1-f558a1b2e860.png)

aplicado el recode, nos debe quedar así:

![image](https://user-images.githubusercontent.com/106888200/223471111-426faa34-b888-454b-89da-2462377137b6.png)

#### 1.2.3 If

El comando if puede ser confundido con otro del mismo nombre usado para ‘programar’ rutinas dentro del propio Stata. En este caso solo exploraremos su uso como un qualifier.

```
* Comando if 

use "$Canadá", clear

generate gap = flife - mlife

gen 	unemp_place = 1 if unemp>=10 & unemp !=.
replace unemp_place = 0 if unemp<10	 & unemp !=.

gen		capital 	= 1 if place == "Ontario"
replace capital		= 0 if place != "Ontario"

replace unemp 		= 0 if unemp == .
```

Luego de cargar la base de ejemplo, usamos el comando if en tres casos. En el primero generamos una nueva variable unemp_place que toma el valor de 1 cuando la tasa de desempleo (unemp) es mayor al 10% y toma el valor de 0 en el resto de casos. en el segundo caso creamos una nueva variable llamada capital que toma el valor de 1 cuando la observación es Ontario (la región de la capital). En el tercer caso, reemplazamos los valores de desempleo a 0 cuando el valor inicial es un missing value.

![image](https://user-images.githubusercontent.com/106888200/223471507-9e7b5873-80df-48c3-8cc2-25fb52cf7725.png)


#### 1.2.4 In

Como vimos algunos puntos atrás, el comando in permite especificar que los cambios se den en filas específicas al indicar el número de la fila. Repliquemos la base previa usando los comandos in.

```
* Comando in

use "$Canadá", clear

generate gap = flife - mlife

gen 	unemp_place = 1 in 1/6
replace unemp_place = 0 in 7/13

gen		capital 	= 1 in 7
replace capital		= 0 in 1/6 
replace capital 	= 0 in 8/13

replace unemp 		= 0 in 12/13
```

En este caso debemos indicar la posición exacta de cada linea. Cuando indicamos reemplazar los valores de las observaciones que no son capital con 0 partimos el código en dos. Primero de la posición 1 a la 6 y luego de la 8 a la 13. Ojo: como se ve, el comando in es sensible al ordenamiento de las filas. Esto significa que si las filas se ordenan de otra manera, el código resultaría en algo distintos. Veamos un ejemplo.

Consideremos el mismo código, pero ahora usemos el comando sort para ordenar las filas de menor a mayor de acuerdo a la variable que se indique. Ordenemos la base de acuerdo a la tasa de desempleo:

```
*Ahora ordenemos los datos de acuerdo al desempleo y usemos el comando in

use "$Canadá", clear

sort unemp

generate gap = flife - mlife

gen 	unemp_place = 1 in 1/6
replace unemp_place = 0 in 7/13

gen		capital 	= 1 in 7
replace capital		= 0 in 1/6 
replace capital 	= 0 in 8/13

replace unemp 		= 0 in 12/13
```

Al ver la base final, encontramos que es distinta a la anterior:

![image](https://user-images.githubusercontent.com/106888200/223471908-6d4c2faa-cb0b-4d0d-8ba1-d9cbaa9daccc.png)

> **TIP: `inspect` para un resumen rápido**
>
> Si desea verificar una variable rápidamente, usa el comando `inspect`, que es similar a `summarize` pero brinda un histograma ordenado en la ventana de resultados.
> Si necesitas aprender más de este comando puedes teclear `help inspect` en la ventana de comando.



****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/6_merge_append.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
