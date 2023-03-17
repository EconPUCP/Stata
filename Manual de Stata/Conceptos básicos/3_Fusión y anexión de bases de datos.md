# Conceptos Básicos

### 3 FUSIÓN Y ANEXIÓN DE BASES DE DATOS

Luego de cargar los datos y almacenarlos en formato ‘.dta’ podemos manipularlos de manera que se pueden combinar de dos formas distintas:

- Agregando nuevas columnas de datos (merge) o fusionando bases.

![image](https://user-images.githubusercontent.com/106888200/223329334-65b47162-f86b-4223-a360-0c3836656490.png)

- Agregando nuevas filas de datos (append) o anexando bases.

![image](https://user-images.githubusercontent.com/106888200/223329385-b27d9c5e-9c70-4caa-8379-d139fca46d5c.png)

El comando exacto que usemos dependerá de en qué caso nos encontremos.

### 3.1 FUSIÓN DE BASES
Fusionar bases de datos implica combinar dos bases de manera horizontal con el objetivo de que la observación de una fila en la base inicial se ‘empate’ con las observaciones de otras filas de la base adicional. Este comando puede ser difícil de usar al comienzo debido a que presenta distintas opciones de acuerdo a los datos que se enfrente.

Estas opciones se diferencian en la manera en cómo fusionan las bases (1:1, m:1, 1:m). A pesar de esto, la sintaxis es similar.

#### 3.1.1 Identificador de la unidad de observación

Para ver las diferencias entre estas opciones debemos conocer previamente qué variable sirve como identificador de las observaciones en cada base de datos. ¿Qué significa esto? Que al abrir una base de datos debemos identificar o crear una variable (de preferencia numérica) que permita diferenciar una unidad de análisis de otra. 
Tomemos como ejemplo la siguiente base de datos sobre desigualdad en el mundo. La unidad de observación es un país en un año específico por lo que es necesario tener o crear una variable que permita identificar a cada país en sus respectivos años.
Esta unidad de observación identificada (puede ser una variable o un conjunto de variables) se usa en la opción varlist. Por último, luego de using se debe indicar la base de datos secundaria que será cargada (indicando tanto el nombre como la dirección en donde se encuentra el archivo). Veamos el siguiente ejemplo:

Consideremos la siguiente base de datos macroeconómicos para una muestra de países africanos. La unidad de observación es un país en un año específico, por ejemplo, Angola en 1970. Para identificar esta observación nos enfocamos en dos variables: date y ifscode. Estamos considerando ifscode en vez del nombre del país porque en muchas operaciones se necesita un identificador que sea numérico.

![image](https://user-images.githubusercontent.com/106888200/223336226-da03f768-31bb-4257-af41-be2f9a975452.png)


#### 3.1.2 1:1, m:1, 1:m

Luego de conocer esa variable (o conjunto de variables) que identifican a cada unidad de observación podemos analizar las diferencias entre cada opción del comando `merge`.

¿En qué se diferencia cada una? Veamos:

- Si la unidad de observación no se repite ni en la base inicial ni en la base secundaria, se usa:
_merge 1:1 varlist using filename [, options]_
- Si la unidad de observación se repite solo en la base inicial pero no en la base secundaria, se usa:
_merge m:1 varlist using filename [, options]_
- Si la unidad de observación se repite solo en la base secundaria pero no en la base inicial.
_merge 1:m varlist using filename [, options]_

Stata también permite la opción m:m, pero nunca debería de ser usada (debido a que no existe situación alguna en donde sea útil) por lo que ni siquiera será presentada. Veamos algunos ejemplos de cada caso a partir de los datos macroeconómicos:

##### 3.1.2.1 merge 1:1

La base de datos macroeconómicos para países africanos contiene datos del PBI real y la población para tres países. Nuestro objetivo es juntar estos datos con nuestra segunda base que contiene datos del índice de capital humano y el número de personas que son empleadas. Dado que la relación entre la unidad de observación entre la base de datos inicial (la de PBI real y población) es la misma que en la base secundaria usamos el comando `merge 1:1`:

![image](https://user-images.githubusercontent.com/106888200/223334212-6f62d3d4-c4f1-4c7b-a074-159df3109278.png)

Luego de correr el código debemos de ver algunos resultados importantes tanto en la ventana de resultado como en el navegador de datos. El primer mensaje de interés es el siguiente: 

![image](https://user-images.githubusercontent.com/106888200/223333576-765f6474-76fe-4bf3-9f4d-ca7a291715ef.png)

En este mensaje encontramos el número de datos que logran (o no) empatarse. Como todos los datos se empatan no hay datos que estén en la fila de ‘not matched’. Si hubieran datos no empatados, estos serían de dos tipos: pertenecientes a la base inicial (from master) o pertenecientes a la base secundaria (from using). Adicionalmente, se crea una nueva variable, por default, llamada _merge que toma distintos valores de acuerdo a si empató (=3), no empató y pertenece a la base inicial (=1) o no empató y pertenece a la base secundaria (=2).

##### 3.1.2.1 merge m:1

Luego de juntar ambas bases deseamos agregar una nueva variable que indique la capital de cada país. En este caso la unidad de observación de la nueva base de datos ya no es un país en un año particular sino solamente un país (dado que la capital se mantiene fija en el tiempo):

![image](https://user-images.githubusercontent.com/106888200/223334726-c9d6dee3-71aa-4e41-9ac2-3fd669d607b4.png)

¡Ante esto, no podemos indicar que se junte 1 a 1 porque la unidad de observación es distinta! En cambio, debemos usar la opción m:1 (many to one o varios a uno). Esto significa empatar varios años de un solo país con la única observación del país en la base de capitales. Si corremos el nuevo código inmediatamente luego del código previo obtendremos el siguiente error:

![image](https://user-images.githubusercontent.com/106888200/221700547-07e370f7-0c84-4507-aa55-15a0d0ad1e06.png)

Debemos eliminar la variable _merge creada previamente con el comando `drop` _merge.

#### 3.1.3 Algunas opciones al momento de fusionar bases

Algunas opciones de gran utilidad al momento de usar el comando `merge`:

- `keepusing`:
Sirve para quedarse con solo un conjunto particular de variables de la base secundaria.
- `nogenerate` o `generate()`:
Al indicar nogenerate se omite la creación de la variable _merge. Lo contrario sucede al indicar generate(), en este caso se crea la variable con un nombre distinto indicado entre paréntesis.
- `noreport`:
Con esta opción no se reportan los resultados en la ventana de resultados
- `keep( )`:
Esta opción sirve para indicar con qué sub grupo de datos quedarse. Por ejemplo, si se indica keepusing(3) solo se mantienen las observaciones que han empatado en ambas bases. Mientras que, de indicar 2 o 1 se mantienen los datos no empatados. Por default, se mantienen todos los datos.


> **TIPS: identificador de la ENAHO**
>
>Cuando queramos fusionar distintos modulos de una encuesta es importante identificar a la unidad de observación. Por ejemplo la ENAHO, la encuesta más utilizada en >Perú, tiene distintas unidades de observación de acuerdo al módulo, esto ocasiona que no todas las observaciones se fusionen. Nos es muy útil saber:
>
>La unidad de observación para los módulos individuales está compuesto por: _conglome, vivienda, hogar, codperso._
>La unidad de observación para los módulos de hogar está _compuesto por: conglome, vivienda, hogar_


### 3.1 ANEXIÓN DE BASES
La anexión de datos es útil cuando se quieren agregar nuevas filas de datos en una base inicial. La sintaxis es más simple que en el caso de fusión de bases. 
Debemos indicar la base de datos secundaria a anexar en el espacio de filename. No es necesario que ambas bases compartan el mismo número de variables pero sí que cada variable que se desee anexar comparta el mismo nombre. Veamos un ejemplo:

![image](https://user-images.githubusercontent.com/106888200/223335519-a615e713-7f48-4f70-8b38-59ed8c4c1245.png)



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/6_merge_append.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
