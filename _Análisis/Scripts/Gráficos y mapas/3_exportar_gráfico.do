************
*PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_exportar_gráfico.do
* OBJETIVO: Exportación de gráficos
************

* Preambulo 

clear all
cd "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Data" // cambiar cd

**************************************************
use IfoGAME
hist mag 
graph export "C:\Users\Usuario\Documents\GitHub\Proyecto_STATA\_Análisis\Results/grafico_1.png", replace