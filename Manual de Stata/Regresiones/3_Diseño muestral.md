# Regresiones

### 3. DISEÑO MUESTRAL: SIMPLE Y COMPLEJO

### 3.1 DISEÑO MUESTRAL

Las encuestas son una herramienta muy importante en la recolección de datos. A diferencia de un censo, una encuesta se basa en método estadístico para recolectar cierta información considerando que esa cantidad de encuestados permite hacer inferencia sobre la situación de una unidad más grande como un distrito o un país. En este caso es bastante necesario revisar la documentación de las encuestas para tener un mejor entendimiento no solo de las variables en sí sino también del proceso de levantar esa información.

Antes de seguir hay algunas definiciones que aclarar:

- Weight: Es el peso que tiene cada observación en la muestra. En un diseño muestral simple, si consideramos probability weight, este peso es igual a N/n, en donde N es el número de elementos en la población y n= el número de elementos en la muestra. En un diseño muestral de dos etapas, es igual a f1f2 en donde cada uno indica el mismo concepto previo, pero para su respectiva etapa de muestreo. Si sumamos todos los pesos (o también llamados factores de expansión) obtendríamos un estimado del universo de observaciones.
- PSU: hace referencia a la unidad de muestreo primaria (primary sampling unit). Esta es la primera unidad en ser muestreada en el diseño. Por ejemplo, si queremos crear una muestra de colegios en Lima podemos comenzar tomando un muestra de UGEL-es (Unidades de Gestión Educativa Local) y luego hacer aleatorizar los colegios que estén dentro de las UGEL-es seleccionadas. En ese caso, el PSU sería las UGEL-es seleccionadas.
- Strata: Hace referencia a los estratos sobre los cuales se aleatoriza usados para mejorar la precisión de los estimadores. La estratificación funciona más efectivamente cuando la varianza de la variable dependiente es menor dentro de cada estrato que en la muestra completa.
- FPC: hace referencia a una corrección por población finita (Finite Population Correction) y es igual a ((N-n)/(N-1))1/2. Es usado cuando la fracción de muestral (n/N) se hace larga y se necesita ajustar los errores estándar estimados.

No necesariamente usaremos todas estas opciones al momento de definir el diseño muestral que manipularemos en el programa. En este caso no vamos a discutir como hacer un muestreo en sí pero sí como usar una base de datos con diseño muestral en el programa.

### 3.2 DECLARAR DISEÑO MUESTRAL: SVYSET

Para declarar que nuestra base de datos parte de un diseño muestral debemos usar el comando `svyset` al inicio de nuestro código.

Usemos el módulo de empleo de ENAHO para hacer algunos ejemplos con este comando.

```
* Declaramos el diseño muestral
/*
PSU    -> conglome
Weight -> fac500a
Strata -> estrato
*/
svyset conglome [pweight = fac500a], strata(estrato)

svydescribe
```

En este caso definimos los valores para PSU, Weight y Strata. Obviamos el valor para FPC. Ojo: el peso (también llamado factor de expansión o ponderador) puede varias de acuerdo al módulo de ENAHO. En este caso el factor de expansión se llama fac500a. Podemos describir los datos de la muestra usando `svydescribe`:

![image](https://user-images.githubusercontent.com/106888200/224202231-4627f8bf-3a47-41ef-9068-f759ae1617eb.png)


Aquí observamos el número de estratos, de unidades y de observaciones por unidad. Así como otra información relacionada al diseño en sí. Luego de declarar que los datos parten de un diseño muestral podemos usar el prefijo `svy`: antes de los códigos usuales para que el comando considere el diseño muestral. Este prefijo se puede usar con muchos comandos, pero no con todos. Por lo que debe estar atento por si sale algún mensaje de error en la pantalla de resultado.
Comparemos los resultados de tabular los valores de la variable ocu500, condición laboral. El resultado de la proporción varía si usamos el prefijo `svy`: y si no lo usamos.

```
svy: tab ocu500
tab ocu500
```

![image](https://user-images.githubusercontent.com/106888200/224202316-e8255e41-eb2b-47f7-81ff-f2dedaf844e5.png)

Ahora comparemos una regresión simple. En este caso regresionaremos el Ingreso total (imputado, deflactado y anualizado) contra la edad y el género de la persona. 

```
svy: reg i524a1 p208a i.p207
reg i524a1 p208a i.p207
```

![image](https://user-images.githubusercontent.com/106888200/224202375-468dc42c-c9e7-4c81-9af3-c740bde0fc5c.png)

La pantalla de resultados también es distinta al resultado obtenido por una regresión sin diseño muestral. En este caso el análisis de suma de cuadrados no se presenta. En cambio se indica algunos datos relacionados al diseño muestral como el número de estratos y de PSU’s. En la la segunda sección vemos algunos datos nuevos, particularmente el Population size y los grados de libertad del diseño, Design df.
Si queremos obtener un estimador para sub grupos en la muestra debemos usar la opción `,subpop()` dentro del prefijo. Estimemos el mismo modelo previo pero considerando solo observaciones para Lima Metropolitana. Previamente tenemos que crear una variable dicotómica, con valor 0 y 1, para Lima a partir de la variable dominio.

```
* Usando subpop para obtener estimado en Lima Metropolitana
gen lima = 1 if dominio==8
replace lima =0 if lima ==.

svy, subpop(lima): reg i524a1 p208a i.p207 /*este es el correcto a usar*/
 reg i524a1 p208a i.p207 if lima ==1 
```
De esta manera consideramos el diseño muestral en la selección de la sub muestra que queremos analizar.

![image](https://user-images.githubusercontent.com/106888200/224202470-8a59294e-8560-47b1-9799-59a06843c498.png)

Comparemos ahora cuáles son las diferencias entre estimar el mismo modelo sin considerar el diseño muestral, solo considerando las ponderaciones y considerando todo el diseño muestral:

```
* Comparamos la regresión simple, solo con pesos y con diseño muestral
* Para usar eststo y esttab debe instalar el paquete estout
ssc install estout
eststo clear
eststo: reg i524a1 p208a i.p207
eststo: reg i524a1 p208a i.p207 [pweight=fac500a]
eststo: svy: reg i524a1 p208a i.p207 /*la manera correcta de estimar*/
esttab
```

Para hacer la comparación vamos a conocer algunos comando nuevos. Una forma de almacenar resultados de manera rápida es usando `eststo` (esto viene de estimates store). Lo usamos como un prefijo adicional en la línea de regresión para almacenar los datos de estimación como los coeficientes, el estadístico t o el p-value. Como estamos almacenando información de manera consecutiva, cada vez que queremos volver a grabar un conjunto de información debemos usar el comando eststo clear. En el ejemplo, limpiamos los datos guardados y almacenamos los resultados de tres regresiones. Por último, usamos el comando `esttab` (viene de estimates tabulation) para tabular los resultados almanceados. La primera regresión es la regresión simple. La segunda es la misma pero solo consideramos el peso de cada observación (es decir el factor de expansión) con la opción entre corchetes [pweight = fac500a] (en este caso usamos pweight porque el peso del diseño el un probability wieght, hay más opciones que puede explorar). La tercera regresión considera todo el diseño muestral.
Cada columna indica cada regresión corrida. La tabla contiene los estimadores, su nivel de significancia expresado en * y en paréntesis los estadísticos t. De esta comparación vemos que la primera regresión genera estimadores distintos a los ‘correctos’ estimados al considerar todo el diseño muestral. Si solo consideramos el factor de expansión como un peso entonces obtenemos los coeficientes correctos pero no obtenemos los errores estándar correctos

![image](https://user-images.githubusercontent.com/106888200/224202567-c997bced-e150-4d15-8f2a-2b6bcde444a8.png)

> **TIPS: factor de expansión Sumaria**
>
>Cuando usemos Sumaria o módulos a nivel de hogar, para poder obtener las estadísticas oficiales, no podemos usar el factor de expansión de manera directa, se debe generar una nueva variable que multiplique el factor de expansión por mieperho.
>
>```
>factor_hogar =  factor07*mieperho
>```

****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
