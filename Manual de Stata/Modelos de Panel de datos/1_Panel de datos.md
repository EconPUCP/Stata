# MODELO DE PANEL DE DATOS

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

> **TIPS: Shell para datos panel**
>
> Un consejo de Stata para generar paneles es usar la opción egen seq. Una poderosa herramienta para generar todo tipo de secuencias, esto dará un panel limpio y balanceado.
>
>```
>clear// 
>define the panel variables
>local units = 40 // panel variable
>local start = 2000 // time start
>local end = 2022 // time end
>
>local time = `end' - `start' + 1
>local obsv = `units' * `time'
>set obs `obsv'
>egen id = seq(), b(`time')
>egen t = seq(), f(`start') t(`end')
>```


## 1.2 MODELOS DE PANEL DE DATOS

Con los datos panel procedemos a estimar los siguientes modelos:

#### 1.2.1  Modelo agrupado (pooled)
Tan solo se agrupan o apilan las observaciones y se estima una regresión, por MCO sin atender la naturaleza de corte transversal y de series de tiempo de los datos. En este método se consideran que todos los coeficientes del modelo o ecuación son constantes

```
eststo pooled_ols: reg lsalario raza escolaridad sexo experiencia urbano i.zona
```

![image](https://user-images.githubusercontent.com/128189216/227408943-e6dd8d05-4324-47a9-b37f-a95c086374e1.png)


#### 1.2.2  Modelo de efectos fijos (FE)

El método de efectos fijos considera que existe un término constante diferente para cada individuo, y supone que los efectos individuales son independientes entre sí.
Con este modelo se considera que las variables explicativas afectan por igual a las unidades de corte transversal y que éstas se diferencian por características propias de cada una de ellas, medidas por medio del intercepto. 

El método de Efectos fijos se puede estimar usando tres caminos:

- Least Square Dummy Variable, LSDV, con el comando `reg`.
- Efectos fijo, FE, con el comando `xtreg`.
- Absorbiendo los efectos fijos con el comando `areg`.

```
* LSDV
eststo lsdv: reg lsalario raza escolaridad sexo experiencia urbano i.zona i.id

* FE
eststo fe: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, fe

* LSDV -AREG
eststo alsdv: areg lsalario raza escolaridad sexo experiencia urbano i.zona, absorb(id)

estimates table lsdv fe alsdv, drop(i.id)
```

- ![image](https://user-images.githubusercontent.com/128189216/227419929-71a92ca2-bf0a-4c61-a771-4ef615244ed5.png)

Podemos también estimar el modelos por efectos fijos temporales haciendo uso del comando `reg` siguiendo las estrategias previas, pero ahora debemos agregar la variable de de tiempo como factor.

```
* LSDV
eststo lsdv_it: reg lsalario raza escolaridad sexo experiencia urbano i.zona i.id i.año

* FE
eststo fe_it: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona i.año, fe

* LSDV -AREG
eststo alsdv_it: areg lsalario raza escolaridad sexo experiencia urbano i.zona i.año, absorb(id)

estimates table lsdv_it fe_it alsdv_it, drop(i.id i.year)
```

![image](https://user-images.githubusercontent.com/128189216/227421163-1ed8ee3f-e5e9-4781-b002-7914151289f0.png)


#### 1.2.3 Modelo de efectos aleatorios

El modelo de efectos fijos es un modelo razonable cuando se posee evidencia de que la diferencia entre los diferentes individuos o agentes sociales de la muestra( o bien los diferentes momentos en el tiempo) son cambios en el parámetro de intersección de la función de regresión. Para estimar el modelo hacemos uso del comando `xtreg` agregando la opción `re`.

```
eststo re: xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, re
```

![image](https://user-images.githubusercontent.com/128189216/227422243-27d925d2-ccbd-47a5-a558-e029c90126c3.png)




## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA - Stata Learning modules | [Reshaping data wide to long](https://stats.oarc.ucla.edu/stata/modules/reshaping-data-wide-to-long/ "Reshaping data wide to long")  | Uso del comando `reshape` para data panel de datos |
| UCLA - Stata Learning modules | [Reshaping data long to wide](https://stats.oarc.ucla.edu/stata/modules/reshaping-data-long-to-wide/ "Reshaping data long to wide") | Uso del comando `reshape` para data panel de datos  |



****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20de%20Panel%20de%20datos/1_Modelos_panel_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
