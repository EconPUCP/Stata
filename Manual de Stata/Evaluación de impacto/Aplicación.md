# APLICACIÓN

Para integrar todos los puntos de la sesión, usaremos los datos del módulo
de empleo de la Encuesta Nacional de Hogares.

- Creemos un do-file 
- Importamos la base de datos
- Fusionamos distintos módulos de la encuesta
- Identificamos los distintos tipos de variables que hay


La Encuesta Nacional de Hogares -  ENAHO  es la investigación que permite al Instituto Nacional de Estadística e Informática (INEI) efectuar el seguimiento de
los indicadores sobre las condiciones de vida. En _tipo de encuesta_ puedes encontrar _ENAHO la metodología anterior_ y _ENAHO metodología actualizada_, con respecto al tipo de datos puedes encontrar _condiciones de vida y pobreza - ENAHO_ y _condiciones de vida y pobreza - ENAHO PANEL_.

Trabajaremos con el modulo 1 (caracteristicas de la vivienda y del hogar) y el modulo 34 (sumaria - variables calculadas) de la _ENAHO metodología actualizada_ y _condiciones de vida y pobreza - ENAHO_ del año 2020.

Podemos descargar los módulos directamente desde la [_base de microdatos del INEI_](https://proyectos.inei.gob.pe/microdatos/ "_ base de microdatos del INEI_") y descomprimirlos o descargalos ya descomprimidos y limpios desde el siguente [enlace](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "enlace").

Abrimos nuestro dofile desde la ventata de comandos con el comando `doedit` y digitamos la dirección de nuestro directorio:

```
*Preambulo 

cd "C:/Users/Usuario/Documents/GitHub/Proyecto_STATA/_Análisis/Data" // Se debe cambiar por la dirección dónde 
                                                                     // se encuentra tu base de datos

```

Ahora fusionaremos el módulo 1: caracteristicas de la vivienda y del hogar con Sumaria: variables calculadas con el comando `merge`

```
use "enaho01-2020-100.dta", clear

merge 1:1 conglome vivienda hogar using "sumaria-2020.dta"
br
```

Para identificar los distintos tipos de variables que tiene nuestra base de datos usamos el comando `describe`.

```
describe
```


*Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/6_merge_append.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
