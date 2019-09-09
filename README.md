# Códigos Simulaciones MATLAB

Este repositorio contiene todos los códigos desarrollados en MATLAB utilizados para realizar las simulaciones necesarias para el desarrollo de mi Trabajo de Fin de Grado. 

## Estructura Repositorio
 
Este repositorio tiene la siguiente estructura:

- **Piromenter6**: código desarrollado por Alberto Tapetado para la realización de su tesis doctoral y en el que se basan el resto de códigos desarrollados.

- **Pirometer7**: código para la simulación del funcionamiento de un pirómetro dos colores en programación modular. Se incluyen algunas funciones utilizadas para simular algunas casuísticas.
	
- **PirometerDob_Old**: modificación de los códigos de Pirometer7 para adaptarlos al caso en el que la medida realizada depende del tamaño del objeto a medir. Se desarrollaron los códigos a partir de las funciones dadas por Alberto Tapetado. Se incluyen algunas funciones utilizadas para simular algunas casuósticas.

- **PirometerDob_New**: modificación de los códigos de Pirometer7 para adaptarlos al caso en el que la medida realizada depende del tamaóo del objeto a medir. Se desarrollaron los códigos a partir de las funciones enunciadas en mi trabajo de fin de grado. Se incluyen algunas funciones utilizadas para simular algunas casuósticas. 
	
- **Tolerancias**: modificación de los códigos de PirometerDob_New para realiazar un estudio de tolerancias del sistema. En este caso, solo se ha realizado el estudio para la configuración detallada en la tesis de Alberto Tapetado y la configuración inicial de mi trabajo de fin de grado.

- **Otras_funciones**: funciones desarrolladas para facilitar las simulaciones desarrolladas.

En todas las carpetas se incluye un README.md y dos carpetas denominadas *Data* y *Data_Test*, a excepción de la carpeta *Pirometer6* y *Otras_funciones* (en esta óltima solo se incluye un README.md). En *Data* se encuentran los .mat necesarios para el correcto funcionamiento de cada uno de los códigos desarrollados, es igual en todas las carpetas. En *Data_Test* se encuentran los .mat bóssicos utilizados para realizar las pruebas.