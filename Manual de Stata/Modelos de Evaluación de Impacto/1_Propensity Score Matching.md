# EVALUACIÓN DE IMPACTO
 
El objetivo de una evaluación de impacto es estimar el efecto causal (impacto) de una
intervención (P) en un resultado (Y). Donde:

 $$P = Tratamiento$$
 
 $$Y = Resultado$$

Formalmente, el impacto del tratamiento es:

$$α = (Y | P=1) - (Y | P=0)$$

Este impacto se obtiene comparando a el mismo individuo con y sin el programa en el mismo momento, el gran problema es que nunca observamos al mismo individuo con y sin el programa en el mismo instante. Para ello se busca usar métodos que permitan construir contrafactuales pertinentes que permitan estimar este efecto causal. Entonces, ahora tendremos que la diferencia entre la observación de un individuo con tratamiento y un contrafactual será el impacto estimado.

las tres herramientas para diseño de evaluación de impacto más usuales son:

- Método de emparejamiento (Propensity Score Matching)

- Método de diferencias en difernecias (Dif-in-Dif)

- Método de regresión discontinua (Regression Discontinuity)


## 1.  PROPENSITY SCORE MATCHING

El propensity score matching (PSM) consiste en buscar observaciones no tratadas que sean similares a las tratadas, con base en un conjunto de variables que determinen la probabilidad de estar en el programa.

La eficacia de un diseño de PSM depende principalmente de qué tan buena son las características observables de los individuos para determinan su participación en el programa. Si el sesgo de las características no observadas es muy pequeño, PSM proporciona buenas estimaciones; Si el sesgo de las características no observadas es grande, entonces las estimaciones del PSM pueden estar sesgadas.
El uso de demasiadas covariables para calcular el puntaje de propensión puede generar una ruptura del supuesto de soporte común (common support)

El tipo de emparejamiento más común es el "Nearest Neighbour", este algoritmo selecciona los mejores controles emparejados para cada individuo tratado. En cada etapa del matching se elige la observación del grupo control que esté lo más cercana a la observación tratada según la distancia especificada. Si múltiples individuos controles se encuentran a la misma distancia del sujeto tratado, se selecciona aleatoriamente a uno de estos.

Abriremos nuestra base de datos, 

```
use "http://www.stata-press.com/data/r16/cattaneo2.dta", clear
```

Procederemos a medir la diferencia entre el grupo de tratados y el grupo de control usando el comando `ttest` seguido por la variable bweight considerando al grupo de los tratados y control.

```
ttest bweight, by(mbsmoke)
```

![image](https://user-images.githubusercontent.com/128189216/229385092-a0921dfe-d16d-4814-90a4-de052b752cba.png)


Para observar cómo varía la distribución de la variable bweight entre ambos grupos realizamos un gráfico de los kernel de densidad.

```
twoway (kdensity bweight if mbsmoke == 0, lcolor(red)) (kdensity bweight if mbsmoke == 1, lcolor(blue)), legend(order(1 "Control" 2 "Tratado" ))
```

![image](https://user-images.githubusercontent.com/128189216/229384696-45cb7533-474c-45bf-a208-07347c6a414b.png)


Podemos observar que hay diferencias sistemáticas entre nuestras observaciones tratadas y de control.

Procederemos a estimar la diferencia a partir del PSM usando varias alternativas. La primera forma es a tráves del comando `psmatch2`, recuerda que este comando debe ser instalado previamente con el comando `ssc install`.

```
ssc install psmatch2
psmatch2 mbsmoke mmarried c.mage##c.mage medu fbaby, out(bweight) ate
```

![image](https://user-images.githubusercontent.com/128189216/229385144-d93b6ec2-e124-4469-9fbe-0f197de5eaaa.png)


Utilizaremos una forma alternativa con el comando `teffects`

```
teffects psmatch (bweight) (mbsmoke mmarried mage medu fbaby, probit), atet nn(1)
```

![image](https://user-images.githubusercontent.com/128189216/229385210-91d486e8-2ac7-4009-8252-7e27b28ed534.png)


Y finalmente utilizaremos un ejemplo utilizando un emparejamiento por kernel con distribución normal

```
psmatch2 mbsmoke mmarried c.mage##c.mage medu fbaby, out(bweight) ate kerneltype(normal)
```

![image](https://user-images.githubusercontent.com/128189216/229385241-888c08f4-8324-4ba4-89d0-7c6b12d040e7.png)


Si bien El PSM es un método muy utilizado en evaluación de impacto, también tiene muchas críticas en cuanto a sus supuestos y sensibilidad a la especificación o a la muestra. El principal problema del Propensity score matching en la estimación del ATET es que no puede controlar las características no observables de los individuos, con lo cual existe un serio riesgo de sesgo en la estimación de este valor.



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| luis García Núñez  | [Econometría de evaluación de impacto](https://revistas.pucp.edu.pe/index.php/economia/article/view/2676http:// "Econometría de evaluación de impacto") | Principales métodos de evaluación de impacto y aplicaciones  |
| Mastering Metrics  | [MRU Short Videos](https://www.masteringmetrics.com/online-metrics-resources/ "MRU Short Videos")| Entendiendo qué es una evaluación de impacto |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20de%20Evaluaci%C3%B3n%20de%20Impacto/1_PSM.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data/Modelos%20de%20Evaluaci%C3%B3n%20de%20Impacto "base de datos")* 
