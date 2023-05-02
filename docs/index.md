---
# STATA ECOPUCP 
---

### Repositorio 

[Main repo Stata](https://github.com/EconPUCP/Stata)


----

Esta es una Guía de análisis de datos en Stata. Esta guía contiene instrucciones y código para los análisis estadísticos y econométricos más frecuentes en la investigación de problemas económicos. Esta guía sigue el principio de programación de escribir código consistente, fácil de leer, transparente y reproducible.


### Índice resumido


| Sección | Contenido |  Aplicaciones |  
|:--|:-------|:------|  
| Video tutoriales  |  Replicación de tesis de Nicolás Barrantes (probit, pobreza multidimensional), replicación de tesis de Angelo Cozzubo (dinámicas de la pobreza; análisis, cuantificación, tipificación de las transiciones) |  |  
| [Conceptos básicos](https://github.com/EconPUCP/Stata/tree/main/Manual%20de%20Stata/Conceptos%20b%C3%A1sicos "Conceptos básicos")   |  Conocer la interfaz, crear e importar datos, fusionar y anexar bases de datos, manipular distintos formatos de datos | [Fusionar módulos de la ENAHO](https://github.com/EconPUCP/Stata/blob/main/Manual%20de%20Stata/Conceptos%20b%C3%A1sicos/Aplicaci%C3%B3n%20Fusi%C3%B3n%20entre%20los%20m%C3%B3dulos%20de%20la%20ENAHO.md "Fusionar módulos de la ENAHO") |  
| [Manipulación de variables](https://github.com/EconPUCP/Stata/tree/main/Manual%20de%20Stata/Creaci%C3%B3n%2C%20manipulaci%C3%B3n%20y%20descripci%C3%B3n%20de%20variables "Manipulación de variables")  | Usar comandos de manipulación, reestructurar datos, crear rutinas con loop, realizar análisis descriptivos y exploratorios | [Crear un reporte macroeconómico usando la Penn World Table PWT10.01](https://github.com/EconPUCP/Stata/blob/main/Manual%20de%20Stata/Creaci%C3%B3n%2C%20manipulaci%C3%B3n%20y%20descripci%C3%B3n%20de%20variables/Aplicaci%C3%B3n%20usando%20PWT10.01.md "Crear un reporte macroeconómico usando la Penn World Table PWT10.01") |  
| [Gráficos y mapas](https://github.com/EconPUCP/Stata/tree/main/Manual%20de%20Stata/Gr%C3%A1ficos%20y%20mapas "Gráficos y mapas")   | Conocer los gráficos de Stata, crear mapas y georreferenciación, exportar gráficos | [Crear un mapa a partir del Censo Nacional de comisarias CENACOM 2017](https://github.com/EconPUCP/Stata/blob/main/Manual%20de%20Stata/Gr%C3%A1ficos%20y%20mapas/4_Aplicaci%C3%B3n.md "Crear un mapa a partir del Censo Nacional de comisarias CENACOM 2017") |  
| [Regresiones](https://github.com/EconPUCP/Stata/tree/main/Manual%20de%20Stata/Modelo%20de%20Regresi%C3%B3n%20lineal "Regresiones")  | Estimar e interpretar regresiones; utilizar resultados de post-estimación, stored results, variables categóricas e interacciones; evaluar multicolinealidad y heterocedasticidad, realizar diseño muestral, ordenar y exportar resultados, contrastar hipótesis, lidiar con la endogeneidad: usar variables instrumentales, estimar con el método generalizado de momentos (GMM); analizar los supuestos de las variables instrumentales; | [Replicar estadísticas oficiales del INEI](https://github.com/EconPUCP/Stata/blob/main/Manual%20de%20Stata/Modelo%20de%20Regresi%C3%B3n%20lineal/4_Aplicaci%C3%B3n%20Replicando%20estadisticas%20oficiales%20del%20INEI.md "Replicar estadísticas oficiales del INEI") - [Estimar una ecuación de Mincer básica](https://github.com/EconPUCP/Stata/blob/main/Manual%20de%20Stata/Modelo%20de%20Regresi%C3%B3n%20lineal/9_Aplicaci%C3%B3n%20Estimaci%C3%B3n%20de%20una%20ecuaci%C3%B3n%20de%20Mincer%20B%C3%A1sica.md "Estimar una ecuación de Mincer básica") |
| Modelos de series de tiempo  |  Manipular variables de fecha, manipular datos de series de tiempo con operadores de rezagos, adelantos y diferencias; producir gráficos de series de tiempo; usar comandos de filtros y suavización de series: tsfilter y tssmoth; simular con modelos AR, MA y ARMA; diagnóstico de modelos: estacionariedad, selección de rezagos; pronóstico de valores; estimar modelos ARCH y GARCH; | _Reading week_ |  
| Modelos binomiales y extensiones multinomiales  | Estimar el modelo de probabilidad lineal o modelos binomiales, estimar modelos probit y logit, estimar extensiones multinomiales: logit multinomial, logit ordenado | Estimar un modelo VAR con series del BCRP |   
| Modelos de datos de panel | Usar y estimar modelos de panel de datos, seleccionar el modelo más apropiado: efectos fijos, datos agrupados, efectos aleatorios, test F, test de Hausman, testparm|  |  
| Evaluación de impacto  | Propensity Score Matching (PSM), Diferencias en diferencias, Diseño de Regresión Discontinua (RDD) |  |  
| Replicación de tesis |   |  |  
| Manejo de base de datos |  Micro: corregir el problema de las tildes y "Ñ" en los módulos de la ENAHO con el comando latin1 Macro: limpiar y preparar una base de datos con la ENAHO, limpiar y preparar una base de datos con la ENAHO PANEL, limpiar y preparar series mensuales del BCRP, limpiar y preparar series trimestrales del BCRP, limpiar y fusionar varias series del BCRP |  |  
| Bases de datos | Descargar bases de datos Nacionales e Internacionales, descargar shapefiles (shp) |  |  
| Recursos  | Repositorios, cursos, manuales y videos de aprendizaje de Stata | |  

----

### Equipo
Consultor responsable: César Cornejo Román

Practicante preprofesional: Gladys Godines Sanchez

Director de la especialidad de economía PUCP: José Carlos Orihuela

Jefa del Departamento de Economía PUCP: Janina León Castillo

Decano de la Facultad de Ciencias Sociales PUCP:  Carlos Eduardo Aramburú

----

### Antecedentes

En la especialidad de Economía de la PUCP, se contaba con los siguientes documentos: Nuevo plan de estudios de economía, Requerimientos mínimos para la sección de prácticas en la especialidad de Economía y Manual de Stata 2022 elaborado por Yasmeen Destre-Roldan y José Antonio Mendoza. En su conjunto, estos documentos establecieron la línea de partida para desarrollar el Repositorio.

----

### El proyecto
El proyecto se realizó en 2 fases: identificación de necesidades y recursos disponibles y desarrollo de contenido. 
En la fase 1, para identificar, organizar y analizar los recursos disponibles para la enseñanza de programación en Stata para economistas, se elaboró los siguientes productos intermedios: 

1) Compilación y análisis de recursos disponibles vinculados con la especialidad o el Departamento de Economía PUCP

2) Compilación y análisis de recursos de enseñanza en programación intermedia en Stata.
Para identificar las necesidades de programación para escribir una tesis de licenciatura en economía, se completó la siguiente tarea: 

3) Análisis de necesidades de programación en las tesis sustentadas para obtener el título profesional de Licenciado en Economía entre 2011 y 2023
Luego de completado el análisis de las tesis, para escoger los análisis estadísticos y econométricos más apropiados para presentar en video tutoriales, se completó la siguiente tarea:

4) Creación de un proceso de replicación de tesis
En la fase 2, se elaboró el contenido publicado en la página web https://econpucp.github.io/ y en el repositorio https://github.com/EconPUCP/Stata a partir de los mejores recursos identificados (de fuentes internas o externas) y se redactó un informe final presentado a la facultad de Ciencias Sociales de la PUCP en abril del 2023
