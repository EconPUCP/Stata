# Modelo de series de tiempo

## 1.  MODELOS ARMA

Las series de tiempo tienen peculiaridades frente a los datos de corte transversal vistos previamente. Estos son datos de una misma unidad de observación a través del tiempo: { ${y_{t},x_{t}}_{t=1}^{T}$ }

En donde t es el índice del tiempo. De este tipo de procesos se captura algo importante, los valores pasados afectan los valores presentes. Veamos un modelo simple:   

$$y_{t}=\beta_{0}+\beta_{1}x_{t}+u_{t}$$  

$$t = 1, 2,..., T.$$ 


A diferencia de un modelo de corte transversal, el supuesto de  $u^T_{t=1}$ que sea i.i.d no se sostiene. Esto debido a que se tiene autocorrelación serial. Antes de pasar a los modelos ARMA veamos un modelo simple sobre el cuál avanzar.
La serie temporal más simple se llama ruido blanco, { $e_t$ }~  i.i.d. en donde:

- E( $e_t$ )=0, ∀t
- Var( $e_t$ )= $σ^2_{e}$, ∀t

Una serie de tiempo es lineal si: $$y_{t}=u+\sum_{i=0}^{\infty}\varphi_{i}\epsilon _{t-1}$$

En donde $Ψ_0$ =1 y $e_t$  es ruido blanco. $e_t$  es la nueva información que se adquiere en t, también llamada innovación o shock. Ψ son los pesos de las innovaciones del pasado en el presente.
A partir de esta última ecuación se hace explícito que el valor de $y_t$ depende de los choques previos, así como del choque contemporáneo. Para delimitar mejor este tipo de procesos podemos plantear modelos del tipo ARMA. Veamos un poco de la teoría simple de los modelos antes de comenzar a estimarlos en el programa. 

### 5.1 AR

Los modelos AR o auto regresivos parten de asumir que las series de tiempo siguen un proceso del siguiente tipo:

AR(p): $y_t=Φ_0+Φ_1y_{t-1}+Φ_2y_{t-2}+...+Φ_py_{t-p}+e_t , t=p,p+1,...$


En donde se tiene que { $e_t$ } es una secuencia de errores de ruido blanco. Los modelos que veremos dependen del número de rezagos que consideramos. La ecuación previa indica la generalización del modelo con q rezagos. Veamos el ejemplo más simple con solo un rezago, AR(1).

 $y_t=Φ_0+Φ_1y_{t-1}+e_t , t=1,2,...$

En donde asumimos que | $Φ_1$ | < 1. Esta misma serie se puede expresar de la siguiente manera:

$$y_t=\frac{Φ_0}{1-Φ_1}+\sum_{j=0}^∞Φ^j_{1}e_{t-j}$$

Esta expresión del proceso AR(1) nos permite ver que hay una ‘memoria infinita’; es decir, un choque, $e_t$  tiene un efecto en todos los periodos posteriores.
Para entender de mejor manera este proceso encontramos sus principales momentos.


$$E[ y_t ]= \frac{Φ_0}{1-Φ_1}$$


$$Var[ y_t ]= \frac{σ^2_{e}}{1-Φ^2_{1}}$$

Ambos momentos difieren de los obtenidos en el ruido blanco. También podemos definir la función de autocovarianza y autocorrelación.

- Función de autocovarianza:

$$γ_k=Cov[y_t,y_{t-k}]=Cov[y_t,y_{t+k}]$$

- Función de autocorrelación:

$$ρ_k=\frac{γ_k}{γ_0}$$

Ambas funciones serán de utilidad al momento de modelar las series. De la misma manera, es posible obtener estos momentos a partir de la versión generalizada del AR, AR(q). Antes de hacer algunas simulaciones en Stata veamos los modelos MA y ARMA

### 5.2 MA

Los modelos de medias móviles o moving average (MA) se definen de manera distinta al modelo MA. En vez de tener el rezago de la variable dependiente ahora podemos definir el rezago solo de la perturbación:

$$MA(p): y_t=α_0+e_t+α_1e_{t-1}+α_2e_{t-2}+...+α_qe_{t-p}$$  

En donde { $e_t$ } es un ruido blanco. Como vemos, las estructura de los rezagos tiene una forma distinta. Veamos los momentos de esta serie:

$$E[ y_t ]= α_0$$


Var[ $y_t$ ]= $σ^2_{e}+α^2_{1}σ^2_{e}+α^2_{2}σ^2_{e}+α^2_{3}σ^2_{e}+...+α^2_{q}σ^2_{e}=σ^2_{e}(1+α^2_{1}+α^2_{2}+α^2_{3}+...+α^2_{q})$

Además. podemos encontrar que:

$Cov[y_t,y_{t-k}]≠0, si k≤q$


$Cov[y_t,y_{t-k}]=0, si k>q$

Consideremos un proceso MA(1):

$$y_t=α_0+e_t+α_1e_{t-1}$$  

Entonces su media y varianza sería igual a: 

$$E[ y_t ]= α_0$$


$$Var[ y_t ]= σ^2_{e}(1+α^2_{1})$$


### 5.3 ARMA

Los modelos ARMA combinan ambos procesos. El caso generalizado se define como:

$$y_t=Φ_0+\sum_{j=1}^pΦ_{j}y_{t-j}+e_t+\sum_{j=1}^qα_{j}e_{t-j}$$

En donde $e_t$  es un ruido blanco. Como vemos se tiene el conjunto de coeficientes ${Φ_{j}}^p_{j=1}$ del proceso AR y ${α_{j}}^q_{j=1}$ del proceso MA.

Hasta este punto solo hemos dado un pincelazo de toda la matemática detrás de los procesos autorregresivos y de medias móviles. Al igual que en otros temas, es necesario ahondar en la parte matemática de la mano con los temas de programación. Con esto en mente vamos a profundizar en la parte de programación de dos tópicos estadísticos; por una parte, analizaremos la presencia de estacionariedad y luego veremos cómo decidir el número de rezagos del modelo de acuerdo con los datos que queremos modelar. Antes de pasar a este diagnóstico de los modelos hagamos algunas simulaciones de los modelos vistos.

### 5.4 SIMULANDO LOS PROCESOS

En esta sección vamos a simular dos series simples bajo distintos valores de parámetros: AR(1) y MA(1), con dos objetivos. El primero es ver cómo cambian las series bajo distintos valores de parámetros. El segundo objetivo es aprender comandos nuevos. En este caso comenzaremos por definir un programa nuevo dentro de Stata, es decir un comando nuevo sobre el cuál evaluar algunos datos o parámetros. Definamos algunas condiciones previas. Ya conocemos la función de set `more off` y de `clear`.
Luego de crear el `shell` de los datos, podemos crear una función o comando nuevo que permita simular los datos. Para ello aprenderemos a usar el comando `program`. Este comando es relativamente avanzado, puesto que permite modificar y crear nuevos comandos a partir de las instrucciones que incluyamos dentro. 

Es necesario definir algunas cosas previas como:

```
*Preámbulo:

clear
set seed 1
global T=50
set obs $T
gen t=_n
tsset t
```

Veamos el siguiente programa:

```
* 	Creamos un programa para simular las series 
* Inicio del programa

capture program drop DGP
program define DGP

capture drop et 
gen et = rnormal(0,1)
gen yt$dgp =.
replace yt$dgp =1 in 1

forvalues i=2(1)$T {
quietly replace yt$dgp = $alpha0 + $alpha1 * et[`i'-1] + et[`i'] in `i'
}

end
* Fin del programa
```

Para crear el programa iniciamos con `program define` seguido por el nombre, en este caso `DGP` (DGP viene de Data Generating Process o Proceso Generador de Datos); y, termina con end. Adicionalmente escribimos una linea previa, `program drop GDP`, que nos permite eliminar el programa llamado DGP de la memoria de Stata. 

Nuestro programa usará algunos parámetros:

- `$dgp`: Será un índice que permita identificar a la serie a crear, por ejemplo, $y_{t1}$ o $y_{t2}$.
- `$T`: El tamaño de la serie.
- `$alpha0` y `$alpha1`: Son los parámetros vistos en la ecuación del MA(1).

Creamos un ruido blanco con valores entre 0 y 1 usando `gen` $e_t$  = rnormal(0,1), luego la serie que almacenará los valores, yt$gdpt. Opcionalmente reemplazamos el valor inicial de la serie por 1 para que todas partan del mismo punto. Hasta este punto tenemos un ruido blanco y una serie vacía. El siguiente loop reemplaza los valores de yt$gdpt a partir de los parámetros y $e_t$  de la siguiente manera:

$$y_t=α_0+e_t+α_1e_{t-1}$$

Para definir el rezago de la perturbación restamos una unidad a la ubicación, i, entre corchetes.
Para que el programa corra debemos definir los parámetros. Como hemos fijado estos parámetros usando $, necesitamos usar `globals` para definirlos por lo que definimos los valores de los así como los nombres que usaremos para las series `$dgp`. En este caso crearemos 5 series (dgp=1(1)5) con $α_0=1$ y $α_1=0.5$. Dado que hemos fijado la ‘semilla’ al inicio del código cada serie saldrá siempre con los mismos valores. Es decir, yt1 siempre tendrá los mismos valores, $y_{t2}$ también y así. Adicionalmente, $y_{t1}$ será distintos a $y_{t2}$.

Veamos:

```
* Proponemos algunos valores para simular las series
capture drop yt*
global phi0=1
global phi1=0.5

forvalues dgp=1(1)5 {
global dgp=`dgp'
DGP
}
*
```

Cada serie simulada sigue un proceso MA(1)

![image](https://user-images.githubusercontent.com/106888200/224458210-e9d5731c-0800-45a6-ab54-7a35b31811aa.png)

Grafiquemos las series.

```
tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("MA(1), {&alpha}{subscript:0}= $alpha0 {&alpha}{subscript:1}= $alpha1")
```

![image](https://user-images.githubusercontent.com/106888200/224458225-44263dd1-51eb-43dc-81db-839c6ae7494b.png)

Probemos aumentar el valor de $α_1$ a un número mayor.

```
capture drop yt*
global alpha0=1
global alpha1=0.95

forvalues dgp=1(1)5 {
gl dgp=`dgp'
DGP
}
*

tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("MA(1), {&alpha}{subscript:0}= $alpha0 {&alpha}{subscript:1}= $alpha1")
```

![image](https://user-images.githubusercontent.com/106888200/224458272-fe7cc2bc-c166-4482-8f06-be8bf25548d9.png)

Ahora, sigamos un procedimiento similar para simular una serie AR(1).

El procedimiento es muy similar al del MA. La principal diferencia se encuentra al momento de definir el proceso. Ahora tenemos que definir los parámetros - y la ecuación de acuerdo a un AR(1).

```
* Inicio del programa
capture program drop DGP
program define DGP

capture drop et 
gen et = rnormal(0,1)
gen yt$dgp =.
replace yt$dgp =1 in 1

forvalues i=2(1)$T {
quietly replace yt$dgp = $phi0 + $phi1 * yt$dgp[`i'-1]+et[`i'] in `i'
}

end
* Fin del programa
```

En la ecuación vemos que se usa la siguiente fórmula:

$$y_t=Φ_0+Φ_1y_{t-1}+e_t$$

Corramos algunas simulaciones:

```
* Cambiar los valores para simular las series
capture drop yt*
global phi0=1
global phi1=0.5

forvalues dgp=1(1)5 {
global dgp=`dgp'
DGP
}
*
```

![image](https://user-images.githubusercontent.com/106888200/224458318-75ca56e4-74f9-4cfe-a9b5-ba8ffad12da8.png)

Veamos qué ocurre si asumimos un $Φ_1$ = 0.99.

```
capture drop yt*
global phi0=1
global phi1=0.5

forvalues dgp=1(1)5 {
global dgp=`dgp'
DGP
}
*

tsline yt*, lcolor(gs0 gs0 gs0 gs0 gs0) lpattern(solid dash longdash dash_dot dot) ///
ttitle("") ytitle("") legend(cols(5)) title("AR(1), {&phi}{subscript:0}= $phi0 {&phi}{subscript:1}= $phi1")
```

![image](https://user-images.githubusercontent.com/106888200/224458334-2291caa8-b03c-40e7-b9c7-ea661c742509.png)

Si consideramos $Φ_1$ = 0.99 la serie empieza a diferir del comportamiento previo. En este caso, los valores empiezan a subir siguiendo una tendencia mientras que en el caso previo los valores circulan alrededor del promedio. Recordemos que el promedio es igual a E[ $y_t$ ]= $\frac{Φ_0}{1-Φ_1}$ por lo que $lim_{Φ_1→1}$ E[ $y_t$ ]=∞


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
