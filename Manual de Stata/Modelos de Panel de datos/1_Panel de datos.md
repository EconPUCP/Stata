# Panel de datos

Son datos que pertenecen a varios individuos de una entidad y para varios momentos del tiempo
son datos que es una combinación de datos se series de tiempo y de corte transversal. Por ejemplo Las exportaciones de los países de Sudamérica para el periodo: 1990-2018.

Los datos panel puede ser útil debido a que le permite al investigador clasificar efectos económicos que no puedan ser distinguirse solo con el uso de datos de corte transversal o de series de tiempo.

$$Y_{it}$$

con $i = 1,......N; t = 1,...T.$ Donde $i$ se refiere al individuo o a la unidad de estudio (corte transversal), $t$ a la dimensión en el tiempo.

Tipo de datos de panel: 
-  Panel balanceado: se dice que un panel es balanceado si cada individuo (persona, familia, empresa , etc) tiene el mismo número de observaciones
- Panel no balanceado: Si cada individuo tiene un número diferente de observaciones se tiene un panel no balaceado.
- Macropaneles: Los individuos suelen ser países, sectores, reciones y se cumple que el número de individuos es pequeño respecto al número total de periódos.
- Micropaneles: el número de individuis son personas u hogares y se cumple que el número de individuos es mayor respecto al número de periódos.


## 1.1 ORGANIZACIÓN DEL PANEL DE DATOS

Algunas consideraciones previas que debemos tener en cuenta es sobre el uso de los comandos `xt`, estos requieren que los datos del panel se organicen en la llamada forma larga, si nuestra data no se encuentra de la forma larga, podemos utilizar el comando `reshape`.

Los comandos xt necesita que declararemos que la base de datos es un panel de datos, esto lo hacemos con el comando `xtstet`. Haciendo uso de este comando debemos declarar tanto la variable del el individuo como el periódo de nuestro panel.

```

use "panel_enaho_2013_2017.dta", clear

* Declara la base de datos como datos panel
sort id año
xtset id año
```

![image](https://user-images.githubusercontent.com/128189216/227386243-1250aaa9-f284-4e72-923e-3e77717cd12d.png)


Una vez declarado que nuestra base de datos con el comando `xtstet`, podemos hacer uso del comando `xtdescribe`, este decribe el patrón de los datos de panel y nos ayuda a observar si el panel es balanceado o no.

```
xtdescribe
```

![image](https://user-images.githubusercontent.com/128189216/227386372-27a719a8-a9e2-4313-8814-4d5dda1a2119.png)

En este caso, observamos que aparentemente tenemos un panel balanceado, sin embargo cuando revisamos la data notamos presencia de missings o valores perdidos, por lo que procedemos limpiar la base, y nos queda un panel no balanceado.

```
*limpiamos los missings o valores perdidos de la data.
drop if año == . | lsalario == . | edad == . | raza == .  | escolaridad == . | sexo == . | experiencia == .  | urbano == . | zona == .
xtdescribe
```

![image](https://user-images.githubusercontent.com/128189216/227395465-8abade45-35ac-4cec-8cb9-a70e68334cba.png)

Usaremos el comando `xtbalance` nos permite quedarnos con un panel balanceado.

```
ssc install xtbalance // este comando debe ser instalado
xtbalance, range(2013 2017) miss(id año lsalario edad raza escolaridad sexo experiencia urbano zona)
xtdescribe
```

![image](https://user-images.githubusercontent.com/128189216/227395837-b98dd2a6-b644-43a1-bc04-2ff64c34345a.png)

El comando `xtsum` nos permite realizar algunos estadísticos descriptivos y nos proporciona la descomposición de la varianza. 

```
xtsum lsalario edad raza escolaridad sexo experiencia urbano zona
```

![image](https://user-images.githubusercontent.com/128189216/227395994-54876f9b-4661-4fc6-aadb-f35725d87754.png)

El comando xttab tabula los datos de una manera que proporciona detalles adicionales sobre el
"within" y "between" entre la variación de una variable.

El comando xttrans proporciona probabilidades de transición de un período al siguiente. El comando xttrans es más útil cuando la variable toma pocos valores


## 1.2 MODELOS DE PANEL DE DATOS

Con los datos panel procedemos a estimar los siguientes modelos:

#### 1.2.1  Modelo agrupado (pooled)
Tan solo se agrupan o apilan las observaciones y se estima una regresión, por MCO sin atender la naturaleza de corte transversal y de series de tiempo de los datos. En este método se consideran que todos los coeficientes del modelo o ecuación son constantes



#### 1.2.2  Modelo de efectos fijos (FE)

El método de efectos fijos considera que existe un término constante diferente para cada individuo, y supone que los efectos individuales son independientes entre sí.
Con este modelo se considera que las variables explicativas afectan por igual a las unidades de corte transversal y que éstas se diferencian por características propias de cada una de ellas, medidas por medio del intercepto. 

El método de Efectos fijos pueden ser de dos tipos:
- El método de efectos fijos con variables dicótomas
- El método de efectos fijos dentro del grupo (between), intragrupos (within group)

#### 1.2.3 Modelo de efectos aleatorios
El modelo de efectos fijos es un modelo razonable cuando se posee evidencia de que la diferencia entre los diferentes individuos o agentes sociales de la muestra( o bien los diferentes momentos en el tiempo) son cambios en el parámetro de intersección de la función de regresión. 



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA - Stata learning module  | [Getting help](https://stats.oarc.ucla.edu/stata/modules/getting-help-using-stata/ "Getting help") | Cómo obtener ayuda en Stata  |
| UCSF GSI  | [Thinking like Stata](https://www.youtube.com/watch?v=jTtIREfhyEY&t=108s&ab_channel=UCSFGSI "Thinking like Stata") | Manejar la sintaxis de los comandos en Stata  |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
