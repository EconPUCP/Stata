# Modelo de series de tiempo

## 1.  OPERADORES DE REZAGOS, ADELANTOS Y DIFERENCIAS
---------------------------------

Un conjunto importante de operadores que se vuelve disponible cuando se usa `tsset` con los relacionados a los rezagos, los adelantos y las diferencias. Veamos este operador en términos de ecuaciones:

- Rezago: Indica el valor de un periodo previo y se indica con el prefijo `l(1).x`

$$g_t=ln(y)_t - ln(y)_{t-1}$$

- Adelanto: Indica el valor de un periodo posterior y se indica con el prefijo `f(1).x`

$$g_{t+1}=ln(y)_{t+1} - ln(y)_{t}$$

- Differencia: El prefijo `d(1).x` sirve para tomar la resta entre dos periodos distintos

$$g_t=ln(y)_t - ln(y)_{t-1}$$

Antes de presentar los ejemplos vamos a limpiar las bases de datos. Usaremos el PBI peruano tanto en frecuencia anual como en frecuencia trimestral.
Carguemos la serie anual del PBI Gasto del Perú desde la página de BCRP. Limpiamos y ordenamos la serie y nos quedamos con los cinco componentes del PBI Gasto: Consumo, Inversión, Gasto Público y Exportaciones Netas. 

```
import excel using "PBI Gasto Real.xlsx", sheet("Anual") clear

rename (*) (year DI C G I Ip X M PBI)
drop in 1/2
drop if year == 2020
destring(*), replace

gen XN = X-M
keep year C G I XN PBI

tsset year
save "pbi_year", replace
```

En el caso anual, la variable de tiempo es el año de manera directa. Veamos el caso trimestral.

En el caso trimestral, la variable de fecha no viene en el formato deseado por lo que tenemos que hacer una limpieza previa. 

```
* Cargamos la serie trimestral del PBI de Perú
import excel using "PBI Gasto Real.xlsx", ///
 sheet("Trimestral") clear

rename (*) (Q DI C G I Ip X M PBI)
drop in 1/2
drop if Q == "T419" | Q == "T120"
destring(*), replace

gen XN = X-M

gen year = substr(Q,3,2)
destring(year), replace

replace year = year + 2000 if year<90
replace year = year + 1900 if year<2000

gen q = substr(Q,2,1)
destring(q), replace

gen trimestre = yq(year,q)
format trimestre %tq
keep trimestre C G I XN PBI

save "pbi_trimestre", replace
```

Extraemos el valor del año y el número del trimestre. Como solo se tiene dos dígitos del año tenemos que pasarlo al valor completo agregando los números que faltan. Con el año y el número del trimestre podemos usar una función ya conocida `yq()` para obtener el valor del trimestre. Guardamos casa una de las bases para usarlas cuando lo necesitemos. Ahora, veamos cómo usar rezagos.

### 2.1 REZAGOS

El operador de rezagos permite crear o usar un valor rezago de una variable. A partir de los datos anuales vamos a crear series rezagadas del PBI. Para indicar el número de rezagos podemos agregar un número al operador. Por ejemplo, l2.lnpbi sería el 2do rezago del logaritmo del PBI.

```
use "pbi_year", clear

gen lnpbi = ln(PBI)
gen lnpbi_l1 = l.lnpbi
gen lnpbi_l2 = l2.lnpbi
gen lnpbi_l3 = l3.lnpbi
gen lnpbi_l4 = l4.lnpbi
gen lnpbi_l5 = l5.lnpbi
```

Si hacemos un gráfico line de las series rezagados podemos ver el número de años que cada serie se retrasa.

![image](https://user-images.githubusercontent.com/106888200/224374997-2196b0cb-9379-415d-9b52-2da65abad033.png)


Cuando tenemos datos trimestrales puede ser útil definir a los rezagos de una variable no como los valores inmediatamente previos sino como los valores pasados de cada uno de los trimestres. Por ejemplo, cuando se compara el primer trimestre del 2019 con el primer trimestre del 2018.

```
tsset trimestre

gen lnpbi = ln(PBI)
gen lnpbi_l1 = l4.lnpbi
gen lnpbi_l2 = l8.lnpbi
gen lnpbi_l3 = l12.lnpbi
gen lnpbi_l4 = l16.lnpbi
gen lnpbi_l5 = l20.lnpbi
```

![image](https://user-images.githubusercontent.com/106888200/224375132-4d57f9b9-2597-4d1b-9b00-d1ccc206279e.png)

En este caso, para comparar los valores del primer trimestre de cada año usamos _l4.lnpbi_. Si tuviéramos datos mensuales tendríamos que usar _l12.lnpbi_, por ejemplo.
Al momento de querer graficar estas nuevas series nos topamos con un problema. Si usamos la opción `xlabel()` de manera usual terminaríamos con un gráfico errado. Para que el código tenga sentido se puede agregar expresiones entre comillas con los formatos deseados. Por ejemplo, indicamos que son quarters/trimestres ‘q()’ y luego damos formato de trimestre. 

```
twoway ///
(line lnpbi trimestre)  ///
(line lnpbi_l1 trimestre) ///
(line lnpbi_l2 trimestre) ///
(line lnpbi_l3 trimestre) ///
(line lnpbi_l4 trimestre) ///
(line lnpbi_l5 trimestre), ///
legend(  cols(6) size(*0.5) order(1 "lnPBI" 2 "Rezago 1" 3 "Rezago 2" ///
 4 "Rezago 3" 5 "Rezago 4" 6 "Rezago 5")) xtitle("") ytitle("ln(PBI)") ///
 title("PBI y rezagos" "Datos trimestrales") ///
 xlabel(`=q(1990q1)'(8) `=q(2018q1)', format(%tq) labsize(*0.7))
```

![image](https://user-images.githubusercontent.com/106888200/224383578-16032776-3fbb-4e70-bda6-8f437a6a3419.png)

Esta opción es, definitivamente, más compleja y extenuante. Luego veremos cómo integrar los datos de series de tiempo a gráficos. Por el momento sigamos con esta lógica.

### 2.2 ADELANTOS

Con el operador de adelantos, `f.var` podemos tomar los valores adelantados de las variables. Tomemos el caso de los datos trimestrales del PBI. Creamos una serie con los valores de los mismos trimestres, pero de años posteriores: 

![image](https://user-images.githubusercontent.com/106888200/224375289-8cc4c8d8-bce7-47d8-92e2-81919f0b9572.png)

Complementemos los operadores de rezagos y adelantos con el operador de diferencias.

### 2.3 DIFERENCIAS

El operador de diferencias toma la resta de una misma variable un número de períodos dados. Tomemos la base anual del PBI y construyamos la tasa de crecimiento usando tanto el operador de diferencias como los operadores de rezago. Recordemos que la tasa de crecimiento puede definirse de la siguiente manera:

$$g_t=ln(y)_t - ln(y)_{t-1}$$

![image](https://user-images.githubusercontent.com/106888200/224375405-810b37ba-deec-4a8f-8613-7ead22b3ec38.png)


```
use "pbi_year", clear
tsset year
gen lnpbi = ln(PBI)
gen g_pbi1 = lnpbi - l.lnpbi
gen g_pbi2 = d.lnpbi
```

Luego de crear el logaritmo del PBI, podemos crear la tasa de crecimiento tomando de manera manual la diferencia lnpbi - l1.lnpbi o podemos usar el operador de diferencias para obtener lo mismo, d.lnpbi. Ojo: si indicamos un número mayor de diferencias, por ejemplo d2.lnpbi, estamos considerando la 2da diferencia del PBI es decir:

$$d2.lnpbi =(ln(y)_t - ln(y)_{t-1}) - (ln(y)_{t-1} - ln(y)_{t-2})$$

Tomemos la base trimestral y comparemos si podemos obtener la tasa de crecimiento Q-Q usando el comando de diferencias.

```
use "pbi_trimestre", clear
tsset trimestre
gen lnpbi = ln(PBI)
gen g_pbi1 = lnpbi - l4.lnpbi
gen g_pbi2 = d4.lnpbi
```

![image](https://user-images.githubusercontent.com/106888200/224375603-7e83af9a-50f4-40d8-8d22-253a98eb547f.png)

La última línea de código no genera la tasa de crecimiento sino la diferencia de la diferencia de la diferencia de la diferencia del ln(y). También podemos combinar los operadores. Si queremos obtener la tasa de crecimiento rezagada en la base anual del PBI podemos usar l.d.lnpbi.


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
