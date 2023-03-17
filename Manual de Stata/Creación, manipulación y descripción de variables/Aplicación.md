# Aplicación

Para integrar los puntos estudiados en este modulo, replicaremos un ejemplo  del laboratorio de manejo de base de datos 2023 - 0 de Diego Quispe Ortogorin, para lo cual realizaremos un reporte macroeconómico.

Trabajando con la base de datos Penn World Table. PWT se encuentra en su versión 10.01 y contiene información sobre los niveles relativos de ingresos, producción, insumos y productividad, que cubre 183 países entre 1950 y 2019. Podemos descargar los módulos directamente desde su [página web ](https://www.rug.nl/ggdc/productivity/pwt/?lang=en "página web ") o descargalo directamente desde el siguente [enlace](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "enlace"). 

iniciamos abriendo nuestro do file para lo cual digitamos `do edit` en la ventana de comandos, estableceremos nuestro directorio y abriremos nuestra base de datos


```
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" //cambiar cd
use "pwt1001.dta"
```

Luego de cargar los datos podemos hacer una descripción rápida de los
datos y sus etiquetas con el comando `describe`:

```
describe
```

![image](https://user-images.githubusercontent.com/106888200/225217205-8108ab66-e0b2-44ac-861d-832ae770a27f.png)

A pesar que de el PW nos brinda los datos están estandarizados a dolares del 2017 con PPP (poder de paridad de compra) lo que nos permite que los datos sean comparables para todos los países, algunos de estos no se pueden comparar directamente como el PBI para lo cual se crea nuevas variables con el comando `gen`.


```
* Creamos nuevas variables 
gen GDB=rgdpna/pop // PBI per cápita
gen logGDP=ln(rgdpna/pop) // logaritmo del PBI per cápita
gen logK=ln(rnna/pop) // logaritmo del stock de capital per cápita
gen logTFP=ln(rtfpna) // logaritmo de la productividad total de factores
gen openness=(csh_x-csh_m) // indicador de grado apertura de un país
gen share=csh_i // participación del capital en la formación de la producción
gen labor=emp/pop 
gen humanx=hc // indice del capital humano
```

Nuestro interés está solo en los países de Perú, Chile y Colombia.

```
* Nos quedamos solo con un conjunto de observaciones de acuerdo al país.

keep if countrycode == "PER" | countrycode == "CHL" | countrycode == "COL"
```

Compararemos el promedio del PBI per cápita de los ultimos 10 años de nuestra base.

```
bys countrycode: summ GDB if year>= 2010 & year<=2019
```

![image](https://user-images.githubusercontent.com/106888200/225218916-17619db5-ddea-4276-a84d-f4b8ef26b3da.png)


Realizaremos los graficos con la ayuda de un local para visualizar las tendencias de algunas de nuestras variables

```
local paises PER CHL COL
local graph_op `"xtitle("Año") lpattern(solid) lcolor(green) xlabel(1940(10)2020)"'

foreach x of local paises{
	line GDB year if countrycode == "`x'", `graph_op' ytitle("`x'") name("`x'" ,replace)
}
graph combine PER CHL COL, ycommon title("PBI per cápita, miles de USD")

foreach x of local paises{
	line logGDP year if countrycode == "`x'", `graph_op' ytitle("`x'") name("`x'" ,replace)
}
graph combine PER CHL COL, ycommon title("Logaritmo PBI per cápita")

foreach x of local paises{
	line logK year if countrycode == "`x'", `graph_op' ytitle("`x'") name("`x'" ,replace)
}
graph combine PER CHL COL, ycommon title("Logaritmo del stock de capital per cápita")
```

![image](https://user-images.githubusercontent.com/106888200/225219114-e0917135-6f46-47b8-ac63-465f979844f4.png)



*Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/6_merge_append.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
