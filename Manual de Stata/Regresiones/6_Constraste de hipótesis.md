# Regresiones

### 6 CONTRASTE DE HIPÓTESIS

Luego de revisar cómo hacer regresiones básicas, repasamos cómo implementar pruebas de hipótesis en el programa. Para ello aprenderemos a usar el comando `ttest`.

### 6.1 TTEST

El comando `ttest` nos permite contrastar estadísticamente el valor de uno de los coeficientes estimados en las regresiones.

Para este módulo trabajaremos con el módulo 5 de la ENAHO y para fines prácticos no consideraremos el diseño muestral. Comparemos la edad promedio en la muestra entre hombres y mujeres:

```
use "enaho01a-2019-500"
ttest p208a, by(p207)	
```

![image](https://user-images.githubusercontent.com/106888200/224228471-c683ec1f-db09-43a5-9bbc-d1ae452c48cf.png)

La primera parte del resultado presenta estadísticos descriptivos para la variable edad con respecto a hombres y mujeres, así como para toda la muestra. La última fila presenta la diferencia de medias, así como su error estándar e intervalo de confianza.
La segunda parte del resultado presenta la definición de la variable diff, es decir la diferencia de promedios. Si no hubiera diferencias en el promedio de estas dos variables la diferencia debería ser estadísticamente indistinta de cero. Para ello, se plantea como hipótesis nula:

               H0 : diff = 0

Y, como hipótesis alternativa se plantean tres opciones a contrastar de manera separada:
_Ha = diff < 0_, es decir que la diferencia sea estadísticamente menor a cero
_Ha = diff ! = 0_, es decir que la diferencia sea distinta cero (mayor o menor)
_Ha = diff > 0_, es decir que la diferencia sea mayor a cero
Cada hipótesis alternativa tiene su respectivo p-value asociado. En este caso concluiríamos que rechazamos la hipótesis nula de que la diferencia sea igual a cero y no rechazamos que sea indistinta cero y menor a cero (las dos primeras hipótesis alternativas).
También podemos contrastar el valor de una variable con un valor fijo.

```
* Comparamos la edad promedio con un valor fijo, sin considerar el diseño muestral
mean p208a
ttest p208a==42.5
```

![image](https://user-images.githubusercontent.com/106888200/224228713-c070a4f9-9f57-46ea-a0da-5d5ec0023152.png)

En este caso comparamos la edad promedio con 42.5. El contenido del resultado es similar al anterior. En este caso no podemos rechazar que el promedio de la variable sea igual a 42.5.
Hasta este puntos hemos usado el comando ttest con los datos sin considerar el diseño muestral. Ahora veamos como implementar un test de medias (un test de medias es un test en donde se compara el promedio de una variable entre grupos) usando el diseño de muestral.
Si consideramos el diseño muestral primero debemos estimar los promedios usando el prefijo `svy`:. Luego tenemos dos opciones, podemos usar el comando text (distinto a ttest) o usar el comando lincom (que hace el mismo test sobre una combinación lineal de los coeficientes). Veamos los dos casos. 

```
* Test de medias, considerando diseño muestral 
svy: mean p208a, over(p207)  coeflegend

test _b[hombre] = _b[mujer] // Usando el comando test

lincom _b[hombre] - _b[mujer] // Usando el comando lincom
*return list
display (r(estimate)/r(se))^2 // Comparamos el F en ambos casos
```
Al correr los promedios estimados usamos la opción coeflegend para ver la leyenda de cada coeficiente. Las leyendas de los coeficientes son _b[hombre]_ y _b[mujer]_ para hombre y mujer respectivamente. De esta manera comparamos el promedio para hombre y mujer en el primer caso usando test. En el segundo caso comparamos la diferencia de ambos con lincom. Al final usamos los resultados guardados para encontrar el F y compararlo con el F del test.

![image](https://user-images.githubusercontent.com/106888200/224228813-6edf9e97-db18-4176-9be9-0cb753d57c31.png)

En ambos casos el F es igual a 61.14 y el p-value indica que se rechaza la H0 de que sean iguales.

****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
