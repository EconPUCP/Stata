# PANEL DE DATOS

### 2 SELECCIÓN DE MODELOS

Luego de ver todos los modelos que se pueden usar podemos definir algunos criterios estadísticos para seleccionar cuál modelo sería pertinente.
Veamos:

### - Efectos Fijos vs Datos agrupados:  test F

Para comparar el modelo de efectos fijos con el modelo de datos agrupados se usa el test F cuando estimamos el modelo de panel con efetos fijos. 


```
xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, fe // efectos fijos
```

![image](https://user-images.githubusercontent.com/128189216/227427882-89ab6f2a-106b-4890-8fa9-0a87b4739371.png)

El p-value de este test nos indica que rechazamos la hipótesis nula por lo que aceptamos que el modelo de efectos fijos es más adecuado que el de datos agrupados.

### - Efectos Aleatorios vs Datos agrupados: test de Breusch-Pagan

Para comparar el modelo de efectos aleatorios con el modelo de efectos fijos se usa el test Breusch-Pagan, este test se realiza con el comando `xttest0`

```
quietly xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, re
xttest0
```

![image](https://user-images.githubusercontent.com/128189216/227428566-80901324-a322-43bb-86c5-33a6d48f7921.png)

El p-value de este test nos indica que rechazamos la hipótesis nula por lo que aceptamos que el modelo de efectos aleatorios es más adecuado que el de datos agrupados.

### - Efectos Fijos vs Efectos Aleatorios: test de Hausman

Para comparar ambos modelos usamos el test de Hausman. Previamente debemos estimar los dos modelos y guardarlos con `estimates store` luego usamos el comando
`hausman` junto a los datos almacenados

```
quietly xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, fe
estimates store fijos
quietly xtreg lsalario raza escolaridad sexo experiencia urbano i.zona, re
estimates store aleatorios
hausman fijos aleatorios
```

![image](https://user-images.githubusercontent.com/128189216/227429527-1e789cd9-3cbd-494d-b23c-1805f821eec3.png)

### - Efectos Fijos por individuo vs Efectos fijos temporales: testparm

Para comparar los dos modelos usamos un test F sobre los coeficientes de cada año. Para elo usamos el comando `testparm`.


```
xtreg lsalario raza escolaridad sexo experiencia urbano i.zona i.año, fe
testparm i.año
```

![image](https://user-images.githubusercontent.com/128189216/227430252-15331d6f-7a27-4412-b2b0-e62a30e636dc.png)

El p-value de este test nos indica que aceptamos la hipótesis nula por lo que aceptamos que el modelo de efectos fijos es más adecuado que el modelo de efectos fijos temporales.

> **TIPS: Tabla rápida de comandos xt**
> 
> El siguiente cuadro es un resumen de los comandos xt en Stata. 
> 
> | Descripción | Comandos | 
> | :-------------- |:-------------|
> | Resumen de datos | xtset; xtdescribe; xtsum; xtdata; xtline; xttab; xttrans |   
> | MCO agrupado | regress |   
> | FGLS agrupados | xtreg, re; xtregar, re |   
> | Efectos aleatorios | xtreg, re; xtregar, re |   
> | Efectos fijos | xtreg, f e ; xtregar, fe |     
> | Primeras diferencias | regress (con datos diferenciados) |   
> | VI estático | xtivreg; xthtaylor |   
> | VI dinámico | xtabond; xtdpdsys; xtdpd | 
> 
>  ***Esta tabla fue elaborada por Cameron & Trivedi en el libro "Microeconometrics Using Stata".
>  


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/EconPUCP/Stata/blob/main/_An%C3%A1lisis/Scripts/Modelos%20de%20Panel%20de%20datos/2_selecci%C3%B3n_de_modelos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
