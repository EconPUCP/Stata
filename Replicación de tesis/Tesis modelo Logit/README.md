# Tesis: Desigualdades horizontales entre las personas con discapacidad de movilidad en el Perú: Brechas en la situación de pobreza multidimensional según la procedencia étnica

__Autor:__ Nicolás Barrantes Gamba 


Esta tesis analiza las desigualdades horizontales según la procedencia étnica dentro de la población de personas con discapacidad de movilidad (PcDM).
Esta sección del repositorio contiene el código completo para la replicación de los análisis estadísticos y econométricos de esta tesis (carpeta script), los datos necesarios para la replicación (carpeta data), los resultados (carpeta results). Esta página (archivo README.md) orienta al usuario para replicar las diferentes secciones y análisis de las tesis.


# Objetivo: 

evaluar empíricamente las posibles desigualdades horizontales entre las personas con discapacidad de movilidad (PcDM) indígenas y no indígenas en términos de pobreza multidimensional. La pobreza multidimensional se entiende como la experiencia de sufrir privaciones en varias dimensiones centrales de la vida humana, según lo conceptualizado por Amartya Sen en sus obras.

# Hipótesis: 
pertenecer al grupo indígena coloca a las PcDM en una posición de desventaja en términos de pobreza multidimensional en comparación con aquellas que no son parte de un grupo indígena.

# Metodología

sigue Clausen (2015) grupo de adultos mayores en el Perú

| 4. Metodología  |
| :------------- | 
| 4.1. Identificación de la Población Indígena | 
| 4.2. Decisiones Normativas: La Elección de las Dimensiones de la Pobreza | 
| 4.3. Metodología de Identificación y Agregación de Pobreza Multidimensional | 
| 4.4 Indicador de Desigualdad Intergrupal en Pobreza Multidimensional | 
| 4.5. Modelos Econométricos y Métodos de Estimación | 
| 4.6. Datos | 


__3 etapas:__

Utilizando los datos disponibles en la Encuesta Nacional Especializada sobre Discapacidad (ENEDIS) de 2012 en torno a la lengua materna y el auto-reporte del origen étnico, se definen las variables que permiten identificar a los grupos de PcDM indígena y no indígena.

Se elabora una propuesta de dimensiones de la pobreza específicas para las PcDM.
Finalmente, en base a dicha elección de dimensiones de la pobreza y a partir de la familia de indicadores de pobreza multidimensional basados en la metodología de Alkire y Foster, se realizan comparaciones cuantitativas entre las PcDM indígenas y no indígenas para evaluar las brechas en la situación de pobreza multidimensional. Estas comparaciones se realizan aplicando tres tipos de ejercicios estadísticos a partir de los datos provistos por la ENEDIS 2012.

El primero consiste en generar estadísticas descriptivas para conocer la cantidad de privaciones que sufren las PcDM indígenas y no indígenas, cuantificar la proporción de PcDM en situación de pobreza multidimensional en estos grupos y calcular un índice de pobreza multidimensional (IPM) para cada uno de los mismos. A partir de esto, se calculan las brechas en la situación de pobreza multidimensional según la procedencia étnica y se evalúa su significancia estadística.

El segundo ejercicio consiste en calcular un indicador que cuantifica la magnitud de las desigualdades que existen en la situación de pobreza multidimensional entre los grupos de comparación. 

El último ejercicio consiste en la estimación de modelos econométricos tipo logit que permitan establecer la relación entre la etnicidad y la probabilidad de ser pobre multidimensional para las PcDM, controlando por diferentes variables. En términos generales, los resultados de los distintos ejercicios empíricos muestran que la pertenencia al grupo indígena coloca a las PcDM en una peor situación en términos de pobreza multidimensional respecto a las no indígenas


__4.1. Identificación de la Población Indígena__

Tareas:

Identificar claramente a los dos grupos dentro de la población con discapacidad de movilidad que van a ser comparados: los indígenas y los no indígenas

La ENEDIS permite realizar esta identificación a partir de dos indicadores. El primero es el de lengua materna (disponible para personas de 3 años de edad o más) y el segundo es el de auto-reporte (disponible para personas de 12 años de edad o más)

Indicador idea: etnicidad por lugar de origen
ENEDIS 2012 no tiene ese dato a nivel provincial ni distrital

Decisión: indicador de etnicidad conservador

__4.2. Decisiones Normativas: La Elección de las Dimensiones de la Pobreza__

__Tabla 3.__ Comparación entre las definiciones de la lista ideal y la lista factible

| Dimensión | Lista Ideal | Lista Factible| 
| :------------- | :------------- | :------------- | 

__Anexo A:__ Criterios de Alkire (2007) para la elección de dimensiones

En cuanto a la metodología de elección de dimensiones previamente enunciada, se elaboraron dos listas: una ideal y otra factible. La lista ideal consta de diez dimensiones: 1) Vida Saludable; 2) Educación; 3) Conectividad Social; 4) Ausencia de Humillación; 5) Accesibilidad Física; 6) Condiciones de Vivienda; 7) Servicios Básicos; 8) Participación Política; 9) Empleo; 10) Agencia.

agencia es una dimensión de la lista ideal que no se evalúa en la lista factible por ausencia de data

__4.3. Metodología de Identificación y Agregación de Pobreza Multidimensional__

metodología de identificación y agregación de Alkire-Foster



-----
__Contribuciones:__ El código fue proporcionado por el autor de la tesis (Nicolás Barrantes Gamba), editado y organizado por César Cornejo Román y Gladys Godines Sánchez, quienes construyeron el paquete de replicación siguiendo los estándares de la American Economics Association. La página fue elaborada por . El videotutorial fue creado y producido por .
