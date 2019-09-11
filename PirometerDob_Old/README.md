# PirometerDob.m
    [Signal,PowerW,PowerdBm]=Pirometer7(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,Temperature,Emissivity)

## Parámetros de entrada
Los párametros de entrada de esta función son los siguientes:
 - *Mean*: cuyos valores pueden ser 'On', 'Off'
    
> NOTE: This value represents a digital switch to choose between an approximated or exactcalculation of all integral expressions. The more accurate method uses the the symbolic toolbox of Matlab.
        
>Important Note: symbolic method (mean = off) takes more time than
 the approximated method and I could appreciate no significant difference between their errors.

 - *Losses*: cuyos valores pueden ser 'On', 'Off'
> NOTE:
 This value represent a logic switch to select if you want to take into account
 the insertion losses of all opto-electronics devices which take
 part in the experimental setup.

 - *PdMaterial*: 'InGaAs', 'InGaAsEx', 'Ge', 'Si', 'PbS', 'PbSe'
     
>NOTE:
 This parameter represents the material of your photodetector. This simulation can
 be run using different photodetectors although we always use InGaAs photodetectors.
 I codded this improvement because one upon a time we were studding the performance
 of the fiber-optic pyrometer using different photodetector responsivities.

 - *LambdaUpper*: 1700 (1550nm Channel) or 1379um (1310nm Channel)
 - *LambdaLower*: 1430 (1550nm Channel) or 0800um (1310nm Channel)
 > NOTE:
 These parameters represent the upper and lower wavelength limits of the
 wavelength band that you want to simulate, in microns. You must run
 this simulation programn as many times as number of channels you
 have. If you have two channels, as it's our case (1310 and 1550nm), you'll run the program two times.
 
 >Please, pay attention to the upper wavelength value of the 1550nm channel (1700nm) and the lower wavelength value of the 1310nm
 channel (800nm). Are these value familiar to you? These values
 corresponds to the upper and lower limits of a InGaAs
 photodetector. Why? It's easy, our fiber-optic filter works
 as a high-pass or low-pass filter, this behaviour depends on the filter output you choose.
 So, the wavelength range of the fiber-optic pyrometer is strongly limited by the
 wavelength limits of the photodetector responsivity, see the
 Characterization Responsivities sheet of my Excel document (Summary.xlsx)

 - *Diameter*: 62.5 +/-3 um (recommended tolerance)
> NOTE:
 This parameter represents the diameter of the optical fiber used to
 gather the radiation in microns. The tolerance represents the minimum and
 maximum fiber diameter. Practically, you ought to measure the fiber
 diameter and then you insert that value here. 

- *Distance*:  0.3 +/-0.075 mm (recommended tolerance)
 > NOTE:
 This value represents the distance between the fiber end and the
 hot surface in millimetres. You can also include the tolerance of
 your measurement.

 - *DistanceConnector*: 4 - 9.3 mm
 > NOTE:
 This value represents the distance between the fiber end and the
 photodetector surface in millimetres. This value is normally fixed by the
 mechanical structure of your photodetector. I recommend you to read
 your photodetector datasheet for more information.

 - *Length*: 0.5 m
 > NOTE:
 This value represents the length of the optical fiber in metres.

 - *Temperature*: 650ºC
 > NOTE:
 This value represents the temperature of the hot surface in Celsius
 degrees

 - *Emissivity*: 1 (NOTE: Blackbody emissivity is equal at 1)
 > NOTE:
 This value represents the emissivity of the hot surface measured by
 the optical fiber. This value is a dimensionless unit.

- *Dob*: diámetro de la superficie a medir. Introducir en micrometros.

## Funciones integradas en PirometerDob.m
A continuación, voy a explicar brevemente las funciones que se encuentran integradas en Pirometer7.m:

### FunctionAcceptanceAngle

    [SolidAngleArea,AceptanceAngle,SpotDiameter]=FunctionAcceptanceAngle(Mean,LambdaLower,LambdaUpper,Lambda,Diameter,Distance,Dob)

Esta función calcula el ángulo sólido (**SolidAngleArea**), el ángulo de aceptancia (**AcceptanceAngle**) y el diámetro del cono de aceptancia (**SpotDiameter**). La función calcula los índices de refracción del núcleo y la cubierta de la fibra a partir de los índices de Sellmeier, con estos calcula la apertura numérica de la fibra y con este dato el ángulo de aceptancia. A partir de estos se calculará el diámetro del cono de aceptancia. Después con la función “FunctionSpotDiameter” calculará el ángulo sólido.
Existe una diferencia en los cálculos dependiendo si estos se están realizando con los valores medios del rango espectral o con los valores exactos del mismo. Actualmente, y tal y como está planteada la función “FunctionSpotDiameter”, el correcto funcionamiento de esta función solo es posible para los valores medios del rango espectral y no para los valores exactos.

Los índices de Sellmeier utilizados se eencuentran en la carpeta _Data_.

### FunctionSpotDiameter
	[SolidAngleArea]=FunctionSpotDiameter(Dob,SpotDiameter,Distance,AceptanceAngle,Diameter)

Esta función se encuentra integrada en la función _“FunctionAcceptanceAngle”_. Se utiliza para calcular el ángulo sólido dependiendo de si el diámetro del objeto a medir es menor que el diámetro del cono de aceptancia. En caso de que se mayor, da igual el tamaño del objeto a medir se calcula siempre de la misma manera. 

### FunctionResponsivity

    [Responsivity,CouplingEfficience]=FunctionResponsivity(PdMaterial,Diameter,DistanceConnector,AceptanceAngle)

Esta función calcula la responsividad del fotodetector y la eficacia del acople entre este y la fibra por la que se trasmite la radiación recogida. Se recurre a la función _“FunctionCouplingEfficience”_ en el caso de que se esté trabajando con fotodetectores de PbSe y PbS. Para el resto de casos el output **CouplingEfficience** recibe el valor de la unidad. En caso de que se introduzca un material de los cuales no se tengan datos, el programa dará un mensaje de error.

Los datos de los materiales del fotodetector utilizados se encuentran en la carpeta _Data_.

### FunctionCouplingEfficience

    [CouplingEfficience]=FunctionCouplingEfficience(AceptanceAngle,Diameter,DistanceConnector)

Esta función solo se utiliza cuando se está trabajando con fotodetectores de PbSe y PbS. Se encuentra integrada en la función _“FunctionResponsivity"_. Calcula la eficacia del acople entre la fibra y el fotodetector. Recurre a función _“FunctionEfficiencyConectorization”_ para realizar los cálculos.

### FunctionEffiencyConectorization

    [PhotodiodeFffectiveArea,R2]=FunctionEfficiencyConectorization(Width,Height,Separation,AceptanceAngleMean,Diameter,DistanceConnector)

Esta función calcula el área efectiva de los fotodetectores de PbSe y PbS. Se encuentra integrada en la función _“FunctionCouplingEfficience”_.

### FunctionLosses

    [SystemLosses,SystemLossesdB]=FunctionLosses(Losses,PdMaterial,LambdaUpper,LambdaLower,Length)

Esta función calcula el valor de las perdidas que se dan en el pirómetro teniendo en cuenta tres aspectos: las pérdidas en los conectores FC/PC, las pérdidas por atenuación en la fibra y las pérdidas en el filtro WDM. El parámetro **Losses** determinará si los factores de perdidas de los aspectos anteriormente mencionados se tienen en cuenta o no.

### FunctionPlanck

    [Signal,Power]=FunctionPlanck(Responsivity,Emissivity,Temperature,SolidAngleArea,LambdaLower,LambdaUpper,PdMaterial)

Esta función calcula la potencia de salida de los fotodetectores y la corriente eléctrica que circula por los mismos. Utiliza la aproximación de Wein de la ecuación de Planck.

### FunctionPlanckLosses

    [Signal,PowerW,PowerdBm]=FunctionPlanckLosses(Power,Signal,SystemLosses,CouplingEfficience,PdMaterial,Mean)

Esta función calcula los valores de la potencia de salida de los fotodetectores y la corriente eléctrica que circula por los mismos teniendo en cuenta las pérdidas del sistema y la eficacia del acople entre la fibra y los fotodetectores.

## Simulaciones realizadas
Para la realización del trabajo de fin de grado se desarrollaron alguna funciones también incluidas en esta carpeta. Estas funciones son:

### IterationDobDist
    [T]=IterationDobDist(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dob,Distance,DistanceConnector,Length,Temperature,Emissivity)

Esta función calcula la potencia óptica medida por el fotodetector para un rango de diámetros objetivo, que se introduce como un vector. El resto de valores permanecen constantes.
Para obtener el vector de diámetros objetivos se puede recurrir a la función _"CalcDob"_ que se encuentra en la carpeta *Otras_funciones*.

### IterationDist
    [T]=IterationDist(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dob,Distance,DistanceConnector,Length,Temperature,Emissivity)

Esta función opera de forma similar a _"IterationDobDist"_ pero esta vez se calcula la potencia óptica para un vector **Distance**, que hace referencia a la distancia a la que se encuentra el pirómetro de la superficie. El resto de parámetros permanecen constantes, así como el diámetro de la superficie a medir también es fijo.
Para obtener un vector distancia cuay variación sea logaritmica se puede recurrir a la función _"CalcDistLog"_ que se encuentra en la carpeta *Otras_funciones*.


## Ejemplos de utilización

Se pueden encontrar archivos .mat con los que pueden realizar las simulaciones. Por ejemplo, si se quiere acceder a los datos del canal de 1310 nm deberá escribir en la _Command Window_ lo siguiente:

    load('Data_Test/DobData1310.mat');

Y, a continuación, puede ejecutar la función PirometerDob con el encabezado indicado al principio del documento.