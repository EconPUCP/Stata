# Evaluación de Impacto

### 2 DIFERENCIAS EN DIFERENCIAS

En muchos casos la variable de interés cambia en el tiempo para un grupo de individuos, una provincia, una cohorte. La fuente de sesgo de variable omitida en estos casos puede ser la
presencia de variables no observables a nivel de estado y año. En estos casos podemos utilizar la estrategia de identificación llamada de Diferencias-en-Diferencias (DD o dif-en-dif). 

Una ventaja de este modelo es que es capaz de remover aquel componente no observable de los datos con el fin de tener estimaciones confiables apoyándonos en la existencia de datos de panel de los individuos antes y después de recibir el tratamiento y asumiendo que las características no observables son invariantes en el tiempo podemos obtener estimaciones confiables del efecto tratamiento. 

$$y_{it}=\alpha_0+\alpha_1T_i+\alpha_2t_t+\beta(T_ixt_t)+e_t$$

En donde $y_{it}$ es la variable de resultado, $T_i$ es una dummy = 1 para el grupo de tratados
y $t_t$ es una dummy = 1 para el periodo en donde el grupo tratado recibe el tratamiento.
Por último, $(T_i × t_t)$ es la interacción entre ambas dummy. El coeficiente $\beta$ es el
parámetro de interés.


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/5_Importar_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
