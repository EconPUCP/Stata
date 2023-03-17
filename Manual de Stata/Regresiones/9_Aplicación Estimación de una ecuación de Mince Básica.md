# Regresiones

### APLICACIÓN: ESTIMACIÓN DE UNA ECUACIÓN DE MINCER BÁSICA

Una ecuación de Mincer busca explicar el nivel de ingresos a partir del nivel de educación así como de otras variables. Consideremos el siguiente modelo:

*log (Ingreso)i = β0+ β1 Educacióni+ β3 HabilidadesInnatasi + ui*

Las habilidades innatas de las personas no son observables por lo que no pueden ser introducidas al modelo. A pesar de esto sí logran determinar el valor del ingreso. Si no consideramos a esta variable entonces estaríamos estimando un modelo como el siguiente:

*log (Ingreso)i = β0+ β1 Educaciónni + εi (1)*
En donde: *β3 HabilidadesInnatasi + ui= εi*

Si estimamos (1) entonces es esperable que E(Educacióni,εi)≠0 dado que las habilidades innatas se correlacionan con el nivel de educación de una personas. A partir de esto debemos de decidir un instrumento que nos permita estimar la ecuación.

Para estimar esta ecuación primero necesitamos juntar los módulos de empleo (módulo 5) y de educación (módulo 3) de la ENAHO. A partir de esta nueva base creamos una variable para los años de educación y una del logaritmo del ingreso total. Como instrumento proponemos el nivel educativo del jefe de hogar. Adicionalmente estimamos 4 modelos. Dos de ellos MCO directos (uno para toda la muestra y otro para solo los hijos/as de jefes/as de familiar) y otros dos modelos usando como variable instrumental el nivel educativo del jefe de hogar.

```
* Estimamos tres modelos
eststo clear
eststo: svy: 						 reg log_ing educ i.p207 p208
eststo: svy, subpop(hijo_jefehogar): reg log_ing educ i.p207 p208
eststo: svy: 					  	 ivregress 2sls log_ing (educ = educ_jefe) i.p207 p208
eststo: svy, subpop(hijo_jefehogar): ivregress 2sls log_ing (educ = educ_jefe) i.p207 p208
```

La calidad del resultado depende, en bastante proporción, de qué tan bien se justifique la exogeneidad de la variable instrumental. 

![image](https://user-images.githubusercontent.com/106888200/224335727-d78182a4-3c53-4abc-8c86-3d82ae60f8f9.png)


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
