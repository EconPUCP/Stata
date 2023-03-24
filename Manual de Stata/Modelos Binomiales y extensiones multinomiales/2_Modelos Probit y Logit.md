# MODELOS DE PROBABILIDAD NO LINEAL

Cuando la variable dependiente toma dos valores, típicamente 1 y 0. La estimación de un modelo con esta característica empleando la metodología MCO convencional se conoce como el modelo de probabilidad lineal, sin embargo su estimación presenta los siguientes problemas:

- Predicciones fuera de muestra (nada garantiza que las predicciones del modelo se encuentren en el intervalo de 0 a 1)
- La perturbación aleatoria no sigue una distribución normal
- Presencia de problema de heterocedasticidad

Caminos alternativos que superan los problemas anteriores se basan en estimaciones no lineales bajo la metodología de máxima verosimilitud. 

### 2 PROBIT Y LOGIT

Los modelos tipo probit y logit asumen que el término de error aleatorio siguen una distribución normal y logística respectivamente, para su estimación se usan los comandos `probit` y `logit` respectivamente. 

Trabajaremos con la base de datos de Hosmer & Lemeshow que se encuentra en la memoria del propio stata, utilizando el comando `syuse` para abrirlo. Procederemos a estimar los modelos logit y probit para luego compararlos en una tabla haciendo uso del comando `esttab`.


```
clear all
sysuse lbw 

**********

logit low age lwt i.race smoke ht, robust // Logit
est store logit

probit low age lwt i.race smoke ht, robust // Probit
est store probit

esttab logit probit, mtitle("Logit" "Probit") pr2
```

![image](https://user-images.githubusercontent.com/106888200/225504213-32942ff9-4594-44f7-97ed-b4da83cdfbcc.png)


#### 2.1. Efecto marginal

En ambos modelos el efecto marginal depende de todas las variables así como de la propia función de densidad f (·) por lo que no existe un único efecto marginal. Un par de opciones para encontrar un efecto marginal pueden ser:

- Estimar el efecto marginal en el promedio de las variables con el comando `margins` y colocando al final post atmeans.

```
estimates restore logit
margins, dydx(*) post atmeans
est store em_logit_mean

estimates restore probit
margins, dydx(*) post atmeans
est store em_probit_mean

esttab em_logit_mean em_probit_mean , mtitle("Logit" "Probit") title("Efectos marginal en los promedios de las variables") p 
```

![image](https://user-images.githubusercontent.com/106888200/225517793-5c8c70b5-f7de-48cc-b11f-69d658497aa8.png)

- Estimar el efecto marginal promedio `margins` y colocando al final post. 

```
estimates restore logit
margins, dydx(*) post
est store em_logit

estimates restore probit
margins, dydx(*) post 
est store em_probit

esttab em_logit em_probit , mtitle("Logit" "Probit") title("Efectos marginal promedio") p 
```

![image](https://user-images.githubusercontent.com/106888200/225517926-b12d1751-fad6-439e-9a7e-095cec2babe6.png)


> **TIPS: Comparando los efectos marginales**
>
> Para comparar los resultados del Logit y el probit, usamos "los efectos marginales en los promedios" pero si queremos comparar el resultado del logit, probit y MPL se compara con "los efectos marginales promedios".
>




#### 2.2 ODDS Y RATIO ODDS

El estadístico odds mide el cociente de probabilidades para una observación i de elegir la opción 1 frente a la opción 0; es decir
 
$$odds=\frac{P_i}{1-P_0}$$

De este modo, si la ratio odds es
• mayor que 1: es alta la probabilidad de que ocurra el evento.
• menor que 1: es baja la probabilidad de que ocurra el evento.

Se utiliza el comando `or`, veamos el ejemplo:

```
logit low age lwt i.race smoke ht, or
```

#### 2.3 CRITERIOS DE SELECCIÓN SEGÚN LA BONDAD DE AJUSTE

los criterios de selección según bondad de ajuste son: 

1. Porcentaje de predicciones correctas, su exito dependerá de qué tan bien balanceada esté la muestra.
2. Criterio de Akaike, la estimación que tenga menor AIC, es la que tiene mejor ajuste.
3. Ratio de verosimilitud o Pseudo $R^2$, el modelo que tenga mayor LR tiene mejor ajuste.

Para poder visualizar estos criterios de selección, previamente de sebe instalar el comando `fitstat`, seguido se deben correr las regresiones y guardar sus resultados de bondad de ajuste:

```
qui: estimates restore probit
quietly fitstat, saving(prob)

qui: estimates restore logit
quietly fitstat, saving(log)

fitstat, using(prob) force
```

![image](https://user-images.githubusercontent.com/106888200/225520865-8c09fea8-9bc8-4f53-980a-8b9c2aac5251.png)



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA   | [Stata data analysis examples](https://stats.oarc.ucla.edu/stata/dae/probit-regression/ "Stata data analysis examples") | Regressión Probit |
| UCLA   | [Stata data analysis examples](https://stats.oarc.ucla.edu/stata/dae/logistic-regression/ "Stata data analysis examples") | Regresión Logistica |
| Luis García Núñez   | [Logit - Probit](https://www.youtube.com/watch?v=NMCgoDYLrsI&t=3s "Logit - Probit") | Ejemplo de estimación logit probit en un modelo de dos variables usando Stata |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20Binomiales%20y%20extensiones%20multinomiales/2_Modelo_probabilidad_no_lineal.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data "base de datos")*   
