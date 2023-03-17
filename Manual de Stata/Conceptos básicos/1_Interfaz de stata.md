# Conceptos Básicos

## 1.  CONOCIENDO LA INTERFAZ
---------------------------------

### 1.1 LA INTERFAZ DE STATA
La interfaz de Stata se compone de distintas ventanas. Conozcamos algunas:

- Ventana de Resultados (Results Window)

Cuando comiences a usar Stata para analizar tus datos, todos tus comandos, resultados o mensajes de errores recientes aparecerán en la venta de resultados. El scroll del lado derecho puede ser usado para ver resultados previos que no están en la pantalla. Sin embargo, la ventana de resultado no mantiene todos los resultados generados. Por default, solo mantendrá alrededor de 500 líneas del resultado más reciente y eliminará los resultados más antiguos. Si deseas almacenar los resultados de algún archivo se debe usar un log-file.

![1](https://user-images.githubusercontent.com/106888200/223146630-9b61c225-1f45-45f7-91dc-297ca21e7270.JPG)


- Ventana de revisión (Review Window)

Esta ventana lista todos los comandos recientes. Si se le da click en algunos de ellos, este será copiado a la ventana de comandos en donde puede ser ejecutado al apretar Enter. si se le da doble click el comando se ejecutará.

![ventana_revisión](https://user-images.githubusercontent.com/106888200/223146688-a98bdefe-f1da-434b-8b42-fd92cee86018.JPG)


- Ventana de Comando (Command Window)

Esta ventana permite introducir comandos que serán ejecutados de manera inmediata. También, puede usar comandos recientes apretando la tecla‘Page Up’ o ‘Page Down’ para regresar. Si se da doble click en una variable de la ventana de comandos, la variable aparecerá en la ventana de comandos.

![ventana de comando](https://user-images.githubusercontent.com/106888200/223146758-7e18418f-293f-4503-8704-a7abf5e3519c.JPG)

- Ventana de Variables (Variables Window)

Esta ventana lista todas las variables de la base de datos que se abre. Se puede aumentar el tamaño de esta ventana para poder ver el nombre completo. Las variables nuevas serán agregadas aquí; y, de igual manera, las variables eliminadas serán borradas de aquí. Se pueden insertar variables en la ventana de comandos haciendo doble click en la ventana de variables.

![ventana_variables](https://user-images.githubusercontent.com/106888200/223146826-9d01e5d8-1692-48bf-9ad5-3dc282175d05.JPG)


- Ventana de Propiedades (Properties Windows)

La ventana de propiedades provee información acerca de las variables abiertas en la base de datos. Si se da click a una variable en la ventana de variables, la ventana de propiedades dará información acerca de esta variable referida al nombre, la etiqueta y el tipo de variable así como otro tipo de información de la base.

![ventana_propiedades](https://user-images.githubusercontent.com/106888200/223146870-3f56b29f-d501-4ea9-b933-fc18208e5809.JPG)

- Navegador de datos (Data Browser)

El navegador de datos permite visualizar los datos como si fuera una hoja de cálculo. Una forma de acceder al navegador es escribiendo el comando `browse` en la ventana de comando. Al acceder mediante `browse` solo se puede visualizar los datos, si se desea editar se debe acceder mediante el comando `edit`.

![image](https://user-images.githubusercontent.com/106888200/223147450-c2bc3497-a5cb-4716-9995-1e04a2f1737a.png)

> **TIPS: preferencias de la interfaz de Stata**
>
> * Podemos cambiar el color de la interfaz haciendo   *click derecho  → preferencias → general → esquema de color general → seleccionar color de preferencia*
>* Podemos cambiar la disposición de las ventanas de Stata siguiendo la ruta *Edición → Preferencias → Cargar conjunto de preferencias → seleccionar diseño de preferencia*


### 1.2 DO-FILES
En vez de introducir comandos de manera directa en la ventana de comandos, se puede crear un archivo de texto que contenga los comandos e instrucciones de Stata para que puedan ser ejecutados. Estos archivos son llamados do-files.
Trabajar de esta manera ofrece una serie de ventajas. Al escribir cada paso que se toma en el manejo y análisis de los datos en forma de un do-file, el trabajo se hace reproducible. De igual manera, el do-file facilita cualquier proceso de debugging (o limpieza de código) así como de edición de algunos comandos o comentarios. Lo contrario implicaría volver a realizar todo el análisis desde cero.
Para abrir el editor de do-files usamos el comando `doedit` en la ventana de comando. Abramos el editor de do-files:

![image](https://user-images.githubusercontent.com/106888200/223150193-140adef9-61a8-44b1-9aa0-e16d8e0ec52c.png)

Veamos cómo crear, guardar y correr un do-file.

![image](https://user-images.githubusercontent.com/106888200/221929452-04507ab4-e664-464b-b4a2-f089ec4a09e3.png)

Luego de guardar un do-file, podemos ejecutarlo dentro de otro do-file mediante el comando `do` seguido por el nombre del archivo junto a la dirección de su respectiva carpeta. También puede utilizarse el comando `run`. Ambos comandos son útiles cuando se necesita ejecutar un conjunto de código almacenado en otro do-file. Mientras que el comando do genera un resultado visible en la ventana de resultados, el comando run ejecuta el mismo código pero sin generar un resultado en la ventana de resultados:

![image](https://user-images.githubusercontent.com/106888200/223153748-2bfc7624-4bbc-4a72-819f-688288268d70.png)


#### 1.2.1 Comentarios en do-files

Hay cuatro maneras de incluir comentarios en un do-file:

- Comenzar una línea con ‘*’ , todo lo escrito después en la misma línea será ignorado.
- Comentar entre ‘/* */’, todo lo que esté dentro de estos delimitadores será ignorado.
- Comentar luego de //, todo lo escrito después en la misma línea será ignorado.
- Comentar luego de ///, todo lo escrito después en la misma línea será ignorado. Sin embargo, cuando se usa ///, la siguiente línea se junta con la línea previa. /// permite partir una línea de código largo en múltiples líneas.
Esta última forma de comentario permite hacer manejables y entendibles líneas de código largas.


### 1.3 LOG-FILES
Un log-file graba todos los comandos y resultados de Stata de una sesión dada, con excepción de los gráficos. A veces es útil mantener una copia del trabajo que se ha realizado en algún proyecto para hacer revisión de los resultados o del estudio en sí.
Un log-file es un archivo separado con extensión ‘.log’ o ‘.smcl’ . Guardar los resultados en formato ‘.smcl’ (‘Stata Markup and Control Language file’) mantiene el formato de la ventana de resultados. Mientras que guardar los resultados en formato ‘.log’ remueve los resultados y los guardo en formato de texto simple para poder ser abierto en cualquier editor de texto. El formato ‘.smcl’ solo puede ser abierto en Stata.
Para almacenar los resultados de un do-file en un log-file usamos el comando `log using` seguido por nombre el log-file junto a la dirección en donde será almacenado. Al final del código, debemos cerrar el log-file con el comando `log close`. En el resultado anterior se obtuvo un log-file en formato smcl. Para guardarlo en formato ‘.log’ debemos usar la opción text al final del comando. Veamos:

![image](https://user-images.githubusercontent.com/106888200/221932322-4049b49a-bc94-47d6-ae3d-16098267b023.png)


### 1.4 COMANDO DE AYUDA

Una primera fuente de ayuda para entender la sintaxis de comandos no conocidos es revisar las opciones de ayuda de Stata. Veamos tres opciones:
- La opción `Help` en la pantalla genera un menú desplegable con distintas opciones de ayuda.
- El comando `help` permite ver la documentación de un comando en específico, de manera que tanto la descripción como las distintas opciones del comando aparecen.
- El comando `search` permite hacer una búsqueda de documentación a partir de una palabra clave.

### 1.5 FORMATOS DE STATA

Los archivos propios de stata se guardan en distintos formatos.
- Los do-files se guardan con extensión ‘.do’.
- Los archivos de datos se guardan con extensión ‘.dta’.
- La extensión ‘.ado’ contiene programas que se pueden correr en Stata. No todos los comandos que se usan se crean en un archivo ado (ado-file), para ver esto se puede usar la opción which. Este comando permite también identificar la carpeta de almacenamiento del ado-file.

Stata no solo puede trabajar con estos archivos, como veremos a través del curso Stata permite usar datos en otros formatos.



#### 1.5.1 Identificando archivos en una carpeta

Los archivos do-files aparecen como ‘Archivo DO’ en la carpeta en donde están:

![image429](https://user-images.githubusercontent.com/106888200/223158412-ff17db26-6a86-4757-b924-91332d57ef08.png)

De igual manera, las bases de datos en formato ‘.dta’ también aparece como ‘Archivo DTA’:

![image431](https://user-images.githubusercontent.com/106888200/223158391-62b29117-89e7-4aae-8faf-0a25f05fe120.png)


#### 1.5.2 ado-files

Usemos el comando `which` para ver la ubicación de un comando que será bastante usado a lo largo de las sesiones, regress.

![image432](https://user-images.githubusercontent.com/106888200/223158711-534453be-7703-4af1-8388-c1aefca45c7d.png)

Vayamos a la carpeta mencionada en la ventana de resultados para ver qué encontramos...

![image433](https://user-images.githubusercontent.com/106888200/223159229-1e4e5a0d-fe72-467d-892d-8bff6cb12305.png)

## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
| UCLA - Stata learning module  | [Getting help](https://stats.oarc.ucla.edu/stata/modules/getting-help-using-stata/ "Getting help") | Cómo obtener ayuda en Stata  |
| UCSF GSI  | [Thinking like Stata](https://www.youtube.com/watch?v=jTtIREfhyEY&t=108s&ab_channel=UCSFGSI "Thinking like Stata") | Manejar la sintaxis de los comandos en Stata  |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
