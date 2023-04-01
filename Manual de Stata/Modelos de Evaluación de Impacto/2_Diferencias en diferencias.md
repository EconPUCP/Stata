# Evaluación de Impacto

### 2 DIFERENCIAS EN DIFERENCIAS

En muchos casos la variable de interés cambia en el tiempo para un grupo de individuos, una provincia, una cohorte. La fuente de sesgo de variable omitida en estos casos puede ser la
presencia de variables no observables a nivel de estado y año. En estos casos podemos utilizar la estrategia de identificación llamada de Diferencias-en-Diferencias (DD o dif-en-dif). 

Una ventaja de este modelo es que es capaz de remover aquel componente no observable de los datos con el fin de tener estimaciones confiables apoyándonos en la existencia de datos de panel de los individuos antes y después de recibir el tratamiento y asumiendo que las características no observables son invariantes en el tiempo podemos obtener estimaciones confiables del efecto tratamiento. 

$$y_{it}=\alpha_0+\alpha_1T_i+\alpha_2t_t+\beta(T_ixt_t)+e_it$$

En donde $y_{it}$ es la variable de resultado, $T_i$ es una dummy = 1 para el grupo de tratados
y $t_t$ es una dummy = 1 para el periodo en donde el grupo tratado recibe el tratamiento.
Por último, $(T_i × t_t)$ es la interacción entre ambas dummy. El coeficiente $\beta$ es el parámetro de interés.

Para ejemplificar este modelo abriremos nuestro do file, estableceremos nuestro directorio y procederemos a abrir nuestra base de datos.

```
use "Panel101.dta", clear
```

Crearemos una variable ficticia para indicar el momento en que comenzó el tratamiento. Supondremos que el tratamiento comenzó en 1994. En este caso, los años anteriores a 1994 tendrán un valor de 0 y los años a partir de 1994 un 1.

```
gen time = (year>=1994) & !missing(year)
```

Crearemos una variable ficticia para identificar el grupo expuesto al tratamiento. Supondremos que se trataron los países con los códigos 5, 6 y 7 (=1). Los países 1-4 no fueron tratados (=0).

```
gen treated = (country>4) & !missing(country)
```

Crearemos una interacción entre el tiempo y el tratado. Llamaremos a esta interacción 'did'

```
gen did = time*treated
```

Procedemos a realizar la estimación del estimador a tráves de tres alternativas.

La primera forma de llegar al estimador es utilizando el comando `reg` seguido de la variable dependiente, time, treated y did.

```
reg y time treated did, r
```

![image](https://user-images.githubusercontent.com/128189216/229003236-afbb7788-3920-4388-bd86-9bc4ef31f3ed.png)

El coeficiente para 'did' es el estimador de diferencias en diferencias que es igual a -2519. El efecto es significativo al nivel del 10%, teniendo el tratamiento un efecto negativo

Una manera alternativa de llegar a este mismo estimador sin crear la variable de interacción es haciendo uso del método del hastag visto en este mismo manual en la sección de regresiones. 

```
reg y time##treated, r
```
![image](https://user-images.githubusercontent.com/128189216/229003406-d1e6400c-7faa-45b6-81c2-241a4eb096fc.png)

Podemos observar que llegamos al mismo estimador. Stata también nos ofrece un comando especial para realizar los este tipo de modelos, el comando `diff`, este debe ser instalado previamente.

```
ssc install diff
diff y, t(treated) p(time)
```
![image](https://user-images.githubusercontent.com/128189216/229003551-c3c89805-33da-4272-88a4-30aa0eccb3eb.png)
 


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| Wordl Bank - Repositorio Github | [`ietoolkit`](https://github.com/worldbank/ietoolkit "`ietoolkit`") | Kit de herramientas del comando `ietoolkit` en Stata para evaluaciones de impacto |
| Rodazuero - Repositorio de Github | [Regression Discontinuity](https://github.com/rodazuero/samplecode/blob/master/Stata/Practical%20Guide%20for%20Impact%20Evaluation/Regression%20Discontinuity/discontinuity_do-file.do "Regression Discontinuity") | Do file - aplicación de una regresión discontinua |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/5_Importar_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
