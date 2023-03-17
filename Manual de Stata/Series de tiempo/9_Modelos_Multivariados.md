# Modelo de series de tiempo

## 9.  MODELOS MULTIVARIADOS


En la parte previa de series de tiempo nos dedicamos a analizar algunas regresiones univariadas, es decir, en donde solo tenemos una variable dependiente. En esta parte aprenderemos algunos modelos multivariados. En estos modelos tenemos más de una variable dependiente. 

De esta manera, cada variable depende no solo de sus rezagos (como en los casos ARMA), sino, también en los rezagos del resto de variables dependientes. Esto con el objetivo de mejorar la estimación debido a que se está considerando mayor información relevante. 
En esta línea repasamos cómo implementar los siguientes modelos:

- VAR
- SVAR

Repasaremos parte de la teoría de los modelos con el objetivo de darle un contexto a los comandos que aprenderemos. Esto no reemplaza a una revisión profunda de los modelos por lo que sí tienen interés deberían revisarlo en algún libro de texto de econometría.

### 9.1 MODELOS VAR

Los modelos VAR se componen de un conjunto de ecuaciones simultáneas similares a los ARMA (también se pueden llamar VARMA cuando incluyen rezagos en la perturbación) por lo que hasta cierto punto el análisis es similar.

Adicionalmente, realizaremos algunos procedimientos nuevos referidos a la generación de funciones de impulso-respuesta y a la descomposición de la varianza del error con el objetivo de desenredar la relación entre el conjunto de variables dependientes. Partamos de un modelo básico VAR(1):

$$y_t=\beta_{10}+\beta_{11}y_{t-1}+\beta_{12}x_{t-1}+\beta_{13}z_{t-1}+e_{yt}$$

$$x_t=\beta_{20}+\beta_{21}y_{t-1}+\beta_{22}x_{t-1}+\beta_{23}z_{t-1}+e_{yt}$$

En donde $y_t$ y $x_t$ son las variables dependientes y eyt, ext son ruidos blancos para cada serie. También podemos expresar este modelo de manera matricial de la siguiente manera:

$$
\left(\begin{array}{cc} 
y_{t}\\
x_{t}
\end{array}\right)=
\left(\begin{array}{cc}
β_{10}\\ 
β_{20}
\end{array}\right) +
\left(\begin{array}{cc}
β_{11} & β_{12}\\
β_{21} & β_{22}
\end{array}\right)
\left(\begin{array}{cc} 
y_{t-1}\\
x_{t-1}
\end{array}\right) +
\left(\begin{array}{cc} 
e_{yt}\\
e_{xt}
\end{array}\right)$$

O también:

$$Y_t=B_0+B_1Y_{t-1}+E_t$$

Al igual que en el caso ARMA, debemos verificar que las series yt y xt sean estacionarias. Por último, se asume que:

- $E_t ~ N (0,Σ_E)$
 
- $Var(E_t)=Σ_E$

- $Cov(E_t, E_{t-i})=0, i=1,2,...$

- $Cov(e_{yt}, e_{xt})=0, i=1,2,...$

Tomemos las series de variación mes a mes de inversión minera junto a la serie de variación mes a mes en los términos de intercambio de la siguiente manera:

$$Y_t=B_0+B_1Y_{t-1}+E_t$$

En donde: 

$$Y_t=[ΔTI_tΔInvMin_t]$$

Los criterios de selección de rezagos son los mismos usamos para ver los rezagos de los modelos ARMA. En este caso podemos usar el comando varsoc para sistematizar el procedimiento que vimos previamente. Esto considerando que el comando varsoc solo compara modelos basados en rezagos de las dependientes. Debemos seleccionar las variables y el número máximo de rezagos a considerar.

```
varsoc ti im, maxlag(8)
```

![image](https://user-images.githubusercontent.com/106888200/224494024-aed4b9c3-5ea3-4e3b-afa7-1154b08f18c2.png)

El comando genera los criterios de información para cada conjunto de rezagos. El modelo seleccionado es el que tiene *. En este caso es el modelo con hasta el 2do rezagos.

$$Y_t=B_0+B_1Y_{t-1}+B_2Y_{t-2}+E_t$$

Luego de seleccionar el número de rezagos podemos estimar el modelo con el comando var indicando el número de rezagos a considerar. Veamos la primera parte del resultado:

```
var ti im, lags(1/2)
```

![image](https://user-images.githubusercontent.com/106888200/224494032-b7da0e33-7100-4039-b2d8-d0fd4e397557.png)

En la primera parte tenemos información general como el número de observaciones, los criterios de información y resultados parciales para cada ecuación dentro del sistema de ecuaciones.

En la segunda parte tenemos los coeficientes estimados:

![image](https://user-images.githubusercontent.com/106888200/224494042-9a9a415b-e8fd-4c82-a8a1-75c73dc7a37e.png)

A pesar de que los coeficientes no sean significativos igual serán usados para estimaciones futuras, por ejemplo para las funciones de impulso-respuesta, por lo que no nos enfocaremos en interpretar los coeficientes de manera individual. Para obtener la matriz de varianza-covarianza tenemos que recuperarla de la estimación:

```
matrix varcov = e(Sigma)
matrix list varcov
```

![image](https://user-images.githubusercontent.com/106888200/224494058-23806cd1-e759-4968-b749-d05cb15a1a91.png)

Podemos ver que los errores de cada ecuación no son independientes entre si. Por lo que se mantiene cierta endogeneidad entre ambas ecuaciones a pesar de considerarlas simultáneamente. Veremos con los SVAR una posible solución para esto. A partir de estos resultados analizaremos dos tópicos adicionales: Causalidad a ala Granger y Funciones de Impulso-Respuesta.

#### 9.1.1 Causalidad a la Granger

Se dice que una variable xt causa a la Granger a yt si, dado el número de rezagos de yy , los rezagos de xt son conjuntamente significativos. Esta definición de causalidad no es la misma que se usa dentro del contexto de evaluación de impacto o de experimentos. Es una definición estadística particular. Para implementarlo usamos el comando vargranger luego de estimar el modelo.

```
vargranger
```

![image](https://user-images.githubusercontent.com/106888200/224494070-3981e909-c661-4a43-9374-5fdcc3fcd5e9.png)

Para cada ecuación, vargranger testea ‘causalidad a la Granger’ para cada variable y luego para todas las variables conjuntamente. La primera fila excluye la variable im mientras que la segunda considera todo. Es decir, en la primera fila se toma como hipótesis nula que todos los coeficientes, excluyendo im, son ceros mientras que en la segunda fila se testa que todos son ceros. La alternativa es que al menos uno es distinto a cero.
Para la primera ecuación, rechazamos la hipótesis nula de que todos los coeficientes son conjuntamente ceros. Es decir, los rezagos de la variación de los términos de intercambio y de la inversión minera ‘logran’ explicar parte de la variación actual de los términos de intercambio. Esto tiene sentido económico puesto que la inversión minera puede afectar el tipo de cambio y por ende el ratio de precio, es decir, los términos de intercambio. Contrariamente, tenemos que no podemos rechazar la hipótesis nula en la segunda ecuación. Por lo que la variación de los términos de intercambio no ‘causan a la Granger’ a la inversión minera.

#### 9.1.2 Funciones de Impulso-Respuesta 

Un segundo conjunto de estadísticos usados para evaluar los VAR consiste en ‘simular’ algún ‘shock’ al sistema con el objetivo de ver qué efectos tiene sobre las variables endógenas. Para esto usaremos la familia de comandos irf (irf significa Impulse Response Function). Este comando nos permite crear un archivo .irf en donde se almacenan los resultados del VAR. 

![image](https://user-images.githubusercontent.com/106888200/224494088-90892e03-7a37-4912-9bfd-3dfb2da64b01.png)

Por lo que primero debemos crear el archivo estableciendo algunas cosas. Veamos
Con irf create creamos un archivo .irf llamado var_irf. Dentro de este archivo podemos tener varias estimaciones de VAR guardadas por lo que a esta estimación en particular la llamamos irf_1. Adicionalmente, establecemos un horizonte de periodos de 36 (si estamos en meses esto sería igual a 3 años) y definimos que se reemplacen los archivos en cada corrida con el comando replace

```
var ti im, lags(1/2)

irf create var_irf , step(36) set(irf_1) replace
```

![image](https://user-images.githubusercontent.com/106888200/224494241-ff46f9cf-3f1e-48db-a751-f76187e5434f.png)

Luego podemos usar algunas de las opciones de irf graph para presentarlos resultados que queremos:


![image](https://user-images.githubusercontent.com/106888200/224494259-815a9db9-5087-4ba4-bb92-4743978b3717.png)

Cada opción tiene un soporte teórico que permite interpretarlos por lo que les recomiendo que profundicen en ellas si tienen interés. En este caso haremos algunos ejemplos de estas opciones enfocándonos en la función de impulso-respuesta ortogonalizada, en su acumulada y descomposición de la varianza del error de predicción.
Usamos los siguientes códigos para estimar los tres gráficos:

```
irf create var_irf , step(36) set(irf_1) replace

irf graph oirf, impulse(ti im) response(ti im) xtitle("Periodos") 

irf graph coirf, impulse(ti im) response(ti im) xtitle("Periodos") 

irf graph fevd, impulse(ti im) response(ti im) xtitle("Periodos") 
```

- oirf: Para la función ortogonalizada de impulso-respuesta
- coirf: Para la función ortogonalizada acumulada de impulso-respuesta.
- fevd: Para la función de descomposición del error de predicción.

Adicionalmente, se puede indicar las funciones que sean los impulsos (es decir cuál término de error se genera el choque) y las respuestas (en qué variables evaluar). En este caso solo tenemos dos variables por lo que incluimos todo.

#### 9.1.2.1 oirf

Veamos el primer gráfico del cuadro. Se evalúa el ‘efecto’ de un choque en im sobre im (el segundo sería el efecto sobre ti). El eje Y nos indica el cambio en porcentajes de la variable mientras ante un cambio de 1 desviación estándar en el término de error mientras que el eje X indica los periodos. La línea del centro es el ‘efecto’ promedio mientras que la parte sombreada indica el intervalo de confianza. Ojo: en este escenario el valor es significativo si los intervalos de confianza no cruzan el eje X.

![image](https://user-images.githubusercontent.com/106888200/224494299-9644561a-f48f-44ae-9e51-62d33e18120e.png)

#### 9.1.2.2 coirf

La opción coirf permite presentar los resultados previos, pero de forma acumulada. En el caso anterior el efecto era parcial, es decir, para cada periodo. En este caso se presenta la suma consecutiva de efectos parciales. La interpretación sigue siendo la misma.

![image](https://user-images.githubusercontent.com/106888200/224494316-ed65adac-16c7-4a4f-aeef-c0fe4303387e.png)

#### 9.1.2.3 fevd

La descomposición de la varianza del error de predicción (o forecast error variance decomposition, fevd) mide la fracción de la varianza del error de predicción de una variable endógena atribuible a un choque ortogonalizado. Es decir, queremos ver qué variable ‘explica más’ la varianza de cada endógena.

![image](https://user-images.githubusercontent.com/106888200/224494361-67d7cec4-210f-4813-8798-d15758f414ea.png)

### 9.2 MODELOS SVAR

Al VAR visto previamente también se le puede conocer como VARreducido en el sentido de que representa una forma ‘estructural’ del modelo en donde se considere los efectos contemporáneos de las variables endógenas (ya no solo depende de los rezagos de las otras endógenas sino también del valor en el mismo periodo). 

Esta forma estructural se llama Structural VAR o SVAR. Su desarrollo es bastante amplio puesto que se puede desarrollar distintas maneras de estimar el VAR de manera estructural. En este caso veremos una forma general e introductoria de cómo estimarlos en Stata. Consideremos un VAR de la siguiente manera:

$$Y_t=A_1Y_{t-1}+...+A_kY_{t-k}+E_t$$

$$E(E_tE_t)=Σ_E)$$

Si consideramos los efectos contemporáneos tendríamos un sistema como el siguiente:

$$A_tY_t=C_1Y_{t-1}+...+C_2Y_{t-k}+BE_t$$

En donde:

$$E_t=BU_t$$

$$A ≠ I$$

$$E(U_tU_t)=I$$

Entonces, el objetivo es estimar conjuntamente A, B y C pero no es posible debido a que no es posible identificarlos correctamente. Sobre este punto se puede desarrollar argumentos estadísticos que salen del tema de programación. En resumen, se necesita considerar algún criterio para poder identificar y estimar los parámetros estructurales. Estos criterios pueden considerar información de ‘corto plazo’ , de ‘largo plazo’ o de otro tipo.

#### 9.2.1 Descomposición de Cholesky

Un método de identificación común parte de asumir que B = I y restringir los valores de A para que sea una matriz triangular inferior de ceros. Por lo que se puede recuperar los valores de las variables a partir de una descomposición de Cholesky. Esta estrategia asume cierta causalidad de las variables, por ejemplo, si A es triangular inferior:


$$
AY_t=
\left(\begin{array}{cc}
1 & a_{01}\\
a_{02} & 1
\end{array}\right)
\left(\begin{array}{cc} 
y_t\\
x_t\end{array}\right)=
\left(\begin{array}{cc} 
1 & 0\\
a_{02} & 1
\end{array}\right)
\left(\begin{array}{cc} 
y_t\\
x_t\end{array}\right)
+
\left(\begin{array}{cc} 
y_t\\
a_{02}y_t+x_t
\end{array}\right)$$


Entonces $y_t$ no se ve afectada contemporáneamente por $x_t$ mientras que x depende de $a_{02}y_t$. Si consideramos que la inversión minera es más exógena que los términos de intercambio debido a que la primera depende de la demanda internacional entonces podemos asumir una estrategia como esta. Veamos cómo implementarlo en Stata.

Estimamos el SVAR con el comando svar. Este nos permite introducir restricciones de corto y largo plazo:

![image](https://user-images.githubusercontent.com/106888200/224494410-4267a0d8-87e0-418d-b3cd-35561bf001cf.png)


Para usar el comando debemos restringir los valores de las matrices A y B como lo hicimos en las ecuaciones. Para ello creamos las siguientes matrices:

```
matrix A1 = (1,0 \ .,1)

matrix B1 = (.,0 \ 0,.)
```

En A fijamos el valor del elemento superior derecho a 0 mientras que en B fijamos los valores que no están en la diagonal en 0.
Usamos ambas matrices para estimar el SVAR de la siguiente manera:

```
svar im ti, lags(1/2) aeq(A1) beq(B1)
```

Al igual que el VAR indicamos el número de rezagos. Adicionalmente usamos las opciones aeq() y beq() para usar las matrices que definimos previamente. De esta manera estimamos los parámetros:

![image](https://user-images.githubusercontent.com/106888200/224494437-09141b73-5fc0-400b-a7ed-df396cc5dc37.png)

Veamos los parámetros estimados creando matrices con los resultados recuperados:

```
matlist e(A)
matlist e(B)
```

![image](https://user-images.githubusercontent.com/106888200/224494453-4a1f3c48-9aa3-447f-8b70-55a1e1c6d614.png)

Al igual que el VAR podemos usar toda esta información para estimar las funciones de impulso-respuesta estructurales. En este luego de crear el archivo .irf usamos la opción irf graph sirf para indicar que es el IRF estructural.

```
irf create svar_irf , step(36) set(irf_2) replace

irf graph sirf, impulse(ti im) response(ti im) xtitle("Periodos") 
```

![image](https://user-images.githubusercontent.com/106888200/224494458-c275a0ab-d58e-46a0-b5e5-d803dbeca33d.png)

****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
