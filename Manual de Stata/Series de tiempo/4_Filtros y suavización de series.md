# Modelo de series de tiempo

## 4  FILTROS Y SUAVIZACIÓN DE SERIES


El concepto de filtro proviene de la literatura de la ingeniería. La idea es tomar como insumo una serie (o una señal) y procesarla considerando los valores rezagados para generar una nueva serie, es decir una serie filtrada. Consideremos la siguiente ecuación:

$$y_t=ψ(L)x_t$$

En donde $ψ(L)$ es una función que considera los rezagos (L) de la serie insumo, $x_t$, para generar una serie output, $y_t$. Esta operación puede ser muy compleja y suponer operaciones matriciales avanzadas o ser mucho más simple como sacar los promedio de los valores rezagados. Vamos a ver dos conjuntos de filtros. Primeros los llamados moving average y luego una colección de filtros más complejos.

### 4.1 FILTROS MOVING - AVERAGE, TSSMOOTH

Los filtros _moving average_ tienen la siguiente forma:


$$\hat{x_t}=\frac{\\sum_{i=-l}^f w_{i}x_{t+i}}{\sum_{i=-l}^{f} w_{i}}$$


En donde $x_t$ es la serie nueva, wi son pesos para cada observación y $x_t$ es la serie input. Los valores f y l indican el número de rezagos a considerar a la derecha y a la izquierda. Si no tenemos ponderadores el filtro solo toma un promedio simple de los datos, por ejemplo: 

![image](https://user-images.githubusercontent.com/106888200/224391996-14ba928e-bf67-4337-b91e-c1dd33ec1620.png)

Consideremos que tomamos un moving average de cinco periodo, es decir, dos periodos previos, el periodo actual y dos periodos posteriores:

![image](https://user-images.githubusercontent.com/106888200/224392022-0c698a58-44ee-46a9-a051-ce223ca1aaee.png)

Para implementar el moving average usamos el comando `tssmooth ma` seguido por la variable. Adicionalmente debemos indicar los valor l y f de la ecuación vista previamente. Para eso usamos la opción window(#l,#c,#f) en donde _#l indica el número de rezagos hacia atrás, #c se reemplaza por 1 cuando se quiere considerar el valor actual y 0 en caso contrario, #f indica los adelantos a considerar_. Usemos esta función para crear la serie moving average de cada componente del consumo considerando una ventana de 5 periodos.

```
use "pbi_trimestre", clear
tsset trimestre

* Moving average

tssmooth ma PBI_ma = PBI, window(2 1 2)
tssmooth ma C_ma   = C  , window(2 1 2)
tssmooth ma I_ma   = I  , window(2 1 2)
tssmooth ma G_ma   = G  , window(2 1 2)
tssmooth ma XN_ma  = XN , window(2 1 2)
```

Comparemos la serie original con la serie nueva

```
tsline PBI_ma PBI if tin(1995q1,2015q1), xtitle("") ///
legend(order(1 "Series Filtrada" 2 "Series Original") cols(2)) ///
tlabel(1995q1(8)2015q1, labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)
```

![image](https://user-images.githubusercontent.com/106888200/224392762-b6c81757-6533-40fa-a0b4-d1365639588c.png)

La serie con línea punteada indica los valores reales en cada trimestre mientras que la serie sólida indica la nueva serie moving average. Como se observa en el gráfico, el filtro ‘suaviza’ los valores de la serie.

### 4.2 OTROS FILTROS, TSFILTER

Ahora veamos otro conjuntos de filtros disponibles en Stata bajo el comando tsfilter:

- tsfilter hp para el filtro Hodrick - Prescott
- tsfilter bk para el filtro Baxter - King
- tsfilter cf para el filtro Christiano - Fitzgerald
- tsfilter bw para el filtro Butterworth

A diferencia del moving average, estos filtros generan por lo menos dos series nuevas, usualmente se identifica a estos componentes como ciclo y tendencia. Veamos cada filtro por separado y luego comparemos los resultados.

#### 4.2.1 tsfilter hp

El filtro Hodrick-Prescott o filtro HP es un filtro bastante usado en la literatura (también bastante criticado, por ejemplo, en Hamilton). Este filtro sigue la siguiente ecuación:

$$x_t=z_t+τ_t$$

En donde a partir de xt, la serie inicial, se crean dos series nuevas: una tendencia, τt, y una residuo o ciclo, zt. Para obtener estos componentes de minimiza la siguiente función con respecto a $τ_t$

$$\sum_{t=1}^T[(x_t-τ_t)^2+λ((τ_{t+1}-τ_t)-(t_t-t_{t-1})]$$


En donde λ indica un parámetro de suavizamiento a seleccionar de acuerdo a la frecuencia de los datos. Usualmente se considera λ = 1600 para datos trimestrales, λ = 129600 para datos mensuales y λ = 6.25 para datos anuales.
Vamos a descomponer o filtrar la serie trimestral del PBI en dos partes: un ciclo (o componente residual) y una tendencia. 

```
tsfilter hp PBI_ciclo = PBI, trend(PBI_tendencia) smooth(1600)
```

En este caso debemos indicar el nuevo nombre del componente, en este caso PBI_ciclo, y la serie de la cuál se extraerá, PBI. También debemos indicar el valor que tomará el parámetro λ, en este caso 1600, y si queremos que se cree una nueva variable con el componente tendencial, trend(PBI_tendencia). Esta rutina generará dos nuevas variables:
PBI_ciclo y PBI_tendencia. Grafiquémoslas

```
tsline PBI_tendencia PBI, xtitle("") ///
legend(order(1 "Tendencia del PBI" 2 "PBI") cols(2)) ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)
```

![image](https://user-images.githubusercontent.com/106888200/224393518-c8d9a651-4daa-4cff-b101-83a84382bc3c.png)

Como vemos, el componente tendencial no tiene los picos y valles presentes en la serie inicial.

```
tsline PBI_ciclo, xtitle("") ytitle("") title("Ciclo del PBI") ///
tlabel(1990q1(8)2019q1, grid labsize(*0.7)) lcolor(gs0 gs0) lpattern(solid -)
```

![image](https://user-images.githubusercontent.com/106888200/224393606-bb504bda-a79e-4396-be54-ac517fd65de3.png)

La serie del ciclo o el residuo es igual a la resta de las series previas. Recordemos que 

$$x_t=z_t-τ_t$$

#### 4.2.2 tsfilter bk

En contraste al filtro HP, el filtro Baxter - King (BK) es un filtro de pase de banda (particualrmente, de highpass). La definición estadística exacta del filtro supero los límites del curso. A pesar de esto, podemos establecer algunos criterios para poder usar la serie dado que hay varios componentes que se deben elegir. El comando tiene la siguiente forma 

```
tsfilter bk PBI_ciclo_bk = PBI , minperiod(6) maxperiod(32) ///
trend(PBI_tendencia_bk)
```

Al igual que el filtro HP debemos de indicar el nombre de la serie ciclo y de la serie tendencia. Adicionalmente, debemos indicar algunos componentes nuevos. En este caso `minperiod()` y `maxperiod()`. Ambos son parámetros que hacen referencia a la extensión de los ciclos considerados. Los valores introducidos son los propuestos para datos trimestrales de acuerdo a Baxter y King. Ahora, este filtro requiere hacer una revisión teórica previa para poder entender exactamente su procedimiento por lo que les recomiendo (si están bastante interesados en el tema) revisar un libro de econometría de series de tiempo. El resto de filtros también van a introducir nuevos conceptos estadísticos que requieren de un estudio previo, Ojo con esto.
Veamos las nuevas series generadas. 

![image](https://user-images.githubusercontent.com/106888200/224418775-223c98ac-7e6c-4daa-99a1-054f3d499a59.png)

A diferencia del filtrado HP, la tendencia estimada es mucho menos suave. Esto también se refleja en el componente cíclico.

En este caso, el ciclo aparece menos volátil que en el caso HP.

![image](https://user-images.githubusercontent.com/106888200/224418855-f3daa034-9240-4af9-9dca-71cd0b2da7d8.png)

Otra diferencia se encuentra en que al usar el filtro BK eliminamos observaciones de los extremos.

#### 4.2.2 tsfilter cf

El filtro Christiano-Fitzgerald también es un filtro de pase de banda con un procedimiento distinto a los filtros previos.

```
tsfilter cf PBI_ciclo_cf = PBI , minperiod(6) maxperiod(32) ///
trend(PBI_tendencia_cf)
```

Los argumentos son similares a los de Baxter-King, se puede seleccionar los periodos mínimos y máximos así como el número de observaciones que contribuyen al filtro con `smaorder()`. De nuevo, para mayor comprensión de la parte netamente estadística del filtro se debe revisar algún libro de econometría de series de tiempo. Veamos las series que se construyen.

![image](https://user-images.githubusercontent.com/106888200/224419030-d47caf71-463b-47da-9d7c-5f5351a5d7a2.png)

#### 4.2.2 tsfilter bw

Por último, el filtro Butterworth es una opción adicional que tiene el comando tsfilter. No es tan usado como el resto de las opciones. 

![image](https://user-images.githubusercontent.com/106888200/224419312-78c4559a-10ea-4886-84a7-0f12b97495bb.png)

Si comparamos las series generadas, la tendencia es más suavizada y el ciclo más volátil Hay más opciones de filtro de series, algunas más complejos como el filtro de Kalman u otros más simples en adaptar a stata como el filtro de Hamilton (`ssc install hamiltonfilter`).

## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
