# Regresiones

### 7. ENDOGENEIDAD EN LOS MODELO

### 7.1 ENDOGENEIDAD

Los problemas de endogeneidad son constantes al momento de estimar un modelo. Una forma fácil de entender la endogeneidad es considerar que hay una correlación entre una variable explicativa (incluida o no ) y el término de error. Es decir:  

  ![image](https://user-images.githubusercontent.com/106888200/224231853-c90b37b8-b4a0-4159-9f6e-5785c45f4470.png)


Definamos que esto puede ocurrir producto de:
- Sesgo por omisión de variables
- Simultaneidad entre variable dependiente e independiente
- Mala especificación del modelo
- Sesgo de selección

Veamos un ejemplo clásico de simultaneidad.
Consideremos una ecuación de oferta y otra de demanda:

![image](https://user-images.githubusercontent.com/106888200/224231802-c2d58206-8120-4035-bda0-d12c729c94d0.png)


Si queremos estimar Qd sin considerar que P se determina simultáneamente en las ecuaciones entonces tendríamos problemas de endogeneidad. Si encontramos los valores de equilibrio de las variables obtenemos:

![image](https://user-images.githubusercontent.com/106888200/224231925-aa43209d-4b62-4fc6-95b1-6191f5797a6a.png)

A partir de esto, podemos verificar que:

![image](https://user-images.githubusercontent.com/106888200/224231972-71b5e77e-67c8-46e4-8a36-9d21cf3a2cdc.png)

Por lo que no se cumpliría que E(P _d_ ε _d_),  por lo tanto, hay endogeneidad

### 7.2 VARIABLES INSTRUMENTALES

Para resolver este problema podemos proponer un o un conjunto de variables instrumentales. Un instrumento debería no estar correlacionado con el término de error y solo afectar a la variable independiente mas no a la dependiente. Definamos a un instrumento como z. Comparemos distintos escenarios:

![image](https://user-images.githubusercontent.com/106888200/224232364-8493a449-cff1-49db-bd42-e7bd4540ebb5.png)

- Exogeneidad, cov(z,u)=0
- Relevancia, Corrz(z,x),x≠0 . Es decir que z tenga la capacidad de explicar x.

El uso de variables instrumentales se puede dar bajo distintos métodos de estimación, no solo bajo MCO. En este caso revisaremos cómo estimar el modelo básico usando dos métodos: Mínimo Cuadrado en 2 Etapas y el Método Generalizado de Momentos. 

### 7.3 ESTIMANDO PASO A PASO, IVREGRESS Y IVREG2

Comenzamos viendo la estimación por dos etapas. Consideremos a x1 como la variable endógena, x2 como otra variable explicativa no endógena, a z como la variable instrumental y a y como la variable dependiente. La primera etapa consiste en estimar:

![image](https://user-images.githubusercontent.com/106888200/224233074-6a7aeeaa-81b1-4ce5-aa7f-b2d577a78c00.png)

A partir de esto se obtiene:

![image](https://user-images.githubusercontent.com/106888200/224233143-e672bdd0-cdbc-40a0-a35b-3d4d642bcc24.png)

Usamos el valor estimado de x1 para regresionar:

![image](https://user-images.githubusercontent.com/106888200/224233175-0bdd80a6-3379-45f0-98f8-57db19abb099.png)

Podemos llegar a esta estimación paso a paso, estimando cada etapa, o usando un comando en particular. Hay dos comandos bastante usados, `ivregress` y `ivreg2`. Comparemos los tres caminos.

Como ejemplo tomemos los datos del estudio de Romer (1993) en donde se busca estimar la correlación entre la tasa de inflación de un país y su nivel de apertura comercial (controlado por el nivel de ingreso per cápita en logaritmo). Para ello planteamos un modelo simple:

![image](https://user-images.githubusercontent.com/106888200/224233259-e2ac0fd4-b42c-4052-ab08-9b2eed1abcc8.png)

En este caso planteamos como variable instrumental al logaritmo de la extensión territorial del país. Veamos:

```
use "http://fmwww.bc.edu/ec-p/data/wooldridge/openness", clear

* Estimamos un modelo por MC2E

* Manualmente
reg open lland lpcinc 
predict open_hat, xb
reg inf open_hat lpcinc

* Usando ivregress
ivregress 2sls inf (open = lland) lpcinc

* Usando ivreg2
ivreg2 inf (open = lland) lpcinc
```

Si lo hacemos paso a paso, primero debemos estimar la primera etapa del modelo, luego predecir el valor de la variable endógena y, por último, usar esta nueva variable como regresor en la ecuación final. En el caso de `ivregress` debemos indicar que estime el modelo en dos etapa indicando 2sls:

![image](https://user-images.githubusercontent.com/106888200/224235312-d9b52c15-c06b-43c9-a2d8-19330ee6e275.png)


Entre paréntesis debemos indicar la variable endógena y el o los instrumentos a usar. Fuera podemos indicar las variables explicativas que no son endógenas. En el caso de `ivreg2` no es necesario indicar expresamente que se estime por dos etapas puesto que es la opción por default. Este último comando tiene una amplia cantidad de opciones disponibles para usar, así como un resultado acompañado de mayor información.

Al comparar los tres resultados obtenemos los mismos coeficientes y estadísticos. En el resultado de `ivreg2` podemos ver la información usual sino también más información sobre algunos tests realizados. Regresaremos a estos test posteriormente.

```
* Comparamos los resultados
eststo clear
eststo: reg inf open_hat lpcinc
eststo: ivregress 2sls inf (open = lland) lpcinc
eststo: ivreg2 inf (open = lland) lpcinc
esttab, rename(open_hat Apertura open Apertura lpcinc logIngpc _cons Const) mtitle("Manualmente" "ivregress" "ivreg2")
```

![image](https://user-images.githubusercontent.com/106888200/224235523-e41b71b6-e7a9-4183-be5f-2ed02819aaac.png)


En el resultado de `ivreg2` podemos ver la información usual sino también mayor información sobre algunos tests realizados. Regresaremos a estos test posteriormente.

![image](https://user-images.githubusercontent.com/106888200/224235809-50f7659e-42e7-4496-9245-84032e767f18.png)


#### 7.3.1 Gmm 

El método generalizado de momentos estima el modelo de manera distinta al estimador de dos etapas. En este escenario se busca que los estimadores cumplan con:

![image](https://user-images.githubusercontent.com/106888200/224236026-1fb94002-2135-4bec-9a6b-99e88abbb456.png)

Siendo g() la función generalizadora de momentos y el vector de coeficientes a estimar. Este no es un método lineal como en el caso anterior. Veamos las diferencias de estimar el modelo considerando dos etapas y considerando el Método generalizado de momentos:

```
* Estimemos el modelo usando el método generalizado de momentos o GMM

eststo clear
eststo: ivregress 2sls inf (open = lland) lpcinc
eststo: ivregress gmm  inf (open = lland) lpcinc
esttab , mtitle("2SLS" "GMM")

```

![image](https://user-images.githubusercontent.com/106888200/224236273-5a3c319c-ea59-4dc5-9642-f078b924fb02.png)

En este caso vemos que el coeficiente estimado es igual pero los errores estándar son distintos. Esto se debe a que son dos maneras distintas de obtener los valores de los coeficientes.

## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*

