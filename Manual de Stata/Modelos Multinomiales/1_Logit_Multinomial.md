# Modelos Multinomiales


Recordemos que una variable nominal es aquella donde la variable tiene varias categorías, cuandos la variable dependiente es una variable nomimal con dos categorías nos encontramos ante un modelo binomial, sin embargo cuando estás variables tienen más de dos categorías, nos encontramos ante modelos multinomiales.

Los  modelos econométricos que se pueden utilizar para modelar modelos de respuesta multinomial son los siguientes:

- Logit o Probit multinomial
- Logit condicional
- Logit anidado

En este módulo nos enfocaremos en el módelo de logit multinomial. 


## 1.  LOGIT MULTINOMIAL

La variable dependiente tiene más  m  categorías, siendo $P_1$, $P_2$,..., $P_m$, las probabilidades de escoger o caer en alguna de estas categorias.

Generzalizando el caso logit, la probabilidad de que el individuo i elija la alternativa j es:


$$P_{ji}=\frac{exp(x_i\beta_j)}{1 + \sum_{k=1}^{m-1} exp(x_i\beta_k)}$$


$$P_{mi}=\frac{1}{1 + \sum_{k=1}^{m-1} exp(x_i\beta_k)}$$

$$j = 1, ..., m-1$$

- La categoría "m" es la categoría base.
- La decisión por algunas de las alternartivas depende de las características de $x_i$
- Este modelo es una generalización del modelo logit bonimial.
- En general para m alternativas se estimaran m-1 vectores de parámetros, \beta_1, \beta_2,..., \beta_{m-1}, maximizando la verosimilitud. Tomando logaritmos:

$$lnL=\sum_{i=1}^n\sum_{j=1}^m Y_{ij}lnP_{ij}$$

- Maximizando esta función se obtienen los estimadores $\hat{\beta_1}$, $\hat{\beta_2}$, ...., $\hat{\beta_{m-1}}$

Veamos un ejemplo, abriremos nuestra base de datos y con el comando `tab` podemos observar que nuestra variable dependiente toma 4 valores.

 ```
 use "base_logit_multinomial.dta"

describe 
tab dedica
tab dedica, nolabel
 ```
  
 ![image](https://user-images.githubusercontent.com/106888200/225971825-e6196cb0-78de-4db2-96a1-6e760630464c.png)

En stata hacemos uso del comando `mlogit` para estimar un modelo multinomial. Cuando se estima un modelo logit multinomial, se puede señalar a mlogit la categoría base que desea utilizar escribiendolo entre paréntesis.

 ```
 mlogit dedica sexo edad conv_cas ing_familiar, base(1)
 estimates store logit_m
 ```
 
 ![image](https://user-images.githubusercontent.com/106888200/225972713-ae490739-4a86-4f78-8170-1a6bba86a1a3.png)

El cambio de base no debería alterar las conclusiones del modelo. Solo hay que tener cuidado con la interpretación de los coeficientes nuevos. 

```
mlogit dedica sexo edad conv_cas ing_familiar, base(2)
```

![image](https://user-images.githubusercontent.com/106888200/225973813-f05aa7be-b39a-4d75-86ee-68a487cee243.png)


### 1.1 EFECTOS MARGINALES

Los efectos marginales entrega el efecto de un cambio en la variable sobre la probabilidad absoluta de caer en una de las alternativas. Los efectos marginales no se alteran si se cambian la base.

En Stata utiizaremos el comando `margins` y debemos definir sobre qué categoría calcularemos el efecto marginal. Adicional a esto, podemos seleccionar la variable de nuestro interés o si deseamos calcular los efectos marginales promedios de todas las categoría, basta con poner un asterisco "*".

```
* Estimamos los efectos marginales
estimates restore logit_m   
margins, dydx(*) pr(out(1)) 
margins, dydx(*) predict(outcome(1))
```

![image](https://user-images.githubusercontent.com/106888200/225983902-27ba75db-b80c-4806-833c-08fc879a1b01.png)


Procederemos a calcular los efectos marginales en el promedio

```
margins, dydx(*) atmeans pr(out(1))
```

Ahora consideraremos valores especificos y procedemos a graficarlos con el comando `marginsplot`.

```
*considerando valores especificos
margins, at(ing_familiar=(10000(5000)40000)) predict(outcome(2)) 
marginsplot, name(estudia, replace) title("Consideremos valores específicos")
```

![image](https://user-images.githubusercontent.com/106888200/225983230-b00642dd-889e-468d-8abf-2ad24fbcabff.png)



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA - Stata learning module  | [Getting help](https://stats.oarc.ucla.edu/stata/modules/getting-help-using-stata/ "Getting help") | Cómo obtener ayuda en Stata  |
| UCSF GSI  | [Thinking like Stata](https://www.youtube.com/watch?v=jTtIREfhyEY&t=108s&ab_channel=UCSFGSI "Thinking like Stata") | Manejar la sintaxis de los comandos en Stata  |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
