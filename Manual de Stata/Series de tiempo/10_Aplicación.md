# Aplicación


Como aplicación vamos a estimar un VAR entre tres variables macroeconómicas importantes, la tasa de desempleo, la tasa de interés de los bonos del gobierno y la tasa de inflación. Empezaremos abriendo nuestra base de datos y declarar que es una serie de tiempo.

```
use "bcrp.dta"
tsset date // establecer que la base de datos es una serie de tiempo
```

Dado que los datos de los meses de crisis complican el análisis eliminamos los datos del año 2020, año que se vivió a nivel mundial el covid 19 y solo consideramos desde 2005M5 hasta 2019M12 haciendo uso del comando `keep` `if` . Veamos:

```
keep if tin(2005m5, 2019m12)
```

realizaremos un gráfico con el comando `tsline` para observar el comportamiendo de las series. Para verificar que las series son estacionarias, realizaremos el test de Dickey - Fuller para ver presencia de raíz unitaria.

```
* Vemos las series

tsline interes u inf, ttitle("") ytitle("%") ///
 legend(order(1 "Interés" 2 "Desempleo" 3 "Inflación") cols(3))
  
* Verificamos estacionariedad en cada una de las series
dfuller interes
dfuller desempleo
dfuller inf 
```

![image](https://user-images.githubusercontent.com/106888200/225364657-c8ca466f-6957-4489-97a7-cf3bd74d6888.png)
![image](https://user-images.githubusercontent.com/106888200/225364804-61c60a99-73ca-46f8-888d-e8d5cb6b86f9.png)


Luego, tenemos que ver el número de rezagos a considerar con el comando `varsoc`:

```
varsoc interes desempleo inf
```

![image](https://user-images.githubusercontent.com/106888200/225364971-28df9003-52d5-4c65-aaff-d4a60a71387d.png)

En este caso, el AIC nos indica que usemos hastael rezago 4 mientras que el resto de criterios nos indican hasta el rezago 2. Dado que no tenemos muchos datos, N = 176, nos quedamos con solo dos rezagos. Entre más rezagos más coeficientes se deben estimar y, ante pocas observaciones, puede complicar la capacidad de inferencia.

Dado que ya seleccionamos el número de rezagos podemos estimar el modelo usando el comando `var`. En este caso vamos a usar un comando nuevo, varbasic, este nos permite estimar el mismo modelo VAR previo pero genera automáticamente los IRF ortogonalizados.

```
varbasic inf u interes , lags(1/2)
```

![image](https://user-images.githubusercontent.com/106888200/225365788-0350d536-fd8d-45e7-99b5-6e5952ffa1a3.png)


El modelo estima una cantidad considerable de coeficientes por lo que la tabla de resultados se hace extensa. Vemos directamente el IRF ortogonalizado.

![image](https://user-images.githubusercontent.com/106888200/225366706-74474676-4f88-4cbc-a699-9cecb14030d6.png)

Ahora, estimemos las IRF estructurales. Para ello asumiremos que la matriz A es triangular inferior mientras que B es una diagonal.

```
matrix A1 = (1,0,0 \ .,1,0 \ .,.,1)
matrix B1 = (.,0,0 \ 0,.,0 \ 0,0,.)

svar inf u interes, lags(1/2) aeq(A1) beq(B1)
```

Realizaremos el impulso respuesta

```
irf create svar_irf, step(36) set(irf_2) replace
irf graph sirf, impulse(inf desempleo interes) response(inf desempleo interes) xtitle("Periodos")
```

![image](https://user-images.githubusercontent.com/106888200/225368645-eb3dd329-4341-43a4-9c01-68d4592b81f5.png)


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
