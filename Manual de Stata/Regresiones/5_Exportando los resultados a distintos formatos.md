# Regresiones

### 5. ORDENANDO Y EXPORTANDO LOS RESULTADOS A DISTINTOS FORMATOS

En este modulo vamos a comenzar por explorar algunos comando bastante utilizados para el ordenamiento y exportación de resultados, tanto de regresiones como de otro tipo. Particularmente, el paquete de opciones de `estout` y `outreg2`. Ambas necesitan instalarse previamente usando `ssc install estout` y `ssc install outreg2`, respectivamente.
El objetivo es crear tablas usando los resultados de las regresiones, editarlas y ver en qué formatos se pueden exportar.

### 5.1 ESTOUT

El paquete de comandos de `estout` permite hacer tablas no solo de regresiones, pero también de estadísticos. Comencemos aprendiendo el comando `estout`. Si recuerda ya hemos usado previamente uno de los comandos de este paquete. Al momento de correr una regresión podemos usar el prefijo `estout` para ir almacenando los resultados. También podemos usar `estimates store` seguido por un nombre luego de una regresión para almacenar los resultados. Veamos un ejemplo:
   
```
reg i524a1 p208a i.p207
estimates store m1

reg i524a1 p208a i.p207 i.dpto
estimates store m2

estout m1 m2

eststo clear
eststo: reg i524a1 p208a i.p207
eststo: reg i524a1 p208a i.p207 i.dpto

estout
```

En la primera parte guardamos los resultados usando `estimates store` y en la segunda parte usamos `eststo`: En este caso i.dpto hace referencia a las categorías de regiones. Veamos el resultado.

![image](https://user-images.githubusercontent.com/106888200/224224109-fc8cf09e-db90-4e46-8596-6c1f67128588.png)


Cuando se usa `estout`, se junta los coeficientes estimados para ambos modelos y se agrega. Un problema claro con esta tabla es que no es clara. Se acumulan los resultados de las dummies por región y de la categoría base para género. Podemos editar esta tabla para mejorarla.

```
* Editando la tabla final
estout, drop(*dpto 1.p207) rename(p208a Edad 2.p207 Mujer _cons Const) ///
mlabels("(1)" "(2)") title("Tabla 1") legend ///
cells("b( star label(Coef.) fmt(2)) p(fmt(2) label(p-value))" ///
 se(fmt(2) label(S.E.)))  stats(r2 N, labels("R-cuadrado" "N. de obs."))
```

En este caso estamos agregando una serie de opciones para editar el resultado final de la tabla:

- `drop()`: Eliminamos las variables que no nos interesa agregar en la tabla final. Por ejemplo la categoría base de la variable de género y las dummies de región.
- `renam()`: Renombramos las etiquetas de las variables que están en la tabla para que se entienda mejor
- `mlabels()`: Son como los títulos de cada columna
- `title()`: El título de la tabla
- `legend`: Con esto se agrega la leyenda en las tablas.
- `cells()`: Son los resultados que se buscan presentar, en este caso b hace referencia a los betas, p al p-value y se al error estándar.
- `stats()`: Son estadísticos adicionales que se agregan al final de la tabla. En este caso el R-cuadrado y el número de observaciones.

Veamos a detalle el código para `cells()`. En este caso, además de indicar el resultado a agregar (como el beta o el error estándar), también podemos indicar algunos detalles adicionales como que se agreguen estrellas por la significancia, se cambie la etiqueta (se usa `label()` con el nombre final) y que se de formato (se usa `fmt()` indicando el formato, en este caso 2 indica dos decimales).

![image](https://user-images.githubusercontent.com/106888200/224224212-a84cacb3-d943-4cb7-8098-9e57d66e1739.png)

Ojo: en el caso de `cells()` indicamos entre comillas b, para los coeficientes, y p, para el p-value. Esto indica que se posicionan verticalmente. Mientras que, para error estándar, está fuera de la comilla por lo que se ubica debajo de los coeficientes.

### 5.2 ESTTAB

El comando `esttab` es una simplificación de `estout`. Su uso es muy similar a este pero no precisa de detallar muchas opciones.

![image](https://user-images.githubusercontent.com/106888200/224224264-201ed141-1809-4dbe-8e5f-e1728579924a.png)

Este comando permite el mismo nivel de detalle que el previo:

![image](https://user-images.githubusercontent.com/106888200/224224342-3a738894-832d-4c23-9a6b-aec92ac4f140.png)

### 5.3 EXPORTANDO EL RESULTADO

Veamos como exportar las tablas que creamos a tres tipos de formato: a formato .csv (puede ser abierto en Excel), a formato .rtf (puede ser abierto en Word u otro editor de texto) y en formato .tex (para cargar la base a una documento de LATEX). Solo hay que agregar algunas cosas adicionales al código previo. Primero, la ubicación y el formato de la tabla. Para ello usamos _esttab using "/Users/direccion/tabla_1.csv"_, o también indicando alguno de los otros formatos.

![image](https://user-images.githubusercontent.com/106888200/224224388-ab8e0df6-e3aa-409e-8370-56ee46fc39a8.png)

El documento .csv se tiene que abrir como una base de datos de texto en excel para que se pueda ver bien (Abrimos _Excel → Pestaña Datos → Desde el texto → Elegimos el archivo → Elegimos el delimitador, en este caso es coma (,)_).

![image](https://user-images.githubusercontent.com/106888200/224224588-f9161d80-59d4-4a00-8969-7ca31c8f50fc.png)

El archivo .rtf puede abrirse desde Word y el archivo .tex desde algún editor de LATEX como TexStudio u Overleaf.

### 5.4 OUTREG2

El comando `outreg2` es similar al anterior, pero tiene otro conjunto de comandos para opciones y otra forma de sintaxis. Una gran diferencia es que puede producir tablas en formato .doc, el formato directo de Word. También puede producir para exportar a LATEX. Veamos su sintaxis.

```
* Usando outreg2
ssc install outreg2 
reg i524a1 p208a i.p207
outreg2 using "$D/Results/tabla_2.doc" , ///
replace keep(p207 p208a)

reg i524a1 p208a i.p207 i.dpto
outreg2 using "$D/Results/tabla_2.doc" , ///
append keep(p207 p208a) 
```
En este caso no se ‘almacenan’ los resultados, en cambio se crea una tabla inmediatamente después de hacer una regresión. En este caso creamos un documento .doc e indicamos la opción replace para que cada vez que se corra esa línea se cree un archivo nuevo. En la segunda regresión hacemos algo similar, pero en vez de usar la opción replace usamos la opción `append` para anexar (append) los resultados a la tabla creada líneas arriba. En este caso usamos la opción `keep()` para quedarnos con un subconjunto de variables. Veamos el resultado:
La tabla, al menos en Word, parece estár más detallada que en el caso del formato .rtf de estout. Al menos si planea solo usar Word para editar sus tablas puede ser preferible practicar más usando el comando `outreg2`.

![image](https://user-images.githubusercontent.com/106888200/224224669-d8cd196a-0d5b-4ba2-9eb4-f121bed0c466.png)


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|   |  |   |
|   |  |   |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")*
