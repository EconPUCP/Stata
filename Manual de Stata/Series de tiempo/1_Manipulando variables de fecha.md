# Modelo de series de tiempo

## 1.  MANIPULANDO VARIABLES DE FECHA

Para que se pueda tomar ventajas del conjunto de funciones que trae Stata se debe declarar previamente que el conjunto de datos son una serie de tiempo. Previamente hemos visto algo parecido al momento de declarar el diseño muestral de una encuesta. En este caso, la identificación es más fácil. Necesitamos saber cuál es la frecuencia de los datos, es decir, si son anuales, trimestrales, mensuales, por hora, por minutos, etc. Darle formato a la variable y usarla para declarar a los datos como de serie de tiempo usando el comando tsset. Veamos un ejemplo con datos simulados:


### 1.1 DATOS DE TIEMPO

Las series de tiempo pueden estar en distintas frecuencias, cada tipo de frecuencia puede ser cargada en Stata bajo un formato específico. Veamos los casos más importantes, datos trimestrales, datos mensuales y datos diarios (en el caso de datos anuales toda la discusión se hace mucho más fácil ya que no es necesario darle un formato especial).

![image](https://user-images.githubusercontent.com/106888200/224338945-abad530b-3f02-4d83-b5b6-fad6f59a2a50.png)

Como vemos cada variable mide una frecuencia distinta. La primera comienza en el primer trimestre de 1960 (1960q1), mientras que la segunda comienza en enero de 1960 (1960m1) y la última serie comienza el primero de enero de 1960 (01jan1960, en donde jan viene de january o enero en inglés).
Hay distintos formatos que se pueden considerar, desde milisegundos hasta años: 

![image](https://user-images.githubusercontent.com/106888200/224339140-4039f77b-8fd4-4f60-a26c-3ad108078458.png)

En el siguiente código vemos algunos ejemplos de cómo crear series. Primero establecemos el tamaño de la base (set obs 100), luego creamos las series considerando los distintos formatos. En este punto usamos tres tipos de funciones: `tq()`, `tm()` y `td()`. Cada una de ellas crea un dato inicial para la fecha que se indica. Luego sumamos la posición de la fila con _n _y_ restamos uno (para que la lista comience en cero). Posteriormente, damos formato a la serie usando los códigos de la lista. Por último, usamos el comando tsset para declarar a la base como de serie de tiempo. Veamos este último código.
Cuando creamos datos desde cero solo se generan unos valores numéricos. Para que se vean como en las imágenes previas tenemos que darle formato. Ahora, para todo tipo de frecuencia el valor 0 se establece para la primera observación de 1960. Es decir 1 en frecuencia mensual significa 2 de enero de 1960 mientras que 1 para frecuencia mensual significa febrero de 1960. Contrariamente -1 bajo frecuencia trimestral significaría el último trimestre de 1959. Bastante ojo con esto. Luego haremos algunos ejemplos de como definir las series temporales cuando los datos ya vienen en otros formatos de cadena desde la fuente original. Por ejemplo, cuando cargamos desde excel una base que dice "2019 Trimestre 4".

```
* Trimestres -> Quarters
clear
set obs 100
gen trimestre = tq(1960q1) +_n -1
format %tq trimestre
tsset trimestre

* Mensuales -> Monthly
clear
set obs 100
gen mes = tm(1960m1) +_n -1
format %tm mes
tsset mes

* Diarios -> Daily
clear
set obs 100
gen diario = td(1jan1960) +_n -1
format %td diario
tsset diario

* Anual -> Yearly
clear
set obs 100
gen anual = 1960 + _n -1
tsset anual 
```

#### 1.1.1 tsset

Luego de crear las series usamos la nueva variable para declararla como la variable temporal. 

![image](https://user-images.githubusercontent.com/106888200/224339363-b6edbcab-7e21-4a1a-9915-d008ce13afbd.png)

Declarar la base de esta manera nos permite usar un conjunto de funciones y comandos creados específicamente para series temporales que revisaremos posteriormente en esta semana. Hasta este punto, ya conocemos los tipos de formatos que hay y la necesidad de declarar los datos como series temporales. Ahora, vamos a ver cómo manejar series de tiempo cuando la variable de tiempo está en otro formato tanto en string como en números. Este es un problema bastante recurrente por lo que analizaremos distintos problemas tipos.

### 1.2 ARREGLANDO LOS FORMATOS DE DATOS TEMPORALES

Tomemos la siguiente base de datos como ejemplo. En este caso no tenemos los datos de manera directa. Cada columna presenta las variables de fechas en distintos formatos.

![image](https://user-images.githubusercontent.com/106888200/224339501-72431a71-8e14-4baa-a292-068b8b88abcc.png)

- fecha1: Fecha string en formato en inglés, primero mes luego día y al final el año.
- fecha2: Es similar al previo pero tiene el mes en iniciales en inglés.
- fecha3: Se tiene la fecha en números pero sin algún tipo de separador.
- fecha4: Similar al previo pero los días y meses menores a 10 no comienzan con cero.
- fecha5: Similar a la segunda columna pero con las iniciales en español.


Veamos cómo manejar estas fechas para que tengan el formato de series diarias. Cargamos la base con las fechas de ejemplos.

```
cd "C:\Users\Usuario\Documents\GitHub\STATA\_Análisis\Data"
use "fechas.dta", clear

gen fecha1_num = date(fecha1,"MDY")
format fecha1_num %td

gen fecha2_num = date(fecha2,"DMY")
format fecha2_num %td

tostring(fecha3), replace
gen fecha3_num = date(fecha3,"YMD")
format fecha3_num %td
```

- La solución para los dos primeros casos es bastante directa, podemos usar el comando `date()` para indicar el orden de los componentes de la fecha. Por ejemplo "MDY" para mes - día - año (como en el formato en inglés). Si quisiéramos pasarlo al formato usual en español comenzaríamos indicando el día, luego el mes y por último el año ("DMY"). 
- En el caso de fecha3 tenemos que hacer un paso previo. Si queremos usar el comando `date()` tenemos que tener la serie en forma `string()` por lo que usamos el comando `tostring(fecha3)`, replace para que reemplace la variable fecha3 con sus mismo valores pero en string.

```
tostring(fecha4), replace
gen year = substr(fecha4,1,4)
gen month = substr(fecha4,4,2)
gen day = substr(fecha4,6,.)
destring(year month day), replace

gen fecha4_num = mdy(month,day,year)
format fecha4_num %td
drop year month day 

replace fecha5 =  subinstr(fecha5,"Ene","Jan",1)
gen fecha5_num = date(fecha5,"DMY")
format fecha5_num %td
```

- En todos los casos, luego de generar los valores tenemos que darle formato usando el comando format seguido por `%td` para indicar que son diarios.
- La variable fecha4 puede ser confusa. Por ejemplo, 202011 indicaría el primero de enero del 2020 pero 2020111 puede ser el 11 de enero o el 1 de noviembre. En el ejemplo tenemos valores bastante directos, para crear la nueva variable separamos los valores de día, mes y año usando el comando `substr()`, previamente tenemos que pasarlo a string para que pueda ser segmentada. Con cada elemento listo, lo volvemos a pasar a números usando el comando `destring()`. Con esto, usamos el comando `mdy()` parecido a `date()` pero en donde indicamos cada componente de la fecha diaria. Ojo: Cuando tengan casos más confusos deben ver alguna manera de solucionar esos problemas.
- En el último caso, tenemos las fechas en español por lo que podemos usar el comando `subinstr()` para reemplazar las iniciales de la fecha.

Hay muchas opciones y funciones adicionales que se pueden usar de acuerdo a la frecuencia de la serie. 

```
/* 
Si tenemos variables en string en otras frecuencias
podemos usar otro conjunto de comandos para 
transformalos, por ejemplo:

gen week= weekly(stringvar,"wy")       // Semana
gen month= monthly(stringvar,"my") 	   // Mes
gen quarter= quarterly(stringvar,"qy") // Trimestres
gen half = halfyearly(stringvar,"hy")  // Semestres
gen year= yearly(stringvar,"y") 	   // Años

En cambio si los componentes están en números podemos
usar otro conjunto de comandos:

gen daily = mdy(month,day,year)		   // Días 
gen week = yw(year, week)			   // Semanas
gen month = ym(year,month) 			   // Mes
gen quarter = yq(year,quarter) 		   // Trimestres
gen half = yh(year,half-year)		   // Semestres
*/
```

Algunas de ellas sirven cuando tenemos los datos en formato string otros cuando los datos están en valores numéricos. Una operación adicional que se puede hacer es crear variables nuevas con otros formatos. Por ejemplo, podemos crear una variable que indique en qué trimestre del año se encuentra la fecha diaria. Veamos algunos ejemplos de cómo cambiar la frecuencia de la serie:

- En este ejemplo hacemos algunos cambios. Primero pasamos de día a trimestre, luego de día a mes y, por último, de día a semana. En los dos primeros casos usamos las siguientes funciones: `qofd()` y `mofd()` mientras que en en último caso usamos una función presentada previamente, `yw()`. 
- Podemos indentificar a `qofd()` y `mofd()` a partir de la primera y última letra. En el primer caso sería, quarter of day y luego sería month of day. Hay una familia extensa de este tipo de funciones que se puede revisar si necesita hacer algún cambio en este sentido. Por ejemplo, aquí.

```
* De dia a trimestre
gen trimestre = qofd(fecha1_num)
format trimestre %tq

* De dia a mes
gen mes = mofd(fecha1_num)
format mes %tm

* De dia a semana
gen w = week(fecha1_num)
gen year = year(fecha1_num)
gen semana = yw(year,w)
format semana %tw
```

> **TIPS: formato de fechas**
>
>las fechas son difíciles de manejar en Stata ya que se almacenan en un formato local de Stata. Los siguientes comandos muestra tres opciones de formato de fecha diferentes
>
>```
>// the data now
>local date: display %tdd_m_yy date(c(current_date), "DMY")
>display "`date'"
>// from a data variable
>summ date
>local date: display %tdd_m_yy `r(max)'
>display "`date'"
>// the same date local formatted
>local date2 = subinstr(trim("`date'"), " ", "_", .)
>display "`date2'"
>


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |



****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
