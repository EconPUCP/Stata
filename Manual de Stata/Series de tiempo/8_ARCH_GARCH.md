# Modelo de series de tiempo

## 8.  MODELOS ARCH Y GARCH


Veamos un poco de teoría antes de pasar a los códigos. Los modelos ARCH surgen de la necesidad de condicionar los procesos autoregresivos a la presencia de heterocedasticidad. Así, surge el modelo autorregresivo con heterocedasticidad condicional. Partamos de un modelo simple:

$$y_t=\beta_0+\beta_1z_t+u_t$$

En un modelo como este podemos asumir que la varianza de la perturbación es constante:

$$Var(u_t)=\sigma^2$$

Incluso cuando se cumple esta condición podemos encontrar que la varianza de la perturbación condicional a perturbaciones pasadas no es constante. Veamos el siguiente caso:

$$Var(u_t|u_{t-1},u_{t-1},...)=E[u_{t-1},u_{t-1},...]=E[u_{t-1}]$$

Este último término se puede modelar como un proceso autorregresivo:

$$E[u_{t-1}]=h_t=\alpha_0+\alpha_1u^2_{t-1}$$

En donde:

$$u_t=\sqrt{h_tv_t}$$

El número de rezagos de $u^2_{t}$ indica el orden del ARCH. Para que la varianza sea positiva se necesita que $\alpha_0>0$ y que $\alpha_1>0$  (Recordemos que la varianza es un valor al cuadrado). 
Este modelo nos indica que la varianza puede tener autocorrelación mientras que el término de perturbación no necesariamente. La generalización de este modelo es llamado GARCH. La siguiente ecuación presenta un proceso GARCH(1,1):

$$h_t=\alpha_0+\alpha_1u^2_{t}+\gamma_1h_{t-1}$$

Este proceso se asemeja al visto en el modelo ARMA. Ahora ![]() y ![]() tiene ambos rezagos.

Modelar la varianza de esta manera es relevante cuando estamos ante series financieras en donde la volatilidad brinda información relevante. Podemos testear la presencia de estos ‘efectos GARCH’ sobre una serie usando el comando estat archlm. 

Para ello puedes descargar la serie del Índice General Bursátil desde el 01/01/2010 hasta el 31/12/2019 desde la página del BCRP y limpiamos la base de datos, o descargarla directamente de nuestra base de datos lista para usar.

Esta serie financiera no tiene datos para todos los días puesto que hay días no laborables. Podemos ignorar este problema y crear una variable adicional que se una tendencia completa. A partir de este índice podemos calcular una proxy del retorno día a día de la bolsa tomando la tasa de crecimiento del índice. Veamos el gráfico del índice y de la proxy de retorno:

```
tsline igb, ttitle("Periodos, 0 = 01Ene2010") ytitle("") title("Índice General Bursatil")
```

![image](https://user-images.githubusercontent.com/106888200/224493318-4abf0df7-b39c-4643-ba7a-9439bb006fb0.png)

Si vemos la serie de retornos:

```
gen retorno=(igb - l.igb)/l.igb

tsline retorno, ttitle("Periodos, 0 = 01Ene2010") ytitle("%") title("Tasa de Crecimiento Índice General Bursatil")
```

![image](https://user-images.githubusercontent.com/106888200/224493332-a0c18afd-0930-45fb-a409-1c0e10837db4.png)

Claramente no hay una tendencia en la serie de retorno. Esto es esperable puesto que las ganancias y pérdidas no pueden durar permanentemente por lo regresan a la media, 0. Si corremos un test ADF para ver presencia de raíz unitaria encontramos que rechazamos la nula.

```
dfuller retorno
```

![image](https://user-images.githubusercontent.com/106888200/224493370-563dc8f7-6472-424a-9711-7956845257df.png)

Las funciones AC y PAC no parecen indicar un proceso claro:

```
ac retorno
pac retorno
```

![image](https://user-images.githubusercontent.com/106888200/224493388-7a29a9a6-5b59-485e-96e7-53bdf4802887.png)

![image](https://user-images.githubusercontent.com/106888200/224493402-5a6619cf-86d3-4c72-8406-c20f870f07cd.png)


Podemos usar un comando adicional que nos permite comparar procesos solo usando AR(), varsoc. Luego vemos el número de rezagos seleccionado con *. En este caso 1.

```
varsoc retorno
```

![image](https://user-images.githubusercontent.com/106888200/224493435-dbc9fcf7-e783-4917-9220-450e7144f809.png)

Para analizar la presencia de efectos ARCH en la serie debemos estimar el modelo por OLS. En este caso lo estimamos contra una constante dado que no hay variables explicativas adicionales. Luego usamos el comando `estat archlm` seguido por la opción de número de rezagos considerados para el test. En este caso indicamos solo 1.

```
* Verificamos si hay efectos ARCH
reg retorno 

estat archlm, lags(1)
```

El test nos arroja lo siguiente: 

![image](https://user-images.githubusercontent.com/106888200/224493458-b352c1ea-554b-4e9b-bc5e-187b10ba7bda.png)

Por lo que rechazamos la no presencia de efectos ARCH.
Luego de tener cierta evidencia de que la serie tiene efectos ‘ARCH’, estimamos el modelo usando el comando `arch`. En este no vamos a usar un criterio como el de Box Jenkins para definir el número de rezagos. En cambio, partiremos de comparar solo un ARCH(1) y un GARCH(1,1). Veamos el resultado de estimar un ARCH(1):

```
arch retorno, arch(1)
```

![image](https://user-images.githubusercontent.com/106888200/224493485-5b1d23cf-7d8a-4a29-8738-6d1b03133dcb.png)

Así, obtenemos los valores de la regresión inicial y de la regresión de la varianza estimada. Es decir, $\alpha_0$ = 0.000081 mientras que $\alpha_1$ = 0.3598. La constante de la ecuación inicial es, también, es promedio de los datos.
Estimemos el GARCH(1,1) usando el mismo comando pero con otras opciones. Arch retorno, arch(1) garch(1)

```
arch retorno, arch(1) garch(1)
```

![image](https://user-images.githubusercontent.com/106888200/224493513-bd8697a7-67a2-49e5-88a2-15f397ae8419.png)

Para obtener el valor estimado de la varianza bajo ambos modelos usamos el comando `predict` seguido del nombre y, en este caso, de la opción variance. Veamos un gráfico de esta varianza estimadas.

```
predict htgarch, variance
 
tsline htgarch, ttitle("Periodos, 0=01Ene2010") ytitle("") title("Varianza estimada, GARCH(1,1)")
```

![image](https://user-images.githubusercontent.com/106888200/224493547-8d282d2b-72d5-45fd-b872-4b9d65cdd038.png)

Stata nos permite estimar no solo estos modelos ARCH básicos sino toda una familia extensa de modelos similares. Veamos en `help arch`

![image](https://user-images.githubusercontent.com/106888200/224493577-e047f6dd-1caa-4abf-b1e2-acd2528ffcc0.png)

Cada extensión particular tiene una teoría detrás que permite entender los resultados, los supuestos detrás y sus limitaciones por lo que es necesario ahondar en estos si se es de interés.




****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
