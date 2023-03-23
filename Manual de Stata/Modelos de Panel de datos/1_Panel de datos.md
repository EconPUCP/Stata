# Datos de Panel

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


## 1.1 ORGANIZACIÓN DATA PANEL

Algunas consideraciones previas que debemos tener en cuenta es sobre el uso de los comandos `xt`, estos requieren que los datos del panel se organicen en la llamada forma larga, si nuestra data no se encuentra de la forma larga, podemos utilizar el comando `reshape`.

Los comandos xt necesita que declararemos que la base de datos es un panel de datos, esto lo hacemos con el comando `xtstet`. Haciendo uso de este comando debemos declarar tanto la variable del el individuo como el periódo de nuestro panel.

Una vez declarado que nuestra base de datos con el comando `xtstet`, podemos hacer uso del comando `xtdescribe`, este decribe el patrón de los datos de panel y nos ayuda a observar si el panel es balanceado o no.

El comando `xtbalance` nos permite quedarnos con un panel balanceado.

El comando `xtsum` nos permite realizar algunos estadísticos descriptivos y nos proporciona la descomposición de la varianza. 

El comando xttab tabula los datos de una manera que proporciona detalles adicionales sobre el
"within" y "between" entre la variación de una variable.

El comando xttrans proporciona probabilidades de transición de un período al siguiente. El comando xttrans es más útil cuando la variable toma pocos valores


## 1.2 MODELOS DE PANEL DE DATOS

Con los datos panel procedemos a estimar los siguientes modelos:

#### 1.2.1  Modelo agrupado (pooled)


#### 1.2.2  Modelo de efectos fijos (FE)
La regresión por efectos fijos es un método que permite controlar por variables
omitidas cuando estas variables no varían en el tiempo pero si entre la unidad de
observación. La estimación por efectos fijos es equivalente a la estimación antesdespués
de la sección II, pero puede ser utilizando cuando tenemos dos o más
periodos de tiempo.

#### 1.2.3 Modelo de efectos aleatorios
El estimador de efectos aleatorios considera que el componente individual en la
estimación no es fijo sino aleatorio, por lo tanto que no esta correlacionado con las
variables explicativas del modelo. Este supuesto permite incorporar variables
explicativas que observamos y son constantes en el tiempo, esto no lo podemos
hacer cuando estimamos por efectos fijos.









## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA - Stata learning module  | [Getting help](https://stats.oarc.ucla.edu/stata/modules/getting-help-using-stata/ "Getting help") | Cómo obtener ayuda en Stata  |
| UCSF GSI  | [Thinking like Stata](https://www.youtube.com/watch?v=jTtIREfhyEY&t=108s&ab_channel=UCSFGSI "Thinking like Stata") | Manejar la sintaxis de los comandos en Stata  |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
