# Gráficos y mapas

### 3. EXPORTAR GRÁFICOS

Luego de crear los gráficos que necesitamos hay distintas opciones de almacenamiento. Una de ellas puede ser dando clic derecho y guardando en la carpeta y formato deseado. Esta opción implica guardarlo manualmente cada vez que tengamos un resultado nuevo. Para evitar eso, podemos usar código y hacer el proceso de guardado automático. Para ello vamos a usar la opción graph export.

Para guardar/exportar el gráfico debemos seleccionar la carpeta en donde se almacenará y además el formato.

```
use IfoGAME
hist mag 
graph export "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Results/grafico_1.png", replace
```

En este caso, luego de indicar la carpeta, llamamos a nuestro gráfico ‘grafico_1.png’ para indicar que se guarde en formato .png.

> **TIPS: datos espaciales**
>
> Stata tiene una función básica de importación y exportación para archivos de forma shp. Puedes calcular un montón de nuevas variables y exportarlas a archivos de forma shapefiles para usar con software GIS como QGIS/ArcGIS. 
> Para tener más información recuerda textear en tu ventana de comando `help import shp`.


## Sigue aprendiendo
| Recurso  | Tema | Descripción |
| ------------- |:-------------:|:-------------:|
|  |  |   |
|   |  |  |


****Puedes usar el kit de replicación de este módulo obteniendo el [script](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Scripts/Conceptos%20b%C3%A1sicos "script") y [base de datos](https://github.com/Gladys91/Proyecto_STATA/tree/main/_An%C3%A1lisis/Data "base de datos")* 
