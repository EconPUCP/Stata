# Regresiones

### 2. MULTICOLINEALIDAD Y HETEROCEDASTICIDAD

### 2.1 MULTICOLINEALIDAD

Cuando hay una relación lineal perfecta entre variables explicativas, los estimadores del modelo no pueden ser estimados. El término colinealidad implica que dos variables son casi una combinación lineal perfecta del otro. Cuando hay más de dos variables envueltas se llama multicolinealidad. Aunque los términos son mutuamente intercambiables. Que dos o más variables sean una combinación lineal de la otra significa que al sumar o restar algún valor en una de las variables se obtiene otra de las variables o una suma/resta de ellas. Un ejemplo muy simple se da en las variables dicotómicas. Por ejemplo, si Mujer = 1 cuando la observación es mujer y Mujer = 0 cuando la observación es hombre. Mientras que Hombre = 1 si la observación es hombre y = 0 en caso contrario. Entonces:

Mujer + Hombre = 1
Mujer = 1 – Hombre

Por lo que Mujer es una combinación lineal de Hombre y por ende no pueden entrar a la misma vez en una regresión. Es por esto que cuando se tienen una variable categórica de N categorías solo se consideran N − 1. + Esto también se puede dar en variables que no sea multicolineales por definición como en el caso del género. Veamos una forma de evaluar este problema en una regresión:
Consideremos un modelo similar al estimado previo, pero ahora considerando al PBI per cápita y al % de la población urbana como variables explicativas adicionales. Una forma de evaluar la multicolinealidad es usando el estadístico `VIF`, usado como post estimation luego de la regresión. Esto generó un valor VIF que se compara con el valor 10. Si es mayor a 10 entonces se tiene indicios de que esa variable es una combinación lineal de alguna otra variable.

```
* Testeando por Multicolinealidad
reg life school gdp urban i.region
vif 
```

![image](https://user-images.githubusercontent.com/106888200/224110420-ad313dd1-5f45-46fc-bc61-e5c0c86054d6.png)

### 2.2 HETEROCEDASTICIDAD

La heterocedasticidad se relaciona con uno de los supuestos del modelo MCO. Si no se cumple que Var(i) = σ2 entonces no hay homocedasticidad en la regresión y por lo tanto se tiene errores heterocedásticos. Revisemos una forma de detectar la presencia de heterocedasticidad en la muestra de datos. El test de Breusch-Pagan, genera un estadístico chi2 que tiene como hipótesis nula que la varianza es constante mientras que en la hipótesis alternativa se tiene que la varianza de los errores son funciones multiplicativas de una o más variables del modelo. Para usar este test de usa el post-estimation hettest. El mismo resultado nos brinda información acerca de la forma de la hipótesis nula, del estadístico y del p-value asociado al estadístico. El comando a utilizar es `hettest`, veamos un ejemplo:

```
* Testeando por Heterocedasticidad
reg life school gdp urban i.region
hettest
```

![image](https://user-images.githubusercontent.com/106888200/224111695-dce4321e-822a-494e-b00b-6e689fbc3eae.png)

En este caso, el p-value nos indica que rechacemos la hipótesis nula de varianza constante. Es decir, que tenemos una regresión heterocedástica. Esto no significa que necesariamente el modelo ya no sirva. Hay formas de solucionar los problemas de heterocedasticidad.

### 2.3 ERRORES ROBUSTOS

Una forma simple de resolver es usar la opción de errores estándar robustos del programa. Esta opción implementa el estimador de Huber-White en la matriz de varianza-covarianza de los coeficientes. Ojo: Esta opción solo afecta a los errores estándar pero no afecta al vector de estimadores (claro porque el ajuste no se da en el vector de coeficientes sino en la matriz de varianza/covarianza usada para obtener el error estándar). Se puede implementar usando solo , `robust` o `vce(robust)`

```
* Usar errores estándar robustos a la heterocedasticidad
reg life school gdp urban i.region, robust
reg life school gdp urban i.region,vce(robust)
```

Los coeficientes son iguales que antes

![image](https://user-images.githubusercontent.com/106888200/224113040-8edddd89-f5fc-4fd7-a917-d54cd818e5c1.png)

> **TIPS: corrigiendo la heterocedasticidad**
>
> Una manera de corregir la heterocedasticidad de nuestra regresión es a través de los errores robustos para lo cual usamos el comando `robust`, esto solo afectará a >los estimadores de errores estandar pero cambiaran los coeficientes.
>



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
