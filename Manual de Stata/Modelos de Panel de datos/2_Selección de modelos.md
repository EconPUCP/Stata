# Panel de datos

### 2 SELECCIÓN DE MODELOS

Luego de ver todos los modelos que se pueden usar podemos definir algunos criterios estadísticos para seleccionar cuál modelo sería pertinente.
Veamos:

- Efectos Fijos vs Datos agrupados:  test F
Para comparar el modelo de efectos fijos con el modelo de datos agrupados se usa el test F cuando estimamos el modelo de panel con efetos fijos. 

![image](https://user-images.githubusercontent.com/128189216/227427882-89ab6f2a-106b-4890-8fa9-0a87b4739371.png)

El p-value de este test nos indica que rechazamos la hipótesis nula por lo que aceptamos que el modelo de efectos fijos es más adecuado que el de datos agrupados.

- Efectos Aleatorios vs Datos agrupados: test de Breusch-Pagan

![image](https://user-images.githubusercontent.com/128189216/227428566-80901324-a322-43bb-86c5-33a6d48f7921.png)

El p-value de este test nos indica que rechazamos la hipótesis nula por lo que aceptamos que el modelo de efectos aleatorios es más adecuado que el de datos agrupados.

- Efectos Fijos vs Efectos Aleatorios: test de Hausman

![image](https://user-images.githubusercontent.com/128189216/227429527-1e789cd9-3cbd-494d-b23c-1805f821eec3.png)

- Efectos Fijos por individuo vs Efectos fijos temporales: testparm

![image](https://user-images.githubusercontent.com/128189216/227430252-15331d6f-7a27-4412-b2b0-e62a30e636dc.png)

El p-value de este test nos indica que aceptamos la hipótesis nula por lo que aceptamos que el modelo de efectos fijos es más adecuado que el modelo de efectos fijos temporales.


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|               |        |         |
|               |        |         |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/blob/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos/5_Importar_datos.do "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
