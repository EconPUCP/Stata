# Modelo de series de tiempo

## 6.  DIAGNÓSTICO DE LOS MODELOS


### 6.1 ESTACIONARIEDAD

Para poder hacer un análisis a partir de los modelos que hemos revisado necesitamos que la serie en cuestión sea estacionaria. Esta propiedad puede ser definida como estacionariedad fuerte o como estacionariedad débil. Para términos del análisis usaremos el concepto de estacionariedad débil. Este asume que:

Para un proceso ${y_t: t=1,2, …}$ con argumento segundo finito E $[y^2_{t}]$ < ∞ es débilmente estacionario si:

(I)  $E[y_{t}]$  es constante

(II) $Var[y_{t}]$ es constante

 (III) para cualquier t, h>1, $Cov[y_t; y_{t+h}]$ depende  solo  de  h  pero  no  de  t.


Esta propiedad se puede evaluar matemáticamente en distintos procesos que consideremos. De nuevo, si están interesados en el tema, deben revisar a profundidad la parte teórica de este desarrollo.

¿Cómo podemos verificar si nuestras series son estacionarias? Hay varioas consideraciones que se pueden hacer:

- Ver gráficos de funciones de autocorrelaciones y autocorrelaciones parciales, usaremos este procedimiento en la sección de selección de rezagos.
- Usar tests formales que permitan evaluar la presencia de raíz unitaria. En slides posteriores veremos los paseos aleatorios y la presencia de raíces unitarias.
- Ver si existen tendencias en los gráficos. Si una serie presenta una tendencia, entonces el promedio de esta no será constante sino que cambiará de acuerdo al cambio de los valores de la serie.
- Verificar en los datos o fuera de los datos si hay alguna presencia de cambio estructural. Un cambio estructural hace referencia a la presencia de cambios en los procesos generadores de datos subyacentes. Pensemos en situaciones inesperadas como una reforma que cambian la dinámica total de la serie.

Consideremos un proceso como el siguiente:

$$y_t=Φ_0+Φ_1y_{t-1}+e_t,  t=1,2,... e_t ~ i.i.d. (0,\sigma^2_{e}$$


A este tipo de procesos se les llama paseos aleatorios. Si lo comparamos con un proceso AR(1) tendríamos un $Φ_1$ = 1 lo que indicaría presencia de raíz unitaria. Bajo esta condición no se cumplen con los supuestos de estacionariedad débil, el promedio no es constante y la varianza tiende a infinito. 
Simulemos un modelo AR(1) con raíz unitaria.
Creamos cinco series j = 1(1)5 a partir de los ruidos blancos. Como vemos el valor de rho va a definir si la serie tiene o no raíz unitaria.

```
* Si el parámetro rho =1 se tiene raíz unitaria en la serie
forvalues j=1(1)5 {

	gen et`j'=rnormal(0,1)
	gen yt`j'=.
	replace yt`j'=et`j' in 1
	global rho=1

	forvalues i=2(1)$T {
		quietly replace yt`j'= $rho * yt`j'[`i'-1]+et`j'[`i'] in `i'
	}
}
*
```

Veamos las series que obtenemos.

```
tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("AR(1), {&rho}= $rho")
```

![image](https://user-images.githubusercontent.com/106888200/224490864-5d1a958b-4b88-4607-ae1e-20abd1d6bc4d.png)

Comparemos un AR(1) bajo distintos valores de coeficiente.

```
gen e_t=rnormal(0,1)

forvalues j=2(2)10 {

	gen y_t`j'=.
	replace y_t`j'=e_t in 1
	global rho=`j'/10

	forvalues i=2(1)$T {
		quietly replace y_t`j' = $rho * y_t`j'[`i'-1]+e_t[`i'] in `i'
	}
}
*

tsline yt*, ttitle("") ytitle("") ///
legend(order(1 "{&rho}= 0.2" 2 "{&rho}= 0.4" 3 "{&rho}= 0.6" 4 "{&rho}= 0.8" 5 "{&rho}= 1" ) ///
 cols(5)) title("AR(1)")
```

![image](https://user-images.githubusercontent.com/106888200/224490912-b8a40ba0-f961-4665-b241-061bb200513d.png)

Para implementarlo hemos seguido la misma lógica previa, pero considerando un mismo vector de valores de perturbaciones y solo cambios.

#### 6.1.1 Tests de raíz unitaria

En los datos que observamos en la realidad no es posible saber el valor de  de antemano. Por lo que podemos acercarnos a rechazar o no rechazar estadísticamente el valor a través de test. Estos test se llaman Tests de raíz unitaria. En este caso revisaremos algunos test básicos que se aplican, usualmente, a una cantidad amplia de casos. Cada test regresiona los datos de acuerdo a cierta manera y sobre esa regresión plantea una hipótesis nula.

- Test Augmented Dickey-Fuller (ADF): Considera el siguiente modelo:

$$Δy_t= α+θy_{t-1}+e_t$$

Y se considera: 

$$H_0: θ=0$$  

$$H_1: θ>0$$

- Test GLS - Augmented Dickey-Fuller (ADF-GLS): Sigue la misma formulación previa pero se detrend bajo GLS (esto significa que se retira un componente tendencial de los datos estimado por mínimos cuadrados generalizados o GLS en inglés).
- Test Phillips-Perron (PP): Estima un modelo AR simple y luego se estiman dos estadísticos $Z_ρ$ y $Z_τ$ que se comparan con una distribución propia de los autores. 

Tomemos la serie mensual de los términos de intercambio para Perú desde la página del BCRP.
Podemos comenzar a analizar la serie mirándola en un gráfico. 

```
use "Mensuales_bcrp"
tsset date

* Gráficamos para ver la serie
tsline ti, ytitle("índice (2007 = 100)") ttitle("") ///
title("Términos de Intercambio")
```

![image](https://user-images.githubusercontent.com/106888200/224490953-ae63ca22-1fba-47e6-b43e-a5fe195d0d95.png)

A primera observación podemos encontrar que hay presencia de una tendencia. Los datos siguen un patrón de subida hasta la crisis del 2008, luego rebotan a un punto más alto para posteriormente empezar a disminuir. Usemos los test sobre esta serie:
Algunos test permiten dos tipos de opciones importantes: `trend` y/o `drift`. El primero hace referencia a que se asume una tendencia determinística (esto significa que nosotros sabemos de antemano cómo aumenta esta tendencia) mientras que drift hace referencia a que la serie tiene un intercepto.
¿Cómo decidimos incluir algunas de estas opciones? Para ello vemos la serie en el gráfico. En este caso parece haber una tendencia determinística por lo que indicamos la opción trend. O Veamos los resultados de usar los tres test sobre la serie mensual de términos de intercambio:

#### 6.1.1.1 Augmented Dickey – Fuller

Para hacer un test ADF usamos el comando `dfuller` seguido por la variable a ser analizada.

```
dfuller ti, trend
```

![image](https://user-images.githubusercontent.com/106888200/224491004-90b77a4c-c054-4584-be80-ae4595985d06.png)

La hipótesis nula de este test considera que la serie tiene raíz unitaria mientras que la alternativa asume que proviene de un proceso estacionario. En este caso encontramos que el estadísticos estimado es -1.474 mientras que los puntos críticos son más negativos que este. Por lo que podemos concluir que no podemos rechazar la hipótesis nula de raíz unitaria en la serie.

#### 6.1.1.2 Phillip Perron

Para implementar el test Phillips Perron usamos el comando `pperron`. La hipótesis asume también que el proceso de los datos no es estacionario mientras que la alternativa considera que si es estacionaria.

```
pperron ti, trend
```

![image](https://user-images.githubusercontent.com/106888200/224491027-de960595-4c1e-49db-a606-e2f10ae2e14b.png)

Una diferencia entre este test y el test estándar ADF es que el test PP es robusto ante presencia de heterocedasticidad en los datos. Adicionalmente obtenemos dos estadísticos, $Z_ρ$ y $Z_τ$. De estos, podemos enfocarnos en $Z_τ$. Al igual que en el resto de los test no es posible rechazar la presencia de raíz unitaria en la serie.

#### 6.1.1.3 DF-GLS

Este test también es presentado por Elliot-Rothenberg-Stock(1996). Es una modificación al test ADF pero se incluye un detrending de los datos mediante una estimación GLS. La hipótesis nula en este caso indica la presencia de de raíz unitaria con un posible `drift` mientras que la alternativa considere una serie estacionaria con o sin tendencia.

```
dfgls ti, max(6)
```

![image](https://user-images.githubusercontent.com/106888200/224491077-ea0af4b6-50ef-4e80-9d49-1ed30e7edf70.png)

Para implementar el test usamos el comando `dfgls`. La serie, por default, considera la presencia de una tendencia. Si no queremos considerar esto usamos la opción notrend. Adicionalmente, debemos seleccionar un número de rezagos máximos a considerar. En este caso, no es posible rechazar la hipótesis nula en ningún caso.
Luego de verificar que hay cierta evidencia a favor de que la serie tiene raíz unitaria podemos tomar una estrategia simple para transformar nuestra serie en estacionaria, tomar la primera diferencia o la tasa de crecimiento. En este caso, vamos a crear una variable nueva igual a la tasa de crecimiento mes a mes.

```
gen ti_g = (ti - l12.ti)/l12.ti

tsline ti_g, ytitle("%") title("") ttitle("") ///
title("Tasa de Crecimiento - Términos de Intercambio")
```

![image](https://user-images.githubusercontent.com/106888200/224491111-85c755eb-d585-4629-8182-96c5d3d502a5.png)

A primera vista, la serie parece no tener tendencia. Tomemos los test sobre esta serie.
En este caso ya no consideramos la opción `trend`

```
dfuller ti_g
pperron ti_g
dfgls ti_g, max(6)
```

![image](https://user-images.githubusercontent.com/106888200/224491193-56886a12-adc4-454d-aaaa-e7c73db3fc47.png)

Ambos test concluyen en los mismo, la serie de la tasa de crecimiento de los términos de intercambio no presenta raíz unitaria. Ahora que ya sabemos identificar a una serie estacionaria vamos a ver como seleccionar el número de rezagos a usar al momento de modelar los datos.

### 6.2 SELECCIÓN DE REZAGOS

Luego de confirmar la estacionariedad vamos a seguir con la metodología de Box Jenkins para seleccionar el modelo. Para ello podemos seguir el siguiente orden:

- Identificar los posibles rezagos. Para ello usamos las funciones de autocorrelación y autocorrelación parcial.
- Estimar los modelos
- Seleccionar el rezago con menor valor de criterio de información 
- Verificar que los residuos estimados tengan una distirbución i.i.d.

Para analizar la autocorrelación y autocorrelación parcial (AC y PAC, en inglés) usamos los comandos `ac` y `pac`, los cuales generan un gráfico de los estadísticos. También podemos usar el comando `corrgram` para tener un resultado no gráfico. En esta etapa se buscan ciertos comportamientos. Veamos un cuadro resumen:

![image](https://user-images.githubusercontent.com/106888200/224491217-efb0c476-efc2-4563-a675-9b375e0643d9.png)

De esta manera tenemos cierta idea de cómo seleccionar el número de rezagos p para la parte autorregresiva y q para la parte de media móvil. Veamos un ejemplo aplicando los comandos y esta primera parte de la metodología para los datos de términos de intercambio.
De estos gráficos encontramos que hay una caída consecutiva en la función de autocorrelación, signo ser una función AR. A partir de la autocorrelación parcial tenemos una serie de picos que nos indicarían los rezagos a usar.

```
ac ti_g, title("Autocorrelación")
pac ti_g, title("Autocorrelación Parcial")
```

![image](https://user-images.githubusercontent.com/106888200/224491238-a105c38a-7e9f-42d2-be05-f10546ba2c01.png)

Para interpretar los picos en la PAC debemos ver qué picos están por encima de la zona sombreada. Esto significa que son significativos. Para ver las posiciones exactas así como otro conjunto de información podemos usar el comando `corrgram`. Veamos:

Este comando nos permite ampliar los resultados del gráfico. Las primeras columnas hacen referencia a los valores de AC y PAC mientras que las últimas columnas presenta una forma resumida de los gráficos previos.

```
corrgram ti_g
```

![image](https://user-images.githubusercontent.com/106888200/224491261-02ccc9e6-c089-47cd-837f-3e04d2264deb.png)

Entonces, tendríamos un proceso AR con posibles rezagos en 1, 3, 6, 7,12, 13 y 25 (el resto de rezagos se muestra en el resultado completo de Stata). Ahora pasemos a estimar los modelos.
Para estimar los modelos usaremos el comando arima. Este comando nos permite seleccionar el número de rezagos que usaremos tanto para la parte AR como para la parte MA. Cómo veran se usa ARIMA en vez de ARMA, esto debido a que se deja la posibilidad de definir un parámetro adicional para los procesos autorregresivos integrados de medias móviles. Este elemento intermedio, I, será dejado de lado ya que es parte de temas más avanzados en series de tiempo. 

![image](https://user-images.githubusercontent.com/106888200/224491312-435346fe-0354-4ecd-85f6-511e99ae033f.png)

Luego de estimar los modelos, necesitamos recuperar los criterios de información con el comando `estat ic` en la línea posterior a la estimación.
En esta parte tenemos que repetir los códigos para distintas combinaciones de rezagos. Para almacenar los criterios de información de manera adecuada podemos crear una matriz previamente. En este caso almacenaremos los resultados de siete modelos. Comenzando con el modelo más simple de solo 1 rezago, aumentando de una a uno hasta tener los rezagos 1, 3, 6, 7, 12, 13 y 25.

```
matrix CritInfor = J(2,7,.) 
matrix colnames CritInfor = Modelo1 Modelo2 Modelo3 Modelo4 Modelo5 Modelo6 Modelo7
matrix rownames CritInfor = AIC BIC
```

Para crear una matriz tenemos que usar el comando `matrix` seguido por el nombre que queremos usar, por ejemplo, CritInfor. Para definir que sea una matriz vacía usamos J(2,7,.). El primer valor define el número de filas mientras que el segundo, el número de columnas. Por último, se define que se componga de missing values, ..
Adicionalmente podemos editar el nombre de las filas y columnas con `matrix colnames` y `matrix rownames`. Podemos ver la matriz usando `matrix list` CritInfor:

![image](https://user-images.githubusercontent.com/106888200/224491387-30e3c09f-9b89-4b0a-9ab8-d65f4222ce53.png)

Estimemos el primero modelo, AR(1), usando el comando arima seguido por la(s) variables(s) a usar. En este caso, definimos ar(1) para seleccionar solo el rezago 1. Veamos el resultado.

```
arima ti_g, ar(1)
```

![image](https://user-images.githubusercontent.com/106888200/224491363-09f73746-40d5-4d7e-a016-131e9640c11e.png)

Este resultado se parece a los que ya hemos visto previamente. Se presentan los resultados de la log verosimilitud estimada para cada iteración. Luego, algunos datos adicionales relacionados con el número de observaciones, las fechas y el contraste conjunto del modelo.
En la siguiente parte encontramos los estimadores de la constante y del rezago, _cons y L1.ar, respectivamente. Luego de estimar el modelo generamos los criterios de información ACI y BIC con el comando `estat ic`:

```
estat ic
```

![image](https://user-images.githubusercontent.com/106888200/224491406-f42e3a3b-727d-4612-8fbf-e0e978077284.png)

Si revisamos las opciones de post-estimation de este comando encontraremos que podemos recuperar los resultados para AIC y BIC en la matriz r(S). Veamos cómo manejamos estos datos.
Luego de correr el AR(1) y generar los criterios de información recuperamos la matriz r(s) creando una nueva matriz.

```
arima ti_g, ar(1) // solo rezago 1
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,1] = aic 
matrix CritInfor[2,1] = bic
```

A partir de la nueva matrix ic creamos dos valores escalares para el AIC y BIC. Para ello, indicamos la posición de cada valor. El AIC se encuentra en la posición 1×5 de la matriz mientras que el BIC se encuentra en la siguiente posición 1×6. Luego reemplazamos los espacios 1×1 y 1×2 de la matriz de criterios de información con los dos nuevos valores.
Debemos de repetir este procedimiento para todos los modelos que consideremos.
Repetimos el bloque de códigos pero cambiando la ubicación en donde vamos a guardar los datos de la matriz. Por ejemplo, para el caso AR(1 3) guardamos en la ubicación 1 × 2 y 2 × 1. En este caso, solo estamos usando el proceso AR pero también podemos comparar un modelo ARMA(1,1) a modo de benchmark para el resto de modelos.
Luego de correr todos los bloques de códigos, visualizamos los datos usando `matrix list` CritInfor.

```
arima ti_g, ar(1) // solo rezago 1
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,1] = aic 
matrix CritInfor[2,1] = bic

arima ti_g, ar(1 3) // Rezago 1 y 3
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,2] = aic 
matrix CritInfor[2,2] = bic

arima ti_g, ar(1 3 6) // Rezago 1, 3 y 6
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,3] = aic 
matrix CritInfor[2,3] = bic

arima ti_g, ar(1 3 6 7) // Rezago 1, 3, 6 y 7
estat ic
matrix ic = r(S)
scalar aic = ic[1,5]
scalar bic = ic[1,6]
matrix CritInfor[1,4] = aic 
matrix CritInfor[2,4] = bic
```

La regla para decidir el modelo es seleccionar aquel con menor valor para el criterio de información. Si consideramos el AIC entonces seleccionaremos el Modelo 6, AR(1 3 6 7 12 13).

![image](https://user-images.githubusercontent.com/106888200/224491434-8ddda4d8-3c7d-4b19-9d34-b29f24065b90.png)

También podemos estimar los modelos considerando solo rezagos en cada periodo, es decir AR(1), AR(3), etc.

![image](https://user-images.githubusercontent.com/106888200/224491544-7063ae2b-6313-4c3c-b1af-d052f5f6a416.png)

A partir de esta última tabla seleccionamos AR(1) frente al resto. Mientras que en la primera tabla seleccionamos AR(1 3 6 7 12 13) frente a AR(1). Entonces, aquella última es la tabla final.
Luego de estimar el modelo debemos revisar si los errores estimados se distribuyen como una normal mediante un histograma y algún test de normalidad. Hagamos un gráfico del histograma.

```
arima ti_g, ar(1 3 6 7 12 13) // Rezago 1, 2, 6, 7, 12 y 13
predict e , resid // residuos estimados
hist e, kdensity kdenopt(lcolor(blue)) normal normopt(lcolor(red))
swilk e
```

![image](https://user-images.githubusercontent.com/106888200/224491610-d86f8790-c69d-4864-853d-b72b1f0939ba.png)

El gráfico nos indica que no hay una gran diferencia entre el histograma y la distribución normal. Para un análisis numérico podemos usar el estadístico de Shapiro Wilk para testear la normalidad con el comando `swilk`. En este caso la nula indica que se distribuye como normal. Encontramos que no es posible rechazarla por lo que nuestros errores serían normales.

![image](https://user-images.githubusercontent.com/106888200/224491638-20ce4546-baa4-411c-99c5-52bddb540d23.png)

Con esto hemos modelado, bajo ciertos criterios, a la serie de tasa de crecimiento de los términos de intercambio. A partir de esto podemos pronosticar los valores de las series.

****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
