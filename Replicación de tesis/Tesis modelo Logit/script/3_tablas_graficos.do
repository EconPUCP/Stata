*******************************************
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ
* SCRIPT: 3_tablas_graficos.do
* OBJETIVO: Indice de privación para PcDM
*******************************************

* Limpiar la memoria del programa
*=================================
clear all 

* Definición de rutas (carpetas)
*================================
global root "C:\Users\Usuario\Desktop\Replica Nicolas" // cambiar directorio
global data "$root/data"
global cleaned "$root/cleaned"

* Abrir base de datos
*=====================
use "$cleaned/data_para_analisis.dta", clear

*Especificación 
*================                                                            
global A = "enfermedad seguro tratamiento educacion ayuda trato_diferenciado traslado materiales hacinamiento tenencia agua saneamiento electricidad" // GRUPO A: 3 años a más 
global B = "enfermedad seguro tratamiento educacion ayuda trato_diferenciado traslado materiales hacinamiento tenencia agua saneamiento electricidad voto empleo" // GRUPO B: 18 años a 64 años 
global pobre_A  "pobre_k1_A pobre_k2_A pobre_k3_A pobre_k4_A pobre_k5_A pobre_k6_A pobre_k7_A pobre_k8_A pobre_k9_A"
global pobre_B "pobre_k1_B pobre_k2_A pobre_k3_B pobre_k4_B pobre_k5_B pobre_k6_B pobre_k7_B pobre_k8_B pobre_k9_B"
global c_k_A "c_k1_A c_k2_A c_k3_A c_k4_A c_k5_A c_k6_A c_k7_A c_k8_A c_k9_A"
global c_k_B "c_k1_B c_k2_B c_k3_B c_k4_B c_k5_B c_k6_B c_k7_B c_k8_B c_k9_B"
*===========================
*ESTADÍSTICAS DESCRIPTIVAS 
*===========================

*Estadísticas de los indicadores de pobreza multidimensional

****Tabla 7.A 
sum c_i_A c_k3_A pobre_k3_A $A if (l_movilidad==1 & edad>=3) 

****Tabla 7.B
sum c_i_B c_k3_B pobre_k3_B $B if (l_movilidad==1 & edad>=18 & edad<=64) 

*Estadísticas de las variables exógenas incluidas en el modelo

****Tabla 8.A
sum indigena mujer rural edad edad2 l_visual_grave_completa l_comunicativa l_auditiva_grave_completa l_aprendizaje l_relacional l_enfermedad jefe vive_solo lima_callao mieperhog programa_social if (l_movilidad==1 & edad>=3)

****Tabla 8.B
sum indigena mujer rural edad l_visual_grave_completa l_comunicativa l_auditiva_grave_completa l_aprendizaje l_relacional l_enfermedad jefe vive_solo lima_callao mieperhog programa_social if (l_movilidad==1 & edad>=18 & edad<=64)

*============================================
* INDICADORES DE PRIVACIÓN SEGÚN ETNICIDAD
*============================================

****Gráfico 5.A
foreach var in $A {	
     mean `var' if (l_movilidad==1 & edad>=3) [iw=FACTOR_PCD], over(indigena)
}

****Gráfico 5.B
foreach var in $B {	
    mean `var' if (l_movilidad==1 & edad>=18 & edad<=64) [iw=FACTOR_PCD], over(indigena)
	}

*==================================================
* CÁLCULO DEL INDICE DE POBREZA MULTIDIMENSIONAL
*==================================================

* Incidencia de Pobreza Multidimensional en PcDM según etnicidad
*============================================================================

****Gráfico 1.A
mean $pobre_A if (l_movilidad==1 & edad>=3) [iw=FACTOR_PCD]  

****Gráfico 1.B
mean $pobre_B  if (l_movilidad==1 & edad>=18 & edad<=64) [iw=FACTOR_PCD]  

****Gráfico 6.A
mean $pobre_A if (l_movilidad==1 & edad>=3) & indigena==1 [iw=FACTOR_PCD]
mean $pobre_A if (l_movilidad==1 & edad>=3) & indigena==0 [iw=FACTOR_PCD]                

****Gráfico 6.B
mean $pobre_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==1 [iw=FACTOR_PCD]
mean $pobre_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==0 [iw=FACTOR_PCD]


* Índice de Pobreza Multidimensional en PcDM según etnicidad
*==================================================================

****Gráfico 2.A
mean $c_k_A if (l_movilidad==1 & edad>=3) [iw=FACTOR_PCD]

****Gráfico 2.B
mean $c_k_B if (l_movilidad==1 & edad>=18 & edad<=64) [iw=FACTOR_PCD]               

****Gráfico 7.A
mean $c_k_A if (l_movilidad==1 & edad>=3) & indigena==1 [iw=FACTOR_PCD]
mean $c_k_A if (l_movilidad==1 & edad>=3) & indigena==0 [iw=FACTOR_PCD]  

****Gráfico 7.B
mean $c_k_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==1 [iw=FACTOR_PCD]
mean $c_k_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==0 [iw=FACTOR_PCD]

****Tabla 9.A
mean $c_k_A if (l_movilidad==1 & edad>=3) & indigena==1 [iw=FACTOR_PCD]
mean $c_k_A if (l_movilidad==1 & edad>=3) & indigena==0 [iw=FACTOR_PCD]
mean $c_k_A if (l_movilidad==1 & edad>=3) & indigena!=. [iw=FACTOR_PCD]

****Tabla 9.B
mean $c_k_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==1 [iw=FACTOR_PCD]
mean $c_k_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==0 [iw=FACTOR_PCD]
mean $c_k_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena!=. [iw=FACTOR_PCD]

* Intensidad de la Pobreza Multidimensional en PcDM según etnicidad
*===================================================================

****Gráfico 8.A
foreach x of numlist 1/9{
    mean cc_k`x'_A if (l_movilidad==1 & edad>=3) [iw=FACTOR_PCD], over(indigena)
}                 

****Gráfico 8.B
foreach x of numlist 1/9{
    mean cc_k`x'_B if (l_movilidad==1 & edad>=18 & edad<=64) [iw=FACTOR_PCD], over(indigena)
} 

*============================
* DESGLOSE POR INDICADORES
*============================
*Grupo A
foreach var in $A {	
    gen c_`var'_k3_A= `var' if (l_movilidad==1 & edad>=3) & pobre_k3_A==1  
	replace c_`var' = 0 if (l_movilidad==1 & edad>=3) & pobre_k3_A==0
	}
	
mean c_enfermedad_k3_A c_seguro_k3_A c_tratamiento_k3_A c_educacion_k3_A c_ayuda_k3_A c_trato_diferenciado_k3_A c_traslado_k3_A c_materiales_k3_A c_hacinamiento_k3_A c_tenencia_k3_A c_agua_k3_A c_saneamiento_k3_A c_electricidad_k3_A if (l_movilidad==1 & edad>=3) & indigena==1 [iw=FACTOR_PCD]

mean c_enfermedad_k3_A c_seguro_k3_A c_tratamiento_k3_A c_educacion_k3_A c_ayuda_k3_A c_trato_diferenciado_k3_A c_traslado_k3_A c_materiales_k3_A c_hacinamiento_k3_A c_tenencia_k3_A c_agua_k3_A c_saneamiento_k3_A c_electricidad_k3_A if (l_movilidad==1 & edad>=3) & indigena==0 [iw=FACTOR_PCD]
		
*Grupo B	
foreach var in $B {	
    gen c_`var'_k3_B = `var' if (l_movilidad==1 & edad>=18 & edad<=64) & pobre_k3_B==1  
	replace c_`var'_k3_B  = 0 if (l_movilidad==1 & edad>=18 & edad<=64) & pobre_k3_B==0
	}
	
mean c_enfermedad_k3_B c_seguro_k3_B c_tratamiento_k3_B c_educacion_k3_B c_ayuda_k3_B c_trato_diferenciado_k3_B c_traslado_k3_B c_materiales_k3_B c_hacinamiento_k3_B c_tenencia_k3_B c_agua_k3_B c_saneamiento_k3_B c_electricidad_k3_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==1 [iw=FACTOR_PCD] 

mean c_enfermedad_k3_B c_seguro_k3_B c_tratamiento_k3_B c_educacion_k3_B c_ayuda_k3_B c_trato_diferenciado_k3_B c_traslado_k3_B c_materiales_k3_B c_hacinamiento_k3_B c_tenencia_k3_B c_agua_k3_B c_saneamiento_k3_B c_electricidad_k3_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==0 [iw=FACTOR_PCD] 
	
*===================
* GRÁFICOS DE PYE
*===================
****Gráfico 3.A  
tab c_i_A if (l_movilidad==1 & edad>=3) & indigena==1 [iw=FACTOR_PCD]
tab c_i_A if (l_movilidad==1 & edad>=3) & indigena==0 [iw=FACTOR_PCD]

****Gráfico 3.B 
tab c_i_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==1 [iw=FACTOR_PCD]
tab c_i_B if (l_movilidad==1 & edad>=18 & edad<=64) & indigena==0 [iw=FACTOR_PCD]


*===================
* REGRESIONES
*===================
****Tabla 10.A 
foreach x of numlist 1/9{

quietly logit pobre_k`x'_A indigena mujer rural edad edad2 l_visual_grave_completa l_comunicativa l_auditiva_grave_completa l_aprendizaje l_relacional l_enfermedad jefe vive_solo lima_callao mieperhog if (l_movilidad==1 & edad>=3) [iw=FACTOR_PCD], robust

eststo m1_`x'_A: quietly margins [iw=FACTOR_PCD], dydx(*) atmeans post

quietly logit pobre_k`x'_A indigena mujer rural edad edad2 l_visual_grave_completa l_comunicativa l_auditiva_grave_completa l_aprendizaje l_relacional l_enfermedad jefe vive_solo lima_callao mieperhog programa_social if (l_movilidad==1 & edad>=3) [iw=FACTOR_PCD], robust

eststo m2_`x'_A: quietly margins [iw=FACTOR_PCD], dydx(*) atmeans post

}

esttab m1_1_A m2_1_A m1_2_A m2_2_A m1_3_A m2_3_A m1_4_A m2_4_A m1_5_A m2_5_A, b(%9.7fc) se(%9.3fc)
esttab m1_6_A m2_6_A m1_7_A m2_7_A m1_8_A m2_8_A m1_9_A m2_9_A, b(%9.7fc) se(%9.3fc)


****Tabla 11.A 
foreach x of numlist 1/7{

logit pobre_k`x'_B indigena mujer rural edad l_visual_grave_completa l_comunicativa l_auditiva_grave_completa l_aprendizaje l_relacional l_enfermedad jefe vive_solo lima_callao mieperhog if (l_movilidad==1 & edad>17 & edad<65) [iw=FACTOR_PCD], robust

margins [iw=FACTOR_PCD], dydx(*) atmeans post

estimates store m1_`x'_B

logit pobre_k`x'_B indigena mujer rural edad l_visual_grave_completa l_comunicativa l_auditiva_grave_completa l_aprendizaje l_relacional l_enfermedad jefe vive_solo lima_callao mieperhog programa_social if (l_movilidad==1 & edad>17 & edad<65) [iw=FACTOR_PCD], robust

margins [iw=FACTOR_PCD], dydx(*) atmeans post

estimates store m2_`x'_B
}

esttab m1_1_B m2_1_B m1_2_B m2_2_B m1_3_B m2_3_B m1_4_B m2_4_B m1_5_B m2_5_B m1_6_B m2_6_B m1_7_B m2_7_B, b(%9.7fc) se(%9.3fc)

