# Evaluación de Impacto
 
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


Si bien El PSM es un método muy utilizado en evaluación de impacto, también tiene muchas críticas en cuanto a sus supuestos y sensibilidad a la especificación o a la muestra. El principal problema del Propensity score matching en la estimación del ATET es que no puede controlar las características no observables de los individuos, con lo cual existe un serio riesgo de sesgo en la estimación de este valor.



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| luis García Núñez  | [Econometría de evaluación de impacto](https://revistas.pucp.edu.pe/index.php/economia/article/view/2676http:// "Econometría de evaluación de impacto") | Principales métodos de evaluación de impacto y aplicaciones  |
| Mastering Metrics  | [MRU Short Videos](https://www.masteringmetrics.com/online-metrics-resources/ "MRU Short Videos")| Entendiendo qué es una evaluación de impacto |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
