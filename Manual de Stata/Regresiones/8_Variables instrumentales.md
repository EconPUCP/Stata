# Regresiones

### 8. ANALIZANDO LOS SUPUESTOS DE VARIABLES INSTRUMENTALES

¿Cómo podemos ver si los instrumentos cumplen con sus condiciones?

- Condición de relevancia, Corr(z,x)≠0 o , Cov(z,x)≠0.
Podemos construir un estadístico:

![image](https://user-images.githubusercontent.com/106888200/224239423-f469998c-2c13-4f9f-8e53-d81a465c9243.png)

Y, luego, testear:

![image](https://user-images.githubusercontent.com/106888200/224239485-174e787d-686a-439a-adfe-10918c82e833.png)

- Condición de exogeneidad, Cov(z,u)=0. 
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


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*


