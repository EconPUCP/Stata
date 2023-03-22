# Modelos Multinomiales

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







## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20multinomiales/2_Logit_ordenado.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data "base de datos")* 
