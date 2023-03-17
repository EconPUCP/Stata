# Conceptos Básicos

### 2 CREACIÓN E IMPORTACIÓN DE DATOS

Hay distintas formas de crear una base de datos. Repasemos tres formas:

- _Creando una base de datos a mano en el editor de datos_,  para acceder al editor de datos, escribimos `edit` en la ventana de comandos. Esto nos permite editar ‘manualmente’ los datos como si fuera una hoja de cálculo. 

- _Copiando y pegando los datos_, para copiar datos se debe acceder de la misma manera que en el punto previo. En el navegador de datos en modo de edición se pueden copiar datos usando las opciones conocidas como control+v o mediante click derecho. Hasta este punto se explotan las posibilidades del editor de datos como si fuera una hoja de cálculo (Excel).

- _Creando una base de datos en el do-file_, crear una base de datos desde el do-file permite disminuir los posibles errores que se presenten al hacer las cosas ‘a mano’. En primer lugar, se debe establecer la extensión (en términos de filas) de la base de datos con el comando `set obs` seguido por el número de observaciones. A partir de esta ‘cáscara’ se crean nuevas variables.

También podemos combinar estas formas.

#### 2.1.1 Usando el editor de datos para crear una base

Para asegurarnos que no tenemos ninguna base abierta usemos el comando `clear` en la ventana de comandos. Luego, abrimos el editor de datos con el comando `edit` en la ventana de comandos.

![image](https://user-images.githubusercontent.com/106888200/223178593-8fe33262-1709-49dc-b478-89cdd1423558.png)

Creemos una base de datos de los principales equipos de fútbol del Perú junto a su color característico y el número de veces que salieron campeones del Descentralizado imputando cada valor en el editor de datos:

![image435](https://user-images.githubusercontent.com/106888200/223178370-8458c2d4-c866-40a6-8bbb-a753df751d9a.png)



> **TIPS:  `clear` vs `clear all`**
>
>Si bien la mayoría de la gente usa `clear` para borrar el conjunto de datos y las etiquetas, `clear all` hace borrón y cuenta nueva. Usa este último si estás trabajando matrices, mata, marcos, programas, etc.


#### 2.1.2 Copiando datos en el editor de datos

Antes de copiar una base, limpiemos el navegador de datos usando el comando clear en la ventana de comando. Abramos el excel de ejemplo, ‘cuadro-19-4, seleccionamos las filas que van desde Amazonas hasta Lima para todos los años de la siguiente manera:

![image436](https://user-images.githubusercontent.com/106888200/223179332-7e726872-ff50-4584-ae2f-818eea8f4891.png)

Copiamos los datos usando `ctrl+c`. Ahora, se puede pegar directamente en el editor de datos usando `ctrl+v`.
Como vemos, luego de pegar aún se puede mejorar la base editando los nombres de las variables antes de guardarla.

![image437](https://user-images.githubusercontent.com/106888200/223179886-461fec04-b655-4e71-9e26-94c3eaf270b6.png)

Editamos los nombres de cada variable para pulir la base antes de guardarla.

![image438](https://user-images.githubusercontent.com/106888200/223179927-77340fc0-c853-40f9-9ac9-97523ccf2c2f.png)

#### 2.1.3 Creando una base en el do-file

Abramos el editor de do-files. En este caso vamos a crear un cascarón (o shell) que definirá la extensión de los datos. Supongamos que estamos revisando archivos históricos y debemos de almacenar cada dato con algún comentario para doce meses de un año. Hacerlo a mano puede generar problemas para editar posteriormente. Así que lo hacemos dato a dato en el do-file. Veamos el ejemplo:

```
*--------------------------------------
*Crear la cáscara de una base de datos
*--------------------------------------

* Fijamos el número de observaciones

clear // Limpiamos el navegador de datos previos
set obs 12 // Se consideran solo 100 filas

gen value =.  // Valor a almacenar *estamos generando una variable vacia*

gen note = "" // Nota del valor almacenado se pone comilla porque trabajaremos con letra

gen mes = _n // Mes *se genera con n con el numero de cada espacio*

/* Reemplazamos los datos para cada mes 	*/

* Enero
replace value = 0.2 if mes == 1

replace note = "Los archivos históricos indican que ...." if mes == 1

* Febrero
replace value = 0.4 if mes == 2

replace note = "A diferencia del mes previo, ahora ..." if mes == 2
```

![image](https://user-images.githubusercontent.com/106888200/223186559-60ac1fc2-ab1c-4ad5-9426-bc4c8699cca7.png)

### 2.2 IMPORTANDO DATOS DE DISTINTOS FORMATOS

Para poder cargar datos a Stata es necesario saber el formato del archivo que se desea cargar. En base a esto, habrán dos tipos de soluciones: 

- Si los datos están en formato ‘.dta’ (el formato propio de Stata) entonces se usa el comando use seguido por la dirección en donde se almacena la carpeta.
- Otros formatos comunes son:
‘.xlsx’ o ‘.xls’ para Excel.
‘.csv’ (Comma Separated Values) para archivos almacenados como texto y separados por algún caracter (puede ser comas, punto y comas, espacios, entre otros).
También se puede cargar formatos menos comunes como ODBC, SAS, etc.

#### 2.2.1 Cargando una base de datos en formato de Stata

El comando para cargar bases en formato ‘.dta’ es `use`. 

Para usarlo es necesario indicar el nombre del archivo junto a la dirección de la carpeta en donde se encuentra guardado. Para que la base sea cargada de manera correcta es necesario no tener alguna base previa. La opción `clear` luego de la coma permite limpiar el navegador de datos de cualquier base previa. De esta manera se puede cargar la base. De no indicar esto, aparecerá una advertencia en la ventana de resultados indicándonos que no podemos cargar la base. Veamos un ejemplo.

##### 2.2.1.1 use filename, clear

El comando `use` se usa para cargar no solo bases que estén físicamente en alguna carpeta de la computadora, también sirve para cargar datos que ya se encuentren en internet. Este es el caso del ejemplo inicial sobre uso de do-files. 

```
use "http://fmwww.bc.edu/ec-p/data/wooldridge/openness", clear	
```

Veamos un caso más común en donde se tiene un archivo en alguna carpeta de la computadora:

```
cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // coloca la dirección donde se encuentra tu base de datos
use "sumaria-2020.dta", clear
```


#### 2.2.2 Importar archivos de Excel

Una alternativa a copiar y pegar desde excel es cargar la misma base desde Excel respetando su formato original. Esto permite disminuir los posibles errores humanos que puede haber al manipular los datos. Para ello, usamos el comando import Excel de la siguiente manera: 

```
import excel using "relaciones_extramaritales.xlsx", clear	
```

Podemos usar el comando de manera similar al use al indicar la carpeta de origen de la base de datos. En este caso es necesario identificar el formato exacto que será cargado, esto es, si es un archivo ‘.xlsx’ o ‘.xls’ (el formato ‘.xlsx’ es más moderno que ‘.xls’). 
Adicionalmente, hay distintas opciones que se pueden indicar luego de la coma (además del ya conocido clear):

- sheet("sheetname"): Si se tienen distintas pestañas en un mismo archivo, podemos cargar una en específico indicando su nombre en sheetname (entre comillas).
- firstrow: Permite tomar la primera fila de los datos como nombre de las variables. Si no hacemos esto, la primera fila será considerada como datos generando problemas en la base.

```
import excel using "relaciones_extramaritales.xlsx", clear firstrow 
br 
 
import excel using "relaciones_extramaritales.xlsx", clear firstrow  sheet ("Hoja2")
br

/* 
- Si se tiene un archivo excel con muchas hojas y no se especifica la opción sheet, Stata cogerá la primera hoja	
- El comando br nos permite ver la base de datos que se ha cargado
*/	
```

![image](https://user-images.githubusercontent.com/106888200/223273860-93aad7f7-a08a-4c1f-9833-c26142b738eb.png)


#### 2.2.3 Importar archivos ‘.csv’

Los archivos ‘.csv’ son archivos de texto (esto significa que pueden abrirse en cualquier editor de texto como Bloc de notas o Word) en donde los valores de las variables están separadas por algún carácter. Por ejemplo, por comas o punto y comas:

![image408](https://user-images.githubusercontent.com/106888200/223274969-3bf99dc7-12a2-448b-b0d8-d32ccfe8e6c3.jpg)

Por ejemplo, se tiene datos de longitud y altitud separados por comas. Para conocer qué tipo de carácter está siendo utilizado como separador podemos abrir el archivo desde el bloc de notas.

#### 2.2.4 Importar delimited filename, delimiters("chars")

El comando usado para cargar archivos ‘.csv’ es muy similar al usado para cargar bases en excel. Hay una diferencia principal. En este caso es necesario indicar qué carácter está siendo usado como separador con la opción delimiter(" "). Dentro del paréntesis debemos indicar el caractér, por ejemplo: delmiter(",") o delmiter(";")

```
import delimited using "RECH0.csv", delimiter(",") clear // formatos .csv
insheet delimited using "RECH0.csv", delimiter(",") clear // formatos .csv
```

Al igual que en el caso de archivos de Excel, es necesario indicar la extensión del archivo al momento de indicar la dirección y el nombre. Por último, esta sintaxis también permite cargar archivos que tengan la extensión ‘.txt’ o ‘.tex’. Veamos un ejemplo de todo lo presentado:

![image](https://user-images.githubusercontent.com/106888200/223322804-3b8740f9-9142-4d7d-9548-9d2f78785d7b.png)



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/5_Importar_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
