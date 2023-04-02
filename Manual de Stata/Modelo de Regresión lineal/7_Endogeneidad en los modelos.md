# Regresiones

### 7. ENDOGENEIDAD EN LOS MODELO

### 7.1 ENDOGENEIDAD

Los problemas de endogeneidad son constantes al momento de estimar un modelo. Una forma fácil de entender la endogeneidad es considerar que hay una correlación entre una variable explicativa (incluida o no ) y el término de error. Es decir:  

$E(e|X) ≠ 0$ o $E(X'e) = 0$


Definamos que esto puede ocurrir producto de:
- Sesgo por omisión de variables
- Simultaneidad entre variable dependiente e independiente
- Mala especificación del modelo
- Sesgo de selección

Veamos un ejemplo clásico de simultaneidad.
Consideremos una ecuación de oferta y otra de demanda:

$$Q_d = \beta P_d + e_d$$


$$Q_s = \theta P_s + e_s$$

Si queremos estimar $Q_d$ sin considerar que P se determina simultáneamente en las ecuaciones entonces tendríamos problemas de endogeneidad. Si encontramos los valores de equilibrio de las variables obtenemos:

$$P=\frac{e_s-e_d}{\beta-\theta}$$


$$Q=\frac{\beta e_s-\theta e_d}{\beta-\theta}$$


A partir de esto, podemos verificar que:


$$E(P_d e_d) = E(\frac{e_s-e_d}{\beta-\theta} e_d)=-\frac{E(e_d^2)}{\beta-\theta}$$


Por lo que no se cumpliría que $E(P_dε_d)=0$,  por lo tanto, hay endogeneidad

### 7.2 VARIABLES INSTRUMENTALES

Para resolver este problema podemos proponer un o un conjunto de variables instrumentales. Un instrumento debería no estar correlacionado con el término de error y solo afectar a la variable independiente mas no a la dependiente. Definamos a un instrumento como z. Comparemos distintos escenarios:

![image](https://user-images.githubusercontent.com/106888200/224232364-8493a449-cff1-49db-bd42-e7bd4540ebb5.png)

- Exogeneidad, $cov(z,u)=0$
- Relevancia, $Corrz(z,x),x≠0$ . Es decir que $z$ tenga la capacidad de explicar $x$.

El uso de variables instrumentales se puede dar bajo distintos métodos de estimación, no solo bajo MCO. En este caso revisaremos cómo estimar el modelo básico usando dos métodos: Mínimo Cuadrado en 2 Etapas y el Método Generalizado de Momentos. 

### 7.3 ESTIMANDO PASO A PASO, IVREGRESS Y IVREG2

Comenzamos viendo la estimación por dos etapas. Consideremos a x1 como la variable endógena, x2 como otra variable explicativa no endógena, a z como la variable instrumental y a y como la variable dependiente. La primera etapa consiste en estimar:

$x_{1,i}=\alpha_0+\alpha_1 z_i +\alpha_2 x_{2,i} + e_i$

A partir de esto se obtiene:

$$\hat{\alpha_{1,i}}=\hat{\alpha_1} z_i+ hat{\alpha_2} x_{2,i}$$

Usamos el valor estimado de $x_1$ para regresionar:

$$y_i=\beta_0+\beta_1 \hat{x_{1,i}}+\beta_2\ x_{i,2} + u_i$$

Podemos llegar a esta estimación paso a paso, estimando cada etapa, o usando un comando en particular. Hay dos comandos bastante usados, `ivregress` y `ivreg2`. Comparemos los tres caminos.

Como ejemplo tomemos los datos del estudio de Romer (1993) en donde se busca estimar la correlación entre la tasa de inflación de un país y su nivel de apertura comercial (controlado por el nivel de ingreso per cápita en logaritmo). Para ello planteamos un modelo simple:

$$inflación_i=\beta_0+\beta_1xApertura_i+ \beta_2 x log(Ingreso_{pc})_i+u_i$$

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

$$E[g(x,\theta]=0$$

Siendo $g()$ la función generalizadora de momentos y el vector de coeficientes a estimar. Este no es un método lineal como en el caso anterior. Veamos las diferencias de estimar el modelo considerando dos etapas y considerando el Método generalizado de momentos:

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
| César Mora Ruíz  | [Endogeneidad y variables instrumentales en Stata](https://www.youtube.com/watch?v=GJLos89fLic&list=PLlyb_Ke0SHbj3hKlN_lUH7F28IoafcSv-&index=5&ab_channel=ProyectaPer%C3%BA-Asesores "Endogeneidad y variables instrumentales en Stata") | Aplicación en Stata con variables instrumentales |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelo%20de%20Regresi%C3%B3n%20lineal/7_endogenoidad.do "script") y [base de datos](https://github.com/EconPUCP/Stata/tree/main/_An%C3%A1lisis/Data/Modelo%20de%20Regresi%C3%B3n%20lineal "base de datos")*

