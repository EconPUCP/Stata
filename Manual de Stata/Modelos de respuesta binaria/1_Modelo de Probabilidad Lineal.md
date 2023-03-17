# MODELO DE RESPUESTA BINARIA


La variable dependiente de las regresiones no solo pueden ser variables continuas, también pueden tomar valores discretos.
Una variable es discreta cuando está formada por un número finito de alternativas que miden cualidades. Esta característica exige la codificación como paso previo a la modelización, proceso por el cual las alternativas de las variables se transforman en códigos o valores cuantitativos, susceptibles de ser operados econométricamente.

Modelar este tipo de variables define el nombre de modelos de elección discreta, dentro de la cual existe una amplia tipología de modelos.

- Según el número de alternativas incluidas en la variable endógena, hablamos de
     - Modelos de respuesta dicotómica
     - Modelos de respuesta o elección múltiple
- Según la función utilizada para la estimación de la probabilidad:
     - Modelo de probabilidad lineal truncado
     - Modelo Logit
     - Modelo Probit
- Según que las alternativas de la variable endógena sean excluyentes o incorporen información
ordinal
     - Modelos con datos no ordenados
     - Modelos con datos ordenados

En los modelos binarios, la variable dependiente toma dos valores de la siguiente manera:

$Y_i$ = 1 con probabilidad p

$Y_i$ = 0 con probabilidad 1-p

En donde 1 indica la ocurrencia del evento y 0 la no ocurrencia del evento. Su distribución incondicional está dada por:

$E(Y) = Pr(Y=1)=p$

$V(Y) = p(1-p)$

Mientras que la distribución condicional está dada por:

$E(Y |X = x) = Pr(Y = 1|X = x) = p(x)$

El último término, p(x) es clave para diferenciar los modelos usados a continuación.

### 1.1 MODELO DE PROBABILIDAD LINEAL

El MPL asume el siguiente modelo:

$E(Y = 1|X = x) = p(x) = \beta_0 + \beta_1x$

Al estimar por MPL genera una probabilidad. 

#### 1.1.1 Estimación MPL

Iniciaremos abriendo nuestra base de datos que se encuentra en la memoria del Stata, para la cual utilizaremos el comando `syuse`.

```
*Preámbulo
clear all
sysuse lbw 
```

Pasaremos a examinar a nuestras variable con el comando `describe` y con el comando `tab` observaremos los valores que toma nuestra variable low.

![image](https://user-images.githubusercontent.com/106888200/225457658-500e4fe3-6e24-4e92-bb24-b312e053dd09.png)

Para estimar nuestro modelo por probabiliad lineal usamosmos el comando `reg`, observemos que "race" es una variable categorica por lo cual la escribirmos con el prefijo "i" para evitar problemas de multicolinealidad. 

```
reg low age lwt i.race smoke ht 
est store mpl_1
```

![image](https://user-images.githubusercontent.com/106888200/225461813-9d7743ae-e9c4-4af0-89a4-e668287e3444.png)

#### 1.1.2. Limitaciones

- Heterocedasticidad: por construcción el modelo no tiene varianza constante.

$e_i$ cuando $Y_i$=1 → $e_i=1-X´\beta$
$e_i$ cuando $Y_i$=0 → $e_i=-X´\beta$

$Var(e_i)=P_i(1-P_i)$

Sin embargo podemos solucionar este problema con los errores robustos.

```
reg low age lwt i.race smoke ht, robust  //
est store mpl_2

*comparando los resultados
esttab mpl_1 mpl_2, nomtitle r2 p
```

![image](https://user-images.githubusercontent.com/106888200/225461983-88c23392-2a6d-4af9-a023-b9b4e30b07c4.png)

- Los valores de E(Y |X = x) no están restringidos a estar comprendidos entre 1 y 0.



## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA - Stata learning module  | [Getting help](https://stats.oarc.ucla.edu/stata/modules/getting-help-using-stata/ "Getting help") | Cómo obtener ayuda en Stata  |
| UCSF GSI  | [Thinking like Stata](https://www.youtube.com/watch?v=jTtIREfhyEY&t=108s&ab_channel=UCSFGSI "Thinking like Stata") | Manejar la sintaxis de los comandos en Stata  |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
