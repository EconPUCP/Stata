# Creación, manipulación y descripción de variables

###  3 CREANDO RUTINAS CON LOOP

Los bucles o loops permiten repetir tareas de acuerdo a ciertas indicaciones. Por ejemplo se puede repetir una operación para una serie de valores de una variable o un número determinado de veces. Para hacer estos bucles podemos usar distintos comandos, veamos algunos de ellos:

- `forvalues`: Se repiten las operaciones por un número pre determinado de veces
- `foreach`: Se repite la operación para un conjunto de ítems pre determinados, es ligeramente distinto al forvalues.
- `while`: Se repite la operación hasta que se cumple cierta condición, por ejemplo que una variable no pase cierto umbral. 

Antes de entrar a fondo a las opciones de bucle debemos conocer las ‘macros’ que se pueden crear. Se denomina ‘macros’ a resultados predefinidos por el usuario o por el programa. Estas pueden ser de dos tipos: local o global.

- `local`: Una macro local solo existe dentro del programa que la refiere y no puede ser referenciada en otro programa.
- `global`: Una macro global es similar a una macro local pero una vez definida se mantiene en la memoria hasta que se cierre la sesión de Stata. Para referirnos al contenido de una global usamos su nombre junto al signo de dólar. 

Veamos algunos ejemplos de su uso en la práctica.

Trabajemos con la encuesta de [OSPSITEL del 2012](https://repositorio.osiptel.gob.pe/handle/20.500.12630/330 "OSPSITEL del 2012") que también puedes encontrarla en nuestra [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos"). Sobre esta base usaremos, en primer lugar, un `local` llamado var que refiere a tres variables de interés: la condición de pobreza, el nivel socio económico y la ocupación de cada persona encuestada. Para llamar a este local se debe escribir dentro de los caracteres mostrados en el código. También se puede usar ambas macros no sólo para almacenar variables sino también para almacenar conjunto de texto. En el ejemplo vemos cómo se puede guardar las opciones de gráfico de un gráfico de dispersión para luego ser usada dentro de un bucle. A diferencia del `local`, un `global` se llama usando el signo de dólar.

```
cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // cambiar el directorio

use "OSIPTEL_personas.dta", clear

local var pobreza nse ocupacion

summ `var'

global scatter_opciones `" xtitle("Ingreso Total", size(medlarge))  mcolor(red) msize(*0.5) "'

foreach x of local var{
	scatter `x' ingreso_total, $scatter_opciones name(`x', replace )
}
graph combine  pobreza nse ocupacion
```

El resultado final, es un conjunto de gráficos a partir del local definido inicialmente usando la configuración de gráficos del `global`.
La forma de uso de ambas macros es bastante diversa. En los siguientes casos de bucle veremos algunas formas adicionales.

![image](https://user-images.githubusercontent.com/106888200/223595263-d58294f4-0a24-41d8-a98b-288a5ffcbc94.png)


> **TIPS: dar formato a un `local`**
>
> Una vez que se define un local, se puede dar formato cambiando su visualización.
> 
> ```
> sysuse auto, clear
>summ price
>  local x = `r(mean)' * 10
>  local x : di %10.2fc `x'
>display "`x'"
>```
> Esto es muy util para el formateo automático de etiquetas en gráficos y tablas sin modificar el formato de la variable original
>

### 3.1 FORVALUES

Para hacer un loop se necesita indicar algún indicador que permita identificar en dónde se repetirá la operación. Ese indicador puede ser i, j o cualquier letra que facilite la identificación. Adicionalmente, es necesario indicar el número de veces que se realizará la rutina a través de un rango.

![image](https://user-images.githubusercontent.com/106888200/223593413-4c55ba6f-e645-409f-ba75-eac7c587a578.png)

Veamos un ejemplo con los datos del índice del Fenómeno de El Niño visto previamente para facilitar la comprensión:

En este ejemplo primero necesitamos hacer un `reshape` a la base inicial para facilitar el uso. Luego se desea hacer gráfico de los valores del índice para cada los meses de cada año comenzando en 1950 y terminando en el 2010 con intervalos de 20 años.

```
* Cargamos la base de datos

use "$MEI", clear

reshape long mei, i(year) j(month)

/*		forvalues 		*/

forvalues i = 1950(20)2010{

	summ mei if year == `i' 
	sort year month
	line mei month if year == `i', name(g`i', replace) title("`i'") ytitle("MEI") ///
	xtitle("") xlabel(1(1)12,grid) ylabel(,grid) 	
}
graph combine g1950 g1970 g1990 g2010, ycommon title("Índice del Fenomeno del Niño", size(*0.8))
```

Primero indicamos que nuestro indicador será la letra i. Luego, indicamos el rango. En este caso indicamos que se comience en 1950 en intervalos de 20 años hasta el 2010. El número entre paréntesis es el intervalo de años elegido. Una vez establecido esto, debemos escribir la rutina o conjunto de comandos entre corchetes, { }. Nuestra rutina consiste en obtener los estadísticos descriptivos de la serie para cada año elegido y un gráfico del indicador para los meses dentro de cada año2. OJO: Estamos usando el indicador no solo para repetir una rutina sino también para indicar sobre qué sub grupo hacer la rutina, esto es, sobre el grupo de años elegido previamente. La ‘i’ es reemplazada por el número determinado previamente.
Posteriormente, podemos juntar los cuatro gráficos generados dentro del bucle para armar un solo gráfico que nos presente las distintas tendencias del índice a lo largo del tiempo.

![image](https://user-images.githubusercontent.com/106888200/223593560-383236b4-55bc-4506-b48e-487e08ac4316.png)


### 3.2 FOREACH

El comando `foreach` permite hacer un bucle sobre distintos ítems:

![image](https://user-images.githubusercontent.com/106888200/223593793-2acf69f2-2a93-4882-8a7c-81966609470b.png)

Estos ítems pueden ser `local`; `global` ; `varlist` o lista de variables; o, `numlist` o lista de números. Este último es similar a `forvalues`.
Veamos un ejemplo. En este caso queremos graficar la variación del MEI para cuatro meses: Enero, Abril, Julio y Octubre. Luego de regresar al formato wide de la base de datos podemos hacer un bucle foreach sobre las variables de interés, en este caso mei1 para enero, mei4 para abril y así.

```
reshape wide 


/*		foreach 		*/

* varlist
foreach x of varlist mei1 mei4 mei7 mei10{
	local mei1 "Enero"
	local mei4 "Abril"
	local mei7 "Julio"
	local mei10 "Octubre"
	line `x' year , name(p`x', replace) title(``x'') xtitle("") ytitle("MEI") ///
	xlabel(1950(5)2010 2011, grid labsize(*0.5) angle(60))
}
graph combine pmei1 pmei4 pmei7 pmei10, ycommon title("Variación de MEI para cada mes")
```

A diferencia del caso anterior ya no hacemos un bucle sobre número, ahora lo hacemos sobre una lista de variables. Es por esto que debemos incluir `varlist` en parte del código. Adicionalmente, decidimos elegir como indicador a la letra x en vez de la i, pero la letra específica no es de interés.
Con los gráficos podemos hacer una combinación como en el punto previo para presentarlo de mejor manera.

![image](https://user-images.githubusercontent.com/106888200/223593973-82b70313-df22-4d38-977a-239c2d968cd4.png)

Podemos hacer lo mismo pero usando la opción `numlist` de la siguiente manera:

```
* numlist
foreach x of numlist 1 4 7 10{
	local 1 "Enero"
	local 4 "Abril"
	local 7 "Julio"
	local 10 "Octubre"
	line mei`x' year, name(p`x', replace) title(``x'') xtitle("") ytitle("MEI") ///
	xlabel(1950(5)2010 2011, grid labsize(*0.5) angle(60))
}
graph combine p1 p4 p7 p10, ycommon title("Variación de MEI para cada mes") 
```

Como se usa una lista de número en vez de una lista de variables sólo elegimos los números que dirigirán el bucle. Para poder hacer esto es necesario tener cierto orden sobre las variables en términos de los números que agregamos en sus nombres. En general, el comando `foreach` permite una mayor gama de opciones.

### 3.3 WHILE

El comando `while` repite las indicaciones hasta que se cumpla con la condición matemática que se indica. Veamos un ejemplo: 

```
local iterar = 1

while `iterar' <= 6 {
	local year_l = `iterar'+1949
	line mei month if year == `year_l', title(`year_l') xlabel(1(1)12, grid) ///
	ytitle("MEI")  xtitle("") name(l`iterar', replace)
	local iterar = `iterar' + 1
}
graph combine l1 l2 l3 l4 l5 l6, ycommon title("Variación de MEI en los primeros 6 swaños")
```

En este caso se crea un `local` igual a 1 y se pide que se repita la iteración hasta que logre ser 6. Para ello se va actualizando el valor del `local` al final. De esa manera se ‘avanza’ en la iteración.

![image](https://user-images.githubusercontent.com/106888200/223594291-551fff9c-61ac-48b2-86aa-ca33a30223d6.png)




## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/6_merge_append.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
