# Modelo de series de tiempo

## 3.  GRÁFICOS DE SERIES DE TIEMPO

Cuando declaramos la base de datos como series de tiempo podemos usar un comando nuevo para graficar series, tsline. Este comando es similar al que ya conocimos previamente, line, con la diferencia que ya no necesitamos indicarla fecha como 2da variable. Grafiquemos la participación de cada componente del PBI usando `tsline` y `line` solo para los años entre 1995 y 2015.

```
use "pbi_year", clear

tsset year

gen C_s  =  C*100/PBI
gen I_s  =  I*100/PBI
gen G_s  =  G*100/PBI
gen XN_s = XN*100/PBI

line C_s I_s G_s XN_s year if tin(1995,2015), xtitle("") ytitle("% PBI") ///
xlabel(1995(1)2015, grid labsize(*0.6)) ylabel(0(10)70) ///
legend(order(1 "Consumo" 2 "Inversión" 3 "Gasto" 4 "Exp.Netas") ///
cols(4) size(*0.6) ) lcolor(gs0 gs0 gs0 gs0) lpattern(solid - .- ..--) ///
title("Componentes del PBI") name(linea1, replace)

tsline C_s I_s G_s XN_s if tin(1995,2015), xtitle("") ytitle("% PBI") ///
xlabel(1995(1)2015, grid labsize(*0.6)) ylabel(0(10)70) ///
legend(order(1 "Consumo" 2 "Inversión" 3 "Gasto" 4 "Exp.Netas") ///
cols(4) size(*0.6) ) lcolor(gs0 gs0 gs0 gs0) lpattern(solid - .- ..--) ///
title("Componentes del PBI") name(linea2, replace)
```

![image](https://user-images.githubusercontent.com/106888200/224386617-b38e9cb1-7c1a-48be-9e53-665e9919b5ba.png)

En ambos casos obtenemos el mismo gráfico. Cuando indicamos `tsline` ya no hacemos uso de year. Otro comando nuevo es `tin()`, este sirve para indicar los años que queremos tomar. Veamos un ejemplo con los datos trimestrales en donde se complica un poco más.
Cuando usamos datos en frecuencias distintas a las anuales hace bastante útil usar los comandos nuevos.

```
use "pbi_trimestre", clear
tsset trimestre

gen C_s  =  C*100/PBI
gen I_s  =  I*100/PBI
gen G_s  =  G*100/PBI
gen XN_s = XN*100/PBI

tsline  C_s I_s G_s XN_s if tin(1995q1,2015q4), xtitle("") ytitle("% PBI") ///
tlabel(1995q1(8)2015q1 2015q4, grid labsize(*0.5)) ylabel(0(10)70) ///
legend(order(1 "Consumo" 2 "Inversión" 3 "Gasto" 4 "Exp.Netas") ///
cols(4) size(*0.6) ) lcolor(gs0 gs0 gs0 gs0) lpattern(solid - .- ..--) ///
title("Componentes del PBI") name(linea2, replace)

```

Por ejemplo:
- Usamos `if tin(1995q1,2015q4)` para denotar los trimestres que vamos a considerar 
- Si usamos `xlabel()` obtendríamos problemas ya que el programa no leería la fecha en sí sino el valor numérico que está detrás de la etiqueta. Para considerar los valores de las fechas usamos `tlabel()`.

![image](https://user-images.githubusercontent.com/106888200/224386821-e4e356f4-a69b-4bf6-93f8-895ef677ffe8.png)

Hasta este punto hemos visto cómo manipular las variables de tiempo y como hacer algunos gráficos simples considerando estos datos. Ahora vamos a ver un primer conjunto de operaciones estadísticas bastante recurrentes cuando se usan datos temporales.

****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
