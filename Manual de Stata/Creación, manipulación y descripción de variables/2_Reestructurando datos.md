# Creación, manipulación y descripción de variables

###  2 REESTRUCTURANDO DATOS

En primer lugar vamos a repasar dos caminos distintos de pasar una variable numérica a una de cadena, y viceversa:

- `encode`/`decode`
- `tostring`/`destring`

Posteriormente, veremos cómo usar el el comando `reshape`:

- Pasar de formato ancho a largo, wide to long
- Pasar de formato largo a ancho, long to wide

### 2.1 ENCODE Y DECODE

#### 2.1.1 Encode

El comando `encode` genera variables numéricas etiquetadas (con los valores de cadena) a partir de una variable de cadena. El número 1 es dado al primer valor de manera alfabética, el 2 al segundo y así. Para ello, debemos indicar el nuevo nombre que queremos que lleve la variable a crear.

En el siguiente ejemplo crea una variable numérica etiquetada llamaba placenum a partir de la variable place:


```
* Comando encode

use "$Canadá", clear

encode place, gen(placenum)
```

![image](https://user-images.githubusercontent.com/106888200/223484256-af5e27dc-73d0-4ebe-a1c3-55273d379be7.png)

#### 2.1.1 Decode

En cambio, `decode` hace la conversión contraria. Este genera una variable cadena usando las etiquetas de una variable numérica.

Retomemos el ejemplo en donde creamos una variable numérica con etiquetas para los diferentes tipos de lugares que están en la base de datos. A partir de esto, creamos una nueva variables:

```
use "$Canadá", clear

gen tipo = .
replace tipo = 1 if place == "Canada"
replace tipo = 2 if place == "Yukon"         | place == "Northwest Territories"
replace tipo = 3 if place == "Newfoundland"  | place == "Prince Edward Island" | place == "Nova Scotia"  | ///
					place == "New Brunswick" | place == "Quebec" 	 		   | place == "Ontario" 	 | ///
					place == "Manitoba"		 | place == "Saskatchewan"		   | place == "Alberta"		 | ///
					place == "British Columbia"

label define tipo_l 1 "País" 2 "Territorios" 3 "Provincias"
label values tipo tipo_l

decode tipo, gen(tipo_string)
```

Veamos la base final:

![image](https://user-images.githubusercontent.com/106888200/223489389-f0da2354-4a68-4f99-93fa-3e3e0ee52a38.png)



> **TIPS: código de seccionamiento**
> 
> Puedes colapsar bloques de código en tus dofiles usando corchetes, esto te permite ocultar grandes fragmentos de código.
> 
>```
>{
>code block
>}
>```
>


### 2.2 TOSTRING Y DESTRING

Estos comandos son similares, pero tienen más restricciones. Por ejemplo, solo se puede usar `destring` sobre una variable que contienen caracteres numéricos en formato de cadena. Mientras que `tostring` transforma a formato de cadena los caracteres numéricos de las variables numéricas. No las etiquetas, como en el caso anterior.

![image](https://user-images.githubusercontent.com/106888200/223489062-b2fd8123-8cd7-49a1-982e-440070805e83.png)

Aunque los comandos `encode` y `decode` deberían ser suficientes para manipular los datos de esta manera, puedes revisar en nuestra sección _"Sigue aprendiendo"_ un poco más del uso de estos comandos del curso de Diego Quispe Ortogorin.

### 2.2 RESHAPE

Una forma distinta de reestructurar los datos es posible usando el comando `reshape`. Este comando cambia la base de datos entre dos tipos de configuraciones llamadas anchas (wide) y larga (long)
Para ejemplificar este comando usamos una base de datos con una medida de la temperatura de la superficie del oceano (esta medida sirve como un índice para analizar la ocurrencia del Fenómeno del Niño, ENSO (El Niño Southern Oscillation) entre los años 1950 y 2011.

![image](https://user-images.githubusercontent.com/106888200/223489729-dab4ff9d-83be-4e5d-ae2b-649ec3cdca50.png)

En donde cada variable mei indica el índice en distintos meses desde enero (mei1) hasta diciembre (mei12).
La base que acabamos de abrir está en formato wide, los índices de cada mes se repiten a lo ancho de la base creando una variable separada para cada una. También es posible pensar que la base puede reducir su número de columnas si solo se tiene una variable que mida el índice y otra en donde se indique el mes. Esto último, es el formato long. Podemos pasar de una base a otra usando el comando `reshape`:

![image](https://user-images.githubusercontent.com/106888200/223490145-e854eb32-e2eb-4f82-ad2a-0503d9ff3f10.png)

Para usar este comando primero debemos identificar el tipo de base que tenemos. El gráfico previo brinda bastante información. En nuestro ejemplo, identificamos que tenemos una variable para los años sin repetición y una serie de columnas que miden lo mismo, pero en diferentes meses.
Si vemos el gráfico entonces i sería el año y stub1, stub2, ..., stub12 serían mei1, mei2, ..., mei12. Vemos que es importante que estas variables compartan parte del nombre y se diferencian en algún número que permita identificarlas posteriormente.
Siguiendo con la guía, verificamos que para pasarlo a formato long debemos indicar el stub que sería en este caso mei; luego, debemos indicar la i que sería el año o year; por último, debemos indicar el nombre que llevará la variable j, en este caso month o mes.

```
* Comando reshape 

use "$MEI", clear
reshape long mei, i(year) j(month)

```

Si seguimos los pasos correctamente obtendremos una base como la siguiente:

![image](https://user-images.githubusercontent.com/106888200/223490878-406847bd-0922-4fd5-8a23-cd97af17256d.png)


Podemos regresar al mismo formato usando el comando reshape wide (si long es nuestro formato original entonces usaríamos reshape long).

```
reshape wide 
```


> **TIPS: intercambiar decimales y comas**
>
>En algunas partes del mundo, los decimales y las comas se intercambian. Para evitar estos innconvenientes el comando `set dp` te ayuda a intercambiar fácilmente decimales y comas. Conoce más sobre este comando tecleando en tu ventana de comando: 
>```
>help set dp 
>```


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/6_merge_append.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
