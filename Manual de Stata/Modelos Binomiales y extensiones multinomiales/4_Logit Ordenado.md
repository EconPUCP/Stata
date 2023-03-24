# EXTENSIONES MULTINOMIALES

En algunos casos, los datos categóricos están ordenados naturalmente. Por ejemplo si se desea estudiar los determinandtes del nivel educativo alcanzado. Las categorías "sin instrucción", "primaria", "secundaria" y "superior" tienen un orden jerárquico natural pues para pasar a la siguiente etapa se debe haber superado el anterior.
Los dos modelos estándar para tales datos son los modelos logit ordenado y probit ordenado.

### 2 LOGIT ORDENADO

El análisis lo realizaremos suponiendo un modelo que incluye una variable latente (no observada) y* que, a diferencia de nuestra variable dependiente, es continua y que se puede escribir como una función lineal de un vector de variables X:

$$Y_i^*=X_i^´\beta+u_i$$

Para un modelo ordenado de m-alternativas, definimos:

$Y_i=j$ sí $\alpha_{j-1}$ < $Y_i^*$ <= $\alpha_{j}$, j=1, ..., m

donde $\alpha_{0}=-∞$ y $\alpha_{m}=∞$. 

Entonces:

$$Pr(Y_i^ * =j)   =   Pr(\alpha_{j-1} < Y_i^* <=\alpha_{j})$$

$$Pr(Y_i^ * =j)   =   Pr(\alpha_{j-1} < X_i^´\beta <=\alpha_{j})$$

$$Pr(Y_i^ * =j)   =   Pr(\alpha_{j-1} - X_i^´\beta <=\alpha_{j} - X_i^´\beta)$$

$$=F(\alpha_{j}-X_i^´\beta) - F(\alpha_{j-1}-X_i^´\beta)$$

donde F es la función de distribución acumulativa. Para el modelo logit ordenado, $u_i$ se distribuye logísticamente con $F(z) =\frac{e^z}{1 + e^z}$.

Para estimar nuestro modelo en Stata procederemos a abrir nuestra base de datos 

```
cd "C:\Users\Usuario\Documents\GitHub\Stata\_Análisis\Data" // cambiar directorio

*************
use "data_modelo_multinomial.dta"
describe
tab estado_salud
```
![image](https://user-images.githubusercontent.com/128189216/227044367-489507d4-325b-4169-a714-2180c9a274b2.png)

Obrsevamos que nuestra variable "percepción de estado de salud" es una variable categórica ordenada. Para estimar este tipo de variables dependiente usaremos el comando  `ologit`

```
ologit estado_salud edad n_enf_cro ingresos 
```

![image](https://user-images.githubusercontent.com/128189216/227044901-c203de0a-6e4e-40e3-9fe9-4835322ee89e.png)

Notemos que en el caso del comando `ologit` se estima un vector beta de parametros, también no está presente el intercepto y ahora tenemos las estimaciones de los cortes. Podemos observar todas las variables incluidas en el modelo son estadisticamente significativas.

#### 2.1.1 Predict

Para obtener una predicción de la variable dependiente, después de la regresión se usa el comando `predict` seguido de un nombre para cada una de las variables asociadas a  cada tramo de la variable dependiente. Es útil examinar la media, el mínimo y máximo de las probabilidades predichas:

```
*Predict
predict mala buena excelente,pr 
sum mala buena excelente
```

![image](https://user-images.githubusercontent.com/128189216/227055192-cc25ada4-411c-42ef-9b1c-e01f59b22d7b.png)

#### 2.1.1 Efectos marginales

Los efectos marginales de esta estimación se deben computar en forma separada para cada una de las categorías de la variable dependiente. El comando a utilizar es `mfx`, el comando que computa los efectos marginales de cualquier estimación. veamos un ejemplo:

```
mfx, predict(outcome(3))
```

![image](https://user-images.githubusercontent.com/128189216/227056360-50316163-d118-4561-aa3c-0f4fa5c19468.png)


una opción alternativa es también usar en comando `margins`, llegas a los mismo resultados.

```
mfx, predict(outcome(3))
```

![image](https://user-images.githubusercontent.com/128189216/227056536-e3246cff-2cd9-466f-b1af-e26e13d69cef.png)

En el output de STATA se proveen los errores estándar y test t y p-values para la hipótesis nula de que los coeficientes de las
variables explicativas, a nivel individual, son iguales a cero, los que se interpretan de la manera habitual.



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| Luis García Núñez | [Extensiones Multinomiales - Logit Ordenado](https://www.youtube.com/watch?v=-Go7UoW0A-U "Extensiones Multinomiales - Logit Ordenado") | Teoría y ejemplo de Logit Ordenado en Stata |
| UCLA - Stata data analysis example | [Ordered Logit Regression](https://stats.oarc.ucla.edu/stata/dae/ordered-logistic-regression/ "Ordered Logit Regression") | Ejemplo de Logit Ordenado y uso de comandos en Stata |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20Binomiales%20y%20extensiones%20multinomiales/4_Logit_ordenado.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data "base de datos")* 
