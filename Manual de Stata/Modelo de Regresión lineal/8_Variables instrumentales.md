# Regresiones

### 8. ANALIZANDO LOS SUPUESTOS DE VARIABLES INSTRUMENTALES

¿Cómo podemos ver si los instrumentos cumplen con sus condiciones?

- Condición de relevancia, $Corr(z,x)≠0, Cov(z,x)≠0$.

Podemos construir un estadístico:

$$\pi=\frac{Cov(z,x}{Var(z)}$$

Y, luego, testear:

$$H_0=\pi=0$$

$$H_a=\pi≠0$$

- Condición de exogeneidad, $Cov(z,u)=0$. 

No se puede hacer un test sobre este supuesto. En cambio, debemos justificar de alguna manera que esto se cumpla. Bien siguiendo la teoría económica o alguna fuente de exogeneidad (como un experimento).


### 8.1 CONDICIÓN DE RELEVANCIA

Para verificar la condición de relevancia podemos verificar el estadístico F de  generado en la primera etapa de la regresión. Una regla rápida es verificar si el F es mayor a 10.

```
use "http://fmwww.bc.edu/ec-p/data/wooldridge/openness", clear

* Condición de relevancia
eststo: ivreg2 inf (open = lland) lpcinc, first
```

![image](https://user-images.githubusercontent.com/106888200/224239724-0f95f9d7-5362-44e6-9ada-3d061a90ce08.png)   

Para ver los resultados de la primera etapa usamos la opción , `first`. Al final de esta primera parte vemos el test de F test of excluded instruments. El F es mayor a 10 por lo que podemos decir que el instrumento es relevante.
Si estamos ante un modelo sobreidentificado, es decir que hay más variables instrumentales que variables endógenas, entonces podemos aplicar otro tipo de test. Veamos el test de Sargan. Para ello consideremos como instrumento adicional una dummy = 1 cuando el país es petrolero. Este instrumento sería útil si asumimos que no afecta la inflación del país pero si la apertura comercial. En este caso la hipótesis nula es que ambos instrumentos, en conjunto, son válidos. Si rechazamos la H0 entonces tendríamos cierta evidencia a favor de dudar sobre la validez de los instrumentos usados, de manera conjunta.

```
* Condición de relevancia con sobreidentificación
eststo: ivreg2 inf (open = lland oil) lpcinc
```

![image](https://user-images.githubusercontent.com/106888200/224239917-ac3ac68f-8f66-4e61-a660-f5605268f1fa.png)

En este caso no podemos rechazar la nula por lo que el conjunto de instrumentos sería válido.


| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| Luis García Núñez | [Correlación entre los regresores y los errores](https://www.youtube.com/watch?v=2xMjmxbkfEE&list=PLvXMYc3QuXe_7363kwXPtwTrd6TzfofOa&index=28 "Correlación entre los regresores y los errores") | Teoría de las variables instrumentales y MC2E, verificando las condiciones de las variables instrumentales. |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelo%20de%20Regresi%C3%B3n%20lineal/8_variables_instrumentales.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data/Modelo%20de%20Regresi%C3%B3n%20lineal "base de datos")*


