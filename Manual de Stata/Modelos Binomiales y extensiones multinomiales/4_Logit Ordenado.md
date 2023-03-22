# Modelos Multinomiales

En algunos casos, los datos categóricos están ordenados naturalmente. Por ejemplo si se desea estudiar los determinandtes del nivel educativo alcanzado. Las categorías "sin instrucción", "primaria", "secundaria" y "superior" tienen un orden jerárquico natural pues para pasar a la siguiente etapa se debe haber superado el anterior.
Los dos modelos estándar para tales datos son los modelos logit ordenado y probit ordenado.

### 2 LOGIT ORDENADO

El análisis lo realizaremos suponiendo un modelo que incluye una variable latente (no observada) y* que, a diferencia de nuestra variable dependiente, es continua y que se puede escribir como una función lineal de un vector de variables X:

$$Y_i^*=X_i\beta^´+u_i$$

Para un modelo ordenado de m-alternativas, definimos:

$Y_i=j$ sí $\alpha_{j-1}$ < $Y_i^*$ <= $\alpha_{j}$, j=1, ..., m

donde $\alpha_{0}=-∞$ y $\alpha_{m}=∞$. 

Entonces:


Entonces, la selección de cada categoría se observa según la variable
latente cruce secuencialmente determinados umbrales:



Como en el caso del modelo de regresión binario, se puede realizar una estimación por medio del método de Máxima Verosimilitud para aproximarse a la regresión de $Y_i^*$ respecto del vector X





Si suponemos que los errores siguen una distribución logística, estamos ante el modelo LOGIT ORDENADO.

donde F es la función de distribución acumulada





El logit ordenado se estima con el objetivo de determinar de forma paramétrica la probabilidad de pertenencia en cada una de las categorías contempladas. El modelo tiene la siguiente forma:

$$Y*=\betaz_i+e_i


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20multinomiales/2_Logit_ordenado.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data "base de datos")* 
