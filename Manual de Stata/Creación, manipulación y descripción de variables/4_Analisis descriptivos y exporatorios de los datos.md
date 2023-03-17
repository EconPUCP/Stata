# Creación, manipulación y descripción de variables

### 4 ANÁLISIS DESCRIPTIVOS Y EXPLORATORIOS DE LOS DATOS

Hasta este punto hemos explorado una serie de comandos nuevos que nos permiten manejar los datos, reestructurarlos y hacer rutinas sobre ellos.  Ahora conoceremos algunos comandos estadísticos que nos permitirán conocer los estadísticos descriptivos básicos de las variables. De igual manera, crearemos tablas de una variable y tablas cruzadas para ahondar en la relación de las variables.

### 4.1 DESCRIPCIÓN DE LOS DATOS
Antes de conocer los estadísticos descriptivos puede ser útil conocer las descripciones generales de las variables que usamos. Para ello usaremos tres comandos:

- `describe`: Presenta información acerca del tipo de cada variable en la base así como su etiqueta.

- `codebook`: A diferencia de describe, este comando presenta información más detallada para cada variables como los valores que contiene o el total de datos faltantes en la base asi como el tipo de variable y la etiqueta.

- `inspect`: Este comando es más detallado que los previos. De manera adicional a lo ya planteado se presentan datos acerca de la distribución.

Estos comandos pueden ser realizados para todas las variables de la base de datos o para un conjunto de ellas. Usemos los tres códigos para la condición laboral de las personas encuestadas en el módulo de empleo de la ENAHO 2018.

```
cd "C:/Users/Usuario/Desktop/STATA_ECOPUCP/Análisis/Data" //cambiar por tu directorio

* Cargamos el módulo 500 de la ENAHO

use "enaho01a-2018-500.dta", clear


* Información descriptiva de la base
describe ocu500
codebook ocu500
inspect  ocu500
```


> **TIPS: describe los datos sin cargarlos**
>
>Puedes ejecutar el comando `describe` y leer todos los nombres y etiquetas de las variables sin tener que cargar el conjunto de datos en la memoria.
>
>```
>describe using http://fmwww.bc.edu/ec-p/data/wooldridge/openness , varlist
>```

### 4.2 ESTADISTICOS DESCRIPTIVOS

Estadísticos descriptivos se refieren a estadísticos básicos como el promedio, la desviación estándar, la mediana, etc. que permiten identificar los principales momentos de las variables. El comando básico para realizar esta tarea es summarize. Encontremos los estadísticos descriptivos de la categoría ocupaciones y del ingreso total mensual deflactado:

```
* Estadísticos descriptivos de los datos

summ ocu500 i524a1
```

![image](https://user-images.githubusercontent.com/106888200/223613583-43c92d33-1b0a-4d47-9112-252ef1b0a6c6.png)


De esta manera obtenemos, el número total de observaciones sin datos faltantes (Obs), el promedio, la desviación estándar, el mínimo y el máximo.
Adicionalmente, podemos obtener más estadísticos descriptivos indicando la opción, detail:

```
summ ocu500 i524a1, detail
```

![image](https://user-images.githubusercontent.com/106888200/223613688-e7a1d903-6858-47d7-a63f-0ec71fef4415.png)


Estos nuevos estadísticos son los percentiles, la varianza, el skewness y la curtosis.
También podemos usar el comando univar para obtener un resultado similar pero bajo otro formato:

```
* Se descarga univar
ssc install univar
univar ocu500 i524a1
```

![image](https://user-images.githubusercontent.com/106888200/223613808-d3424f81-c0e8-4aba-b90c-ad31a2ceeb9d.png)


Este comando presenta los datos de percentiles de manera horizontal, a diferencia del summarize, detail.

### 4.3  TABLAS DE FRECUENCIA Y TABLAS CRUZADAS

Las tablas pueden representar las frecuencias de cada valor de una variable. De igual manera, se puede hacer tablas cruzadas para ver como cruzan las frecuencias de dos variables. Para ambas tareas se usa el comando tabulate. Para hacer tablas de frecuencia se debe indicar solo una variable mientras que para hacer una tabla cruzada se debe indicar dos:

![image](https://user-images.githubusercontent.com/106888200/223613981-ae3e2872-4ef2-4a34-b390-22181fe77ae3.png)
![image](https://user-images.githubusercontent.com/106888200/223614060-093b4348-d35a-43fa-aa72-89274c6190a0.png)


Veamos un ejemplo:
Hagamos una tabla de frecuencias para la condición laboral de las personas.

```
tabulate ocu5001
```

![image](https://user-images.githubusercontent.com/106888200/223614150-d9008158-5024-46d1-8ad0-ef5f91a48fc4.png)

La tabla de frecuencia nos indica los valores de las variables, el número de veces que se repite (Freq), su porcentaje y su porcentaje acumulado.
Veamos ahora una tabla cruzada entre la condición laboral y el dominio geográfico:

```
tabulate dominio ocu500, row
```

![image](https://user-images.githubusercontent.com/106888200/223614343-b92534e2-d3f2-4159-8480-e379a1885b80.png)

En este caso usamos la opción row para indicar que se presente los porcentajes de cada celda de la tabla con respecto al total de la fila. Podemos hacer algo similar, pero con respecto a las columnas indicando la opción column.




## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/5_Importar_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
